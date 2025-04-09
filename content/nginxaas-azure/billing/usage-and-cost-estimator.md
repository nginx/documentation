---
title: Usage and cost estimator
weight: 200
toc: true
docs: DOCS-1474
url: /nginxaas/azure/billing/usage-and-cost-estimator/
type:
- concept
---

{{< raw-html >}}

<link rel="stylesheet" href="/nginxaas-azure/css/cost-calculator_v2.css">
<div id="calculator">
    <h3 id="calculator-section-heading">
            Cost Estimation for Standard V2 Plan
            <button id="printButton">Print Estimate</button>
        </h3>
    <div class="section">
        <div class="form-section">
            <div class="form-section-content">
                <h4>1. Estimate NCU Usage </h4>
                <div>
                    <div class="form-field">
                        <label for="avgNewConnsPerSec">
                            Average New Connections per Second
                        </label>
                        <input id="avgNewConnsPerSec" type="number" />
                    </div>
                    <div class="form-field avg-conn-duration-container">
                        <label for="avgConnDuration">
                            Average Connection Duration
                        </label>
                        <input id="avgConnDuration" type="number" />
                    </div>
                    <div class="form-field bandwidth-input-container">
                        <label for="totalBandwidth">
                            Total Processed Data
                        </label>
                        <input id="totalBandwidth" type="number" />
                    </div>
                </div>
            </div>
            <div class="form-section-content">
                <div class=form-section-footer>
                    <div class="totals">
                        <span>NGINX Capacity Units Needed</span>
                        <span id="ncuEstimateValue">--</span>
                        <span> Sold in bundles of 10, with a minimum of 10</span>
                    </div>
                    <details id="ncu-usage-details">
                        <summary>Show calculations</summary>
                        <div id="ncuEstimateDetails">
                        <div class="math">
                            <var id="ncuEstConnRate">x</var> new connections per second *
                            <var id="ncuEstConnDuration">y</var> average connection duration seconds =
                            <var id="ncuEstAvgConn">z</var> average concurrent connections
                        </div>
                        <pre class="math">
Max(
    <var id="ncuEstAvgConn2">x</var> concurrent connections / <span id="ncuEstConnsPerNcu"></span> Conns per NCU,
    <var id="ncuEstConnRate2">y</var> connections per second / <span id="ncuEstConnsPerSecondPerNcu"></span> conns per second per NCU,
    <var id="ncuEstDataRate">z</var> Mbps / <span id="ncuEstMbpsPerNcu"></span>Mbps per NCU
) = <var id="ncuEstMin1"></var> NCUs
</pre>
                        <div class="math">
                            Usage needs at least <var id="ncuEstMin">x</var> NCUs, rounded to the nearest 10, with a minimum of 10 = <var id="ncuEstTotal">total</var> NCUs
                        </div>
                        </div>
                    </details>
                </div>
            </div>
        </div>
        <div class="form-section">
        <div class=form-section-content>
            <h4 id="calculator-section-heading">
               2. Estimate Monthly Cost
            </h4>
            <div class="form-field">
                <label for="region">
                    Region
                </label>
                <select id="region">
                <!-- options appended from tiers data -->
                </select>
            </div>
            <div class="form-field">
                <label for="numNcus">
                    NCUs <span class="label-details">- value from usage estimate: <span id="numNcusEstVal"> - </span></span>
                </label>
                <input id="numNcus" type="number" step="10" min="10" />
                <span id="ncuValidation"></span>
            </div>
            <div class="form-field">
                <label for="numHours">
                    Hours <span class="label-details">- used in a month</span>
                </label>
                <input id="numHours" type="number"/>
            </div>
            <div class="form-field">
                <label for="numListenPorts">
                    Listen Ports <span class="label-details">- first 5 are included</span>
                </label>
                <input id="numListenPorts" type="number"/>
            </div>
            <div class="form-field">
                <label for="isWAF">
                    Utilize WAF <span class="label-details"></span>
                </label>
                <input type="checkbox" id="isWAF" />
            </div>
            </div>
            <div class=form-section-content>
                <div id="totals-section">
                    <span class="total-text">Total Monthly Payment</span>
                    <span id="total-value" class="total-text">--</span>
                    <div class="subtitle">
                        The standard Azure networking and bandwidth charges apply to NGINX deployments.
                    </div>
                    <details id="total-cost-details">
                        <summary>Show calculations</summary>
                        <div class="details-content">
                            <div class="details-section">
                                <p class="math">
                                    <var id="cost-detail-hours"></var> hours * ((<var id="cost-detail-ncus"></var> NCUs * <var id="cost-detail-tier-cost"></var> per NCU per hour) + <var id="cost-detail-listen-ports"></var> additional listen ports * <var id="cost-detail-listen-ports-cost"></var>) = <var id="cost-detail-total"></var>
                                    </br>
                                </p>
                            </div>
                            <div class="details-section">
                                <table class="math" id="tiers-costs-table">
                                    <tr>
                                        <th>Region</th>
                                        <th>Tier</th>
                                        <th>Cost per NCU/hr</th>
                                    </tr>
                                    <!-- tier costs data appended here -->
                                </table>
                            </div>
                        </div>
                    </details>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="module" src="/nginxaas-azure/js/cost-calculator_v2.js"></script>
{{< /raw-html >}}
