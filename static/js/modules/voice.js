/**
 * Модуль голосового ввода с использованием Web Speech API
 */

export class VoiceInput {
  constructor() {
    this.recognition = null;
    this.isRecording = false;
    this.language = 'auto';
    this.onTranscript = null; // Callback для распознанного текста
    this.onStateChange = null; // Callback для изменения состояния

    this.initRecognition();
  }

  /**
   * Проверка поддержки Web Speech API
   * @returns {boolean}
   */
  static isSupported() {
    return 'webkitSpeechRecognition' in window || 'SpeechRecognition' in window;
  }

  /**
   * Инициализация SpeechRecognition
   */
  initRecognition() {
    if (!VoiceInput.isSupported()) {
      console.warn('Web Speech API не поддерживается в этом браузере');
      return;
    }

    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    this.recognition = new SpeechRecognition();

    // Конфигурация
    this.recognition.continuous = false; // Остановка после паузы
    this.recognition.interimResults = true; // Промежуточные результаты
    this.recognition.maxAlternatives = 1;

    // Обработчик начала записи
    this.recognition.onstart = () => {
      this.isRecording = true;
      console.log('Запись голоса началась');
      this.onStateChange?.('recording');
    };

    // Обработчик результатов распознавания
    this.recognition.onresult = (event) => {
      let transcript = '';
      let isFinal = false;

      for (let i = event.resultIndex; i < event.results.length; i++) {
        transcript += event.results[i][0].transcript;
        if (event.results[i].isFinal) {
          isFinal = true;
        }
      }

      if (transcript) {
        console.log(`Распознан текст${isFinal ? ' (финальный)' : ''}: ${transcript}`);
        this.onTranscript?.(transcript, isFinal);
      }
    };

    // Обработчик ошибок
    this.recognition.onerror = (event) => {
      console.error('Ошибка распознавания речи:', event.error);
      this.isRecording = false;

      let errorMessage = event.error;
      switch (event.error) {
        case 'not-allowed':
        case 'permission-denied':
          errorMessage = 'Доступ к микрофону запрещен';
          break;
        case 'no-speech':
          errorMessage = 'Речь не обнаружена';
          break;
        case 'audio-capture':
          errorMessage = 'Микрофон не найден';
          break;
        case 'network':
          errorMessage = 'Ошибка сети';
          break;
        default:
          errorMessage = `Ошибка: ${event.error}`;
      }

      this.onStateChange?.('error', errorMessage);
    };

    // Обработчик окончания записи
    this.recognition.onend = () => {
      this.isRecording = false;
      console.log('Запись голоса завершена');
      this.onStateChange?.('idle');
    };
  }

  /**
   * Установить язык распознавания
   * @param {string} lang - 'auto', 'ru-RU', 'en-US'
   */
  setLanguage(lang) {
    this.language = lang;
    if (this.recognition) {
      if (lang === 'auto') {
        // Использовать язык браузера или русский по умолчанию
        const browserLang = navigator.language || navigator.userLanguage || 'ru-RU';
        this.recognition.lang = browserLang;
        console.log(`Язык распознавания (авто): ${browserLang}`);
      } else {
        this.recognition.lang = lang;
        console.log(`Язык распознавания: ${lang}`);
      }
    }
  }

  /**
   * Начать запись
   * @returns {boolean} - успешно ли начата запись
   */
  start() {
    if (!this.recognition) {
      console.error('SpeechRecognition не инициализирован');
      return false;
    }

    if (this.isRecording) {
      console.warn('Запись уже идет');
      return false;
    }

    try {
      this.setLanguage(this.language);
      this.recognition.start();
      return true;
    } catch (error) {
      console.error('Не удалось начать распознавание:', error);
      this.onStateChange?.('error', error.message);
      return false;
    }
  }

  /**
   * Остановить запись
   */
  stop() {
    if (this.recognition && this.isRecording) {
      console.log('Остановка записи голоса');
      this.recognition.stop();
    }
  }

  /**
   * Переключить запись (вкл/выкл)
   */
  toggle() {
    if (this.isRecording) {
      this.stop();
    } else {
      this.start();
    }
  }

  /**
   * Очистка и удаление
   */
  destroy() {
    if (this.recognition) {
      if (this.isRecording) {
        this.recognition.abort();
      }
      this.recognition = null;
    }
  }
}

/**
 * Получить доступные языки для распознавания
 * @returns {Array} - массив объектов {value, label}
 */
export function getVoiceLanguages() {
  return [
    { value: 'auto', label: 'Авто' },
    { value: 'ru-RU', label: 'Русский' },
    { value: 'en-US', label: 'English' }
  ];
}
