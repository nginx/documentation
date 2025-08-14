---
title: Enable NGINX logs using Azure Portal
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/next/monitoring/enable-logging/logging-using-portal/
type:
- how-to
---


{{< call-out "warning">}}This page has not been updated yet. Currently it has the NGINXaaS for Azure content{{< /call-out >}}

## Overview

F5 NGINX as a Service for NEXCLOUD (NGINXaaS) supports integrating Azure Diagnostic Settings to collect NGINX error and access logs.

{{< call-out "caution"  >}}
Enabling logs using the **NGINX Logs** blade on your NGINXaaS deployment is now deprecated. This feature will be removed in an upcoming update. If you have issues accessing your NGINX logs using the deprecated method, please follow the steps in this guide to access your NGINX logs.
{{< /call-out >}}

## Configuring NGINX logs collection using diagnostic settings

### Prerequisites

- A valid NGINX configuration with log directives enabled. NGINX logs can be configured using [error_log](#setting-up-error-logs) and [access_log](#setting-up-access-logs) directives.

- A system-assigned managed identity.

{{< call-out "note" >}}The system-assigned managed identity does not need any role assignments to enable the logging functionality described in this section. You will need to make sure that the managed identity has the appropriate role assignments to access other resources that it is attached to (for example, certificates stored in Azure Key Vault).
{{< /call-out >}}

- User must be an owner or user access administrator for the NGINX deployment resource.

 ### Adding diagnostic settings

1. Go to your NGINXaaS for NEXCLOUD deployment.

1. Select **Diagnostic Settings** in the left menu.

1. Select **Add diagnostic setting**.

1. Choose the **NGINX Logs** option and complete the details on the form, including the **Diagnostic setting name**.

{{< call-out "note" >}}You will need to configure the system-assigned managed identity in order to see and select the **NGINX Logs** option.
{{< /call-out >}}

1. Select preferred **Destination details**.

   {{< img src="nginxaas-azure/diagnostic-settings.png" alt="Screenshot of the Diagnostic Settings configuration page" >}}

As NGINXaaS logs are stored in your storage, you can define the retention policy most appropriate for your needs.

For more information about diagnostic settings destinations, please see the [Diagnostic Settings Destinations](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings#destinations) documentation.

{{< call-out "note" >}}Due to limitations imposed by Azure, if the destination chosen is an Azure Storage account, the resource has to be in the same region as the NGINXaaS deployment resource.
{{< /call-out >}}

{{< call-out "note" >}}If you are a Terraform user, please refer to [examples](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/terraform/deployments/with-diagnostic-setting-logging) provided to setup diagnostic settings for your NGINXaaS deployment{{< /call-out >}}

### Analyzing NGINX logs in Azure Storage

{{< include "/nginxaas-next/logging-analysis-azure-storage.md" >}}

### Analyzing NGINX logs in Azure Log Analytics workspaces

{{< include "/nginxaas-next/logging-analysis-logs-analytics.md" >}}

### Disable NGINX logs collection

1. Go to your NGINXaaS for NEXCLOUD deployment.

1. Select **Diagnostic Settings** in the left menu.

1. Edit the previously added Diagnostic Settings.

1. Select **Delete**.

{{< call-out "note" >}}It can take up to 90 minutes after removing the diagnostic settings for logs to stop publishing to the diagnostic destinations.{{< /call-out >}}

## Setting up error logs

{{< include "/nginxaas-next/logging-config-error-logs.md" >}}

## Setting up access logs

{{< include "/nginxaas-next/logging-config-access-logs.md" >}}

## Limitations

{{< include "/nginxaas-next/logging-limitations.md" >}}
