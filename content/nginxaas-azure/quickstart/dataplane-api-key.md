---
title: Create NGINXaaS Dataplane API Key
weight: 50
toc: true
url: /nginxaas/azure/quickstart/dataplane-api-key/
nd-content-type: how-to
nd-product: NAZURE
---

## Overview

The NGINXaaS dataplane API key is used to authenticate with your NGINXaaS deployment's dataplane API. This key is required for various integrations including VMSS backend synchronization and Kubernetes load balancing.

## Requirements

{{< call-out "note" >}}
The data plane API key has the following requirements:

- The key should have an expiration date. The default expiration date is six months from the date of creation. The expiration date cannot be longer than two years from the date of creation.
- The key should be at least 12 characters long.
- The key requires three out of four of the following types of characters:
  - lowercase characters.
  - uppercase characters.
  - symbols.
  - numbers.

A good example of an API key that will satisfy the requirements is UUIDv4.
{{< /call-out >}}

## Create the API Key

The data plane API key can be created using the Azure CLI or portal.

### Create an NGINXaaS data plane API key using the Azure portal

1. Go to your NGINXaaS for Azure deployment.
2. Select **NGINXaaS Loadbalancer for Kubernetes** on the left blade.
3. Select **New API Key**.
4. Provide a name for the new API key in the right panel, and select an expiration date.
5. Select the **Add API Key** button.
6. Copy the value of the new API key.

{{< call-out "note" >}}
Make sure to write down the key value in a safe location after creation, as you cannot retrieve it again. If you lose the generated value, delete the existing key and create a new one.
{{< /call-out >}}

### Create an NGINXaaS data plane API key using the Azure CLI

Set shell variables about the name of the NGINXaaS you've already created:

```bash
## Customize this to provide the details about my already created NGINXaaS deployment
nginxName=myNginx
nginxGroup=myNginxGroup
```

Generate a new random data plane API key:

```bash
# Generate a new random key or specify a value for it.
keyName=myKey
keyValue=$(uuidgen --random)
```

Create the key for your NGINXaaS deployment:

```bash
az nginx deployment api-key create --name $keyName --secret-text $keyValue --deployment-name $nginxName --resource-group $nginxGroup
```

## Get the Dataplane API Endpoint

The data plane API endpoint can be retrieved using the Azure CLI or portal.

### View NGINXaaS data plane API endpoint using the Azure portal

1. Go to your NGINXaaS for Azure deployment.
2. Select **NGINXaaS Loadbalancer for Kubernetes** on the left blade.
3. The data plane API endpoint associated with the deployment is available at the top of the screen.

### View NGINXaaS data plane API endpoint using the Azure CLI

```bash
dataplaneAPIEndpoint=$(az nginx deployment show -g "$nginxGroup" -n "$nginxName" --query properties.dataplaneApiEndpoint -o tsv)
```

## Next Steps

Once you have created the dataplane API key and obtained the endpoint, you can use them in various NGINXaaS integrations:

- [VMSS Backend Integration]({{< ref "/nginxaas-azure/vmss-backend/" >}})
- [Load Balancer for Kubernetes]({{< ref "/nginxaas-azure/loadbalancer-kubernetes/" >}})