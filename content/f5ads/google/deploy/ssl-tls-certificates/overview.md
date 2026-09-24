---
title: Overview
description: "Reference for supported SSL/TLS certificate types and how to add them to an F5 Application Delivery Service for Google Cloud deployment."
weight: 50
toc: true
url: /application-services/google/deploy/ssl-tls-certificates/overview/
canonical: /application-services/google/deploy/ssl-tls-certificates/overview/
f5-content-type: reference
f5-product: F5 Application Delivery Service for Google Cloud
f5-keywords: "F5 ADS for Google Cloud, SSL, TLS, certificates, Google Secret Manager, certificate rotation, PEM, ML-DSA, post-quantum, PQC"
f5-summary: >
  This reference covers the SSL/TLS certificate types and formats F5 Application Delivery Service for Google Cloud supports, including post-quantum ML-DSA certificates, and the two ways to manage them: the F5 ADS Console and Google Secret Manager.
  Use it to choose a certificate management approach and understand automatic and manual rotation options.
f5-audience: operator
---

Use F5 Application Delivery Service for Google Cloud (F5 ADS for Google Cloud) to secure traffic by adding SSL/TLS certificates to a deployment.

## Supported certificate types and formats

NGINX supports the following certificate formats:

- PEM format certificates.

You can upload these certificates as text, as files, or as secrets from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview).

Encrypt your certificates, keys, and PEM files using one of these standards:

- RSA
- ECC/ECDSA
- ML-DSA (post-quantum)

{{< call-out class="note" title="ML-DSA key format support" >}}
When you upload an ML-DSA private key using the F5 ADS Console, use the seed-only key format.
If you store your ML-DSA key in Google Secret Manager, you can use either the seed-only or seed-priv format.
See [Enable post-quantum cryptography]({{< ref "/f5ads/google/quickstart/pqc.md" >}}) for configuration guidance.
{{< /call-out >}}

## Add SSL/TLS certificates

F5 ADS for Google Cloud supports two ways to manage your certificates and keys securely:

**F5 ADS Console**: Manage certificates alongside the NGINX configurations that reference them. See [Add certificates using the F5 ADS Console]({{< ref "/f5ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}).

**Google Secret Manager**: Fetch secrets directly from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview), keeping credentials within Google Cloud. See [Add certificates from Secret Manager]({{< ref "/f5ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md" >}}).

## Certificate rotation

F5 ADS for Google Cloud supports automatic and manual rotation for Secret Manager certificates:

**Automatic rotation**: Let F5 ADS for Google Cloud pick up new certificate versions automatically with no configuration changes needed. See [Rotate a Secret Manager certificate (automatic)]({{< ref "/f5ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-a-secret-manager-certificate-automatic" >}}).

**Manual rotation**: When you need to update certificates immediately, use **Reapply Configuration** in the console to refetch secrets right away. See [Rotate a Secret Manager certificate (manual)]({{< ref "/f5ads/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-a-secret-manager-certificate-manual" >}}).
