---
doc: null
nd-files:
- content/nim/waf-integration/configuration/install-waf-compiler/automatic-download.md
- content/nim/waf-integration/configuration/setup-signatures-and-threats/automatic-download.md
---

Follow these steps to get and upload the certificate and key:

1. Log in to [MyF5](https://account.f5.com/myf5).
1. Go to **My Products and Plans > Subscriptions**.
1. Download these files from your F5 WAF for NGINX subscription:
   - `nginx-repo.crt` (certificate)
   - `nginx-repo.key` (private key)
1. Create a JSON file that contains both files. Replace each newline (`\n`) in the certificate and key with a literal `\n` so the formatting is correct inside the JSON file.

   **Example request:**

   ```json
   {
     "name": "nginx-repo",
     "nginxResourceType": "NginxRepo",
     "certPEMDetails": {
       "caCerts": [],
       "password": "",
       "privateKey": "-----BEGIN PRIVATE KEY-----\n[content snipped]\n-----END PRIVATE KEY-----\n",
       "publicCert": "-----BEGIN CERTIFICATE-----\n[content snipped]\n-----END CERTIFICATE-----",
       "type": "PEM"
     }
   }
   ```

1. Upload the file to NGINX Instance Manager using the REST API:

   ```shell
   curl -X POST 'https://{{NIM_FQDN}}/api/platform/v1/certs'    --header "Authorization: Bearer <access token>"    --header "Content-Type: application/json"    -d @nginx-repo-certs.json
   ```

1. If successful, you’ll see a response similar to this:

   **Example response:**

   ```json
   {
     "certAssignmentDetails": [],
     "certMetadata": [
       {
         "authorityKeyIdentifier": "<fingerprint>",
         "commonName": "<subscription name>",
         "expired": false,
         "expiry": 59789838,
         "issuer": "C=US, ST=Washington, L=Seattle, Inc., O=F5 Networks\\, OU=Certificate Authority, CN=F5 PRD Issuing Certificate Authority TEEM V1",
         "publicKeyType": "RSA (2048 bit)",
         "serialNumber": "<serial number>",
         "signatureAlgorithm": "SHA256-RSA",
         "subject": "CN=<subscription name>",
         "subjectAlternativeName": "",
         "subjectKeyIdentifier": "<fingerprint>",
         "thumbprint": "<thumbprint>",
         "thumbprintAlgorithm": "SHA256-RSA",
         "validFrom": "2021-12-21T16:57:55Z",
         "validTo": "2024-12-20T00:00:00Z",
         "version": 3
       }
     ],
     "certPEMDetails": {
       "caCerts": [],
       "password": "**********",
       "privateKey": "**********",
       "publicCert": "[content snipped]",
       "type": "PEM"
     },
     "created": "2023-01-27T23:42:41.587760092Z",
     "modified": "2023-01-27T23:42:41.587760092Z",
     "name": "nginx-repo",
     "serialNumber": "<serial number>",
     "uid": "d08d9f54-58dd-447a-a71d-6fa5aa0d880c",
     "validFrom": "2021-12-21T16:57:55Z",
     "validTo": "2024-12-20T00:00:00Z"
   }
   ```
