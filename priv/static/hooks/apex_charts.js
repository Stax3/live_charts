import ApexCharts from 'apexcharts';

const ApexChartsHook = {
  /**
   * Render chart and register event listeners
   * on when the component is first mounted.
   */
  mounted() {
    this.renderChart();
    this.handleEvent('chart-data', this.onChartDataEvent.bind(this));
  },

  /**
   * Re-render chart when `data-chart` attribute is updated.
   */
  updated() {
    this.renderChart();
  },

  /**
   * Parse config from `data-chart` attribute,
   * normalize it if needed, and remove it
   * from the HTML mkarup.
   */
  getConfig() {
    const config = JSON.parse(this.el.dataset.chart);
    delete this.el.dataset.chart;
    return config;
  },

  /**
   * Render Chart given provided config
   */
  renderChart() {
    this.chart = new ApexCharts(this.el, this.getConfig());
    this.chart.render();
  },

  /**
   * Update chart when receiving new data over liveview
   */
  onChartDataEvent({ value }) {
    this.chart.updateSeries(value);
  },
};

export default ApexChartsHook;
