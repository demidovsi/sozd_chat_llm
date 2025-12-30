"""
Database initialization script
Creates database schema and optional admin user
"""
import argparse
import sys
import bcrypt
from models import Database
import config


def hash_password(password: str) -> str:
    """Hash a password using bcrypt"""
    salt = bcrypt.gensalt(rounds=config.BCRYPT_LOG_ROUNDS)
    return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')


def create_admin_user(db: Database, username: str, email: str, password: str, schemas: list = None):
    """Create admin user with access to all schemas"""
    # Check if user already exists
    existing = db.fetchone('SELECT id FROM users WHERE username = ? OR email = ?', (username, email))
    if existing:
        print(f'[ERROR] User with username "{username}" or email "{email}" already exists!')
        return False

    # Hash password
    password_hash = hash_password(password)

    # Insert user
    conn = db.get_connection()
    cursor = conn.cursor()

    cursor.execute('''
        INSERT INTO users (username, email, password_hash, is_admin, is_active)
        VALUES (?, ?, ?, 1, 1)
    ''', (username, email, password_hash))

    user_id = cursor.lastrowid

    # Grant access to all schemas if not specified
    if schemas is None:
        schemas = ['sozd', 'lib', 'family', 'urban', 'eco', 'gen', 'ohi']

    for schema_name in schemas:
        cursor.execute('''
            INSERT INTO user_schema_access (user_id, schema_name, granted_by)
            VALUES (?, ?, ?)
        ''', (user_id, schema_name, user_id))

    conn.commit()
    conn.close()

    print(f'[OK] Admin user "{username}" created successfully!')
    print(f'     Email: {email}')
    print(f'     Access to schemas: {", ".join(schemas)}')
    return True


def main():
    parser = argparse.ArgumentParser(description='Initialize database and optionally create admin user')
    parser.add_argument('--admin-username', help='Admin username')
    parser.add_argument('--admin-email', help='Admin email')
    parser.add_argument('--admin-password', help='Admin password')
    parser.add_argument('--schemas', help='Comma-separated list of schemas (default: all)', default=None)
    parser.add_argument('--reset', action='store_true', help='Reset database (WARNING: deletes all data)')

    args = parser.parse_args()

    db = Database()

    # Reset database if requested
    if args.reset:
        import os
        if os.path.exists(config.DATABASE_PATH):
            confirm = input('[WARNING] This will delete all data! Type "yes" to confirm: ')
            if confirm.lower() == 'yes':
                os.remove(config.DATABASE_PATH)
                print(f'[OK] Database deleted: {config.DATABASE_PATH}')
            else:
                print('[INFO] Reset cancelled')
                return

    # Initialize database schema
    print(f'[INIT] Initializing database: {config.DATABASE_PATH}')
    db.init_db()
    print('[OK] Database schema initialized')

    # Create admin user if credentials provided
    if args.admin_username and args.admin_email and args.admin_password:
        schemas = args.schemas.split(',') if args.schemas else None
        create_admin_user(db, args.admin_username, args.admin_email, args.admin_password, schemas)
    elif any([args.admin_username, args.admin_email, args.admin_password]):
        print('[ERROR] All admin credentials required: --admin-username, --admin-email, --admin-password')
        sys.exit(1)
    else:
        print('[INFO] No admin user created. Use --admin-username, --admin-email, --admin-password to create one.')

    print('\n[DONE] Database initialization complete!')


if __name__ == '__main__':
    main()
