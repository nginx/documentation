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

## System assigned managed identity
The system-assigned managed identity is required for all NGINXaaS deployments. When creating deployments through the Azure Portal, this identity is automatically created. For deployments created using other methods (such as ARM templates, Bicep, or Terraform), you must explicitly create the system-assigned managed identity. Once created, it cannot be removed.

### Viewing the system assigned managed identity

1. Go to your NGINXaaS for Azure deployment.

2. Select **Identity** in the left menu, select the **System Assigned** tab to view the system-assigned managed identity details.

3. The system assigned managed identity will be shown as enabled with Status **On**.

{{< call-out "note" >}}The system-assigned managed identity cannot be disabled or removed. Attempting to toggle the status to "Off" will result in an error.{{< /call-out >}}

### Managing role assignments for system assigned managed identity

To provide the role assignments necessary for the deployment:

1. Select **Azure Role Assignments** under Permissions on the System Assigned tab.

2. Select **Add Role Assignments**

3. On the **Add role assignment (Preview)** panel, select the appropriate **Scope** and **Role**. Then select **Save**.

## Legacy deployments without system assigned managed identity
{{< call-out "note" >}}**Legacy Deployments**: Deployments created before system-assigned managed identity became mandatory will continue to operate normally and can still be updated (including deployment properties and NGINX configurations). However, logging and monitoring features will not work. You can add a system-assigned managed identity to these deployments by navigating to the Identity page and enabling it under the System Assigned tab.{{< /call-out >}}

{{< call-out "note" >}}Removing a user-assigned managed identity from an NGINX deployment has the following effects:

- If the NGINX deployment uses any SSL/TLS certificates from Azure Key Vault, then any updates to the deployment (including deployment properties, certificates, and configuration) will result in a failure. If the configuration is updated not to use any certificates, then those requests will succeed.

{{< /call-out >}}


## Checking for deployments without system assigned managed identity

Use the following bash script to identify NGINXaaS deployments that do not have a system-assigned managed identity:

{{< call-out "note" >}}Before running the script, ensure you are logged in to Azure CLI (`az login`) and have selected the appropriate subscription (`az account set --subscription <subscription-id>`).{{< /call-out >}}

```bash
#!/bin/bash

# Find NGINXaaS deployments without system-assigned managed identity
echo "Checking for NGINXaaS deployments without system-assigned managed identity..."
echo ""

# Get all NGINXaaS deployments
deployments=$(az resource list \
  --resource-type "NGINX.NGINXPLUS/nginxDeployments" \
  --query "[].id" -o tsv)

# Check each deployment for system-assigned identity
for deployment_id in $deployments; do
  identity_type=$(az nginx deployment show \
    --ids "$deployment_id" \
    --query "identity.type" -o tsv 2>/dev/null)

  # Check if identity type contains "SystemAssigned"
  if [[ ! "$identity_type" =~ "SystemAssigned" ]]; then
    echo "$deployment_id"
  fi
done

echo ""
echo "Done. Deployments listed above do not have a system-assigned managed identity."
```

The script will output the Azure resource IDs of any deployments that need to be updated with a system-assigned managed identity.

## What's next

[Add SSL/TLS Certificates]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}})
