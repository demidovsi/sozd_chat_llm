/**
 * API вызовы к бэкенду
 */

import { config } from './config.js';
import { restSessionId, setRestSessionId, dbSchema } from './state.js';

export async function fetchSqlText(userText, { signal } = {}) {
  const url = config.URL_rest + "sql/text";

  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 90000);

  if (signal) {
    signal.addEventListener('abort', () => controller.abort());
  }

  const requestUrl = new URL(url);

  const requestBody = {
    user_conditions: userText,
    model: "gemini-2.5-pro",
    default_row_count: 10,
    default_row_from: 0,
    default_order: "law_reg_date desc"
  };

  // Добавляем session_id в тело запроса, если он есть
  if (restSessionId) {
    requestBody.session_id = restSessionId;
  }

  // Добавляем db_schema в тело запроса
  if (dbSchema) {
    requestBody.db_schema = dbSchema;
  }

  try {
    const res = await fetch(requestUrl.toString(), {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(requestBody),
      signal: controller.signal
    });

    clearTimeout(timeoutId);

    if (!res.ok) {
      const text = await res.text();
      throw new Error(`HTTP ${res.status}: ${text}`);
    }

    const json = await res.json();

    // Логирование полного ответа для отладки
    console.log('Full response from sql/text:', json);

    if (json && typeof json === "object" && json.session_id) {
      setRestSessionId(json.session_id);
      console.log(`Session ID updated: ${json.session_id}`);
    } else {
      console.warn('No session_id in response or response is not an object');
    }

    return json;
  } catch (error) {
    clearTimeout(timeoutId);
    if (error.name === 'AbortError') {
      throw new Error('Request timeout after 90 seconds');
    }
    throw error;
  }
}

export async function executeSqlViaApi({ sqlText, params, token }, { signal } = {}) {
  const url = config.URL + "v2/execute";
  const body = {
    params: {
      script: sqlText,
      datas: params ?? null
    },
    token: token ?? null
  };

  const res = await fetch(url, {
    method: "PUT",
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
    body: JSON.stringify(body),
    signal
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`EXECUTE HTTP ${res.status}: ${text}`);
  }

  const ct = res.headers.get("content-type") || "";
  if (ct.includes("application/json")) return await res.json();
  return await res.text();
}

export async function getApiVersion() {
  const url = config.URL_rest + "v1/version";

  const res = await fetch(url, {
    method: "GET",
    headers: {
      "Accept": "application/json"
    }
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`VERSION HTTP ${res.status}: ${text}`);
  }

  return await res.json();
}

export async function clearApiCache() {
  const url = config.URL_rest + "v1/cache/clear";

  const res = await fetch(url, {
    method: "DELETE",
    headers: {
      "Accept": "application/json"
    }
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`CACHE HTTP ${res.status}: ${text}`);
  }

  return await res.json();
}

export async function clearSchemaCache(schema) {
  const url = config.URL_rest + `v1/cache/clear/schema/${schema}`;

  const res = await fetch(url, {
    method: "DELETE",
    headers: {
      "Accept": "application/json"
    }
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`SCHEMA_CACHE HTTP ${res.status}: ${text}`);
  }

  return await res.json();
}
