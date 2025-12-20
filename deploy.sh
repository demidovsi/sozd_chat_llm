#!/bin/bash

# Скрипт для развертывания sozd-chat-web на Google Cloud Run

set -e  # Остановка при ошибке

PROJECT_ID="playground-332710"
IMAGE_NAME="sozd-chat-web"
REGION="europe-central2"
PORT="8080"

IMAGE_TAG="gcr.io/${PROJECT_ID}/${IMAGE_NAME}:latest"

echo "========================================="
echo "Развертывание ${IMAGE_NAME}"
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
