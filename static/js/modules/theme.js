/**
 * Управление темой интерфейса
 */

import { THEME_KEY } from './config.js';

export function applyTheme(mode) {
  let theme = mode;
  if (mode === "auto") {
    theme = window.matchMedia("(prefers-color-scheme: light)").matches ? "light" : "dark";
  }
  document.documentElement.dataset.theme = theme;
}

export function updateThemeIcon(themeToggleBtn, theme) {
  if (!themeToggleBtn) return;
  themeToggleBtn.textContent = theme === "dark" ? "🌙" : "☀️";
}

export function setTheme(themeSelect, themeToggleBtn, mode) {
  localStorage.setItem(THEME_KEY, mode);
  applyTheme(mode);
  if (themeSelect) themeSelect.value = mode;
  updateThemeIcon(themeToggleBtn, document.documentElement.dataset.theme);
}

export function initTheme(themeSelect, themeToggleBtn) {
  const saved = localStorage.getItem(THEME_KEY) || "auto";
  setTheme(themeSelect, themeToggleBtn, saved);

  const mq = window.matchMedia("(prefers-color-scheme: light)");
  mq.addEventListener?.("change", () => {
    const current = localStorage.getItem(THEME_KEY) || "auto";
    if (current === "auto") applyTheme("auto");
  });

  themeSelect?.addEventListener("change", (e) => {
    setTheme(themeSelect, themeToggleBtn, e.target.value);
  });

  themeToggleBtn?.addEventListener("click", () => {
    const actual = document.documentElement.dataset.theme || "dark";
    const next = actual === "dark" ? "light" : "dark";
    setTheme(themeSelect, themeToggleBtn, next);
  });
}
