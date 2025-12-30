/**
 * Функции форматирования данных
 */

import { escapeHtml, isUrl, formatTimestamp } from './utils.js';
import { MAX_TABLE_CELL_LENGTH, MAX_CARD_TEXT_LENGTH } from './config.js';

/**
 * Получает значение из объекта по пути с точкой
 * Например: getValueByPath(row, "metadata.id") вернет row.metadata.id
 * @param {Object} obj - Объект для получения значения
 * @param {string} path - Путь к значению (может содержать точки)
 * @returns {*} Значение по указанному пути или undefined
 */
function getValueByPath(obj, path) {
  if (!path || !obj) return undefined;

  // Если путь содержит точку, разбираем его
  if (path.includes('.')) {
    const parts = path.split('.');
    let value = obj;
    for (const part of parts) {
      if (value == null) return undefined;
      value = value[part];
    }
    return value;
  }

  // Иначе просто возвращаем значение по ключу
  return obj[path];
}

/**
 * Экранирует значение ячейки для отображения в таблице
 * Поддерживает получение значений по пути с точкой (например, "metadata.id")
 * @param {*} v - Значение ячейки
 * @param {string} column - Название колонки (может быть путем с точкой)
 * @param {Object} row - Объект строки (для получения значения по пути)
 * @returns {string} HTML-строка для отображения
 */
export function escapeCell(v, column, row) {
  // Если v не передано, но есть column и row, пытаемся получить значение по пути
  if (v === undefined && column && row) {
    v = getValueByPath(row, column);
  }

  if (v == null) return "<em>null</em>";
  if (v === "") return "<em>empty</em>";

  let str = String(v);

  // Форматируем timestamp в читаемый формат YYYY-MM-DD HH:MM:SS
  str = formatTimestamp(str);

  // Специальная обработка для filename_bucket - создаем кнопку скачивания
  // Проверка нечувствительна к регистру (filename_bucket или FILENAME_BUCKET)
  // Filename уже содержит префикс с номером закона
  if (column && column.toLowerCase() === 'filename_bucket' && str && str !== 'null' && str !== 'empty') {
    const escapedFilename = escapeHtml(str);
    return `<button class="download-btn" data-filename="${escapedFilename}" title="Скачать файл из GCS">📥 ${escapedFilename}</button>`;
  }

  // URL - делаем гиперссылкой без обрезания
  if (isUrl(str)) {
    const escapedUrl = escapeHtml(str);
    return `<a href="${escapedUrl}" target="_blank" rel="noopener noreferrer" class="table-link" title="Открыть в новом окне">${escapedUrl}</a>`;
  }

  // Обрезаем длинный текст с кнопкой "читать далее"
  if (str.length > MAX_TABLE_CELL_LENGTH) {
    const truncated = str.substring(0, MAX_TABLE_CELL_LENGTH);
    const escapedTruncated = escapeHtml(truncated);
    const escapedFull = escapeHtml(str);

    return `<span class="cell-text-truncated">
      <span class="cell-text-short">${escapedTruncated}...</span>
      <span class="cell-text-full" style="display: none;">${escapedFull}</span>
      <button class="cell-expand-btn" onclick="toggleCellText(this)" title="Показать полный текст">читать далее</button>
    </span>`;
  }

  return escapeHtml(str);
}

/**
 * Форматирует значение для отображения в карточке с обрезкой длинного текста
 * @param {*} value - Значение для форматирования
 * @returns {string} Отформатированная строка (может содержать HTML для кнопки "читать далее")
 */
function formatCardValue(value) {
  if (value === null) return "null";

  let str = String(value);

  // Форматируем timestamp в читаемый формат YYYY-MM-DD HH:MM:SS
  str = formatTimestamp(str);

  // Если текст короткий, возвращаем как есть
  if (str.length <= MAX_CARD_TEXT_LENGTH) {
    return str;
  }

  // Для длинного текста создаем обертку с кнопкой "читать далее"
  const truncated = str.substring(0, MAX_CARD_TEXT_LENGTH);
  const escapedTruncated = escapeHtml(truncated);
  const escapedFull = escapeHtml(str);

  return `<span class="cell-text-truncated">
    <span class="cell-text-short">${escapedTruncated}...</span>
    <span class="cell-text-full" style="display: none;">${escapedFull}</span>
    <button class="cell-expand-btn" onclick="toggleCellText(this)" title="Показать полный текст">читать далее</button>
  </span>`;
}

/**
 * Преобразует массив объектов в CSV формат
 * Поддерживает колонки с путями (например, "metadata.id")
 * @param {Array} rows - Массив объектов-строк
 * @param {Array<string>} columns - Массив названий колонок
 * @returns {string} CSV-строка
 */
export function toCsv(rows, columns) {
  const esc = (s) => {
    const div = document.createElement('div');
    div.innerHTML = String(s ?? "");
    const cleanValue = div.textContent || div.innerText || "";

    if (/[",\n\r;]/.test(cleanValue)) return `"${cleanValue.replace(/"/g, '""')}"`;
    return cleanValue;
  };

  const header = columns.map(esc).join(";");
  const lines = rows.map(r =>
    columns.map(c => {
      // Получаем значение по пути (с поддержкой точки)
      const value = getValueByPath(r, c);
      return esc(value);
    }).join(";")
  );
  return [header, ...lines].join("\n");
}

export function formatTimeForMeta(iso) {
  if (!iso) return "";
  const d = new Date(iso);
  return d.toLocaleTimeString();
}

export function formatDurationMs(ms) {
  if (ms == null) return "";
  if (ms < 1000) return `${ms} ms`;
  return (ms / 1000).toFixed(2) + " s";
}

export function formatExecuteResult(result) {
  if (typeof result === "string") return result;
  if (!Array.isArray(result)) return JSON.stringify(result, null, 2);
  if (result.length === 0) return "Результат: пустой массив";

  return result
    .map((row, idx) => {
      if (typeof row !== "object" || row === null) {
        const formattedValue = formatCardValue(row);
        return result.length === 1
          ? formattedValue
          : `${idx + 1}) ${formattedValue}`;
      }

      const lines = [];

      for (const [key, value] of Object.entries(row)) {
        if (
          Array.isArray(value) &&
          value.length > 0 &&
          value.every(v => typeof v === "object" && v !== null && !Array.isArray(v))
        ) {
          lines.push(`  **${key}**:`);
          value.forEach((obj, subIdx) => {
            lines.push(`    ${subIdx + 1})`);
            for (const [subKey, subValue] of Object.entries(obj)) {
              // Проверка на filename_bucket в вложенном объекте
              if (subKey.toLowerCase() === 'filename_bucket' && subValue && subValue !== 'null') {
                const escapedFilename = escapeHtml(String(subValue));
                lines.push(
                  `      **${subKey}**: <button class="download-btn" data-filename="${escapedFilename}" title="Скачать файл из GCS">📥 ${escapedFilename}</button>`
                );
              } else {
                lines.push(
                  `      **${subKey}**: ${formatCardValue(subValue)}`
                );
              }
            }
            lines.push("");
          });
        }
        else if (value && typeof value === "object" && !Array.isArray(value)) {
          lines.push(`  **${key}**:`);
          for (const [subKey, subValue] of Object.entries(value)) {
            // Проверка на filename_bucket в вложенном объекте
            if (subKey.toLowerCase() === 'filename_bucket' && subValue && subValue !== 'null') {
              const escapedFilename = escapeHtml(String(subValue));
              lines.push(
                `    **${subKey}**: <button class="download-btn" data-filename="${escapedFilename}" title="Скачать файл из GCS">📥 ${escapedFilename}</button>`
              );
            } else {
              lines.push(
                `    **${subKey}**: ${formatCardValue(subValue)}`
              );
            }
          }
        }
        else {
          // Проверка на filename_bucket на верхнем уровне
          if (key.toLowerCase() === 'filename_bucket' && value && value !== 'null') {
            const escapedFilename = escapeHtml(String(value));
            lines.push(
              `  **${key}**: <button class="download-btn" data-filename="${escapedFilename}" title="Скачать файл из GCS">📥 ${escapedFilename}</button>`
            );
          } else {
            lines.push(
              `  **${key}**: ${formatCardValue(value)}`
            );
          }
        }
      }

      return result.length === 1
        ? lines.join("\n")
        : `${idx + 1})\n${lines.join("\n")}`;
    })
    .join("\n\n");
}
