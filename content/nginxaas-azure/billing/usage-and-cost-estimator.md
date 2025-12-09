---
title: Usage and cost estimator
weight: 200
toc: true
nd-docs: DOCS-1474
url: /nginxaas/azure/billing/usage-and-cost-estimator/
type:
- concept
---

{{< raw-html >}}

<link rel="stylesheet" href="/nginxaas-azure/css/cost-calculator_v2.css">
<div id="calculator" data-testid="calculator">
    <h3 id="calculator-section-heading" data-testid="calculator-section-heading">
            Cost Estimation for Standard V2 Plan
            <button id="printButton">Print Estimate</button>
        </h3>
    <div class="section" data-testid="calculator-section-content">
        <div class="form-section">
            <div class="form-section-content" data-testid="form-section-content-estimateNCUUsage">
                <h4>1. Estimate NCU Usage </h4>
                <div>
                    <div class="form-field">
                        <label for="avgNewConnsPerSec">
                            Average New Connections per Second
                        </label>
                        <input id="avgNewConnsPerSec" type="number" data-testid="input-avgNewConnsPerSec"/>
                    </div>
                    <div class="form-field avg-conn-duration-container">
                        <label for="avgConnDuration">
                            Average Connection Duration
                        </label>
                        <input id="avgConnDuration" type="number" data-testid="input-avgConnDuration"/>
                    </div>
                    <div class="form-field bandwidth-input-container">
                        <label for="totalBandwidth">
                            Total Processed Data
                        </label>
                        <input id="totalBandwidth" type="number" data-testid="input-totalBandwidth"/>
                    </div>
                </div>
            </div>
            <div class="form-section-content" data-testid="form-section-content-capacityUnitsNeeded">
                <div class=form-section-footer>
                    <div class="totals">
                        <span>NGINX Capacity Units Needed</span>
                        <span id="ncuEstimateValue" data-testid="ncuEstimateValue">--</span>
                        <span> Sold in bundles of 10, with a minimum of 10</span>
                    </div>
                    <details id="ncu-usage-details">
                        <summary data-testid="button-ncu-usage-details">Show calculations</summary>
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
        <div class="form-section-content" data-testid="form-section-content-estimateMonthlyCost">
            <h4 id="calculator-section-heading">
               2. Estimate Monthly Cost
            </h4>
            <div class="form-field">
                <label for="region">
                    Region
                </label>
                <select id="region" data-testid="dropdown-region">
                <!-- options appended from tiers data -->
                </select>
            </div>
            <div class="form-field">
                <label for="numNcus">
                    NCUs <span class="label-details">- value from usage estimate: <span id="numNcusEstVal"> - </span></span>
                </label>
                <input id="numNcus" data-testid="input-numNcus" type="number" step="10" min="10" />
                <span id="ncuValidation"></span>
            </div>
            <div class="form-field">
                <label for="numHours">
                    Hours <span class="label-details">- used in a month</span>
                </label>
                <input id="numHours" data-testid="input-numHours" type="number"/>
            </div>
            <div class="form-field">
                <label for="numListenPorts">
                    Listen Ports <span class="label-details">- first 5 are included</span>
                </label>
                <input id="numListenPorts" data-testid="input-numListenPorts" type="number"/>
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
                    <span id="total-value" data-testid="total-value" class="total-text">--</span>
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

<h2>Cost analysis tool for standard V3 plan</h2>

<h3>Overview</h3>

The NGINXaaS for Azure cost analysis tool provides a detailed hourly cost breakdown of your NGINXaaS deployment usage for each component (NCU, WAF, Ports, Data). It fetches real-time metrics directly from Azure Monitor and calculates costs based on actual usage.

<h3>Prerequisites</h3>

Before using the cost analysis script:

1. **Python 3.7+** installed on your system
2. **pip3** (Python package manager) installed
3. **Azure SDK for Python** installed:

    ```bash
    pip3 install azure-identity azure-mgmt-monitor
    ```
  
4. **NGINXaaS for Azure deployment on Standard V3 Plan** with monitoring enabled
5. **Azure AD Tenant ID** (required for authentication)
6. **Monitoring Reader permissions** on your NGINXaaS resource

<h4>Setting up Azure permissions</h4>

<strong>Get Tenant ID:</strong>

1. Go to Azure Portal → Microsoft Entra ID → Overview
2. Copy the <strong>Tenant ID</strong>

<strong>Grant Access:</strong>

1. Go to your NGINX resource → Access control (IAM) → Add role assignment
2. Role: <strong>Monitoring Reader</strong> → Assign to your user account

<h3>Download and usage</h3>

#### Download script

{{<icon "download">}} {{<link "/scripts/nginxaas_cost_analysis.py" "Download nginxaas_cost_analysis.py script">}}

#### Basic usage

Run the script with the required parameters:

```bash
python3 nginxaas_cost_analysis.py \
        --resource-id "/subscriptions/xxx/resourceGroups/my-rg/providers/Nginx.NginxPlus/nginxDeployments/my-nginx" \
        --location "eastus2" \
        --date-range "2025-11-18T00:00:00Z/2025-11-19T23:59:59Z" \
        --tenant-id "your-tenant-id" \
        --output "my-cost-analysis.csv"
```

#### Required parameters

| Parameter         | Description                                 | Example                                      |
|-------------------|---------------------------------------------|----------------------------------------------|
| `--resource-id`   | Azure resource ID of NGINXaaS deployment    | `/subscriptions/.../my-nginx`                |
| `--location`      | Azure region for pricing tier                | `eastus2`, `westus2`                         |
| `--date-range`    | Analysis period (max 30 days)                | `2025-11-18T00:00:00Z/2025-11-19T23:59:59Z`  |
| `--tenant-id`     | Azure AD Tenant ID (required for login)      | `12345678-1234-...`                          |
| `--output`        | Output CSV filename (optional)               | `my-cost-analysis.csv`                       |

#### Sample output

{{< details "View sample output" >}}

```
Cost breakdown exported to nginxaas_cost_breakdown.csv
Summary: 96 hours, Total cost: $71.66
Cost analysis completed successfully!
```

{{< /details >}}

<h3>Understanding the results</h3>

<h4>Cost components</h4>

- **Fixed costs**: Fixed deployment cost (varies by region and WAF usage)
- **NCU costs**: Variable costs based on actual NCU consumption
- **WAF costs**: Additional costs when Web Application Firewall is enabled
- **Port costs**: Additional costs for listen ports beyond the first 5
- **Data processing**: Costs for data processed ($0.005/GB across all regions)

<h3>Additional billing resources</h3>

For comprehensive billing information and cost planning, refer to these additional resources:

- **[Usage and Cost Estimator]({{< relref "usage-and-cost-estimator.md" >}})**: Interactive tool for planning and estimating costs before deployment
- **[Billing Overview]({{< relref "overview.md" >}})**: Complete billing model explanation and pricing details

This cost analysis tool helps you understand your actual NGINX for Azure spending by analyzing real usage metrics, enabling you to optimize costs and plan future deployments effectively.
