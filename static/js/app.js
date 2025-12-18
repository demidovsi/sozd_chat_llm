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
  URL: "http://159.223.0.234:5000/",
  URL_rest: "https://159.223.0.234:5051/"
//  URL_rest: "http://localhost:5050/"
};

const LS_KEY = "chatui_demo_v1";
const THEME_KEY = "chatui_theme";
const MAX_TABLE_COLS = 8; // ← N (поменяй как хочешь)

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

function escapeHtml(s) {
  return (s || "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
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

function escapeCell(v, column, row) {
  if (v === null || v === undefined) return "";

  // Если колонка содержит точку - это развернутый ключ словаря
  if (typeof column === "string" && column.includes(".")) {
    const [mainKey, subKey] = column.split(".", 2);
    const mainValue = row?.[mainKey];
    if (mainValue && typeof mainValue === "object" && !Array.isArray(mainValue)) {
      const subValue = mainValue[subKey];
      if (subValue === null || subValue === undefined) return "";
      if (typeof subValue === "object") return JSON.stringify(subValue);
      return String(subValue);
    }
    return "";
  }

  if (typeof v === "object") return JSON.stringify(v);
  return String(v);
}

function toCsv(rows, columns) {
  const esc = (s) => {
    const v = String(s ?? "");
    if (/[",\n\r;]/.test(v)) return `"${v.replace(/"/g, '""')}"`;
    return v;
  };

  const header = columns.map(esc).join(";");
  const lines = rows.map(r => columns.map(c => esc(escapeCell(r?.[c]))).join(";"));
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

  const requestBody = {
    user_conditions: userText,
    model: "gemini-2.5-pro",
    default_row_count: 10,
    default_row_from: 0,
    default_order: "law_reg_date desc"
  };

  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(requestBody),
    signal
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`HTTP ${res.status}: ${text}`);
  }

  return await res.json();
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
          // Проверяем, что клик НЕ по кнопке удаления
          if (e.target.closest('.icon-btn')) return;
          // Проверяем, является ли цель клика заголовком чата или его содержимым
          if (e.target.id === 'chatTitle' || e.target.closest('#chatTitle')) return;

          // Проверяем, что это НЕ двойной клик
          if (e.detail === 2) return;

          // Если чат уже активен, не переключаем
          if (chat.id === state.activeChatId) return;

          state.activeChatId = chat.id;
          saveState();
          renderAll();
          requestAnimationFrame(() => promptInput.focus());
      });



      chatListEl.appendChild(item);
    }
  }

  function renderMessages() {
    const chat = getActiveChat();
    chatTitleEl.textContent = chat?.title || "Chat";

    messagesEl.innerHTML = "";

    for (const m of chat.messages) {
      const row = document.createElement("div");
      row.className = "msg " + (m.role === "user" ? "user" : "assistant");
      if (m.error) row.classList.add("error");

      const role = document.createElement("div");
      role.className = "role";
      role.textContent = m.role === "user" ? "U" : "A";

      const bubble = document.createElement("div");
      bubble.className = "bubble";

      const isTableMsg = (m.role === "assistant" && m.table && Array.isArray(m.table.rows));

      if (!isTableMsg) {
        const copyBtn = document.createElement("button");
        copyBtn.className = "copy-btn";
        copyBtn.type = "button";
        copyBtn.textContent = "Copy";
        copyBtn.addEventListener("click", async () => {
          const ok = await copyToClipboard(m.content);
          copyBtn.textContent = ok ? "Copied" : "Failed";
          setTimeout(() => (copyBtn.textContent = "Copy"), 900);
        });
        bubble.appendChild(copyBtn);
      }

      const content = document.createElement("div");
      content.className = "content";
      content.innerHTML = renderMarkdownSafe(m.content);
      bubble.appendChild(content);

      if (isTableMsg) {
        const wrap = document.createElement("div");
        wrap.className = "tbl-wrap";

        const head = document.createElement("div");
        head.className = "tbl-head";

        const left = document.createElement("div");
        left.textContent = `Rows: ${m.table.rows.length}`;

        const actions = document.createElement("div");
        actions.className = "tbl-actions";

        const exportCsvBtn = document.createElement("button");
        exportCsvBtn.type = "button";
        exportCsvBtn.className = "sql-btn";
        exportCsvBtn.textContent = "Export CSV";
        exportCsvBtn.disabled = !m.csv;

        exportCsvBtn.addEventListener("click", () => {
          const csv = m.csv || "";
          const name = `result_${new Date().toISOString().slice(0, 19).replace(/[:T]/g, "-")}.csv`;
          downloadTextFile(name, csv, "text/csv;charset=utf-8");
        });

        actions.appendChild(exportCsvBtn);
        head.appendChild(left);
        head.appendChild(actions);

        const scroller = document.createElement("div");
        scroller.className = "tbl-scroller";

        const table = document.createElement("table");
        table.className = "tbl";

        const thead = document.createElement("thead");
        const trh = document.createElement("tr");
        for (const col of m.table.columns) {
          const th = document.createElement("th");
          th.textContent = col;
          trh.appendChild(th);
        }
        thead.appendChild(trh);

        const tbody = document.createElement("tbody");
        for (const rowObj of m.table.rows) {
          const tr = document.createElement("tr");
          for (const col of m.table.columns) {
            const td = document.createElement("td");
            td.textContent = escapeCell(rowObj?.[col], col, rowObj);
            tr.appendChild(td);
          }
          tbody.appendChild(tr);
        }

        table.appendChild(thead);
        table.appendChild(tbody);
        scroller.appendChild(table);

        wrap.appendChild(head);
        wrap.appendChild(scroller);
        bubble.appendChild(wrap);
      }

      if (m.role === "assistant" && m.sql) {
        const wrap = document.createElement("div");
        wrap.className = "sql-wrap";
        if (m.sqlOpen) wrap.classList.add("open");

        const head = document.createElement("div");
        head.className = "sql-head";

        const left = document.createElement("div");
        left.textContent = "sql_text";

        const actions = document.createElement("div");
        actions.className = "sql-actions";

        const toggleBtn = document.createElement("button");
        toggleBtn.type = "button";
        toggleBtn.className = "sql-btn";
        toggleBtn.textContent = m.sqlOpen ? "Hide SQL" : "Show SQL";
        toggleBtn.addEventListener("click", () => {
          m.sqlOpen = !m.sqlOpen;
          saveState();
          // Переключаем класс только на текущем wrap элементе
          wrap.classList.toggle("open", m.sqlOpen);
          toggleBtn.textContent = m.sqlOpen ? "Hide SQL" : "Show SQL";
          //renderMessages();
        });

        const copySqlBtn = document.createElement("button");
        copySqlBtn.type = "button";
        copySqlBtn.className = "sql-btn";
        copySqlBtn.textContent = "Copy SQL";
        copySqlBtn.addEventListener("click", async () => {
          const textToCopy = buildSqlWithParams(m);
          const ok = await copyToClipboard(textToCopy);
          copySqlBtn.textContent = ok ? "Copied" : "Failed";
          setTimeout(() => (copySqlBtn.textContent = "Copy SQL"), 900);
        });

        actions.appendChild(toggleBtn);
        actions.appendChild(copySqlBtn);

        if (hasParams(m.params)) {
          const copyParamsBtn = document.createElement("button");
          copyParamsBtn.type = "button";
          copyParamsBtn.className = "sql-btn";
          copyParamsBtn.textContent = "Copy params";
          copyParamsBtn.addEventListener("click", async () => {
            const ok = await copyToClipboard(JSON.stringify(m.params, null, 2));
            copyParamsBtn.textContent = ok ? "Copied" : "Failed";
            setTimeout(() => (copyParamsBtn.textContent = "Copy params"), 900);
          });
          actions.appendChild(copyParamsBtn);
        }

        head.appendChild(left);
        head.appendChild(actions);

        const body = document.createElement("div");
        body.className = "sql-body";

        const pre = document.createElement("pre");
        pre.className = "sql-pre";

        const code = document.createElement("code");
        code.className = "language-sql";
        code.textContent = buildSqlWithParams(m);

        pre.appendChild(code);
        body.appendChild(pre);

        wrap.appendChild(head);
        wrap.appendChild(body);

        bubble.appendChild(wrap);
      }

      row.appendChild(role);
      row.appendChild(bubble);
      messagesEl.appendChild(row);
    }

    if (window.hljs) {
      messagesEl.querySelectorAll("pre code").forEach((block) => {
        try { window.hljs.highlightElement(block); } catch {}
      });
    }

    scrollToBottom();
  }

  function renderAll() {
    renderChatList();
    renderMessages();
  }

  /** ---------- Actions ---------- **/

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

    chat.messages.push({ id: crypto.randomUUID(), role: "user", content: text });

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
      await fakeStreamAnswer(text, assistantMsg, currentAbortController.signal);
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

  if (typeof result[0] === "object" && result[0] !== null) {
    return result
      .map((row, idx) => {
        const flattenedRow = {};

        // Разворачиваем словари в отдельные поля
        Object.entries(row).forEach(([key, value]) => {
          if (value && typeof value === "object" && !Array.isArray(value)) {
            // Если значение - словарь, разворачиваем его ключи
            Object.entries(value).forEach(([subKey, subValue]) => {
              flattenedRow[`${key}.${subKey}`] = subValue;
            });
          } else {
            flattenedRow[key] = value;
          }
        });

        const lines = Object.entries(flattenedRow).map(
          ([key, value]) => {
            const displayValue = value === null ? "null" : String(value);
            // Всегда выделяем ключи жирным (и для одной строки, и для нескольких)
            return `  **${key}**: ${displayValue}`;
          }
        );

        // Убираем порядковый номер если запись только одна
        if (result.length === 1) {
          return lines.join("\n");
        }
        return `${idx + 1})\n${lines.join("\n")}`;
      })
      .join("\n\n");
  }

  // Для простых значений тоже убираем номер если элемент один
  if (result.length === 1) {
    return String(result[0]);
  }

  return result.map((value, idx) => `${idx + 1}) ${String(value)}`).join("\n");
}

async function fakeStreamAnswer(userText, assistantMsg, signal) {
  try {
    const response = await fetchSqlText(userText, { signal });

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

      // Показываем таблицу только если:
      // 1) колонок не больше MAX_TABLE_COLS (с учетом развернутых словарей)
      // 2) И строк больше 1
      if (columns.length > 0 && columns.length <= MAX_TABLE_COLS && rows.length > 1) {
        assistantMsg.table = { columns, rows };
        assistantMsg.csv = toCsv(rows, columns);
        assistantMsg.content = `✅ Result rendered as table (${rows.length} rows, ${columns.length} cols).`;
        renderMessages();
        return;
      }
    }

    // Во всех остальных случаях показываем как текстовый список
    // (одна строка ИЛИ много колонок с учетом развернутых словарей)
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
