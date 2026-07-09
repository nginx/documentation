---
title: Overview
weight: 50
toc: true
url: /nginxaas/aws/deploy/ssl-tls-certificates/overview/
f5-content-type: reference
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

F5 NGINXaaS for AWS enables customers to secure traffic by adding SSL/TLS certificates to a deployment.

This document provides details about using SSL/TLS certificates with your F5 NGINXaaS for AWS deployment.

## Supported certificate types and formats

NGINX supports the following certificate formats:

- PEM format certificates.

NGINXaaS for AWS allows you to upload these certificates as text, as files, and as secrets from [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html).

Encrypt your certificates, keys, and PEM files using one of these standards:

- RSA
- ECC/ECDSA

## Add SSL/TLS certificates

NGINXaaS for AWS supports two ways to manage your certificates and keys securely:

**NGINXaaS console** — Manage certificates alongside the NGINX configurations that reference them. See [Add certificates using the NGINXaaS Console]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}).

**AWS Secrets Manager** — Fetch secrets directly from [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html), keeping credentials within AWS. See [Add certificates from AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md" >}}).

## Certificate rotation

NGINXaaS for AWS supports automatic and manual rotation for AWS Secrets Manager certificates:

**Automatic rotation** — Let NGINXaaS for AWS pick up new certificate versions automatically with no configuration changes needed. See [Rotate an AWS Secrets Manager certificate (automatic)]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-an-aws-secrets-manager-certificate-automatic" >}}).

**Manual rotation** — When you need to update certificates immediately, use **Reapply Configuration** in the console to refetch secrets right away. See [Rotate an AWS Secrets Manager certificate (manual)]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-an-aws-secrets-manager-certificate-manual" >}}).
