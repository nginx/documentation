---
title: Usage Dashboard
weight: 300
---

# Usage Dashboard

The Usage Dashboard provides detailed insights into your NGINX as a Service resource consumption. View hourly usage metrics to track costs, analyze patterns, and optimize your deployments. Use the dashboard to analyze daily traffic patterns, plan capacity requirements, and optimize geographic distribution across regions.

Use this dashboard to revie daily and monthly usage trends, monitor peak traffic hours to plan scaling strategies and compare performance across different regions to optimize deployment location.

## Detailed Per-Deployment Analysis

This dashboard provides granular, per-deployment usage analysis beyond GCP Marketplace aggregate reports. View individual deployment consumption, namespace-specific usage, and hourly patterns for each deployment.

## Viewing Your Usage Data

Access your usage dashboard to view consumption metrics across all your deployments. The dashboard displays hourly usage data that you can filter and analyze based on your needs.

## Available Filters

### Time Period Selection

Choose the time range for your usage analysis:

- **Start Date & Time**: Beginning of the period you want to analyze
- **End Date & Time**: End of the period you want to analyze

*Time periods can range from a single hour to several months, depending on your analysis needs. All times are displayed in UTC.*

### Filtering Options

Narrow down your usage data using these filters. You can combine multiple filters to get more precise usage insights:

| Filter | Description | Use Case |
|--------|-------------|----------|
| **Namespace** | Filter by namespace | View usage for specific application environments (e.g., production, staging) |
| **Region** | Filter by cloud region | Analyze regional usage patterns |
| **Deployment** | Filter by specific deployment | Focus on individual deployment performance and consumption |

## Usage Metrics Explained

### Hourly Data Points

Usage data is collected and displayed on an hourly basis. Each hour shows:

- **Timestamp**: The specific hour when usage was recorded
- **Location Details**: Namespace, region, and deployment information
- **Consumption Metrics**: Detailed usage measurements

### Usage Meters

Your usage dashboard tracks several types of consumption:

| Meter Type | Description |
|------------|-------------|
| **Fixed** | Base service cost |
| **NCU (NGINX Compute Units)** | Processing capacity used |
| **Data Processed** | Volume of data handled |

## Usage Data Display

### Navigation
For large datasets, the dashboard provides:
- **Pagination**: Navigate through multiple pages of results
- **Page Size Options**: Choose how many records to display per page (up to 1,000)
- **Quick Navigation**: Jump between pages efficiently

## Data Retention
Historical usage data is available for up to one year, allowing for comprehensive analysis and trend identification.