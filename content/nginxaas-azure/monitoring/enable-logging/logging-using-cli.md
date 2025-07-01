---
title: Enable NGINX logs using CLI
weight: 100
toc: true
nd-docs: DOCS-1369
url: /nginxaas/azure/monitoring/enable-logging/logging-using-cli/
type:
- how-to
---

## Overview

F5 NGINX as a Service for Azure (NGINXaaS) supports integrating Azure Diagnostic Settings to collect NGINX error and access logs.

{{<caution>}}
Enabling logs using the **NGINX Logs** blade on your NGINXaaS deployment is now deprecated. This feature will be removed in an upcoming update. If you have issues accessing your NGINX logs using the deprecated method, please follow the steps in this guide to access your NGINX logs.
{{</caution>}}

## Configuring NGINX logs collection using diagnostic settings

### Prerequisites

- A valid NGINX configuration with log directives enabled. NGINX logs can be configured using [error_log](#setting-up-error-logs) and [access_log](#setting-up-access-logs) directives.

- A system-assigned managed identity.
{{<note>}}The system-assigned managed identity does not need any role assignments to enable the logging functionality described in this section. You will need to make sure that the managed identity has the appropriate role assignments to access other resources that it is attached to (for example, certificates stored in Azure Key Vault).
{{</note>}}

- User must be an owner or user access administrator for the NGINX deployment resource.

 ### Adding diagnostic settings

Diagnostic settings for the NGINXaaS deployment resource can be managed using the Azure monitor diagnostic settings [commands](https://learn.microsoft.com/en-us/cli/azure/monitor/diagnostic-settings?view=azure-cli-latest).

To add diagnostic settings to export NGINX logs to a storage account for an NGINXaaS deployment, the following command can be used:
```shell
 az monitor diagnostic-settings create --resource <nginxaas_resource_id> --logs "[{category:NginxLogs,enabled:true,retention-policy:{enabled:false,days:0}}]" --name <diagnostic_setting_name> --storage-account <storage_account_name>
```

{{<note>}}Due to limitations imposed by Azure, if the destination chosen is an Azure Storage account, the resource has to be in the same region as the NGINXaaS deployment resource.
{{</note>}}

To use a logs analytics workspace as the export destination, use the following command:
```shell
 az monitor diagnostic-settings create --resource <nginxaas_resource_id> --logs "[{category:NginxLogs,enabled:true,retention-policy:{enabled:false,days:0}}]" --name <diagnostic_setting_name> --workspace <logs_analytics_workspace_name>

```

To view the supported log categories for an NGINXaaS resource, use the following command:
```shell
az monitor diagnostic-settings list --resource <nginxaas_resource_id>
```

As NGINXaaS logs are stored in your storage, you can define the retention policy most appropriate for your needs.

### Analyzing NGINX logs in Azure Storage

{{< include "/nginxaas-azure/logging-analysis-azure-storage.md" >}}

### Analyzing NGINX logs in Azure Log Analytics workspaces

{{< include "/nginxaas-azure/logging-analysis-logs-analytics.md" >}}

## Setting up error logs

{{< include "/nginxaas-azure/logging-config-error-logs.md" >}}

## Setting up access logs

{{< include "/nginxaas-azure/logging-config-access-logs.md" >}}

## Limitations

{{< include "/nginxaas-azure/logging-limitations.md" >}}
