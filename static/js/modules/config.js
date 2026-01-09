/**
 * Конфигурация приложения
 */

export const config = {
  kirill: "wqzDi8OVw43DjcOOwoTCncKZwpM=",
  URL: "https://sergey-demidov.ru:5001/",
  URL_rest: "https://sergey-demidov.ru:5051/",
  GCS_BUCKET: "sozd-laws-file" // Имя корневого bucket в Google Cloud Storage
};

export const LS_KEY = "chatui_demo_v1";
export const THEME_KEY = "chatui_theme";
export const DB_SCHEMA_KEY = "chatui_db_schema";
export const QUERY_MODE_KEY = "chatui_query_mode"; // Ключ для сохранения режима запросов
export const AUTH_KEY = "chatui_current_user"; // Ключ для текущего пользователя
export const MAX_TABLE_COLS = 20; // Максимальное количество колонок в таблице
export const MAX_AXIS_LABEL_LENGTH = 20; // Максимальная длина метки на оси графика
export const MAX_TABLE_CELL_LENGTH = 200; // Максимальная длина текста в ячейке таблицы
export const MAX_CARD_TEXT_LENGTH = 500; // Максимальная длина текста в карточках

// НОВАЯ СТРУКТУРА: Режимы работы, привязанные к схемам БД
// Каждая схема имеет свой набор режимов с собственными URL и bucket для GCS
export const SCHEMA_MODES = {
  sozd: {
    label: "СОЗД",
    bucket: "sozd-laws-file", // GCS bucket для этой схемы
    modes: {
      sql: {
        id: "sql",
        label: "SQL",
        icon: "🗄️",
        url: config.URL_rest,
        endpoint: "", // SQL использует два отдельных endpoint: sql/text (POST) и v2/execute (PUT)
        method: "POST",
        description: "Генерация SQL запросов и работа с базой данных"
      },
      custom: {
        id: "custom",
        label: "Custom",
        icon: "🤖",
        url: "https://sergey-demidov.ru:5071",
        endpoint: "/api/search",
        method: "POST",
        bucket: "sozd-transcripts", // GCS bucket для скачивания архивов
        description: "Запросы к кастомному API с выбором схемы"
      }
    }
  },
  lib: {
    label: "Гаазе",
    bucket: null, // Нет bucket для этой схемы
    modes: {
      sql: {
        id: "sql",
        label: "SQL",
        icon: "🗄️",
        url: config.URL_rest,
        endpoint: "", // SQL использует два отдельных endpoint: sql/text (POST) и v2/execute (PUT)
        method: "POST",
        description: "Генерация SQL запросов и работа с базой данных"
      },
    }
  },
  family: {
    label: "Семья",
    bucket: null, // Нет bucket для этой схемы
    modes: {
      sql: {
        id: "sql",
        label: "SQL",
        icon: "🗄️",
        url: config.URL_rest,
        endpoint: "", // SQL использует два отдельных endpoint: sql/text (POST) и v2/execute (PUT)
        method: "POST",
        description: "Генерация SQL запросов и работа с базой данных"
      },
    }
  },
  urban: {
    label: "Игра",
    bucket: null, // Нет bucket для этой схемы
    modes: {
      sql: {
        id: "sql",
        label: "SQL",
        icon: "🗄️",
        url: config.URL_rest,
        endpoint: "", // SQL использует два отдельных endpoint: sql/text (POST) и v2/execute (PUT)
        method: "POST",
        description: "Генерация SQL запросов и работа с базой данных"
      },
    }
  },
  eco: {
    label: "ГЕО-ЭКО",
    bucket: null, // Нет bucket для этой схемы
    modes: {
      sql: {
        id: "sql",
        label: "SQL",
        icon: "🗄️",
        url: config.URL_rest,
        endpoint: "", // SQL использует два отдельных endpoint: sql/text (POST) и v2/execute (PUT)
        method: "POST",
        description: "Генерация SQL запросов и работа с базой данных"
      },
    }
  },
  gen: {
    label: "ЕВГЕНИЯ",
    bucket: null, // Нет bucket для этой схемы
    modes: {
      sql: {
        id: "sql",
        label: "SQL",
        icon: "🗄️",
        url: config.URL_rest,
        endpoint: "", // SQL использует два отдельных endpoint: sql/text (POST) и v2/execute (PUT)
        method: "POST",
        description: "Генерация SQL запросов и работа с базой данных"
      },
    }
  },
  ohi: {
    label: "Наш дом Израиль",
    bucket: null, // Нет bucket для этой схемы
    modes: {
      sql: {
        id: "sql",
        label: "SQL",
        icon: "🗄️",
        url: config.URL_rest,
        endpoint: "", // SQL использует два отдельных endpoint: sql/text (POST) и v2/execute (PUT)
        method: "POST",
        description: "Генерация SQL запросов и работа с базой данных"
      },
    }
  }
};

// Вспомогательные функции для работы со схемами и режимами

/**
 * Получить список всех доступных схем
 * @returns {Array<{value: string, label: string}>}
 */
export function getSchemaList() {
  return Object.keys(SCHEMA_MODES).map(value => ({
    value,
    label: SCHEMA_MODES[value].label
  }));
}

/**
 * Получить режимы для конкретной схемы
 * @param {string} schemaValue - Идентификатор схемы (например, "sozd")
 * @returns {Object} - Объект с режимами или пустой объект
 */
export function getModesForSchema(schemaValue) {
  return SCHEMA_MODES[schemaValue]?.modes || {};
}

/**
 * Получить конфигурацию конкретного режима для схемы
 * @param {string} schemaValue - Идентификатор схемы
 * @param {string} modeId - Идентификатор режима (например, "sql")
 * @returns {Object|null} - Конфигурация режима или null
 */
export function getModeConfig(schemaValue, modeId) {
  return SCHEMA_MODES[schemaValue]?.modes?.[modeId] || null;
}

/**
 * Получить GCS bucket для схемы
 * @param {string} schemaValue - Идентификатор схемы
 * @returns {string|null} - Название bucket или null
 */
export function getSchemaBucket(schemaValue) {
  return SCHEMA_MODES[schemaValue]?.bucket || null;
}

/**
 * Получить GCS bucket для конкретного режима
 * @param {string} schemaValue - Идентификатор схемы
 * @param {string} modeId - Идентификатор режима
 * @returns {string|null} - Название bucket или null
 */
export function getModeBucket(schemaValue, modeId) {
  return SCHEMA_MODES[schemaValue]?.modes?.[modeId]?.bucket || null;
}
