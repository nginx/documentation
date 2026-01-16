---
title: Azure CLI
weight: 900
description: Learn how to setup the Azure CLI to manage NGINXaaS for Azure.
toc: true
nd-docs: DOCS-1234
url: /nginxaas/azure/client-tools/cli/
nd-content-type: how-to
nd-product: NAZURE
---

F5 NGINXaaS for Azure (NGINXaaS) deployments can be managed using the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/). This document outlines how to install the CLI tool including the NGINX extension.

## Prerequisites

- Install Azure CLI version 2.67.0 or greater: [Azure CLI Installation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli))
- Log into your Azure account through the CLI: [Azure CLI Authentication](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli).

## Install NGINXaaS extension

{{< call-out "important" >}}**System-Assigned Managed Identity Required**: All new NGINXaaS deployments must include a system-assigned managed identity for Geneva logging and monitoring features. When creating deployments with the Azure CLI, use the `--identity` parameter with `type="SystemAssigned"`. See [Deploy using the Azure CLI]({{< ref "/nginxaas-azure/getting-started/create-deployment/deploy-azure-cli.md" >}}) for examples.{{< /call-out >}}

In order to install and manage your NGINXaaaS deployments using the Azure CLI, you will need to install the `nginx` extension:

```shell
az extension add --name nginx --allow-preview true
```

## Update NGINXaaS extension

Ensure you are running the latest version of the `nginx` CLI extension to take advantage of the latest capabilities available on your NGINXaaS deployments:

```shell
az extension update --name nginx --allow-preview true
```
