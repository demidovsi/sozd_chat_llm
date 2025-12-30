/**
 * Login page functionality
 */

// DOM elements
const loginForm = document.getElementById('loginForm');
const loginBtn = document.getElementById('loginBtn');
const errorMessage = document.getElementById('errorMessage');
const successMessage = document.getElementById('successMessage');
const forgotPasswordLink = document.getElementById('forgotPasswordLink');
const resetPasswordModal = document.getElementById('resetPasswordModal');
const requestResetForm = document.getElementById('requestResetForm');
const resetPasswordForm = document.getElementById('resetPasswordForm');
const resetStep1 = document.getElementById('resetStep1');
const resetStep2 = document.getElementById('resetStep2');
const resetError = document.getElementById('resetError');
const resetSuccess = document.getElementById('resetSuccess');

// Login form submission
loginForm.addEventListener('submit', async (e) => {
  e.preventDefault();

  const username = document.getElementById('username').value;
  const password = document.getElementById('password').value;
  const rememberMe = document.getElementById('rememberMe').checked;

  hideMessages();

  // Disable button during request
  loginBtn.disabled = true;
  loginBtn.textContent = 'Вход...';

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
      // Login successful
      showSuccess('Вход выполнен успешно! Перенаправление...');

      // Wait a bit for user to see the message
      setTimeout(() => {
        window.location.href = '/';
      }, 500);
    } else {
      // Login failed
      showError(data.message || 'Неверное имя пользователя или пароль');
      loginBtn.disabled = false;
      loginBtn.textContent = 'Войти';
    }
  } catch (error) {
    console.error('Login error:', error);
    showError('Ошибка соединения с сервером');
    loginBtn.disabled = false;
    loginBtn.textContent = 'Войти';
  }
});

// Forgot password link
forgotPasswordLink.addEventListener('click', (e) => {
  e.preventDefault();
  openResetModal();
});

// Request reset form
requestResetForm.addEventListener('submit', async (e) => {
  e.preventDefault();

  const email = document.getElementById('resetEmail').value;

  hideResetMessages();

  try {
    const response = await fetch('/api/auth/request-password-reset', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email })
    });

    const data = await response.json();

    if (response.ok && data.success) {
      // Show token (in production, this would be sent by email)
      if (data.token) {
        document.getElementById('resetToken').textContent = data.token;
        document.getElementById('resetTokenInput').value = data.token;
        resetStep1.classList.add('hidden');
        resetStep2.classList.remove('hidden');
        showResetSuccess('Токен восстановления сгенерирован');
      } else {
        showResetSuccess(data.message);
      }
    } else {
      showResetError(data.message || 'Ошибка запроса токена');
    }
  } catch (error) {
    console.error('Password reset request error:', error);
    showResetError('Ошибка соединения с сервером');
  }
});

// Reset password form
resetPasswordForm.addEventListener('submit', async (e) => {
  e.preventDefault();

  const token = document.getElementById('resetTokenInput').value;
  const newPassword = document.getElementById('newPassword').value;

  hideResetMessages();

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

    if (response.ok && data.success) {
      showResetSuccess('Пароль успешно изменен! Можете войти с новым паролем.');

      // Close modal after delay
      setTimeout(() => {
        closeResetModal();
        // Clear form
        loginForm.reset();
      }, 2000);
    } else {
      showResetError(data.message || 'Ошибка сброса пароля');
    }
  } catch (error) {
    console.error('Password reset error:', error);
    showResetError('Ошибка соединения с сервером');
  }
});

// Close modal buttons
document.querySelectorAll('.close-modal').forEach(btn => {
  btn.addEventListener('click', closeResetModal);
});

// Close modal on background click
resetPasswordModal.addEventListener('click', (e) => {
  if (e.target === resetPasswordModal) {
    closeResetModal();
  }
});

// Helper functions
function showError(message) {
  errorMessage.textContent = message;
  errorMessage.style.display = 'block';
  successMessage.style.display = 'none';
}

function showSuccess(message) {
  successMessage.textContent = message;
  successMessage.style.display = 'block';
  errorMessage.style.display = 'none';
}

function hideMessages() {
  errorMessage.style.display = 'none';
  successMessage.style.display = 'none';
}

function showResetError(message) {
  resetError.textContent = message;
  resetError.style.display = 'block';
  resetSuccess.style.display = 'none';
}

function showResetSuccess(message) {
  resetSuccess.textContent = message;
  resetSuccess.style.display = 'block';
  resetError.style.display = 'none';
}

function hideResetMessages() {
  resetError.style.display = 'none';
  resetSuccess.style.display = 'none';
}

function openResetModal() {
  resetPasswordModal.classList.add('active');
  // Reset to step 1
  resetStep1.classList.remove('hidden');
  resetStep2.classList.add('hidden');
  hideResetMessages();
  requestResetForm.reset();
  resetPasswordForm.reset();
}

function closeResetModal() {
  resetPasswordModal.classList.remove('active');
}
