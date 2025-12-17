# ✅ Используем минимальный Python-образ
FROM python:3.9-slim AS builder

# ✅ Устанавливаем рабочую директорию
WORKDIR /app

# ✅ Сначала копируем только requirements.txt (для кеша)
COPY requirements.txt .

# ✅ Устанавливаем зависимости без кеша pip
RUN pip install --no-cache-dir -r requirements.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip

# ✅ Копируем оставшийся код
COPY . .

# ✅ Указываем порт (если используется веб-сервер)
EXPOSE 8080

# ✅ Явно задаём команду запуска
CMD ["python", "lib_web.py"]
