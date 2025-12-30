/**
 * Модуль для анализа данных и построения графиков
 */

import { MAX_AXIS_LABEL_LENGTH } from './config.js';

// Регистрация плагинов при загрузке модуля
if (typeof Chart !== 'undefined') {
  if (typeof window.ChartZoom !== 'undefined') {
    Chart.register(window.ChartZoom);
  }
  if (typeof ChartDataLabels !== 'undefined') {
    Chart.register(ChartDataLabels);
  }
}

/**
 * Анализ данных для определения пригодности к построению графиков
 */
export class ChartAnalyzer {
  /**
   * Анализирует данные и возвращает возможные типы графиков
   * @param {Array} rows - массив объектов данных
   * @param {Array} columns - имена колонок
   * @returns {Object|null} - { suitable: boolean, charts: [], reason: string }
   */
  static analyzeForChart(rows, columns) {
    if (!rows || rows.length < 2) {
      return { suitable: false, reason: 'Недостаточно данных (минимум 2 строки)' };
    }

    // Исключаем текстовые колонки из анализа
    const excludedColumns = ['description', 'invoice'];
    const filteredColumns = columns.filter(col =>
      !excludedColumns.includes(col.toLowerCase())
    );

    if (filteredColumns.length === 0) {
      return { suitable: false, reason: 'Нет подходящих колонок для визуализации' };
    }

    const columnTypes = this.detectColumnTypes(rows, filteredColumns);
    const numericColumns = columnTypes.filter(c => c.type === 'numeric');
    const categoricalColumns = columnTypes.filter(c => c.type === 'categorical');
    const dateColumns = columnTypes.filter(c => c.type === 'date');

    if (numericColumns.length === 0) {
      return { suitable: false, reason: 'Нет числовых данных для визуализации' };
    }

    const possibleCharts = [];

    // Линейный график: числовая Y + (категориальная или дата) X
    if (numericColumns.length >= 1 && (categoricalColumns.length >= 1 || dateColumns.length >= 1)) {
      possibleCharts.push({
        type: 'line',
        label: 'Линейный график',
        xColumn: dateColumns[0]?.name || categoricalColumns[0]?.name,
        yColumns: numericColumns.map(c => c.name)
      });
    }

    // Столбчатый график: аналогично линейному
    if (numericColumns.length >= 1 && categoricalColumns.length >= 1) {
      possibleCharts.push({
        type: 'bar',
        label: 'Столбчатый график',
        xColumn: categoricalColumns[0].name,
        yColumns: numericColumns.map(c => c.name)
      });
    }

    // Круговая диаграмма: 1 числовая + 1 категориальная (не более 10 значений)
    if (numericColumns.length >= 1 && categoricalColumns.length >= 1) {
      const uniqueCategories = new Set(rows.map(r => r[categoricalColumns[0].name])).size;
      if (uniqueCategories <= 10) {
        possibleCharts.push({
          type: 'pie',
          label: 'Круговая диаграмма',
          labelColumn: categoricalColumns[0].name,
          valueColumn: numericColumns[0].name
        });
      }
    }

    // Точечная диаграмма: 2+ числовых колонки
    if (numericColumns.length >= 2) {
      possibleCharts.push({
        type: 'scatter',
        label: 'Точечная диаграмма',
        xColumn: numericColumns[0].name,
        yColumn: numericColumns[1].name
      });
    }

    if (possibleCharts.length === 0) {
      return { suitable: false, reason: 'Данные не подходят для известных типов графиков' };
    }

    return {
      suitable: true,
      charts: possibleCharts,
      columnTypes: columnTypes
    };
  }

  /**
   * Определяет типы колонок
   * @param {Array} rows - массив объектов
   * @param {Array} columns - имена колонок
   * @returns {Array} - [{name, type: 'numeric'|'categorical'|'date'}]
   */
  static detectColumnTypes(rows, columns) {
    return columns.map(colName => {
      const values = rows.map(r => r[colName]).filter(v => v != null);

      if (values.length === 0) {
        return { name: colName, type: 'unknown' };
      }

      // Проверка на числовой тип
      const numericCount = values.filter(v => typeof v === 'number' || !isNaN(Number(v))).length;
      if (numericCount / values.length > 0.8) { // 80% числовых значений
        return { name: colName, type: 'numeric' };
      }

      // Проверка на дату
      const dateCount = values.filter(v => {
        const str = String(v);
        return /^\d{4}-\d{2}-\d{2}/.test(str) || !isNaN(Date.parse(str));
      }).length;
      if (dateCount / values.length > 0.8) {
        return { name: colName, type: 'date' };
      }

      // По умолчанию - категориальные данные
      return { name: colName, type: 'categorical' };
    });
  }
}

/**
 * Преобразует число в римские цифры
 * @param {number} num - число от 1 до 20
 * @returns {string} - римская цифра
 */
function toRoman(num) {
  const romanNumerals = {
    1: 'I', 2: 'II', 3: 'III', 4: 'IV', 5: 'V',
    6: 'VI', 7: 'VII', 8: 'VIII', 9: 'IX', 10: 'X',
    11: 'XI', 12: 'XII', 13: 'XIII', 14: 'XIV', 15: 'XV',
    16: 'XVI', 17: 'XVII', 18: 'XVIII', 19: 'XIX', 20: 'XX'
  };
  return romanNumerals[num] || num.toString();
}

/**
 * Рендеринг графиков с использованием Chart.js
 */
export class ChartRenderer {
  /**
   * Создает график в указанном контейнере
   * @param {HTMLElement} container - контейнер для canvas
   * @param {Array} rows - данные
   * @param {Object} chartConfig - конфигурация из ChartAnalyzer
   * @returns {Chart} - экземпляр Chart.js
   */
  static renderChart(container, rows, chartConfig) {
    const canvas = document.createElement('canvas');
    canvas.style.maxHeight = '400px';
    container.appendChild(canvas);

    const ctx = canvas.getContext('2d');

    let chartData, chartOptions;

    switch (chartConfig.type) {
      case 'line':
      case 'bar':
        chartData = this.prepareLineBarData(rows, chartConfig);
        chartOptions = this.getLineBarOptions(chartConfig);
        break;
      case 'pie':
        chartData = this.preparePieData(rows, chartConfig);
        chartOptions = this.getPieOptions();
        break;
      case 'scatter':
        chartData = this.prepareScatterData(rows, chartConfig);
        chartOptions = this.getScatterOptions(chartConfig);
        break;
      default:
        throw new Error(`Unknown chart type: ${chartConfig.type}`);
    }

    return new Chart(ctx, {
      type: chartConfig.type,
      data: chartData,
      options: chartOptions
    });
  }

  static prepareLineBarData(rows, config) {
    const labels = rows.map(r => r[config.xColumn]);
    const datasets = config.yColumns.map((yCol, idx) => ({
      label: yCol,
      data: rows.map(r => Number(r[yCol])),
      borderColor: this.getColor(idx),
      backgroundColor: this.getColor(idx, 0.5),
      borderWidth: 2
    }));

    return { labels, datasets };
  }

  static preparePieData(rows, config) {
    const labels = rows.map(r => r[config.labelColumn]);
    const data = rows.map(r => Number(r[config.valueColumn]));

    return {
      labels,
      datasets: [{
        data,
        backgroundColor: labels.map((_, idx) => this.getColor(idx, 0.7))
      }]
    };
  }

  static prepareScatterData(rows, config) {
    const data = rows.map(r => ({
      x: Number(r[config.xColumn]),
      y: Number(r[config.yColumn])
    }));

    return {
      datasets: [{
        label: `${config.xColumn} vs ${config.yColumn}`,
        data,
        backgroundColor: this.getColor(0, 0.6)
      }]
    };
  }

  static getLineBarOptions(config) {
    return {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: {
          display: true,
          position: 'top',
          labels: {
            usePointStyle: true,
            padding: 15,
            font: { size: 12 }
          }
        },
        tooltip: {
          enabled: true,
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          titleFont: { size: 14, weight: 'bold' },
          bodyFont: { size: 13 },
          padding: 12,
          cornerRadius: 6,
          displayColors: true,
          callbacks: {
            label: function(context) {
              let label = context.dataset.label || '';
              if (label) {
                label += ': ';
              }
              label += Number(context.parsed.y).toLocaleString('ru-RU');
              return label;
            }
          }
        },
        datalabels: {
          display: false // Отключаем для line/bar, чтобы не загромождать
        },
        zoom: {
          zoom: {
            wheel: {
              enabled: true,
              modifierKey: 'ctrl'
            },
            pinch: {
              enabled: true
            },
            mode: 'xy'
          },
          pan: {
            enabled: true,
            mode: 'xy',
            scaleMode: 'xy'
          },
          limits: {
            x: { min: 'original', max: 'original' },
            y: { min: 'original', max: 'original' }
          }
        }
      },
      scales: {
        x: {
          title: {
            display: true,
            text: config.xColumn,
            font: { size: 13, weight: 'bold' }
          },
          grid: { color: 'rgba(0, 0, 0, 0.05)' },
          ticks: {
            callback: function(value, index) {
              const label = this.getLabelForValue(value);
              return label.length > MAX_AXIS_LABEL_LENGTH ? label.substring(0, MAX_AXIS_LABEL_LENGTH) + '...' : label;
            }
          }
        },
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: config.yColumns.join(', '),
            font: { size: 13, weight: 'bold' }
          },
          grid: { color: 'rgba(0, 0, 0, 0.1)' },
          ticks: {
            callback: function(value) {
              return Number(value).toLocaleString('ru-RU');
            }
          }
        }
      }
    };
  }

  static getPieOptions() {
    return {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: {
          position: 'right',
          labels: {
            usePointStyle: true,
            padding: 12,
            font: { size: 12 },
            generateLabels: function(chart) {
              const data = chart.data;
              if (data.labels.length && data.datasets.length) {
                return data.labels.map((label, i) => {
                  const value = data.datasets[0].data[i];
                  const total = data.datasets[0].data.reduce((a, b) => a + b, 0);
                  const percentage = ((value / total) * 100).toFixed(1);
                  const roman = toRoman(i + 1); // +1 потому что индексы с 0
                  return {
                    text: `${roman}. ${label}: ${percentage}%`,
                    fillStyle: data.datasets[0].backgroundColor[i],
                    hidden: false,
                    index: i
                  };
                });
              }
              return [];
            }
          }
        },
        tooltip: {
          enabled: true,
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          titleFont: { size: 14, weight: 'bold' },
          bodyFont: { size: 13 },
          padding: 12,
          cornerRadius: 6,
          callbacks: {
            label: function(context) {
              const label = context.label || '';
              const value = Number(context.parsed).toLocaleString('ru-RU');
              const total = context.dataset.data.reduce((a, b) => a + b, 0);
              const percentage = ((context.parsed / total) * 100).toFixed(1);
              const roman = toRoman(context.dataIndex + 1);
              return `${roman}. ${label}: ${value} (${percentage}%)`;
            }
          }
        },
        datalabels: {
          color: '#fff',
          font: { size: 16, weight: 'bold' },
          formatter: (value, context) => {
            const roman = toRoman(context.dataIndex + 1);
            return roman; // Показываем только римскую цифру на секторе
          }
        }
      }
    };
  }

  static getScatterOptions(config) {
    return {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          enabled: true,
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          titleFont: { size: 14, weight: 'bold' },
          bodyFont: { size: 13 },
          padding: 12,
          cornerRadius: 6,
          callbacks: {
            label: function(context) {
              const x = Number(context.parsed.x).toLocaleString('ru-RU');
              const y = Number(context.parsed.y).toLocaleString('ru-RU');
              return `${config.xColumn}: ${x}, ${config.yColumn}: ${y}`;
            }
          }
        },
        datalabels: {
          display: false // Отключаем для scatter, чтобы не загромождать
        },
        zoom: {
          zoom: {
            wheel: {
              enabled: true,
              modifierKey: 'ctrl'
            },
            pinch: {
              enabled: true
            },
            mode: 'xy'
          },
          pan: {
            enabled: true,
            mode: 'xy',
            scaleMode: 'xy'
          },
          limits: {
            x: { min: 'original', max: 'original' },
            y: { min: 'original', max: 'original' }
          }
        }
      },
      scales: {
        x: {
          title: {
            display: true,
            text: config.xColumn,
            font: { size: 13, weight: 'bold' }
          },
          grid: { color: 'rgba(0, 0, 0, 0.1)' },
          ticks: {
            callback: function(value) {
              const formatted = Number(value).toLocaleString('ru-RU');
              return formatted.length > MAX_AXIS_LABEL_LENGTH ? formatted.substring(0, MAX_AXIS_LABEL_LENGTH) + '...' : formatted;
            }
          }
        },
        y: {
          title: {
            display: true,
            text: config.yColumn,
            font: { size: 13, weight: 'bold' }
          },
          grid: { color: 'rgba(0, 0, 0, 0.1)' },
          ticks: {
            callback: function(value) {
              return Number(value).toLocaleString('ru-RU');
            }
          }
        }
      }
    };
  }

  static getColor(index, alpha = 1) {
    const colors = [
      `rgba(59, 130, 246, ${alpha})`,   // blue
      `rgba(16, 185, 129, ${alpha})`,   // green
      `rgba(245, 158, 11, ${alpha})`,   // amber
      `rgba(239, 68, 68, ${alpha})`,    // red
      `rgba(168, 85, 247, ${alpha})`,   // purple
      `rgba(236, 72, 153, ${alpha})`,   // pink
      `rgba(14, 165, 233, ${alpha})`,   // sky
      `rgba(34, 197, 94, ${alpha})`     // emerald
    ];
    return colors[index % colors.length];
  }
}
