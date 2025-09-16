---
title: Overview
weight: 50
toc: true
url: /nginxaas/google/getting-started/ssl-tls-certificates/overview/
type:
- how-to
---


F5 NGINXaaS for Google Cloud (NGINXaaS) enables customers to secure traffic by adding SSL/TLS certificates to a deployment. NGINXaaS can fetch certificates directly from Google Cloud Secret Manager, rotate certificates, and provide observability on the status of your certificates.

This document provides details about using SSL/TLS certificates with your F5 NGINXaaS for Google Cloud deployment.

## Supported certificate types and formats

NGINXaaS supports certificates of the following types:

- Self-signed certificates, Domain Validated (DV) certificates, Organization Validated (OV) certificates, and Extended Validation (EV) certificates.

NGINX supports the following certificate formats:

- PEM format certificates.

The NGINXaaS allows you to upload these certificates as text and as files. You can also upload your own certificate files (with file extensions such as .crt and .key).

Make sure your certificates, keys, and pem files are encrypted to one of the following standards:

- RSA
- ECC/ECDSA


## Add SSL/TLS certificates

Add a certificate to your NGINXaaS deployment using your preferred client tool:
* [Add certificates using the NGINXaaS portal]({{< ref "/nginxaas-google/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}})


## Common certificate errors

The following section describes common errors you might encounter while adding SSL/TLS certificates to your NGINXaaS deployment and how to resolve them.

<details>
<summary><b>Expand to view common certificate errors</b></summary>

#### Error message: `certificate parse error`

**Description:**  The certificate file is not in the correct format or is corrupted.

**Resolution:** Ensure that the certificate file is in PEM format and is not corrupted. You can use tools like OpenSSL to verify the certificate file.

#### Error message: `private key parse error`

**Description:**  The private key file is not in the correct format or is corrupted.

**Resolution:** Ensure that the private key file is in PEM format and is not corrupted. You can use tools like OpenSSL to verify the private key file.

#### Error message: `certificate input is invalid`

**Description:**  The leaf certificate should be provided, when pairing with a private key

**Resolution:** Check the certificate input and ensure that it is in the correct format.

#### Error message: `certificate create request is invalid`

**Description:**  The certificate start date should be before its expiration date.

**Resolution:** Check the certificate start and expiration dates and ensure that they are valid.

#### Error message: `certificate update request is invalid`

**Description:**  The private key cannot be updated for a CA bundle.

**Resolution:** Ensure that you are not trying to update the private key for a CA bundle. If you need to update the private key, you must create a new CA bundle.

</details>
