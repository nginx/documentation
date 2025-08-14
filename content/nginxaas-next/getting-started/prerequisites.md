---
title: Overview and prerequisites
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/next/getting-started/prerequisites/
type:
- how-to
---


{{< call-out "warning">}}This page has not been updated yet. Currently it has the NGINXaaS for Azure content{{< /call-out >}}

## Before you begin

Before you deploy NGINXaaS you need to meet the following prerequisites:

- An Azure account with an active subscription (if you don’t have one, [create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F)).

- [Confirm that you have the appropriate access](https://docs.microsoft.com/en-us/azure/role-based-access-control/check-access) before starting the setup:

  - The simplest approach is to use Azure’s built-in [Owner](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) role on either a specific resource group or the subscription.

  - It's possible to complete a limited setup with the built-in [Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor) role.


- The specific Azure permissions required to deploy NGINXaaS are:

   - microsoft.network/publicIPAddresses/join/action
   - nginx.nginxplus/nginxDeployments/Write
   - microsoft.network/virtualNetworks/subnets/join/action
   - nginx.nginxplus/nginxDeployments/configurations/Write
   - nginx.nginxplus/nginxDeployments/certificates/Write

- Additionally, if you are creating the Virtual Network or IP address resources that NGINXaaS for NEXCLOUD will be using, then you probably also want those permissions as well.

- Note that assigning the managed identity permissions normally requires an "Owner" role.

## What's next

[Create a Deployment]({{< ref "/nginxaas-next/getting-started/create-deployment/" >}})
