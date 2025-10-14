// /nginxaas-google/js/cost-calculator_v2.js
(() => {
  // ---- Single-tier pricing ----
  const costs = {
    fixedHourly: 0.10,   // $/hour
    ncuHourly: 0.008,    // $/NCU/hour
    dataPerGb: 0.0096    // $/GB (monthly)
  };

  const utils = {
    calculateCost: (costs, values) => {
      const hoursPortion = values.numHours * (costs.fixedHourly + (values.numNcus * costs.ncuHourly));
      const dataPortion = values.dataProcessedGb * costs.dataPerGb;
      return hoursPortion + dataPortion;
    },
    currencyFormatter: (n, significantDigits) => {
      return new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD",
        maximumSignificantDigits: significantDigits
      }).format(n);
    },
  };

  // ---- Form state (defaults: 10 NCUs on load) ----
  const calculatorValuesState = {
    numNcus: 10,
    numHours: 730,
    dataProcessedGb: 0
  };

  // ---- Element refs ----
  const costFormElements = {
    numNcus: document.getElementById("numNcus"),
    numHours: document.getElementById("numHours"),
    dataProcessedGb: document.getElementById("dataProcessedGb"),
  };

  const totalCostDetailElements = {
    ncus: document.getElementById("cost-detail-ncus"),
    hours: document.getElementById("cost-detail-hours"),
    fixedHourly: document.getElementById("cost-detail-fixed-hourly"),
    ncuHourly: document.getElementById("cost-detail-ncu-hourly"),
    dataGb: document.getElementById("cost-detail-data-gb"),
    dataPerGb: document.getElementById("cost-detail-data-pergb"),
    total: document.getElementById("cost-detail-total"),
  };

  // ---- Listeners ----
  const setupChangeListeners = (costs, values = calculatorValuesState) => {
    Object.keys(costFormElements).forEach((elName) => {
      costFormElements[elName].addEventListener("change", (evt) => {
        values[elName] = Number(evt.target.value);
        updateCost(costs);
      });
    });

    document.getElementById("printButton").addEventListener("click", () => {
      printCostEstimate();
    });
  };

  // ---- Init values ----
  const initializeValues = (values = calculatorValuesState) => {
    Object.keys(costFormElements).forEach((elName) => {
      const el = costFormElements[elName];
      if (el && (el.tagName.toLowerCase() === "input" || el.tagName.toLowerCase() === "select")) {
        el.value = values[elName];
      }
    });
  };

  // ---- Updates ----
  const updateCost = (costs, values = calculatorValuesState) => {
    const updatedTotalCost = utils.calculateCost(costs, values);
    document.getElementById("total-value").textContent = utils.currencyFormatter(updatedTotalCost);
    updateTotalCostDetails(values, updatedTotalCost);
  };

  const updateTotalCostDetails = (formValues, totalCost) => {
    totalCostDetailElements.hours.textContent = formValues.numHours;
    totalCostDetailElements.ncus.textContent = formValues.numNcus;
    totalCostDetailElements.fixedHourly.textContent = utils.currencyFormatter(costs.fixedHourly, 3);
    totalCostDetailElements.ncuHourly.textContent = utils.currencyFormatter(costs.ncuHourly, 3);
    totalCostDetailElements.dataGb.textContent = formValues.dataProcessedGb;
    totalCostDetailElements.dataPerGb.textContent = utils.currencyFormatter(costs.dataPerGb, 3);
    totalCostDetailElements.total.textContent = utils.currencyFormatter(totalCost);
  };

  function printCostEstimate() {
    const totalDetails = document.getElementById("total-cost-details");
    const detailsOpen = totalDetails.hasAttribute("open");
    if (!detailsOpen) totalDetails.setAttribute("open", "true");

    window.print();

    if (!detailsOpen) totalDetails.removeAttribute("open");
  }

  // ---- Boot ----
  const start = async () => {
    const loaded = costs;
    setupChangeListeners(loaded);
    initializeValues(calculatorValuesState);
    updateCost(loaded); // immediately show total on load
  };
  start();
})();
