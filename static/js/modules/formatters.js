/**
 * Функции форматирования данных
 */

import { escapeHtml, isUrl } from './utils.js';

export function escapeCell(v, column, row) {
  if (v == null) return "<em>null</em>";
  if (v === "") return "<em>empty</em>";

  const str = String(v);

  if (isUrl(str)) {
    const escapedUrl = escapeHtml(str);
    return `<a href="${escapedUrl}" target="_blank" rel="noopener noreferrer" class="table-link" title="Открыть в новом окне">${escapedUrl}</a>`;
  }

  return escapeHtml(str);
}

export function toCsv(rows, columns) {
  const esc = (s) => {
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
        return result.length === 1
          ? String(row)
          : `${idx + 1}) ${String(row)}`;
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
              lines.push(
                `      **${subKey}**: ${subValue === null ? "null" : String(subValue)}`
              );
            }
            lines.push("");
          });
        }
        else if (value && typeof value === "object" && !Array.isArray(value)) {
          lines.push(`  **${key}**:`);
          for (const [subKey, subValue] of Object.entries(value)) {
            lines.push(
              `    **${subKey}**: ${subValue === null ? "null" : String(subValue)}`
            );
          }
        }
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
