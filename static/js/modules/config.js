/**
 * Конфигурация приложения
 */

export const config = {
  kirill: "wqzDi8OVw43DjcOOwoTCncKZwpM=",
  URL: "https://159.223.0.234:5001/",
  URL_rest: "https://159.223.0.234:5051/",
  GCS_BUCKET: "sozd-laws-file" // Имя корневого bucket в Google Cloud Storage
};

export const LS_KEY = "chatui_demo_v1";
export const THEME_KEY = "chatui_theme";
export const DB_SCHEMA_KEY = "chatui_db_schema";
export const QUERY_MODE_KEY = "chatui_query_mode"; // Ключ для сохранения режима запросов
export const MAX_TABLE_COLS = 20; // Максимальное количество колонок в таблице
export const MAX_AXIS_LABEL_LENGTH = 20; // Максимальная длина метки на оси графика

// Режимы работы приложения
export const QUERY_MODES = {
  sql: {
    id: "sql",
    label: "",
    icon: "🗄️",
    url: config.URL_rest,
    endpoint: "", // Используется существующий endpoint
    useSchemas: true, // Требуется выбор схемы БД
    description: "Генерация SQL запросов и работа с базой данных"
  },
  custom: {
    id: "custom",
    label: "",
    icon: "🤖",
    url: "http://другой-url/", // TODO: Заменить на реальный URL
    endpoint: "/api/query", // TODO: Заменить на реальный endpoint
    useSchemas: true, // Тоже требуется выбор схемы
    description: "Запросы к кастомному API с выбором схемы"
  }
  // Можно добавить третий режим без схемы:
  // future: {
  //   id: "future",
  //   label: "Будущий режим",
  //   icon: "🚀",
  //   url: "http://еще-один-url/",
  //   endpoint: "/api/ask",
  //   useSchemas: false, // НЕ требуется схема
  //   description: "Режим без привязки к схеме БД"
  // }
};

// Доступные схемы БД
export const DB_SCHEMAS = [
  { value: "sozd", label: "СОЗД" },
  { value: "lib", label: "Гаазе" },
  { value: "family", label: "Семья" },
  { value: "urban", label: "Игра" },
  { value: "eco", label: "ГЕО-ЭКО" },
  { value: "gen", label: "ЕВГЕНИЯ" },
  { value: "ohi", label: "Наш дом Израиль" }
];
