"""
Authentication middleware and decorators for Flask
"""
from functools import wraps
from flask import redirect, url_for, jsonify, request
from flask_login import current_user
import auth_service


def login_required(f):
    """Decorator to require login for routes"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            # For API requests, return JSON error
            if request.path.startswith('/api/'):
                return jsonify({'error': 'Authentication required'}), 401
            # For pages, redirect to login
            return redirect(url_for('login_page'))
        return f(*args, **kwargs)
    return decorated_function


def admin_required(f):
    """Decorator to require admin privileges"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            return jsonify({'error': 'Authentication required'}), 401
        if not current_user.is_admin:
            return jsonify({'error': 'Admin privileges required'}), 403
        return f(*args, **kwargs)
    return decorated_function


def schema_access_required(schema_name_param='schema_name'):
    """Decorator to require access to a specific schema"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not current_user.is_authenticated:
                return jsonify({'error': 'Authentication required'}), 401

            # Get schema name from kwargs or request
            schema_name = kwargs.get(schema_name_param)
            if not schema_name:
                # Try to get from request JSON or args
                if request.is_json:
                    schema_name = request.json.get('db_schema') or request.json.get('schema_name')
                else:
                    schema_name = request.args.get('schema_name')

            if not schema_name:
                return jsonify({'error': 'Schema name required'}), 400

            # Check if user has access
            if not auth_service.has_schema_access(current_user.id, schema_name):
                return jsonify({'error': f'Access denied to schema: {schema_name}'}), 403

            return f(*args, **kwargs)
        return decorated_function
    return decorator


def get_current_user():
    """Get current authenticated user"""
    return current_user if current_user.is_authenticated else None


def check_schema_access(user_id: int, schema_name: str) -> bool:
    """Check if user has access to schema"""
    return auth_service.has_schema_access(user_id, schema_name)
