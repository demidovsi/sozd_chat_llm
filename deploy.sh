#!/bin/bash

# Скрипт для развертывания на Google Cloud Run
# Использование: ./deploy.sh [IMAGE_NAME] [REGION] [PORT]
# Пример: ./deploy.sh sozd-chat-web europe-central2 8080

set -e  # Остановка при ошибке

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
