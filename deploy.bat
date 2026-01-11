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
    echo GCS credentials file found
    REM Кодируем JSON в base64 чтобы избежать проблем с спецсимволами
    for /f "delims=" %%i in ('powershell -Command "[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Content gcs_credentials.json -Raw)))"') do set GCS_CREDS_B64=%%i
    echo GCS credentials encoded to base64
) else (
    echo WARNING: gcs_credentials.json not found, service may not work!
    goto error
)

echo.
echo 4. Загрузка ADMIN_TOKEN из .env...
if exist .env (
    REM Извлекаем ADMIN_TOKEN из .env файла
    for /f "tokens=2 delims==" %%i in ('findstr "^ADMIN_TOKEN=" .env') do set ADMIN_TOKEN=%%i
    if not defined ADMIN_TOKEN (
        echo WARNING: ADMIN_TOKEN not found in .env file!
        goto error
    )
    echo ADMIN_TOKEN loaded from .env
) else (
    echo WARNING: .env file not found!
    goto error
)

echo.
echo 5. Развертывание на Cloud Run...
gcloud run deploy %IMAGE_NAME% --image %IMAGE_TAG% --platform managed --region %REGION% --allow-unauthenticated --port %PORT% --set-env-vars="GCS_CREDENTIALS_B64=%GCS_CREDS_B64%,ADMIN_TOKEN=%ADMIN_TOKEN%"
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
