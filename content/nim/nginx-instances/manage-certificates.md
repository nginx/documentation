---
nd-docs: DOCS-821
title: Manage SSL certificates
toc: true
weight: 650
type:
- tutorial
---

{{< include "nim/decoupling/note-legacy-nms-references.md" >}}

## About certificates {#about-certificates}

You can add certificates to **F5 NGINX Instance Manager** using the web interface or the REST API. Certificates in NGINX Instance Manager are stored in PEM format in an internal secret store. They can be published to NGINX instances, which use certificates to encrypt and decrypt requests and responses.

NGINX Instance Manager can import the following types of certificates:

1. **PEM** (Privacy Enhanced Mail): A container format that includes an entire certificate chain, including the public key, private key, and any intermediate root certificates.
2. **PKCS12** (Public-Key Cryptography Standards): A container format with multiple embedded objects, such as multiple certificates. The contents are base64-encoded.

---

## Add managed certificates

You need to create a certificate before you can add one to NGINX Instance Manager. Use [OpenSSL](https://www.openssl.org) or a similar service to create the certificate.

If you’re uploading a **PKCS12** certificate, make sure to encode it in base64 before adding it to NGINX Instance Manager. Use the following command to encode the certificate:

   ```bash
    cat <filename>.pkcs12 | base64 > <new-filename>.pkcs12
   ```

To add a certificate to NGINX Instance Manager, take the following steps:

1. Open the NGINX Instance Manager web interface and log in.
2. Under **Modules**, select **Instance Manager**.
3. In the left menu, select **Certificates**.
4. Select **Add**.
5. In the **Name** box, enter a name for the certificate.
6. Choose the import method:
   - **Import PEM or PKCS12 file**: Drag and drop the certificate file into the upload section, or select **Browse** to find and upload the file.
   - **Copy and paste PEM text**: Paste the appropriate certificate contents into the **Private Key**, **Public Certificate**, and **Issuing CA Certificates** boxes.
7. Select **Add**.

---

## Identify expiring or expired certificates {#identify-expiring-or-expired-certificates}

To identify certificates that are expired or expiring soon:

1. Open the NGINX Instance Manager web interface and log in.
2. Under **Modules**, select **Instance Manager**.
3. In the left menu, select **Certificates**.

You will see the status of certificates as either `Expired`, `Expiring`, or `Healthy`, along with the expiration date. A certificate is considered `Expiring` if it will expire in fewer than 30 days.

To update expiring or expired certificates, select **Edit** and provide the new certificate details.

---

## Replace managed certificates

#### Web interface

To replace a certificate using the web interface:

1. Open the NGINX Instance Manager web interface and log in.
2. Under **Modules**, select **Instance Manager**.
3. In the left menu, select **Certificates**.
4. Select the certificate you want to replace, then select **Edit**.
5. Paste the appropriate certificate contents into the **Private Key**, **Public Certificate**, and **Issuing CA Certificates** boxes.
6. Select **Save**.

#### API

{{<call-out "tip" "Using the NGINX Instance Manager REST API" "">}}{{< include "nim/how-to-access-nim-api.md" >}}{{</call-out>}}

To replace a certificate using the NGINX Instance Manager REST API, send a `PUT` request like the following to the Certificates API endpoint:

```bash
curl -X PUT "https://nginx-manager.example.com/api/platform/v1/certs/pem_cert_with_ca" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "pem_cert_with_ca",
    "certPEMDetails": {
      "type": "PEM",
      "privateKey": "-----BEGIN PRIVATE KEY-----<base64-encoded blob>-----END PRIVATE KEY-----",
      "publicCert": "-----BEGIN CERTIFICATE-----<base64-encoded blob>-----END CERTIFICATE-----",
      "password": "",
      "caCerts": [
        "-----BEGIN CERTIFICATE-----<base64-encoded blob>-----END CERTIFICATE-----"
      ]
    },
    "instanceRefs": [
      "/api/platform/v1/systems/<system-uuid>/instances/<instance-uuid>"
    ]
  }'
  ```

---

## Delete managed certificates {#delete-certs}

#### Web interface

To delete a certificate using the web interface:

1. Open the NGINX Instance Manager web interface and log in.
2. Under **Modules**, select **Instance Manager**.
3. In the left menu, select **Certificates**.
4. Select the certificate you want to delete, then select **Delete**.

#### API

To delete a certificate using the NGINX Instance Manager REST API, send a `DELETE` request like the following to the Certificates API endpoint:

```bash
curl -X DELETE "https://nginx-manager.example.com/api/platform/v1/certs/pem_cert_with_ca" \
  -H "accept: application/json"
```

---

## Convert remote certificates to managed certificates

#### API

To convert a remote certificate to a managed certificate using the NGINX Instance Manager REST API, send a `PUT` request to the Certificates API endpoint. This request should include both the public certificate and private key, like in the following example:

```bash
curl -X PUT "https://nginx-manager.example.com/api/platform/v1/certs/pem_cert_with_ca" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "pem_cert_with_ca",
    "certPEMDetails": {
      "type": "PEM",
      "privateKey": "-----BEGIN PRIVATE KEY-----<base64-encoded blob>-----END PRIVATE KEY-----",
      "publicCert": "-----BEGIN CERTIFICATE-----<base64-encoded blob>-----END CERTIFICATE-----",
      "password": "",
      "caCerts": [
        "-----BEGIN CERTIFICATE-----<base64-encoded blob>-----END CERTIFICATE-----"
      ]
    },
    "instanceRefs": []
  }'
 ```

---

## Rotate encryption keys {#rotate-encryption-keys}

To manage certificates securely, you should rotate encryption keys regularly or when a key is compromised.

{{< call-out "important" "Service Disruption Warning" "fas fa-exclamation-triangle" >}}You must stop the `nms-core` service to rotate keys. Stopping this service is disruptive, so you should plan a downtime window for the rotation.{{< /call-out >}}

To rotate the certificate encryption key:

1. Open an SSH connection to the F5 NGINX Management Suite host.
2. Run the following command to stop the `nms` service:

      ```bash
      sudo systemctl stop nms
      ```

3.	Run the following command to rotate the encryption keys:

      ```bash
      sudo runuser -u nms -- nms-core secret rotate
      ```

      This command performs the following steps:

   	1.	Generates a new 256-bit encryption key.
   	2.	Reads the certificates using the old key.
   	3.	Generates a new 192-bit salt.
   	4.	Re-encrypts the certificates with the new key and salt.
   	5.	Repeats steps 2–4 for all certificates.
   	6.	Deletes the old encryption key.

4. Now that you've rotated encryption keys, start the `nms` service:

   ```bash
   sudo systemctl start nms
   ```
