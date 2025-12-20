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