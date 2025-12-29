#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Скрипт для получения DDL схемы PostgreSQL через SSH туннель
"""

import subprocess
import sys
import os

DB_HOST = "159.223.0.234"
SSH_USER = "root"  # Укажите пользователя SSH
REMOTE_SCRIPT = "/tmp/get_schema_ddl.py"
LOCAL_SCRIPT = "get_schema_ddl.py"
OUTPUT_FILE = "../db_schema_dll/sozd_schema_ddl.sql"

print(f"Копирование скрипта на сервер {DB_HOST}...")

# Копируем скрипт на сервер
scp_cmd = f'scp "{LOCAL_SCRIPT}" {SSH_USER}@{DB_HOST}:{REMOTE_SCRIPT}'
result = subprocess.run(scp_cmd, shell=True, capture_output=True, text=True)

if result.returncode != 0:
    print(f"[ERROR] Ошибка копирования: {result.stderr}")
    print(f"\nУстановите SSH ключ или используйте пароль SSH")
    sys.exit(1)

print(f"Запуск скрипта на сервере...")

# Запускаем скрипт на сервере
ssh_cmd = f'ssh {SSH_USER}@{DB_HOST} "python3 {REMOTE_SCRIPT} Jenya!980"'
result = subprocess.run(ssh_cmd, shell=True, capture_output=True, text=True)

if result.returncode != 0:
    print(f"[ERROR] Ошибка выполнения: {result.stderr}")
    sys.exit(1)

print(result.stdout)

# Скачиваем результат
print(f"\nСкачивание результата...")
scp_cmd = f'scp {SSH_USER}@{DB_HOST}:sozd_schema_ddl.sql "{OUTPUT_FILE}"'
result = subprocess.run(scp_cmd, shell=True, capture_output=True, text=True)

if result.returncode != 0:
    print(f"[ERROR] Ошибка скачивания: {result.stderr}")
    sys.exit(1)

print(f"[OK] DDL схемы сохранён в файл: {OUTPUT_FILE}")
