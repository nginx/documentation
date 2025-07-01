---
nd-docs: "DOCS-000"
---

If the diagnostic setting destination details included a Logs Analytics workspace, logs show up in the table "NGXOperationLogs" with the following non-standard attributes:

{{<bootstrap-table "table table-striped table-bordered">}}
| **Attribute**               | **Description** |
|-----------------------------|-----------------|
| **Location**                  | The location of the NGINXaaS resource.|
| **Message**                 | The generated NGINX log line. |
| **FilePath**                 | The path to which NGINX logs were configured to be logged to if the nginx config used file-based logs. |
| **Tag**                 | The tag with which NGINX logs were generated if syslog-based log configuration is used. By default this is nginx |
| **Facility**                 | The syslog facility with which NGINX logs were generated if syslog-based log configuration is used. |
| **Severity**                | The syslog severity with which NGINX logs were generated if syslog-based log configuration is used. |

{{</bootstrap-table>}}

Using a [KQL](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/), a custom query can be run to view the logs:

```
NGXOperationLogs
| where Location contains "eastus"
```

For more information on the standard attributes that appear in Logs Analytics,see the [Standard columns in Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-standard-columns) documentation.

For more information on using [KQL](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/) see [Queries in Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/queries?tabs=groupby).

{{<note>}}It can take up to 90 minutes after adding diagnostic settings for logs to appear in the provided Logs Analytics Workspace.{{</note>}}
