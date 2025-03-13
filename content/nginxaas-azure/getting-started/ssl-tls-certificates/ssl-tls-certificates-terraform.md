---
title: Add certificates using Terraform
weight: 300
toc: true
url: /nginxaas/azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-terraform/
type:
- how-to
---

## Overview

You can manage SSL/TSL certificates for F5 NGINX as a Service for Azure (NGINXaaS) using Terraform.

## Prerequisites

{{< include "/nginxaas-azure/terraform-prerequisites.md" >}}

## Upload and manage a certificate

You can find examples of Terraform configurations in the [NGINXaaS for Azure Snippets GitHub repository](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/terraform/certificates)

To create a deployment, add a certificate, and use it in a configuration, run the following commands:

   ```bash
   terraform init
   terraform plan
   terraform apply --auto-approve
   ```

## Delete a deployment

Once the deployment is no longer needed, run the following to clean up the deployment and related resources:

   ```bash
   terraform destroy --auto-approve
   ```

## Additional resources

- [Terraform NGINX certificate documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nginx_certificate)

{{< include "/nginxaas-azure/terraform-resources.md" >}}