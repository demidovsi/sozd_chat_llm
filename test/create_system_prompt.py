#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Создание system prompt для Gemini с DDL схемы
"""

import os
from dotenv import load_dotenv

load_dotenv()

SCHEMA_NAME = os.getenv("SCHEMA_NAME", "sozd")
DDL_FILE = "../db_schema_dll/sozd_schema_ddl.sql"
OUTPUT_FILE = f"{SCHEMA_NAME}_system_prompt.txt"

# Читаем DDL
with open(DDL_FILE, 'r', encoding='utf-8') as f:
    ddl_content = f.read()

# Создаём system prompt
system_prompt = f"""Ты - эксперт по PostgreSQL и помощник в написании SQL запросов.

# СХЕМА БАЗЫ ДАННЫХ

Работаем со схемой "{SCHEMA_NAME}" в PostgreSQL. Вот полное определение всех таблиц:

```sql
{ddl_content}
```

# ПРАВИЛА ГЕНЕРАЦИИ SQL

1. **Всегда используй имя схемы**: {SCHEMA_NAME}.table_name
2. **Используй параметризованные запросы** для защиты от SQL injection
3. **Оптимизируй запросы**: используй индексы, избегай SELECT *
4. **Проверяй типы данных**: убедись, что типы в WHERE совпадают с типами колонок
5. **Используй LIMIT** по умолчанию для больших выборок
6. **Добавляй комментарии** к сложным запросам
7. **Используй JOIN вместо подзапросов** где возможно
8. **Проверяй NULL значения** где необходимо

# ФОРМАТ ОТВЕТА

Возвращай SQL запрос в следующем формате:

```sql
-- Описание запроса
SELECT ...
FROM {SCHEMA_NAME}.table_name
WHERE ...
ORDER BY ...
LIMIT 10;
```

Если запрос требует параметров, укажи их отдельно:

```json
{{
  "param1": "значение",
  "param2": 123
}}
```

# ПРИМЕРЫ ЗАПРОСОВ

Пример 1: Поиск по названию
```sql
-- Поиск законопроектов по ключевым словам
SELECT law_id, law_name, law_reg_date
FROM {SCHEMA_NAME}.laws
WHERE law_name ILIKE '%' || $1 || '%'
ORDER BY law_reg_date DESC
LIMIT 10;
```

Пример 2: Агрегация
```sql
-- Количество законопроектов по годам
SELECT
  EXTRACT(YEAR FROM law_reg_date) as year,
  COUNT(*) as count
FROM {SCHEMA_NAME}.laws
GROUP BY year
ORDER BY year DESC;
```

# ИНСТРУКЦИЯ

На основе пользовательского запроса сгенерируй оптимальный SQL запрос, используя схему базы данных выше.
"""

# Сохраняем
with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
    f.write(system_prompt)

print(f"[OK] System prompt создан: {OUTPUT_FILE}")
print(f"   Размер: {len(system_prompt):,} символов")
print(f"   Примерно {len(system_prompt) // 3:,} токенов")

# Также создаём сокращённую версию (только структура таблиц, без индексов)
print("\n[INFO] Создание сокращённой версии...")

# Берём только CREATE TABLE и COMMENT ON
ddl_lines = ddl_content.split('\n')
short_ddl = []
include = False

for line in ddl_lines:
    if line.startswith('-- Таблица:'):
        include = True
        short_ddl.append('\n' + line)
    elif line.startswith('CREATE TABLE'):
        short_ddl.append(line)
    elif line.startswith('COMMENT ON'):
        short_ddl.append(line)
    elif line.startswith('ALTER TABLE') and 'PRIMARY KEY' in line:
        short_ddl.append(line)
    elif line.startswith('-- ') and include:
        short_ddl.append(line)

short_ddl_content = '\n'.join(short_ddl)

short_prompt = system_prompt.replace(ddl_content, short_ddl_content)

SHORT_OUTPUT = f"{SCHEMA_NAME}_system_prompt_short.txt"
with open(SHORT_OUTPUT, 'w', encoding='utf-8') as f:
    f.write(short_prompt)

print(f"[OK] Сокращённый prompt создан: {SHORT_OUTPUT}")
print(f"   Размер: {len(short_prompt):,} символов")
print(f"   Примерно {len(short_prompt) // 3:,} токенов")
print(f"   Экономия: {100 - (len(short_prompt) / len(system_prompt) * 100):.1f}%")
