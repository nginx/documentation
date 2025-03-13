---
title: Enable NGINX logs using Terraform
weight: 100
toc: true
docs: DOCS-1369
url: /nginxaas/azure/monitoring/enable-logging/logging-using-terraform/
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

To setup diagnostic settings to enable logging to a storage account for your NGINXaaS deployment, please refer to [examples](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/terraform/deployments/with-diagnostic-setting-logging) provided.

Once the terraform configurations provided in the repository above are used, the following commands can be used to update the deployment.

```shell
terraform init
terraform plan -var="storage_account_resource_group=myresourcegroup" -var="storage_account_name=myaccountname" -out=plan.cache
terraform apply plan.cache
```

{{<note>}}Due to limitations imposed by Azure, if the destination chosen is an Azure Storage account, the resource has to be in the same region as the NGINXaaS deployment resource.
{{</note>}}

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
