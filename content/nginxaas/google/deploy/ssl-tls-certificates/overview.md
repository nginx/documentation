---
title: Overview
description: "Reference for supported SSL/TLS certificate types and how to add them to an F5 NGINXaaS for Google Cloud deployment."
weight: 50
toc: true
url: /nginxaas/google/deploy/ssl-tls-certificates/overview/
f5-content-type: reference
f5-product: F5 Application Delivery Service for Google Cloud
f5-product-former: NGINXaaS for Google Cloud
canonical: /application-services/google/deploy/ssl-tls-certificates/overview/
f5-ref-path: /f5ads/google/deploy/ssl-tls-certificates/overview/
f5-docs: DOCS-000
f5-keywords: "NGINXaaS for Google Cloud, SSL, TLS, certificates, Google Secret Manager, certificate rotation, PEM, ML-DSA, post-quantum, PQC"
f5-summary: >
  This reference covers the SSL/TLS certificate types and formats F5 NGINXaaS for Google Cloud supports, including post-quantum ML-DSA certificates, and the two ways to manage them: the NGINXaaS Console and Google Secret Manager.
  Use it to choose a certificate management approach and understand automatic and manual rotation options.
f5-audience: operator
---

{{< renamed-notice >}}

Use F5 NGINXaaS for Google Cloud (NGINXaaS) to secure traffic by adding SSL/TLS certificates to a deployment.

## Supported certificate types and formats

NGINX supports the following certificate formats:

- PEM format certificates.

You can upload these certificates as text, as files, or as secrets from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview).

Encrypt your certificates, keys, and PEM files using one of these standards:

- RSA
- ECC/ECDSA
- ML-DSA (post-quantum)

{{< call-out class="note" title="ML-DSA key format support" >}}
When you upload an ML-DSA private key using the NGINXaaS Console, use the seed-only key format.
If you store your ML-DSA key in Google Secret Manager, you can use either the seed-only or seed-priv format.
See [Enable post-quantum cryptography]({{< ref "/nginxaas/google/quickstart/pqc.md" >}}) for configuration guidance.
{{< /call-out >}}

## Add SSL/TLS certificates

NGINXaaS supports two ways to manage your certificates and keys securely:

**NGINXaaS console**: Manage certificates alongside the NGINX configurations that reference them. See [Add certificates using the NGINXaaS Console]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}).

**Google Secret Manager**: Fetch secrets directly from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview), keeping credentials within Google Cloud. See [Add certificates from Secret Manager]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md" >}}).

## Certificate rotation

NGINXaaS supports automatic and manual rotation for Secret Manager certificates:

**Automatic rotation**: Let NGINXaaS pick up new certificate versions automatically with no configuration changes needed. See [Rotate a Secret Manager certificate (automatic)]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-a-secret-manager-certificate-automatic" >}}).

**Manual rotation**: When you need to update certificates immediately, use **Reapply Configuration** in the console to refetch secrets right away. See [Rotate a Secret Manager certificate (manual)]({{< ref "/nginxaas/google/deploy/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md#rotate-a-secret-manager-certificate-manual" >}}).
