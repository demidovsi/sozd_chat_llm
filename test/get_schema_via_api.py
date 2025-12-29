#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Получение DDL схемы через REST API
"""

import requests
import json

API_URL = "https://159.223.0.234:5001/v2/execute"
SCHEMA_NAME = "sozd"
OUTPUT_FILE = "../db_schema_dll/sozd_schema_ddl.sql"

def execute_sql(sql_query):
    """Выполнить SQL запрос через API"""
    response = requests.put(
        API_URL,
        headers={
            "Accept": "application/json",
            "Content-Type": "application/json"
        },
        json={
            "params": {
                "script": sql_query,
                "datas": None
            },
            "token": None
        },
        verify=False
    )

    if response.status_code != 200:
        raise Exception(f"API Error {response.status_code}: {response.text}")

    return response.json()

# SQL запрос для получения списка таблиц
tables_query = f"""
SELECT tablename
FROM pg_tables
WHERE schemaname = '{SCHEMA_NAME}'
ORDER BY tablename;
"""

print(f"Получение списка таблиц схемы '{SCHEMA_NAME}'...")

try:
    result = execute_sql(tables_query)
    tables = [row['tablename'] for row in result]

    print(f"Найдено таблиц: {len(tables)}")
    for table in tables:
        print(f"  - {table}")

    # Для каждой таблицы получаем CREATE TABLE
    ddl_statements = []
    ddl_statements.append(f"-- DDL схемы {SCHEMA_NAME}")
    ddl_statements.append(f"-- Сгенерировано через API")
    ddl_statements.append("")
    ddl_statements.append(f"CREATE SCHEMA IF NOT EXISTS {SCHEMA_NAME};")
    ddl_statements.append("")

    for table in tables:
        print(f"\nПолучение DDL для {table}...")

        # Запрос для получения определения таблицы
        ddl_query = f"""
        SELECT
            'CREATE TABLE {SCHEMA_NAME}.' || quote_ident('{table}') || ' (' ||
            string_agg(
                quote_ident(column_name) || ' ' ||
                data_type ||
                CASE
                    WHEN character_maximum_length IS NOT NULL
                    THEN '(' || character_maximum_length || ')'
                    WHEN numeric_precision IS NOT NULL AND numeric_scale IS NOT NULL
                    THEN '(' || numeric_precision || ',' || numeric_scale || ')'
                    ELSE ''
                END ||
                CASE WHEN is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END,
                ', '
                ORDER BY ordinal_position
            ) || ');' as create_table
        FROM information_schema.columns
        WHERE table_schema = '{SCHEMA_NAME}' AND table_name = '{table}';
        """

        result = execute_sql(ddl_query)
        if result and len(result) > 0:
            ddl_statements.append(f"\n-- Таблица: {SCHEMA_NAME}.{table}")
            ddl_statements.append(result[0]['create_table'])

    # Сохраняем в файл
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write('\n'.join(ddl_statements))

    print(f"\n[OK] DDL схемы сохранён в файл: {OUTPUT_FILE}")
    print(f"   Всего строк: {len(ddl_statements)}")

except requests.exceptions.SSLError as e:
    print(f"[ERROR] SSL ошибка: {e}")
    print("Попробуйте запустить с verify=False или установите сертификат")
except requests.exceptions.ConnectionError as e:
    print(f"[ERROR] Ошибка подключения: {e}")
except Exception as e:
    print(f"[ERROR] Ошибка: {e}")
    exit(1)

print("\nГотово!")
