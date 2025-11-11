---
title: Manually update security packages
description: Manually download and upload F5 WAF for NGINX security packages to NGINX Instance Manager.
toc: true
weight: 200
nd-content-type: how-to
nd-product: NIM
nd-docs:
---

If you prefer not to enable automatic updates, you can manually update the attack signature, bot signature, and threat campaign packages by downloading them from the NGINX repository and uploading them to NGINX Instance Manager.

## Download packages from NGINX repository

1. Log in to [MyF5](https://account.f5.com/myf5) and go to **My Products and Plans > Subscriptions**.

1. Download the following files from your F5 WAF for NGINX subscription:
   - `nginx-repo.crt` (certificate)
   - `nginx-repo.key` (private key)

1. Choose your Linux distribution path on the [NGINX repository](https://pkgs.nginx.com/app-protect-security-updates):
   - **Ubuntu:** `/ubuntu/pool/nginx-plus/a/`
   - **Debian:** `/debian/pool/nginx-plus/a/`
   - **RHEL:** `/centos/<8 or 9>/x86_64/RPMS/`

1. Download the `.deb` or `.rpm` packages from [pkgs.nginx.com](https://pkgs.nginx.com) using your F5 WAF for NGINX certificate and key.

   - **Attack signatures:** package names start with `app-protect-attack-signatures`.

     - `.deb` package format:

       ```text
       https://pkgs.nginx.com/app-protect-security-updates/<ubuntu or debian>/pool/nginx-plus/a/app-protect-attack-signatures/app-protect-attack-signatures_<Revision Timestamp in YYYY.MM.DD>-<version>~<OS Family>_amd64.deb
       ```

     - Example:

       ```shell
       curl --key nginx-repo.key \
         --cert nginx-repo.crt \
         "https://pkgs.nginx.com/app-protect-security-updates/ubuntu/pool/nginx-plus/a/app-protect-attack-signatures/app-protect-attack-signatures_2025.07.24-1~noble_amd64.deb" \
         --output app-protect-attack-signatures_2025.07.24-1~noble_amd64.deb
       ```

     - `.rpm` package format:

       ```text
       https://pkgs.nginx.com/app-protect-security-updates/centos/<8 or 9>/x86_64/RPMS/app-protect-attack-signatures-<Revision Timestamp in YYYY.MM.DD>-<version>.el<8 or 9>.ngx.x86_64.rpm
       ```

     - Example:

       ```shell
       curl -v --key nginx-repo.key \
         --cert nginx-repo.crt \
         "https://pkgs.nginx.com/app-protect-security-updates/centos/8/x86_64/RPMS/app-protect-attack-signatures-2025.07.24-1.el8.ngx.x86_64.rpm" \
         --output app-protect-attack-signatures-2025.07.24-1.el8.ngx.x86_64.rpm
       ```

   - **Bot signatures:** package names start with `app-protect-bot-signatures`.

     - `.deb` package format:

       ```text
       https://pkgs.nginx.com/app-protect-security-updates/<ubuntu or debian>/pool/nginx-plus/a/app-protect-bot-signatures/app-protect-bot-signatures_<Revision Timestamp in YYYY.MM.DD>-<version>~<OS Family>_amd64.deb
       ```

     - Example:

       ```shell
       curl --key nginx-repo.key \
         --cert nginx-repo.crt \
         "https://pkgs.nginx.com/app-protect-security-updates/ubuntu/pool/nginx-plus/a/app-protect-bot-signatures/app-protect-bot-signatures_2025.07.09-1~noble_amd64.deb" \
         --output app-protect-bot-signatures_2025.07.09-1~noble_amd64.deb
       ```

     - `.rpm` package format:

       ```text
       https://pkgs.nginx.com/app-protect-security-updates/centos/<8 or 9>/x86_64/RPMS/app-protect-bot-signatures-<Revision Timestamp in YYYY.MM.DD>-<version>.el<8 or 9>.ngx.x86_64.rpm
       ```

     - Example:

       ```shell
       curl -v --key nginx-repo.key \
         --cert nginx-repo.crt \
         "https://pkgs.nginx.com/app-protect-security-updates/centos/8/x86_64/RPMS/app-protect-bot-signatures-2025.07.09-1.el8.ngx.x86_64.rpm" \
         --output app-protect-bot-signatures-2025.07.09-1.el8.ngx.x86_64.rpm
       ```

   - **Threat campaigns:** package names start with `app-protect-threat-campaigns`.

     - `.deb` package format:

       ```text
       https://pkgs.nginx.com/app-protect-security-updates/<ubuntu or debian>/pool/nginx-plus/a/app-protect-threat-campaigns/app-protect-threat-campaigns_<Revision Timestamp in YYYY.MM.DD>-<version>~<OS Family>_amd64.deb
       ```

     - Example:

       ```shell
       curl --key nginx-repo.key \
         --cert nginx-repo.crt \
         "https://pkgs.nginx.com/app-protect-security-updates/ubuntu/pool/nginx-plus/a/app-protect-threat-campaigns/app-protect-threat-campaigns_2025.07.29-1~noble_amd64.deb" \
         --output app-protect-threat-campaigns_2025.07.29-1~noble_amd64.deb
       ```

     - `.rpm` package format:

       ```text
       https://pkgs.nginx.com/app-protect-security-updates/centos/<8 or 9>/x86_64/RPMS/app-protect-threat-campaigns-<Revision Timestamp in YYYY.MM.DD>-<version>.el<8 or 9>.ngx.x86_64.rpm
       ```

     - Example:

       ```shell
       curl -v --key nginx-repo.key \
         --cert nginx-repo.crt \
         "https://pkgs.nginx.com/app-protect-security-updates/centos/8/x86_64/RPMS/app-protect-threat-campaigns-2025.07.29-1.el8.ngx.x86_64.rpm" \
         --output app-protect-threat-campaigns-2025.07.29-1.el8.ngx.x86_64.rpm
       ```

2. Extract the following files from the package:
   - `signatures.bin.tgz`, `bot_signatures.bin.tgz`, or `threat_campaigns.bin.tgz`
   - `signature_update.yaml`, `bot_signature_update.yaml`, or `threat_campaign_update.yaml`
   - `version`

   Use `rpm2cpio | cpio` for `.rpm` packages or `ar` for `.deb` packages to extract the files.

3. Create a `.tgz` bundle that includes the three files. For example:

   ```shell
   tar -czvf attack-signatures.tgz signatures.bin.tgz signature_update.yaml version

## Upload packages to NGINX Instance Manager

Use the NGINX Instance Manager REST API to upload the `.tgz` files.

**Upload attack signatures**

```shell
curl -X POST 'https://{{NIM_FQDN}}/api/platform/v1/security/attack-signatures' \
  --header "Authorization: Bearer <access token>" \
  --form 'revisionTimestamp="2022.11.16"' \
  --form 'filename=@"/attack-signatures.tgz"'
```

**Upload bot signatures**

```shell
curl -X POST 'https://{{NIM_FQDN}}/api/platform/v1/security/bot-signatures' \
  --header "Authorization: Bearer <access token>" \
  --form 'revisionTimestamp="2025.07.09"' \
  --form 'filename=@"/bot-signatures.tgz"'
```

**Upload threat campaigns**

```shell
curl -X POST 'https://{{NIM_FQDN}}/api/platform/v1/security/threat-campaigns' \
  --header "Authorization: Bearer <access token>" \
  --form 'revisionTimestamp="2022.11.15"' \
  --form 'filename=@"/threat-campaigns.tgz"'
```

{{< call-out "important" >}}
The bundle you upload must match both the operating system and version of your NGINX Instance Manager host.  
Create the `.tgz` file using the package built for the same OS and version to ensure compatibility.
{{< /call-out >}}