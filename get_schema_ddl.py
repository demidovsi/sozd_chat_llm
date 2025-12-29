#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Скрипт для получения DDL схемы PostgreSQL
"""

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import os
import sys
from dotenv import load_dotenv


def translate_from_base(st):
    if st and type(st) == str:
        st = st.replace('~A~', '(').replace('~B~', ')').replace('~a1~', '@').replace('~LF~', '\n')
        st = st.replace('~a2~', ',').replace('~a3~', '=').replace('~a4~', '"').replace('~a5~', "'")
        st = st.replace('~a6~', ':').replace('~b1~', '/').replace('~TAB~', '\t').replace('~R~', '\r')
    return st

# Загружаем переменные из .env файла
load_dotenv()

# Параметры подключения из переменных окружения
DB_HOST = os.getenv("DB_HOST", "159.223.0.234")
DB_PORT = int(os.getenv("DB_PORT", "5432"))
DB_NAME = os.getenv("DB_NAME", "postgres")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD")
SCHEMA_NAME = "ohi"
OUTPUT_FILE = SCHEMA_NAME + "_schema_ddl.sql"

# Проверяем наличие пароля
if not DB_PASSWORD:
    print("[ERROR] DB_PASSWORD не установлен в .env файле")
    print("Создайте файл .env на основе .env.example и укажите пароль")
    sys.exit(1)

print(f"\nПодключение к {DB_HOST}:{DB_PORT}/{DB_NAME}...")

try:
    # Подключение к базе данных
    print(f"Попытка подключения с пользователем: {DB_USER}")
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        connect_timeout=10
    )
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    print("Подключение успешно установлено!")
    cur = conn.cursor()

    print(f"Извлечение DDL схемы '{SCHEMA_NAME}'...\n")

    ddl_statements = []

    # Заголовок
    ddl_statements.append(f"-- DDL схемы {SCHEMA_NAME}")
    ddl_statements.append(f"-- Сгенерировано: {__import__('datetime').datetime.now()}")
    ddl_statements.append("")
    ddl_statements.append(f"CREATE SCHEMA IF NOT EXISTS {SCHEMA_NAME};")
    ddl_statements.append("")

    # Получаем список таблиц
    cur.execute("""
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = %s
        ORDER BY tablename;
    """, (SCHEMA_NAME,))

    tables = cur.fetchall()
    print(f"Найдено таблиц: {len(tables)}")

    for (table_name,) in tables:
        print(f"  - {table_name}")

        # Получаем определение таблицы
        cur.execute("""
            SELECT
                'CREATE TABLE ' || quote_ident(%s) || '.' || quote_ident(%s) || ' (' ||
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
                ) || ');'
            FROM information_schema.columns
            WHERE table_schema = %s AND table_name = %s;
        """, (SCHEMA_NAME, table_name, SCHEMA_NAME, table_name))

        create_table = cur.fetchone()
        if create_table:
            ddl_statements.append(f"\n-- Таблица: {SCHEMA_NAME}.{table_name}")

            # Получаем комментарий к таблице
            cur.execute("""
                SELECT obj_description((quote_ident(%s) || '.' || quote_ident(%s))::regclass, 'pg_class');
            """, (SCHEMA_NAME, table_name))

            table_comment = cur.fetchone()
            if table_comment and table_comment[0]:
                comment = table_comment[0]
                comment = translate_from_base(comment)
                ddl_statements.append(f"-- Комментарий: {comment}")

            ddl_statements.append(create_table[0])

            # Добавляем COMMENT ON TABLE если есть комментарий
            if table_comment and table_comment[0]:
                comment_sql = f"COMMENT ON TABLE {SCHEMA_NAME}.{table_name} IS '{table_comment[0]}';"
                ddl_statements.append(comment_sql)

            # Получаем комментарии к колонкам
            cur.execute("""
                SELECT
                    a.attname AS column_name,
                    col_description(a.attrelid, a.attnum) AS column_comment
                FROM pg_attribute a
                JOIN pg_class c ON a.attrelid = c.oid
                JOIN pg_namespace n ON c.relnamespace = n.oid
                WHERE n.nspname = %s
                    AND c.relname = %s
                    AND a.attnum > 0
                    AND NOT a.attisdropped
                    AND col_description(a.attrelid, a.attnum) IS NOT NULL
                ORDER BY a.attnum;
            """, (SCHEMA_NAME, table_name))

            column_comments = cur.fetchall()
            if column_comments:
                for col_name, col_comment in column_comments:
                    col_comment = translate_from_base(col_comment)
                    comment_sql = f"COMMENT ON COLUMN {SCHEMA_NAME}.{table_name}.{col_name} IS '{col_comment}';"
                    ddl_statements.append(comment_sql)

        # Получаем первичные ключи
        cur.execute("""
            SELECT
                'ALTER TABLE ' || quote_ident(tc.table_schema) || '.' || quote_ident(tc.table_name) ||
                ' ADD CONSTRAINT ' || quote_ident(tc.constraint_name) ||
                ' PRIMARY KEY (' || string_agg(quote_ident(kcu.column_name), ', ' ORDER BY kcu.ordinal_position) || ');'
            FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu
                ON tc.constraint_name = kcu.constraint_name
                AND tc.table_schema = kcu.table_schema
            WHERE tc.constraint_type = 'PRIMARY KEY'
                AND tc.table_schema = %s
                AND tc.table_name = %s
            GROUP BY tc.table_schema, tc.table_name, tc.constraint_name;
        """, (SCHEMA_NAME, table_name))

        pk = cur.fetchone()
        if pk:
            ddl_statements.append(pk[0])

        # Получаем индексы
        cur.execute("""
            SELECT indexdef || ';'
            FROM pg_indexes
            WHERE schemaname = %s AND tablename = %s
                AND indexname NOT IN (
                    SELECT constraint_name
                    FROM information_schema.table_constraints
                    WHERE table_schema = %s AND table_name = %s
                );
        """, (SCHEMA_NAME, table_name, SCHEMA_NAME, table_name))

        indexes = cur.fetchall()
        for (index_def,) in indexes:
            ddl_statements.append(index_def)

    # Получаем внешние ключи
    cur.execute("""
        SELECT
            'ALTER TABLE ' || quote_ident(tc.table_schema) || '.' || quote_ident(tc.table_name) ||
            ' ADD CONSTRAINT ' || quote_ident(tc.constraint_name) ||
            ' FOREIGN KEY (' || string_agg(DISTINCT quote_ident(kcu.column_name), ', ') || ')' ||
            ' REFERENCES ' || quote_ident(ccu.table_schema) || '.' || quote_ident(ccu.table_name) ||
            ' (' || string_agg(DISTINCT quote_ident(ccu.column_name), ', ') || ');'
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
            ON tc.constraint_name = kcu.constraint_name
            AND tc.table_schema = kcu.table_schema
        JOIN information_schema.constraint_column_usage ccu
            ON ccu.constraint_name = tc.constraint_name
            AND ccu.table_schema = tc.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
            AND tc.table_schema = %s
        GROUP BY tc.table_schema, tc.table_name, tc.constraint_name, ccu.table_schema, ccu.table_name;
    """, (SCHEMA_NAME,))

    fks = cur.fetchall()
    if fks:
        ddl_statements.append("\n-- Внешние ключи")
        for (fk_def,) in fks:
            ddl_statements.append(fk_def)

    # Сохраняем в файл
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write('\n'.join(ddl_statements))

    print(f"\n[OK] DDL схемы сохранён в файл: {OUTPUT_FILE}")
    print(f"   Всего строк: {len(ddl_statements)}")

    cur.close()
    conn.close()

except psycopg2.Error as e:
    print(f"\n[ERROR] Ошибка PostgreSQL: {e}")
    print(f"\nПроверьте:")
    print(f"  - Правильность пароля")
    print(f"  - Доступ пользователя {DB_USER} к базе {DB_NAME}")
    print(f"  - Правила firewall для {DB_HOST}:{DB_PORT}")
    exit(1)
except Exception as e:
    print(f"\n[ERROR] Ошибка: {e}")
    exit(1)

print("\nГотово!")
