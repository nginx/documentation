---
title: Assign Managed Identities
weight: 300
toc: true
nd-docs: DOCS-872
url: /nginxaas/azure/getting-started/managed-identity-portal/
nd-content-type: how-to
nd-product: NAZURE
---

## Overview

F5 NGINXaaS for Azure (NGINXaaS) leverages managed identities for its integrations with Azure services.

Managed identities are used for the following integrations:

- Azure Key Vault (AKV): fetch SSL/TLS certificates from AKV to your NGINXaaS deployment, so that they can be referenced by your NGINX configuration.
- Azure Monitor: publish metrics from your NGINX deployment to Azure Monitor.
- Azure Storage: export logs from your NGINX deployment to Azure Blob Storage Container.

## Prerequisites

- A user assigned managed identity (optional, for additional integrations). If you are unfamiliar with managed identities for Azure resources, refer to the [Managed Identity documentation](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) from Microsoft.

- Owner access on the resource group or subscription to assign the managed identity to the NGINX deployment.

## Adding a user assigned managed identity

1. Go to your NGINXaaS for Azure deployment.

2. Select **Identity** in the left menu, select the **User Assigned** tab, and select **Add**.

3. Select the appropriate **subscription** and **user assigned managed identity**, then select **Add**.

<br>
   {{< call-out "note" >}}NGINXaaS supports adding one user assigned managed identity in addition to the required system assigned managed identity. Adding more than one user assigned managed identity is not supported.{{< /call-out >}}

4. The added user assigned managed identity will show up in the main table.

## Removing a user assigned managed identity

1. Select the managed identity you want to remove from the list and then select **Remove**.

2. Confirm the operation by selecting **Yes** on the confirmation prompt.

{{< call-out "note" >}}Removing a user-assigned managed identity from an NGINX deployment will only cause issues if that specific user-assigned identity was being used to fetch certificates from Azure Key Vault. In such cases, updates to the deployment will fail until the configuration is updated to not use those certificates.{{< /call-out >}}


## System assigned managed identity

The system-assigned managed identity is required for all NGINXaaS deployments. When creating deployments through the Azure Portal, this identity is automatically created. For deployments created using other methods (such as ARM templates, Bicep, or Terraform), you must explicitly create the system-assigned managed identity. Once created, it cannot be removed.

### Viewing and Managing the system assigned managed identity

1. Go to your NGINXaaS for Azure deployment.

2. Select **Identity** in the left menu, select the **System Assigned** tab to view the system-assigned managed identity details.

3. The system assigned managed identity will be shown as enabled with Status **On**.

{{< call-out "note" >}}The system-assigned managed identity cannot be disabled or removed. Attempting to toggle the status to "Off" will result in an error.{{< /call-out >}}

### Add a system-assigned managed identity

{{< call-out "note" >}}This section applies only to legacy deployments created before system-assigned managed identity became mandatory. New deployments already have this identity enabled.{{< /call-out >}}

To add a system-assigned managed identity to an existing deployment:

1. Go to your NGINXaaS for Azure deployment.

2. Select **Identity** in the left menu, then select the **System Assigned** tab.

3. Toggle the **Status** to **On**.

4. Select **Save** to apply the changes.

#### Managing role assignments

To provide the role assignments necessary for the deployment:

1. Select **Azure Role Assignments** under Permissions on the System Assigned tab.

2. Select **Add Role Assignments**

3. On the **Add role assignment (Preview)** panel, select the appropriate **Scope** and **Role**. Then select **Save**.

## Legacy deployments without system assigned managed identity
{{< call-out "note" >}}**Legacy Deployments**: Deployments created before system-assigned managed identity became mandatory will continue to operate normally and can still be updated (including deployment properties and NGINX configurations). However, logging and monitoring features will not work. You can add a system-assigned managed identity to these deployments by navigating to the Identity page and enabling it under the System Assigned tab.{{< /call-out >}}




## Checking for deployments without system assigned managed identity

Use the following Azure Resource Graph query to identify NGINXaaS deployments that do not have a system-assigned managed identity.


{{< details summary="Azure Resource Graph Query" >}}

You can run this query in the Azure Portal by navigating to **Azure Resource Graph Explorer** or by using the search bar and typing "Resource Graph Explorer".

```
Resources
| where type == "nginx.nginxplus/nginxdeployments"
| where isnull(identity) or identity.type !has "SystemAssigned"
| project name, location, type, id, identity
```

The query lists the name, location, resource type, resource ID, and current identity configuration of the NGINXaaS deployments that do not have a system assigned managed identity.

{{< /details >}}

## What's next

[Add SSL/TLS Certificates]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}})
