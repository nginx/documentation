---
title: Deploy using the Terraform provider
description: "Create an F5 Application Delivery Service for AWS deployment using the Terraform provider."
weight: 200
toc: true
f5-content-type: how-to
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 ADS for AWS, Terraform, deployment, managed public endpoint, NGINX configuration"
f5-summary: >
  Create an F5 Application Delivery Service for AWS deployment with Terraform.
  Apply a managed NGINX configuration and set up a managed public endpoint.
f5-audience: operator
---

## Overview

Use the `f5ads_deployment` resource to create an F5 Application Delivery Service for AWS deployment.
This guide shows how to apply a configuration managed with Terraform and expose it through a managed public endpoint.

## Prerequisites

- Complete the [F5 ADS for AWS prerequisites]({{< ref "/f5ads/aws/deploy/prerequisites.md" >}}).
- Create an NGINX configuration with Terraform. See [Manage NGINX configurations using Terraform]({{< ref "/f5ads/aws/deploy/nginx-configuration/configuration-terraform.md" >}}).

{{< include "/f5ads/terraform-prerequisites.md" >}}

## Set up the provider

Add the `f5ads` provider to your Terraform configuration. This example uses the latest provider version; Terraform records the selected version in the dependency lock file.

```hcl
terraform {
  required_providers {
    f5ads = {
      source = "F5Networks/f5ads"
    }
  }
}

provider "f5ads" {
  geo = "us"
}
```

The provider needs your F5 ADS client credentials to authenticate. Supply them in the provider block or through environment variables:

```hcl
provider "f5ads" {
  geo           = "us"
  client_id     = "your-client-id"
  client_secret = "your-client-secret"
}
```

```shell
export F5ADS_GEO="us"
export F5ADS_CLIENT_ID="your-client-id"
export F5ADS_CLIENT_SECRET="your-client-secret"
```

## Create a deployment

The example uses a managed public endpoint with access limited to the documentation-only CIDR block `203.0.113.0/24`.
Replace it with the CIDR blocks that should reach your deployment.

```hcl
resource "f5ads_deployment" "example" {
  name                    = "my-deployment"
  capacity                = 20
  waf_enabled             = true
  nginx_config_id         = f5ads_configuration.tls.id
  nginx_config_version_id = f5ads_configuration.tls.latest_version_id

  aws_cloud_properties = {
    region          = "us-east-1"
    ipv4_cidr_block = "10.0.0.0/24"

    frontend = {
      managed_public_endpoint = {
        acl = [
          {
            source_prefixes = ["203.0.113.0/24"]
            port_range      = "443"
            protocol        = "tcp"
          },
        ]
      }
    }
  }
}
```

Choose an IPv4 CIDR block that doesn't overlap with VPCs you plan to peer with the deployment.
For more information, see [Identity and access management]({{< ref "/f5ads/aws/deploy/access-management.md" >}}) if you need to connect an IAM role for CloudWatch or Secrets Manager.

Initialize Terraform, review the plan, and apply the deployment:

```shell
terraform init
terraform plan
terraform apply
```

## References

- [Deployment resource reference](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs/resources/deployment)
- [Service frontend]({{< ref "/f5ads/aws/overview.md#service-frontend" >}})
