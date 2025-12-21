@echo off
REM Скрипт для развертывания на Google Cloud Run
REM Использование: deploy.bat [IMAGE_NAME] [REGION] [PORT]
REM Пример: deploy.bat sozd-chat-web europe-central2 8080

setlocal

set PROJECT_ID=playground-332710
if "%~1"=="" (set IMAGE_NAME=sozd-chat-web) else (set IMAGE_NAME=%~1)
if "%~2"=="" (set REGION=europe-central2) else (set REGION=%~2)
if "%~3"=="" (set PORT=8080) else (set PORT=%~3)
set IMAGE_TAG=gcr.io/%PROJECT_ID%/%IMAGE_NAME%:latest

echo =========================================
echo Развертывание %IMAGE_NAME%
echo Регион: %REGION%
echo Порт: %PORT%
echo =========================================

echo.
echo WARNING: Не забудьте обновить CHANGELOG.md перед деплоем!
echo          Добавьте запись о новых изменениях в файл CHANGELOG.md
echo.
set /p CHANGELOG_UPDATED="CHANGELOG.md обновлен? (y/n): "
if /i not "%CHANGELOG_UPDATED%"=="y" (
    echo Развертывание отменено. Обновите CHANGELOG.md и повторите попытку.
    exit /b 1
)

echo.
echo 1. Сборка Docker образа...
docker build -t %IMAGE_TAG% .
if errorlevel 1 goto error

echo.
echo 2. Отправка образа в GCR...
docker push %IMAGE_TAG%
if errorlevel 1 goto error

echo.
echo 3. Загрузка GCS credentials...
if exist gcs_credentials.json (
    set /p GCS_CREDS=<gcs_credentials.json
    echo GCS credentials loaded from file
) else (
    echo WARNING: gcs_credentials.json not found, service may not work!
)

echo.
echo 4. Развертывание на Cloud Run...
gcloud run deploy %IMAGE_NAME% --image %IMAGE_TAG% --platform managed --region %REGION% --allow-unauthenticated --port %PORT% --set-env-vars="GCS_CREDENTIALS=%GCS_CREDS%"
if errorlevel 1 goto error

echo.
echo =========================================
echo Развертывание завершено!
echo =========================================
goto end

:error
echo.
echo ОШИБКА: Развертывание не удалось!
exit /b 1

:end
endlocal
