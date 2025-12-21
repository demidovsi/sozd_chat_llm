/**
 * Управление состоянием приложения
 */

import { LS_KEY } from './config.js';

export let state = null;
export let currentAbortController = null;
export let isGenerating = false;
export let lastUserMessageCache = "";
export let restSessionId = null;

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

export function loadState() {
  // Загружаем session_id из localStorage
  const savedSessionId = localStorage.getItem('restSessionId');
  if (savedSessionId) {
    restSessionId = savedSessionId;
    console.log(`Session ID loaded from localStorage: ${savedSessionId}`);
  }

  const raw = localStorage.getItem(LS_KEY);
  if (raw) {
    try { return JSON.parse(raw); } catch {}
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

export function createChat(title) {
  return {
    id: crypto.randomUUID(),
    title,
    createdAt: Date.now(),
    messages: [
      {
        id: crypto.randomUUID(),
        role: "assistant",
        content: "Привет! Это демо-интерфейс. Напиши сообщение снизу — я отвечу (через fetchSqlText + v2/execute)."
      }
    ]
  };
}

export function getActiveChat() {
  const found = state.chats.find(c => c.id === state.activeChatId);
  if (found) return found;

  state.activeChatId = state.chats[0]?.id || null;
  saveState();
  return state.chats[0];
}
