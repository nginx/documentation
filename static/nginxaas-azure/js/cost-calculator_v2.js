// todo [heftel] - if we are going to live with this for a while then this file should be broken up with
// modules. Browser support shouldn't be a concern anymore? - https://caniuse.com/es6-module

(() => {
  /**
   * @typedef {typeof costs} Costs
   * @constant
   * @default
   */
  const costs = {
    regionsTiers: {
      eastus2: { label: "East US 2", tier: 1 },
      northeurope: { label: "North Europe", tier: 1 },
      westcentralus: { label: "West Central US", tier: 1 },
      westus2: { label: "West US 2", tier: 1 },
      westus3: { label: "West US 3", tier: 1 },
      canadacentral: { label: "Canada Central", tier: 2 },
      centralindia: { label: "Central India", tier: 2 },
      centralus: { label: "Central US", tier: 2 },
      eastus: { label: "East US", tier: 2 },
      germanywestcentral: { label: "Germany West Central", tier: 2 },
      koreacentral: { label: "Korea Central", tier: 2 },
      northcentralus: { label: "North Central US", tier: 2 },
      southeastasia: { label: "Southeast Asia", tier: 2 },
      swedencentral: { label: "Sweden Central", tier: 2 },
      westeurope: { label: "West Europe", tier: 2 },
      westus: { label: "West US", tier: 2 },
      australiaeast: { label: "Australia East", tier: 3 },
      brazilsouth: { label: "Brazil South", tier: 3 },
      japaneast: { label: "Japan East", tier: 3 },
      southindia: { label: "South India", tier: 3 },
      ukwest: { label: "UK West", tier: 3 },
      uksouth: { label: "UK South", tier: 3 },
      southcentralus: { label: "South Central US", tier: 1 },
    },
    // Fixed deployment fee per hour by tier (with/without WAF)
    deploymentFee: {
      1: { withWAF: 0.45, withoutWAF: 0.25 },
      2: { withWAF: 0.594, withoutWAF: 0.33 },
      3: { withWAF: 0.75, withoutWAF: 0.42 }
    },
    // NCU cost per hour by tier (with/without WAF)
    tiersCosts: {
      1: { withWAF: 0.0144, withoutWAF: 0.008 },
      2: { withWAF: 0.01952, withoutWAF: 0.01064 },
      3: { withWAF: 0.0239, withoutWAF: 0.01328 }
    },
    // Data processing cost (constant across all regions and WAF usage)
    dataProcessing: 0.005,
    listenPorts: 0.01,
    numFreeListenPorts: 5,
  };

  /**
   * @typedef {typeof ncuParameterVals} NcuParameterVals
   * @constant
   * @default
   */
  const ncuParameterVals = {
    connsPerSecPerAcu: 2.64,
    acusPerNcu: 20,
    connsPerNcu: 3000,
    mbpsPerNcu: 2.2,
  };

  const utils = {
    /**
     *
     * @param {Costs} costs
     * @param {CostCalculatorValuesState} values
     * @returns {number} total - The total estimated cost
     */
    calculateCost: (costs, values) => {
      const tier = costs.regionsTiers[values.region].tier;
      const wafKey = values.isWAF ? 'withWAF' : 'withoutWAF';
      
      const deploymentFee = costs.deploymentFee[tier][wafKey];
      const ncuCost = costs.tiersCosts[tier][wafKey];
      const standardNcuCost = costs.tiersCosts[tier]['withoutWAF'];

      const total =
        (values.numHours *
        (deploymentFee +
         values.numNcus * ncuCost +
          (values.numListenPorts > costs.numFreeListenPorts
            ? (values.numListenPorts - costs.numFreeListenPorts) *
              2 * standardNcuCost
            : 0))) +
        values.dataProcessedGB * costs.dataProcessing;

      return total;
    },

    /**
     * NcuValues needed to show values and calculations
     * @typedef {Object} NcuValues
     * @property {number} avgConcurrentConnections - the average concurrent connections
     * @property {number} exactNcusNeeded - the number of NCUs needed as an integer
     * @property {number} bundledNcusNeeded - the number of NCUs in bundles of tens
     */
    /**
     * @param {NcuEstimateValuesState} ncuEstimateFormValues
     * @return {NcuValues}
     */
    calculateNcuValues: (ncuEstimateFormValues) => {
      // new connections per second avg duration in seconds
      const avgConcurrentConnections =
        ncuEstimateFormValues.avgNewConnsPerSec *
        ncuEstimateFormValues.avgConnDuration;

      // Include 0s as default values in case of unexpected NaN
      const minNcus = Math.max(
        ncuEstimateFormValues.avgNewConnsPerSec /
          (ncuParameterVals.connsPerSecPerAcu * ncuParameterVals.acusPerNcu) ||
          0,
        avgConcurrentConnections / ncuParameterVals.connsPerNcu || 0,
        ncuEstimateFormValues.totalBandwidth / ncuParameterVals.mbpsPerNcu || 0
      );

      return {
        avgConcurrentConnections,
        min: minNcus,
        total: Math.max(10, Math.ceil(minNcus / 10) * 10),
      };
    },

    // async so it could call out to an API
    loadCosts: async () => {
      return costs;
    },

    /**
     * Formats numbers to USD currency string
     * @param {number} n
     * @param {number} significantDigits
     * @returns {string}
     */
    currencyFormatter: (n, significantDigits = 5) => {
      console.log('Formatting number to currency:', n, 'with significantDigits:', significantDigits);
      const options = {
        style: "currency",
        currency: "USD"
      };
      
      // Only add maximumSignificantDigits if significantDigits is provided and valid
      if (significantDigits && significantDigits > 0) {
        options.maximumSignificantDigits = significantDigits;
      }
      
      return new Intl.NumberFormat("en-US", options).format(n);
    },
  };

  ////////
  // "state" objects that keep form values
  ////////

  /**
   * @typedef {Object} CostCalculatorValuesState
   * @property {string} region
   * @property {number} numNcus
   * @property {number} numHours
   * @property {number} numListenPorts
   * @property {boolean} isWAF
   * @property {number} dataProcessedGB
   */
  /**
   * @type {CostCalculatorValuesState}
   */
  const calculatorValuesState = {
    region: "westus2",
    numNcus: 20,
    numHours: 730,
    numListenPorts: 5,
    isWAF: false,
    dataProcessedGB: 100,
  };

  /**
   * @typedef {Object} NcuEstimateValuesState
   * @property {number} avgNewConnsPerSec
   * @property {number} avgConnDuration
   * @property {number} totalBandwidth
   */
  /**
   * @type {NcuEstimateValuesState}
   */
  const ncuEstimateValuesState = {
    avgNewConnsPerSec: 10,
    avgConnDuration: 10,
    totalBandwidth: 500,
  };

  ////////
  // Keep element refs with hugo global HTMLElement
  ////////

  /**
   * @type {Object.<string, HTMLElement>}
   */
  const costFormElements = {
    region: document.getElementById("region"),
    numNcus: document.getElementById("numNcus"),
    numHours: document.getElementById("numHours"),
    numListenPorts: document.getElementById("numListenPorts"),
    isWAF: document.getElementById("isWAF"),
    dataProcessedGB: document.getElementById("dataProcessedGB"),
  };

  /**
   * @type {Object.<string, HTMLElement>}
   */
  const costFormLabelElements = {
    numNcusEstVal: document.getElementById("numNcusEstVal"),
  };

  /**
   * @type {Object.<string, HTMLElement>}
   */
  const ncuFormElements = {
    avgNewConnsPerSec: document.getElementById("avgNewConnsPerSec"),
    avgConnDuration: document.getElementById("avgConnDuration"),
    totalBandwidth: document.getElementById("totalBandwidth"),
  };

  /**
   * @type {Object.<string, HTMLElement>}
   */
  const ncuEstimateElements = {
    ncuEstConnRate: document.getElementById("ncuEstConnRate"),
    ncuEstConnDuration: document.getElementById("ncuEstConnDuration"),
    ncuEstAvgConn: document.getElementById("ncuEstAvgConn"),
    ncuEstAvgConn2: document.getElementById("ncuEstAvgConn2"),
    ncuEstConnRate2: document.getElementById("ncuEstConnRate2"),
    ncuEstDataRate: document.getElementById("ncuEstDataRate"),
    ncuEstMin1: document.getElementById("ncuEstMin1"),
    ncuEstMin: document.getElementById("ncuEstMin"),
    ncuEstTotal: document.getElementById("ncuEstTotal"),
    ncuEstConnsPerNcu: document.getElementById("ncuEstConnsPerNcu"),
    ncuEstConnsPerSecondPerNcu: document.getElementById("ncuEstConnsPerSecondPerNcu"),
    ncuEstMbpsPerNcu: document.getElementById("ncuEstMbpsPerNcu"),
  };

  /**
   * @type {Object.<string, HTMLElement>}
   */
  const totalCostDetailElements = {
    ncus: document.getElementById("cost-detail-ncus"),
    hours: document.getElementById("cost-detail-hours"),
    tierCost: document.getElementById("cost-detail-tier-cost"),
    deploymentFee: document.getElementById("cost-detail-deployment-fee"),
    dataProcessed: document.getElementById("cost-detail-data-processed"),
    dataProcessingCost: document.getElementById("cost-detail-data-processing-cost"),
    listenPorts: document.getElementById("cost-detail-listen-ports"),
    listenPortsCost: document.getElementById("cost-detail-listen-ports-cost"),
    waf: document.getElementById("cost-detail-waf"),
    total: document.getElementById("cost-detail-total"),
    tiersCostsTable: document.getElementById("tiers-costs-table"),
  };

  ///////
  // Setup change and click listeners
  ///////

  /**
   *
   * @param {Costs} costs
   * @param {CostCalculatorValuesState} values
   * @param {NcuEstimateValuesState} ncuEstimateValues
   */
  const setupChangeListeners = (
    costs,
    values = calculatorValuesState,
    ncuEstimateValues = ncuEstimateValuesState
  ) => {
    Object.keys(costFormElements).map((elName) => {
      costFormElements[elName].addEventListener("change", (evt) => {
        if (elName === "isWAF") {
          values[elName] = evt.target.checked;
        } else if (elName === "dataProcessedGB" || elName === "numNcus" || elName === "numHours" || elName === "numListenPorts") {
          values[elName] = parseFloat(evt.target.value) || 0;
        } else {
          values[elName] = evt.target.value;
        }
        updateCost(costs);
      });
    });

    Object.keys(ncuFormElements).map((elName) => {
      ncuFormElements[elName].addEventListener("change", (evt) => {
        ncuEstimateValues[elName] = evt.target.value;
        updateNcuEstimate(ncuEstimateValues);
      });
    });

    document.getElementById("printButton").addEventListener('click', () => {
      printCostEstimate();
    });
  };

  //////
  // Element and form value initialization functions
  //////

  /**
   *
   * @param {Costs["regionsTiers"]} regionsTiers
   */
  const populateTierSelect = (regionsTiers) => {
    const $selectTarget = document.getElementById("region");

    Object.keys(regionsTiers).forEach((tierKey) => {
      const option = document.createElement("option");
      option.setAttribute("value", tierKey);
      option.innerText = `${regionsTiers[tierKey].label} (tier ${regionsTiers[tierKey].tier})`;
      $selectTarget.append(option);
    });
  };

  /**
   * @param {Costs["regionsTiers"]} regionsTiers
   * @param {Costs["tiersCosts"]} tiersCosts
   */
  const populateTierCostTable = (regionsTiers, tiersCosts) => {
    const $tableTarget = totalCostDetailElements.tiersCostsTable;

    Object.keys(regionsTiers).forEach((tierKey) => {
      const row = document.createElement("tr");
      const col1 = document.createElement("td");
      const col2 = document.createElement("td");
      const col3 = document.createElement("td");
      const col4 = document.createElement("td");
      const col5 = document.createElement("td");
      const col6 = document.createElement("td");
      
      const tier = regionsTiers[tierKey].tier;
      
      const formattedWithoutWAF = utils.currencyFormatter(tiersCosts[tier].withoutWAF);
      const formattedWithWAF = utils.currencyFormatter(tiersCosts[tier].withWAF);
      const formattedDeploymentWithoutWAF = utils.currencyFormatter(costs.deploymentFee[tier].withoutWAF);
      const formattedDeploymentWithWAF = utils.currencyFormatter(costs.deploymentFee[tier].withWAF);
      
      col1.innerText = `${regionsTiers[tierKey].label}`;
      col2.innerText = `${tier}`;
      col3.innerText = formattedWithoutWAF;
      col4.innerText = formattedWithWAF;
      col5.innerText = formattedDeploymentWithoutWAF;
      col6.innerText = formattedDeploymentWithWAF;

      row.appendChild(col1);
      row.appendChild(col2);
      row.appendChild(col3);
      row.appendChild(col4);
      row.appendChild(col5);
      row.appendChild(col6);

      $tableTarget.append(row);
    });
  };

  /**
   * Sets DOM elements with initial values from cost form state
   *
   * @param {CostCalculatorValuesState} values
   */
  const initializeValues = (values = calculatorValuesState) => {
    Object.keys(costFormElements).map((elName) => {
      const curEl = costFormElements[elName];
      if (curEl.tagName.toLowerCase() === "input" || curEl.tagName.toLowerCase() === "select") {
        curEl.value = values[elName];
      } else {
        $(curEl).children("input").first().value = values[elName];
      }
    });
  };

  /**
   * Sets DOM elements with initial values from NCU form state
   *
   * @param {NcuEstimateValuesState} values
   */
  const initializeNcuEstimateValues = (values = ncuEstimateValuesState) => {
    Object.keys(ncuFormElements).map((elName) => {
      const curEl = ncuFormElements[elName];
      if (curEl.tagName.toLowerCase() === "input" || curEl.tagName.toLowerCase() === "select") {
        curEl.value = values[elName];
      } else {
        $(curEl).children("input").first().value = values[elName];
      }
    });

    updateNcuEstimate(ncuEstimateValuesState);

    ncuEstimateElements.ncuEstConnsPerNcu.textContent = ncuParameterVals.connsPerNcu;
    ncuEstimateElements.ncuEstConnsPerSecondPerNcu.textContent = 
      (
        ncuParameterVals.connsPerSecPerAcu * ncuParameterVals.acusPerNcu
      ).toFixed(2);
    ncuEstimateElements.ncuEstMbpsPerNcu.textContent = ncuParameterVals.mbpsPerNcu;
  };

  //////
  // Update values functions
  //////

  /**
   * Calculates new NCU usage estimate and updates DOM elements that show values
   *
   * @param {NcuEstimateValuesState} ncuValues
   */
  const updateNcuEstimate = (ncuValues) => {
    const updatedNcuValues = utils.calculateNcuValues(ncuValues);

    document.getElementById("ncuEstimateValue").textContent = `${updatedNcuValues.total} NCUs`;

    // update cost estimate form when estimated number of NCUs changes
    if (calculatorValuesState.numNcus !== updatedNcuValues.total) {
      costFormElements.numNcus.value = updatedNcuValues.total 
      costFormElements.numNcus.dispatchEvent(new Event("change"));
    }

    ncuEstimateElements.ncuEstConnRate.textContent = ncuValues.avgNewConnsPerSec;
    ncuEstimateElements.ncuEstConnDuration.textContent = ncuValues.avgConnDuration;
    ncuEstimateElements.ncuEstAvgConn.textContent = updatedNcuValues.avgConcurrentConnections;

    ncuEstimateElements.ncuEstAvgConn2.textContent = updatedNcuValues.avgConcurrentConnections;
    ncuEstimateElements.ncuEstConnRate2.textContent = ncuValues.avgNewConnsPerSec;
    ncuEstimateElements.ncuEstDataRate.textContent = ncuValues.totalBandwidth;

    ncuEstimateElements.ncuEstMin1.textContent = (updatedNcuValues.min ?? 0).toFixed(2);
    ncuEstimateElements.ncuEstMin.textContent = (updatedNcuValues.min ?? 0).toFixed(2);
    ncuEstimateElements.ncuEstTotal.textContent = updatedNcuValues.total;

    costFormLabelElements.numNcusEstVal.textContent = updatedNcuValues.total;
  };

  /**
   * Calculates new estimated cost based on base costs and
   * form values, and updates the DOM elements that show values
   *
   * @param {Costs} costs
   * @param {CostCalculatorValuesState} values
   */
  const updateCost = (costs, values = calculatorValuesState) => {
    const updatedTotalCost = utils.calculateCost(costs, values);

    document.getElementById("total-value").textContent = utils.currencyFormatter(updatedTotalCost);
    updateTotalCostDetails(values, updatedTotalCost);
  };

  /**
   * @param {CostCalculatorValuesState} formValues
   * @param {number} totalCost
   */
  const updateTotalCostDetails = (formValues, totalCost) => {
    totalCostDetailElements.hours.textContent = formValues.numHours;
    totalCostDetailElements.ncus.textContent = formValues.numNcus;
    totalCostDetailElements.listenPorts.textContent = Math.max(formValues.numListenPorts - 5, 0);
    
    const tier = costs.regionsTiers[formValues.region].tier;
    const wafKey = formValues.isWAF ? 'withWAF' : 'withoutWAF';
    
    totalCostDetailElements.listenPortsCost.textContent = utils.currencyFormatter(costs.tiersCosts[tier]["withoutWAF"]);
    // Update deployment fee
    if (totalCostDetailElements.deploymentFee) {
      totalCostDetailElements.deploymentFee.textContent = utils.currencyFormatter(costs.deploymentFee[tier][wafKey]);
    }
    
    // Update data processing cost details
    if (totalCostDetailElements.dataProcessed) {
      totalCostDetailElements.dataProcessed.textContent = formValues.dataProcessedGB;
    }
    if (totalCostDetailElements.dataProcessingCost) {
      totalCostDetailElements.dataProcessingCost.textContent = utils.currencyFormatter(costs.dataProcessing);
    }

    // Update NCU cost based on tier and WAF usage
    totalCostDetailElements.tierCost.textContent = utils.currencyFormatter(costs.tiersCosts[tier][wafKey]);

    totalCostDetailElements.total.textContent = utils.currencyFormatter(totalCost);

    // update highlighted tier cost
    const rowIndex =
      Object.keys(costs.regionsTiers).indexOf(formValues.region) + 1;

    totalCostDetailElements.tiersCostsTable.querySelectorAll("tr")?.forEach((rowEl, index) => {
      if (index === rowIndex) {
        rowEl.classList.add("selected");
      } else {
        rowEl.classList.remove("selected");
      }
    });
  };

  /**
   * Opens collapsed sections and uses window.print to open the
   * browser default print window
   */
  function printCostEstimate() {
    // expand the total price details if they aren't already
    const totalDetails = document.getElementById("total-cost-details");
    const detailsOpen = totalDetails.hasAttribute("open");
    if (!detailsOpen) {
      totalDetails.setAttribute("open", "true");
    }
    const ncuDetails = document.getElementById("ncu-usage-details");
    const ncuDetailsOpen = ncuDetails.hasAttribute("open");
    if (!ncuDetailsOpen) {
      ncuDetails.setAttribute("open", "true");
    }

    window.print();

    // collapse the total price details if it was closed initially
    if (!detailsOpen) {
      totalDetails.setAttribute("open", null);
    }
    if (!ncuDetailsOpen) {
      ncuDetails.setAttribute("open", null);
    }
  }

  const start = async () => {
    const costs = await utils.loadCosts();
    setupChangeListeners(costs);
    initializeValues(calculatorValuesState);
    initializeNcuEstimateValues(ncuEstimateValuesState);
    populateTierSelect(costs.regionsTiers);
    populateTierCostTable(costs.regionsTiers, costs.tiersCosts);
    updateCost(costs);
  };
  start();
})();
