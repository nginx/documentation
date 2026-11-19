---
title: Deploy using the Terraform provider
description: "Create and set up an F5 Application Delivery Service for Google Cloud deployment using the Terraform provider."
weight: 100
toc: true
f5-content-type: how-to
f5-product: F5 Application Delivery Service for Google Cloud
f5-keywords: "F5 ADS for Google Cloud, Terraform, create deployment, F5 ADS configuration, F5 ADS Console, NCU, service frontend, Network attachment, Service Attachment, PSC"
f5-summary: >
  Learn how to manage an F5 Application Delivery Service for Google Cloud deployment using the Terraform provider.
  This guide covers Google Cloud network resources, provider setup, and deployment creation using Terraform.
f5-audience: operator
---

## Overview

This guide explains how to create an F5 Application Delivery Service for Google Cloud deployment using the [`F5Networks/f5ads` Terraform provider](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs).

The examples in this guide use two resources:

- `f5ads_configuration` creates and versions the NGINX configuration.
- `f5ads_deployment` creates a deployment that references the configuration and its version.

Terraform resolves these references automatically when you run `terraform apply`. You don't need to copy IDs or import resources that you create with Terraform.

To create and manage a configuration with Terraform, see [Manage NGINX configurations using Terraform]({{< ref "/f5ads/google/deploy/nginx-configuration/configuration-terraform.md" >}}).

## Prerequisites

{{< include "/f5ads/terraform-prerequisites.md" >}}

{{< include "/f5ads/google/terraform-prerequisites.md" >}}

## Set up the provider

{{< include "/f5ads/google/terraform-provider-config.md" >}}

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

## Prepare an NGINX configuration

Follow [Manage NGINX configurations using Terraform]({{< ref "/f5ads/google/deploy/nginx-configuration/configuration-terraform.md" >}}) to add an `f5ads_configuration.example` resource to the same Terraform working directory.

You don't need to apply the configuration separately. The deployment references it, so Terraform creates both resources in the correct order during `terraform apply`.

## Create a deployment

To apply your configuration to a deployment, reference the configuration from the `f5ads_deployment` resource:

- Set `nginx_config_id` to `f5ads_configuration.<RESOURCE_NAME>.id`.
- Set `nginx_config_version_id` to `f5ads_configuration.<RESOURCE_NAME>.latest_version_id`.

Replace `<RESOURCE_NAME>` with the local name declared in your `f5ads_configuration` resource block. For example, `resource "f5ads_configuration" "example"` uses `example`, as shown in the deployment example.

Both fields are required. Terraform uses the references to create the configuration first and apply it to the deployment. You don't need a separate step to link the resources. Applying file changes creates a new configuration version and updates the deployment to use it.

{{< call-out class="important" >}}
If you use a configuration created in the Console, replace the Terraform references below with its configuration ID and version ID.
{{< /call-out >}}

Choose a frontend type for your deployment. Refer to [Service frontend]({{< ref "/f5ads/google/overview.md#service-frontend" >}}) for more information on these two frontend types.

To use a managed public endpoint:

```hcl
resource "f5ads_deployment" "example" {
  name                    = "my-deployment"
  capacity                = 20
  waf_enabled             = true
  nginx_config_id         = f5ads_configuration.example.id
  nginx_config_version_id = f5ads_configuration.example.latest_version_id

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

Terraform creates the NGINX configuration and then creates the deployment with that configuration. No import is needed for these new resources.

## What's next

- [Update an NGINX configuration]({{< ref "/f5ads/google/deploy/nginx-configuration/nginx-configuration-terraform.md#update-a-configuration" >}}).
- [Monitor your deployment]({{< ref "/f5ads/google/monitoring/enable-monitoring.md" >}}).
