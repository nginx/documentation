---
title: Enable monitoring
weight: 200
toc: true
docs: DOCS-876
url: /nginxaas/azure/monitoring/enable-monitoring/
type:
- how-to
---

Monitoring your application's performance is crucial for maintaining its reliability and efficiency. F5 NGINX as a Service for Azure (NGINXaaS) seamlessly integrates with Azure Monitor, allowing you to collect, correlate, and analyze metrics for a thorough understanding of your application's health and behavior. With Azure Monitor, you gain access to a wealth of information regarding your application's operations. You can:

- Review Metrics: Examine the performance data collected from your application.
- Correlate Data: Connect different data points to gain insights into application performance trends.
- Analyze Performance: Dive deep into metrics to gain a comprehensive understanding of how your application operates.
- Create Alerts: Set up proactive monitoring by configuring alerts that notify you of potential issues before they escalate.

{{<note>}}NGINXaaS for Azure publishes *custom* metrics to Azure Monitor. To learn about the differences between standard and custom metrics, refer to the [Custom metrics in Azure Monitor overview](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-custom-overview) documentation from Microsoft. Azure Monitor custom metrics are currently in public preview.{{</note>}}


### Prerequisites

- A user assigned managed identity or a system assigned managed identity with `Monitoring Metrics Publisher` role.

{{<note>}} When a user assigned managed identity or a system assigned managed identity is added to the deployment through portal, this role is automatically added.{{</note>}}

- User must be an owner or user access administrator for NGINX deployment resource to complete this set up.

- If you're unfamiliar with Azure Monitor, refer to the [Azure monitor overview](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) documentation from Microsoft.

## Enable monitoring

1. Log in to the Azure portal and navigate to your NGINXaaS for Azure deployment.
2. In the navigation pane under **Settings**, select the **NGINX monitoring** section.
3. Turn on the **Send metrics to Azure Monitor** setting.

## View metrics with Azure Monitor metrics explorer

1. In the navigation pane under **Monitoring**, select the **Metrics** section to access the Azure Monitor metrics explorer for your NGINXaaS deployment.
2. Refer to the [Azure Monitor metrics explorer](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-getting-started) documentation from Microsoft to learn how you can create queries.

{{<note>}}Many of NGINX Plus's advanced statistics need to be enabled in the "nginx.conf" file before they will appear in the metrics explorer, for example "plus.http.request.bytes_*". Refer to [Gathering Data to Appear in Statistics](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#gathering-data-to-appear-in-statistics) to learn more.{{</note>}}

## Retrieve metrics through Azure Monitor API

This section shows you how to effectively discover, gather and analyze NGINXaaS metrics through the Azure Monitor API.

{{<note>}}Refer to [Authenticate Azure Monitor requests](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/rest-api-walkthrough?tabs=portal#authenticate-azure-monitor-requests) for instructions on authenticating your API requests against the Azure Monitor API endpoint.{{</note>}}

1. **Retrieve metric namespaces:** Each metric belongs to a category, or "namespace", which groups similar types of metrics together. We recommend listing all namespaces for NGINXaaS to locate the metrics you're interested in. The following `curl` example shows how to retrieve all metrics namespaces on your NGINXaaS deployment:

   ```bash
   curl --request GET --header "Authorization: Bearer $TOKEN" "https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/microsoft.insights/metricNamespaces?api-version=2024-02-01"
   ```

   The following JSON shows an example response body:

   ```json
   {
     "value": [
    	...
   	{
         "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/microsoft.insights/metricNamespaces/NGINX Connections Statistics",
         "name": "nginx connections statistics",
   	  "type": "Microsoft.Insights/metricNamespaces",
         "classification": "Custom",
         "properties": {
           "metricNamespaceName": "nginx connections statistics"
         }
       },
   	...
     ]
   }
   ```

2. **Retrieve metric definitions:** Metrics definitions give you insights into the various metrics available for NGINXaaS within a namespace and what they represent. The following `curl` example shows how to retrieve all metrics definitions within the `nginx connections statistics` namespace for your NGINXaaS deployment:

   ```bash
   curl --request GET --header "Authorization: Bearer $TOKEN" "https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/microsoft.insights/metricDefinitions?metricnamespace=nginx%20connections%20statistics&api-version=2024-02-01"
   ```

   The following JSON shows an example response body:

   ```json
   {
     "value": [
   	...
       {
         "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/microsoft.insights/metricdefinitions/Nginx Connections Statistics/nginx.conn.current",
         "resourceId": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-deployment",
         "namespace": "NGINX Connections Statistics",
         "name": {
           "value": "nginx.conn.current",
           "localizedValue": "nginx.conn.current"
         },
         ...
       },
   	...
     ]
   }
   ```

3. **Metric values:** Finally, you can obtain the actual metric values which represent real-time or historical data points that tell you how your NGINXaaS is performing. The following `curl` example shows how to retrieve the value of metric `nginx.conn.current` within the `nginx connections statistics` namespace over a 10-minute time window averaged over 5 minute intervals:

   ```bash
   curl --request GET --header "Authorization: Bearer $TOKEN" "https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/microsoft.insights/metrics?metricnamespace=nginx%20connections%20statistics&metricnames=nginx.conn.current&timespan=2024-03-27T20:00:00Z/2024-03-27T20:10:00Z&aggregation=Average&interval=PT5M&api-version=2024-02-01"
   ```

   The following JSON shows an example response body:

   ```json
   {
     "cost": 9,
     "timespan": "2024-03-27T20:00:00Z/2024-03-27T20:10:00Z",
     "interval": "PT5M",
     "value": [
       {
         "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/my-nginx-rg/providers/NGINX.NGINXPLUS/nginxDeployments/my-nginx-dep/providers/Microsoft.Insights/metrics/nginx.conn.current",
         "type": "Microsoft.Insights/metrics",
         "name": {
           "value": "nginx.conn.current",
           "localizedValue": "nginx.conn.current"
         },
         "unit": "Unspecified",
         "timeseries": [
           {
             "metadatavalues": [],
             "data": [
               {
                 "timeStamp": "2024-03-27T20:00:00Z",
                 "average": 4
               },
               {
                 "timeStamp": "2024-03-27T20:05:00Z",
                 "average": 4
               }
             ]
           }
         ],
         "errorCode": "Success"
       }
     ],
     "namespace": "nginx connections statistics",
     "resourceregion": "eastus2"
   }
   ```

{{<note>}} Refer to the [Metrics Catalog]({{< relref "/nginxaas-azure/monitoring/metrics-catalog.md" >}}) for a listing of available namespaces and metrics.{{</note>}}
