---
nd-docs: "DOCS-000"
---

If the diagnostic setting destination details included a storage account, logs show up in the storage container "insights-logs-nginxlogs" with the following format: `resourceID=/<NGINXaaS-resourceID>/y=<YYYY>/m=<MM>/d=<DD>/h=<HH>/PT1H.json`

{{<bootstrap-table "table table-striped table-bordered">}}
| **Attribute**               | **Description** |
|-----------------------------|-----------------|
| `<NGINXaaS-resourceID>`     | The resourceID of the NGINXaaS deployment in upper case.|
| `<YYYY>`                    | The four-digit year when the log batch was generated.|
| `<MM>`                      | The two-digit month when the log batch was generated.|
| `<DD>`                      | The two-digit day when the log batch was generated.|
| `<HH>`                      | The two-digit hour value that indicates the starting hour for the log batch, in 24 hour UTC format|
{{</bootstrap-table>}}

{{<note>}}It can take up to 90 minutes after adding diagnostic settings for logs to appear in the provided Azure Storage container.{{</note>}}

Each log event in the "PT1H.json" file is written in a new line delimited JSON text format. The properties that show up in each log line are described in the [Top Level Common Schema](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-schema#top-level-common-schema) documentation.

For instance, an access log event logging to a particular file path will have attributes similar to this example:

```yaml
{
	"category": "NginxLogs",
	"location": "westcentralus",
	"operationName": "NGINX.NGINXPLUS/NGINXDEPLOYMENTS/LOG",
	"properties": {
		"message": "172.92.129.50 - \"-\" [18/Jan/2024:17:59:00 +0000] \"GET / HTTP/1.1\" 200 11232 \"-\" \"curl/8.4.0\" \"-\" \"20.69.58.179\" sn=\"localhost\" rt=0.000 ua=\"-\" us=\"-\" ut=\"-\" ul=\"-\" cs=\"-\" ",
		"filePath": "/var/log/nginx/access.log"
	},
	"resourceId": "/SUBSCRIPTIONS/FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF/RESOURCEGROUPS/RESOURCEGROUP1/PROVIDERS/NGINX.NGINXPLUS/NGINXDEPLOYMENTS/TEST1",
	"time": "2024-01-18T17:59:00.363956795Z"
}
```

If [syslog-based](#logging-to-syslog) logs are used, the log event entry has different **properties** sub-fields:

```yaml
#...
"properties": {
		"message": "172.92.129.50 - - [16/Jan/2024:18:00:00 +0000] \"GET / HTTP/1.1\" 200 11232 \"-\" \"curl/8.4.0\"",
		"tag": "nginx",
		"severity": "info",
		"facility": "local7"
	},
#...
```
