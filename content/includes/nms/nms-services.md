The following table lists the services that are installed with NGINX Management Suite. The "Platform" services are installed with Instance Manager, which is the foundation for the NGINX Management Suite platform.

{{<bootstrap-table "table table-striped table-bordered">}}

| Service                | <div style="width:200px">Used By</div> | Description                                                                                                                                                                                                                                          |
|------------------------|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| nms                    | Platform                               | A pseudo service used to start the other `nms-*` services.                                                                                                                                                                                           |
| nms-core               | Platform                               | The core service configures and sets up the management plane, as well as performs data analysis for metrics, events, and alerts.                                                                                                                     |
| nms-dpm                | Platform                               | The data plane manager (DPM) service is responsible for configuring NGINX instances on the data plane, monitoring the state of data plane resources, and generating reports and event messages.                                                      |
| nms-ingestion          | Platform                               | The ingestion service collects metrics, security violations, and events not sent to the data plane manager service by the NGINX Agent. This information can be forwarded to external data stores.                                                    |
| nms&#8209;integrations | Platform                               | The integrations process includes features for interacting with external components, like configuring [NGINX App Protect WAF policies]({{< relref "/nim/app-protect/setup-waf-config-management.md" >}}), managing threat campaigns, and more. |
| nms-acm                | API&nbsp;Connectivity Manager          | The API Connectivity Manager service.                                                                                                                                                                                                                |

{{</bootstrap-table>}}

<br>

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1059 -->
