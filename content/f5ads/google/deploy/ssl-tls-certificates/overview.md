---
title: Overview
weight: 50
toc: true
url: /f5ads/google/deploy/ssl-tls-certificates/overview/
canonical: /f5ads/google/deploy/ssl-tls-certificates/overview/
f5-content-type: reference
f5-product: F5 Application Delivery Service for Google Cloud
---

Use F5 Application Delivery Service for Google Cloud to secure traffic by adding SSL/TLS certificates to a deployment.

## Supported certificate types and formats

NGINX supports the following certificate formats:

- PEM format certificates.

You can upload these certificates as text, as files, or as secrets from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview).

Encrypt your certificates, keys, and PEM files using one of these standards:

- RSA
- ECC/ECDSA

## Add SSL/TLS certificates

F5 Application Delivery Service supports two ways to manage your certificates and keys securely:

**F5 ADS console**: Manage certificates alongside the NGINX configurations that reference them. See [Add certificates using the F5 ADS Console]({{< ref "/f5ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}).

**Google Secret Manager**: Fetch secrets directly from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview), keeping credentials within Google Cloud. See [Add certificates from Secret Manager]({{< ref "/f5ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md" >}}).

## Certificate rotation

F5 Application Delivery Service supports automatic and manual rotation for Secret Manager certificates:

**Automatic rotation**: Let F5 Application Delivery Service pick up new certificate versions automatically with no configuration changes needed. See [Rotate a Secret Manager certificate (automatic)]({{< ref "/f5ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-a-secret-manager-certificate-automatic" >}}).

**Manual rotation**: When you need to update certificates immediately, use **Reapply Configuration** in the console to refetch secrets right away. See [Rotate a Secret Manager certificate (manual)]({{< ref "/f5ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-a-secret-manager-certificate-manual" >}}).
