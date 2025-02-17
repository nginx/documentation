---
title: "Deploy using the Azure portal"
weight: 100
categories: ["tasks"]
toc: true
docs: "DOCS-878"
url: /nginxaas/azure/getting-started/create-deployment/deploy-azure-portal/
---

## Overview

This guide explains how to deploy F5 NGINX as a Service for Azure (NGINXaaS) using [Microsoft Azure portal](https://azure.microsoft.com/en-us/get-started/azure-portal). The deployment process involves creating a new deployment, configuring the deployment, and testing the deployment.

## Find the NGINX as a Service for Azure offer in the Azure portal

You can start the NGINXaaS deployment process by visiting the [Create NGINXaaS](https://portal.azure.com/#create/f5-networks.f5-nginx-for-azure) page or finding the NGINXaaS service in the Azure portal:

1. [Sign in](https://portal.azure.com/) to the Azure portal with your Azure account.
1. Use the search field to find "NGINXaaS" in the Azure Portal. In the Services results, select **NGINXaaS**.
1. Select **+ Create** on the **NGINXaaS** page to start the deployment process.

## Create a deployment

### Basics tab

1. On the Create NGINXaaS Deployment **Basics** page, provide the following information:

   {{<bootstrap-table "table table-striped table-bordered">}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Subscription                | Select the appropriate Azure subscription that you have access to.|
  | Resource group              | Specify whether you want to create a new resource group or use an existing one.<br> For more information, see [Azure Resource Group overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview).         |
  | Name                        | Provide a unique name for your deployment. |
  | Region                      | Select the region you want to deploy to.   |
  | Pricing Plan                | Select the Standard V2 plan. For more information, see [Pricing Plans]({{< ref "/nginxaas-azure/billing/overview.md#pricing-plans">}})   |
  | Scaling                     | Select Manual to set the capacity of your deployment in NCUs or select Autoscale to automatically adjust the capacity of your deployment. Learn more about NCUs in [Scaling Guidance]({{< relref "/nginxaas-azure/quickstart/scaling.md" >}}). |
  | Email                       | Provide an email address that can be notified about service alerts, maintenance data and activity reports. |
  | Upgrade Channel             | Select the desired upgrade channel for your deployment. For more information, see [Upgrade Channels]({{< relref "/nginxaas-azure/quickstart/upgrade-channels.md" >}}). |

   {{</bootstrap-table>}}

1. Next, select **Networking**.

### Networking tab

1. On the Create NGINXaaS Deployment **Networking** page, provide the following information:

  {{<bootstrap-table "table table-striped table-bordered">}}
  | Field                       | Description                |
  |---------------------------- | ---------------------------- |
  | Virtual Network             | A virtual network is required for communication between the resources you create.<br>You can create a new virtual network or use an existing one (for an existing one see note below).<br>Additionally, you can peer a new virtual network with existing ones (in any region) to create network access from NGINXaaS for Azure to your upstream servers. To peer the virtual network with another see [Create, change, or delete a virtual network peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering).|
  | Subnet              | If you select an existing virtual network, you can select the existing subnet to be used. Before creating a deployment, the existing subnet needs to be delegated to `NGINX.NGINXPLUS/nginxDeployments`. To delegate a subnet to an Azure service, see [Delegate a subnet to an Azure service](https://learn.microsoft.com/en-us/azure/virtual-network/manage-subnet-delegation?source=recommendations#delegate-a-subnet-to-an-azure-service).<br><br>Otherwise, if you have chosen to create a new virtual network, a new subnet will be selected by default.<br><br>The minimum subnet size is `/27` and is sufficient for a single NGINXaaS deployment even at large scales. Multiple NGINXaaS deployments can be placed in a single delegated subnet, along with other resources. When doing so a larger subnet, e.g. a `/24`, is recommended. |
  | Allow NGINX access to Virtual Network | Confirm that you allow:<br>- Registration of the NGINX provider to your Azure subscription.<br>- Delegation of the subnet to the NGINX provider.|
  | IP address          | Set the IP address (public or private) that the service listens to for requests:<br><br>If you select a public IP address:<br>- Create a new public IP or use an existing one (for an existing one see the note below).<br>- Set the resource name for your public IP address.<br>Newly created public IPs are [zone-redundant in supported regions](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses#availability-zone). <br><br>If you select a private IP address:<br>- Provide a static IP address from the same subnet range set previously.   |
  | Inbound port rules | Select `None` to disallow inbound access on any port, or choose to allow traffic from one of these common http(s) ports. <br><br> **Note:** This option is only available when specifying a new virtual network as part of the create workflow. If you select an existing virtual network which is associated with a subnet and Network Security Group (NSG), you will need to edit the Inbound security rules to add access for the specific ports you want to allow (for example, ports 80 and 443).|
  | Apply default NGINX configuration | Confirm that you want your NGINXaaS deployment to be bootstrapped with a default NGINX configuration and a browsable splash page. |
   {{</bootstrap-table>}}

1. Next, select **Tags**.

### Tags tab

1. Add custom tags for the new NGINXaaS Deployment.  Each tag consists of a **name** and **value**.

1. After adding the tags, select **Next: Review+Create**

### Review + create tab

1. On the Review + create tab, your configuration is validated. You can review the selections made in the previous screens.

1. After validation has succeeded and you've reviewed the terms, select **Create** for Azure to start the deployment.

1. After the deployment finishes, select the NGINX deployment from the list (with "Type: NGINXaaS") to view information about the deployed resource.

   {{< img src="nginxaas-azure/deployment-complete.png" alt="Resource Deployment Completed page showing the available deployments and the new NGINXaaS type deployment in the Deployment details section." >}}


## Test your deployment

1. To test your deployment, you can go to the IP address noted on the overview page. The default NGINX welcome screen should load.

   {{<note>}}You will not see the default NGINX welcome screen if you unchecked "Apply default NGINX configuration" in the [Networking Tab screen]({{< relref "create-deployment.md#networking-tab" >}}) above. You can proceed with providing your own NGINX configuration as outlined in the [NGINX configuration]({{< relref "nginx-configuration.md#networking-tab" >}}) section.{{</note>}}

   {{< img src="nginxaas-azure/test-deployment.png" alt="NGINXaaS Overview page showing the IP address of the deployment in the Essentials section." >}}


## What's next

[Assign Managed Identities]({{< relref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}})
