---
title: Enable post-quantum cryptography
description: "Configure F5 NGINXaaS for AWS to use hybrid ML-KEM key exchange or ML-DSA certificates for post-quantum TLS protection."
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/quickstart/pqc/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
f5-keywords: "NGINXaaS for AWS, PQC, post-quantum cryptography, ML-KEM, ML-DSA, TLS 1.3, hybrid mode, quantum-safe"
f5-summary: >
  Learn how to enable post-quantum cryptography in F5 NGINXaaS for AWS using hybrid ML-KEM key exchange or ML-DSA certificates.
  This guide covers both modes, key format requirements, and optional NGINX configuration for hardening.
f5-audience: operator
contentVars:
  product: NGINXaaS for AWS
---

{{< include "nginxaas/pqc-intro.md" >}}

## Before you begin

Before you begin, ensure you have:

- An existing NGINXaaS for AWS deployment: See [Create a deployment]({{< ref "/nginxaas/aws/deploy/create-deployment/deploy-console.md" >}}) if you need to create one.
- TLS 1.3 in your NGINX configuration: NGINX includes TLSv1.3 in its default `ssl_protocols` value alongside TLSv1.2. ML-KEM hybrid key exchange only applies to TLS 1.3 connections. To prevent clients from downgrading to TLS 1.2, restrict `ssl_protocols` to `TLSv1.3` only - this is recommended for maximum security but drops support for older clients.

## Enable hybrid mode (ML-KEM key exchange)

{{< include "nginxaas/pqc-hybrid-mode-intro.md" >}}

### Recommended: Restrict to TLS 1.3 only

{{< include "nginxaas/pqc-restrict-tls13.md" >}}

### Optional: Explicitly configure ML-KEM hybrid groups

{{< include "nginxaas/pqc-mlkem-hybrid-groups.md" >}}

## Enable full PQC mode (ML-DSA certificates)

Full PQC mode requires you to upload an ML-DSA certificate and private key. NGINXaaS for AWS accepts ML-DSA keys in PEM format with the following constraints:

- NGINXaaS Console: Seed-only key format only.
- AWS Secrets Manager: Seed-only and seed-priv formats are both supported.

Choose the method that matches your key format.

### Upload an ML-DSA certificate using the Console

Use this method if your ML-DSA private key is in seed-only format.

1. Follow the steps in [Add certificates using the Console]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}) to upload your ML-DSA certificate and key.
1. In your NGINX configuration, reference the certificate and key with `ssl_certificate` and `ssl_certificate_key`, and set `ssl_protocols TLSv1.3;`:

    ```nginx
    server {
        listen 443 ssl;
        ssl_protocols TLSv1.3;
        ssl_certificate     /etc/nginx/certs/mldsa.crt;
        ssl_certificate_key /etc/nginx/certs/mldsa.key;
        # ...
    }
    ```

1. Select **Next** and then **Save** to apply the change.
1. Deploy configuration to relevant deployments.

### Store an ML-DSA certificate in AWS Secrets Manager

Use this method if your ML-DSA private key is in seed-priv format, or if you want to keep your keys within AWS.

1. Add your ML-DSA certificate and key to AWS Secrets Manager. Follow the steps in [Add an SSL/TLS certificate to AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md#add-an-ssltls-certificate-to-aws-secrets-manager" >}}).
1. Reference the secret in your NGINX configuration as described in [Use an AWS Secrets Manager certificate in an NGINX configuration]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md#use-an-aws-secrets-manager-certificate-in-an-nginx-configuration" >}}).
1. Add `ssl_protocols TLSv1.3;` to your `server` block.

## Verify post-quantum negotiation

{{< include "nginxaas/pqc-verify-negotiation.md" >}}

### Track ML-KEM adoption across real clients

{{< include "nginxaas/pqc-track-adoption.md" >}}

{{< call-out class="note" title="Collecting logs" >}}
To forward logs to AWS CloudWatch, see [Enable NGINX logs]({{< ref "/nginxaas/aws/monitoring/enable-nginx-logs.md" >}}).
{{< /call-out >}}

## What's next

- [SSL/TLS certificate overview]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/overview.md" >}}) - supported certificate types, formats, and rotation options.
- [Add certificates using the Console]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}) - manage certificates alongside your NGINX configuration.
- [Add certificates from AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md" >}}) - fetch secrets directly from AWS Secrets Manager.
