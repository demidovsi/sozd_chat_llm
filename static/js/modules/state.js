/**
 * Управление состоянием приложения
 */

import { LS_KEY, DB_SCHEMA_KEY, QUERY_MODE_KEY, getSchemaList, getModesForSchema, getModeConfig } from './config.js';

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
  const modeConfig = getModeConfig(dbSchema, queryMode);
  if (modeConfig) return modeConfig;

  // Fallback: если режим не найден, берем первый доступный режим для схемы
  const availableModes = getModesForSchema(dbSchema);
  const firstModeId = Object.keys(availableModes)[0];
  return availableModes[firstModeId] || null;
}

export function loadState() {
  // Загружаем session_id из localStorage
  const savedSessionId = localStorage.getItem('restSessionId');
  if (savedSessionId) {
    restSessionId = savedSessionId;
    console.log(`Session ID loaded from localStorage: ${savedSessionId}`);
  }

  // Загружаем db_schema из localStorage
  const savedDbSchema = localStorage.getItem(DB_SCHEMA_KEY);
  const schemaList = getSchemaList();

  if (savedDbSchema) {
    dbSchema = savedDbSchema;
    console.log(`DB Schema loaded from localStorage: ${savedDbSchema}`);
  } else {
    // По умолчанию первая схема (sozd)
    dbSchema = schemaList[0]?.value || 'sozd';
    localStorage.setItem(DB_SCHEMA_KEY, dbSchema);
  }

  // Загружаем query_mode из localStorage
  const savedQueryMode = localStorage.getItem(QUERY_MODE_KEY);
  const availableModes = getModesForSchema(dbSchema);

  if (savedQueryMode && availableModes[savedQueryMode]) {
    queryMode = savedQueryMode;
    console.log(`Query Mode loaded from localStorage: ${savedQueryMode}`);
  } else {
    // По умолчанию первый доступный режим для схемы
    queryMode = Object.keys(availableModes)[0] || "sql";
    localStorage.setItem(QUERY_MODE_KEY, queryMode);
    console.log(`Query Mode set to default: ${queryMode}`);
  }

  const raw = localStorage.getItem(LS_KEY);
  if (raw) {
    try {
      const data = JSON.parse(raw);

      // Миграция: добавляем schema и mode к старым чатам, валидируем комбинации
      if (data.chats && Array.isArray(data.chats)) {
        data.chats.forEach(chat => {
          // Добавляем schema, если отсутствует
          if (!chat.schema) {
            chat.schema = schemaList[0]?.value || 'sozd';
          }
          // Добавляем mode, если отсутствует
          if (!chat.mode) {
            chat.mode = "sql";
          }

          // Валидация: проверяем, что режим доступен для схемы
          const chatAvailableModes = getModesForSchema(chat.schema);
          if (!chatAvailableModes[chat.mode]) {
            // Режим недоступен для этой схемы
            const firstMode = Object.keys(chatAvailableModes)[0];
            if (firstMode) {
              console.warn(`Chat ${chat.id}: migrating mode from ${chat.mode} to ${firstMode} for schema ${chat.schema}`);
              chat.mode = firstMode;
            } else {
              // Схема не существует - мигрируем на sozd:sql
              console.warn(`Chat ${chat.id}: schema ${chat.schema} not found, migrating to sozd:sql`);
              chat.schema = 'sozd';
              chat.mode = 'sql';
            }
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
  const currentSchema = schema || dbSchema;
  const currentMode = mode || queryMode;
  const modeConfig = getModeConfig(currentSchema, currentMode);

  // Fallback на первый доступный режим, если конфигурация не найдена
  const fallbackModeConfig = modeConfig || (() => {
    const availableModes = getModesForSchema(currentSchema);
    const firstModeId = Object.keys(availableModes)[0];
    return availableModes[firstModeId];
  })();

  return {
    id: crypto.randomUUID(),
    title,
    schema: currentSchema, // Привязываем чат к схеме БД
    mode: currentMode, // Привязываем чат к режиму работы
    createdAt: Date.now(),
    messages: [
      {
        id: crypto.randomUUID(),
        role: "assistant",
        content: fallbackModeConfig
          ? `Привет! Режим: ${fallbackModeConfig.label}. ${fallbackModeConfig.description}`
          : "Привет!"
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
