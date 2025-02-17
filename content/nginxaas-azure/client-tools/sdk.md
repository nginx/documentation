---
title: "Azure SDK"
weight: 300
description: "Learn how to use the Python Azure Management SDK to manage NGINXaaS for Azure deployments."
categories: ["platform-management"]
toc: true
docs: "DOCS-1095"
url: /nginxaas/azure/client-tools/sdk/
---

F5 NGINX as a Service for Azure (NGINXaaS) deployments can be managed using the multi-language SDK. This document outlines common workflows using the Python SDK. You can find example code to manage NGINXaaS deployments and related objects in the NGINXaaS GitHub repository, [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/sdk/python/).

## Prerequisites

- [NGINXaaS Prerequisites]({{< relref "/nginxaas-azure/getting-started/prerequisites.md" >}})
- Install Azure Identity package - [azure-identity](https://pypi.org/project/azure-identity/)
- Install the NGINX SDK - [azure-mgmt-nginx](https://pypi.org/project/azure-mgmt-nginx/)
- See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/sdk/python/deployments/) for an example script to create prerequisite resources.

## Workflows

- For a complete list of NGINXaaS SDK documentation, see the [Azure NGINXaaS SDK Documentation](https://learn.microsoft.com/en-us/python/api/overview/azure/mgmt-nginx-readme)
- [Azure Authentication SDK Documentation](https://learn.microsoft.com/en-us/azure/developer/python/sdk/authentication-overview)

### Create or update a deployment

For example scripts to create or update deployment resources, see [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/sdk/python/deployments/)

- [Azure SDK Deployment Create or Update Documentation](https://learn.microsoft.com/en-us/python/api/azure-mgmt-nginx/azure.mgmt.nginx.operations.deploymentsoperations?view=azure-python#azure-mgmt-nginx-operations-deploymentsoperations-begin-create-or-update)
- [Azure SDK Deployment Delete Documentation](https://learn.microsoft.com/en-us/python/api/azure-mgmt-nginx/azure.mgmt.nginx.operations.deploymentsoperations?view=azure-python#azure-mgmt-nginx-operations-deploymentsoperations-begin-delete)
- [NGINXaaS Managed Identity Documentation]({{< relref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}})
- [NGINXaaS Azure Monitor Documentation]({{< relref "/nginxaas-azure/monitoring/enable-monitoring/" >}})

### Create or update a certificate

Create or update a certificate under a deployment. This references an existing certificate in an Azure Key Vault and makes it available to the NGINX configuration. See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/sdk/python/certificates/) for example scripts to create or update deployment certificate resources.

- [Azure SDK Certificate Create or Update Documentation](https://learn.microsoft.com/en-us/python/api/azure-mgmt-nginx/azure.mgmt.nginx.operations.certificatesoperations?view=azure-python#azure-mgmt-nginx-operations-certificatesoperations-begin-create-or-update)
- [Azure SDK Certificate Delete Documentation](https://learn.microsoft.com/en-us/python/api/azure-mgmt-nginx/azure.mgmt.nginx.operations.configurationsoperations?view=azure-python#azure-mgmt-nginx-operations-configurationsoperations-begin-delete)
- [NGINXaaS Certificates Documentation]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}})
- [Azure SDK Key Vault Documentation](https://learn.microsoft.com/en-us/python/api/overview/azure/key-vault)

### Create or update a configuration

Create or update the default configuration for a deployment using a gzipped archive based on the NGINXaaS documentation below. See [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/sdk/python/configurations/) for example scripts to create or update deployment configuration resources.

- [Azure SDK Configuration Create or Update Documentation](https://learn.microsoft.com/en-us/python/api/azure-mgmt-nginx/azure.mgmt.nginx.operations.configurationsoperations?view=azure-python#azure-mgmt-nginx-operations-configurationsoperations-begin-create-or-update)
- [NGINXaaS GZIP Configuration Documentation]({{< relref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#upload-gzip-nginx-configuration" >}})

## Additional Docs

- [Python Azure SDK Overview](https://learn.microsoft.com/en-us/python/api/overview/azure/nginx)
- [Java Azure SDK Overview](https://learn.microsoft.com/en-us/java/api/overview/azure/nginx)
- [JavaScript Azure SDK Overview](https://learn.microsoft.com/en-us/javascript/api/overview/azure/nginx)
- [Go Azure SDK Documentation](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/nginx/armnginx)
- [.NET Azure SDK Overview (Preview)](https://learn.microsoft.com/en-us/dotnet/api/overview/azure/nginx?view=azure-dotnet-preview)
