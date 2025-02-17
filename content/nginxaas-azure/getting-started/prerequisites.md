---
title: "Prerequisites"
weight: 100
categories: ["tasks"]
toc: true
docs: "DOCS-880"
url: /nginxaas/azure/getting-started/prerequisites/
---

Before you deploy F5 NGINX as a Service for Azure (NGINXaaS) you need to meet the following prerequisites:

- An Azure account with an active subscription (if you don’t have one, [create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F)).

- [Confirm that you have the appropriate access](https://docs.microsoft.com/en-us/azure/role-based-access-control/check-access) before starting the setup:

  - The simplest approach is to use Azure’s built-in [Owner](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) role on either a specific resource group or the subscription.

  - It's possible to complete a limited setup with the built-in [Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor) role.

For specific permissions check the [NGINXaaS for Azure Frequently Asked Questions]({{< relref "/nginxaas-azure/faq" >}}).

## What's next

[Create a Deployment]({{< relref "/nginxaas-azure/getting-started/create-deployment/" >}})
