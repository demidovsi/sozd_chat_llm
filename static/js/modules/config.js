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
export const MAX_TABLE_COLS = 20; // Максимальное количество колонок в таблице
export const MAX_AXIS_LABEL_LENGTH = 20; // Максимальная длина метки на оси графика

// Доступные схемы БД
export const DB_SCHEMAS = [
  { value: "sozd", label: "СОЗД" },
  { value: "lib", label: "Гаазе" },
  { value: "family", label: "Семья" },
  { value: "urban", label: "Игра" },
  { value: "gen", label: "ГЕО" },
  { value: "evg", label: "ЕВГЕНИЯ" }
];
