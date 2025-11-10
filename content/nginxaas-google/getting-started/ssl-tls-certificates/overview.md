---
title: Overview
weight: 50
toc: true
url: /nginxaas/google/getting-started/ssl-tls-certificates/overview/
type:
- how-to
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

NGINXaaS allows you to upload these certificates as text and as files.

Encrypt your certificates, keys, and PEM files using one of these standards:

- RSA
- ECC/ECDSA

## Add SSL/TLS certificates

Add a certificate to your NGINXaaS deployment using your preferred client tool:

- [Add certificates using the NGINXaaS Console]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/ssl-tls-certificates-console.md" >}})

