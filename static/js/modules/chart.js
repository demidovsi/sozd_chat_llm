/**
 * Модуль для анализа данных и построения графиков
 */

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

    const columnTypes = this.detectColumnTypes(rows, columns);
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
        legend: { display: true },
        title: { display: true, text: `${config.yColumns.join(', ')} по ${config.xColumn}` }
      },
      scales: {
        y: { beginAtZero: true }
      }
    };
  }

  static getPieOptions() {
    return {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { position: 'right' }
      }
    };
  }

  static getScatterOptions(config) {
    return {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { display: false },
        title: { display: true, text: `${config.xColumn} vs ${config.yColumn}` }
      },
      scales: {
        x: { title: { display: true, text: config.xColumn } },
        y: { title: { display: true, text: config.yColumn } }
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
