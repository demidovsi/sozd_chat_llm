/**
 * Главный файл приложения (модульная версия)
 */

import { el, normalizeUserMessage } from './modules/utils.js';
import { state, setState, loadState, saveState, getActiveChat, setCurrentAbortController, setIsGenerating, setLastUserMessageCache, currentAbortController, isGenerating, lastUserMessageCache } from './modules/state.js';
import { initTheme } from './modules/theme.js';
import { renderAll, renderChatList, renderMessages, fakeStreamAnswer, setElements } from './modules/render.js';
import { newChat, clearMessages, exportJSON, toggleAllMessages, updateToggleAllButton, getLastUserMessage } from './modules/actions.js';
import { setGenerating, setOverlay, autoGrow, canSendOnEnter, withUiBusy } from './modules/ui.js';
import { VoiceInput } from './modules/voice.js';

// Инициализация при загрузке DOM
document.addEventListener("DOMContentLoaded", () => {
  const startTime = performance.now();
  console.log('DOM loaded, starting initialization...');

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

  const themeSelect = el("themeSelect");
  const themeToggleBtn = el("themeToggle");
  const genOverlay = el("genOverlay");

  const scrollToEndBtn = el("scrollToEndBtn");
  const scrollToTopBtn = el("scrollToTopBtn");
  const versionInfoEl = el("versionInfo");

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

  // Загрузка состояния
  const loadedState = loadState();
  setState(loadedState);

  // Инициализация темы
  initTheme(themeSelect, themeToggleBtn);

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

    // Установить язык по умолчанию (автоопределение)
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
  clearBtn?.addEventListener("click", () => clearMessages(renderMessages));
  exportBtn?.addEventListener("click", exportJSON);
  searchInputEl?.addEventListener("input", renderChatList);
  toggleAllBtn?.addEventListener("click", () => toggleAllMessages(toggleAllBtn, renderMessages));

  /** ---------- Composer ---------- **/
  promptInput.addEventListener("input", () => autoGrow(promptInput));

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
    if (e.key === "ArrowUp") {
      const value = promptInput.value;
      const cursorPos = promptInput.selectionStart;
      if (!value && cursorPos === 0) {
        e.preventDefault();
        const last = getLastUserMessage();
        if (last) {
          setLastUserMessageCache(last);
          promptInput.value = last;
          autoGrow(promptInput);
          requestAnimationFrame(() => {
            promptInput.selectionStart = promptInput.selectionEnd = last.length;
          });
        }
      }
      return;
    }

    if (e.key === "ArrowDown") {
      if (promptInput.value === lastUserMessageCache) {
        e.preventDefault();
        promptInput.value = "";
        autoGrow(promptInput);
        setLastUserMessageCache("");
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
      return;
    }

    const rawText = promptInput.value || "";
    const text = normalizeUserMessage(rawText);
    if (!text) return;

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

    saveState();
    renderAll();

    const abortController = new AbortController();
    setCurrentAbortController(abortController);
    setGenerating(sendBtn, true);
    setIsGenerating(true);
    setOverlay(genOverlay, true);
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
