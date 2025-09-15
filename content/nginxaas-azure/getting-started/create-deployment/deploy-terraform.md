---
title: Deploy using Terraform
weight: 300
toc: true
url: /nginxaas/azure/getting-started/create-deployment/deploy-terraform/
type:
- how-to
---

## Overview

F5 NGINXaaS for Azure (NGINXaaS) deployments can be managed using Terraform. This document outlines common Terraform workflows for NGINXaaS.

## Prerequisites

{{< include "/nginxaas-azure/terraform-prerequisites.md" >}}

## Create a deployment

You can find examples of Terraform configurations in the [NGINXaaS for Azure Snippets GitHub repository](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/terraform/deployments/create-or-update)

To create a deployment, use the following Terraform commands:

   ```shell
   terraform init
   terraform plan
   terraform apply --auto-approve
   ```

## Delete a deployment

Once the deployment is no longer needed, run the following to clean up the deployment and related resources:

   ```shell
   terraform destroy --auto-approve
   ```

## Additional resources

- If you're just starting with Terraform, you can learn more on their [official website](https://www.terraform.io/).
- [Terraform NGINX deployment documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nginx_deployment)

{{< include "/nginxaas-azure/terraform-resources.md" >}}