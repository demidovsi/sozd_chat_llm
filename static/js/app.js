/**
 * Главный файл приложения (модульная версия)
 */

import { el, normalizeUserMessage } from './modules/utils.js';
import { state, setState, loadState, saveState, getActiveChat, setCurrentAbortController, setIsGenerating, setLastUserMessageCache, currentAbortController, isGenerating, lastUserMessageCache, dbSchema, setDbSchema, createChat, queryMode, setQueryMode, getCurrentMode } from './modules/state.js';
import { initTheme } from './modules/theme.js';
import { renderAll, renderChatList, renderMessages, fakeStreamAnswer, setElements } from './modules/render.js';
import { newChat, clearMessages, exportJSON, toggleAllMessages, updateToggleAllButton, getLastUserMessage } from './modules/actions.js';
import { setGenerating, setOverlay, autoGrow, canSendOnEnter, withUiBusy, setOverlayText } from './modules/ui.js';
import { VoiceInput } from './modules/voice.js';
import { config, getModesForSchema, getModeConfig } from './modules/config.js';
import { getApiVersion, clearApiCache, clearSchemaCache, clearQueryCache } from './modules/api.js';
import { getCurrentUser, getAvailableSchemasWithLabels, logout, isAdmin } from './modules/auth.js';
import * as admin from './modules/admin.js';

// ============================================================================
// История ввода
// ============================================================================
let inputHistory = []; // Массив истории сообщений пользователя
let historyIndex = -1;  // Текущая позиция в истории (-1 = не в истории)
let currentDraft = "";  // Текущий черновик при навигации по истории

/**
 * Получает историю сообщений пользователя из текущего чата
 */
function getUserMessageHistory() {
  const chat = getActiveChat();
  if (!chat) return [];
  return chat.messages
    .filter(m => m.role === "user")
    .map(m => m.content || "")
    .filter(content => content.trim() !== "");
}

/**
 * Обновляет историю сообщений
 */
function updateInputHistory() {
  inputHistory = getUserMessageHistory();
  historyIndex = -1;
  currentDraft = "";
}

/**
 * Проверяет, находится ли курсор в самом начале поля ввода
 */
function isCursorAtStart(textarea) {
  return textarea.selectionStart === 0;
}

/**
 * Проверяет, находится ли курсор в самом конце поля ввода
 */
function isCursorAtEnd(textarea) {
  return textarea.selectionEnd === textarea.value.length;
}

// Инициализация при загрузке DOM
document.addEventListener("DOMContentLoaded", async () => {
  const startTime = performance.now();
  console.log('DOM loaded, starting initialization...');

  // Check authentication first
  const user = await getCurrentUser();
  if (!user) {
    console.log('Not authenticated, redirecting to login...');
    window.location.href = '/login';
    return;
  }
  console.log('Authenticated as:', user.username);

  // Получение элементов
  const chatListEl = el("chatList");
  const messagesEl = el("messages");
  const chatTitleEl = el("chatTitle");
  const searchInputEl = el("searchInput");
  const newChatBtn = el("newChatBtn");
  const clearBtn = el("clearBtn");
  const exportBtn = el("exportBtn");
  const toggleAllBtn = el("toggleAllBtn");

  const composerForm = el("composerForm");
  const promptInput = el("promptInput");
  const sendBtn = el("sendBtn");
  const voiceBtn = el("voiceBtn");
  const clearQueryCacheBtn = el("clearQueryCacheBtn");

  const themeSelect = el("themeSelect");
  const themeToggleBtn = el("themeToggle");
  const genOverlay = el("genOverlay");

  const scrollToEndBtn = el("scrollToEndBtn");
  const scrollToTopBtn = el("scrollToTopBtn");
  const versionInfoEl = el("versionInfo");
  const queryModeTabsEl = el("queryModeTabs");
  const dbSchemaSelect = el("dbSchemaSelect");

  const toolsBtn = el("toolsBtn");
  const toolsMenu = el("toolsMenu");
  const showVersionBtn = el("showVersionBtn");
  const clearCacheBtn = el("clearCacheBtn");
  const clearSchemaCacheBtn = el("clearSchemaCacheBtn");
  const adminPanelMenuItem = el("adminPanelMenuItem");
  const newLoginMenuItem = el("newLoginMenuItem");

  const logoutBtn = el("logoutBtn");
  const userName = el("userName");
  const userEmail = el("userEmailDisplay");
  const userAvatar = el("userAvatar");

  // Проверка элементов
  if (!chatListEl || !messagesEl || !chatTitleEl) {
    console.error("Core UI elements not found");
    return;
  }
  if (!composerForm || !promptInput || !sendBtn) {
    console.error("Composer elements not found");
    return;
  }

  // Передаем элементы в модуль render
  setElements({ chatListEl, messagesEl, chatTitleEl, searchInputEl, promptInput });

  // Update user UI
  if (userName) userName.textContent = user.username;
  if (userEmail) userEmail.textContent = user.email;
  if (userAvatar) userAvatar.textContent = user.username.charAt(0).toUpperCase();

  // Show admin menu item if user is admin
  if (isAdmin() && adminPanelMenuItem) {
    adminPanelMenuItem.style.display = 'flex';
  }

  // Logout handler
  if (logoutBtn) {
    logoutBtn.addEventListener('click', async () => {
      await logout();
      window.location.href = '/login';
    });
  }

  // Admin panel handler
  if (adminPanelMenuItem) {
    adminPanelMenuItem.addEventListener('click', () => {
      if (toolsMenu) toolsMenu.style.display = 'none';
      admin.openAdminPanel();
    });
  }

  // New login handler
  if (newLoginMenuItem) {
    newLoginMenuItem.addEventListener('click', async () => {
      if (toolsMenu) toolsMenu.style.display = 'none';
      if (confirm('Вы уверены, что хотите выйти и войти под другим пользователем?')) {
        await logout();
        window.location.href = '/login';
      }
    });
  }

  // Global functions for admin panel (called from HTML onclick)
  window.editUser = (userId) => {
    admin.openUserForm(userId);
  };

  window.deleteUserConfirm = async (userId) => {
    if (confirm('Вы уверены, что хотите удалить этого пользователя?')) {
      const result = await admin.deleteUser(userId);
      if (result.success) {
        alert('Пользователь удален');
        admin.refreshUsers();
      } else {
        alert('Ошибка: ' + (result.message || 'Не удалось удалить пользователя'));
      }
    }
  };

  window.resetPassword = async (userId) => {
    const newPassword = prompt('Введите новый пароль (минимум 6 символов):');
    if (newPassword && newPassword.length >= 6) {
      const result = await admin.resetUserPassword(userId, newPassword);
      if (result.success) {
        alert('Пароль успешно сброшен');
      } else {
        alert('Ошибка: ' + (result.message || 'Не удалось сбросить пароль'));
      }
    } else if (newPassword !== null) {
      alert('Пароль должен содержать минимум 6 символов');
    }
  };

  // Toggle cell text expansion
  window.toggleCellText = (button) => {
    const container = button.closest('.cell-text-truncated');
    if (!container) return;

    const shortText = container.querySelector('.cell-text-short');
    const fullText = container.querySelector('.cell-text-full');

    if (shortText && fullText) {
      const isExpanded = fullText.style.display !== 'none';

      if (isExpanded) {
        // Collapse
        shortText.style.display = shortText.tagName === 'TEXTAREA' ? 'block' : '';
        fullText.style.display = 'none';
        button.textContent = 'читать далее';
        button.title = 'Показать полный текст';

        // Если это textarea, пересчитываем высоту
        if (shortText.tagName === 'TEXTAREA') {
          requestAnimationFrame(() => {
            shortText.style.height = 'auto';
            shortText.style.height = (shortText.scrollHeight + 4) + 'px';
          });
        }
      } else {
        // Expand
        shortText.style.display = 'none';
        fullText.style.display = fullText.tagName === 'TEXTAREA' ? 'block' : '';
        button.textContent = 'свернуть';
        button.title = 'Скрыть полный текст';

        // Если это textarea, пересчитываем высоту
        if (fullText.tagName === 'TEXTAREA') {
          requestAnimationFrame(() => {
            fullText.style.height = 'auto';
            fullText.style.height = (fullText.scrollHeight + 4) + 'px';
          });
        }
      }
    }
  };

  // Admin panel event listeners
  const addUserBtn = el("addUserBtn");
  if (addUserBtn) {
    addUserBtn.addEventListener('click', () => {
      admin.openUserForm();
    });
  }

  // Admin tabs
  document.querySelectorAll('.admin-tab').forEach(tab => {
    tab.addEventListener('click', (e) => {
      const tabName = e.target.getAttribute('data-tab');
      admin.switchAdminTab(tabName);
    });
  });

  // Close modal buttons
  document.querySelectorAll('.close-modal').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const modal = e.target.closest('.modal');
      if (modal) {
        modal.classList.remove('active');
      }
    });
  });

  // Close modal on background click
  document.querySelectorAll('.modal').forEach(modal => {
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        modal.classList.remove('active');
      }
    });
  });

  // User form submission
  const userForm = el("userForm");
  if (userForm) {
    userForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      const formData = new FormData(userForm);
      const result = await admin.saveUser(formData);

      if (result.success) {
        alert('Пользователь сохранен');
        admin.closeUserForm();
        admin.refreshUsers();
      } else {
        alert('Ошибка: ' + (result.message || 'Не удалось сохранить пользователя'));
      }
    });
  }

  // Activity filter
  const refreshActivityBtn = el("refreshActivityBtn");
  if (refreshActivityBtn) {
    refreshActivityBtn.addEventListener('click', () => {
      admin.refreshActivity();
    });
  }

  // Auto-refresh activity on user filter change
  const activityUserFilter = el("activityUserFilter");
  if (activityUserFilter) {
    activityUserFilter.addEventListener('change', () => {
      admin.refreshActivity();
    });
  }

  // Загрузка состояния
  const loadedState = loadState();
  setState(loadedState);

  // Инициализация темы
  initTheme(themeSelect, themeToggleBtn);

  /** ---------- Query Mode Tabs ---------- **/
  /**
   * Функция для динамического создания кнопок режимов для текущей схемы
   */
  function renderModeTabs() {
    if (!queryModeTabsEl) return;

    // Очищаем существующие кнопки
    queryModeTabsEl.innerHTML = '';

    // Получаем доступные режимы для текущей схемы
    const availableModes = getModesForSchema(dbSchema);

    // Создаём кнопки для каждого режима
    Object.values(availableModes).forEach(mode => {
      const tab = document.createElement('button');
      tab.className = 'mode-tab';
      tab.dataset.mode = mode.id;
      tab.title = mode.description;

      const icon = document.createElement('span');
      icon.className = 'mode-tab-icon';
      icon.textContent = mode.icon;

      const label = document.createElement('span');
      label.className = 'mode-tab-label';
      label.textContent = mode.label;

      tab.appendChild(icon);
      tab.appendChild(label);
      queryModeTabsEl.appendChild(tab);

      // Обработчик клика на режим
      tab.addEventListener('click', () => {
        const newMode = mode.id;
        if (newMode === queryMode) return; // Уже активен

        setQueryMode(newMode);
        console.log(`Query Mode changed to: ${newMode}`);

        // Обновляем активную вкладку
        queryModeTabsEl.querySelectorAll('.mode-tab').forEach(t => {
          t.classList.toggle('active', t.dataset.mode === newMode);
        });

        // Ищем чаты для нового режима и текущей схемы
        const modeChats = state.chats.filter(c =>
          c.mode === newMode && c.schema === dbSchema
        );

        if (modeChats.length > 0) {
          // Переключаемся на первый чат нового режима
          state.activeChatId = modeChats[0].id;
          saveState();
        } else {
          // Создаём новый чат для нового режима
          const newChat = createChat("New chat", dbSchema, newMode);
          state.chats.push(newChat);
          state.activeChatId = newChat.id;
          saveState();
        }

        // Перерендериваем UI
        renderAll();
      });
    });

    // Устанавливаем активную вкладку
    queryModeTabsEl.querySelectorAll('.mode-tab').forEach(tab => {
      tab.classList.toggle('active', tab.dataset.mode === queryMode);
    });
  }

  // Инициализируем кнопки режимов для текущей схемы
  renderModeTabs();

  /** ---------- DB Schema Select ---------- **/
  if (dbSchemaSelect) {
    // Загружаем доступные схемы для текущего пользователя
    const availableSchemas = await getAvailableSchemasWithLabels();

    // Очищаем существующие опции
    dbSchemaSelect.innerHTML = '';

    // Заполняем select только доступными схемами
    availableSchemas.forEach(schema => {
      const option = document.createElement('option');
      option.value = schema.value;
      option.textContent = schema.label;
      dbSchemaSelect.appendChild(option);
    });

    // Устанавливаем текущее значение если оно доступно
    if (dbSchema && availableSchemas.some(s => s.value === dbSchema)) {
      dbSchemaSelect.value = dbSchema;
    } else if (availableSchemas.length > 0) {
      // Если текущая схема недоступна, выбираем первую доступную
      setDbSchema(availableSchemas[0].value);
      dbSchemaSelect.value = availableSchemas[0].value;
    }

    // Обработчик изменения схемы
    dbSchemaSelect.addEventListener('change', (e) => {
      const newSchema = e.target.value;
      setDbSchema(newSchema);
      console.log(`DB Schema changed to: ${newSchema}`);

      // Проверяем, существует ли текущий режим для новой схемы
      const availableModes = getModesForSchema(newSchema);
      let targetMode = queryMode;

      if (!availableModes[queryMode]) {
        // Текущий режим недоступен для новой схемы - выбираем первый доступный
        targetMode = Object.keys(availableModes)[0] || 'sql';
        setQueryMode(targetMode);
        console.log(`Mode changed to ${targetMode} (was unavailable for new schema)`);
      }

      // КРИТИЧНО: Пересоздаем кнопки режимов для новой схемы
      renderModeTabs();

      // Ищем чаты для новой схемы и текущего (или обновленного) режима
      const schemaChats = state.chats.filter(c =>
        c.schema === newSchema && c.mode === targetMode
      );

      if (schemaChats.length > 0) {
        // Переключаемся на первый чат новой схемы
        state.activeChatId = schemaChats[0].id;
        saveState();
      } else {
        // Создаём новый чат для новой схемы и режима
        const newChat = createChat("New chat", newSchema, targetMode);
        state.chats.push(newChat);
        state.activeChatId = newChat.id;
        saveState();
      }

      // Перерендериваем UI
      renderAll();
    });
  }

  /** ---------- Voice Input ---------- **/
  let voiceInput = null;
  if (VoiceInput.isSupported()) {
    voiceInput = new VoiceInput();

    // Callback для распознанного текста
    voiceInput.onTranscript = (transcript, isFinal) => {
      if (isFinal) {
        // Вставляем текст в текущую позицию курсора
        const currentValue = promptInput.value;
        const cursorPos = promptInput.selectionStart || currentValue.length;
        const newValue = currentValue.slice(0, cursorPos) + transcript + ' ' + currentValue.slice(cursorPos);
        promptInput.value = newValue;

        // Устанавливаем курсор после вставленного текста
        const newCursorPos = cursorPos + transcript.length + 1;
        promptInput.selectionStart = promptInput.selectionEnd = newCursorPos;

        // Автоматически расширяем textarea
        autoGrow(promptInput);
        promptInput.focus();
      }
    };

    // Callback для изменения состояния
    voiceInput.onStateChange = (state, error) => {
      voiceBtn.classList.remove('recording', 'processing', 'error');

      switch (state) {
        case 'recording':
          voiceBtn.classList.add('recording');
          voiceBtn.title = 'Остановить запись';
          break;
        case 'processing':
          voiceBtn.classList.add('processing');
          voiceBtn.title = 'Обработка...';
          break;
        case 'error':
          voiceBtn.classList.add('error');
          voiceBtn.title = `Ошибка: ${error}`;
          // Сбросить состояние ошибки через 3 секунды
          setTimeout(() => {
            voiceBtn.classList.remove('error');
            voiceBtn.title = 'Голосовой ввод';
          }, 3000);
          break;
        default: // 'idle'
          voiceBtn.title = 'Голосовой ввод';
      }
    };

    // Установить язык по умолчанию (умное автоопределение)
    voiceInput.setLanguage('auto');
  } else {
    // Скрываем кнопку, если браузер не поддерживает Web Speech API
    if (voiceBtn) voiceBtn.style.display = 'none';
  }

  /** ---------- Scroll controls ---------- **/
  function scrollToBottom() {
    messagesEl.scrollTop = messagesEl.scrollHeight;
  }

  function scrollToTop() {
    messagesEl.scrollTop = 0;
  }

  scrollToEndBtn?.addEventListener("click", () => {
    scrollToBottom();
  });

  scrollToTopBtn?.addEventListener("click", () => {
    scrollToTop();
  });

  /** ---------- Chat controls ---------- **/
  newChatBtn?.addEventListener("click", () => newChat(promptInput, renderAll));
  clearBtn?.addEventListener("click", () => clearMessages(renderMessages, chatTitleEl, renderChatList));
  exportBtn?.addEventListener("click", exportJSON);
  searchInputEl?.addEventListener("input", renderChatList);
  toggleAllBtn?.addEventListener("click", () => toggleAllMessages(toggleAllBtn, renderMessages));

  /** ---------- Tools menu ---------- **/
  toolsBtn?.addEventListener("click", (e) => {
    e.stopPropagation();
    const isVisible = toolsMenu.style.display !== 'none';
    toolsMenu.style.display = isVisible ? 'none' : 'block';
  });

  // Закрытие меню при клике вне его
  document.addEventListener("click", (e) => {
    if (toolsMenu && toolsMenu.style.display !== 'none') {
      if (!toolsMenu.contains(e.target) && e.target !== toolsBtn) {
        toolsMenu.style.display = 'none';
      }
    }
  });

  showVersionBtn?.addEventListener("click", async () => {
    toolsMenu.style.display = 'none';
    try {
      const version = await getApiVersion();
      const versionWithUrl = {
        ...version,
        URL_api: config.URL,
        URL_rest: config.URL_rest
      };
      alert(`Версия API:\n\n${JSON.stringify(versionWithUrl, null, 2)}`);
    } catch (error) {
      alert(`Ошибка получения версии:\n${error.message}`);
    }
  });

  clearCacheBtn?.addEventListener("click", async () => {
    toolsMenu.style.display = 'none';
    if (!confirm('Вы уверены, что хотите очистить кэш API?')) {
      return;
    }
    try {
      const result = await clearApiCache();
      alert(`Кэш очищен:\n\n${JSON.stringify(result, null, 2)}`);
    } catch (error) {
      alert(`Ошибка очистки кэша:\n${error.message}`);
    }
  });

  clearSchemaCacheBtn?.addEventListener("click", async () => {
    toolsMenu.style.display = 'none';
    const schemaName = DB_SCHEMAS.find(s => s.value === dbSchema)?.label || dbSchema;
    if (!confirm(`Вы уверены, что хотите очистить кэш для схемы "${schemaName}"?`)) {
      return;
    }
    try {
      const result = await clearSchemaCache(dbSchema);
      alert(`Кэш схемы "${schemaName}" очищен:\n\n${JSON.stringify(result, null, 2)}`);
    } catch (error) {
      alert(`Ошибка очистки кэша схемы:\n${error.message}`);
    }
  });

  /** ---------- Composer ---------- **/

  // Функция для обновления видимости кнопки очистки кэша запроса
  function updateClearQueryCacheButton() {
    if (clearQueryCacheBtn) {
      const hasText = promptInput.value.trim().length > 0;
      clearQueryCacheBtn.style.display = hasText ? 'flex' : 'none';
    }
  }

  promptInput.addEventListener("input", () => {
    autoGrow(promptInput);
    updateClearQueryCacheButton();
  });

  // Обработчик вставки текста
  promptInput.addEventListener("paste", () => {
    setTimeout(() => {
      autoGrow(promptInput);
      updateClearQueryCacheButton();
    }, 0);
  });

  // Обработчик для кнопки очистки кэша запроса
  clearQueryCacheBtn?.addEventListener("click", async (e) => {
    e.preventDefault();
    const userText = promptInput.value.trim();
    if (!userText) return;

    if (!confirm('Очистить кэш для этого запроса?')) {
      return;
    }

    try {
      const result = await clearQueryCache(userText, dbSchema);
      alert(`Кэш запроса очищен:\n\n${JSON.stringify(result, null, 2)}`);
    } catch (error) {
      alert(`Ошибка очистки кэша запроса:\n${error.message}`);
    }
  });

  sendBtn.addEventListener("click", (e) => {
    e.preventDefault();
    if (typeof composerForm.requestSubmit === "function") {
      composerForm.requestSubmit();
    } else {
      composerForm.dispatchEvent(new Event("submit", { cancelable: true }));
    }
  });

  voiceBtn?.addEventListener("click", (e) => {
    e.preventDefault();
    if (voiceInput) {
      voiceInput.toggle();
    }
  });

  promptInput.addEventListener("keydown", (e) => {
    // ⭐ ArrowUp: навигация назад по истории (только если курсор в самом начале)
    if (e.key === "ArrowUp") {
      if (isCursorAtStart(promptInput)) {
        // Обновляем историю перед навигацией
        if (historyIndex === -1) {
          updateInputHistory();
          currentDraft = promptInput.value; // Сохраняем текущий ввод
        }

        // Проверяем, можем ли двигаться назад
        if (inputHistory.length > 0 && historyIndex < inputHistory.length - 1) {
          e.preventDefault();
          historyIndex++;
          promptInput.value = inputHistory[inputHistory.length - 1 - historyIndex];
          autoGrow(promptInput);
          updateClearQueryCacheButton();
          // Курсор остаётся на месте (в начале)
        }
      }
      return;
    }

    // ⭐ ArrowDown: навигация вперёд по истории (только если курсор в самом конце)
    if (e.key === "ArrowDown") {
      if (isCursorAtEnd(promptInput)) {
        // Проверяем, находимся ли мы в режиме навигации по истории
        if (historyIndex > -1) {
          e.preventDefault();
          historyIndex--;

          if (historyIndex === -1) {
            // Вернулись к текущему черновику
            promptInput.value = currentDraft;
            currentDraft = "";
          } else {
            // Переходим к следующему сообщению в истории
            promptInput.value = inputHistory[inputHistory.length - 1 - historyIndex];
          }

          autoGrow(promptInput);
          updateClearQueryCacheButton();
          // Курсор остаётся на месте (в конце)
        }
      }
      return;
    }

    if (e.key === "Enter" && !e.shiftKey) {
      if (canSendOnEnter(promptInput)) {
        e.preventDefault();
        if (typeof composerForm.requestSubmit === "function") {
          composerForm.requestSubmit();
        } else {
          composerForm.dispatchEvent(new Event("submit", { cancelable: true }));
        }
      }
    }
  });

  composerForm.addEventListener("submit", async (e) => {
    e.preventDefault();

    if (isGenerating && currentAbortController) {
      currentAbortController.abort();
      // Сбрасываем флаги после abort
      setGenerating(sendBtn, false);
      setIsGenerating(false);
      setOverlay(genOverlay, false);
      setCurrentAbortController(null);
      if (voiceBtn) voiceBtn.disabled = false;
      return;
    }

    const rawText = promptInput.value || "";
    const text = normalizeUserMessage(rawText);
    if (!text) return;

    // ⭐ Сбрасываем навигацию по истории при отправке
    historyIndex = -1;
    currentDraft = "";

    const chat = getActiveChat();
    if (chat.title === "New chat") chat.title = text.slice(0, 40);

    // userMsg — теперь отдельный объект, чтобы сохранить на нём тайминги REST
    const userMsg = {
      id: crypto.randomUUID(),
      role: "user",
      content: text
    };
    chat.messages.push(userMsg);

    const assistantMsg = {
      id: crypto.randomUUID(),
      role: "assistant",
      content: "",
      sql: "",
      params: null,
      sqlOpen: false,
      error: false,
      table: null,
      csv: null
    };

    chat.messages.push(assistantMsg);

    promptInput.value = "";
    promptInput.style.height = "auto";
    promptInput.style.overflowY = "hidden";
    autoGrow(promptInput);
    updateClearQueryCacheButton();

    saveState();
    renderAll();

    const abortController = new AbortController();
    setCurrentAbortController(abortController);
    setGenerating(sendBtn, true);
    setIsGenerating(true);
    setOverlay(genOverlay, true);
    setOverlayText("Generating response…");
    if (voiceBtn) voiceBtn.disabled = true;

    try {
      await fakeStreamAnswer(text, assistantMsg, userMsg, abortController.signal);
    } catch (err) {
      if (err?.name !== "AbortError") {
        assistantMsg.error = true;
        assistantMsg.content += `\n\n⚠️ Error: ${err?.message || err}`;
        renderMessages();
      }
    } finally {
      setGenerating(sendBtn, false);
      setIsGenerating(false);
      setOverlay(genOverlay, false);
      setCurrentAbortController(null);
      if (voiceBtn) voiceBtn.disabled = false;
      saveState();
      renderMessages();
    }
  });

  // Первый рендер
  renderAll();
  promptInput.focus();

  // Загрузка и отображение версии
  async function loadVersion() {
    try {
      const response = await fetch('/api/version');
      if (response.ok) {
        const data = await response.json();
        if (versionInfoEl && data.version && data.date) {
          versionInfoEl.textContent = `v${data.version} (${data.date})`;
        }
      }
    } catch (err) {
      console.error('Failed to load version:', err);
    }
  }
  loadVersion();

  // Статистика производительности
  const endTime = performance.now();
  console.log(`Total initialization time: ${(endTime - startTime).toFixed(2)}ms`);

  // Проверка размера localStorage
  const storageSize = new Blob([JSON.stringify(localStorage)]).size;
  console.log(`LocalStorage size: ${(storageSize / 1024).toFixed(2)} KB`);

  // Количество чатов и сообщений
  console.log(`Chats: ${state.chats.length}, Messages: ${state.chats.reduce((sum, c) => sum + c.messages.length, 0)}`);

  // Cleanup при выгрузке страницы
  window.addEventListener('beforeunload', () => {
    if (voiceInput) {
      voiceInput.destroy();
    }
  });

  console.log('Initialization complete');
});
