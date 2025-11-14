---
title: Change from basic plan to standard plan
weight: 200
toc: false
url: /nginxaas/azure/change-plan/basic-to-standard/
type:
- how-to
---

The basic plan is designed for early-stage trials and testing and is not intended for production use. If you are ready to create a standard plan deployment and wish to preserve the configuration of an existing basic plan deployment, you can [create a new deployment]({{< ref "/nginxaas-azure/getting-started/create-deployment.md">}}), selecting the latest standard pricing plan, and manually reapply your NGINX configuration and certificates. You can also follow the instructions below to recreate your deployment using an Azure Resource Manager (ARM) template.

## Prerequisites

- [Azure CLI Installation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- You must be logged in to your Azure account through the CLI. See [Azure CLI Authentication](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)

## Recreate deployment using ARM template

To export an ARM template for an existing deployment:

1. Go to your existing NGINXaaS deployment.
1. Select **Export template** under **Automation** in the left menu.
1. Wait for the template to generate.
1. Select **Download**.
1. Decompress the template archive.
1. Open the `template.json` file and verify that the data in the template is correct. 
1. In the `resources` section, change `sku.name` to `standardv2_Monthly`. This recreates the deployment as a standard plan deployment.
1. Delete the original basic plan deployment.
1. On the command line, run:

```shell
az deployment group create \
    --subscription=<deployment subscription ID> \
    --resource-group=<resource group name> \
    --template-file=</path/to/template.json>
```

## Further reading

For further details on recreating a deployment, see our [guide]({{< ref "/nginxaas-azure/quickstart/recreate.md">}}).
