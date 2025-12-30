import os
from dotenv import load_dotenv

load_dotenv()

# Existing settings
OWN_PORT=8080
OWN_HOST='0.0.0.0'
kirill = 'wqzDi8OVw43DjcOOwoTCncKZwpM='

# Auth settings
SECRET_KEY = os.environ.get('SECRET_KEY') or os.urandom(32).hex()
DATABASE_PATH = os.path.join(os.path.dirname(__file__), 'auth.db')
BCRYPT_LOG_ROUNDS = 12
SESSION_COOKIE_SECURE = False  # True for production with HTTPS
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = 'Lax'
REMEMBER_COOKIE_DURATION = 30 * 24 * 3600  # 30 days in seconds
RESET_TOKEN_EXPIRATION = 3600  # 1 hour in seconds
