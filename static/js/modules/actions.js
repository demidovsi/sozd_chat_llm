/**
 * Действия пользователя (CRUD операции с чатами и сообщениями)
 */

import { state, saveState, createChat, getActiveChat } from './state.js';
import { getChatStats, updateGlobalStats } from './stats.js';

export function deleteMessage(chatId, messageId, messagesEl, chatTitleEl, renderMessages, updateChatTitleWithStats) {
  const chat = state.chats.find(c => c.id === chatId);
  if (!chat) return;

  const prevScrollTop = messagesEl?.scrollTop ?? 0;

  const msgIndex = chat.messages.findIndex(m => m.id === messageId);
  if (msgIndex === -1 || msgIndex === 0) return;

  if (chat.messages[msgIndex].role === "user" &&
      msgIndex + 1 < chat.messages.length &&
      chat.messages[msgIndex + 1].role === "assistant") {
    chat.messages.splice(msgIndex, 2);
  } else if (chat.messages[msgIndex].role === "assistant" &&
             msgIndex > 0 &&
             chat.messages[msgIndex - 1].role === "user") {
    chat.messages.splice(msgIndex - 1, 2);
  } else {
    chat.messages.splice(msgIndex, 1);
  }

  saveState();
  renderMessages();

  requestAnimationFrame(() => {
    if (messagesEl) {
      messagesEl.scrollTop = prevScrollTop;
    }
  });

  updateChatTitleWithStats(chatTitleEl);
}

export function deleteChat(chatId, renderAll) {
  const idx = state.chats.findIndex(c => c.id === chatId);
  if (idx === -1) return;

  state.chats.splice(idx, 1);

  if (!state.chats.length) {
    const chat = createChat("New chat");
    state.chats.push(chat);
    state.activeChatId = chat.id;
  } else if (state.activeChatId === chatId) {
    state.activeChatId = state.chats[0].id;
  }

  saveState();
  renderAll();
}

export function newChat(promptInput, renderAll) {
  const title = prompt("Введите имя чата:", "New chat") || "New chat";
  const chat = createChat(title.trim() || "New chat");
  state.chats.push(chat);
  state.activeChatId = chat.id;
  saveState();
  renderAll();
  promptInput.focus();
}

export function clearMessages(renderMessages, chatTitleEl, renderChatList) {
  const chat = getActiveChat();
  chat.messages = [
    { id: crypto.randomUUID(), role: "assistant", content: "Чат очищен. Напиши новое сообщение 👇" }
  ];
  saveState();
  renderMessages();
  updateChatTitleWithStats(chatTitleEl);
  if (renderChatList) renderChatList();
}

export function exportJSON() {
  const blob = new Blob([JSON.stringify(state, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = "chat-export.json";
  a.click();
  URL.revokeObjectURL(url);
}

export function toggleMessage(messageId, renderMessages, updateToggleAllButton, withUiBusy) {
  const toggleMessageInternal = () => {
    const currentChat = getActiveChat();
    if (!currentChat) return;

    const message = currentChat.messages.find(m => m.id === messageId);
    if (!message) return;

    message.collapsed = !message.collapsed;

    saveState();
    renderMessages();

    updateToggleAllButton();

    requestAnimationFrame(() => {
      const node = document.querySelector(`.msg[data-id="${messageId}"]`);
      if (node) {
        node.scrollIntoView({
          block: "start",
          inline: "nearest",
          behavior: "auto"
        });
      }
    });
  };

  withUiBusy(toggleMessageInternal)();
}

export function toggleAllMessages(toggleAllBtn, renderMessages) {
  const chat = getActiveChat();
  if (!chat) return;

  // Определяем текущее состояние на основе реальных данных
  const anyExpanded = chat.messages.some(
    (m, idx) => idx > 0 && m.role === "assistant" && !m.collapsed
  );
  const allCollapsed = !anyExpanded;

  // Переключаем на противоположное состояние
  const nextState = !allCollapsed;

  // Применяем новое состояние ко всем сообщениям ассистента
  chat.messages.forEach((m, idx) => {
    if (idx === 0) return; // Пропускаем первое приветственное сообщение
    if (m.role === "assistant") {
      m.collapsed = nextState;
    }
  });

  // Обновляем кнопку
  toggleAllBtn.textContent = nextState ? "+" : "−";
  toggleAllBtn.title = nextState ? "Развернуть все сообщения" : "Свернуть все сообщения";

  saveState();
  renderMessages();
}

export function updateToggleAllButton(toggleAllBtn) {
  const chat = getActiveChat();
  if (!chat || !toggleAllBtn) return false;

  const anyExpanded = chat.messages.some(
    (m, idx) => idx > 0 && m.role === "assistant" && !m.collapsed
  );

  const allCollapsed = !anyExpanded;

  toggleAllBtn.textContent = allCollapsed ? "+" : "−";
  toggleAllBtn.title = allCollapsed
    ? "Развернуть все сообщения"
    : "Свернуть все сообщения";

  return allCollapsed;
}

export function updateChatTitleWithStats(chatTitleEl) {
  const active = getActiveChat();
  if (chatTitleEl && active) {
    const stats = getChatStats(active);
    chatTitleEl.innerHTML = `
      <div class="chat-title-main">${active.title || "New chat"}</div>
      <div class="chat-title-stats">${stats}</div>
    `;
  }
  updateGlobalStats();
}

export function getLastUserMessage() {
  const chat = getActiveChat();
  if (!chat) return "";
  for (let i = chat.messages.length - 1; i >= 0; i--) {
    if (chat.messages[i].role === "user") return chat.messages[i].content || "";
  }
  return "";
}
