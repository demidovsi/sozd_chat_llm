"""
Пример интеграции system prompt в endpoint sql/text

Добавьте этот код в ваш REST API сервер (порт 5051)
"""

import os
from pathlib import Path

# Загружаем system prompt при старте приложения
SYSTEM_PROMPT_FILE = Path(__file__).parent / "sozd_system_prompt.txt"

# Глобальная переменная для кэширования
_SYSTEM_PROMPT = None

def load_system_prompt():
    """Загрузить system prompt из файла (один раз при старте)"""
    global _SYSTEM_PROMPT
    if _SYSTEM_PROMPT is None:
        with open(SYSTEM_PROMPT_FILE, 'r', encoding='utf-8') as f:
            _SYSTEM_PROMPT = f.read()
    return _SYSTEM_PROMPT


# В вашем endpoint sql/text:
@app.post("/sql/text")
async def generate_sql_from_text(request: Request):
    """
    Генерация SQL из естественного языка с использованием Gemini
    """
    data = await request.json()
    user_conditions = data.get("user_conditions", "")
    model = data.get("model", "gemini-2.5-pro")
    session_id = data.get("session_id")
    db_schema = data.get("db_schema", "sozd")

    # Загружаем system prompt
    system_prompt = load_system_prompt()

    # Формируем запрос к Gemini
    messages = [
        {
            "role": "user",
            "parts": [
                {
                    "text": f"{system_prompt}\n\n# ПОЛЬЗОВАТЕЛЬСКИЙ ЗАПРОС\n\n{user_conditions}"
                }
            ]
        }
    ]

    # Или если используете chat history:
    # messages = [
    #     {"role": "system", "content": system_prompt},
    #     {"role": "user", "content": user_conditions}
    # ]

    # Вызов Gemini API
    response = await call_gemini_api(
        model=model,
        messages=messages,
        session_id=session_id
    )

    return response


# Альтернатива: если используете Google AI SDK
import google.generativeai as genai

def generate_sql_with_gemini(user_query: str, db_schema: str = "sozd"):
    """Генерация SQL с использованием Gemini и system prompt"""

    # Загружаем system prompt
    system_prompt = load_system_prompt()

    # Настраиваем модель
    model = genai.GenerativeModel(
        model_name="gemini-2.5-pro",
        system_instruction=system_prompt  # System prompt здесь!
    )

    # Генерируем
    response = model.generate_content(user_query)

    return response.text


# Пример с историей чата (для сессий)
def generate_sql_with_session(user_query: str, session_id: str):
    """Генерация SQL с сохранением истории сессии"""

    system_prompt = load_system_prompt()

    model = genai.GenerativeModel(
        model_name="gemini-2.5-pro",
        system_instruction=system_prompt
    )

    # Создаём или получаем существующую сессию
    chat = model.start_chat(history=get_session_history(session_id))

    # Отправляем сообщение
    response = chat.send_message(user_query)

    # Сохраняем историю
    save_session_history(session_id, chat.history)

    return response.text
