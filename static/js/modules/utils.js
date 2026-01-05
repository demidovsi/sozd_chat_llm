/**
 * Утилиты общего назначения
 */

export const el = (id) => document.getElementById(id);

export function normalizeUserMessage(text) {
  return (text || "")
    .replace(/\r\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

export function sleep(ms) {
  return new Promise(res => setTimeout(res, ms));
}

export function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

export function isUrl(string) {
  try {
    const url = new URL(string);
    return url.protocol === 'http:' || url.protocol === 'https:';
  } catch {
    return false;
  }
}

/**
 * Форматирует timestamp в читаемый формат (убирает микросекунды, timezone, заменяет T на пробел)
 * Входной формат:
 *   - 2025-12-30T11:50:42.605428
 *   - 2025-12-30T11:50:42Z
 *   - 2025-12-30T11:50:42.559263+00:00
 * Выходной формат: 2025-12-30 11:50:42
 * @param {string} timestamp - Timestamp строка
 * @returns {string} - Отформатированный timestamp или исходная строка если не является timestamp
 */
export function formatTimestamp(timestamp) {
  if (typeof timestamp !== 'string') return timestamp;

  // Проверяем, является ли это ISO 8601 timestamp (с поддержкой timezone offset)
  const isoRegex = /^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}:\d{2})(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})?$/;
  const match = timestamp.match(isoRegex);

  if (match) {
    // Возвращаем в формате YYYY-MM-DD HH:MM:SS
    return `${match[1]} ${match[2]}`;
  }

  return timestamp;
}

export function getColumnsFromRows(rows) {
  const set = new Set();
  for (const r of rows) {
    if (r && typeof r === "object" && !Array.isArray(r)) {
      Object.entries(r).forEach(([key, value]) => {
        if (value && typeof value === "object" && !Array.isArray(value)) {
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

export function isArrayOfObjects(x) {
  return Array.isArray(x) && x.length > 0 && x.every(r => r && typeof r === "object" && !Array.isArray(r));
}

export async function copyToClipboard(text) {
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

export function hasParams(p) {
  if (!p || typeof p !== "object") return false;
  if (Array.isArray(p)) return p.length > 0;

  return Object.entries(p).some(
    ([, v]) => v !== null && v !== undefined && v !== ""
  );
}

export function downloadTextFile(filename, text, mime = "text/plain;charset=utf-8") {
  const BOM = "\uFEFF";
  const blob = new Blob([BOM + text], { type: mime });

  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

export function makeLinksOpenInNewTab(root) {
  if (!root) return;
  const links = root.querySelectorAll('a[href]');
  links.forEach(a => {
    const href = a.getAttribute('href') || '';
    if (href.startsWith('http://') || href.startsWith('https://')) {
      a.setAttribute('target', '_blank');
      a.setAttribute('rel', 'noopener noreferrer');
      a.classList.add('table-link');
    }
  });
}

/**
 * Скачивает файл из Google Cloud Storage через API endpoint
 * @param {string} bucketName - Имя bucket (не используется, т.к. bucket указан на бэкенде)
 * @param {string} filename - Имя файла (уже содержит префикс с номером закона)
 * @note Если файл является .7z архивом, сервер автоматически разархивирует его
 *       и вернет с правильным именем в заголовке Content-Disposition
 */
export async function downloadFromGCS(bucketName, filename) {
  try {
    // Используем API endpoint для безопасного скачивания
    const apiUrl = `/api/download?filename=${encodeURIComponent(filename)}&bucket_name=${encodeURIComponent(bucketName)}`;

    console.log(`Downloading file via API: ${apiUrl}`);

    // Используем fetch для получения файла
    const response = await fetch(apiUrl);

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({ error: 'Unknown error' }));
      throw new Error(errorData.error || `HTTP error! status: ${response.status}`);
    }

    // Получаем blob из ответа
    const blob = await response.blob();

    // Создаем URL для blob
    const blobUrl = URL.createObjectURL(blob);

    // Извлекаем правильное имя файла из заголовка Content-Disposition
    let downloadFilename = filename.split('/').pop(); // fallback - исходное имя без пути
    const contentDisposition = response.headers.get('Content-Disposition');
    if (contentDisposition) {
      // Извлекаем имя файла из заголовка (формат: attachment; filename="file.txt" или filename*=UTF-8''file.txt)
      const filenameMatch = contentDisposition.match(/filename\*?=['"]?(?:UTF-\d+'')?([^"';]+)['"]?/i);
      if (filenameMatch && filenameMatch[1]) {
        downloadFilename = decodeURIComponent(filenameMatch[1]);
      }
    }

    // Создаем ссылку и кликаем для скачивания
    const link = document.createElement('a');
    link.href = blobUrl;
    link.download = downloadFilename; // Используем правильное имя файла из ответа сервера
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    // Освобождаем память
    URL.revokeObjectURL(blobUrl);

    console.log(`File download completed: ${downloadFilename} (requested: ${filename})`);
  } catch (error) {
    console.error('Error downloading file from GCS:', error);
    alert(`Ошибка при скачивании файла: ${error.message}`);
  }
}

/**
 * Переключает отображение между text и stage в результатах поиска
 * @param {string|number} messageIdOrIndex - ID сообщения (новый формат) или индекс панели (старый формат)
 * @param {number|string} panelIndexOrContentType - Индекс панели (новый) или тип контента (старый)
 * @param {string} contentType - Тип контента (только новый формат)
 */
window.switchContent = function(messageIdOrIndex, panelIndexOrContentType, contentType) {
  console.log('=== switchContent called ===');
  console.log('Args:', messageIdOrIndex, panelIndexOrContentType, contentType);

  // Определяем формат вызова (старый или новый)
  let messageId, panelIndex, actualContentType;

  if (contentType === undefined) {
    // Старый формат: switchContent(panelIndex, contentType)
    panelIndex = messageIdOrIndex;
    actualContentType = panelIndexOrContentType;
    // Находим сообщение по контексту (ищем в DOM)
    const panel = document.querySelector(`.search-tab-panel[data-panel-index="${panelIndex}"]`);
    if (!panel) {
      console.error('Panel not found for old format!');
      return;
    }
    const messageElement = panel.closest('.msg');
    if (messageElement) {
      messageId = messageElement.dataset.id;
    }
  } else {
    // Новый формат: switchContent(messageId, panelIndex, contentType)
    messageId = messageIdOrIndex;
    panelIndex = panelIndexOrContentType;
    actualContentType = contentType;
  }

  console.log('Parsed - messageId:', messageId, 'panelIndex:', panelIndex, 'contentType:', actualContentType);

  // Находим сообщение в DOM
  const messageElement = messageId ? document.querySelector(`.msg[data-id="${messageId}"]`) : null;
  if (!messageElement) {
    console.error('Message element not found!');
    return;
  }

  // Находим все элементы контента для этой панели
  const textElement = messageElement.querySelector(`.search-result-text[data-content-type="text"][data-panel-index="${panelIndex}"]`);
  const stageElement = messageElement.querySelector(`.search-result-text[data-content-type="stage"][data-panel-index="${panelIndex}"]`);

  console.log('textElement found:', !!textElement);
  console.log('stageElement found:', !!stageElement);

  if (!textElement || !stageElement) {
    console.error('Content elements not found!');
    return;
  }

  // Находим панель для поиска кнопок
  const panel = messageElement.querySelector(`.search-tab-panel[data-panel-index="${panelIndex}"]`);
  if (!panel) {
    console.error('Panel not found for index:', panelIndex);
    return;
  }

  // Находим кнопки
  const textButton = panel.querySelector('.switcher-btn[data-content-type="text"]');
  const stageButton = panel.querySelector('.switcher-btn[data-content-type="stage"]');

  console.log('textButton found:', !!textButton);
  console.log('stageButton found:', !!stageButton);

  // Переключаем видимость
  if (actualContentType === 'text') {
    textElement.style.display = 'block';
    stageElement.style.display = 'none';
    if (textButton) {
      textButton.classList.add('active');
      if (stageButton) stageButton.classList.remove('active');
    }
    console.log('Switched to TEXT');
  } else if (actualContentType === 'stage') {
    textElement.style.display = 'none';
    stageElement.style.display = 'block';
    if (stageButton) {
      stageButton.classList.add('active');
      if (textButton) textButton.classList.remove('active');
    }
    console.log('Switched to STAGE');
  }

  // Сохраняем состояние в state (только если есть messageId)
  if (messageId) {
    // Используем динамический импорт для доступа к state
    import('./state.js').then(({ getActiveChat, saveState }) => {
      const chat = getActiveChat();
      if (chat) {
        const message = chat.messages.find(m => m.id === messageId);
        if (message) {
          if (!message.searchPanelStates) {
            message.searchPanelStates = {};
          }
          message.searchPanelStates[panelIndex] = actualContentType;
          saveState();
          console.log('State saved:', message.searchPanelStates);
        }
      }
    });
  }

  console.log('=== switchContent completed ===');
}