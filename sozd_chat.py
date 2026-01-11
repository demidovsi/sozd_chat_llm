import datetime
import json
import os
import logging
import base64
import requests

from flask import Flask, jsonify, send_file, request, redirect, url_for, session
from flask import render_template
from flask_login import LoginManager, login_required, current_user, login_user, logout_user
from google.cloud import storage
from io import BytesIO
import py7zr
import tempfile

import config
from models import Database, User
import auth_service
from auth_middleware import admin_required, schema_access_required

import mimetypes
# import magic

# Настройка логирования для Cloud Run
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def get_gcs_credentials_json():
    """
    Получает JSON credentials для GCS из переменных окружения или файла
    Поддерживает как прямой JSON (GCS_CREDENTIALS), так и base64 (GCS_CREDENTIALS_B64)
    """
    # Сначала пробуем base64 версию (новый метод)
    gcs_creds_b64 = os.environ.get('GCS_CREDENTIALS_B64')
    if gcs_creds_b64:
        try:
            decoded = base64.b64decode(gcs_creds_b64).decode('utf-8')
            logger.info("Using GCS credentials from GCS_CREDENTIALS_B64 (base64)")
            return decoded
        except Exception as e:
            logger.error(f"Failed to decode GCS_CREDENTIALS_B64: {e}")

    # Fallback на прямой JSON (старый метод)
    gcs_creds_json = os.environ.get('GCS_CREDENTIALS')
    if gcs_creds_json:
        logger.info("Using GCS credentials from GCS_CREDENTIALS (direct JSON)")
        return gcs_creds_json

    # Fallback на файл
    credentials_path = 'gcs_credentials.json'
    if os.path.exists(credentials_path):
        logger.info("Using GCS credentials from file")
        with open(credentials_path, 'r') as f:
            return f.read()

    return None

app = Flask(__name__)
app.config['SECRET_KEY'] = config.SECRET_KEY
app.permanent = False
app.permanent_session_lifetime = datetime.timedelta(hours=24)
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Initialize Flask-Login
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login_page'


def determine_mimetype(filename, file_content=None):
    """Определяет MIME-type комбинированным методом"""
    # Сначала пробуем по расширению
    mimetype, _ = mimetypes.guess_type(filename)

    # Если не удалось определить по расширению и есть содержимое файла
    # if not mimetype and file_content:
    #     try:
    #         mime = magic.Magic(mime=True)
    #         mimetype = mime.from_buffer(file_content)
    #     except:
    #         pass

    # Fallback
    return mimetype or 'application/octet-stream'


@login_manager.user_loader
def load_user(user_id):
    """Load user by ID for Flask-Login"""
    db = Database()
    user_dict = db.fetchone("SELECT * FROM users WHERE id = ?", (int(user_id),))
    return User(user_dict) if user_dict else None

# Initialize database
db = Database()
db.init_db()

# CORS middleware для Cloud Run
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,POST,OPTIONS')
    return response


@app.route('/')
@login_required
def index():
    return render_template('index.html')

@app.route('/login')
def login_page():
    """Login page"""
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    return render_template('login.html')

# ===== AUTH API ENDPOINTS =====

@app.route('/api/auth/login', methods=['POST'])
def api_login():
    """Login API endpoint"""
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    remember = data.get('remember', False)

    if not username or not password:
        return jsonify({'success': False, 'message': 'Username and password required'}), 400

    user = auth_service.authenticate_user(username, password)

    if user:
        login_user(user, remember=remember)
        auth_service.log_activity(user.id, 'login', f'Logged in as {username}', request.remote_addr, request.user_agent.string)

        return jsonify({
            'success': True,
            'user': user.to_dict(include_schemas=True)
        })
    else:
        auth_service.log_activity(None, 'login_failed', f'Failed login attempt for {username}', request.remote_addr, request.user_agent.string)
        return jsonify({'success': False, 'message': 'Invalid credentials'}), 401

@app.route('/api/auth/logout', methods=['POST'])
@login_required
def api_logout():
    """Logout API endpoint"""
    user_id = current_user.id
    username = current_user.username
    auth_service.log_activity(user_id, 'logout', f'Logged out: {username}', request.remote_addr, request.user_agent.string)
    logout_user()
    return jsonify({'success': True})

@app.route('/api/auth/me', methods=['GET'])
@login_required
def api_me():
    """Get current user info"""
    return jsonify({
        'success': True,
        'user': current_user.to_dict(include_schemas=True)
    })

@app.route('/api/schemas', methods=['GET'])
@login_required
def api_schemas():
    """Get available schemas for current user"""
    # Маппинг schema value -> label
    SCHEMA_LABELS = {
        'sozd': 'СОЗД',
        'lib': 'Гаазе',
        'family': 'Семья',
        'urban': 'Игра',
        'eco': 'ГЕО-ЭКО',
        'gen': 'ЕВГЕНИЯ',
        'ohi': 'Наш дом Израиль'
    }

    schema_names = auth_service.get_user_schemas(current_user.id)
    schemas_with_labels = [
        {'value': name, 'label': SCHEMA_LABELS.get(name, name)}
        for name in schema_names
    ]

    return jsonify({
        'success': True,
        'schemas': schemas_with_labels
    })

# ===== ADMIN API ENDPOINTS =====

@app.route('/api/admin/users', methods=['GET'])
@login_required
@admin_required
def api_admin_users():
    """Get all users (admin only)"""
    users = auth_service.get_all_users()
    return jsonify({
        'success': True,
        'users': [user.to_dict(include_schemas=True) for user in users]
    })

@app.route('/api/admin/users', methods=['POST'])
@login_required
@admin_required
def api_admin_create_user():
    """Create new user (admin only)"""
    data = request.get_json()
    result = auth_service.create_user(
        username=data.get('username'),
        email=data.get('email'),
        password=data.get('password'),
        is_admin=data.get('is_admin', False),
        is_active=data.get('is_active', True),
        schemas=data.get('schemas', [])
    )

    if result['success']:
        auth_service.log_activity(
            current_user.id,
            'admin_create_user',
            f'Created user: {data.get("username")}',
            request.remote_addr,
            request.user_agent.string
        )

    return jsonify(result)

@app.route('/api/admin/users/<int:user_id>', methods=['PUT'])
@login_required
@admin_required
def api_admin_update_user(user_id):
    """Update user (admin only)"""
    data = request.get_json()
    result = auth_service.update_user(
        user_id=user_id,
        username=data.get('username'),
        email=data.get('email'),
        is_admin=data.get('is_admin'),
        is_active=data.get('is_active'),
        schemas=data.get('schemas')
    )

    if result['success']:
        auth_service.log_activity(
            current_user.id,
            'admin_update_user',
            f'Updated user ID: {user_id}',
            request.remote_addr,
            request.user_agent.string
        )

    return jsonify(result)

@app.route('/api/admin/users/<int:user_id>', methods=['DELETE'])
@login_required
@admin_required
def api_admin_delete_user(user_id):
    """Delete user (admin only)"""
    if user_id == current_user.id:
        return jsonify({'success': False, 'message': 'Cannot delete yourself'}), 400

    result = auth_service.delete_user(user_id)

    if result['success']:
        auth_service.log_activity(
            current_user.id,
            'admin_delete_user',
            f'Deleted user ID: {user_id}',
            request.remote_addr,
            request.user_agent.string
        )

    return jsonify(result)

@app.route('/api/admin/users/<int:user_id>/reset-password', methods=['POST'])
@login_required
@admin_required
def api_admin_reset_password(user_id):
    """Reset user password (admin only)"""
    data = request.get_json()
    new_password = data.get('new_password')

    if not new_password or len(new_password) < 6:
        return jsonify({'success': False, 'message': 'Password must be at least 6 characters'}), 400

    result = auth_service.reset_user_password(user_id, new_password)

    if result['success']:
        auth_service.log_activity(
            current_user.id,
            'admin_reset_password',
            f'Reset password for user ID: {user_id}',
            request.remote_addr,
            request.user_agent.string
        )

    return jsonify(result)

@app.route('/api/admin/activity', methods=['GET'])
@login_required
@admin_required
def api_admin_activity():
    """Get activity logs (admin only)"""
    user_id = request.args.get('user_id', type=int)
    limit = request.args.get('limit', 100, type=int)

    logs = auth_service.get_activity_logs(user_id=user_id, limit=limit)

    return jsonify({
        'success': True,
        'logs': logs
    })

@app.route('/api/log-chat', methods=['POST'])
@login_required
def log_chat():
    """
    Логирование запроса к чат-ассистенту в таблицу chat_logs
    Получает данные от фронтенда, определяет IP и геолокацию,
    сохраняет запись через v2/execute endpoint
    """
    try:
        data = request.get_json()

        # Получаем параметры из запроса
        message = data.get('message', '')
        answer = data.get('answer')  # JSON объект
        type_message = data.get('type_message', 'sql')
        schema = data.get('schema', 'sozd')
        duration_ms = data.get('duration_ms')  # Время выполнения в миллисекундах

        # Преобразуем миллисекунды в секунды (float)
        td = float(duration_ms) / 1000.0 if duration_ms is not None else None

        # Получаем email текущего пользователя
        user_email = current_user.email if current_user and hasattr(current_user, 'email') else None

        # Получаем IP адрес клиента (с учетом прокси)
        x_forwarded_for = request.environ.get('HTTP_X_FORWARDED_FOR')
        logger.info(f"HTTP_X_FORWARDED_FOR: {x_forwarded_for}, remote_addr: {request.remote_addr}")

        if x_forwarded_for is None:
            client_ip = request.remote_addr
        else:
            # X-Forwarded-For может содержать несколько IP через запятую, берем первый (клиента)
            client_ip = x_forwarded_for.split(',')[0].strip()

        # Получаем геолокацию через ip-api.com
        country = None
        city = None

        try:
            geo_response = requests.get(f'http://ip-api.com/json/{client_ip}', timeout=5)
            if geo_response.status_code == 200:
                geo_data = geo_response.json()
                if geo_data.get('status') == 'success':
                    country = geo_data.get('country')
                    city = geo_data.get('city')
                    logger.info(f"Geolocation for {client_ip}: {country}, {city}")
                else:
                    logger.warning(f"Geolocation API returned status: {geo_data.get('status')}")
        except Exception as geo_err:
            logger.warning(f"Failed to get geolocation for {client_ip}: {geo_err}")

        # Текущее время в UTC+0
        current_time = datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

        # Формируем SQL INSERT запрос
        # answer сохраняется как JSON
        answer_json = json.dumps(answer, ensure_ascii=False) if answer is not None else 'null'

        # Экранируем одинарные кавычки для SQL
        message_escaped = message.replace("'", "''") if message else ''
        country_escaped = country.replace("'", "''") if country else None
        city_escaped = city.replace("'", "''") if city else None
        email_escaped = user_email.replace("'", "''") if user_email else None
        # ВАЖНО: экранируем одинарные кавычки в JSON для безопасной вставки в SQL
        answer_json_escaped = answer_json.replace("'", "''") if answer_json != 'null' else answer_json

        # Формируем INSERT запрос с использованием dollar-quoted string для JSON
        insert_sql = f"""
INSERT INTO {schema}.chat_logs (at_date_time, ip, country, city, type_message, message, answer, td, email)
VALUES (
    '{current_time}',
    '{client_ip}',
    {'NULL' if country_escaped is None else f"'{country_escaped}'"},
    {'NULL' if city_escaped is None else f"'{city_escaped}'"},
    '{type_message}',
    '{message_escaped}',
    '{answer_json_escaped}'::json,
    {td if td is not None else 'NULL'},
    {'NULL' if email_escaped is None else f"'{email_escaped}'"}
)
"""

        logger.info(f"Logging chat message to {schema}.chat_logs: type={type_message}, ip={client_ip}")

        # Отправляем INSERT запрос через v2/execute
        # Используем config.URL для endpoint v2/execute
        execute_url = os.environ.get('URL') or 'https://sergey-demidov.ru:5001/'
        if not execute_url.endswith('/'):
            execute_url += '/'
        execute_url += 'v2/execute?need_answer=0'

        # Получаем токен из переменной окружения
        encoded_token = os.environ.get('ADMIN_TOKEN')
        if not encoded_token:
            logger.error("ADMIN_TOKEN environment variable not set")
            return jsonify({'success': False, 'message': 'ADMIN_TOKEN not configured'}), 500

        execute_payload = {
            "params": {
                "script": insert_sql,
                "datas": None
            },
            "token": encoded_token
        }

        execute_response = requests.put(
            execute_url,
            json=execute_payload,
            timeout=10
        )

        if execute_response.status_code == 200:
            logger.info(f"Chat log saved successfully to {schema}.chat_logs")
            return jsonify({'success': True, 'message': 'Chat log saved'})
        else:
            logger.error(f"Failed to save chat log: {execute_response.status_code} - {execute_response.text}")
            return jsonify({
                'success': False,
                'message': f'Failed to save chat log: {execute_response.status_code}'
            }), 500

    except Exception as e:
        logger.error(f"Error in log_chat: {str(e)}", exc_info=True)
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/api/version')
def get_version():
    try:
        with open('version.json', 'r', encoding='utf-8') as f:
            version_data = json.load(f)
        return jsonify(version_data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/health')
def health_check():
    """Проверка состояния приложения и доступа к GCS"""
    try:
        health_status = {
            "status": "healthy",
            "gcs_credentials": "not_configured",
            "bucket_access": "not_tested"
        }

        # Проверка наличия GCS credentials
        gcs_creds_json = get_gcs_credentials_json()
        if gcs_creds_json:
            if os.environ.get('GCS_CREDENTIALS_B64'):
                health_status["gcs_credentials"] = "env_var_base64"
            elif os.environ.get('GCS_CREDENTIALS'):
                health_status["gcs_credentials"] = "env_var"
            else:
                health_status["gcs_credentials"] = "file"
        else:
            health_status["gcs_credentials"] = "missing"
            logger.warning("GCS credentials not found")
            return jsonify(health_status), 200

        # Проверка доступа к bucket
        try:
            with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as temp_file:
                temp_file.write(gcs_creds_json)
                temp_path = temp_file.name
            try:
                storage_client = storage.Client.from_service_account_json(temp_path)
            finally:
                os.unlink(temp_path)

            bucket = storage_client.bucket('sozd-laws-file')
            if bucket.exists():
                health_status["bucket_access"] = "ok"
                logger.info("Successfully accessed GCS bucket")
            else:
                health_status["bucket_access"] = "bucket_not_found"
                logger.warning("GCS bucket not found")
        except Exception as e:
            health_status["bucket_access"] = f"error: {str(e)}"
            logger.error(f"Error accessing GCS bucket: {str(e)}")

        return jsonify(health_status), 200
    except Exception as e:
        logger.error(f"Error in health check: {str(e)}", exc_info=True)
        return jsonify({"status": "error", "error": str(e)}), 500

@app.route('/api/download')
def download_file():
    """Скачивание файла из Google Cloud Storage с поддержкой .7z архивов"""
    try:
        filename = request.args.get('filename')
        bucket_name = request.args.get('bucket_name', 'sozd-laws-file')
        logger.info(f"Download request for file: {filename} bucket: {bucket_name}")

        if not filename:
            logger.error("Filename parameter is missing")
            return jsonify({"error": "Filename parameter is required"}), 400

        # Сохраняем исходное имя файла для правильного определения download_name
        original_filename = filename

        # Инициализация клиента GCS с service account
        gcs_creds_json = get_gcs_credentials_json()

        if not gcs_creds_json:
            logger.error("GCS credentials not found")
            return jsonify({"error": "GCS credentials not found"}), 500

        with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as temp_file:
            temp_file.write(gcs_creds_json)
            temp_path = temp_file.name

        try:
            storage_client = storage.Client.from_service_account_json(temp_path)
        finally:
            os.unlink(temp_path)

        bucket = storage_client.bucket(bucket_name)
        logger.info(f"Accessing bucket: {bucket_name}")

        # Filename уже содержит префикс с номером закона (например: 123456/document.pdf)
        # Попытка найти файл
        blob = bucket.blob(filename)
        is_7z = False

        if not blob.exists():
            logger.info(f"File {filename} not found, trying .7z version")
            # Если файл не найден, проверяем версию с .7z.
            # Заменяем расширение на .7z (например: document.pdf -> document.7z)
            if '.' in filename:
                base_name = filename.rsplit('.', 1)[0]
                filename_7z = f"{base_name}.7z"
            else:
                filename_7z = f"{filename}.7z"
            blob_7z = bucket.blob(filename_7z)

            if blob_7z.exists():
                logger.info(f"Found .7z version: {filename_7z}")
                blob = blob_7z
                is_7z = True
            else:
                logger.error(f"File not found: {filename} and {filename_7z}")
                return jsonify({"error": f"File not found: {filename}"}), 404
        else:
            logger.info(f"File found: {filename}")
            if filename.lower().endswith('.7z'):
                is_7z = True

        # Загрузка содержимого файла
        logger.info(f"Downloading file from GCS, size: {blob.size} bytes")
        file_content = BytesIO()
        blob.download_to_file(file_content)
        file_content.seek(0)
        logger.info("File downloaded successfully")

        # Если это .7z архив - разархивируем
        if is_7z:
            logger.info("Extracting .7z archive")
            # Создаем временную директорию для разархивирования
            with tempfile.TemporaryDirectory() as temp_dir:
                archive_path = os.path.join(temp_dir, 'archive.7z')

                # Сохраняем архив во временный файл
                with open(archive_path, 'wb') as f:
                    f.write(file_content.getvalue())

                # Разархивируем
                with py7zr.SevenZipFile(archive_path, mode='r') as archive:
                    archive.extractall(path=temp_dir)

                # Ищем разархивированный файл (должен быть один файл с оригинальным именем)
                extracted_files = [f for f in os.listdir(temp_dir) if f != 'archive.7z']
                logger.info(f"Extracted files in archive: {extracted_files}")

                if not extracted_files:
                    logger.error("No files found in archive")
                    return jsonify({"error": "No files found in archive"}), 500

                # Берем первый файл
                extracted_file = os.path.join(temp_dir, extracted_files[0])

                # Проверяем, что это файл, а не директория
                if os.path.isdir(extracted_file):
                    logger.error(f"Extracted item is a directory: {extracted_files[0]}")
                    # Ищем файлы внутри директории
                    files_in_dir = []
                    for root, dirs, files in os.walk(temp_dir):
                        for file in files:
                            if file != 'archive.7z':
                                files_in_dir.append(os.path.join(root, file))

                    if not files_in_dir:
                        logger.error("No files found in archive subdirectories")
                        return jsonify({"error": "No files found in archive"}), 500

                    extracted_file = files_in_dir[0]
                    logger.info(f"Using file from subdirectory: {extracted_file}")

                logger.info(f"Extracted file path: {extracted_file}")

                # Читаем содержимое
                with open(extracted_file, 'rb') as f:
                    extracted_content = BytesIO(f.read())

                # Определяем правильное имя для скачивания
                extracted_filename = os.path.basename(extracted_file)

                if original_filename.lower().endswith('.7z'):
                    # Если запрашивался .7z файл, используем РЕАЛЬНОЕ имя из архива
                    download_name = extracted_filename
                    logger.info(f"Original: {original_filename}, Extracted: {extracted_filename}, Using: {download_name}")
                else:
                    # Если запрашивался обычный файл (которого не было), используем исходное имя
                    download_name = original_filename.split('/')[-1]
                    logger.info(f"Original: {original_filename} (non-archive), Using: {download_name}")

                logger.info(f"Sending extracted file with name: {download_name}")

                mimetype = determine_mimetype(download_name, extracted_content.getvalue())

                return send_file(
                    extracted_content,
                    as_attachment=True,
                    download_name=download_name,
                    mimetype=mimetype
                )
        else:
            # Обычный файл - отправляем как есть
            download_name = filename.split('/')[-1]
            logger.info(f"Sending file: {download_name}, mimetype: {blob.content_type}")

            return send_file(
                file_content,
                as_attachment=True,
                download_name=download_name,
                mimetype=blob.content_type or 'application/octet-stream'
            )

    except Exception as e:
        logger.error(f"Error in download_file: {str(e)}", exc_info=True)
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    # use_reloader=False отключает Flask reloader для совместимости с отладчиком PyCharm
    # PyCharm использует свой собственный отладчик
    app.run(port=config.OWN_PORT, host=config.OWN_HOST, debug=True, use_reloader=False)
