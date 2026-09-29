// /nginxaas/google/js/cost-calculator_gc.js
(() => {
  // ---- Region to tier mapping ----
  const regionsTiers = {
    "us-east1":        { label: "US East 1",        tier: "Tier 1" },
    "us-east4":        { label: "US East 4",        tier: "Tier 1" },
    "us-west1":        { label: "US West 1",        tier: "Tier 1" },
    "us-west2":        { label: "US West 2",        tier: "Tier 1" },
    "us-west3":        { label: "US West 3",        tier: "Tier 1" },
    "us-west4":        { label: "US West 4",        tier: "Tier 1" },
    "us-central1":     { label: "US Central 1",     tier: "Tier 1" },
    "europe-west1":    { label: "Europe West 1",    tier: "Tier 1" },
    "europe-west4":    { label: "Europe West 4",    tier: "Tier 1" },
    "europe-north1":   { label: "Europe North 1",   tier: "Tier 1" },
    "asia-south2":     { label: "Asia South 2",     tier: "Tier 1" },
    "europe-west2":    { label: "Europe West 2",    tier: "Tier 2" },
    "europe-west3":    { label: "Europe West 3",    tier: "Tier 2" },
    "asia-southeast1": { label: "Asia Southeast 1", tier: "Tier 2" },
    "asia-south1":     { label: "Asia South 1",     tier: "Tier 2" },
    "europe-central2": { label: "Europe Central 2", tier: "Tier 3" },
  };

  // ---- Tier pricing ----
  const tierCosts = {
    "Tier 1": { fixedHourly: 0.10,  ncuHourly: 0.008,  dataPerGb: 0.0096 },
    "Tier 2": { fixedHourly: 0.133, ncuHourly: 0.0106, dataPerGb: 0.0127 },
    "Tier 3": { fixedHourly: 0.166, ncuHourly: 0.0132, dataPerGb: 0.0159 },
  };

  const HOURS_PER_MONTH = 730;

  let currentRegion = Object.keys(regionsTiers)[0]; // "us-east1"

  const utils = {
    calculateCost: (region, values) => {
      const costs = tierCosts[regionsTiers[region].tier];
      const hoursPortion = HOURS_PER_MONTH * (costs.fixedHourly + (values.numNcus * costs.ncuHourly));
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

  // ---- Form state (defaults: 10 NCUs, 0 GB on load) ----
  const calculatorValuesState = {
    numNcus: 10,
    dataProcessedGb: 0,
  };

  // ---- Element refs ----
  const costFormElements = {
    regionSelect: document.getElementById("regionSelect"),
    numNcus: document.getElementById("numNcus"),
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

  const populateRegionSelect = () => {
    const $select = costFormElements.regionSelect;
    Object.keys(regionsTiers).forEach((regionKey) => {
      const option = document.createElement("option");
      option.value = regionKey;
      option.textContent = `${regionsTiers[regionKey].label} (${regionsTiers[regionKey].tier})`;
      $select.append(option);
    });
  };

  // ---- Listeners ----
  const setupChangeListeners = (values = calculatorValuesState) => {
    costFormElements.regionSelect.addEventListener("change", (evt) => {
      currentRegion = evt.target.value;
      updateCost(values);
    });

    ["numNcus", "dataProcessedGb"].forEach((elName) => {
      costFormElements[elName].addEventListener("change", (evt) => {
        values[elName] = Number(evt.target.value);
        updateCost(values);
      });
    });

    document.getElementById("printButton").addEventListener("click", () => {
      printCostEstimate();
    });
  };

  // ---- Init values ----
  const initializeValues = (values = calculatorValuesState) => {
    costFormElements.regionSelect.value = currentRegion;
    costFormElements.numNcus.value = values.numNcus;
    costFormElements.dataProcessedGb.value = values.dataProcessedGb;
  };

  // ---- Updates ----
  const updateCost = (values = calculatorValuesState) => {
    const updatedTotalCost = utils.calculateCost(currentRegion, values);
    document.getElementById("total-value").textContent = utils.currencyFormatter(updatedTotalCost);
    updateTotalCostDetails(values, updatedTotalCost);
  };

  const updateTotalCostDetails = (formValues, totalCost) => {
    const costs = tierCosts[regionsTiers[currentRegion].tier];
    totalCostDetailElements.hours.textContent = HOURS_PER_MONTH;
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
    populateRegionSelect();
    setupChangeListeners();
    initializeValues(calculatorValuesState);
    updateCost(calculatorValuesState); // immediately show total on load
  };
  start();
})();
