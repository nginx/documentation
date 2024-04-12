---
description: This guide provides instructions on adding, managing, updating, deleting, and converting remote certificates.
docs: DOCS-821
doctypes:
- tutorial
tags:
- docs
title: Add, Delete, Replace, or Convert Certificates
toc: true
weight: 650
---

{{< shortversions "2.0.0" "latest" "nimvers" >}}

## About Certificates {#about-certificates}

You can add certificates to Instance Manager using the web interface or API. Certificates in Instance Manager are stored in PEM format in an internal secret store. Certificates can be published to NGINX instances, which use certificates to decrypt and encrypt requests and responses.

Instance Manager can import the following types of certificates:

1. `PEM` (Privacy Enhanced Mail): a container format that includes an entire certificate chain including public key, private key, and any intermediate root certificates.
2. `PKCS12` (Public-Key Cryptography Standards): a container format with multiple embedded objects, such as multiple certificates. The contents are base64 encoded.

<br>

---

<br>

## Add Managed Certificates

You need to create a certificate before you can add one to Instance Manager. Use [OpenSSL](https://www.openssl.org) or a similar service to create a certificate.

To add a certificate to Instance Manager, take the following steps:

1. Open the Instance Manager web interface and log in.
1. Under **Modules**, select **Instance Manager**.
1. In the left menu, select **certificates**.
1. Select **Add**.
1. In the **Name** box, type the name for the certificate.
1. Select the import method:

   - **Import PEM or PKCS12** file - Drag and drop the certificate file into the upload section, or select **Browse** to locate and upload the file.
   - **Copy and paste PEM text** - Paste the appropriate certificate contents into the **Private Key**, **Public certificate**, and **Issuing CA certificates** boxes.

1. Select **Add**.

<br>

---

<br>

## Identify Expiring or Expired Certificates {#identify-expiring-or-expired-certificates}

To identify certificates that have expired or are expiring soon, take the following steps:

1. Open the Instance Manager web interface and log in.
1. Under **Modules**, select **Instance Manager**.
1. In the left menu, select **certificates**.

The status of the certificates is either `Expired`, `Expiring`, or `Healthy` along with the expiration date.

A certificate is considered `Expiring` if it's about to expire in fewer than 30 days.

The expiring or expired certificates can be updated with new certificates by selecting **Edit**.

<br>

---

<br>

## Replace Managed Certificates

To replace a certificate using the web interface, take the following steps.

### Web Interface

1. Open the Instance Manager web interface and log in.
2. Under **Modules**, select **Instance Manager**.
3. In the left menu, select **certificates**.
4. Select the certificate you want to replace, then select **Edit**.
5. Paste the appropriate certificate contents into the **Private Key**, **Public certificate**, and **Issuing CA certificates** boxes.
6. Select **Save**.

<br>

### API

Alternatively, to replace a certificate using the Instance Manager API, send a PUT request similar to the following example to the Certificates API endpoint.

```bash
curl -X PUT "https://nginx-manager.example.com/api/platform/v1/certs/pem_cert_with_ca" -H  "accept: application/json" -H "Content-Type: application/json" -d "{  \"name\": \"pem_cert_with_ca\",  \"certPEMDetails\": {  \"type\": \"PEM\",  \"privateKey\": \"-----BEGIN PRIVATE KEY-----<base64-encoded blob>-----END PRIVATE KEY-----\",  \"publicCert\": \"-----BEGIN CERTIFICATE-----<base64-encoded blob>-----END CERTIFICATE-----\",  \"password\": \"\",  \"caCerts\": [\"-----BEGIN CERTIFICATE-----<base64-encoded blob>-----END CERTIFICATE-----\"]},  \"instanceRefs\": [\"/api/platform/v1/systems/56926426-c8c6-1c4e-95b4-418d4a817b42/instances/1de809e5-c186-5367-9957-25dfab5354f5\"]}"
```

<br>

---

<br>

## Delete Managed Certificates {#delete-certs}

### Web Interface

To delete a certificate using the web interface, take the following steps.

1. Open the Instance Manager web interface and log in.
1. Under **Modules**, select **Instance Manager**.
1. In the left menu, select **certificates**.
1. Select the certificate you want to delete, then select **Delete**.

<br>

### API

To delete a certificate using the Instance Manager API, send a DELETE request similar to the following example to the
Certificates API endpoint.

```bash
curl -X DELETE "https://nginx-manager.example.com/api/platform/v1/certs/pem_cert_with_ca" -H  "accept: application/json"
```

<br>

---

<br>

## Convert Remote Cerificates to Managed Certificates

### API

To convert a remote certificate to a managed certificate using the Instance Manager API, send a PUT request to the Certificates API endpoint that includes both the public cert and private key, similar to the following example:

```bash
curl -X PUT "https://nginx-manager.example.com/api/platform/v1/certs/pem_cert_with_ca" -H  "accept: application/json" -H "Content-Type: application/json" -d "{  \"name\": \"pem_cert_with_ca\",  \"certPEMDetails\": {  \"type\": \"PEM\",  \"privateKey\": \"-----BEGIN PRIVATE KEY-----<base64-encoded blob>-----END PRIVATE KEY-----\",  \"publicCert\": \"-----BEGIN CERTIFICATE-----<base64-encoded blob>-----END CERTIFICATE-----\",  \"password\": \"\",  \"caCerts\": [\"-----BEGIN CERTIFICATE-----<base64-encoded blob>-----END CERTIFICATE-----\"]},  \"instanceRefs\": []}"
```

<br>

---

## Rotate Encryption Keys {#rotate-encryption-keys}

To manage certificates securely, you should rotate the encryption keys regularly or when a key has been compromised.

{{< important>}} You must stop the `nms-core` service to rotate keys. Stopping this service is disruptive, so you should plan a downtime window for the rotation.{{< /important >}}

To rotate the certificates encryption key, take the following steps:

1. Open an SSH connection to the NGINX Management Suite host.
2. Run the `sudo systemctl stop nms` command.
3. Run the `sudo runuser -u nms -- nms-core secret rotate` command. This command performs the following steps:

   1. Generates a new 256-bit encryption key.
   2. Reads a certificate using the old key.
   3. Generates a new 192-bit salt.
   4. Re-encrypts the certificate with the new key and salt.
   5. Repeats steps 2-4 until all certificates have been migrated to the new key.
   6. Deletes the old encryption key.

4. Run the `sudo systemctl start nms` command.
