---
title: Overview
weight: 50
toc: true
url: /nginxaas/google/getting-started/ssl-tls-certificates/overview/
nd-content-type: reference
nd-product: NGOOGL
---


F5 NGINXaaS for Google Cloud (NGINXaaS) enables customers to secure traffic by adding SSL/TLS certificates to a deployment.

This document provides details about using SSL/TLS certificates with your F5 NGINXaaS for Google Cloud deployment.

## Supported certificate types and formats

NGINXaaS supports certificates of the following types:

- Self-signed
- Domain Validated (DV)
- Organization Validated (OV)
- Extended Validation (EV)

NGINX supports the following certificate formats:

- PEM format certificates.

NGINXaaS allows you to upload these certificates as text, as files, and as secrets from [Secret Manager](https://docs.cloud.google.com/secret-manager/docs/overview).

Encrypt your certificates, keys, and PEM files using one of these standards:

- RSA
- ECC/ECDSA

## Add SSL/TLS certificates

Add a certificate to your NGINXaaS deployment using your preferred client tool:

- [Add certificates from Secret Manager]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/ssl-tls-certificates-secret-manager.md" >}})
- [Add certificates using the NGINXaaS Console]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/ssl-tls-certificates-console.md" >}})
