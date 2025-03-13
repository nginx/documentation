---
title: Azure Resource Manager templates
weight: 100
description: Learn how to use Azure Resource Manager (ARM) JSON and Bicep templates
  to manage NGINXaaS for Azure.
toc: true
docs: DOCS-1097
url: /nginxaas/azure/client-tools/templates/
type: []
---

F5 NGINX as a Service for Azure (NGINXaaS) deployments can be managed using the ARM API or the Azure CLI with ARM template deployments using JSON or Bicep formats. These deployments can be made locally or in a continuous integration pipeline. This document outlines common workflows using the ARM API. You can find example code to manage NGINXaaS deployments and related objects in the NGINXaaS GitHub repository, [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets).

## Prerequisites

- [NGINXaaS Prerequisites]({{< relref "/nginxaas-azure/getting-started/prerequisites.md" >}})
- [Azure CLI Installation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- You need to be logged in to your Azure account through the CLI if you are using that for template deployment, see [Azure CLI Authentication](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
- See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/arm-templates/deployments/prerequisites) for an example template to create the prerequisite resources.

## Workflows

### Create or update a deployment

See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/arm-templates/deployments/create-or-update) for an example template to create or update deployment resources.

- [NGINXaaS Managed Identity Documentation]({{< relref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}})
- [NGINXaaS Azure Monitor Documentation]({{< relref "/nginxaas-azure/monitoring/enable-monitoring.md" >}})

### Create or update a certificate

Create or update a certificate under a deployment. This references an existing certificate in an Azure Key Vault and makes it available to the NGINX configuration. See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/arm-templates/certificates/create-or-update) for an example template to create or update certificate resources.

- [NGINXaaS Certificates Documentation]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}})
- [ARM Template Key Vault Documentation](https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults)

### Create or update a configuration

Create or update the default configuration for a deployment using a gzipped archive based on the NGINXaaS documentation below. See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/arm-templates/configuration) for an example template to create or update configuration resources.

- [NGINXaaS GZIP Configuration Documentation]({{< relref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#upload-gzip-nginx-configuration" >}})

## Additional Docs

If you are new to Azure Resource Manager templates, see:

- [Azure JSON Templates Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)
- [Azure Bicep Templates Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)
