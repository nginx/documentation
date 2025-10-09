---
title: Usage and cost estimator
weight: 200
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/billing/usage-and-cost-estimator/
type:
- concept
---

{{< raw-html >}}
<link rel="stylesheet" href="/nginxaas-google/css/cost-calculator_v2.css">
<div id="calculator">
  <h3 id="calculator-section-heading">
    Cost Estimation for Enterprise Plan
    <button id="printButton">Print Estimate</button>
  </h3>

  <div class="section">
    <div class="form-section">
      <div class="form-section-content">
        <h4 id="calculator-section-heading">Estimate Monthly Cost</h4>

        <div class="form-field">
          <label for="numNcus">NCUs</label>
          <input id="numNcus" type="number" step="10" min="10" />
        </div>

        <div class="form-field">
          <label for="numHours">
            Hours <span class="label-details">- used in a month</span>
          </label>
          <input id="numHours" type="number" />
        </div>

        <div class="form-field">
          <label for="dataProcessedGb">Data Processed (GB/month)</label>
          <input id="dataProcessedGb" type="number" />
        </div>
      </div>

      <div class="form-section-content">
        <div id="totals-section">
          <span class="total-text">Total Monthly Payment</span>
          <span id="total-value" class="total-text">--</span>

          <details id="total-cost-details">
            <summary>Show calculations</summary>
            <div class="details-content">
              <div class="details-section">
                <p class="math">
                  <var id="cost-detail-hours"></var> hours * (
                    <var id="cost-detail-fixed-hourly"></var> fixed/hr +
                    <var id="cost-detail-ncus"></var> NCUs * <var id="cost-detail-ncu-hourly"></var> per NCU/hr
                  )
                  + <var id="cost-detail-data-gb"></var> GB * <var id="cost-detail-data-pergb"></var> per GB
                  = <var id="cost-detail-total"></var>
                </p>
              </div>
            </div>
          </details>
        </div>
      </div>
    </div>
  </div>
</div>

<script type="module" src="/nginxaas-google/js/cost-calculator_gc.js"></script>

{{< /raw-html >}}
