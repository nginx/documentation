---
title: Deploy using the Terraform provider
description: "Create, and configure an F5 NGINXaaS for Google Cloud deployment using the Terraform provider."
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/google/deploy/create-deployment/deploy-terraform/
f5-content-type: how-to
f5-product: NGINXaaS for Google Cloud
f5-keywords: "NGINXaaS for Google Cloud, Terraform,create deployment, NGINXaaS Console, NCU, service frontend, Network attachment, Service Attachment, PSC"
f5-summary: >
  Learn how to manage an F5 NGINXaaS for Google Cloud deployment using the Terraform provider.
  This guide covers setting up necessary Google Cloud resources, configuring the Terraform provider, and managing the deployment using Terraform.
f5-audience: operator
---

## Overview

This guide explains how to create an F5 NGINXaaS for Google Cloud (NGINXaaS) deployment using the [`F5Networks/f5ads` Terraform provider](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs). This guide only covers creating a deployment.

## Prerequisites

{{< include "/nginxaas/google/terraform-prerequisites.md" >}}

## Configure the provider

Add the `f5ads` provider to your Terraform configuration and pin it to the exact alpha version:

```hcl
terraform {
  required_providers {
    f5ads = {
      source  = "F5Networks/f5ads"
      version = "0.1.0-alpha.1"
    }
  }
}

provider "f5ads" {
  geo = "us"
}
```

The provider needs your F5 ADS client credentials to authenticate. You can supply them in the provider block, or with environment variables:

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

## Create GCP network resources

Include the following snippet if you need to create a VPC, subnet, and [network attachment](https://cloud.google.com/vpc/docs/about-network-attachments) for your deployment. Refer to the [`hashicorp/google` provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) for instructions on authentication and setting up your Google Cloud project.

```hcl
provider "google" {
  region = "us-east1"
}

resource "google_compute_network" "vpc" {
  name                    = "my-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-east1"
  network       = google_compute_network.vpc.id
}

resource "google_compute_network_attachment" "attachment" {
  name                  = "my-network-attachment"
  region                = "us-east1"
  connection_preference = "ACCEPT_AUTOMATIC"
  subnetworks           = [google_compute_subnetwork.subnet.id]
}
```

{{< call-out class="caution" >}}
The `f5ads` provider currently only supports network attachments with `connection_preference` set to `ACCEPT_AUTOMATIC`, which accepts connections from all projects. Support for `ACCEPT_MANUAL` is planned for an upcoming release. See [Google's documentation on creating a network attachment](https://cloud.google.com/vpc/docs/create-manage-network-attachments#create-network-attachments) for details.
{{< /call-out >}}

## Create a deployment

{{< call-out class="important" >}}
Create or reuse an existing configuration in the [F5 ADS Console]({{< ref "/nginxaas/google/deploy/nginx-configuration/nginx-configuration-console.md" >}}) first, then supply its [Configuration ID and Configuration Version ID]({{< ref "/nginxaas/google/deploy/nginx-configuration/nginx-configuration-console.md#get-nginx-configuration-version-information" >}}) below.
{{< /call-out >}}

Choose a frontend type for your deployment. Refer to [Service frontend]({{< ref "/nginxaas/google/overview.md#service-frontend" >}}) for more information on these two frontend types.

To use a managed public endpoint:

```hcl
resource "f5ads_deployment" "example" {
  name                    = "my-deployment"
  capacity                = 20
  waf_enabled             = true
  nginx_config_id         = "cfg_example123"
  nginx_config_version_id = "cv_example456"

  google_cloud_properties = {
    region             = "us-east1"
    network_attachment = google_compute_network_attachment.attachment.id

    frontend = {
      managed_public_endpoint = {
        acl = [
          {
            source_prefixes = ["0.0.0.0/0"]
            port_range      = "80"
            protocol        = "tcp"
          },
          {
            source_prefixes = ["0.0.0.0/0"]
            port_range      = "443"
            protocol        = "tcp"
          },
        ]
      }
    }
  }
}
```

To use a private endpoint instead, replace the `managed_public_endpoint` block with a `private_endpoint` block:

```hcl
    frontend = {
      private_endpoint = {
        service_attachment_accept_list = [
          "my-gcp-project",
        ]
      }
    }
```

Create the deployment:

```shell
terraform init
terraform plan
terraform apply
```
