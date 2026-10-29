---
title: Create or upload using Terraform
description: "Create, upload, and update NGINX configurations for F5 Application Delivery Service for Google Cloud using Terraform."
canonical: /app-delivery/google/deploy/nginx-configuration/nginx-configuration-terraform/
weight: 200
toc: true
f5-content-type: how-to
f5-product: F5 Application Delivery Service for Google Cloud
f5-keywords: "F5 ADS for Google Cloud, Terraform, F5 ADS Configuration, NGINX configuration, upload configuration, configuration version"
f5-summary: >
  Create or upload an NGINX configuration for F5 Application Delivery Service for Google Cloud with Terraform.
  Reference the configuration from a deployment to apply configuration updates without copying IDs.
  Import existing configurations only when you want Terraform to manage them.
f5-audience: operator
---

## Overview

Use the `f5ads_configuration` resource in the [`F5Networks/f5ads` Terraform provider](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs) to manage NGINX configurations for F5 Application Delivery Service for Google Cloud.

You can define configuration files inline or upload local files. The provider creates a new configuration version when you apply changes to the files.

Creating a configuration doesn't attach it to a deployment. Reference its `id` and `latest_version_id` from an `f5ads_deployment` resource to apply it. Terraform resolves the references automatically during `terraform apply`. No import is needed for resources that you create with Terraform.

## Prerequisites

{{< include "/f5ads/google/terraform-prerequisites.md" >}}

Review the [NGINX configuration rules and limits]({{< ref "/f5ads/google/deploy/nginx-configuration/configuration-rules.md" >}}) before you upload your files.

## Configure the provider

If you already configured the provider for your deployment, use the same Terraform working directory and skip this section. Otherwise, follow [Configure the provider]({{< ref "/f5ads/google/deploy/create-deployment/deploy-terraform.md#configure-the-provider" >}}) in the deployment guide.

## Create a configuration

Add the following example to a `.tf` file in your working directory. The sample NGINX configuration returns an HTTP 200 response on port 80.

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
}
```

Use these settings for your configuration files:

- For the main NGINX configuration file, set the directory `name` to `/etc/nginx` and the file `name` to `nginx.conf`. The provider requires this destination path.
- Base64-encode file contents with `base64encode()` for inline content or `filebase64()` for local files.
- Set either `name` or `name_prefix`, but not both. A fixed `name` must contain 3–30 characters, start with a lowercase letter, and end with a lowercase letter or digit. Use only lowercase letters, digits, and hyphens.

For all arguments, see the [`f5ads_configuration` resource documentation](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs/resources/configuration).

### Upload a local file instead

To use your own configuration, save it as `nginx.conf` in your Terraform working directory. Replace the resource definition in **Create a configuration** with the following example. You no longer need the `locals` block.

The `filebase64()` argument identifies the local source file. The directory and file `name` values specify its destination, `/etc/nginx/nginx.conf`.

```hcl
resource "f5ads_configuration" "example" {
  name        = "example-config"
  description = "NGINX configuration uploaded with Terraform."

  configs = [
    {
      name = "/etc/nginx"
      files = [
        {
          name     = "nginx.conf"
          contents = filebase64("${path.module}/nginx.conf")
        },
      ]
    },
  ]
}
```

Add other files to `files`, or add directory entries to `configs`, as needed. Include every file that your NGINX configuration references.

## Apply the configuration

```shell
terraform init
terraform plan
terraform apply
```

Terraform creates the configuration. No import is needed for this new resource.

## Use the configuration with a deployment

In your `f5ads_deployment` resource, set these required fields:

- `nginx_config_id = f5ads_configuration.<RESOURCE_NAME>.id`
- `nginx_config_version_id = f5ads_configuration.<RESOURCE_NAME>.latest_version_id`

Replace `<RESOURCE_NAME>` with the local name declared in your `f5ads_configuration` resource block. For example, `resource "f5ads_configuration" "example"` uses `example`, as shown in the deployment example.

Keep both resources in the same Terraform configuration. Terraform creates the configuration before the deployment and applies it automatically. You can create both resources in the same `terraform apply`. You don't need to create the configuration separately first.

For a complete deployment example, see [Deploy using the Terraform provider]({{< ref "/f5ads/google/deploy/create-deployment/deploy-terraform.md#create-a-deployment" >}}).

If Terraform already manages the deployment, update these fields in its existing resource definition. If it doesn't, first define a matching resource and [import the existing deployment](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs/resources/deployment#import). Review the plan before applying changes.

## Update a configuration

Edit `local.nginx_conf` or the files referenced by `filebase64()`, review `terraform plan`, then run `terraform apply`.

The provider creates a new version and updates `latest_version_id` without changing the configuration ID. Deployments referencing `latest_version_id` also update to use the new version.

## Import an existing configuration

Import a configuration only if Terraform doesn't already manage it, such as one you created through the console. Skip this section for new configurations created with Terraform.

1. Define a `f5ads_configuration` resource that matches the existing configuration's name and files. Don't apply it yet.
1. Run `terraform init`.
1. Import the configuration. Replace `<RESOURCE_NAME>` with the local name in your resource block, such as `example`. Replace `<CONFIGURATION_ID>` with the existing configuration's ID:

   ```shell
   terraform import f5ads_configuration.<RESOURCE_NAME> '<CONFIGURATION_ID>'
   ```

1. Run `terraform plan` and fix unintended differences before you apply changes.

Import adds the configuration to Terraform state. It doesn't create a configuration or attach it to a deployment. To apply it, use the references in [Use the configuration with a deployment]({{< ref "/f5ads/google/deploy/nginx-configuration/nginx-configuration-terraform.md#use-the-configuration-with-a-deployment" >}}).

## Replace a configuration safely

Changes to configuration files create a new version without replacing the resource. Changes to `name` or `name_prefix` replace the resource itself.

For replacements, use `name_prefix` with `create_before_destroy`. Ensure the deployment references the configuration resource's `id` and `latest_version_id`. Terraform then creates the replacement, updates the deployment, and deletes the old configuration.

Update any deployments managed outside this Terraform configuration before deleting the old configuration.

The provider appends a random suffix to `name_prefix`. The prefix must contain 1–21 characters and start with a lowercase letter. Use only lowercase letters, digits, and hyphens.

For a local file, replace the resource definition in **Upload a local file instead** with this example:

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
          contents = filebase64("${path.module}/nginx.conf")
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

## Delete a configuration

Before you delete a configuration, update or delete all deployments that use it, including deployments managed outside this Terraform configuration.

Remove the `f5ads_configuration` resource block and its references, review `terraform plan`, then run `terraform apply`.

## What's next

- [Monitor your deployment]({{< ref "/f5ads/google/monitoring/enable-monitoring.md" >}}) after you apply the configuration.
