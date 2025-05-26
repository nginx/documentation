---
title: Enable monitoring
weight: 200
toc: true
docs: DOCS-876
url: /nginxaas/azure/monitoring/enable-monitoring/
type:
- how-to
---

Monitoring your application's performance is crucial for maintaining its reliability and efficiency. F5 NGINX as a Service for Azure (NGINXaaS) seamlessly integrates with Azure Monitor, allowing you to collect, correlate, and analyze metrics for a thorough understanding of your application's health and behavior. 

Refer to the [Azure monitor overview](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) documentation from Microsoft to learn more about Azure Monitor.

### Prerequisites

- A system assigned managed identity with `Monitoring Metrics Publisher` role.

{{<note>}} When a system assigned managed identity is added to the deployment through portal, this role is automatically added.{{</note>}}

## Collection

Azure Monitor will collects metrics from the NGINXaaS deployment automatically if the prerequisites are met. No configuration is required.

## Exporting
You can export Azure Monitor metrics to other destinations like Log Analytics workspace, Azure Storage Account, Azure Event Hubs or Azure Monitor partner solutions using Diagnostic Setting. For more information, see the [Metrics diagnostic setting](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings).

To configure diagnostic settings for a service, see [Create diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/create-diagnostic-settings).

{{<note>}} Not all metrics are exportable via diagnostic settings, for a list of exportable metrics, see [NGINXaaS exportable metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/nginx-nginxplus-nginxdeployments-metrics).{{</note>}}


## Cost and retention
Azure Monitor platform metrics are ingested and stored free of charge, with a standard retention period of 93 days. Adding alerts, querying Azure Monitor using REST API or exporting metrics using Azure Monitor's diagnostic settings would incurs costs. For detailed pricing, you can refer to the [Azure Monitor pricing page](https://azure.microsoft.com/en-us/pricing/details/monitor/).


## View metrics with Azure Monitor metrics explorer

Access the [Microsoft Azure portal](https://portal.azure.com)

1. Go to your NGINXaaS for Azure deployment.
2. In the navigation pane under **Monitoring**, select the **Metrics** section to access the Azure Monitor metrics explorer for your NGINXaaS deployment.

Refer to the [Azure Monitor metrics explorer](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-getting-started) documentation from Microsoft to learn how you can create queries.

{{<note>}}Many of NGINX Plus's advanced statistics need to be enabled in the "nginx.conf" file before they will appear in the metrics explorer, for example "plus.http.request.bytes_*". Refer to [Gathering Data to Appear in Statistics](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#gathering-data-to-appear-in-statistics) to learn more.{{</note>}}

## Retrieve metrics through Azure Monitor REST API

This section shows you how to effectively discover, gather and analyze NGINXaaS metrics through the Azure Monitor REST API.

{{<note>}}Refer to [Authenticate Azure Monitor requests](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/rest-api-walkthrough?tabs=portal#authenticate-azure-monitor-requests) for instructions on authenticating your API requests against the Azure Monitor API endpoint.{{</note>}}


1. **Retrieve metric definitions:** Metrics definitions give you insights into the various metrics available for NGINXaaS within a namespace and what they represent. The following `curl` example shows how to retrieve all metrics definitions within the `nginx connections statistics` namespace for your NGINXaaS deployment:

   ```bash
   curl --request GET --header "Authorization: Bearer $TOKEN" "https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/microsoft.insights/metricDefinitions?api-version=2024-02-01"
   ```

   The following JSON shows an example response body:

   ```json
   {
     "value": [
   	...
       {
         "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/microsoft.insights/metricdefinitions/Nginx Connections Statistics/nginx.conn.current",
         "resourceId": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-deployment",
         "namespace": "NGINX.NGINXPLUS/nginxDeployments",
         "category":"nginx connections statistics",
         "name": {
           "value": "nginx.conn.current",
           "localizedValue": "Current connections"
         },
         ...
       }
   	...
     ]
   }
   ```

2. **Metric values:** You can obtain the actual metric values which represent real-time or historical data points that tell you how your NGINXaaS is performing. The following `curl` example shows how to retrieve the value of metric `nginx.conn.current` over a 10-minute time window averaged over 5 minute intervals:

   ```bash
   curl --request GET --header "Authorization: Bearer $TOKEN" "https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/microsoft.insights/metrics?metricnames=nginx.conn.current&timespan=2025-03-27T20:00:00Z/2025-03-27T20:10:00Z&aggregation=Average&interval=PT5M&api-version=2024-02-01"
   ```

   The following JSON shows an example response body:

   ```json
   {
     "cost": 9,
     "timespan": "2025-03-27T20:00:00Z/2025-03-27T20:10:00Z",
     "interval": "PT5M",
     "value": [
       {
         "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/Microsoft.Insights/metrics/nginx.conn.current",
         "type": "Microsoft.Insights/metrics",
         "name": {
           "value": "nginx.conn.current",
           "localizedValue": "Current connections"
         },
         "unit": "Count",
         "timeseries": [
           {
             "metadatavalues": [],
             "data": [
               {
                 "timeStamp": "2025-03-27T20:00:00Z",
                 "average": 4
               },
               {
                 "timeStamp": "2025-03-27T20:05:00Z",
                 "average": 4
               }
             ]
           }
         ],
         "errorCode": "Success"
       }
     ],
     "namespace": "NGINX.NGINXPLUS/nginxDeployments",
     "resourceregion": "eastus2"
   }
   ```

{{<note>}} Refer to the [Metrics Catalog]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md" >}}) for a listing of available namespaces and metrics.{{</note>}}
