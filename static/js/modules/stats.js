/**
 * Статистика и метрики чатов
 */

import { state, dbSchema } from './state.js';
import { getSchemaList } from './config.js';

export function getMemorySize(text) {
  if (!text) return 0;
  return new Blob([text]).size;
}

export const formatSize = (bytes) => {
  if (bytes < 1024) return `${bytes}B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)}KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)}MB`;
};

export function getChatStats(chat) {
  if (!chat || !chat.messages) return "";

  const userMessages = chat.messages.filter((m, idx) => idx > 0 && m.role === "user");
  const assistantMessages = chat.messages.filter((m, idx) => idx > 0 && m.role === "assistant");

  // Если нет пользовательских сообщений, не показываем статистику
  if (userMessages.length === 0) return "";

  const totalSize = chat.messages.reduce((sum, m) => {
    return sum + getMemorySize(m.content || '') + getMemorySize(m.sql || '');
  }, 0);

  return `${userMessages.length} U • ${assistantMessages.length} A • ${formatSize(totalSize)}`;
}

export function updateGlobalStats() {
  const userSubEl = document.querySelector('.user-sub');
  if (!userSubEl || !state.chats) return;

  // Фильтруем чаты по текущей схеме
  const schemaChats = state.chats.filter(c => c.schema === dbSchema);
  const totalChats = schemaChats.length;
  let totalSize = 0;

  schemaChats.forEach(chat => {
    if (chat.messages) {
      totalSize += chat.messages.reduce((sum, m) => {
        return sum + getMemorySize(m.content || '') + getMemorySize(m.sql || '');
      }, 0);
    }
  });

  // Находим название текущей схемы
  const schemaList = getSchemaList();
  const schemaLabel = schemaList.find(s => s.value === dbSchema)?.label || dbSchema;

  userSubEl.textContent = `${schemaLabel} • ${totalChats} чатов • ${formatSize(totalSize)}`;
}
