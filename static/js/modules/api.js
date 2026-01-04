/**
 * API вызовы к бэкенду
 */

import { config } from './config.js';
import { restSessionId, setRestSessionId, dbSchema, queryMode, getCurrentMode } from './state.js';

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

  // Получаем HTTP метод из конфигурации текущего режима
  const mode = getCurrentMode();
  const httpMethod = mode?.method || "POST";

  // Для GET запросов добавляем параметры в URL
  if (httpMethod === "GET") {
    Object.keys(requestBody).forEach(key => {
      requestUrl.searchParams.append(key, requestBody[key]);
    });
  }

  try {
    const fetchOptions = {
      method: httpMethod,
      signal: controller.signal
    };

    // Для POST добавляем тело запроса
    if (httpMethod === "POST") {
      fetchOptions.headers = { "Content-Type": "application/json" };
      fetchOptions.body = JSON.stringify(requestBody);
    }

    const res = await fetch(requestUrl.toString(), fetchOptions);

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

export async function clearQueryCache(userConditions, schema) {
  const url = config.URL_rest + "v1/cache/clear/query";

  const res = await fetch(url, {
    method: "POST",
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      user_conditions: userConditions,
      db_schema: schema
    })
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`QUERY_CACHE HTTP ${res.status}: ${text}`);
  }

  return await res.json();
}

/**
 * Универсальная функция для запросов к разным API в зависимости от режима
 * @param {string} userText - Текст запроса пользователя
 * @param {Object} options - Опции запроса
 * @param {AbortSignal} options.signal - Сигнал для отмены запроса
 * @returns {Promise<Object>} - Ответ от API
 */
export async function fetchQueryAnswer(userText, { signal } = {}) {
  const mode = getCurrentMode();

  if (!mode) {
    throw new Error(`Invalid mode configuration for schema ${dbSchema}, mode ${queryMode}`);
  }

  // Для SQL режима используем существующий fetchSqlText
  if (mode.id === 'sql') {
    return await fetchSqlText(userText, { signal });
  }

  // Для других режимов - универсальный запрос
  const url = mode.url + mode.endpoint;

  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 90000);

  if (signal) {
    signal.addEventListener('abort', () => controller.abort());
  }

  const requestUrl = new URL(url);

  // Для custom режима используем ключ "query"
  const requestBody = {};
  if (mode.id === 'custom') {
    requestBody.query = userText;
  } else {
    requestBody.question = userText;
    requestBody.user_text = userText;
  }

  // Добавляем session_id если есть
  if (restSessionId) {
    requestBody.session_id = restSessionId;
  }

  // Добавляем db_schema (всегда отправляем схему)
  if (dbSchema) {
    requestBody.db_schema = dbSchema;
  }

  // Используем HTTP метод из конфигурации (GET или POST)
  const httpMethod = mode.method || "POST";

  // Для GET запросов добавляем параметры в URL
  if (httpMethod === "GET") {
    Object.keys(requestBody).forEach(key => {
      requestUrl.searchParams.append(key, requestBody[key]);
    });
  }

  try {
    const fetchOptions = {
      method: httpMethod,
      signal: controller.signal
    };

    // Для POST добавляем тело запроса
    if (httpMethod === "POST") {
      fetchOptions.headers = { "Content-Type": "application/json" };
      fetchOptions.body = JSON.stringify(requestBody);
    }

    console.log('=== Детали запроса ===');
    console.log('URL:', requestUrl.toString());
    console.log('Method:', httpMethod);
    console.log('Mode:', mode.id);
    console.log('Request Body:', requestBody);
    console.log('Fetch Options:', fetchOptions);

    const res = await fetch(requestUrl.toString(), fetchOptions);
    clearTimeout(timeoutId);

    if (!res.ok) {
      const text = await res.text();
      throw new Error(`HTTP ${res.status}: ${text}`);
    }
    
    const data = await res.json();
    
    // Сохраняем session_id если пришёл новый
    if (data.session_id && data.session_id !== restSessionId) {
      setRestSessionId(data.session_id);
    }
    
    return data;
  } catch (err) {
    clearTimeout(timeoutId);
    console.error('Ошибка fetch:', err);
    if (err.name === 'AbortError') {
      throw err;
    }
    throw new Error(`Query failed: ${err.message}`);
  }
}
