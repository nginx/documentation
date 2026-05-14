---
title: Enable Metrics
weight: 200
toc: true
f5-docs: DOCS-000
url: /nginxaas/google/observability/enable-metrics/
f5-content-type: how-to
f5-product: NGOOGL
---

Monitoring your application's performance is crucial for maintaining its reliability and efficiency. F5 NGINXaaS for Google Cloud (NGINXaaS) seamlessly integrates with Google Cloud services, allowing you to collect, correlate, and analyze metrics for a thorough understanding of your application's health and behavior.

## Prerequisites

- Enable the [Cloud Monitoring API](https://cloud.google.com/monitoring/api/enable-api).
- Configure Workload Identity Federation (WIF). See [our documentation on setting up WIF]({{< ref "/nginxaas-google/getting-started/access-management.md#configure-wif" >}}) for exact steps.
- Grant your principal access to one of the following IAM roles depending on your needs:
  - `roles/monitoring.viewer` — View metrics in Cloud Monitoring (read-only access)
  - `roles/monitoring.editor` — View metrics and create or import dashboards

  See [Google's documentation on controlling access to Cloud Monitoring with IAM](https://cloud.google.com/monitoring/access-control) for more information.
- Configure the [`status_zone`](https://nginx.org/en/docs/http/ngx_http_status_module.html#status_zone) directive in your `server` blocks and the [`zone`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) directive in your `upstream` blocks to collect HTTP request and response statistics, stream connection metrics, upstream statistics, and memory statistics. See the [Metrics Catalog]({{< ref "/nginxaas-google/observability/metrics-catalog.md" >}}) for configuration requirements.

## Export NGINXaaS metrics to a Google Cloud Project

To enable sending metrics to your desired Google Cloud project, you must specify the project ID when creating or updating a deployment. To create a deployment, see [our documentation on creating an NGINXaaS deployment]({{< ref "/nginxaas-google/getting-started/create-deployment/" >}}) for a step-by-step guide. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter the project you want metrics to be send to under **Metric Project ID**.
1. Select **Update**.

## View NGINXaaS metrics in Google Cloud Monitoring

See the [Metrics Catalog]({{< ref "/nginxaas-google/observability/metrics-catalog.md" >}}) for a full list of metrics NGINXaaS provides.

### Google Cloud Console's Metrics Explorer

Log in to your [Google Cloud Console](https://console.cloud.google.com/),

1. Go to your metric project.
2. Search for "Metrics Explorer".

Refer to the [Google's Metrics Explorer](https://cloud.google.com/monitoring/charts/metrics-explorer) documentation to learn how you can create charts and queries.

### Import a pre-built dashboard

To help you quickly visualize important metrics and logs from your NGINXaaS deployments, you can import a pre-configured dashboard into Google Cloud Monitoring. The dashboard displays key metrics such as request and connection rates, response status codes, upstream health, and access and error logs.

To import the dashboard:

1. Copy the dashboard JSON configuration {{< details summary="Show dashboard JSON" >}}

```json
{
  "displayName": "NGINXaaS",
  "dashboardFilters": [
    {
      "filterType": "METRIC_LABEL",
      "labelKey": "nginxaas_deployment_name",
      "templateVariable": "nginxaas_deployment_name",
      "valueType": "STRING_ARRAY"
    }
  ],
  "description": "",
  "labels": {},
  "mosaicLayout": {
    "columns": 48,
    "tiles": [
      {
        "height": 16,
        "width": 29,
        "widget": {
          "title": "Request + Connection rates",
          "id": "",
          "xyChart": {
            "chartOptions": {
              "displayHorizontal": false,
              "mode": "COLOR",
              "showLegend": false
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "legendTemplate": "Connections/second",
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "sort": [],
                "targetAxis": "Y2",
                "timeSeriesQuery": {
                  "outputFullDuration": false,
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"workload.googleapis.com/nginx.http.connections\" resource.type=\"generic_node\" metric.label.\"nginx_connections_outcome\"=\"ACCEPTED\" ${nginxaas_deployment_name}"
                  },
                  "unitOverride": ""
                }
              },
              {
                "breakdowns": [],
                "dimensions": [],
                "legendTemplate": "Requests/second",
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "sort": [],
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "outputFullDuration": false,
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"workload.googleapis.com/nginx.http.requests\" resource.type=\"generic_node\" ${nginxaas_deployment_name}"
                  },
                  "unitOverride": ""
                }
              }
            ],
            "thresholds": [],
            "y2Axis": {
              "label": "Conn/s",
              "scale": "LINEAR"
            },
            "yAxis": {
              "label": "Req/s",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "xPos": 29,
        "height": 16,
        "width": 18,
        "widget": {
          "title": "Current Connections",
          "id": "",
          "scorecard": {
            "breakdowns": [],
            "dimensions": [],
            "measures": [],
            "sparkChartView": {
              "sparkChartType": "SPARK_LINE"
            },
            "thresholds": [],
            "timeSeriesQuery": {
              "outputFullDuration": false,
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "60s",
                  "crossSeriesReducer": "REDUCE_SUM",
                  "groupByFields": [
                    "metric.label.\"nginx_connections_outcome\""
                  ],
                  "perSeriesAligner": "ALIGN_MEAN"
                },
                "filter": "metric.type=\"workload.googleapis.com/nginx.http.connection.count\" resource.type=\"generic_node\" ${nginxaas_deployment_name}"
              },
              "unitOverride": ""
            }
          }
        }
      },
      {
        "yPos": 16,
        "height": 14,
        "width": 29,
        "widget": {
          "title": "Response rate by Zone + Status",
          "id": "",
          "xyChart": {
            "chartOptions": {
              "displayHorizontal": false,
              "mode": "COLOR",
              "showLegend": false
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "legendTemplate": "",
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "sort": [],
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "outputFullDuration": false,
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"nginx_zone_name\"",
                        "metric.label.\"nginx_status_range\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"workload.googleapis.com/nginx.http.response.status\" resource.type=\"generic_node\" ${nginxaas_deployment_name}"
                  },
                  "unitOverride": ""
                }
              }
            ],
            "thresholds": [],
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 16,
        "xPos": 29,
        "height": 9,
        "width": 9,
        "widget": {
          "title": "Current Requests",
          "id": "",
          "scorecard": {
            "breakdowns": [],
            "dimensions": [],
            "measures": [],
            "sparkChartView": {
              "sparkChartType": "SPARK_LINE"
            },
            "thresholds": [],
            "timeSeriesQuery": {
              "outputFullDuration": false,
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "60s",
                  "crossSeriesReducer": "REDUCE_SUM",
                  "groupByFields": [],
                  "perSeriesAligner": "ALIGN_MEAN"
                },
                "filter": "metric.type=\"workload.googleapis.com/nginx.http.request.processing.count\" resource.type=\"generic_node\" metric.label.\"nginx_zone_name\"=monitoring.regex.full_match(\"..*\") ${nginxaas_deployment_name}",
                "pickTimeSeriesFilter": {
                  "direction": "TOP",
                  "numTimeSeries": 12,
                  "rankingMethod": "METHOD_MEAN"
                }
              },
              "unitOverride": ""
            }
          }
        }
      },
      {
        "yPos": 16,
        "xPos": 38,
        "height": 9,
        "width": 9,
        "widget": {
          "title": "Config updates",
          "id": "",
          "scorecard": {
            "breakdowns": [],
            "dimensions": [],
            "measures": [],
            "sparkChartView": {
              "sparkChartType": "SPARK_LINE"
            },
            "thresholds": [],
            "timeSeriesQuery": {
              "outputFullDuration": true,
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "60s",
                  "crossSeriesReducer": "REDUCE_SUM",
                  "groupByFields": [
                    "metric.label.\"nginxaas_deployment_name\""
                  ],
                  "perSeriesAligner": "ALIGN_DELTA"
                },
                "filter": "metric.type=\"workload.googleapis.com/nginx.config.reloads\" resource.type=\"generic_node\" ${nginxaas_deployment_name}",
                "pickTimeSeriesFilter": {
                  "direction": "TOP",
                  "numTimeSeries": 12,
                  "rankingMethod": "METHOD_MEAN"
                }
              },
              "unitOverride": ""
            }
          }
        }
      },
      {
        "yPos": 25,
        "xPos": 29,
        "height": 12,
        "width": 18,
        "widget": {
          "title": "Upstream Status",
          "id": "",
          "xyChart": {
            "chartOptions": {
              "displayHorizontal": false,
              "mode": "COLOR",
              "showLegend": false
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "legendTemplate": "",
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_AREA",
                "sort": [],
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "outputFullDuration": false,
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"nginx_peer_state\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"workload.googleapis.com/nginx.http.upstream.peer.count\" resource.type=\"generic_node\" ${nginxaas_deployment_name}",
                    "pickTimeSeriesFilter": {
                      "direction": "TOP",
                      "numTimeSeries": 12,
                      "rankingMethod": "METHOD_MAX"
                    }
                  },
                  "unitOverride": ""
                }
              }
            ],
            "thresholds": [],
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 30,
        "height": 14,
        "width": 29,
        "widget": {
          "title": "Upstream Response rate by Zone + Status",
          "id": "",
          "xyChart": {
            "chartOptions": {
              "displayHorizontal": false,
              "mode": "COLOR",
              "showLegend": false
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "legendTemplate": "",
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "sort": [],
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "outputFullDuration": false,
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"nginx_zone_name\"",
                        "metric.label.\"nginx_status_range\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"workload.googleapis.com/nginx.http.upstream.peer.responses\" resource.type=\"generic_node\" ${nginxaas_deployment_name}"
                  },
                  "unitOverride": ""
                }
              }
            ],
            "thresholds": [],
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 44,
        "height": 16,
        "width": 48,
        "widget": {
          "title": "Error Logs",
          "logsPanel": {
            "filter": "resource.type=\"generic_node\"\nlabels.\"log.file.name\"=\"error.log\"\nlabels.\"log.file.path\"=~\"/var/log/nginx/.*\\.log\"",
            "resourceNames": []
          }
        }
      },
      {
        "yPos": 60,
        "height": 16,
        "width": 48,
        "widget": {
          "title": "Access Logs",
          "logsPanel": {
            "filter": "resource.type=\"generic_node\"\nlabels.\"log.file.name\"=\"access.log\"\nlabels.\"log.file.path\"=~\"/var/log/nginx/.*\\.log\"",
            "resourceNames": []
          }
        }
      }
    ]
  }
}
```

{{< /details >}}

2. Go to the [Google Cloud Console](https://console.cloud.google.com/).
3. Go to your metrics project.
4. Search for **Monitoring** and select **Dashboards**.
5. Select **Create Custom Dashboard**.
6. Select the settings icon (⚙), and select **JSON** to switch to JSON editor mode.
7. Replace the default JSON with the dashboard configuration you copied.
8. Select **Apply Changes**.

{{< call-out "note" >}}The dashboard includes an **nginxaas_deployment_name** filter. Use this filter to view metrics for a specific NGINXaaS deployment or select multiple deployments to compare their performance.{{< /call-out >}}

## Disable exporting NGINXaaS metrics to a Google Cloud project

To disable sending metrics to your Google Cloud project, update your NGINXaaS deployment to remove the reference to your project ID. To update the deployment, in the NGINXaaS console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Remove the project ID under **Metric Project ID**.
1. Select **Update**.

## Troubleshooting

If Google Cloud Monitoring is not showing any metrics, check for **Failed Metric Export to Google** events from your NGINXaaS deployment.

In the NGINXaaS console:

1. On the navigation menu, select **Events**.
1. Select **Add Filter**.
1. Select **Affected Object** and the name of your NGINXaaS deployment.

Events are deleted after 14 days.
