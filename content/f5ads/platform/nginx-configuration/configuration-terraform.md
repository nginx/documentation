---
title: Manage NGINX configurations using Terraform
description: "Create NGINX configurations and link managed certificates to them using Terraform."
weight: 200
toc: true
f5-content-type: how-to
f5-product: F5 Application Delivery Service
f5-keywords: "Terraform, NGINX configuration, managed certificate, TLS"
f5-summary: >
  Use the F5 ADS Terraform provider to manage versioned NGINX configurations.
  Link managed certificates to configuration payloads and apply the configuration to a deployment.
f5-audience: operator
---

## Overview

Use the `f5ads_configuration` resource to manage versioned NGINX configurations with Terraform.
For TLS, create a certificate first and reference its resource ID in the configuration payload.
The deployment uses the configuration ID and its latest version ID.

## Prerequisites

{{< include "/f5ads/terraform-prerequisites.md" >}}

Create a certificate with Terraform before you add the configuration below.
See [Add certificates using Terraform]({{< ref "/f5ads/platform/ssl-tls-certificates/ssl-tls-certificates-terraform.md" >}}).

## Create an NGINX configuration

The following example assumes that your certificate resource is named `f5ads_certificate.tls`.
It creates an HTTPS server configuration and links the certificate and key to the paths used by NGINX.

```hcl
resource "f5ads_configuration" "tls" {
  name        = "example-tls-config"
  description = "NGINX configuration with a managed TLS certificate."

  payloads = [
    {
      type      = "managed_certificate"
      object_id = f5ads_certificate.tls.id
      paths     = ["/etc/nginx/tls/server.crt"]
    },
    {
      type      = "managed_key"
      object_id = f5ads_certificate.tls.id
      paths     = ["/etc/nginx/tls/server.key"]
    },
  ]

  configs = [
    {
      name = "/etc/nginx"
      files = [
        {
          name = "nginx.conf"
          contents = base64encode(<<-EOT
            worker_processes auto;

            events {
              worker_connections 1024;
            }

            http {
              server {
                listen 443 ssl;
                server_name example.com;

                ssl_certificate     /etc/nginx/tls/server.crt;
                ssl_certificate_key /etc/nginx/tls/server.key;

                location / {
                  return 200 "OK";
                }
              }
            }
          EOT
          )
        },
      ]
    },
  ]
}
```

The `managed_certificate` and `managed_key` payloads link the certificate to the configuration.
Their `paths` values must match the paths in the `ssl_certificate` and `ssl_certificate_key` directives.
The configuration resource creates a new version when you change its files.

Initialize Terraform, review the plan, and apply the configuration:

```shell
terraform init
terraform plan
terraform apply
```

## Apply the configuration to a deployment

Set `nginx_config_id` to the configuration resource's `id` and `nginx_config_version_id` to its `latest_version_id` in your `f5ads_deployment` resource.

Add the cloud-specific properties required by your deployment. For examples, see [Deploy using the Terraform provider for AWS]({{< ref "/f5ads/aws/deploy/create-deployment/deploy-terraform.md" >}}) or [Deploy using the Terraform provider for Google Cloud]({{< ref "/f5ads/google/deploy/create-deployment/deploy-terraform.md" >}}).

## References

- [Configuration resource reference](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs/resources/configuration)
- [Deployment resource reference](https://registry.terraform.io/providers/F5Networks/f5ads/latest/docs/resources/deployment)
