---
title: Terraform
weight: 400
description: Learn how to use the Terraform to manage NGINXaaS for Azure.
toc: true
docs: DOCS-1472
draft: true
url: /nginxaas/azure/client-tools/terraform/
type: []
---

F5 NGINX as a Service for Azure (NGINXaaS) deployments can be managed using Terraform. This document outlines common Terraform workflows for NGINXaaS.

## Prerequisites

- [NGINXaaS Prerequisites]({{< relref "/nginxaas-azure/getting-started/prerequisites.md" >}})
- [Authenticate Terraform to Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure)
- [Install Terraform](https://developer.hashicorp.com/terraform/downloads)

## Workflows

### Create or update a deployment

See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/terraform/deployments/create-or-update) for an example to create or update deployment resources.

- [NGINXaaS Managed Identity Documentation]({{< relref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}})
- [NGINXaaS Azure Monitor Documentation]({{< relref "/nginxaas-azure/monitoring/enable-monitoring.md" >}})

### Create or update a certificate

Upload a self-signed certificate created in Azure Key Vault to a deployment. See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/terraform/certificates) for an example to create or update certificate resources.

- [NGINXaaS Certificates Documentation]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}})

### Create or update a configuration

Upload an example multi-file NGINX configuration to a deployment. See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/terraform/configurations) for an example to create or update configurations resources.

- [NGINXaaS Configuration Documentation]({{< relref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}})

## Additional Docs

- [Managing an NGINXaaS for Azure deployment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nginx_deployment)
- [Managing an NGINXaaS for Azure deployment configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nginx_configuration)
- [Managing an NGINXaaS for Azure deployment certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nginx_certificate)
- If you are new to Terraform, see [Terraform Overview](https://www.terraform.io/)
