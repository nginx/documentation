---
f5-product: F5 Application Delivery Service
f5-files:
- content/f5ads/google/billing/usage-dashboard.md
- content/f5ads/aws/billing/usage-dashboard.md
---

## Detailed per-deployment analysis

This dashboard provides granular, per-deployment usage analysis. View individual deployment consumption, region-specific usage, and hourly patterns for each deployment.

## Viewing your usage data

Access your usage dashboard to view consumption metrics across all your deployments. The dashboard displays hourly usage data that you can filter and analyze based on your needs.

## Available filters

### Time period selection

Choose the time range for your usage from the predefined ranges. The default time range is last 30 days.

### Filtering options

Narrow down your usage data using these filters. You can combine multiple filters to get more precise usage insights:

| Filter | Description | Use Case |
|--------|-------------|----------|
| **Cloud provider** | Filter by cloud provider (Google or AWS). Leave empty to view usage across all providers. | Compare usage across cloud providers or focus on a specific provider |
| **Region** | Filter by region | Analyze regional usage patterns |
| **Deployment** | Filter by specific deployment | Focus on individual deployment consumption |

#### Filtering workflow

To analyze your usage data, follow this step-by-step filtering process:

1. **Select a time range** - Choose from the available time periods as described in [Time period selection](#time-period-selection)
2. **Filter by cloud provider** (optional) - Select Google or AWS to focus on one provider, or leave empty to see usage across all providers
3. **Filter by region** - Narrow down the data to specific regions where your deployments are located
4. **Filter by deployment** - Focus on specific deployments within the selected region for detailed analysis

This hierarchical filtering approach allows you to progressively narrow your analysis from organization-wide usage to specific deployment performance.

## Usage metrics explained

### Hourly data points

Usage data is collected and displayed on an hourly basis. Each hour shows:

- **Timestamp**: The specific hour when usage was recorded
- **Location details**: Region and deployment information
- **Consumption metrics**: Detailed usage measurements

### Usage meters

Your usage dashboard tracks several types of consumption:

| Meter type | Unit | Description |
|------------|------|-------------|
| **Fixed** | hours | Base service cost |
| **NGINX Capacity Unit (NCU)** | NCU/hr | Processing capacity used |
| **Data Processed** | MiB | Volume of data handled |

For more information about NCU, see the [billing overview](overview.md).

## Data retention

Historical usage data is available for **up to one year**, allowing for comprehensive analysis and trend identification.
