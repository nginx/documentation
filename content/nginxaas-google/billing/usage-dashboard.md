---
title: Usage dashboard
weight: 300
toc: true
url: /nginxaas/google/billing/usage-dashboard/
nd-content-type: concept
nd-product: NGOOGL
---

# Usage dashboard

The Usage dashboard provides detailed insights into your NGINX as a Service resource consumption for the entire customer organization, encompassing deployments across all geographies and regions. View hourly usage metrics to track costs, analyze patterns, and optimize your deployments. Use the dashboard to analyze daily traffic patterns, plan capacity requirements, and optimize geographic distribution across regions.

Use this dashboard to get daily and monthly usage trends, monitor peak traffic hours to plan scaling strategies and compare performance across different regions to optimize deployment location.

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
| **Region** | Filter by cloud region | Analyze regional usage patterns |
| **Deployment** | Filter by specific deployment | Focus on individual deployment consumption |

#### Filtering workflow

To analyze your usage data, follow this step-by-step filtering process:

1. **Select a time range** - Choose from the available time periods as described in [Time Period Selection](#time-period-selection)
2. **Filter by region** - Narrow down the data to specific cloud regions where your deployments are located
3. **Filter by deployment** - Focus on specific deployments within the selected region for detailed analysis

This hierarchical filtering approach allows you to progressively narrow your analysis from organization-wide usage to specific deployment performance.

## Usage metrics explained

### Hourly data points

Usage data is collected and displayed on an hourly basis. Each hour shows:

- **Timestamp**: The specific hour when usage was recorded
- **Location Details**: Region and deployment information
- **Consumption Metrics**: Detailed usage measurements

### Usage meters

Your usage dashboard tracks several types of consumption:

| Meter Type | Description |
|------------|-------------|
| **Fixed** | Base service cost |
| **NCU (NGINX Compute Units)** | Processing capacity used |
| **Data Processed** | Volume of data handled |

For more information about NCU, see the [overview](overview.md).

## Data retention

Historical usage data is available for **up to one year**, allowing for comprehensive analysis and trend identification.