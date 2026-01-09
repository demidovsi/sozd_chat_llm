/**
 * Управление состоянием приложения
 */

import { LS_KEY, DB_SCHEMA_KEY, QUERY_MODE_KEY, SCHEMA_MODES, getSchemaList, getModesForSchema, getModeConfig } from './config.js';

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

/**
 * Генерирует приветственное сообщение с примерами для режима
 * @param {Object} modeConfig - Конфигурация режима
 * @param {string} schemaValue - Значение схемы БД
 * @returns {string} - Приветственное сообщение с примерами
 */
export function getWelcomeMessage(modeConfig, schemaValue) {
  if (!modeConfig) return "Привет! Чем могу помочь?";

  const schemaLabel = SCHEMA_MODES[schemaValue]?.label || schemaValue;

  // Приветственное сообщение для SQL режима
  if (modeConfig.id === 'sql') {
    return `👋 Добро пожаловать в **SQL режим** для схемы **${schemaLabel}**!

Я помогу вам генерировать SQL запросы на естественном языке. Просто опишите что вы хотите найти, и я создам SQL запрос и выполню его.

**Примеры запросов:**

📌 **Поиск по тексту:**
- "Покажи все законы о налогах"
- "Найди документы содержащие слово 'образование'"

📌 **Фильтрация по дате:**
- "Покажи законы принятые в 2023 году"
- "Найди документы опубликованные после 1 января 2024"

📌 **Статистика и аналитика:**
- "Посчитай количество законов по годам"
- "Покажи топ 10 самых часто встречающихся терминов"

📌 **Сложные запросы:**
- "Найди все законы о строительстве принятые в 2024 году и отсортируй по дате"

Попробуйте задать свой вопрос! 🚀`;
  }

  // Приветственное сообщение для Custom режима
  if (modeConfig.id === 'custom') {
    return `👋 Добро пожаловать в **Custom режим** для схемы **${schemaLabel}**!

Я использую векторный поиск и AI для поиска релевантной информации в базе данных. Вы можете задавать вопросы и получать ответы с контекстом из документов.

**Примеры запросов:**

📌 **Семантический поиск:**
- "Как регулируется охрана труда?"
- "Расскажи о правах работников"

📌 **Вопросы по темам:**
- "Какие льготы предусмотрены для многодетных семей?"
- "Что говорится о налоге на имущество?"

📌 **Поиск конкретики:**
- "Какой штраф за нарушение ПДД?"
- "Сколько длится отпуск по беременности?"

📌 **Аналитические вопросы:**
- "Сравни изменения в трудовом кодексе за последние годы"

**Доступные режимы просмотра:**
- **Embeddings** - результаты векторного поиска по релевантности
- **Analiz** - сводный ответ AI на основе найденных документов

Задайте свой вопрос! 🔍`;
  }

  // Дефолтное сообщение для других режимов
  return `Привет! Режим: ${modeConfig.label}. ${modeConfig.description}`;
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
        content: getWelcomeMessage(fallbackModeConfig, currentSchema)
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
