---
description: Learn how to deploy an Azure NGINX instance using F5 NGINX Controller.
nd-docs: DOCS-769
title: Add an Azure NGINX Instance
toc: true
weight: 35
type:
- tutorial
---

## Overview



You can use F5 NGINX Controller to deploy and manage NGINX instances on [Microsoft Azure](https://azure.microsoft.com/en-us/).

This tutorial explains how to deploy NGINX Plus on Azure by defining an Azure Integration, a Location, and an Instance Template in NGINX Controller.

{{< important >}}

You are responsible for applying software and security updates on your NGINX instances. NGINX Controller does not manage these updates for you.

{{< /important >}}

&nbsp;


---

## Before You Begin



Before you can create an Azure Integration in NGINX Controller, you need to register an app in Azure and create a client secret. You'll need to copy and save the following information to use when creating an Azure Integration:

- Application (client) ID
- Directory (tenant) ID
- Client secret value

### Register an App in the Azure Portal

To register an app in Azure, take the following steps:

1. Sign in to the [Microsoft Azure Portal](https://portal.azure.com/#home).
2. Search for and select **Microsoft Entra**.
3. Under **Manage**, select **App registrations > New registration**.
4. Type a name to use for the app.
5. Specify who can see the app.
6. Select **Register**. The overview page for the app is displayed.
7. On the app overview page, copy and save the following information:

    - **Application (client) ID**
    - **Directory (tenant) ID**

### Add a Client Secret

To add a client secret to your app registration:

1. Select your application in **App registrations** in the Azure portal.
1. Select **Certificates & secrets > New client secret**.
1. Add a description for your client secret.
1. Select a duration.
1. Select **Add**.
1. Copy and save the **secret's value** for use when creating an Azure Integration in NGINX Controller -- this value is **never displayed again** after leaving this page.

&nbsp;


---

## Create an Azure Integration



Integrations give NGINX Controller permission to deploy and manage NGINX instances on external systems, such as cloud providers like Azure.

To create an Integration for Azure using the [NGINX Controller API]({{< ref "/controller/api/_index.md" >}}), send a POST request similar to the following example to the Integrations API endpoint.

In the JSON request, provide the `clientID`, `tenantID`, and `clientSecret` that you copied and saved when you [registered an app with Azure](#before-you-begin).

```json
{
  "metadata": {
    "name": "azure"
  },
  "desiredState": {
    "credential": {
      "type": "AZURE_SERVICE_PRINCIPAL",
      "clientID": "...",
      "clientSecret": "...",
      "tenantID": "..."
    },
    "type": "AZURE_INTEGRATION"
  }
}
```

&nbsp;


---

## Create a Location



After you've [created an Integration for Azure](#create-an-azure-integration), take the following steps to create a Location. Locations are a way to logically group your NGINX Plus instances by their physical locations. The Location you define in NGINX Controller corresponds to the Azure location that your resource group is running in.

### Prerequisites

To create a Location, you'll need your Azure resource group name, region, and subscription ID. To gather this information:

1. Sign in to the [Microsoft Azure Portal](https://portal.azure.com/#home).
2. Search for and select **Resource groups**.
3. Select the name of your resource group. Make a note of this name to use for later.
4. Under **Essentials**, copy and save the following information:

   - Subscription ID
   - Location

### Create a Location by using the REST API

To create a Location using the [NGINX Controller API]({{< ref "/controller/api/_index.md" >}}), send a POST request similar to the following example to the Locations API endpoint.

In the JSON request, provide the `resourceGroup` name, `region`, and `subscriptionID` that you copied and saved in the previous steps.

```json
{
  "metadata": {
    "name": "washington",
    "tags": []
  },
  "desiredState": {
    "type": "AZURE_LOCATION",
    "integrationRef": {
      "ref": "/platform/integrations/azure"
    },
    "resourceGroup": "...",
    "region": "...",
    "subscriptionID": "..."
  }
}
```

&nbsp;


---

## Create an Instance Template for Azure NGINX Instances



An [Instance Template]({{< ref "/controller/infrastructure/instances/manage-instance-templates.md" >}}) defines the parameters to use when creating an NGINX instance. Instance Templates are ideal for cloud orchestration and make managing your cloud resources easy and quick.

For the Instance Template, you can provide the details for an NGINX image on the Azure Marketplace, or you can provide the image and network details for your own instance. Refer to the [NGINX Controller Technical Specifications]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}) guide for the NGINX Plus requirements.

- To create an Instance Template for an Azure Marketplace image using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a POST request similar to the following example to the Instance Templates API endpoint. You can find descriptions of the instance parameters in the API Reference documentation.

  {{< tip >}}To look up the image details — `publisher`, `offer`, `sku`, and `version` — that you'll need to define the Instance Template, you can attempt to deploy an NGINX instance from the [Azure Marketplace](https://azure.microsoft.com/en-us/marketplace/) and look at the template that Azure creates to get the image details.
  {{</ tip >}}

  &nbsp;

  ```json
  {
    "metadata": {
      "name": "us-west-azure"
    },
    "desiredState": {
      "type": "AZURE_INSTANCE_TEMPLATE",
      "image": {
        "type": "AZURE_IMAGE_REFERENCE",
        "publisher": "nginxinc",
        "offer": "nginx-plus-v1",
        "sku": "nginx-plus-ub1804",
        "version": "latest"
      },
      "instanceType": "Standard_A1",
      "adminUser": "azureuser",
      "publicKey": "<the complete ssh-rsa string>",
      "networkInterface": {
        "type": "AZURE_NIC_CONFIG",
        "name": "",
        "virtualNetwork": "",
        "subnet": "default",
        "securityGroup": "",
        "publicIpName": ""
      }
    }
  }
  ```

- To create an Azure Instance Template for your own instance using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}, send a POST request similar to the following example to the Instance Templates API endpoint.

    ```json
    {
      "metadata": {
      "name": "my-azure-template-for-standard-A1",
      },
      "desiredState": {
        "type": "AZURE_INSTANCE_TEMPLATE",
        "image": {
          "type": "AZURE_IMAGE_ID",
          "imageID": "<the resource ID for the Azure image>"
        },
        "instanceType": "Standard_A1",
        "adminUser": "azureuser",
        "publicKey": "<the complete ssh-rsa string>",
        "networkInterface": {
          "type": "AZURE_NIC_ID",
          "nicID": "<the ID for the Azure network interface>"
        }
      }
    }
    ```

&nbsp;


---

## Add an Azure NGINX Instance to NGINX Controller



Now that you've [defined a Location](#create-a-location) and [made an Instance Template](#create-an-instance-template-for-azure-nginx-instances) for an  NGINX instance on Azure, you're ready to add the instance to  NGINX Controller.

To add an Azure NGINX instance to NGINX Controller using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a POST request similar to the following example to the Instances API endpoint. For the `templateRef` parameter, use the Instance Template that you created in the previous procedure.

```json
{
  "metadata": {
    "name": "azure1"
  },
  "desiredState": {
    "type": "AZURE_INSTANCE",
    "templateRef": {
      "ref": "/infrastructure/locations/washington/instance-templates/us-west-azure"
    }
  }
}
```

&nbsp;


---

## What's Next

- [Manage Your NGINX Instances]({{< ref "/controller/infrastructure/instances/manage-instances.md#add-an-existing-instance" >}})
- [Add, Edit, and Update Locations]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}})
- [View Performance Reports for Your Instances]({{< ref "/controller/infrastructure/instances/analyzer.md" >}})
- [Deploy an App]({{< ref "/controller/app-delivery/deploy-simple-app.md" >}})

{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
