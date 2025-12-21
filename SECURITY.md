# Безопасность и Credentials

## GCS Credentials

Для доступа к Google Cloud Storage используются service account credentials.

### ⚠️ ВАЖНО: Защита credentials

**НЕ коммитьте файл `gcs_credentials.json` в Git!**

Файл уже добавлен в `.gitignore`, но убедитесь что вы:
1. Не добавили его в репозиторий до добавления в .gitignore
2. Если случайно закоммитили - удалите из истории Git

### Локальная разработка

1. Скопируйте файл с credentials в корень проекта как `gcs_credentials.json`
2. Приложение автоматически использует его для локальной разработки

### Production развертывание

При развертывании на Cloud Run credentials передаются через переменную окружения:

```bash
./deploy.sh
```

Скрипт автоматически:
1. Читает `gcs_credentials.json`
2. Передает содержимое как переменную окружения `GCS_CREDENTIALS`
3. Приложение использует credentials из переменной окружения

### Альтернативный способ (переменные окружения)

Можно использовать переменную окружения локально:

```bash
export GCS_CREDENTIALS='{"type":"service_account",...}'
python sozd_chat.py
```

### Проверка безопасности

Перед коммитом убедитесь:
```bash
git status
# Убедитесь что gcs_credentials.json не в списке измененных файлов
```

Проверьте .gitignore:
```bash
cat .gitignore | grep gcs_credentials
# Должно вывести: gcs_credentials.json
```

### Что делать если credentials попали в репозиторий

1. Немедленно отзовите service account key в Google Cloud Console
2. Создайте новый service account key
3. Удалите credentials из истории Git:
```bash
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch gcs_credentials.json" \
  --prune-empty --tag-name-filter cat -- --all
```
4. Форсируйте push (ОСТОРОЖНО):
```bash
git push origin --force --all
```
