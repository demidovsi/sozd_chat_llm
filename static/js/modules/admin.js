/**
 * Admin panel module
 */

import { getSchemaList } from './config.js';

// === User Management ===

export async function loadUsers() {
  try {
    const response = await fetch('/api/admin/users');
    if (response.ok) {
      const data = await response.json();
      return data.users || [];
    } else {
      console.error('Failed to load users:', response.status);
      return [];
    }
  } catch (error) {
    console.error('Load users error:', error);
    return [];
  }
}

export async function createUser(userData) {
  try {
    const response = await fetch('/api/admin/users', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(userData)
    });

    if (!response.ok) {
      // Try to parse error message from server
      try {
        const data = await response.json();
        return data;
      } catch {
        return { success: false, message: `Server error: ${response.status}` };
      }
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Create user error:', error);
    return { success: false, message: 'Connection error: ' + error.message };
  }
}

export async function updateUser(userId, userData) {
  try {
    const response = await fetch(`/api/admin/users/${userId}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(userData)
    });

    if (!response.ok) {
      // Try to parse error message from server
      try {
        const data = await response.json();
        return data;
      } catch {
        return { success: false, message: `Server error: ${response.status}` };
      }
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Update user error:', error);
    return { success: false, message: 'Connection error: ' + error.message };
  }
}

export async function deleteUser(userId) {
  try {
    const response = await fetch(`/api/admin/users/${userId}`, {
      method: 'DELETE'
    });

    if (!response.ok) {
      // Try to parse error message from server
      try {
        const data = await response.json();
        return data;
      } catch {
        return { success: false, message: `Server error: ${response.status}` };
      }
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Delete user error:', error);
    return { success: false, message: 'Connection error: ' + error.message };
  }
}

export async function resetUserPassword(userId, newPassword) {
  try {
    const response = await fetch(`/api/admin/users/${userId}/reset-password`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ new_password: newPassword })
    });

    if (!response.ok) {
      // Try to parse error message from server
      try {
        const data = await response.json();
        return data;
      } catch {
        return { success: false, message: `Server error: ${response.status}` };
      }
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Reset password error:', error);
    return { success: false, message: 'Connection error: ' + error.message };
  }
}

// === Activity Logs ===

export async function loadActivity(userId = null, limit = 100) {
  try {
    let url = `/api/admin/activity?limit=${limit}`;
    if (userId) {
      url += `&user_id=${userId}`;
    }

    const response = await fetch(url);
    if (response.ok) {
      const data = await response.json();
      return data.logs || [];
    } else {
      console.error('Failed to load activity:', response.status);
      return [];
    }
  } catch (error) {
    console.error('Load activity error:', error);
    return [];
  }
}

// === UI Rendering ===

export function renderUsersTable(users) {
  const tbody = document.querySelector('#usersTableBody');
  if (!tbody) return;

  if (users.length === 0) {
    tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 2rem; color: var(--text-secondary);">Нет пользователей</td></tr>';
    return;
  }

  tbody.innerHTML = users.map(user => {
    const schemaList = getSchemaList();
    const schemasText = user.schemas.length > 0
      ? user.schemas.map(s => schemaList.find(ds => ds.value === s)?.label || s).join(', ')
      : 'Нет доступа';

    const statusBadge = user.is_active
      ? '<span class="badge badge-success">Активен</span>'
      : '<span class="badge badge-inactive">Неактивен</span>';

    const roleBadge = user.is_admin
      ? '<span class="badge badge-admin">Админ</span>'
      : '<span class="badge badge-user">Пользователь</span>';

    return `
      <tr data-user-id="${user.id}">
        <td>${user.username}</td>
        <td>${user.email}</td>
        <td>${statusBadge}</td>
        <td>${roleBadge}</td>
        <td><small>${schemasText}</small></td>
        <td class="actions-cell">
          <button class="btn-icon" onclick="window.editUser(${user.id})" title="Редактировать">
            ✏️
          </button>
          <button class="btn-icon" onclick="window.resetPassword(${user.id})" title="Сбросить пароль">
            🔑
          </button>
          <button class="btn-icon" onclick="window.deleteUserConfirm(${user.id})" title="Удалить">
            🗑️
          </button>
        </td>
      </tr>
    `;
  }).join('');
}

export function renderActivityTable(logs) {
  const tbody = document.querySelector('#activityTableBody');
  if (!tbody) return;

  if (logs.length === 0) {
    tbody.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 2rem; color: var(--text-secondary);">Нет записей</td></tr>';
    return;
  }

  tbody.innerHTML = logs.map(log => {
    const username = log.username || `User #${log.user_id || 'N/A'}`;
    const action = formatAction(log.action);
    const details = log.details || '-';
    const date = new Date(log.created_at).toLocaleString('ru-RU');

    return `
      <tr>
        <td>${username}</td>
        <td>${action}</td>
        <td><small>${details}</small></td>
        <td><small>${log.ip_address || '-'}</small></td>
        <td><small>${date}</small></td>
      </tr>
    `;
  }).join('');
}

function formatAction(action) {
  const actionMap = {
    'login': '🔓 Вход',
    'logout': '🔒 Выход',
    'login_failed': '❌ Неудачный вход',
    'password_reset_requested': '🔑 Запрос сброса пароля',
    'password_reset': '✅ Пароль сброшен',
    'admin_create_user': '➕ Создан пользователь',
    'admin_update_user': '✏️ Обновлен пользователь',
    'admin_delete_user': '🗑️ Удален пользователь',
    'admin_reset_password': '🔑 Сброс пароля админом'
  };

  return actionMap[action] || action;
}

// === Modal Management ===

export function openAdminPanel() {
  const modal = document.getElementById('adminModal');
  if (modal) {
    modal.classList.add('active');
    // Load users by default
    switchAdminTab('users');
  }
}

export function closeAdminPanel() {
  const modal = document.getElementById('adminModal');
  if (modal) {
    modal.classList.remove('active');
  }
}

export function switchAdminTab(tabName) {
  // Update tab buttons
  document.querySelectorAll('.admin-tab').forEach(tab => {
    tab.classList.remove('active');
  });
  document.querySelector(`[data-tab="${tabName}"]`)?.classList.add('active');

  // Update content
  document.querySelectorAll('.admin-tab-content').forEach(content => {
    content.style.display = 'none';
  });

  const content = document.getElementById(`adminTab${tabName.charAt(0).toUpperCase() + tabName.slice(1)}`);
  if (content) {
    content.style.display = 'block';
  }

  // Load data
  if (tabName === 'users') {
    refreshUsers();
  } else if (tabName === 'activity') {
    refreshActivity();
  }
}

export async function refreshUsers() {
  const users = await loadUsers();
  renderUsersTable(users);
}

export async function refreshActivity() {
  // Populate user filter
  await populateUserFilter();

  const filterSelect = document.getElementById('activityUserFilter');
  const userId = filterSelect ? filterSelect.value : null;
  const logs = await loadActivity(userId || null, 100);
  renderActivityTable(logs);
}

async function populateUserFilter() {
  const filterSelect = document.getElementById('activityUserFilter');
  if (!filterSelect) return;

  // Save current selection
  const currentValue = filterSelect.value;

  // Load all users
  const users = await loadUsers();

  // Clear existing options (except "All users")
  filterSelect.innerHTML = '<option value="">Все пользователи</option>';

  // Add user options
  users.forEach(user => {
    const option = document.createElement('option');
    option.value = user.id;
    option.textContent = `${user.username} (${user.email})`;
    filterSelect.appendChild(option);
  });

  // Restore selection
  if (currentValue) {
    filterSelect.value = currentValue;
  }
}

export async function openUserForm(userId = null) {
  const modal = document.getElementById('userFormModal');
  const title = document.getElementById('userFormTitle');
  const form = document.getElementById('userForm');
  const passwordGroup = document.getElementById('passwordGroup');

  if (!modal || !form) return;

  // Открываем модальное окно СНАЧАЛА
  modal.classList.add('active');

  if (userId) {
    // Edit mode
    title.textContent = 'Редактировать пользователя';
    document.getElementById('userId').value = userId;
    passwordGroup.style.display = 'none';
    document.getElementById('userPassword').removeAttribute('required');

    // Load user data ПОСЛЕ открытия модального окна с задержкой
    await new Promise(resolve => setTimeout(resolve, 300));
    await loadUserData(userId);
  } else {
    // Create mode
    // Reset form only for new user
    form.reset();
    title.textContent = 'Добавить пользователя';
    document.getElementById('userId').value = '';
    passwordGroup.style.display = 'block';
    document.getElementById('userPassword').setAttribute('required', 'required');
  }
}

export function closeUserForm() {
  const modal = document.getElementById('userFormModal');
  if (modal) {
    modal.classList.remove('active');
  }
}

async function loadUserData(userId) {
  const users = await loadUsers();
  // Преобразуем userId в число для корректного сравнения
  const numericUserId = parseInt(userId);
  const user = users.find(u => u.id === numericUserId);

  if (user) {
    const emailField = document.getElementById('userEmail');
    const usernameField = document.getElementById('userUsername');

    // Очищаем и устанавливаем значения
    emailField.value = '';
    usernameField.value = '';

    emailField.value = user.email || '';
    usernameField.value = user.username || '';


    document.getElementById('userIsAdmin').checked = user.is_admin;
    document.getElementById('userIsActive').checked = user.is_active;

    // Set schema checkboxes
    const schemaList = getSchemaList();
    schemaList.forEach(schema => {
      const checkbox = document.getElementById(`schema_${schema.value}`);
      if (checkbox) {
        checkbox.checked = user.schemas.includes(schema.value);
      }
    });
  }
}

export async function saveUser(formData) {
  const userId = formData.get('userId');
  const isEdit = userId && userId !== '';

  const userData = {
    username: formData.get('username'),
    email: formData.get('email'),
    is_admin: formData.get('is_admin') === 'on',
    is_active: formData.get('is_active') === 'on',
    schemas: []
  };

  // Collect selected schemas
  const schemaList = getSchemaList();
  schemaList.forEach(schema => {
    if (formData.get(`schema_${schema.value}`) === 'on') {
      userData.schemas.push(schema.value);
    }
  });

  if (!isEdit) {
    userData.password = formData.get('password');
  }

  let result;
  if (isEdit) {
    result = await updateUser(parseInt(userId), userData);
  } else {
    result = await createUser(userData);
  }

  return result;
}
