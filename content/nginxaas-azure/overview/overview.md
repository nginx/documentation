---
title: "Overview and architecture"
weight: 100
categories: ["concepts"]
toc: true
docs: "DOCS-879"
url: /nginxaas/azure/overview/overview/
---

## What Is F5 NGINX as a Service for Azure?

NGINX as a Service for Azure is a service offering that is tightly integrated into Microsoft Azure public cloud and its ecosystem, making applications fast, efficient, and reliable with full lifecycle management of advanced NGINX traffic services.
NGINXaaS for Azure is available in the Azure Marketplace.

NGINXaaS for Azure is powered by [NGINX Plus](https://www.nginx.com/products/nginx/), which extends NGINX Open Source with advanced functionality and provides customers with a complete application delivery solution. Initial use cases covered by NGINXaaS include L7 HTTP load balancing and reverse proxy which can be managed through various Azure management tools.
NGINXaaS allows you to provision distinct deployments as per your business or technical requirements.

## Capabilities

The key capabilities of NGINXaaS for Azure are:

- Simplifies onboarding by leveraging NGINX as a service.
- Lowers operational overhead in running and optimizing NGINX.
- Simplifies NGINX deployments with fewer moving parts (edge routing is built into the service).
- Supports migration of existing NGINX configurations to the cloud with minimal effort.
- Integrates with the Azure ecosystem (Microsoft Entra, Azure Key Vault, and Azure Monitor).
- Addresses a wide range of deployment scenarios (HTTP reverse proxy, JWT authentication, etc).
- Adopts a consumption-based pricing to align infrastructure costs to actual usage by billing transactions using Azure.

## Supported regions

NGINXaaS for Azure is supported in the following regions:
{{< bootstrap-table "table table-striped table-bordered" >}}
| **North America**                                              | **South America** | **Europe** | **Asia Pacific** |
|----------------------------------------------------------|--------------------------------------------|--------------------------------------------|-------------------------|
| West Central US <br> West US <br> East US 2 <br> West US 2 <br> West US 3 <br> East US <br> Central US <br> North Central US <br> Canada Central | Brazil South | West Europe <br> North Europe <br> Sweden Central <br> Germany West Central | Australia East <br> Japan East <br> Korea Central <br> Southeast Asia <br> Central India <br> South India |
{{< /bootstrap-table >}}


## NGINXaaS architecture

{{< img src="nginxaas-azure/n4a-architecture.png" alt="The diagram illustrates the architecture of F5 NGINXaaS for Azure within a Microsoft Azure environment. It shows admins using Azure API/SDK, Azure Portal, Azure CLI, and Terraform to interact with the NGINX Plus component in the IaaS layer for edge routing. The diagram also depicts subnet delegation from the NGINX Plus component to a customer subscription, which includes Azure Key Vault, Azure Monitor, other Azure services, and multiple application servers (App Server 1, App Server 2, App Server N)." >}}

- Azure management tools (API, CLI, portal, terraform) work with NGINXaaS to create, update, and delete deployments
- Each NGINXaaS deployment has dedicated network and compute resources. There is no possibility of [noisy neighbor problems](https://learn.microsoft.com/en-us/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) or data leakage between deployments

### Redundancy

With the Standard V2 Plan, NGINXaaS uses the following redundancy features to keep your service available.

- We run _at least_ two NGINX Plus instances for each deployment in an active-active pattern
- NGINX Plus is constantly monitored for health. Any unhealthy instances are replaced with new ones
- We use [Azure Availability  Zones](https://learn.microsoft.com/en-us/azure/availability-zones/az-overview)
  to protect your deployment from local failures within an Azure region. We balance NGINX instances across the possible availability zones in [supported regions](https://learn.microsoft.com/en-us/azure/availability-zones/az-overview#azure-regions-with-availability-zones)

{{< note >}} If you are creating a public IP for your deployment, be sure to make them [zone redundant](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses#availability-zone) to get the best uptime. {{</ note >}}

### Data plane traffic

{{< img src="nginxaas-azure/n4a-data-plane-architecture.svg" alt="The diagram illustrates the architecture of F5 NGINXaaS for Azure, showing end users accessing a public IP that routes through a network security group within a customer's Azure subscription. This leads to a delegated subnet in a virtual network, which connects to a zone-redundant load balancer within the NGINXaaS subscription. The load balancer distributes traffic across NGINX Plus instances in multiple availability zones, ensuring scalability and redundancy." >}}

NGINXaaS uses new Azure networking capabilities to keep end-user traffic private. Each NGINX Plus instance passes traffic to  downstream services using an elastic network card (NIC) that exists inside your subscription. These NICs are injected into a delegated virtual network. A network security group controls traffic to your NGINX Plus instances.

NGINX Plus instances are automatically upgraded to receive security patches and the latest stable NGINX Plus version.

## What's next

To get started, check the [NGINX as a Service for Azure prerequisites]({{< relref "/nginxaas-azure/getting-started/prerequisites.md" >}})
