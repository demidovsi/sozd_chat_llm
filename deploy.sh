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
echo "1. Сборка Docker образа..."
docker build -t ${IMAGE_TAG} .

echo ""
echo "2. Отправка образа в GCR..."
docker push ${IMAGE_TAG}

echo ""
echo "3. Развертывание на Cloud Run..."
gcloud run deploy ${IMAGE_NAME} \
  --image ${IMAGE_TAG} \
  --platform managed \
  --region ${REGION} \
  --allow-unauthenticated \
  --port ${PORT}

echo ""
echo "========================================="
echo "Развертывание завершено!"
echo "========================================="
