/**
 * Модуль рендеринга интерфейса
 */

import { state, saveState, getActiveChat, dbSchema, getCurrentMode } from './state.js';
import { copyToClipboard, makeLinksOpenInNewTab, isArrayOfObjects, getColumnsFromRows, downloadFromGCS, hasParams, downloadTextFile } from './utils.js';
import { escapeCell, toCsv, formatTimeForMeta, formatDurationMs, formatExecuteResult } from './formatters.js';
import { buildSqlWithParams, renderMarkdownSafe, setOverlay, withUiBusy, setUiBusy, setOverlayText } from './ui.js';
import { updateChatTitleWithStats } from './actions.js';
import { fetchSqlText, executeSqlViaApi, fetchQueryAnswer, clearQueryCache } from './api.js';
import { getEncodedAdminToken } from './crypto.js';
import { MAX_TABLE_COLS, MAX_TABLE_CELL_LENGTH, getSchemaBucket } from './config.js';
import { ChartAnalyzer, ChartRenderer } from './chart.js';

// ============================================================================
// Глобальные элементы DOM (устанавливаются через setElements)
// ============================================================================

let chatListEl = null;      // Контейнер списка чатов
let messagesEl = null;       // Контейнер сообщений
let chatTitleEl = null;      // Элемент заголовка чата
let searchInputEl = null;    // Поле поиска чатов
let promptInput = null;      // Поле ввода сообщения

/**
 * Устанавливает ссылки на DOM элементы для использования в модуле
 * @param {Object} elements - Объект с ссылками на DOM элементы
 * @param {HTMLElement} elements.chatListEl - Контейнер списка чатов
 * @param {HTMLElement} elements.messagesEl - Контейнер сообщений
 * @param {HTMLElement} elements.chatTitleEl - Элемент заголовка чата
 * @param {HTMLElement} elements.searchInputEl - Поле поиска
 * @param {HTMLElement} elements.promptInput - Поле ввода
 */
export function setElements(elements) {
  chatListEl = elements.chatListEl;
  messagesEl = elements.messagesEl;
  chatTitleEl = elements.chatTitleEl;
  searchInputEl = elements.searchInputEl;
  promptInput = elements.promptInput;

  // Добавляем обработчик сохранения позиции скролла
  if (messagesEl) {
    messagesEl.addEventListener('scroll', saveScrollPosition);
  }
}

/**
 * Сохраняет текущую позицию скролла для активного чата
 */
function saveScrollPosition() {
  const currentChat = getActiveChat();
  if (!currentChat || !messagesEl) return;

  currentChat.scrollTop = messagesEl.scrollTop;
}

// ============================================================================
// Утилиты оптимизации рендеринга
// ============================================================================

/**
 * Асинхронная подсветка блоков кода порциями
 * Использует requestIdleCallback для выполнения подсветки во время простоя браузера
 * @param {Array<HTMLElement>} codeBlocks - массив элементов code для подсветки
 */
function highlightCodeBlocksAsync(codeBlocks) {
  if (codeBlocks.length === 0) return;

  const CHUNK_SIZE = 5; // Обрабатываем по 5 блоков за раз
  let currentIndex = 0;

  const processChunk = (deadline) => {
    // Обрабатываем блоки пока есть время или пока не закончатся
    while (currentIndex < codeBlocks.length && (deadline.timeRemaining() > 0 || deadline.didTimeout)) {
      const endIndex = Math.min(currentIndex + CHUNK_SIZE, codeBlocks.length);

      for (let i = currentIndex; i < endIndex; i++) {
        try {
          hljs.highlightElement(codeBlocks[i]);
        } catch (err) {
          console.warn('Syntax highlighting error:', err);
        }
      }

      currentIndex = endIndex;
    }

    // Если есть еще блоки - планируем следующую порцию
    if (currentIndex < codeBlocks.length) {
      if (typeof requestIdleCallback !== 'undefined') {
        requestIdleCallback(processChunk, { timeout: 500 });
      } else {
        // Fallback для браузеров без requestIdleCallback
        setTimeout(() => processChunk({ timeRemaining: () => 10, didTimeout: false }), 0);
      }
    }
  };

  // Запускаем первую порцию
  if (typeof requestIdleCallback !== 'undefined') {
    requestIdleCallback(processChunk, { timeout: 500 });
  } else {
    setTimeout(() => processChunk({ timeRemaining: () => 10, didTimeout: false }), 0);
  }
}

// ============================================================================
// Внутренние функции для работы с сообщениями
// ============================================================================

/**
 * Удаляет сообщение из чата
 * Если удаляется user-сообщение, удаляется также следующее assistant-сообщение
 * Если удаляется assistant-сообщение, удаляется также предыдущее user-сообщение
 * Сохраняет текущую позицию скролла
 *
 * @param {string} chatId - ID чата
 * @param {string} messageId - ID сообщения для удаления
 */
function deleteMessage(chatId, messageId) {
  const chat = state.chats.find(c => c.id === chatId);
  if (!chat) return;

  const prevScrollTop = messagesEl?.scrollTop ?? 0;

  const msgIndex = chat.messages.findIndex(m => m.id === messageId);
  if (msgIndex === -1 || msgIndex === 0) return;

  if (chat.messages[msgIndex].role === "user" &&
      msgIndex + 1 < chat.messages.length &&
      chat.messages[msgIndex + 1].role === "assistant") {
    chat.messages.splice(msgIndex, 2);
  } else if (chat.messages[msgIndex].role === "assistant" &&
             msgIndex > 0 &&
             chat.messages[msgIndex - 1].role === "user") {
    chat.messages.splice(msgIndex - 1, 2);
  } else {
    chat.messages.splice(msgIndex, 1);
  }

  saveState();
  renderMessagesInternal();
  // Обновляем список чатов, чтобы изменился счетчик user-сообщений
  renderChatList();

  requestAnimationFrame(() => {
    if (messagesEl) {
      messagesEl.scrollTop = prevScrollTop;
    }
  });

  updateChatTitleWithStats(chatTitleEl);
}

/**
 * Внутренняя функция для сворачивания/разворачивания сообщения
 * Переключает состояние collapsed у сообщения и прокручивает к нему
 *
 * @param {string} messageId - ID сообщения для переключения
 */
function toggleMessageInternal(messageId) {
  const currentChat = getActiveChat();
  if (!currentChat) return;

  const message = currentChat.messages.find(m => m.id === messageId);
  if (!message) return;

  message.collapsed = !message.collapsed;

  saveState();
  renderMessagesInternal();

  updateToggleAllButton();

  requestAnimationFrame(() => {
    const node = document.querySelector(`.msg[data-id="${messageId}"]`);
    if (node) {
      node.scrollIntoView({
        block: "start",
        inline: "nearest",
        behavior: "auto"
      });
    }
  });
}

/**
 * Переключает состояние сворачивания/разворачивания сообщения с UI индикатором загрузки
 *
 * @param {string} messageId - ID сообщения для переключения
 */
function toggleMessage(messageId) {
  withUiBusy(toggleMessageInternal)(messageId);
}

/**
 * Удаляет чат из списка
 * Если удаляется последний чат, создается новый
 * Если удаляется активный чат, активируется первый чат из списка
 *
 * @param {string} chatId - ID чата для удаления
 */
function deleteChat(chatId) {
  const idx = state.chats.findIndex(c => c.id === chatId);
  if (idx === -1) return;

  state.chats.splice(idx, 1);

  if (!state.chats.length) {
    const chat = {
      id: crypto.randomUUID(),
      title: "New chat",
      createdAt: Date.now(),
      messages: [
        {
          id: crypto.randomUUID(),
          role: "assistant",
          content: "Привет! Это демо-интерфейс. Напиши сообщение снизу — я отвечу (через fetchSqlText + v2/execute)."
        }
      ]
    };
    state.chats.push(chat);
    state.activeChatId = chat.id;
  } else if (state.activeChatId === chatId) {
    state.activeChatId = state.chats[0].id;
  }

  saveState();
  renderAllInternal();
}

/**
 * Обновляет состояние глобальной кнопки сворачивания/разворачивания всех сообщений
 * Анализирует текущий чат и устанавливает соответствующий текст и состояние кнопки
 *
 * @returns {boolean} - true если все сообщения свернуты, false иначе
 */
function updateToggleAllButton() {
  const toggleAllBtn = document.getElementById("toggleAllBtn");
  const chat = getActiveChat();
  if (!chat || !toggleAllBtn) return false;

  const anyExpanded = chat.messages.some(
    (m, idx) => idx > 0 && m.role === "assistant" && !m.collapsed
  );

  const allCollapsed = !anyExpanded;

  toggleAllBtn.textContent = allCollapsed ? "+" : "−";
  toggleAllBtn.title = allCollapsed
    ? "Развернуть все сообщения"
    : "Свернуть все сообщения";

  return allCollapsed;
}

// ============================================================================
// Публичные функции рендеринга
// ============================================================================

/**
 * Рендерит список чатов в боковой панели
 *
 * Отображает все чаты с учетом:
 * - Поискового запроса (фильтрация по названию и последнему сообщению)
 * - Сортировки по дате создания (новые сверху)
 * - Выделения активного чата
 * - Возможности редактирования названия по двойному клику
 * - Превью последнего сообщения
 * - Кнопки удаления чата
 */
export function renderChatList() {
  const q = (searchInputEl?.value || "").trim().toLowerCase();
  const mode = getCurrentMode();

  chatListEl.innerHTML = "";

  const chats = state.chats
    .slice()
    .filter(c => {
      // Фильтруем по режиму и схеме (все режимы теперь привязаны к схемам)
      if (c.mode !== mode.id) return false;
      if (c.schema !== dbSchema) return false;
      return true;
    })
    .sort((a, b) => b.createdAt - a.createdAt)
    .filter(c => {
      if (!q) return true;
      const hay = (c.title + " " + (c.messages.at(-1)?.content || "")).toLowerCase();
      return hay.includes(q);
    });

  for (const chat of chats) {
    const last = chat.messages.at(-1)?.content || "";
    const item = document.createElement("div");
    item.className = "chat-item" + (chat.id === state.activeChatId ? " active" : "");
    item.role = "listitem";

    const meta = document.createElement("div");
    meta.className = "meta";

    const name = document.createElement("div");
    name.className = "name";

    // Подсчитываем количество user-сообщений (исключая первое приветственное)
    const userMsgCount = chat.messages.filter((m, idx) => idx > 0 && m.role === "user").length;
    const chatTitle = chat.title || "Untitled";

    // Добавляем количество сообщений к названию чата
    name.textContent = userMsgCount > 0 ? `${chatTitle} (${userMsgCount})` : chatTitle;

    // Добавляем обработчик двойного клика для редактирования прямо в списке
    name.addEventListener("dblclick", (e) => {
      e.preventDefault();
      e.stopPropagation();

      console.log('dblclick на чате в списке:', chat.title);

      // Если уже в режиме редактирования — выходим
      if (name.querySelector("input")) return;

      const current = chat.title || "";
      name.innerHTML = "";

      const input = document.createElement("input");
      input.type = "text";
      input.value = current;
      input.className = "chat-title-input";
      input.style.width = "100%";
      input.style.fontSize = "inherit";
      input.style.fontFamily = "inherit";

      name.appendChild(input);
      input.focus();
      input.select();

      const finish = (commit) => {
        if (commit) {
          const newTitle = input.value.trim() || "Untitled";
          if (newTitle !== current) {
            chat.title = newTitle;
            saveState();

            // ⭐ Обновляем заголовок, если это активный чат
            if (chat.id === state.activeChatId && chatTitleEl) {
              chatTitleEl.textContent = newTitle;
              updateChatTitleWithStats(chatTitleEl);
            }
          }
        }

        // Восстанавливаем название с количеством сообщений
        const finalTitle = chat.title || "Untitled";
        name.textContent = userMsgCount > 0 ? `${finalTitle} (${userMsgCount})` : finalTitle;
        name.removeChild(input);
      };

      input.addEventListener("keydown", (e) => {
        if (e.key === "Enter") {
          e.preventDefault();
          finish(true);
        } else if (e.key === "Escape") {
          e.preventDefault();
          finish(false);
        }
      });

      input.addEventListener("blur", () => {
        finish(true);
      });
    });

    const preview = document.createElement("div");
    preview.className = "preview";
    preview.textContent = last.replace(/\s+/g, " ").slice(0, 80);

    meta.appendChild(name);
    meta.appendChild(preview);

    const del = document.createElement("button");
    del.className = "icon-btn";
    del.title = "Delete chat";
    del.textContent = "🗑";
    del.addEventListener("click", (e) => {
      e.stopPropagation();
      deleteChat(chat.id);
    });

    item.appendChild(meta);
    item.appendChild(del);

    item.addEventListener("click", (e) => {
      // НЕ по кнопке удаления
      if (e.target.closest('.icon-btn')) return;
      // Не по заголовку chatTitle справа
      if (e.target.id === 'chatTitle' || e.target.closest('#chatTitle')) return;
      // Не двойной клик (редактирование)
      if (e.detail === 2) return;
      // Уже активный чат — ничего не делаем
      if (chat.id === state.activeChatId) return;

      const run = () => {
        // Сохраняем позицию скролла текущего чата перед переключением
        saveScrollPosition();

        state.activeChatId = chat.id;
        saveState();
        renderAll();
        requestAnimationFrame(() => promptInput.focus());
      };

      withUiBusy(run)();
    });

    chatListEl.appendChild(item);
  }
}

/**
 * Внутренняя функция рендеринга сообщений (без UI блокировки)
 * Используется для внутренних вызовов, где блокировка не нужна
 */
function renderMessagesInternal() {
  const messagesContainer = document.querySelector('.messages');
  if (!messagesContainer) return;

  const currentChat = getActiveChat();
  if (!currentChat) return;

  // Используем DocumentFragment для пакетной вставки
  const fragment = document.createDocumentFragment();
  const codeBlocksToHighlight = [];

  for (const m of currentChat.messages) {
    const msg = document.createElement('div');
    msg.className = `msg ${m.role}`;
    msg.dataset.id = m.id;
    if (m.error) msg.classList.add('error');

    // Role icon
    const role = document.createElement('div');
    role.className = 'role';
    role.textContent = m.role === 'user' ? 'U' : 'A';

    // Message bubble
    const bubble = document.createElement('div');
    bubble.className = 'bubble';
    bubble.style.position = 'relative'; // Для позиционирования кнопок

    // ---------- Hover-контролы (Copy + Delete / Toggle) ----------
    if ((m.role === 'assistant' && (m.content || m.sql)) || (m.role === 'user' && m.content)) {
      const topControls = document.createElement('div');
      topControls.className = 'hover-controls';
      topControls.style.cssText = `
        position: sticky;
        top: 0;
        right: 8px;
        margin-top: 4px;
        display: flex;
        gap: 4px;
        opacity: 0;
        transition: opacity 0.2s ease;
        z-index: 10;
        background: var(--bg);
        border-radius: 4px;
        padding: 2px;
        width: max-content;
        margin-left: auto;
      `;

      // Кнопка копирования
      const copyBtn = document.createElement('button');
      copyBtn.className = 'copy-btn icon-btn';
      copyBtn.textContent = 'Copy';
      copyBtn.style.cssText = 'padding: 4px 8px; font-size: 12px;';
      copyBtn.title = m.role === 'user' ? 'Скопировать вопрос в буфер обмена' : 'Скопировать ответ в буфер обмена';
      copyBtn.onclick = () => {
        if (m.role === 'user') {
          copyToClipboard(m.content);
        } else {
          const text = m.content + (m.sql ? "\n\nSQL:\n" + buildSqlWithParams(m) : "");
          copyToClipboard(text);
        }
      };
      topControls.appendChild(copyBtn);

      // Кнопки управления для ассистента
      if (m.role === 'assistant') {
        const toggleBtn = document.createElement('button');
        toggleBtn.className = 'toggle-msg-btn icon-btn';
        toggleBtn.textContent = m.collapsed ? '+' : '−';
        toggleBtn.title = m.collapsed ? 'Развернуть' : 'Свернуть';
        toggleBtn.style.cssText = 'padding: 4px 8px; font-size: 12px;';
        toggleBtn.onclick = () => toggleMessage(m.id);

        const deleteBtn = document.createElement('button');
        deleteBtn.className = 'delete-msg-btn icon-btn';
        deleteBtn.textContent = '🗑️';
        deleteBtn.title = 'Удалить';
        deleteBtn.style.cssText = 'padding: 4px 8px; font-size: 12px;';
        deleteBtn.onclick = () => deleteMessage(currentChat.id, m.id);

        topControls.appendChild(toggleBtn);
        topControls.appendChild(deleteBtn);
      }
      // Кнопка удаления для USER-сообщений
      else if (m.role === 'user') {
        const deleteBtn = document.createElement('button');
        deleteBtn.className = 'delete-msg-btn icon-btn';
        deleteBtn.textContent = '🗑️';
        deleteBtn.title = 'Удалить вопрос и ответ';
        deleteBtn.style.cssText = 'padding: 4px 8px; font-size: 12px;';
        deleteBtn.onclick = () => deleteMessage(currentChat.id, m.id);

        topControls.appendChild(deleteBtn);
      }

      // Если сообщение свернуто, кнопки всегда видны
      if (m.role === 'assistant' && m.collapsed) {
        topControls.style.opacity = '1';
      }

      // Показываем/скрываем кнопки при наведении на сообщение
      bubble.addEventListener('mouseenter', () => {
        topControls.style.opacity = '1';
      });
      bubble.addEventListener('mouseleave', () => {
        // Если сообщение свернуто, кнопки остаются видимыми
        if (!(m.role === 'assistant' && m.collapsed)) {
          topControls.style.opacity = '0';
        }
      });

      bubble.appendChild(topControls);
    }

    // ---------- Основной контент (то, что сворачивается) ----------
    const collapsibleContent = document.createElement('div');
    collapsibleContent.className = 'collapsible-content';
    if (m.collapsed) {
      collapsibleContent.style.display = 'none';
    }

    // Placeholder для свернутого сообщения
    let collapsedPlaceholder = null;
    if (m.role === 'assistant' && m.collapsed) {
      collapsedPlaceholder = document.createElement('div');
      collapsedPlaceholder.className = 'collapsed-placeholder';
      collapsedPlaceholder.style.cssText = `
        color: var(--muted-2);
        font-size: 13px;
        font-style: italic;
        padding: 8px 0;
      `;
      collapsedPlaceholder.textContent = '[Сообщение свернуто]';
    }

    // ⭐ ОПТИМИЗАЦИЯ: Не рендерим тяжелый контент для свернутых сообщений
    const shouldRenderContent = !m.collapsed;

    // Текстовое содержимое
    if (m.content && shouldRenderContent) {
      const content = document.createElement('div');
      content.className = 'content';
      content.innerHTML = renderMarkdownSafe(m.content);
      makeLinksOpenInNewTab(content);

      // Добавляем обработчики для кнопок скачивания файлов из GCS в текстовом содержимом
      const currentBucket = getSchemaBucket(dbSchema);
      const downloadBtns = content.querySelectorAll('.download-btn');

      if (!currentBucket) {
        // Если bucket не настроен для схемы - удаляем кнопки скачивания
        downloadBtns.forEach(btn => btn.remove());
      } else {
        // Добавляем обработчики клика
        downloadBtns.forEach(btn => {
          btn.onclick = () => {
            const filename = btn.getAttribute('data-filename');
            if (filename) {
              downloadFromGCS(currentBucket, filename);
            }
          };
        });
      }

      collapsibleContent.appendChild(content);
    }

    // SQL блок
    if (m.sql && shouldRenderContent) {
      const sqlWrap = document.createElement('div');
      sqlWrap.className = 'sql-wrap';
      if (m.error) sqlWrap.classList.add('error');

      const sqlHead = document.createElement('div');
      sqlHead.className = 'sql-head';
      sqlHead.innerHTML = `
        <span>SQL Query</span>
        <div class="sql-actions">
          <button class="sql-btn" title="Скопировать SQL запрос в буфер обмена">Copy</button>
          <button class="sql-btn" title="${m.sqlOpen ? 'Скрыть SQL запрос' : 'Показать SQL запрос'}">${m.sqlOpen ? 'Hide' : 'Show'}</button>
        </div>
      `;

      const sqlBody = document.createElement('div');
      sqlBody.className = 'sql-body';
      sqlBody.style.display = m.sqlOpen ? 'block' : 'none';

      const sqlPre = document.createElement('pre');
      sqlPre.className = 'sql-pre';
      const sqlCode = document.createElement('code');
      sqlCode.className = 'language-sql';
      sqlCode.textContent = m.sql;
      sqlPre.appendChild(sqlCode);
      sqlBody.appendChild(sqlPre);

      // блок Params (только если params не пустой)
      if (hasParams(m.params)) {
        const paramsPre = document.createElement("pre");
        paramsPre.className = "sql-pre params-pre";
        paramsPre.textContent = "Params:\n" + JSON.stringify(m.params, null, 2);
        sqlBody.appendChild(paramsPre);
      }

      sqlWrap.appendChild(sqlHead);
      sqlWrap.appendChild(sqlBody);
      collapsibleContent.appendChild(sqlWrap);

      // Кнопки SQL
      const buttons = sqlHead.querySelectorAll('.sql-btn');
      buttons[0].onclick = () => copyToClipboard(m.sql);
      buttons[1].onclick = () => {
        m.sqlOpen = !m.sqlOpen;
        sqlBody.style.display = m.sqlOpen ? 'block' : 'none';
        buttons[1].textContent = m.sqlOpen ? 'Hide' : 'Show';
        saveState();
      };

      // Отложенная подсветка (добавляем в очередь)
      if (typeof hljs !== 'undefined' && !m.collapsed) {
        codeBlocksToHighlight.push(sqlCode);
      }
    }

    // Таблица
    if (m.table && m.table.rows && m.table.rows.length > 0 && shouldRenderContent) {
      const { columns, rows } = m.table;

      const tableInfo = document.createElement('div');
      tableInfo.className = 'table-info';
      tableInfo.textContent = `Результат: ${rows.length} строк`;
      if (m.error) tableInfo.classList.add('error');
      collapsibleContent.appendChild(tableInfo);

      const tblWrap = document.createElement('div');
      tblWrap.className = 'tbl-wrap';

      const tblHead = document.createElement('div');
      tblHead.className = 'tbl-head';
      tblHead.innerHTML = `
        <span>Таблица (${rows.length} строк, ${columns.length} колонок)</span>
        <button class="sql-btn" title="Скачать таблицу в формате Excel (CSV)">Excel</button>
      `;

      const tblScroller = document.createElement('div');
      tblScroller.className = 'tbl-scroller';

      const table = document.createElement('table');
      table.className = 'tbl';

      // Определяем числовые колонки (проверяем первые несколько строк)
      const isNumericColumn = (colName) => {
        const sampleSize = Math.min(5, rows.length);
        let numericCount = 0;
        for (let i = 0; i < sampleSize; i++) {
          const val = rows[i][colName];
          if (val != null && !isNaN(Number(val)) && String(val).trim() !== '') {
            numericCount++;
          }
        }
        return numericCount === sampleSize && sampleSize > 0;
      };

      const numericColumns = new Set(columns.filter(isNumericColumn));

      // Проверка, содержит ли колонка URL
      const containsUrl = (colName) => {
        const sampleSize = Math.min(5, rows.length);
        const urlPattern = /^(https?:\/\/|www\.)/i;
        for (let i = 0; i < sampleSize; i++) {
          const val = rows[i][colName];
          if (val != null && urlPattern.test(String(val).trim())) {
            return true;
          }
        }
        return false;
      };

      // Определяем URL колонки для установки минимальной ширины
      const urlColumns = new Set(columns.filter(containsUrl));

      // Анализируем ширину текстовых колонок на основе содержимого
      const getColumnMaxLength = (colName) => {
        const sampleSize = Math.min(5, rows.length);
        let maxLength = colName.length; // Учитываем длину заголовка

        // Если колонка содержит URL, устанавливаем минимальную длину 100
        if (containsUrl(colName)) {
          maxLength = Math.max(maxLength, 100);
        }

        for (let i = 0; i < sampleSize; i++) {
          const val = rows[i][colName];
          if (val != null) {
            const strVal = String(val);
            // Для многострочного текста берем длину самой длинной строки
            const lines = strVal.split('\n');
            const maxLineLength = Math.max(...lines.map(line => line.length));
            maxLength = Math.max(maxLength, maxLineLength);
          }
        }
        return maxLength;
      };

      // Вычисляем относительные ширины для текстовых колонок
      const columnWidths = new Map();
      const textColumns = columns.filter(col => !numericColumns.has(col));

      if (textColumns.length > 1) {
        const maxLengths = textColumns.map(col => ({
          col,
          length: getColumnMaxLength(col)
        }));

        const totalLength = maxLengths.reduce((sum, item) => sum + item.length, 0);

        // Вычисляем процентную ширину для каждой колонки
        maxLengths.forEach(({ col, length }) => {
          const percentage = Math.max(10, Math.min(60, (length / totalLength) * 100));
          columnWidths.set(col, percentage);
        });
      }

      const thead = document.createElement('thead');
      const headerRow = document.createElement('tr');
      for (const col of columns) {
        const th = document.createElement('th');
        th.textContent = col;
        if (numericColumns.has(col)) {
          th.classList.add('numeric-col');
        } else if (columnWidths.has(col)) {
          // Устанавливаем ширину для текстовых колонок
          th.style.width = columnWidths.get(col) + '%';
        }
        // Для URL колонок устанавливаем минимальную ширину
        if (urlColumns.has(col)) {
          th.style.minWidth = '200px';
        }
        headerRow.appendChild(th);
      }
      thead.appendChild(headerRow);
      table.appendChild(thead);

      const tbody = document.createElement('tbody');
      for (const row of rows) {
        const tr = document.createElement('tr');
        for (const col of columns) {
          const td = document.createElement('td');

          // Добавляем класс для числовых колонок
          if (numericColumns.has(col)) {
            td.classList.add('numeric-col');
          }

          // Для URL колонок устанавливаем минимальную ширину
          if (urlColumns.has(col)) {
            td.style.minWidth = '200px';
          }

          // Получаем значение ячейки
          const cellValue = row[col];
          const cellStr = cellValue != null ? String(cellValue) : '';

          // Если значение содержит переносы строк - используем textarea
          if (cellStr.includes('\n')) {
            // Проверяем длину текста
            if (cellStr.length > MAX_TABLE_CELL_LENGTH) {
              // Длинный многострочный текст - создаем обертку с кнопкой
              const wrapper = document.createElement('div');
              wrapper.className = 'cell-text-truncated';

              // Короткая версия
              const shortTextarea = document.createElement('textarea');
              shortTextarea.className = 'table-cell-textarea cell-text-short';
              shortTextarea.value = cellStr.substring(0, MAX_TABLE_CELL_LENGTH) + '...';
              shortTextarea.readOnly = true;

              // Полная версия
              const fullTextarea = document.createElement('textarea');
              fullTextarea.className = 'table-cell-textarea cell-text-full';
              fullTextarea.value = cellStr;
              fullTextarea.readOnly = true;
              fullTextarea.style.display = 'none';

              // Кнопка раскрытия
              const expandBtn = document.createElement('button');
              expandBtn.className = 'cell-expand-btn';
              expandBtn.textContent = 'читать далее';
              expandBtn.title = 'Показать полный текст';
              expandBtn.onclick = function() { window.toggleCellText(this); };

              wrapper.appendChild(shortTextarea);
              wrapper.appendChild(fullTextarea);
              wrapper.appendChild(expandBtn);

              // Подстраиваем высоту textarea после добавления в DOM
              requestAnimationFrame(() => {
                shortTextarea.style.height = 'auto';
                shortTextarea.style.height = (shortTextarea.scrollHeight + 4) + 'px';
                fullTextarea.style.height = 'auto';
                fullTextarea.style.height = (fullTextarea.scrollHeight + 4) + 'px';
              });

              td.appendChild(wrapper);
            } else {
              // Обычный многострочный текст
              const textarea = document.createElement('textarea');
              textarea.className = 'table-cell-textarea';
              textarea.value = cellStr;
              textarea.readOnly = true;

              // Функция для автоматической подстройки высоты
              const adjustHeight = () => {
                textarea.style.height = 'auto';
                // Добавляем небольшой запас для padding и border
                textarea.style.height = (textarea.scrollHeight + 4) + 'px';
              };

              // Подстраиваем высоту после добавления в DOM
              requestAnimationFrame(adjustHeight);

              td.appendChild(textarea);
            }
          } else {
            // Обычная ячейка
            td.innerHTML = escapeCell(undefined, col, row);
          }

          tr.appendChild(td);
        }
        tbody.appendChild(tr);
      }
      table.appendChild(tbody);

      tblScroller.appendChild(table);
      tblWrap.appendChild(tblHead);
      tblWrap.appendChild(tblScroller);
      collapsibleContent.appendChild(tblWrap);

      const csvBtn = tblHead.querySelector('.sql-btn');
      csvBtn.onclick = () => {
        setUiBusy(true);
        // Используем setTimeout для асинхронности, чтобы индикатор успел отобразиться
        setTimeout(() => {
          try {
            const csv = toCsv(rows, columns);
            const chat = getActiveChat();
            const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
            const filename = `${chat.title.slice(0, 30)}_${timestamp}.csv`;
            downloadTextFile(filename, csv, "text/csv;charset=utf-8");
          } finally {
            setUiBusy(false);
          }
        }, 50);
      };

      // ⭐ Кнопка построения графика
      if (m.chartAnalysis && m.chartAnalysis.suitable) {
        const chartBtn = document.createElement('button');
        chartBtn.className = 'sql-btn btn-chart';
        chartBtn.textContent = '📊 График';
        chartBtn.title = 'Построить график';
        chartBtn.onclick = (e) => {
          e.stopPropagation();
          showChartModal(m);
        };
        csvBtn.insertAdjacentElement('beforebegin', chartBtn);
      }

      // Обработчик для кнопок скачивания файлов из GCS
      const currentBucket = getSchemaBucket(dbSchema);
      const downloadBtns = tblWrap.querySelectorAll('.download-btn');

      if (!currentBucket) {
        // Если bucket не настроен для схемы - удаляем кнопки скачивания
        downloadBtns.forEach(btn => btn.remove());
      } else {
        // Добавляем обработчики клика
        downloadBtns.forEach(btn => {
          btn.onclick = () => {
            const filename = btn.getAttribute('data-filename');
            if (filename) {
              // Filename уже содержит префикс с номером закона
              downloadFromGCS(currentBucket, filename);
            }
          };
        });
      }
    }

    // Добавляем placeholder если сообщение свернуто
    if (collapsedPlaceholder) {
      bubble.appendChild(collapsedPlaceholder);
    }

    // Добавляем основной контент в bubble
    bubble.appendChild(collapsibleContent);

    // ---------- МЕТА-БЛОК (всегда виден, вне collapsible-content) ----------
    const meta = document.createElement("div");
    meta.className = "msg-meta";
    let hasMeta = false;

    if (m.role === "user" && m.restRequestAt) {
      const len = (m.content || "").length;
      const tReq = formatTimeForMeta(m.restRequestAt);
      const tResp = m.restResponseAt ? formatTimeForMeta(m.restResponseAt) : null;
      const dur = m.restDurationMs != null ? formatDurationMs(m.restDurationMs) : null;

      const parts = [];
      parts.push(`len: ${len}`);
      parts.push(`REST: ${tReq}${tResp ? " → " + tResp : ""}`);
      if (dur) parts.push(dur);

      meta.textContent = parts.join(" • ");
      hasMeta = true;
    }

    if (m.role === "assistant" && (m.restRequestAt || m.executeRequestAt)) {
      const isTable = !!m.table;
      const len = isTable ? null : (m.content || "").length;

      const parts = [];
      if (!isTable && len) parts.push(`len: ${len}`);

      // REST тайминги
      if (m.restRequestAt && m.restResponseAt) {
        const tReq = formatTimeForMeta(m.restRequestAt);
        const tResp = formatTimeForMeta(m.restResponseAt);
        const dur = m.restDurationMs ? formatDurationMs(m.restDurationMs) : null;
        parts.push(`REST: ${tReq} → ${tResp}${dur ? ` (${dur})` : ""}`);
      }

      // SQL execute тайминги
      if (m.executeRequestAt && m.executeResponseAt) {
        const tExecReq = formatTimeForMeta(m.executeRequestAt);
        const tExecResp = formatTimeForMeta(m.executeResponseAt);
        const execDur = m.executeDurationMs ? formatDurationMs(m.executeDurationMs) : null;
        parts.push(`SQL: ${tExecReq} → ${tExecResp}${execDur ? ` (${execDur})` : ""}`);
      }

      if (parts.length) {
        meta.textContent = parts.join(" • ");
        hasMeta = true;
      }
    }

    if (hasMeta) {
      bubble.appendChild(meta);
    }

    // завершение
    msg.appendChild(role);
    msg.appendChild(bubble);
    fragment.appendChild(msg);
  }

  // Пакетная вставка всех сообщений за один раз
  messagesContainer.innerHTML = '';
  messagesContainer.appendChild(fragment);

  updateChatTitleWithStats(chatTitleEl);

  // Восстанавливаем позицию скролла для текущего чата
  const savedScrollTop = currentChat.scrollTop;
  if (savedScrollTop !== undefined && savedScrollTop !== null) {
    messagesContainer.scrollTop = savedScrollTop;
  } else {
    // По умолчанию — скроллим в конец (для новых сообщений)
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  }

  // ⭐ после рендера — выравниваем кнопки по верхней видимой строке
  requestAnimationFrame(() => {
    adjustHoverOffsets();

    // Асинхронная подсветка синтаксиса (порциями, чтобы не блокировать UI)
    if (codeBlocksToHighlight.length > 0) {
      highlightCodeBlocksAsync(codeBlocksToHighlight);
    }
  });
}

/**
 * Рендерит все сообщения активного чата с индикатором загрузки
 *
 * Отображает для каждого сообщения:
 * - Иконку роли (User/Assistant)
 * - Hover-контролы (копирование, удаление, сворачивание)
 * - Текстовое содержимое с рендерингом Markdown
 * - SQL запрос с подсветкой синтаксиса и параметрами
 * - Таблицу результатов с возможностью экспорта в CSV
 * - Метаданные (тайминги REST и SQL запросов)
 *
 * Во время рендеринга:
 * - Показывает индикатор загрузки
 * - Блокирует взаимодействие с UI
 *
 * После рендеринга:
 * - Обновляет заголовок чата со статистикой
 * - Скроллит к концу сообщений
 * - Выравнивает позицию hover-кнопок
 */
export function renderMessages() {
  withUiBusy(renderMessagesInternal)();
}

/**
 * Внутренняя функция полного рендеринга (без UI блокировки)
 * Используется для внутренних вызовов
 */
function renderAllInternal() {
  renderChatList();
  renderMessagesInternal();
  // обновляем заголовок активного чата
  updateChatTitleWithStats(chatTitleEl);
  updateToggleAllButton(); // ⭐ Обновляем состояние кнопки при смене чата
}

/**
 * Полный рендеринг интерфейса с индикатором загрузки
 *
 * Последовательно выполняет:
 * - Рендеринг списка чатов (renderChatList)
 * - Рендеринг сообщений активного чата (renderMessagesInternal)
 * - Обновление заголовка чата со статистикой
 * - Обновление состояния кнопки "свернуть все"
 *
 * Во время рендеринга:
 * - Показывает индикатор загрузки
 * - Блокирует взаимодействие с UI
 */
export function renderAll() {
  withUiBusy(renderAllInternal)();
}

/**
 * Выравнивает hover-кнопки по верхнему краю видимой части сообщения
 *
 * Для каждого сообщения находит первый видимый блок контента
 * и позиционирует hover-контролы относительно его верхней границы
 * Это обеспечивает корректное отображение кнопок для свернутых сообщений
 */
export function adjustHoverOffsets() {
  const messagesContainer = document.querySelector('.messages');
  if (!messagesContainer) return;

  const msgs = messagesContainer.querySelectorAll('.msg');
  msgs.forEach(msg => {
    const bubble = msg.querySelector('.bubble');
    const controls = bubble?.querySelector('.hover-controls');
    if (!bubble || !controls) return;

    // ищем первый видимый дочерний блок (кроме самих hover-controls)
    const children = Array.from(bubble.children).filter(
      node => !node.classList.contains('hover-controls')
    );

    let target = null;
    for (const node of children) {
      // offsetParent === null у элементов display:none
      if (node.offsetParent !== null) {
        target = node;
        break;
      }
    }
    if (!target) return;

    const offset = target.offsetTop; // относительно bubble (position:relative)
    controls.style.top = offset + "px";
  });
}

/**
 * Скроллит к началу сообщения ассистента
 *
 * @param {string} messageId - ID сообщения для скроллинга
 */
function scrollToAssistantMessage(messageId) {
  const currentChat = getActiveChat();
  if (!currentChat) return;

  // Используем requestAnimationFrame чтобы дождаться рендера
  requestAnimationFrame(() => {
    const messagesContainer = document.querySelector('.messages');
    if (!messagesContainer) return;

    const messageEl = messagesContainer.querySelector(`[data-id="${messageId}"]`);
    if (!messageEl) return;

    // Скроллим к началу сообщения ассистента
    const offsetTop = messageEl.offsetTop;
    messagesContainer.scrollTop = offsetTop;

    // Сохраняем позицию скролла для текущего чата
    currentChat.scrollTop = offsetTop;
  });
}

/**
 * Рендерит результаты векторного поиска из custom API в виде закладок
 * @param {Object} response - Ответ от API с массивом results
 * @returns {string} - HTML разметка с результатами поиска в виде табов
 */
function renderSearchResults(response) {
  if (!response.results || !Array.isArray(response.results) || response.results.length === 0) {
    return "Результаты не найдены";
  }

  const results = response.results;
  const tabsId = `search-tabs-${Date.now()}`; // Уникальный ID для набора табов

  let html = `<div class="search-results">`;
  html += `<div class="search-results-header">Найдено результатов: ${results.length}</div>`;

  // Заголовки закладок
  html += `<div class="search-tabs" id="${tabsId}">`;
  results.forEach((result, index) => {
    const relevance = result.relevance || {};
    const percent = relevance.percent || 0;

    // Определяем класс релевантности для цветового кодирования
    let relevanceClass = "low";
    if (percent >= 80) relevanceClass = "high";
    else if (percent >= 60) relevanceClass = "medium";

    const activeClass = index === 0 ? "active" : "";

    html += `<div class="search-tab ${activeClass} ${relevanceClass}" data-tab-index="${index}" onclick="window.switchSearchTab('${tabsId}', ${index})">`;
    html += `<span class="tab-number">#${index + 1}</span>`;
    html += `<span class="tab-relevance">${percent}%</span>`;
    html += `</div>`;
  });
  html += `</div>`; // search-tabs

  // Содержимое закладок
  html += `<div class="search-tabs-content">`;
  results.forEach((result, index) => {
    const relevance = result.relevance || {};
    const metadata = result.metadata || {};
    const text = result.text || "";
    const chunkInfo = result.chunk_info || {};

    const percent = relevance.percent || 0;
    const score = relevance.score?.toFixed(3) || "0.000";

    // Определяем класс релевантности
    let relevanceClass = "low";
    if (percent >= 80) relevanceClass = "high";
    else if (percent >= 60) relevanceClass = "medium";

    const activeClass = index === 0 ? "active" : "";

    html += `<div class="search-tab-panel ${activeClass}" data-panel-index="${index}">`;

    // Заголовок с релевантностью
    html += `<div class="search-result-header">`;
    html += `<div class="search-result-number">Результат #${index + 1}</div>`;
    html += `<div class="search-result-relevance ${relevanceClass}">`;
    html += `<span class="relevance-percent">${percent}%</span>`;
    html += `<span class="relevance-score">(${score})</span>`;
    html += `</div>`;
    html += `</div>`;

    // Метаданные
    html += `<div class="search-result-metadata">`;
    if (metadata.archive_name) {
      html += `<div class="metadata-item"><strong>Архив:</strong> ${metadata.archive_name}</div>`;
    }
    if (metadata.meeting_date) {
      html += `<div class="metadata-item"><strong>Дата:</strong> ${metadata.meeting_date}</div>`;
    }
    if (chunkInfo.chunk_index !== undefined && chunkInfo.total_chunks !== undefined) {
      html += `<div class="metadata-item"><strong>Фрагмент:</strong> ${chunkInfo.chunk_index + 1} из ${chunkInfo.total_chunks}</div>`;
    }
    html += `</div>`;

    // Текст результата
    html += `<div class="search-result-text">${text}</div>`;

    html += `</div>`; // search-tab-panel
  });
  html += `</div>`; // search-tabs-content

  html += `</div>`; // search-results

  return html;
}

/**
 * Обрабатывает запрос пользователя и генерирует ответ ассистента
 *
 * Процесс работы:
 * 1. Отправляет текст пользователя на REST API для генерации SQL запроса
 * 2. Получает SQL запрос и параметры, сохраняет тайминги REST запроса
 * 3. Выполняет SQL запрос через API с токеном авторизации
 * 4. Анализирует результат и определяет способ отображения:
 *    - Таблица (если результат - простые объекты, не более MAX_TABLE_COLS колонок)
 *    - Текстовый список (для всех остальных случаев)
 * 5. Сохраняет тайминги выполнения SQL запроса
 * 6. Обновляет сообщения в интерфейсе
 *
 * @param {string} userText - Текст вопроса пользователя
 * @param {Object} assistantMsg - Объект сообщения ассистента для заполнения
 * @param {Object} userMsg - Объект сообщения пользователя для сохранения таймингов
 * @param {AbortSignal} signal - Сигнал для отмены операции
 */
export async function fakeStreamAnswer(userText, assistantMsg, userMsg, signal) {
  const mode = getCurrentMode();

  try {
    // --- тайминги REST-запроса ---
    const restStart = new Date();
    const t0 = performance.now();

    // сохраняем время начала REST-запроса
    assistantMsg.restRequestAt = restStart.toISOString();
    if (userMsg) userMsg.restRequestAt = assistantMsg.restRequestAt;

    // Для SQL режима используем существующую логику
    // Для остальных режимов - универсальный запрос
    const response = (mode.id === 'sql')
      ? await fetchSqlText(userText, { signal })
      : await fetchQueryAnswer(userText, { signal });

    const restEnd = new Date();
    const durationMs = Math.round(performance.now() - t0);

    // сохраняем время окончания и длительность REST для ассистента
    assistantMsg.restResponseAt = restEnd.toISOString();
    assistantMsg.restDurationMs = durationMs;

    // для пользователя сохраняем только REST тайминги
    if (userMsg) {
      userMsg.restResponseAt = assistantMsg.restResponseAt;
      userMsg.restDurationMs = durationMs;
    }

    console.log('Response from API:', response);

    // Проверяем наличие запроса на уточнение в ответе
    if (response && typeof response.error === 'string' && response.error.trim().length > 0) {
      console.log('Clarification request detected:', response.error);
      // Это запрос на уточнение (код 200), а не ошибка
      assistantMsg.error = true;
      assistantMsg.collapsed = false;
      assistantMsg.content = "❓ " + response.error;
      scrollToAssistantMessage(assistantMsg.id);
      renderMessagesInternal();
      return;
    }

    // ========== SQL РЕЖИМ ==========
    if (mode.id === 'sql') {
      let sqlText = "";
      let params = null;

      if (response && typeof response === "object") {
        sqlText = typeof response.sql === "string" ? response.sql : "";
        params = response.params ?? null;
      }

      if (!sqlText) throw new Error("SQL not generated");

      assistantMsg.sql = sqlText;
      assistantMsg.params = params;
      // Скроллим на начало ответа ассистента
      scrollToAssistantMessage(assistantMsg.id);
      renderMessagesInternal();

      const encodedToken = await getEncodedAdminToken({ signal });

    // --- тайминги SQL выполнения (только для ассистента) ---
    const executeStart = new Date();
    const executeT0 = performance.now();

    assistantMsg.executeRequestAt = executeStart.toISOString();

    // Изменяем текст overlay на "Receiving data…"
    setOverlayText("Receiving data…");

    let executeResult;
    try {
      executeResult = await executeSqlViaApi(
        { sqlText, params, token: encodedToken },
        { signal }
      );

      const executeEnd = new Date();
      const executeDurationMs = Math.round(performance.now() - executeT0);

      // сохраняем тайминги SQL выполнения только для ассистента
      assistantMsg.executeResponseAt = executeEnd.toISOString();
      assistantMsg.executeDurationMs = executeDurationMs;

    } catch (execErr) {
      const executeEnd = new Date();
      const executeDurationMs = Math.round(performance.now() - executeT0);

      // Автоматически очищаем кэш запроса при ошибке выполнения SQL
      try {
        await clearQueryCache(userText, dbSchema);
        console.log('Query cache cleared after SQL execution error');
      } catch (cacheError) {
        console.warn('Failed to clear query cache:', cacheError);
      }

      assistantMsg.executeResponseAt = executeEnd.toISOString();
      assistantMsg.executeDurationMs = executeDurationMs;
      assistantMsg.error = true;
      assistantMsg.collapsed = false; // Сразу раскрываем сообщение с ошибкой

      // Извлекаем detail из ошибки, если есть
      let errorText;
      if (typeof execErr === 'object' && execErr !== null) {
        errorText = execErr.detail || execErr.message || JSON.stringify(execErr, null, 2);
      } else {
        errorText = String(execErr);
      }

      // Выбираем иконку в зависимости от типа сообщения
      const icon = errorText.toLowerCase().startsWith('clarification:') ? '❓' : '❌';
      assistantMsg.content = icon + " " + errorText;

      // Скроллим на начало ответа ассистента
      scrollToAssistantMessage(assistantMsg.id);
      renderMessagesInternal();
      return;
    }

    setOverlay(false);

    if (isArrayOfObjects(executeResult)) {
      const rows = executeResult;
      const columns = getColumnsFromRows(rows);

      const hasComplex = rows.some(r =>
        r && Object.values(r).some(v =>
          (
            Array.isArray(v) &&
            v.length > 0 &&
            v.every(o => o && typeof o === "object" && !Array.isArray(o))
          ) ||
          (v && typeof v === "object" && !Array.isArray(v))
        )
      );

      if (!hasComplex && columns.length > 0 && columns.length <= MAX_TABLE_COLS && rows.length > 1) {
        assistantMsg.table = { columns, rows };
        assistantMsg.csv = toCsv(rows, columns);
        assistantMsg.content = `✅ Result rendered as table (${rows.length} rows, ${columns.length} cols).`;
        assistantMsg.hasTable = true;

        // ⭐ НОВЫЙ КОД: Анализ для графиков
        const chartAnalysis = ChartAnalyzer.analyzeForChart(rows, columns);
        if (chartAnalysis.suitable) {
          assistantMsg.chartAnalysis = chartAnalysis;
          assistantMsg.content += `\n\n📊 Данные подходят для визуализации. Доступные типы графиков: ${chartAnalysis.charts.map(c => c.label).join(', ')}.`;
        }

        // Скроллим на начало ответа ассистента
        scrollToAssistantMessage(assistantMsg.id);
        renderMessagesInternal();
        return;
      }
    }

      // Во всех остальных случаях показываем как текстовый список
      const answerText = formatExecuteResult(executeResult);
      assistantMsg.content = answerText;
      // Скроллим на начало ответа ассистента
      scrollToAssistantMessage(assistantMsg.id);
      renderMessagesInternal();
    }
    // ========== ДРУГИЕ РЕЖИМЫ (Custom API и т.д.) ==========
    else {
      // Для других режимов - отображаем ответ
      if (response && typeof response === "object") {
        // Проверяем, есть ли массив results (векторный поиск)
        if (response.results && Array.isArray(response.results) && response.results.length > 0) {
          // Используем специальный рендеринг для результатов поиска
          assistantMsg.content = renderSearchResults(response);
        } else {
          // Пробуем разные поля в ответе
          const answerText = response.answer || response.text || response.response || JSON.stringify(response, null, 2);
          assistantMsg.content = answerText;
        }
      } else if (typeof response === "string") {
        assistantMsg.content = response;
      } else {
        assistantMsg.content = "✅ Запрос выполнен успешно";
      }

      // Скроллим на начало ответа ассистента
      scrollToAssistantMessage(assistantMsg.id);
      renderMessagesInternal();
    }
  } catch (error) {
    if (error?.name === "AbortError") return;

    // Автоматически очищаем кэш запроса при ошибке
    try {
      await clearQueryCache(userText, dbSchema);
      console.log('Query cache cleared after error');
    } catch (cacheError) {
      console.warn('Failed to clear query cache:', cacheError);
    }

    assistantMsg.error = true;
    assistantMsg.collapsed = false; // Сразу раскрываем сообщение с ошибкой

    // Извлекаем detail из ошибки, если есть
    let errorText;
    if (typeof error === 'object' && error !== null) {
      errorText = error.detail || error.message || JSON.stringify(error, null, 2);
    } else {
      errorText = String(error);
    }

    // Выбираем иконку в зависимости от типа сообщения
    const icon = errorText.toLowerCase().startsWith('clarification:') ? '❓' : '❌';
    assistantMsg.content = icon + " " + errorText;

    // Скроллим на начало ответа ассистента
    scrollToAssistantMessage(assistantMsg.id);
    renderMessagesInternal();
  }
}

/**
 * Показывает модальное окно с выбором типа графика
 * @param {Object} msg - сообщение с данными и chartAnalysis
 */
export function showChartModal(msg) {
  const modal = document.getElementById('chartModal');
  if (!modal) {
    console.error('Chart modal element not found');
    return;
  }

  const chartTypeSelect = modal.querySelector('#chartTypeSelect');
  const chartContainer = modal.querySelector('#chartContainer');

  if (!chartTypeSelect || !chartContainer) {
    console.error('Chart modal elements not found');
    return;
  }

  // Очистка предыдущего содержимого
  chartTypeSelect.innerHTML = '';
  chartContainer.innerHTML = '';

  // Заполнение списка типов графиков
  msg.chartAnalysis.charts.forEach((chartConfig, idx) => {
    const option = document.createElement('option');
    option.value = idx;
    option.textContent = chartConfig.label;
    chartTypeSelect.appendChild(option);
  });

  let currentChart = null;

  // Обработчик изменения типа графика
  const renderSelectedChart = () => {
    const selectedIdx = parseInt(chartTypeSelect.value);
    const chartConfig = msg.chartAnalysis.charts[selectedIdx];

    chartContainer.innerHTML = ''; // Очистка

    // Уничтожаем предыдущий график
    if (currentChart) {
      currentChart.destroy();
      currentChart = null;
    }

    try {
      currentChart = ChartRenderer.renderChart(chartContainer, msg.table.rows, chartConfig);
    } catch (err) {
      chartContainer.innerHTML = `<div class="error">❌ Ошибка построения графика: ${err.message}</div>`;
      console.error('Chart rendering error:', err);
    }
  };

  // Добавляем обработчик события
  chartTypeSelect.onchange = renderSelectedChart;

  // Показать модальное окно
  modal.style.display = 'flex';

  // Построить первый график по умолчанию
  renderSelectedChart();

  // ⭐ Обработчик сброса масштаба
  const resetZoomBtn = modal.querySelector('#resetZoomBtn');
  if (resetZoomBtn) {
    resetZoomBtn.onclick = () => {
      if (currentChart && typeof currentChart.resetZoom === 'function') {
        currentChart.resetZoom();
      }
    };
  }

  // ⭐ Обработчик копирования графика в буфер обмена
  const copyChartBtn = modal.querySelector('#copyChartBtn');
  if (copyChartBtn) {
    copyChartBtn.onclick = async () => {
      if (!currentChart || !currentChart.canvas) {
        alert('График не найден');
        return;
      }

      const originalText = copyChartBtn.textContent;
      copyChartBtn.disabled = true;
      copyChartBtn.textContent = '⏳ Копирование...';

      try {
        // Получаем canvas элемент
        const canvas = currentChart.canvas;

        // Преобразуем canvas в blob
        const blob = await new Promise((resolve) => {
          canvas.toBlob(resolve, 'image/png');
        });

        if (!blob) {
          throw new Error('Не удалось создать изображение');
        }

        // Копируем blob в буфер обмена
        await navigator.clipboard.write([
          new ClipboardItem({
            'image/png': blob
          })
        ]);

        copyChartBtn.textContent = '✅ Скопировано!';
        setTimeout(() => {
          copyChartBtn.textContent = originalText;
          copyChartBtn.disabled = false;
        }, 2000);
      } catch (err) {
        console.error('Error copying chart:', err);
        copyChartBtn.textContent = '❌ Ошибка';
        setTimeout(() => {
          copyChartBtn.textContent = originalText;
          copyChartBtn.disabled = false;
        }, 2000);

        // Fallback: предлагаем скачать изображение
        if (err.name === 'NotAllowedError' || err.message.includes('clipboard')) {
          if (confirm('Браузер не поддерживает копирование изображений в буфер обмена. Скачать график как изображение?')) {
            const canvas = currentChart.canvas;
            const link = document.createElement('a');
            link.download = `chart-${Date.now()}.png`;
            link.href = canvas.toDataURL('image/png');
            link.click();
          }
        }
      }
    };
  }

  // Закрытие модального окна
  const closeModal = () => {
    if (currentChart) {
      currentChart.destroy();
      currentChart = null;
    }
    modal.style.display = 'none';
  };

  const closeBtn = modal.querySelector('.close-modal');
  if (closeBtn) {
    closeBtn.onclick = closeModal;
  }

  modal.onclick = (e) => {
    if (e.target === modal) {
      closeModal();
    }
  };
}
