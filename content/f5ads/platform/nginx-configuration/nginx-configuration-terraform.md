---
title: Create or upload using Terraform
description: "Create, upload, and update NGINX configurations for F5 Application Delivery Service using Terraform."
weight: 200
toc: true
f5-content-type: how-to
f5-product: F5 Application Delivery Service
f5-keywords: "Terraform, NGINX configuration, upload configuration, configuration version"
f5-summary: >
  Create or upload an NGINX configuration for F5 Application Delivery Service with Terraform.
  Reference the configuration from a deployment to apply configuration updates without copying IDs.
f5-audience: operator
---

You can apply an NGINX configuration to your F5 Application Delivery Service deployment using the F5 ADS Terraform provider.

## Overview

Use the `f5ads_configuration` resource in the [`F5Networks/f5ads` Terraform provider](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs) to manage NGINX configurations for F5 Application Delivery Service.

Provide configuration files as base64-encoded content. Applying changes to the files creates a new configuration version.

Creating a configuration doesn't attach it to a deployment. For Google Cloud deployments, follow [Create a deployment]({{< ref "/f5ads/google/deploy/create-deployment/deploy-terraform.md#create-a-deployment" >}}) to apply the configuration.

## Prerequisites

For Google Cloud deployments, meet the following prerequisites:

{{< include "/f5ads/google/terraform-prerequisites.md" >}}

Review the [NGINX configuration rules and limits]({{< ref "/f5ads/platform/nginx-configuration/configuration-rules.md" >}}) before you upload your files.

## Configure the provider

{{< include "/f5ads/google/terraform-provider-config.md" >}}

## Create a configuration

The following example returns an HTTP 200 response on port 80.

```hcl
locals {
  nginx_conf = <<-EOT
    user nginx;
    worker_processes auto;
    pid /run/nginx/nginx.pid;
    worker_rlimit_nofile 524288;
    events {
        worker_connections 150000;
    }

    http {
        server {
            listen 80 backlog=2048 default_server;
            http2 on;
            server_name _;

            location / {
                return 200 "Hello from F5 ADS!";
            }
        }
    }
  EOT
}

resource "f5ads_configuration" "example" {
  name        = "example-config"
  description = "Example F5 ADS configuration managed by Terraform."

  configs = [
    {
      name = "/etc/nginx"
      files = [
        {
          name     = "nginx.conf"
          contents = base64encode(local.nginx_conf)
        },
      ]
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}
```

Use these settings for your configuration files:

- For the main NGINX configuration file, set the directory `name` to `/etc/nginx` and the file `name` to `nginx.conf`. The provider requires this destination path.
- Base64-encode file contents with `base64encode()` for inline content or `filebase64()` for local files.
- Set either `name` or `name_prefix`, but not both.

For all arguments, see the [`f5ads_configuration` resource documentation](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs/resources/configuration).

Add other files to `files`, or add directory entries to `configs`, as needed. Include every file that your NGINX configuration references.

## Apply the configuration

```shell
terraform init
terraform plan
terraform apply
```

Terraform creates the configuration.

## Replace a configuration safely

Changes to configuration files create a new version without replacing the resource. Changes to `name` or `name_prefix` replace the resource itself.

For configurations referenced by a deployment, use the `create_before_destroy` Terraform lifecycle block so that Terraform creates a new configuration, updates the deployment, and then deletes the old configuration.

Replace the resource definition in **Create a configuration** with this example, keeping the `locals` block:

```hcl
resource "f5ads_configuration" "example" {
  name_prefix = "example-config"
  description = "NGINX configuration uploaded with Terraform."

  configs = [
    {
      name = "/etc/nginx"
      files = [
        {
          name     = "nginx.conf"
          contents = base64encode(local.nginx_conf)
        },
      ]
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}
```

Review the replacement plan before applying it.
