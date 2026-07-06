---
title: Overview
weight: 50
toc: true
url: /nginxaas/google/deploy/ssl-tls-certificates/overview/
f5-content-type: reference
f5-product: NGINXaaS for Google Cloud
---


F5 NGINXaaS for Google Cloud (NGINXaaS) enables customers to secure traffic by adding SSL/TLS certificates to a deployment.

This document provides details about using SSL/TLS certificates with your F5 NGINXaaS for Google Cloud deployment.

## Supported certificate types and formats

NGINX supports the following certificate formats:

- PEM format certificates.

NGINXaaS allows you to upload these certificates as text, as files, and as secrets from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview).

Encrypt your certificates, keys, and PEM files using one of these standards:

- RSA
- ECC/ECDSA

## Add SSL/TLS certificates

NGINXaaS supports two ways to manage your certificates and keys securely:

**NGINXaaS console** — Manage certificates alongside the NGINX configurations that reference them. See [Add certificates using the NGINXaaS Console]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}).

**Google Secret Manager** — Fetch secrets directly from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview), keeping credentials within Google Cloud. See [Add certificates from Secret Manager]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md" >}}).

## Certificate rotation

NGINXaaS supports automatic and manual rotation for Secret Manager certificates:

**Automatic rotation** — Let NGINXaaS pick up new certificate versions automatically with no configuration changes needed. See [Rotate a Secret Manager certificate (automatic)]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-a-secret-manager-certificate-automatic" >}}).

**Manual rotation** — When you need to update certificates immediately, use **Reapply Configuration** in the console to refetch secrets right away. See [Rotate a Secret Manager certificate (manual)]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-a-secret-manager-certificate-manual" >}}).
