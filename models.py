"""
Database models with support for both SQLite (local) and PostgreSQL (Cloud SQL)
"""
import os
import sqlite3
from datetime import datetime
from typing import Optional, List, Dict, Any
import config


# Определяем тип БД на основе переменных окружения
DB_TYPE = os.getenv('DB_TYPE', 'sqlite')  # 'sqlite' или 'postgresql'

if DB_TYPE == 'postgresql':
    import psycopg2
    import psycopg2.extras


class Database:
    """Universal database connection manager for SQLite and PostgreSQL"""

    def __init__(self, db_path: str = None):
        self.db_type = DB_TYPE
        self.db_path = db_path or config.DATABASE_PATH

        # PostgreSQL connection parameters
        if self.db_type == 'postgresql':
            self.pg_config = {
                'host': os.getenv('DB_HOST', '/cloudsql/' + os.getenv('CLOUD_SQL_CONNECTION_NAME', '')),
                'port': int(os.getenv('DB_PORT', '5432')),
                'database': os.getenv('DB_NAME', 'auth_db'),
                'user': os.getenv('DB_USER', 'postgres'),
                'password': os.getenv('DB_PASSWORD', '')
            }

    def get_connection(self):
        """Get database connection (SQLite or PostgreSQL)"""
        if self.db_type == 'postgresql':
            # Cloud SQL connection via Unix socket
            conn = psycopg2.connect(**self.pg_config)
            return conn
        else:
            # SQLite connection for local development
            conn = sqlite3.connect(self.db_path)
            conn.row_factory = sqlite3.Row
            return conn

    @property
    def cursor(self):
        """Для совместимости с health check"""
        conn = self.get_connection()
        cursor = conn.cursor()
        return cursor

    def execute(self, query: str, params: tuple = ()):
        """Execute a query with proper parameter binding"""
        conn = self.get_connection()
        cursor = conn.cursor()

        # PostgreSQL использует %s, SQLite использует ?
        if self.db_type == 'postgresql':
            query = query.replace('?', '%s')

        cursor.execute(query, params)
        conn.commit()
        conn.close()
        return cursor

    def fetchone(self, query: str, params: tuple = ()) -> Optional[Dict]:
        """Execute query and fetch one result"""
        conn = self.get_connection()

        if self.db_type == 'postgresql':
            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            query = query.replace('?', '%s')
        else:
            cursor = conn.cursor()

        cursor.execute(query, params)
        row = cursor.fetchone()
        conn.close()

        if self.db_type == 'postgresql':
            return dict(row) if row else None
        else:
            return dict(row) if row else None

    def fetchall(self, query: str, params: tuple = ()) -> List[Dict]:
        """Execute query and fetch all results"""
        conn = self.get_connection()

        if self.db_type == 'postgresql':
            cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            query = query.replace('?', '%s')
        else:
            cursor = conn.cursor()

        cursor.execute(query, params)
        rows = cursor.fetchall()
        conn.close()

        return [dict(row) for row in rows]

    def init_db(self):
        """Initialize database schema (supports both SQLite and PostgreSQL)"""
        conn = self.get_connection()
        cursor = conn.cursor()

        if self.db_type == 'postgresql':
            # PostgreSQL specific schema
            queries = [
                # Users table
                '''
                CREATE TABLE IF NOT EXISTS users (
                    id SERIAL PRIMARY KEY,
                    username VARCHAR(255) UNIQUE NOT NULL,
                    email VARCHAR(255) UNIQUE NOT NULL,
                    password_hash VARCHAR(255) NOT NULL,
                    is_active BOOLEAN DEFAULT TRUE,
                    is_admin BOOLEAN DEFAULT FALSE,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    last_login_at TIMESTAMP NULL,
                    reset_token VARCHAR(255) NULL,
                    reset_token_expires TIMESTAMP NULL,
                    remember_token VARCHAR(255) NULL
                )
                ''',
                # User schema access table
                '''
                CREATE TABLE IF NOT EXISTS user_schema_access (
                    id SERIAL PRIMARY KEY,
                    user_id INTEGER NOT NULL,
                    schema_name VARCHAR(255) NOT NULL,
                    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    granted_by INTEGER NULL,
                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                    FOREIGN KEY (granted_by) REFERENCES users(id) ON DELETE SET NULL,
                    UNIQUE(user_id, schema_name)
                )
                ''',
                # Activity log table
                '''
                CREATE TABLE IF NOT EXISTS activity_log (
                    id SERIAL PRIMARY KEY,
                    user_id INTEGER NULL,
                    action VARCHAR(255) NOT NULL,
                    details TEXT NULL,
                    ip_address VARCHAR(255) NULL,
                    user_agent TEXT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
                )
                ''',
                # Index on activity_log
                '''
                CREATE INDEX IF NOT EXISTS idx_activity_user_created
                ON activity_log(user_id, created_at)
                ''',
                # Chat history table
                '''
                CREATE TABLE IF NOT EXISTS chat_history (
                    id SERIAL PRIMARY KEY,
                    user_id INTEGER NOT NULL,
                    chat_id VARCHAR(255) NOT NULL,
                    chat_data TEXT NOT NULL,
                    schema_name VARCHAR(255) NOT NULL,
                    mode VARCHAR(255) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                    UNIQUE(user_id, chat_id)
                )
                ''',
                # Index on chat_history
                '''
                CREATE INDEX IF NOT EXISTS idx_chat_user_schema
                ON chat_history(user_id, schema_name)
                '''
            ]
        else:
            # SQLite specific schema
            queries = [
                # Users table
                '''
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    username TEXT UNIQUE NOT NULL,
                    email TEXT UNIQUE NOT NULL,
                    password_hash TEXT NOT NULL,
                    is_active BOOLEAN DEFAULT 1,
                    is_admin BOOLEAN DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    last_login_at TIMESTAMP NULL,
                    reset_token TEXT NULL,
                    reset_token_expires TIMESTAMP NULL,
                    remember_token TEXT NULL
                )
                ''',
                # User schema access table
                '''
                CREATE TABLE IF NOT EXISTS user_schema_access (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user_id INTEGER NOT NULL,
                    schema_name TEXT NOT NULL,
                    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    granted_by INTEGER NULL,
                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                    FOREIGN KEY (granted_by) REFERENCES users(id) ON DELETE SET NULL,
                    UNIQUE(user_id, schema_name)
                )
                ''',
                # Activity log table
                '''
                CREATE TABLE IF NOT EXISTS activity_log (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user_id INTEGER NULL,
                    action TEXT NOT NULL,
                    details TEXT NULL,
                    ip_address TEXT NULL,
                    user_agent TEXT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
                )
                ''',
                # Index on activity_log
                '''
                CREATE INDEX IF NOT EXISTS idx_activity_user_created
                ON activity_log(user_id, created_at)
                ''',
                # Chat history table
                '''
                CREATE TABLE IF NOT EXISTS chat_history (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user_id INTEGER NOT NULL,
                    chat_id TEXT NOT NULL,
                    chat_data TEXT NOT NULL,
                    schema_name TEXT NOT NULL,
                    mode TEXT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                    UNIQUE(user_id, chat_id)
                )
                ''',
                # Index on chat_history
                '''
                CREATE INDEX IF NOT EXISTS idx_chat_user_schema
                ON chat_history(user_id, schema_name)
                '''
            ]

        # Execute all queries
        for query in queries:
            cursor.execute(query)

        conn.commit()
        conn.close()


class User:
    """User model"""

    def __init__(self, user_dict: Dict):
        self.id = user_dict.get('id')
        self.username = user_dict.get('username')
        self.email = user_dict.get('email')
        self.password_hash = user_dict.get('password_hash')
        self.is_active = bool(user_dict.get('is_active', True))
        self.is_admin = bool(user_dict.get('is_admin', False))
        self.created_at = user_dict.get('created_at')
        self.updated_at = user_dict.get('updated_at')
        self.last_login_at = user_dict.get('last_login_at')
        self.reset_token = user_dict.get('reset_token')
        self.reset_token_expires = user_dict.get('reset_token_expires')
        self.remember_token = user_dict.get('remember_token')

    # Flask-Login integration
    @property
    def is_authenticated(self):
        return True

    @property
    def is_anonymous(self):
        return False

    def get_id(self):
        return str(self.id)

    def to_dict(self, include_schemas=False) -> Dict:
        """Convert user to dictionary with ISO 8601 timestamps"""
        from auth_service import to_iso8601, get_user_schemas

        data = {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'is_active': self.is_active,
            'is_admin': self.is_admin,
            'created_at': to_iso8601(self.created_at),
            'updated_at': to_iso8601(self.updated_at),
            'last_login_at': to_iso8601(self.last_login_at)
        }

        if include_schemas:
            data['schemas'] = get_user_schemas(self.id)

        return data


class UserSchemaAccess:
    """User schema access model"""

    def __init__(self, access_dict: Dict):
        self.id = access_dict.get('id')
        self.user_id = access_dict.get('user_id')
        self.schema_name = access_dict.get('schema_name')
        self.granted_at = access_dict.get('granted_at')
        self.granted_by = access_dict.get('granted_by')

    def to_dict(self) -> Dict:
        """Convert to dictionary with ISO 8601 timestamps"""
        from auth_service import to_iso8601

        return {
            'id': self.id,
            'user_id': self.user_id,
            'schema_name': self.schema_name,
            'granted_at': to_iso8601(self.granted_at),
            'granted_by': self.granted_by
        }


class ActivityLog:
    """Activity log model"""

    def __init__(self, log_dict: Dict):
        self.id = log_dict.get('id')
        self.user_id = log_dict.get('user_id')
        self.action = log_dict.get('action')
        self.details = log_dict.get('details')
        self.ip_address = log_dict.get('ip_address')
        self.user_agent = log_dict.get('user_agent')
        self.created_at = log_dict.get('created_at')

    def to_dict(self) -> Dict:
        """Convert to dictionary with ISO 8601 timestamps"""
        from auth_service import to_iso8601

        return {
            'id': self.id,
            'user_id': self.user_id,
            'action': self.action,
            'details': self.details,
            'ip_address': self.ip_address,
            'user_agent': self.user_agent,
            'created_at': to_iso8601(self.created_at)
        }


class ChatHistory:
    """Chat history model"""

    def __init__(self, chat_dict: Dict):
        self.id = chat_dict.get('id')
        self.user_id = chat_dict.get('user_id')
        self.chat_id = chat_dict.get('chat_id')
        self.chat_data = chat_dict.get('chat_data')
        self.schema_name = chat_dict.get('schema_name')
        self.mode = chat_dict.get('mode')
        self.created_at = chat_dict.get('created_at')
        self.updated_at = chat_dict.get('updated_at')

    def to_dict(self) -> Dict:
        """Convert to dictionary with ISO 8601 timestamps"""
        from auth_service import to_iso8601

        return {
            'id': self.id,
            'user_id': self.user_id,
            'chat_id': self.chat_id,
            'chat_data': self.chat_data,
            'schema_name': self.schema_name,
            'mode': self.mode,
            'created_at': to_iso8601(self.created_at),
            'updated_at': to_iso8601(self.updated_at)
        }
