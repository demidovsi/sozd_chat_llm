/**
 * Управление состоянием приложения
 */

import { LS_KEY, DB_SCHEMA_KEY, DB_SCHEMAS, QUERY_MODE_KEY, QUERY_MODES } from './config.js';

export let state = null;
export let currentAbortController = null;
export let isGenerating = false;
export let lastUserMessageCache = "";
export let restSessionId = null;
export let dbSchema = null;
export let queryMode = "sql"; // Текущий режим работы (по умолчанию SQL)

export function setState(newState) {
  state = newState;
}

export function setCurrentAbortController(controller) {
  currentAbortController = controller;
}

export function setIsGenerating(value) {
  isGenerating = value;
}

export function setLastUserMessageCache(value) {
  lastUserMessageCache = value;
}

export function setRestSessionId(value) {
  restSessionId = value;
  // Сохраняем session_id в localStorage
  if (value) {
    localStorage.setItem('restSessionId', value);
    console.log(`Session ID saved to localStorage: ${value}`);
  }
}

export function setDbSchema(value) {
  dbSchema = value;
  // Сохраняем db_schema в localStorage
  if (value) {
    localStorage.setItem(DB_SCHEMA_KEY, value);
    console.log(`DB Schema saved to localStorage: ${value}`);
  }
}

export function setQueryMode(value) {
  queryMode = value;
  // Сохраняем query_mode в localStorage
  if (value) {
    localStorage.setItem(QUERY_MODE_KEY, value);
    console.log(`Query Mode saved to localStorage: ${value}`);
  }
}

export function getCurrentMode() {
  return QUERY_MODES[queryMode] || QUERY_MODES.sql;
}

export function loadState() {
  // Загружаем session_id из localStorage
  const savedSessionId = localStorage.getItem('restSessionId');
  if (savedSessionId) {
    restSessionId = savedSessionId;
    console.log(`Session ID loaded from localStorage: ${savedSessionId}`);
  }

  // Загружаем query_mode из localStorage
  const savedQueryMode = localStorage.getItem(QUERY_MODE_KEY);
  if (savedQueryMode && QUERY_MODES[savedQueryMode]) {
    queryMode = savedQueryMode;
    console.log(`Query Mode loaded from localStorage: ${savedQueryMode}`);
  } else {
    // По умолчанию SQL режим
    queryMode = "sql";
    localStorage.setItem(QUERY_MODE_KEY, queryMode);
  }

  // Загружаем db_schema из localStorage
  const savedDbSchema = localStorage.getItem(DB_SCHEMA_KEY);
  if (savedDbSchema) {
    dbSchema = savedDbSchema;
    console.log(`DB Schema loaded from localStorage: ${savedDbSchema}`);
  } else {
    // По умолчанию первая схема (sozd)
    dbSchema = DB_SCHEMAS[0].value;
    localStorage.setItem(DB_SCHEMA_KEY, dbSchema);
  }

  const raw = localStorage.getItem(LS_KEY);
  if (raw) {
    try {
      const data = JSON.parse(raw);

      // Миграция: добавляем schema и mode к старым чатам
      if (data.chats && Array.isArray(data.chats)) {
        data.chats.forEach(chat => {
          if (!chat.schema) {
            chat.schema = DB_SCHEMAS[0].value; // Присваиваем первую схему старым чатам
          }
          if (!chat.mode) {
            chat.mode = "sql"; // Присваиваем SQL режим старым чатам
          }
        });
      }

      return data;
    } catch {}
  }
  const init = { activeChatId: null, chats: [] };
  const chat = createChat("New chat");
  init.chats.push(chat);
  init.activeChatId = chat.id;
  saveState(init);
  return init;
}

export function saveState(next = state) {
  localStorage.setItem(LS_KEY, JSON.stringify(next));
}

export function createChat(title, schema = null, mode = null) {
  const currentMode = mode || queryMode;
  const modeConfig = QUERY_MODES[currentMode];

  return {
    id: crypto.randomUUID(),
    title,
    schema: schema || dbSchema, // Привязываем чат к схеме БД
    mode: currentMode, // Привязываем чат к режиму работы
    createdAt: Date.now(),
    messages: [
      {
        id: crypto.randomUUID(),
        role: "assistant",
        content: `Привет! Режим: ${modeConfig.label}. ${modeConfig.description}`
      }
    ]
  };
}

export function getActiveChat() {
  const found = state.chats.find(c => c.id === state.activeChatId);
  if (found) return found;

  // Если активный чат не найден, ищем первый чат текущей схемы
  const schemaChats = state.chats.filter(c => c.schema === dbSchema);
  if (schemaChats.length > 0) {
    state.activeChatId = schemaChats[0].id;
    saveState();
    return schemaChats[0];
  }

  // Если нет чатов для текущей схемы, возвращаем первый чат (любой схемы)
  state.activeChatId = state.chats[0]?.id || null;
  saveState();
  return state.chats[0];
}

export function getSchemaChats() {
  return state.chats.filter(c => c.schema === dbSchema);
}
