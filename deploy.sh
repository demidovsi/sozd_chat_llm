#!/bin/bash

# Скрипт для развертывания на Google Cloud Run
# Использование: ./deploy.sh [IMAGE_NAME] [REGION] [PORT]
# Пример: ./deploy.sh sozd-chat-web europe-central2 8080

set -e  # Остановка при ошибке

# Функция для восстановления config.js при выходе (даже при ошибке)
cleanup() {
  if [ -f "static/js/modules/config.js.backup" ]; then
    echo ""
    echo "Восстановление оригинального config.js..."
    mv static/js/modules/config.js.backup static/js/modules/config.js
    echo "✅ config.js восстановлен"
  fi
}

# Регистрируем функцию очистки при выходе
trap cleanup EXIT

PROJECT_ID="playground-332710"
IMAGE_NAME="${1:-sozd-chat-web}"  # Первый аргумент или значение по умолчанию
REGION="${2:-europe-central2}"     # Второй аргумент или значение по умолчанию
PORT="${3:-8080}"                  # Третий аргумент или значение по умолчанию

IMAGE_TAG="gcr.io/${PROJECT_ID}/${IMAGE_NAME}:latest"

echo "========================================="
echo "Развертывание ${IMAGE_NAME}"
echo "Регион: ${REGION}"
echo "Порт: ${PORT}"
echo "========================================="

echo ""
echo "⚠️  НАПОМИНАНИЕ: Не забудьте обновить CHANGELOG.md перед деплоем!"
echo "   Добавьте запись о новых изменениях в файл CHANGELOG.md"
echo ""
read -p "CHANGELOG.md обновлен? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Развертывание отменено. Обновите CHANGELOG.md и повторите попытку."
  exit 1
fi

echo ""
echo "Проверка и замена URL в config.js..."

# Проверяем наличие локальных URL (127.0.0.1 или localhost)
if grep -q "127\.0\.0\.1\|localhost" static/js/modules/config.js; then
  echo "⚠️  Обнаружены локальные URL (127.0.0.1 или localhost)"
  echo "   Заменяем на продакшн URL (sergey-demidov.ru)..."

  # Создаем резервную копию
  cp static/js/modules/config.js static/js/modules/config.js.backup

  # Заменяем все вхождения 127.0.0.1 и localhost на sergey-demidov.ru
  # Используем разные подходы в зависимости от ОС
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash)
    sed -i "s|https\?://127\.0\.0\.1|https://sergey-demidov.ru|g" static/js/modules/config.js
    sed -i "s|https\?://localhost|https://sergey-demidov.ru|g" static/js/modules/config.js
  else
    # Linux/Mac
    sed -i 's|https\?://127\.0\.0\.1|https://sergey-demidov.ru|g' static/js/modules/config.js
    sed -i 's|https\?://localhost|https://sergey-demidov.ru|g' static/js/modules/config.js
  fi

  echo "✅ URL заменены на продакшн версии"

  # Показываем что изменилось
  echo "Изменённые строки:"
  grep -n "sergey-demidov.ru" static/js/modules/config.js | head -5
else
  echo "✅ Локальные URL не обнаружены"
fi

# Проверяем корректность основных URL
EXPECTED_URL_REST="https://sergey-demidov.ru:5051/"
CURRENT_URL_REST=$(grep -oP 'URL_rest:\s*"\K[^"]+' static/js/modules/config.js || echo "")

if [ "$CURRENT_URL_REST" != "$EXPECTED_URL_REST" ]; then
  echo "❌ ОШИБКА: URL_rest имеет неверное значение!"
  echo "   Текущее значение: $CURRENT_URL_REST"
  echo "   Ожидаемое значение: $EXPECTED_URL_REST"
  echo ""
  echo "Исправьте URL_rest в static/js/modules/config.js и повторите попытку."
  exit 1
fi
echo "✅ URL_rest корректен: $CURRENT_URL_REST"

# Дополнительная проверка на наличие оставшихся локальных URL
if grep -q "127\.0\.0\.1\|localhost" static/js/modules/config.js; then
  echo "❌ ОШИБКА: В config.js остались локальные URL!"
  echo "Не удалось заменить все вхождения 127.0.0.1 или localhost"
  grep -n "127\.0\.0\.1\|localhost" static/js/modules/config.js
  exit 1
fi

echo ""
echo "1. Сборка Docker образа..."
docker build -t ${IMAGE_TAG} .

echo ""
echo "2. Отправка образа в GCR..."
docker push ${IMAGE_TAG}

echo ""
echo "3. Кодирование GCS credentials в base64..."
if [ -f "gcs_credentials.json" ]; then
  GCS_CREDS_B64=$(base64 -w 0 < gcs_credentials.json)
  echo "GCS credentials encoded to base64"
else
  echo "WARNING: gcs_credentials.json not found, service may not work!"
  exit 1
fi

echo ""
echo "4. Развертывание на Cloud Run..."
gcloud run deploy ${IMAGE_NAME} \
  --image ${IMAGE_TAG} \
  --platform managed \
  --region ${REGION} \
  --allow-unauthenticated \
  --port ${PORT} \
  --set-env-vars="GCS_CREDENTIALS_B64=${GCS_CREDS_B64}"

echo ""
echo "========================================="
echo "Развертывание завершено!"
echo "========================================="
