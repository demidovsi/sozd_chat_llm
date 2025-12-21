import datetime
import json
import os
import logging

from flask import Flask, jsonify, send_file, request, make_response
from flask import render_template
from google.cloud import storage
from io import BytesIO
import py7zr
import tempfile

import config

# Настройка логирования для Cloud Run
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(20).hex()
app.permanent = False
app.permanent_session_lifetime = datetime.timedelta(hours=24)
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# CORS middleware для Cloud Run
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,POST,OPTIONS')
    return response


@app.route('/')
def index():
    return render_template('index.html')

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
        gcs_creds_json = os.environ.get('GCS_CREDENTIALS')
        if gcs_creds_json:
            health_status["gcs_credentials"] = "env_var"
            logger.info("GCS credentials found in environment variable")
        elif os.path.exists('gcs_credentials.json'):
            health_status["gcs_credentials"] = "file"
            logger.info("GCS credentials found in file")
        else:
            health_status["gcs_credentials"] = "missing"
            logger.warning("GCS credentials not found")
            return jsonify(health_status), 200

        # Проверка доступа к bucket
        try:
            if gcs_creds_json:
                with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as temp_file:
                    temp_file.write(gcs_creds_json)
                    temp_path = temp_file.name
                try:
                    storage_client = storage.Client.from_service_account_json(temp_path)
                finally:
                    os.unlink(temp_path)
            else:
                storage_client = storage.Client.from_service_account_json('gcs_credentials.json')

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
        logger.info(f"Download request for file: {filename}")

        if not filename:
            logger.error("Filename parameter is missing")
            return jsonify({"error": "Filename parameter is required"}), 400

        # Инициализация клиента GCS с service account
        gcs_creds_json = os.environ.get('GCS_CREDENTIALS')

        if gcs_creds_json:
            logger.info("Using GCS credentials from environment variable")
            with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as temp_file:
                temp_file.write(gcs_creds_json)
                temp_path = temp_file.name

            try:
                storage_client = storage.Client.from_service_account_json(temp_path)
            finally:
                os.unlink(temp_path)
        else:
            logger.info("Using GCS credentials from file")
            credentials_path = 'gcs_credentials.json'
            if not os.path.exists(credentials_path):
                logger.error("GCS credentials file not found")
                return jsonify({"error": "GCS credentials not found"}), 500
            storage_client = storage.Client.from_service_account_json(credentials_path)

        bucket_name = 'sozd-laws-file'
        bucket = storage_client.bucket(bucket_name)
        logger.info(f"Accessing bucket: {bucket_name}")

        # Filename уже содержит префикс с номером закона (например: 123456/document.pdf)
        # Попытка найти файл
        blob = bucket.blob(filename)
        is_7z = False

        if not blob.exists():
            logger.info(f"File {filename} not found, trying .7z version")
            # Если файл не найден, проверяем версию с .7z
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

                if not extracted_files:
                    logger.error("No files found in archive")
                    return jsonify({"error": "No files found in archive"}), 500

                # Берем первый файл
                extracted_file = os.path.join(temp_dir, extracted_files[0])
                logger.info(f"Extracted file: {extracted_files[0]}")

                # Читаем содержимое
                with open(extracted_file, 'rb') as f:
                    extracted_content = BytesIO(f.read())

                download_name = filename.split('/')[-1]
                logger.info(f"Sending extracted file: {download_name}")

                return send_file(
                    extracted_content,
                    as_attachment=True,
                    download_name=download_name,
                    mimetype='application/octet-stream'
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
    app.run(port=config.OWN_PORT, host=config.OWN_HOST)

