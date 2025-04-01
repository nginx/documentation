---
docs: DOCS-1186
---

{{<bootstrap-table "table table-striped table-bordered">}}

| <div style="width:200px">Service</div> | Description                                                                                                                                                                                                                                          |
|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Core                                   | The core service configures and sets up the management plane, as well as performs data analysis for metrics, events, and alerts.                                                                                                                     |
| Data Plane Manager (DPM)               | The data plane manager (DPM) service is responsible for configuring NGINX instances on the data plane, monitoring the state of data plane resources, and generating reports and event messages.                                                      |
| Ingestion                              | The ingestion service collects metrics, security violations, and events that are not sent to the data plane manager service by the NGINX Agent. This information can be forwarded to external data stores.                                                    |
| Integrations                           | The integrations process includes features for interacting with external components, like configuring [NGINX App Protect WAF policies]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md" >}}), managing threat campaigns, and more. |

{{< /bootstrap-table >}}
