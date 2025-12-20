/**
 * Криптографические функции для работы с токенами
 */

import { config } from './config.js';

export function base64UrlDecodeToString(b64url) {
  let b64 = (b64url || "").replace(/-/g, "+").replace(/_/g, "/");
  while (b64.length % 4 !== 0) b64 += "=";

  const binary = atob(b64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);

  return new TextDecoder("utf-8").decode(bytes);
}

export function decode(key, enc) {
  const plain = base64UrlDecodeToString(enc);
  const dec = [];
  for (let i = 0; i < plain.length; i++) {
    const key_c = key[i % key.length];
    const dec_c = String.fromCharCode((256 + plain.charCodeAt(i) - key_c.charCodeAt(0)) % 256);
    dec.push(dec_c);
  }
  return dec.join("");
}

export function base64UrlEncodeFromString(str) {
  const bytes = new TextEncoder().encode(str);
  let binary = "";
  for (let i = 0; i < bytes.length; i++) binary += String.fromCharCode(bytes[i]);

  return btoa(binary)
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");
}

export function encode(key, text) {
  const enc = [];
  for (let i = 0; i < text.length; i++) {
    const key_c = key[i % key.length];
    const enc_c = String.fromCharCode((text.charCodeAt(i) + key_c.charCodeAt(0)) % 256);
    enc.push(enc_c);
  }
  return base64UrlEncodeFromString(enc.join(""));
}

let token_admin = null;

export async function loginSuperadmin({ signal } = {}) {
  let result = false;
  let token_admin_local = null;
  let txt = "";

  const password = decode("abcd", config.kirill);
  const payload = {
    params: {
      login: "superadmin",
      password,
      rememberMe: true
    }
  };

  try {
    const res = await fetch(config.URL + "v1/login", {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify(payload),
      signal
    });

    txt = await res.text();
    result = res.ok;

    if (!result) return { txt, result, token_admin: null };

    let js;
    try { js = JSON.parse(txt); } catch { return { txt, result: false, token_admin: null }; }

    if (js && typeof js.accessToken === "string") {
      const tokenKey = decode("abcd", config.kirill);
      const decrypted = decode(tokenKey, js.accessToken);
      try { token_admin_local = JSON.parse(decrypted); } catch { token_admin_local = decrypted; }
    }

    return { txt, result, token_admin: token_admin_local };
  } catch (err) {
    if (err?.name === "AbortError") throw err;
    return { txt: `Other error occurred: ${err?.message || err}`, result: false, token_admin: null };
  }
}

export async function getEncodedAdminToken({ signal } = {}) {
  // Хардкод токена (можно раскомментировать живой логин)
  return "w4bCi8KcwpPClsKOW1lawqfCtMOcw5vDi8OYw5FNWcKZwpXCuMOSw6DCi8KYwoxDwp7CsMKhwrTDm8OXw5zCjsKmQVtqYn_CmcKfwpnCncKZUm5YYX7Co8KnwpvCpsKgVltkUW3DnsOlw47DnsKOW1lawqTDgMOZw5fDm8ONw5DCjsKiwqZTw4g=";
}
