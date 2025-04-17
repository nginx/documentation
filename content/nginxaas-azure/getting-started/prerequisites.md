---
title: Prerequisites
weight: 100
toc: true
docs: DOCS-880
url: /nginxaas/azure/getting-started/prerequisites/
type:
- how-to
---

Before you deploy F5 NGINX as a Service for Azure (NGINXaaS) you need to meet the following prerequisites:

- An Azure account with an active subscription (if you don’t have one, [create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F)).

- [Confirm that you have the appropriate access](https://docs.microsoft.com/en-us/azure/role-based-access-control/check-access) before starting the setup:

  - The simplest approach is to use Azure’s built-in [Owner](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) role on either a specific resource group or the subscription.

  - It's possible to complete a limited setup with the built-in [Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor) role.

For specific permissions check the [NGINXaaS for Azure Frequently Asked Questions]({{< ref "/nginxaas-azure/faq" >}}).

## What's next

[Create a Deployment]({{< ref "/nginxaas-azure/getting-started/create-deployment/" >}})
