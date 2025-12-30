"""
Authentication services for user management, passwords, and schema access
"""
import bcrypt
import secrets
from datetime import datetime, timedelta
from typing import Optional, List, Dict
from models import Database, User
import config


db = Database()


def to_iso8601(timestamp_str: str) -> str:
    """
    Convert SQLite timestamp to ISO 8601 format with UTC timezone
    Input: '2025-12-30 15:30:45' (SQLite CURRENT_TIMESTAMP format)
    Output: '2025-12-30T15:30:45Z' (ISO 8601 with UTC)
    """
    if not timestamp_str:
        return None
    try:
        # Parse SQLite timestamp
        dt = datetime.strptime(timestamp_str, '%Y-%m-%d %H:%M:%S')
        # Convert to ISO 8601 with Z (UTC) suffix
        return dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    except (ValueError, AttributeError):
        # If parsing fails, return as-is
        return timestamp_str


# === User Management ===

def create_user(username: str, email: str, password: str, is_admin: bool = False, is_active: bool = True, schemas: List[str] = None) -> Dict:
    """Create a new user"""
    # Validate required fields
    if not username or not email or not password:
        return {'success': False, 'message': 'Username, email and password are required'}

    # Check if user already exists
    existing = db.fetchone('SELECT id FROM users WHERE username = ? OR email = ?', (username, email))
    if existing:
        return {'success': False, 'message': 'User with this username or email already exists'}

    # Hash password
    password_hash = hash_password(password)

    # Insert user
    conn = db.get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute('''
            INSERT INTO users (username, email, password_hash, is_admin, is_active)
            VALUES (?, ?, ?, ?, ?)
        ''', (username, email, password_hash, 1 if is_admin else 0, 1 if is_active else 0))

        user_id = cursor.lastrowid

        # Grant schema access
        if schemas:
            for schema in schemas:
                cursor.execute('''
                    INSERT INTO user_schema_access (user_id, schema_name)
                    VALUES (?, ?)
                ''', (user_id, schema))

        conn.commit()
        return {'success': True, 'message': 'User created successfully', 'user_id': user_id}
    except Exception as e:
        conn.rollback()
        return {'success': False, 'message': f'Database error: {str(e)}'}
    finally:
        conn.close()


def authenticate_user(username: str, password: str) -> Optional[User]:
    """Authenticate user by username and password"""
    user_dict = db.fetchone('SELECT * FROM users WHERE username = ?', (username,))
    if not user_dict:
        return None

    # Check if user is active
    if not user_dict.get('is_active'):
        return None

    # Verify password
    if not verify_password(password, user_dict['password_hash']):
        return None

    # Update last login
    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE users SET last_login_at = CURRENT_TIMESTAMP WHERE id = ?', (user_dict['id'],))
    conn.commit()
    conn.close()

    return User(user_dict)


def get_user_by_id(user_id: int) -> Optional[User]:
    """Get user by ID"""
    user_dict = db.fetchone('SELECT * FROM users WHERE id = ?', (user_id,))
    return User(user_dict) if user_dict else None


def get_user_by_username(username: str) -> Optional[User]:
    """Get user by username"""
    user_dict = db.fetchone('SELECT * FROM users WHERE username = ?', (username,))
    return User(user_dict) if user_dict else None


def get_user_by_email(email: str) -> Optional[User]:
    """Get user by email"""
    user_dict = db.fetchone('SELECT * FROM users WHERE email = ?', (email,))
    return User(user_dict) if user_dict else None


def get_all_users() -> List[User]:
    """Get all users"""
    user_dicts = db.fetchall('SELECT * FROM users ORDER BY created_at DESC')
    return [User(u) for u in user_dicts]


def update_user(user_id: int, username: str = None, email: str = None, is_active: bool = None, is_admin: bool = None, schemas: List[str] = None) -> Dict:
    """Update user fields"""
    conn = db.get_connection()
    cursor = conn.cursor()

    try:
        # Check if username/email already exists for another user
        if username:
            existing = db.fetchone('SELECT id FROM users WHERE username = ? AND id != ?', (username, user_id))
            if existing:
                return {'success': False, 'message': 'Username already exists'}

        if email:
            existing = db.fetchone('SELECT id FROM users WHERE email = ? AND id != ?', (email, user_id))
            if existing:
                return {'success': False, 'message': 'Email already exists'}

        updates = []
        params = []

        if username is not None:
            updates.append('username = ?')
            params.append(username)

        if email is not None:
            updates.append('email = ?')
            params.append(email)

        if is_active is not None:
            updates.append('is_active = ?')
            params.append(1 if is_active else 0)

        if is_admin is not None:
            updates.append('is_admin = ?')
            params.append(1 if is_admin else 0)

        if updates:
            updates.append('updated_at = CURRENT_TIMESTAMP')
            params.append(user_id)
            query = f"UPDATE users SET {', '.join(updates)} WHERE id = ?"
            cursor.execute(query, params)

        # Update schemas if provided
        if schemas is not None:
            # Delete existing access
            cursor.execute('DELETE FROM user_schema_access WHERE user_id = ?', (user_id,))

            # Insert new access
            for schema in schemas:
                cursor.execute('''
                    INSERT INTO user_schema_access (user_id, schema_name)
                    VALUES (?, ?)
                ''', (user_id, schema))

        conn.commit()
        return {'success': True, 'message': 'User updated successfully'}
    except Exception as e:
        conn.rollback()
        return {'success': False, 'message': f'Database error: {str(e)}'}
    finally:
        conn.close()


def delete_user(user_id: int) -> Dict:
    """Delete user (cascade deletes schema access and chat history)"""
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM users WHERE id = ?', (user_id,))
        conn.commit()
        conn.close()
        return {'success': True, 'message': 'User deleted successfully'}
    except Exception as e:
        return {'success': False, 'message': f'Database error: {str(e)}'}


def reset_user_password(user_id: int, new_password: str) -> Dict:
    """Reset user password (for admin)"""
    try:
        if not new_password or len(new_password) < 6:
            return {'success': False, 'message': 'Password must be at least 6 characters'}

        password_hash = hash_password(new_password)

        conn = db.get_connection()
        cursor = conn.cursor()
        cursor.execute('''
            UPDATE users
            SET password_hash = ?, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        ''', (password_hash, user_id))
        conn.commit()
        conn.close()

        return {'success': True, 'message': 'Password reset successfully'}
    except Exception as e:
        return {'success': False, 'message': f'Database error: {str(e)}'}


def set_user_active(user_id: int, is_active: bool) -> bool:
    """Activate or deactivate user"""
    return update_user(user_id, is_active=is_active)


# === Password Management ===

def hash_password(password: str) -> str:
    """Hash password using bcrypt"""
    salt = bcrypt.gensalt(rounds=config.BCRYPT_LOG_ROUNDS)
    return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')


def verify_password(password: str, password_hash: str) -> bool:
    """Verify password against hash"""
    return bcrypt.checkpw(password.encode('utf-8'), password_hash.encode('utf-8'))


def generate_reset_token() -> str:
    """Generate a secure reset token"""
    return secrets.token_urlsafe(32)


def create_password_reset_token(email: str) -> Optional[str]:
    """Create password reset token for user"""
    user = get_user_by_email(email)
    if not user:
        return None

    token = generate_reset_token()
    expires = datetime.now() + timedelta(seconds=config.RESET_TOKEN_EXPIRATION)

    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        UPDATE users
        SET reset_token = ?, reset_token_expires = ?
        WHERE id = ?
    ''', (token, expires.isoformat(), user.id))
    conn.commit()
    conn.close()

    return token


def verify_reset_token(token: str) -> Optional[User]:
    """Verify reset token and return user if valid"""
    user_dict = db.fetchone('''
        SELECT * FROM users
        WHERE reset_token = ?
        AND reset_token_expires > CURRENT_TIMESTAMP
    ''', (token,))

    return User(user_dict) if user_dict else None


def reset_password(token: str, new_password: str) -> bool:
    """Reset password using token"""
    user = verify_reset_token(token)
    if not user:
        return False

    password_hash = hash_password(new_password)

    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        UPDATE users
        SET password_hash = ?, reset_token = NULL, reset_token_expires = NULL, updated_at = CURRENT_TIMESTAMP
        WHERE id = ?
    ''', (password_hash, user.id))
    conn.commit()
    conn.close()

    return True


def change_password(user_id: int, new_password: str) -> bool:
    """Change user password (for admin)"""
    password_hash = hash_password(new_password)

    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        UPDATE users
        SET password_hash = ?, updated_at = CURRENT_TIMESTAMP
        WHERE id = ?
    ''', (password_hash, user_id))
    conn.commit()
    conn.close()

    return True


# === Remember Me ===

def generate_remember_token() -> str:
    """Generate remember me token"""
    return secrets.token_urlsafe(32)


def set_remember_token(user_id: int, token: str) -> bool:
    """Set remember me token for user"""
    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE users SET remember_token = ? WHERE id = ?', (token, user_id))
    conn.commit()
    conn.close()
    return True


def verify_remember_token(token: str) -> Optional[User]:
    """Verify remember token and return user"""
    user_dict = db.fetchone('SELECT * FROM users WHERE remember_token = ? AND is_active = 1', (token,))
    return User(user_dict) if user_dict else None


def clear_remember_token(user_id: int) -> bool:
    """Clear remember me token"""
    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE users SET remember_token = NULL WHERE id = ?', (user_id,))
    conn.commit()
    conn.close()
    return True


# === Schema Access Management ===

def grant_schema_access(user_id: int, schema_name: str, granted_by_user_id: int = None) -> bool:
    """Grant user access to a schema"""
    conn = db.get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute('''
            INSERT INTO user_schema_access (user_id, schema_name, granted_by)
            VALUES (?, ?, ?)
        ''', (user_id, schema_name, granted_by_user_id))
        conn.commit()
        return True
    except Exception:
        # Already exists or other error
        return False
    finally:
        conn.close()


def revoke_schema_access(user_id: int, schema_name: str) -> bool:
    """Revoke user access to a schema"""
    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        DELETE FROM user_schema_access
        WHERE user_id = ? AND schema_name = ?
    ''', (user_id, schema_name))
    conn.commit()
    conn.close()
    return True


def get_user_schemas(user_id: int) -> List[str]:
    """Get list of schemas user has access to"""
    rows = db.fetchall('''
        SELECT schema_name FROM user_schema_access
        WHERE user_id = ?
        ORDER BY schema_name
    ''', (user_id,))
    return [row['schema_name'] for row in rows]


def has_schema_access(user_id: int, schema_name: str) -> bool:
    """Check if user has access to a specific schema"""
    row = db.fetchone('''
        SELECT id FROM user_schema_access
        WHERE user_id = ? AND schema_name = ?
    ''', (user_id, schema_name))
    return row is not None


def set_user_schemas(user_id: int, schema_names: List[str], granted_by_user_id: int = None) -> bool:
    """Set user's schema access (replaces all existing)"""
    conn = db.get_connection()
    cursor = conn.cursor()

    # Delete existing access
    cursor.execute('DELETE FROM user_schema_access WHERE user_id = ?', (user_id,))

    # Insert new access
    for schema_name in schema_names:
        cursor.execute('''
            INSERT INTO user_schema_access (user_id, schema_name, granted_by)
            VALUES (?, ?, ?)
        ''', (user_id, schema_name, granted_by_user_id))

    conn.commit()
    conn.close()
    return True


# === Activity Logging ===

def log_activity(user_id: Optional[int], action: str, details: str = None, ip_address: str = None, user_agent: str = None) -> bool:
    """Log user activity"""
    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO activity_log (user_id, action, details, ip_address, user_agent)
        VALUES (?, ?, ?, ?, ?)
    ''', (user_id, action, details, ip_address, user_agent))
    conn.commit()
    conn.close()
    return True


def get_user_activity(user_id: int, limit: int = 100) -> List[Dict]:
    """Get activity logs for a specific user"""
    rows = db.fetchall('''
        SELECT * FROM activity_log
        WHERE user_id = ?
        ORDER BY created_at DESC
        LIMIT ?
    ''', (user_id, limit))

    # Convert timestamps to ISO 8601
    for row in rows:
        if row.get('created_at'):
            row['created_at'] = to_iso8601(row['created_at'])

    return rows


def get_all_activity(limit: int = 100) -> List[Dict]:
    """Get all activity logs with user information"""
    rows = db.fetchall('''
        SELECT al.*, u.username
        FROM activity_log al
        LEFT JOIN users u ON al.user_id = u.id
        ORDER BY al.created_at DESC
        LIMIT ?
    ''', (limit,))

    # Convert timestamps to ISO 8601
    for row in rows:
        if row.get('created_at'):
            row['created_at'] = to_iso8601(row['created_at'])

    return rows


def get_activity_logs(user_id: Optional[int] = None, limit: int = 100) -> List[Dict]:
    """Get activity logs, optionally filtered by user_id"""
    if user_id:
        return get_user_activity(user_id, limit)
    else:
        return get_all_activity(limit)


# === Chat History Management ===

def save_chat(user_id: int, chat_id: str, chat_data: str, schema_name: str, mode: str) -> bool:
    """Save or update chat history"""
    conn = db.get_connection()
    cursor = conn.cursor()

    # Check if chat exists
    existing = db.fetchone('''
        SELECT id FROM chat_history
        WHERE user_id = ? AND chat_id = ?
    ''', (user_id, chat_id))

    if existing:
        # Update existing
        cursor.execute('''
            UPDATE chat_history
            SET chat_data = ?, schema_name = ?, mode = ?, updated_at = CURRENT_TIMESTAMP
            WHERE user_id = ? AND chat_id = ?
        ''', (chat_data, schema_name, mode, user_id, chat_id))
    else:
        # Insert new
        cursor.execute('''
            INSERT INTO chat_history (user_id, chat_id, chat_data, schema_name, mode)
            VALUES (?, ?, ?, ?, ?)
        ''', (user_id, chat_id, chat_data, schema_name, mode))

    conn.commit()
    conn.close()
    return True


def get_user_chats(user_id: int, schema_name: str = None) -> List[Dict]:
    """Get user's chat history, optionally filtered by schema"""
    if schema_name:
        rows = db.fetchall('''
            SELECT * FROM chat_history
            WHERE user_id = ? AND schema_name = ?
            ORDER BY updated_at DESC
        ''', (user_id, schema_name))
    else:
        rows = db.fetchall('''
            SELECT * FROM chat_history
            WHERE user_id = ?
            ORDER BY updated_at DESC
        ''', (user_id,))

    return rows


def delete_chat(user_id: int, chat_id: str) -> bool:
    """Delete a chat"""
    conn = db.get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        DELETE FROM chat_history
        WHERE user_id = ? AND chat_id = ?
    ''', (user_id, chat_id))
    conn.commit()
    conn.close()
    return True


def get_chat(user_id: int, chat_id: str) -> Optional[Dict]:
    """Get a specific chat"""
    return db.fetchone('''
        SELECT * FROM chat_history
        WHERE user_id = ? AND chat_id = ?
    ''', (user_id, chat_id))
