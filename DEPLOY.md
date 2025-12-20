# Развертывание на Google Cloud Run

## Быстрый старт

### Для текущего проекта (sozd-chat-web)

```bash
# Linux/macOS/Git Bash:
./deploy.sh

# Windows CMD:
deploy.bat
```

### Для других проектов

```bash
# Linux/macOS/Git Bash:
./deploy.sh IMAGE_NAME [REGION] [PORT]

# Windows CMD:
deploy.bat IMAGE_NAME [REGION] [PORT]
```

## Примеры использования

### Развертывание другого проекта

```bash
# Развертывание archive-web на тот же регион
./deploy.sh archive-web

# Развертывание gen-web на другой регион
./deploy.sh gen-web us-central1

# Развертывание с нестандартным портом
./deploy.sh family-web europe-central2 3000
```

## Параметры

| Параметр | Описание | Значение по умолчанию |
|----------|----------|----------------------|
| IMAGE_NAME | Имя Docker образа и Cloud Run сервиса | `sozd-chat-web` |
| REGION | Регион Google Cloud | `europe-central2` |
| PORT | Порт приложения | `8080` |

## Что делает скрипт

1. **Docker Build** - собирает Docker образ из текущей директории
2. **Docker Push** - отправляет образ в Google Container Registry
3. **GCloud Deploy** - развертывает на Cloud Run с параметрами:
   - Platform: managed
   - Allow unauthenticated: yes
   - Указанный регион и порт

## Требования

- Docker установлен и запущен
- Google Cloud SDK (gcloud) установлен и настроен
- Проект GCP: `playground-332710`
- Dockerfile в текущей директории

## Регионы

Доступные регионы Google Cloud Run:
- `europe-central2` (Warsaw) - по умолчанию
- `us-central1` (Iowa)
- `europe-west1` (Belgium)
- `asia-northeast1` (Tokyo)
- И другие...
