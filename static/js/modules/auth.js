/**
 * Authentication module
 */

// Current user state
export let currentUser = null;

/**
 * Login user
 */
export async function login(username, password, rememberMe = false) {
  try {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        username,
        password,
        remember_me: rememberMe
      })
    });

    const data = await response.json();

    if (response.ok && data.success) {
      currentUser = data.user;
      return { success: true, user: data.user };
    } else {
      return { success: false, message: data.message };
    }
  } catch (error) {
    console.error('Login error:', error);
    return { success: false, message: 'Connection error' };
  }
}

/**
 * Logout user
 */
export async function logout() {
  try {
    await fetch('/api/auth/logout', {
      method: 'POST'
    });

    currentUser = null;
    return { success: true };
  } catch (error) {
    console.error('Logout error:', error);
    return { success: false };
  }
}

/**
 * Get current authenticated user
 */
export async function getCurrentUser() {
  try {
    const response = await fetch('/api/auth/me');

    if (response.ok) {
      const data = await response.json();
      currentUser = data.user;
      return currentUser;
    } else {
      currentUser = null;
      return null;
    }
  } catch (error) {
    console.error('Get current user error:', error);
    currentUser = null;
    return null;
  }
}

/**
 * Request password reset
 */
export async function requestPasswordReset(email) {
  try {
    const response = await fetch('/api/auth/request-password-reset', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email })
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Password reset request error:', error);
    return { success: false, message: 'Connection error' };
  }
}

/**
 * Reset password with token
 */
export async function resetPassword(token, newPassword) {
  try {
    const response = await fetch('/api/auth/reset-password', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        token,
        new_password: newPassword
      })
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Password reset error:', error);
    return { success: false, message: 'Connection error' };
  }
}

/**
 * Check if user has access to a schema
 */
export function hasSchemaAccess(schemaName) {
  if (!currentUser || !currentUser.schemas) {
    return false;
  }
  return currentUser.schemas.includes(schemaName);
}

/**
 * Check if current user is admin
 */
export function isAdmin() {
  return currentUser && currentUser.is_admin === true;
}

/**
 * Get available schemas for current user
 */
export function getAvailableSchemas() {
  if (!currentUser || !currentUser.schemas) {
    return [];
  }
  return currentUser.schemas;
}

/**
 * Get available schemas with labels
 */
export async function getAvailableSchemasWithLabels() {
  try {
    const response = await fetch('/api/schemas');

    if (response.ok) {
      const data = await response.json();
      return data.schemas || [];
    } else {
      return [];
    }
  } catch (error) {
    console.error('Get schemas error:', error);
    return [];
  }
}

/**
 * Set current user (for internal use)
 */
export function setCurrentUser(user) {
  currentUser = user;
}

/**
 * Clear current user
 */
export function clearCurrentUser() {
  currentUser = null;
}
