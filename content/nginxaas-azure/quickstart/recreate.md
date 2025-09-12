---
title: Recreating a deployment
weight: 500
toc: true
nd-docs: DOCS-1378
url: /nginxaas/azure/quickstart/recreate/
type:
- how-to
---

Learn how to recreate an existing F5 NGINXaaS for Azure (NGINXaaS) deployment using an Azure Resource Manager (ARM) template.

There are two ways to replicate a current NGINXaaS for Azure deployment using ARM templates. You can either delete and recreate the deployment, or you can update the DNS to smoothly transition to the new deployment.

## Prerequisites

- [Azure CLI Installation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- You need to be logged in to your Azure account through the CLI if you are using that for template deployment, see [Azure CLI Authentication](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)

## Export ARM template from existing deployment

To export an ARM template for an existing deployment:

1. Navigate to your existing NGINXaaS deployment.
1. Select **Export template** under **Automation** in the left menu.
1. Wait for the template to generate.
1. Select **Download**.

## Delete and recreate strategy

The simplest method to recreate a deployment is to delete the original deployment and then recreate it using the ARM template.

The ARM template generated through the portal will include the VNET and public IP address used by the original deployment as dependencies. If you plan to change these with the new deployment these entries need to be modified in the template.

To recreate the deployment:

1. Export the template as instructed above.
1. Modify, if neccessary, and verify the data in the template for accuracy.
1. Delete the original deployment.
1. Use the exported ARM template to recreate the deployment using the Azure CLI:

```shell
az deployment group create \
    --subscription=<deployment subscription ID> \
    --resource-group=<resource group name> \
    --template-file=<path to template file>
```

## DNS migration strategy

If you control the DNS associated with the deployment's frontend and have flexibility of the IP address NGINXaaS uses you can recreate a deployment with no downtime.

1. Export the template, as instructed above.
1. If you're using a public IP, create a new public IP resource. If you're using a private IP address, select a new IP address from your VNET.
1. Modify the ARM template to change the NGINXaaS deployment name and reference the new IP address.
1. Use the Azure CLI as above to create a new deployment.
1. Update DNS to refer to the new deployment's IP address.
1. Monitor metrics of the old deployment to watch for requests dropping off as clients use the new IP address from DNS.  Note that depending on your DNS settings this could take from a few minutes to a few days.
1. Delete the old deployment.

Remember to change your configuration on any firewall or Network Security Group associated with the deployment to allow access to your deployment's new IP address.

## Further reading

See the [Azure CLI Deployment Create](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment#az-nginx-deployment-create) documentation for example commands to create deployment resources.

You can find example code to manage NGINXaaS deployments and related objects in the NGINXaaS GitHub repository, [NGINXaaS Snippets](https://github.com/nginxinc/nginxaas-for-azure-snippets).
