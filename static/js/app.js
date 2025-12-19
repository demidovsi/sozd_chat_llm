/* ChatGPT-like UI demo (with backend fetchSqlText).
 * - Multi chat sessions
 * - LocalStorage persistence
 * - Markdown render (marked)
 * - Optional code highlighting (highlight.js)
 * - Fake assistant streaming (disabled: render instantly)
 * - Copy buttons
 * - Theme toggle
 * - AbortController Stop
 * - ArrowUp = last user message
 * - Enter sends only if cursor is in last line AND at end
 * - Center overlay shown while waiting for server response, hidden during streaming
 */
const config = {
  kirill: "wqzDi8OVw43DjcOOwoTCncKZwpM=",
  URL: "https://159.223.0.234:5001/",
//  URL: "http://159.223.0.234:5000/",
//  URL_rest: "http://159.223.0.234:5050/"
//  URL_rest: "https://159.223.0.234:5051/"
  URL_rest: "http://localhost:5050/"
};

const LS_KEY = "chatui_demo_v1";
const THEME_KEY = "chatui_theme";
const MAX_TABLE_COLS = 10; // ← N (поменяй как хочешь)

const el = (id) => document.getElementById(id);

let state = null;
let token_admin = null;
let currentAbortController = null;
let isGenerating = false;
let lastUserMessageCache = "";

const scrollToEndBtn = el("scrollToEndBtn");
const scrollToTopBtn = el("scrollToTopBtn");

/** ---------- State ---------- **/
function loadState() {
  const raw = localStorage.getItem(LS_KEY);
  if (raw) {
    try { return JSON.parse(raw); } catch {}
  }
  const init = { activeChatId: null, chats: [] };
  const chat = createChat("New chat");
  init.chats.push(chat);
  init.activeChatId = chat.id;
  saveState(init);
  return init;
}

function saveState(next = state) {
  localStorage.setItem(LS_KEY, JSON.stringify(next));
}

function createChat(title) {
  return {
    id: crypto.randomUUID(),
    title,
    createdAt: Date.now(),
    messages: [
      {
        id: crypto.randomUUID(),
        role: "assistant",
        content: "Привет! Это демо-интерфейс. Напиши сообщение снизу — я отвечу (через fetchSqlText + v2/execute)."
      }
    ]
  };
}

// ✅ укрепили: если activeChatId сломался — чинит и сохраняет
function getActiveChat() {
  const found = state.chats.find(c => c.id === state.activeChatId);
  if (found) return found;

  state.activeChatId = state.chats[0]?.id || null;
  saveState();
  return state.chats[0];
}

/** ---------- Helpers ---------- **/
function normalizeUserMessage(text) {
  return (text || "")
    .replace(/\r\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

function sleep(ms) {
  return new Promise(res => setTimeout(res, ms));
}

// Функция для экранирования HTML
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

function getColumnsFromRows(rows) {
  const set = new Set();
  for (const r of rows) {
    if (r && typeof r === "object" && !Array.isArray(r)) {
      Object.entries(r).forEach(([key, value]) => {
        if (value && typeof value === "object" && !Array.isArray(value)) {
          // Если значение - словарь, добавляем его ключи как отдельные колонки
          Object.keys(value).forEach(subKey => {
            set.add(`${key}.${subKey}`);
          });
        } else {
          set.add(key);
        }
      });
    }
  }
  return Array.from(set);
}

// Обновляем функцию escapeCell для обработки URL
function escapeCell(v, column, row) {
  if (v == null) return "<em>null</em>";
  if (v === "") return "<em>empty</em>";

  const str = String(v);

  // Проверяем, является ли значение URL
  if (isUrl(str)) {
    const escapedUrl = escapeHtml(str);
    return `<a href="${escapedUrl}" target="_blank" rel="noopener noreferrer" class="table-link" title="Открыть в новом окне">${escapedUrl}</a>`;
  }

  return escapeHtml(str);
}

// Функция для определения URL
function isUrl(string) {
  try {
    const url = new URL(string);
    return url.protocol === 'http:' || url.protocol === 'https:';
  } catch {
    return false;
  }
}

function toCsv(rows, columns) {
  const esc = (s) => {
    // Убираем HTML теги из значения для CSV
    const div = document.createElement('div');
    div.innerHTML = String(s ?? "");
    const cleanValue = div.textContent || div.innerText || "";

    if (/[",\n\r;]/.test(cleanValue)) return `"${cleanValue.replace(/"/g, '""')}"`;
    return cleanValue;
  };

  const header = columns.map(esc).join(";");
  const lines = rows.map(r => columns.map(c => esc(r?.[c])).join(";"));
  return [header, ...lines].join("\n");
}

function downloadTextFile(filename, text, mime = "text/plain;charset=utf-8") {
  const BOM = "\uFEFF"; // чтобы Excel корректно открыл UTF-8
  const blob = new Blob([BOM + text], { type: mime });

  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

function isArrayOfObjects(x) {
  return Array.isArray(x) && x.length > 0 && x.every(r => r && typeof r === "object" && !Array.isArray(r));
}

async function copyToClipboard(text) {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch {
    const ta = document.createElement("textarea");
    ta.value = text;
    ta.style.position = "fixed";
    ta.style.opacity = "0";
    document.body.appendChild(ta);
    ta.select();
    const ok = document.execCommand("copy");
    document.body.removeChild(ta);
    return ok;
  }
}

function hasParams(p) {
  if (!p || typeof p !== "object") return false;
  if (Array.isArray(p)) return p.length > 0;

  return Object.entries(p).some(
    ([, v]) => v !== null && v !== undefined && v !== ""
  );
}

/** ---------- Theme ---------- **/
function applyTheme(mode) {
  let theme = mode;
  if (mode === "auto") {
    theme = window.matchMedia("(prefers-color-scheme: light)").matches ? "light" : "dark";
  }
  document.documentElement.dataset.theme = theme;
}

function updateThemeIcon(themeToggleBtn, theme) {
  if (!themeToggleBtn) return;
  themeToggleBtn.textContent = theme === "dark" ? "🌙" : "☀️";
}

function setTheme(themeSelect, themeToggleBtn, mode) {
  localStorage.setItem(THEME_KEY, mode);
  applyTheme(mode);
  if (themeSelect) themeSelect.value = mode;
  updateThemeIcon(themeToggleBtn, document.documentElement.dataset.theme);
}

function initTheme(themeSelect, themeToggleBtn) {
  const saved = localStorage.getItem(THEME_KEY) || "auto";
  setTheme(themeSelect, themeToggleBtn, saved);

  const mq = window.matchMedia("(prefers-color-scheme: light)");
  mq.addEventListener?.("change", () => {
    const current = localStorage.getItem(THEME_KEY) || "auto";
    if (current === "auto") applyTheme("auto");
  });

  themeSelect?.addEventListener("change", (e) => {
    setTheme(themeSelect, themeToggleBtn, e.target.value);
  });

  themeToggleBtn?.addEventListener("click", () => {
    const actual = document.documentElement.dataset.theme || "dark";
    const next = actual === "dark" ? "light" : "dark";
    setTheme(themeSelect, themeToggleBtn, next);
  });
}

/** ---------- Backend call ---------- **/
async function fetchSqlText(userText, { signal } = {}) {
  const url = config.URL_rest + "sql/text";

  // Создаем собственный AbortController с timeout 60 секунд
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 90000); // 90 секунд

  // Если передан внешний signal, слушаем его тоже
  if (signal) {
    signal.addEventListener('abort', () => controller.abort());
  }

  const requestBody = {
    user_conditions: userText,
    model: "gemini-2.5-pro",
    default_row_count: 10,
    default_row_from: 0,
    default_order: "law_reg_date desc"
  };

  try {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(requestBody),
      signal: controller.signal
    });

    clearTimeout(timeoutId); // Очищаем timeout если запрос успешен

    if (!res.ok) {
      const text = await res.text();
      throw new Error(`HTTP ${res.status}: ${text}`);
    }

    return await res.json();
  } catch (error) {
    clearTimeout(timeoutId);
    if (error.name === 'AbortError') {
      throw new Error('Request timeout after 60 seconds');
    }
    throw error;
  }
}

async function executeSqlViaApi({ sqlText, params, token }, { signal } = {}) {
  const url = config.URL + "v2/execute";
  const body = {
    params: {
      script: sqlText,
      datas: params ?? null
    },
    token: token ?? null
  };

  const res = await fetch(url, {
    method: "PUT",
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
    body: JSON.stringify(body),
    signal
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`EXECUTE HTTP ${res.status}: ${text}`);
  }

  const ct = res.headers.get("content-type") || "";
  if (ct.includes("application/json")) return await res.json();
  return await res.text();
}

/** ---------- App ---------- **/
document.addEventListener("DOMContentLoaded", () => {
  const chatListEl = el("chatList");
  const messagesEl = el("messages");
  const chatTitleEl = el("chatTitle");
  const searchInputEl = el("searchInput");

  const newChatBtn = el("newChatBtn");
  const clearBtn = el("clearBtn");
  const exportBtn = el("exportBtn");
  const toggleAllBtn = el("toggleAllBtn");
  let allCollapsed = false; // Глобальное состояние: false = развернуто, true = свернуто

  const composerForm = el("composerForm");
  const promptInput = el("promptInput");
  const sendBtn = el("sendBtn");

  const themeSelect = el("themeSelect");
  const themeToggleBtn = el("themeToggle");
  const genOverlay = el("genOverlay");

  if (!chatListEl || !messagesEl || !chatTitleEl) {
    console.error("Core UI elements not found", { chatListEl, messagesEl, chatTitleEl });
    return;
  }
  if (!composerForm || !promptInput || !sendBtn) {
    console.error("Composer elements not found", { composerForm, promptInput, sendBtn });
    return;
  }

  state = loadState();
  initTheme(themeSelect, themeToggleBtn);

  /** ---------- UI helpers ---------- **/
  function setGenerating(on) {
    isGenerating = on;
    if (sendBtn) {
      sendBtn.textContent = on ? "Stop" : "Send";
      sendBtn.classList.toggle("btn-danger", on);
    }
  }

  function setOverlay(on) {
    if (genOverlay) genOverlay.classList.toggle("active", on);
  }

  function buildSqlWithParams(m) {
    let text = m.sql || "";
    if (hasParams(m.params)) {
      text += "\n\n-- params\n";
      text += JSON.stringify(m.params, null, 2);
    }
    return text;
  }
  const uiBusyEl = el("uiBusy");

function setUiBusy(on) {
    // Берём элемент каждый раз — не важно, когда DOM загрузился
    const elBusy = document.getElementById("uiBusy");
    if (!elBusy) return;
    elBusy.classList.toggle("active", !!on);
}

  // Обёртка для тяжёлых операций:
  function withUiBusy(fn) {
    return (...args) => {
      if (!uiBusyEl) {
        // если индикатора нет, просто выполняем
        return fn(...args);
      }

      setUiBusy(true);

      // Даём браузеру шанс нарисовать индикатор,
      // а уже потом делаем тяжёлую работу
      requestAnimationFrame(() => {
        try {
          fn(...args);
        } finally {
          setUiBusy(false);
        }
      });
    };
  }

  /** ---------- Rendering ---------- **/
  function renderMarkdownSafe(text) {
    if (window.marked) {
      marked.setOptions({ breaks: true, gfm: true, headerIds: false, mangle: false });
      return marked.parse(text, { sanitize: false, headerIds: false, mangle: false });
    }
    return escapeHtml(text).replace(/\n/g, "<br/>");
  }

  function scrollToBottom() {
    messagesEl.scrollTop = messagesEl.scrollHeight;
  }

  function scrollToTop() {
    messagesEl.scrollTop = 0;
  }

  function renderChatList() {
    const q = (searchInputEl?.value || "").trim().toLowerCase();

    chatListEl.innerHTML = "";
    const chats = state.chats
      .slice()
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
      name.textContent = chat.title || "Untitled";

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
            const next = (input.value || "").trim() || "Untitled";
            chat.title = next;
            saveState();

            // если это активный чат — обновляем заголовок сверху
            if (chat.id === state.activeChatId) {
                renderChatTitle();
            }
          }

          name.textContent = chat.title || "Untitled";
          // НЕ вызываем renderAll() чтобы не сбросить фокус
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

  function renderMessages() {
    const messagesContainer = document.querySelector('.messages');
    if (!messagesContainer) return;

    const currentChat = getActiveChat();
    if (!currentChat) return;

    messagesContainer.innerHTML = '';

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
        copyBtn.onclick = () => {
          if (m.role === 'user') {
            copyToClipboard(m.content);
          } else {
            let text = '';
            if (m.content) text += m.content + '\n\n';
            if (m.sql) text += 'SQL:\n' + m.sql;
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
          deleteBtn.textContent = '❌';
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
          deleteBtn.textContent = '❌';
          deleteBtn.title = 'Удалить вопрос и ответ';
          deleteBtn.style.cssText = 'padding: 4px 8px; font-size: 12px;';
          deleteBtn.onclick = () => deleteMessage(currentChat.id, m.id);

          topControls.appendChild(deleteBtn);
        }

        // Показываем/скрываем кнопки при наведении на сообщение
        bubble.addEventListener('mouseenter', () => {
          topControls.style.opacity = '1';
        });
        bubble.addEventListener('mouseleave', () => {
          topControls.style.opacity = '0';
        });

        bubble.appendChild(topControls);
      }

      // ---------- Основной контент (то, что сворачивается) ----------
      const collapsibleContent = document.createElement('div');
      collapsibleContent.className = 'collapsible-content';
      if (m.collapsed) {
        collapsibleContent.style.display = 'none';
      }

      // Текстовое содержимое
      if (m.content) {
        const content = document.createElement('div');
        content.className = 'content';
        content.innerHTML = renderMarkdownSafe(m.content);
        makeLinksOpenInNewTab(content);
        collapsibleContent.appendChild(content);
      }

      // SQL блок
      if (m.sql) {
        const sqlWrap = document.createElement('div');
        sqlWrap.className = 'sql-wrap';
        if (m.error) sqlWrap.classList.add('error');

        const sqlHead = document.createElement('div');
        sqlHead.className = 'sql-head';
        sqlHead.innerHTML = `
          <span>SQL Query</span>
          <div class="sql-actions">
            <button class="sql-btn">Copy SQL</button>
            <button class="sql-btn">${m.sqlOpen ? 'Hide' : 'Show'}</button>
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

        // блок Params
        if (m.params) {
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

        // Подсветка
        if (typeof hljs !== 'undefined') {
          hljs.highlightElement(sqlCode);
        }
      }

      // Таблица
      if (m.table && m.table.rows && m.table.rows.length > 0) {
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
          <button class="sql-btn">Copy CSV</button>
        `;

        const tblScroller = document.createElement('div');
        tblScroller.className = 'tbl-scroller';

        const table = document.createElement('table');
        table.className = 'tbl';

        const thead = document.createElement('thead');
        const headerRow = document.createElement('tr');
        for (const col of columns) {
          const th = document.createElement('th');
          th.textContent = col;
          headerRow.appendChild(th);
        }
        thead.appendChild(headerRow);
        table.appendChild(thead);

        const tbody = document.createElement('tbody');
        for (const row of rows) {
          const tr = document.createElement('tr');
          for (const col of columns) {
            const td = document.createElement('td');
            const value = row[col];
            td.innerHTML = escapeCell(value, col, row);
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
          const csv = toCsv(rows, columns);
          copyToClipboard(csv);
        };
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

      if (m.role === "assistant" && (m.restRequestAt || m.restResponseAt)) {
        const isTable = !!m.table;
        const len = isTable ? null : (m.content || "").length;
        const tReq = m.restRequestAt ? formatTimeForMeta(m.restRequestAt) : null;
        const tResp = m.restResponseAt ? formatTimeForMeta(m.restResponseAt) : null;
        const dur = m.restDurationMs != null ? formatDurationMs(m.restDurationMs) : null;

        const parts = [];
        if (!isTable && len) parts.push(`len: ${len}`);
        if (tReq) parts.push(`REST start: ${tReq}`);
        if (tResp) parts.push(`REST end: ${tResp}`);
        if (dur) parts.push(`REST: ${dur}`);

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
      messagesContainer.appendChild(msg);
    }

    // по умолчанию — скроллим в конец (для новых сообщений)
    messagesContainer.scrollTop = messagesContainer.scrollHeight;

    // ⭐ после рендера — выравниваем кнопки по верхней видимой строке
    requestAnimationFrame(() => adjustHoverOffsets());
  }


  function renderAll() {
    renderChatList();
    renderMessages();

    // обновляем заголовок активного чата
    const active = getActiveChat();
    if (chatTitleEl) {
      chatTitleEl.textContent = active?.title || "New chat";
    }
  }


  // ⭐ Выравнивание кнопок по верхнему краю видимой части сообщения
  function adjustHoverOffsets() {
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

    function toggleMessageInternal(messageId) {
    const currentChat = getActiveChat();
    if (!currentChat) return;

    const message = currentChat.messages.find(m => m.id === messageId);
    if (!message) return;

    // Переключаем только это сообщение
    message.collapsed = !message.collapsed;

    // Проверяем, есть ли хоть один развернутый ассистент
    const anyExpanded = currentChat.messages.some(
      (m, idx) => idx > 0 && m.role === "assistant" && !m.collapsed
    );

    // Обновляем глобальный флаг "все свернуты"
    allCollapsed = !anyExpanded;

    // Обновляем подпись на глобальной кнопке
    toggleAllBtn.textContent = allCollapsed ? "+" : "−";
    toggleAllBtn.title = allCollapsed
      ? "Развернуть все сообщения"
      : "Свернуть все сообщения";

    saveState();
    renderMessages();

    // После перерендера скроллим к началу этого сообщения
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

  // Внешняя функция, которая используется в onClick
  function toggleMessage(messageId) {
    withUiBusy(toggleMessageInternal)(messageId);
  }


  /** ---------- Actions ---------- **/
  function deleteMessage(chatId, messageId) {
    const chat = state.chats.find(c => c.id === chatId);
    if (!chat) return;

    // ⭐ сохраняем текущий scrollTop, чтобы не улетать в конец
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
    renderMessages();

    // ⭐ возвращаемся к прежнему положению скролла
    requestAnimationFrame(() => {
      if (messagesEl) {
        messagesEl.scrollTop = prevScrollTop;
      }
    });
  }

  function deleteChat(chatId) {
    const idx = state.chats.findIndex(c => c.id === chatId);
    if (idx === -1) return;

    state.chats.splice(idx, 1);

    if (!state.chats.length) {
      const chat = createChat("New chat");
      state.chats.push(chat);
      state.activeChatId = chat.id;
    } else if (state.activeChatId === chatId) {
      state.activeChatId = state.chats[0].id;
    }

    saveState();
    renderAll();
  }

  function newChat() {
    const title = prompt("Введите имя чата:", "New chat") || "New chat";
    const chat = createChat(title.trim() || "New chat");
    state.chats.push(chat);
    state.activeChatId = chat.id;
    saveState();
    renderAll();
    promptInput.focus();
  }

  function clearMessages() {
    const chat = getActiveChat();
    chat.messages = [
      { id: crypto.randomUUID(), role: "assistant", content: "Чат очищен. Напиши новое сообщение 👇" }
    ];
    saveState();
    renderMessages();
  }

  function exportJSON() {
    const blob = new Blob([JSON.stringify(state, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "chat-export.json";
    a.click();
    URL.revokeObjectURL(url);
  }

  /** ---------- Composer ---------- **/
  function autoGrow(textarea) {
    textarea.style.height = "auto";
    const max = 160;
    const next = Math.min(textarea.scrollHeight, max);
    textarea.style.height = next + "px";
    textarea.style.overflowY = textarea.scrollHeight > max ? "auto" : "hidden";
  }

  function getLastUserMessage() {
    const chat = getActiveChat();
    if (!chat) return "";
    for (let i = chat.messages.length - 1; i >= 0; i--) {
      if (chat.messages[i].role === "user") return chat.messages[i].content || "";
    }
    return "";
  }

  function canSendOnEnter(textarea) {
    const v = textarea.value;
    const end = textarea.selectionEnd;
    const inLastLine = v.indexOf("\n", end) === -1;
    const atEnd = end === v.length;
    return inLastLine && atEnd;
  }

  promptInput.addEventListener("input", () => autoGrow(promptInput));

  sendBtn.addEventListener("click", (e) => {
    e.preventDefault();
    if (typeof composerForm.requestSubmit === "function") {
      composerForm.requestSubmit();
    } else {
      composerForm.dispatchEvent(new Event("submit", { cancelable: true }));
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
          lastUserMessageCache = last;
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
        lastUserMessageCache = "";
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

    currentAbortController = new AbortController();
    setGenerating(true);
    setOverlay(true);

    try {
      // передаём ещё и userMsg
      await fakeStreamAnswer(text, assistantMsg, userMsg, currentAbortController.signal);
    } catch (err) {
      if (err?.name !== "AbortError") {
        assistantMsg.error = true;
        assistantMsg.content += `\n\n⚠️ Error: ${err?.message || err}`;
        renderMessages();
      }
    } finally {
      setGenerating(false);
      setOverlay(false);
      currentAbortController = null;
      saveState();
      renderMessages();
    }
  });

  function formatExecuteResult(result) {
    if (typeof result === "string") return result;
    if (!Array.isArray(result)) return JSON.stringify(result, null, 2);
    if (result.length === 0) return "Результат: пустой массив";

    return result
      .map((row, idx) => {
        if (typeof row !== "object" || row === null) {
          return result.length === 1
            ? String(row)
            : `${idx + 1}) ${String(row)}`;
        }

        const lines = [];

        for (const [key, value] of Object.entries(row)) {
          // 🟦 массив словарей
          if (
            Array.isArray(value) &&
            value.length > 0 &&
            value.every(v => typeof v === "object" && v !== null && !Array.isArray(v))
          ) {
            lines.push(`  **${key}**:`);
            value.forEach((obj, subIdx) => {
              lines.push(`    ${subIdx + 1})`);
              for (const [subKey, subValue] of Object.entries(obj)) {
                lines.push(
                  `      **${subKey}**: ${subValue === null ? "null" : String(subValue)}`
                );
              }
              lines.push("");
            });
          }
          // 🟩 одиночный словарь
          else if (value && typeof value === "object" && !Array.isArray(value)) {
            lines.push(`  **${key}**:`);
            for (const [subKey, subValue] of Object.entries(value)) {
              lines.push(
                `    **${subKey}**: ${subValue === null ? "null" : String(subValue)}`
              );
            }
          }
          // обычное поле
          else {
            lines.push(
              `  **${key}**: ${value === null ? "null" : String(value)}`
            );
          }
        }

        return result.length === 1
          ? lines.join("\n")
          : `${idx + 1})\n${lines.join("\n")}`;
      })
      .join("\n\n");
  }

  async function fakeStreamAnswer(userText, assistantMsg, userMsg, signal) {
    try {
      // --- тайминги REST-запроса к URL_rest (fetchSqlText) ---
      const restStart = new Date();
      const t0 = performance.now();

      // сохраняем время начала REST-запроса
      assistantMsg.restRequestAt = restStart.toISOString();
      if (userMsg) userMsg.restRequestAt = assistantMsg.restRequestAt;

      const response = await fetchSqlText(userText, { signal });

      const restEnd = new Date();
      const durationMs = Math.round(performance.now() - t0);

      // сохраняем время окончания и длительность
      assistantMsg.restResponseAt = restEnd.toISOString();
      assistantMsg.restDurationMs = durationMs;

      if (userMsg) {
        userMsg.restResponseAt = assistantMsg.restResponseAt;
        userMsg.restDurationMs = durationMs;
      }

      let sqlText = "";
      let params = null;

      if (response && typeof response === "object") {
        sqlText = typeof response.sql === "string" ? response.sql : "";
        params = response.params ?? null;
      }

      if (!sqlText) throw new Error("SQL not generated");

      assistantMsg.sql = sqlText;
      assistantMsg.params = params;
      renderMessages();

      const encodedToken = await getEncodedAdminToken({ signal });

      let executeResult;
      try {
        executeResult = await executeSqlViaApi(
          { sqlText, params, token: encodedToken },
          { signal }
        );
      } catch (execErr) {
        assistantMsg.error = true;
        assistantMsg.content = "❌ Ошибка выполнения SQL\n\n" + (execErr?.message || String(execErr));
        renderMessages();
        return;
      }

      setOverlay(false);

      if (isArrayOfObjects(executeResult)) {
        const rows = executeResult;
        const columns = getColumnsFromRows(rows);

        // Проверяем, есть ли "сложные" колонки: словарь или массив словарей
        const hasComplex = rows.some(r =>
          r && Object.values(r).some(v =>
            (
              Array.isArray(v) &&
              v.length > 0 &&
              v.every(o => o && typeof o === "object" && !Array.isArray(o))
            ) ||
            (
              v && typeof v === "object" && !Array.isArray(v)
            )
          )
        );

        // Показываем таблицу только если:
        // 1) нет сложных структур (массивов словарей / словарей)
        // 2) колонок не больше MAX_TABLE_COLS
        // 3) строк больше 1
        if (!hasComplex && columns.length > 0 && columns.length <= MAX_TABLE_COLS && rows.length > 1) {
          assistantMsg.table = { columns, rows };
          assistantMsg.csv = toCsv(rows, columns);
          assistantMsg.content = `✅ Result rendered as table (${rows.length} rows, ${columns.length} cols).`;
          assistantMsg.hasTable = true;
          renderMessages();
          return;
        }
      }

      // Во всех остальных случаях показываем как текстовый список
      const answerText = formatExecuteResult(executeResult);
      assistantMsg.content = answerText;
      renderMessages();
    } catch (error) {
      if (error?.name === "AbortError") return;
      assistantMsg.error = true;
      assistantMsg.content = "❌ Ошибка при подготовке запроса\n\n" + (error?.message || String(error));
      renderMessages();
    }
  }

  /** ---------- Token crypto helpers ---------- **/
  function base64UrlDecodeToString(b64url) {
    let b64 = (b64url || "").replace(/-/g, "+").replace(/_/g, "/");
    while (b64.length % 4 !== 0) b64 += "=";

    const binary = atob(b64);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);

    return new TextDecoder("utf-8").decode(bytes);
  }

  function decode(key, enc) {
    const plain = base64UrlDecodeToString(enc);
    const dec = [];
    for (let i = 0; i < plain.length; i++) {
      const key_c = key[i % key.length];
      const dec_c = String.fromCharCode((256 + plain.charCodeAt(i) - key_c.charCodeAt(0)) % 256);
      dec.push(dec_c);
    }
    return dec.join("");
  }

  function base64UrlEncodeFromString(str) {
    const bytes = new TextEncoder().encode(str);
    let binary = "";
    for (let i = 0; i < bytes.length; i++) binary += String.fromCharCode(bytes[i]);

    return btoa(binary)
      .replace(/\+/g, "-")
      .replace(/\//g, "_")
      .replace(/=+$/, "");
  }

  function encode(key, text) {
    const enc = [];
    for (let i = 0; i < text.length; i++) {
      const key_c = key[i % key.length];
      const enc_c = String.fromCharCode((text.charCodeAt(i) + key_c.charCodeAt(0)) % 256);
      enc.push(enc_c);
    }
    return base64UrlEncodeFromString(enc.join(""));
  }

  async function loginSuperadmin({ signal } = {}) {
    let result = false;
    let token_admin_local = null;
    let txt = "";

    const password = decode("abcd", config.kirill);
    const payload = {
      params: {
        login: "superadmin",
        password,
        rememberMe: true
      }
    };

    try {
      const res = await fetch(config.URL + "v1/login", {
        method: "POST",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: JSON.stringify(payload),
        signal
      });

      txt = await res.text();
      result = res.ok;

      if (!result) return { txt, result, token_admin: null };

      let js;
      try { js = JSON.parse(txt); } catch { return { txt, result: false, token_admin: null }; }

      if (js && typeof js.accessToken === "string") {
        const tokenKey = decode("abcd", config.kirill);
        const decrypted = decode(tokenKey, js.accessToken);
        try { token_admin_local = JSON.parse(decrypted); } catch { token_admin_local = decrypted; }
      }

      return { txt, result, token_admin: token_admin_local };
    } catch (err) {
      if (err?.name === "AbortError") throw err;
      return { txt: `Other error occurred: ${err?.message || err}`, result: false, token_admin: null };
    }
  }

  async function getEncodedAdminToken({ signal } = {}) {
    // Если хочешь включить живой логин — раскомментируй блок ниже и убери return с хардкодом
    // if (!token_admin) {
    //   const login = await loginSuperadmin({ signal });
    //   if (!login?.result || !login?.token_admin) throw new Error(`Superadmin login failed: ${login?.txt || "unknown error"}`);
    //   token_admin = login.token_admin;
    // }
    // const key = decode("abcd", config.kirill);
    // return encode(key, JSON.stringify(token_admin));

    return "w4bCi8KcwpPClsKOW1lawqfCtMOcw5vDi8OYw5FNWcKZwpXCuMOSw6DCi8KYwoxDwp7CsMKhwrTDm8OXw5zCjsKmQVtqYn_CmcKfwpnCncKZUm5YYX7Co8KnwpvCpsKgVltkUW3DnsOlw47DnsKOW1lawqTDgMOZw5fDm8ONw5DCjsKiwqZTw4g=";
  }

  // Функция глобального сворачивания/разворачивания
  function toggleAllMessages() {
    const chat = getActiveChat();
    if (!chat) return;

    // новое глобальное состояние
    const next = !allCollapsed;
    allCollapsed = next;

    // Проставляем collapsed всем ассистентским сообщениям (кроме первого приветственного)
    chat.messages.forEach((m, idx) => {
      if (idx === 0) return;
      if (m.role === "assistant") {
        m.collapsed = next;
      }
    });

    // Обновляем кнопку
    toggleAllBtn.textContent = next ? "+" : "−";
    toggleAllBtn.title = next ? "Развернуть все сообщения" : "Свернуть все сообщения";

    saveState();
    renderMessages();
  }

  // Добавляем обработчик события
  toggleAllBtn?.addEventListener("click", withUiBusy(toggleAllMessages));

  function formatTimeForMeta(iso) {
    if (!iso) return "";
    const d = new Date(iso);
    return d.toLocaleTimeString();
  }

  function formatDurationMs(ms) {
    if (ms == null) return "";
    if (ms < 1000) return `${ms} ms`;
    return (ms / 1000).toFixed(2) + " s";
  }

  function linkify(text) {
    if (!text) return text;

    const urlRegex = /(https?:\/\/[^\s)]+)|((?<!\/)www\.[^\s)]+)/gi;

    return text.replace(urlRegex, (rawUrl) => {
      const url = rawUrl.startsWith("http") ? rawUrl : `https://${rawUrl}`;
      return `<a href="${url}"
                target="_blank"
                rel="noopener noreferrer"
                class="table-link">${rawUrl}</a>`;
    });
  }

  function makeLinksOpenInNewTab(root) {
    if (!root) return;
    const links = root.querySelectorAll('a[href]');
    links.forEach(a => {
      const href = a.getAttribute('href') || '';
      // Только для http/https — чтобы не трогать якоря, mailto и т.п.
      if (href.startsWith('http://') || href.startsWith('https://')) {
        a.setAttribute('target', '_blank');
        a.setAttribute('rel', 'noopener noreferrer');
        a.classList.add('table-link'); // чтобы был такой же стиль, как в таблице
      }
    });
  }

  /** ---------- Init bindings ---------- **/
  scrollToEndBtn?.addEventListener("click", () => {
    scrollToBottom();
  });

  scrollToTopBtn?.addEventListener("click", () => {
    scrollToTop();
  });

  newChatBtn?.addEventListener("click", newChat);
  clearBtn?.addEventListener("click", clearMessages);
  exportBtn?.addEventListener("click", exportJSON);
  searchInputEl?.addEventListener("input", renderChatList);

  renderAll();

  promptInput.focus();
});
