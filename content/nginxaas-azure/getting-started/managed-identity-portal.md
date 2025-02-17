---
title: "Assign Managed Identities"
weight: 300
categories: ["tasks"]
toc: true
docs: "DOCS-872"
url: /nginxaas/azure/getting-started/managed-identity-portal/
---

## Overview

F5 NGINX as a Service for Azure (NGINXaaS) leverages a user assigned and a system assigned managed identity for some of its integrations with Azure, such as:

- Azure Key Vault (AKV): fetch SSL/TLS certificates from AKV to your NGINXaaS deployment, so that they can be referenced by your NGINX configuration.

- Azure Monitor: publish metrics from your NGINX deployment to Azure Monitor.

- Azure Storage: export logs from your NGINX deployment to Azure Blob Storage Container.

## Prerequisites

- A user assigned or a system assigned managed identity. If you are unfamiliar with managed identities for Azure resources, refer to the [Managed Identity documentation](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) from Microsoft.

- Owner access on the resource group or subscription to assign the managed identity to the NGINX deployment.

## Adding a user assigned managed identity

1. Go to your NGINXaaS for Azure deployment.

2. Select **Identity** in the left menu, select the **User Assigned** tab, and select **Add**.

3. Select the appropriate **subscription** and **user assigned managed identity**, then select **Add**.

<br>
   {{<note>}}NGINXaaS supports adding a system assigned managed identity and a user assigned managed identity. Adding more than one user assigned managed identity is not supported.{{</note>}}

4. The added user assigned managed identity will show up in the main table.

## Removing a user assigned managed identity

1. Select the managed identity you want to remove from the list and then select **Remove**.

2. Confirm the operation by selecting **Yes** on the confirmation prompt.

## Adding a system assigned managed identity

1. Go to your NGINXaaS for Azure deployment.

2. Select **Identity** in the left menu, select the **System Assigned** tab, and then toggle the Status to **On**.

3. Select **Save**.

3. To confirm the operation, select **Yes** on the confirmation prompt.

   {{<note>}}NGINXaaS supports using only one type of managed identity per deployment at a time. User assigned and system assigned identities cannot be present simultaneously.{{</note>}}

4. To provide the role assignments necessary for the deployment, Select **Azure Role Assignments** under Permissions.

5. Select **Add Role Assignments**

6. On the **Add role assignment (Preview)** panel, select the appropriate **Scope** and **Role**. Then select **Save**.

7. The system assigned managed identity will be shown as enabled on the main Identity page.

## Removing a system assigned managed identity

1. Select **Identity** in the left menu, then select the **System assigned** tab.

2. Toggle the Status to **Off** and select **Save**.

3. Confirm the operation by selecting **Yes** on the confirmation prompt.

{{<note>}}Removing a Managed Identity from an NGINX deployment has the following effects:

- If the NGINX deployment uses any SSL/TLS certificates, then any updates to the deployment (including deployment properties, certificates, and configuration) will result in a failure. If the configuration is updated not to use any certificates, then those requests will succeed.

- If publishing metrics is enabled for the NGINX deployment, then the metrics will no longer be published to Azure Monitor for this deployment until a Managed Identity is added.

- If logging is enabled for the NGINX deployment, then the logs will no longer be exported to the Azure Blob Storage Container for this deployment until a Managed Identity is added.{{</note>}}


## What's next

[Add SSL/TLS Certificates]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}})
