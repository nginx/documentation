// /ads/aws/js/cost-calculator_aws.js
(() => {
  // ---- Region to tier mapping ----
  const regionsTiers = {
    "us-east-1":      { label: "US East 1 (N. Virginia)",    tier: "Tier 1" },
    "us-east-2":      { label: "US East 2 (Ohio)",           tier: "Tier 1" },
    "us-west-1":      { label: "US West 1 (N. California)",  tier: "Tier 1" },
    "us-west-2":      { label: "US West 2 (Oregon)",         tier: "Tier 1" },
    "eu-central-1":   { label: "EU Central 1 (Frankfurt)",   tier: "Tier 3" },
    "eu-north-1":     { label: "EU North 1 (Stockholm)",     tier: "Tier 1" },
    "eu-west-1":      { label: "EU West 1 (Ireland)",        tier: "Tier 1" },
    "eu-west-2":      { label: "EU West 2 (London)",         tier: "Tier 2" },
    "eu-west-3":      { label: "EU West 3 (Paris)",          tier: "Tier 2" },
    "ap-northeast-1": { label: "AP Northeast 1 (Tokyo)",     tier: "Tier 1" },
    "ap-northeast-2": { label: "AP Northeast 2 (Seoul)",     tier: "Tier 1" },
    "ap-south-1":     { label: "AP South 1 (Mumbai)",        tier: "Tier 1" },
    "ap-south-2":     { label: "AP South 2 (Hyderabad)",     tier: "Tier 1" },
    "ap-southeast-1": { label: "AP Southeast 1 (Singapore)", tier: "Tier 1" },
    "ap-southeast-4": { label: "AP Southeast 4 (Melbourne)", tier: "Tier 1" },
  };

  // ---- Tier pricing ----
  const tierCosts = {
    "Tier 1": { fixedHourly: 0.10,  ncuHourly: 0.008,  dataPerGb: 0.0096 },
    "Tier 2": { fixedHourly: 0.133, ncuHourly: 0.0106, dataPerGb: 0.0127 },
    "Tier 3": { fixedHourly: 0.166, ncuHourly: 0.0132, dataPerGb: 0.0159 },
  };

  const HOURS_PER_MONTH = 730;

  let currentRegion = Object.keys(regionsTiers)[0]; // "us-east-1"

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
