---
title: Add certificates using Terraform
description: "Upload SSL/TLS certificates and private keys for F5 Application Delivery Service using Terraform."
weight: 200
toc: true
f5-content-type: how-to
f5-product: F5 Application Delivery Service
f5-keywords: "Terraform, SSL, TLS, certificates, private keys, certificate rotation"
f5-summary: >
  Upload SSL/TLS certificates and private keys for F5 Application Delivery Service using the Terraform provider.
  Use the certificate resource to manage certificates separately from your NGINX configurations.
f5-audience: operator
---

## Overview

Use the [`f5ads_certificate` resource](https://registry.terraform.io/providers/F5Networks/f5ads/0.1.0/docs/resources/certificate) to upload certificates for F5 Application Delivery Service.
The resource supports SSL/TLS certificates with matching private keys and CA certificate bundles without private keys.

## Prerequisites

{{< include "/f5ads/google/terraform-prerequisites.md" >}}

Have a PEM-encoded certificate and matching private key for the example below.

## Add a certificate

1. Save your certificate as `server.crt` and its matching private key as `server.key` in your Terraform module directory.

1. Add the following resource to your Terraform configuration:

   ```hcl
   resource "f5ads_certificate" "tls" {
     name_prefix  = "example-tls"
     public_certs = filebase64("${path.module}/server.crt")
     private_key  = filebase64("${path.module}/server.key")

     lifecycle {
       create_before_destroy = true
     }
   }
   ```

   Use either `name` or `name_prefix` to name the certificate.
   The example uses `name_prefix` to give replacement certificates unique names.
   The resource requires Base64-encoded PEM contents. The `filebase64()` function reads and encodes each file.
   For a CA certificate bundle, supply the bundle in `public_certs` and omit `private_key`.

   Certificates are immutable. Changing the certificate or private key requires Terraform to replace the resource.
   Keep `name_prefix` and `create_before_destroy` so Terraform creates the replacement before removing the old certificate.
   Update any configuration references before removing a certificate that's in use.

   {{< call-out class="important" >}}
   Terraform stores the private key in its state, even though CLI output marks it as sensitive.
   Restrict who can read your state backend and use encryption at rest.
   Don't commit private keys or state files to version control.
   {{< /call-out >}}

1. Initialize Terraform, review the plan, and apply the changes:

   ```shell
   terraform init
   terraform plan
   terraform apply
   ```

   Terraform creates the certificate. Use `f5ads_certificate.tls.id` when referencing it in your Terraform configuration.

## Troubleshooting

### Terraform can't replace a certificate with a fixed name

Certificates with the same name can't coexist.
Use `name_prefix` with `create_before_destroy`, as shown above, to give the replacement a unique name.
If you already use a fixed name, create a certificate with a new name and update its configuration references first.

## References

- [Certificate resource reference](https://registry.terraform.io/providers/F5Networks/f5ads/0.1.0/docs/resources/certificate)
- [Use a certificate in an NGINX configuration with the console]({{< ref "/f5ads/platform/ssl-tls-certificates/ssl-tls-certificates-console.md#use-a-certificate-in-an-nginx-configuration" >}})
