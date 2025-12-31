/**
 * UI хелперы и утилиты интерфейса
 */

import { hasParams } from './utils.js';

export function setGenerating(sendBtn, on) {
  if (sendBtn) {
    sendBtn.textContent = on ? "Stop" : "Send";
    sendBtn.classList.toggle("btn-danger", on);
  }
}

export function setOverlay(genOverlay, on) {
  if (genOverlay) genOverlay.classList.toggle("active", on);
}

export function setOverlayText(text) {
  const genOverlay = document.getElementById("genOverlay");
  if (genOverlay) {
    const genText = genOverlay.querySelector(".gen-text");
    const genCard = genOverlay.querySelector(".gen-card");

    if (genText) {
      genText.textContent = text;
    }

    // Добавляем класс "receiving" для "Receiving data…"
    if (genCard) {
      if (text.toLowerCase().includes("receiving")) {
        genCard.classList.add("receiving");
      } else {
        genCard.classList.remove("receiving");
      }
    }
  }
}

export function buildSqlWithParams(m) {
  let text = m.sql || "";
  if (hasParams(m.params)) {
    text += "\n\n-- params\n";
    text += JSON.stringify(m.params, null, 2);
  }
  return text;
}

export function setUiBusy(on) {
  const elBusy = document.getElementById("uiBusy");
  if (!elBusy) return;
  elBusy.classList.toggle("active", !!on);
}

export function withUiBusy(fn) {
  return (...args) => {
    const elBusy = document.getElementById("uiBusy");
    if (!elBusy) {
      return fn(...args);
    }

    setUiBusy(true);

    requestAnimationFrame(() => {
      try {
        fn(...args);
      } finally {
        setUiBusy(false);
      }
    });
  };
}

export function renderMarkdownSafe(text) {
  if (window.marked) {
    marked.setOptions({ breaks: true, gfm: true, headerIds: false, mangle: false });
    return marked.parse(text, { sanitize: false, headerIds: false, mangle: false });
  }
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML.replace(/\n/g, "<br/>");
}

export function autoGrow(textarea) {
  textarea.style.height = "auto";
  const max = 160;
  const next = Math.min(textarea.scrollHeight, max);
  textarea.style.height = next + "px";
  textarea.style.overflowY = textarea.scrollHeight > max ? "auto" : "hidden";
}

export function canSendOnEnter(textarea) {
  const v = textarea.value;
  const end = textarea.selectionEnd;
  const inLastLine = v.indexOf("\n", end) === -1;
  const atEnd = end === v.length;
  return inLastLine && atEnd;
}
