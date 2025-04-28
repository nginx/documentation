---
title: Set up WAF configuration management
weight: 200
toc: true
description: Learn how to set up F5 NGINX Instance Manager to manage NGINX App Protect WAF configurations, including compiler installation, security policy onboarding, and threat update management.
type: how-to
product: NIM
docs: DOCS-996
---

## Overview

F5 NGINX Instance Manager helps you manage your NGINX App Protect WAF configurations, making it easier to stay secure. This guide walks you through how to set up NGINX Instance Manager to configure and manage NGINX App Protect WAF.

### Before you begin

Make sure you've completed the following prerequisites before you get started:

- You have one or more [NGINX App Protect WAF]({{< ref "/nap-waf/" >}}) instances running. For supported versions, see [Support for NGINX App Protect WAF]({{< ref "/nim/fundamentals/tech-specs.md#support-for-nginx-app-protect-waf" >}}).

  {{<note>}}If you're using configuration management and Security Monitoring, follow the steps in the [setup guide]({{< ref "/nim/nginx-app-protect/security-monitoring/set-up-app-protect-instances.md" >}}) to set up your NGINX App Protect WAF instances first.{{</note>}}

- You're running NGINX Instance Manager v2.6.0 or later. Make sure it's [installed]({{< ref "/nim/deploy/vm-bare-metal/_index.md" >}}), licensed, and running.

  If you have a subscription to NGINX App Protect WAF, you can find your license in the subscription details section of [MyF5](https://my.f5.com).

### Limitations

NGINX Instance Manager doesn’t support the following NGINX App Protect WAF features:

- [Policies with external references]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#external-references" >}})
- Custom signatures

---

## Install the WAF compiler

NGINX Instance Manager can use the WAF compiler to precompile security configurations before deploying them to NGINX App Protect WAF instances. Precompiling configurations improves performance and reduces the risk of runtime errors.

Install the WAF compiler on the NGINX Instance Manager host only if you plan to compile configurations on the management plane. If you’ll compile on the data plane, you can skip this step.

Each version of NGINX App Protect WAF has a matching WAF compiler version. If you're managing multiple versions, install the corresponding WAF compiler for each one on the NGINX Instance Manager host.

The WAF compiler installs to the `/opt` directory. Make sure this directory has the correct permissions so the owner can write to it. A permission setting like `0755` is typically sufficient.

To keep track of instances running the same version, you can create [instance groups]({{< ref "/nim/nginx-instances/manage-instance-groups" >}}).

For an overview of how the WAF compiler works, see the [Security bundle compilation]({{< ref "/nim/nginx-app-protect/overview-nap-waf-config-management#security-bundle" >}}) topic.

### WAF compiler and supported NGINX App Protect WAF versions {#nap-waf-compiler-compatibility}

The table below shows which WAF compiler version to use for each version of NGINX App Protect WAF:

{{<bootstrap-table "table table-striped table-bordered">}}

| NGINX App Protect WAF version | WAF compiler version       |
|-------------------------------|----------------------------|
| 5.6.0                         | nms-nap-compiler-v5.342.0  |
| 5.5.0                         | nms-nap-compiler-v5.264.0  |
| 5.4.0                         | nms-nap-compiler-v5.210.0  |
| 5.3.0                         | nms-nap-compiler-v5.144.0  |
| 5.2.0                         | nms-nap-compiler-v5.48.0   |
| 5.1.0                         | nms-nap-compiler-v5.17.0   |
| 4.14.0                        | nms-nap-compiler-v5.342.0  |
| 4.13.0                        | nms-nap-compiler-v5.264.0  |
| 4.12.0                        | nms-nap-compiler-v5.210.0  |
| 4.11.0                        | nms-nap-compiler-v5.144.0  |
| 4.10.0                        | nms-nap-compiler-v5.48.0   |
| 4.9.0                         | nms-nap-compiler-v5.17.0   |
| 4.8.1                         | nms-nap-compiler-v4.815.0  |
| 4.8.0                         | nms-nap-compiler-v4.762.0  |
| 4.7.0                         | nms-nap-compiler-v4.641.0  |
| 4.6.0                         | nms-nap-compiler-v4.583.0  |
| 4.5.0                         | nms-nap-compiler-v4.457.0  |
| 4.4.0                         | nms-nap-compiler-v4.402.0  |
| 4.3.0                         | nms-nap-compiler-v4.279.0  |
| 4.2.0                         | nms-nap-compiler-v4.218.0  |
| 4.1.0                         | nms-nap-compiler-v4.100.1  |
| 4.0.0                         | nms-nap-compiler-v4.2.0    |
| 3.12.2                        | nms-nap-compiler-v3.1088.2 |

{{</bootstrap-table>}}

### Debian or Ubuntu

To install the WAF compiler on Debian or Ubuntu, run the following command:

```shell
sudo apt-get install nms-nap-compiler-v5.342.0
```

If you want to install more than one version of the WAF compiler on the same system, append the `--force-overwrite` option to the install command after the first installation:

```shell
sudo apt-get install nms-nap-compiler-v5.342.0 -o Dpkg::Options::="--force-overwrite"
```

{{< include "nim/nap-waf/restart-nms-integrations.md" >}}

### RHEL 8.1 or later

To install the WAF compiler on RHEL 8.1 or later:

1. Download the `dependencies.repo` file to the `/etc/yum.repos.d` directory:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
   ```

2. Enable the CodeReady Builder repository:

   ```shell
   sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
   ```

3. Install the WAF compiler:
   
   ```shell
   sudo yum install nms-nap-compiler-v5.342.0
   ```

4. {{< include "nim/nap-waf/restart-nms-integrations.md" >}}

### RHEL 7.4 or later; CentOS

To install the WAF compiler on RHEL 7.4 or later or CentOS:

1. Download the `dependencies.repo` file to the `/etc/yum.repos.d` directory:

    ```shell
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
    ```

2. Enable the RHEL 7 server repositories:

    ```shell
    sudo yum-config-manager --enable rhui-REGION-rhel-server-optional rhui-REGION-rhel-server-releases rhel-7-server-optional-rpms
    ```

3. Install the WAF compiler:

    ```shell
    sudo yum install nms-nap-compiler-v5.342.0
    ```

4.	{{< include "nim/nap-waf/restart-nms-integrations.md" >}}

### Amazon Linux 2 LTS

To install the WAF compiler on Amazon Linux 2 LTS:

1. Download the required repo files to the `/etc/yum.repos.d` directory:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms-amazon2.repo
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
   ```

2. Enable the Extra Packages for Enterprise Linux (EPEL) repository:

    ```shell
    sudo amazon-linux-extras enable epel
    sudo yum clean metadata
    sudo yum install epel-release
    ```

3. Install the WAF compiler:

    ```shell
    sudo yum install nms-nap-compiler-v5.342.0
    ```

4. {{< include "nim/nap-waf/restart-nms-integrations.md" >}}


### Oracle Linux 7.4 or later

To install the WAF compiler on Oracle Linux 7.4 or later:

1. Download the `dependencies.repo` file to the `/etc/yum.repos.d` directory:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
   ```

2. Enable the `ol8_codeready_builder` repository:
   
   ```shell
   sudo yum-config-manager --enable ol8_codeready_builder
   ```

3. Install the WAF compiler:

    ```shell
    sudo yum install nms-nap-compiler-v5.342.0
    ```

4. {{< include "nim/nap-waf/restart-nms-integrations.md" >}}


### Download from MyF5

If you can’t access the public NGINX repository, you can manually download the WAF compiler from [MyF5](https://my.f5.com/).

To install the WAF compiler manually:

1. Log in to [MyF5](https://my.f5.com).
2. Go to **Resources** > **Downloads**.
3. Select the following:
   - **Group/Product Family**: **NGINX**
   - **Product Line**: **NGINX App Protect**
   - Choose a **Product version** that matches your environment
   - Select the **Linux distribution**, **version**, and **architecture**
4. Download the appropriate `.deb` or `.rpm` WAF compiler file.
5. Transfer the file to your NGINX Instance Manager host.
6. Install the WAF compiler:

    - **Debian or Ubuntu**

        ```shell
        sudo apt-get install -f /path/to/nms-nap-compiler-<version>_focal_amd64.deb
        ```

        To install multiple versions, use:

        ```shell
        sudo apt-get install -f /path/to/nms-nap-compiler-<version>_focal_amd64.deb -o Dpkg::Options::="--force-overwrite"
        ```

    - **RHEL, CentOS, or Oracle Linux**

        ```shell
        sudo yum install -f /path/to/nms-nap-compiler-<version>_el8.ngx.x86_64.rpm
        ```

7. {{< include "nim/nap-waf/restart-nms-integrations.md" >}}

### Automatically download and install new WAF compiler

After you manually install at least one version of the NGINX App Protect WAF compiler, NGINX Instance Manager can automatically download and install additional versions as needed.

This typically happens when:

- A managed instance is upgraded to a new NGINX App Protect WAF version.
- You add a new instance running a different version of NGINX App Protect WAF.

To enable this automatic download feature, you need to [upload your NGINX App Protect WAF certificate and key](#upload-nginx-app-protect-waf-certificate-and-key) to NGINX Instance Manager. This step allows Instance Manager to securely connect to the NGINX package repository and retrieve the necessary files. You only need to upload the certificate and key once.

If the certificate is missing or invalid, or if NGINX Instance Manager can’t connect to the repository, you’ll see an error like:

```text
missing the specific compiler, please install it and try again.
```

This usually means the certificate and key are missing or incorrect, or that NGINX Instance Manager can’t connect to the NGINX repository.

Check the log file for errors:

```text
/var/log/nms/nms.log
```

If you see the following message, your certificate and key might be invalid or expired:

```text
error when creating the nginx repo retriever - NGINX repo certificates not found
```

If needed, you can also [install the WAF compiler manually](#install-the-waf-compiler).

---

## Set up attack signatures and threat campaigns

NGINX App Protect WAF protects your applications using predefined and regularly updated detection patterns:

- **Attack signatures**: Known threat patterns used to detect common vulnerabilities and exploits. These are included with NGINX App Protect WAF and updated frequently to reflect the latest security threats. See the [attack signatures documentation]({{< ref "nap-waf/v5/configuration-guide/configuration.md#attack-signatures-overview" >}}) for more information.

- **Threat campaigns**: Context-aware threat intelligence based on attack campaigns observed by F5 Threat Labs. These are updated even more frequently than attack signatures and require installation to take effect. Learn more in the [threat campaigns documentation]({{< ref "nap-waf/v5/configuration-guide/configuration.md#threat-campaigns" >}}).

To take advantage of the latest updates, you must upload the attack signature and threat campaign packages to NGINX Instance Manager.

You can either:

- Configure NGINX Instance Manager to automatically download new versions, or
- Manually download packages from MyF5 and upload them to NGINX Instance Manager using the REST API.

### Automatically Download Latest Packages {#automatically-download-latest-packages}

#### Upload the NGINX App Protect WAF certificate and key

To enable automatic downloads, NGINX Instance Manager must authenticate with the NGINX repository. You do this by uploading the NGINX repository certificate and private key that come with your NGINX App Protect WAF subscription. Once uploaded, NGINX Instance Manager can securely retrieve the latest attack signature and threat campaign packages on your behalf.

Follow these steps to get and upload the certificate and key:

1. Log in to [MyF5](https://account.f5.com/myf5).
2. Go to **My Products and Plans > Subscriptions**.
3. Download the following files from your NGINX App Protect WAF subscription:
   - `nginx-repo.crt` (certificate)
   - `nginx-repo.key` (private key)
4. Create a JSON file that includes the contents of both files. Replace newlines (`\n`) in each file with literal `\n` characters so the certificate and key can be formatted correctly inside the JSON.

   <details open>
   <summary>Example request</summary>

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

   </details>

5. Upload the file to NGINX Instance Manager using the REST API:

    ```shell
    curl -X POST 'https://{{NIM_FQDN}}/api/platform/v1/certs' \
    --header "Authorization: Bearer <access token>" \
    --header "Content-Type: application/json" \
    -d @nginx-repo-certs.json
    ```

6. If successful, you should see a response similar to this:

    <details open>
    <summary>Example response</summary>

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

#### Enable automatic downloads

NGINX Instance Manager can automatically download the latest Attack Signatures and Threat Campaign versions. To enable automatic downloads:

1. Log in to the NGINX Instance Manager host using SSH.

2. Open the `/etc/nms/nms.conf` file in a text editor.

3. Adjust the `app_protect_security_update` settings, as shown in the example below:

    ```yaml
    integrations:
      # enable this for integrations on tcp
      # address: 127.0.0.1:8037
      address: unix:/var/run/nms/integrations.sock
      dqlite:
        addr: 127.0.0.1:7892
      app_protect_security_update:
        # enable this to automatically retrieve the latest Attack Signatures and Threat Campaigns
        enable: true
        # how often, in hours, to check for updates; default is 6
        interval: 6
        # how many updates to download; default is 10, max is 20
        number_of_updates: 10
    ```

4. Save the changes and close the file.

5. {{< include "/nim/nap-waf/restart-nms-integrations.md" >}}

If the NGINX App Protect WAF certificate and key are missing, invalid, or expired, you’ll see the following error:

```text
error when creating the nginx repo retriever - NGINX repo certificates not found
```

This means NGINX Instance Manager can’t connect to the NGINX repository to retrieve the packages. You may need to re-upload a valid certificate and key to resolve the issue.

### Manually update packages

If you prefer not to enable automatic updates, you can manually update the Attack Signature and Threat Campaign packages by downloading them from MyF5 and uploading them to NGINX Instance Manager.

#### Download packages from MyF5

1. Log in to [MyF5](https://my.f5.com), then go to **Resources > Downloads**.

2. Select the following options in the product menu:
    - **Group/Product Family**: *NGINX*
    - **Product Line**: *NGINX App Protect*
    - **Product Version**: Choose a version that matches your WAF compiler version.
    - Select your **Linux Distribution**, **Version**, and **Architecture**.

3. Download the `.deb` or `.rpm` packages:
    - For Attack Signatures: package starts with `app-protect-attack-signatures`
    - For Threat Campaigns: package starts with `app-protect-threat-campaigns`

4. Extract the following three files from the package:
    - `signatures.bin.tgz` (or `threat_campaigns.bin.tgz`)
    - `signature_update.yaml` (or `threat_campaign_update.yaml`)
    - `version`

    Use tools like `rpm2cpio | cpio` or `ar` (for `.deb`) to extract the files.

5. Create a `.tgz` bundle that includes the three files. For example:

    ```shell
    tar -czvf attack-signatures.tgz signatures.bin.tgz signature_update.yaml version
    ```

#### Upload packages to NGINX Instance Manager

Use the NGINX Instance Manager REST API to upload the `.tgz` files.

**Upload Attack Signatures:**

```shell
curl -X POST 'https://{{NIM_FQDN}}/api/platform/v1/security/attack-signatures' \
  --header "Authorization: Bearer <access token>" \
  --form 'revisionTimestamp="2022.11.16"' \
  --form 'filename=@"/attack-signatures.tgz"'
```

**Upload Threat Campaigns:**

```shell
curl -X POST 'https://{{NIM_FQDN}}/api/platform/v1/security/threat-campaigns' \
  --header "Authorization: Bearer <access token>" \
  --form 'revisionTimestamp="2022.11.15"' \
  --form 'filename=@"/threat-campaigns.tgz"'
```

{{<important>}}The bundle you upload must match the OS of your NGINX Instance Manager host. For example, if the host is running Ubuntu 20.04, create the `.tgz` from the Ubuntu 20.04 package.{{</important>}}

### Update the Security Monitoring signature database

The Security Monitoring dashboards in NGINX Instance Manager rely on a Signature Database to show more information about triggered security violations, such as the signature's name, accuracy, and risk level.

To keep the dashboards accurate and up to date, you need to update the Security Monitoring signature database.

For instructions, see the [update signatures guide]({{< ref "/nim/nginx-app-protect/security-monitoring/update-signatures.md" >}}).

---

## Set up compiler resource pruning

You can configure NGINX Instance Manager to automatically remove unused compiler resources:

- Compiled security policies
- Compiled security log profiles
- Attack Signatures
- Threat Campaigns

Only the compiled bundles are removed. NGINX Instance Manager does not delete the definitions for security policies or log profiles.

To enable compiler resource pruning:

1. Log in to the NGINX Instance Manager host using SSH.
2. Open the `/etc/nms/nms.conf` file in a text editor.
3. Update the `policy_manager` section under `integrations` with time-to-live (TTL) values for each resource type:

   ```yaml
   integrations:
     address: unix:/var/run/nms/integrations.sock
     dqlite:
       addr: 127.0.0.1:7892
     policy_manager:
       # Time to live for attack signatures. If the attack signatures exceed their TTL and are not
       # deployed to an instance or instance group, they will be deleted from the database.
       # Duration unit can be seconds (s), minutes (m), or hours (h).
       attack_signatures_ttl: 336h

       # Time to live for compiled bundles, including compiled security policies and log profiles.
       # If a compiled bundle exceeds its TTL and is not deployed to an instance or instance group,
       # it will be deleted from the database. The bundle is deleted, not the resource definition.
       compiled_bundles_ttl: 336h

       # Time to live for threat campaigns. If the threat campaigns exceed their TTL and are not
       # deployed to an instance or instance group, they will be deleted from the database.
       threat_campaigns_ttl: 1440h

     app_protect_security_update:
       enable: true
       interval: 6
       number_of_updates: 10
    ```

4. Save the file and close the editor.
5. {{< include "nim/nap-waf/restart-nms-integrations.md" >}}

NGINX Instance Manager runs the pruning process at startup and every 24 hours after the `nms-integrations` service starts.

---

## Onboard NGINX App Protect WAF instances

To onboard your NGINX App Protect WAF instances to NGINX Instance Manager, install and configure the NGINX Agent on each instance.

### Install NGINX Agent

1. Use SSH to connect to the NGINX App Protect WAF instance. Repeat these steps for each instance you want to onboard.

2. Download the NGINX Agent package from the NGINX Instance Manager host and run the installation script.

   You can group instances that use the same version of NGINX App Protect WAF by using the optional `--instance-group` flag in the install command.

   {{< include "agent/installation/install-agent-api.md" >}}


### Configure NGINX Agent

1. Edit the NGINX Agent configuration file to enable support for NGINX App Protect WAF:

    ```shell
    sudo vi /etc/nginx-agent/nginx-agent.conf
    ```

2. Update or confirm the following settings:

    ```yaml
    config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"
    extensions:
      - nginx-app-protect
    nginx_app_protect:
      report_interval: 15s
      precompiled_publication: true
    ```

    These settings:

    - Allow the agent to access NGINX App Protect WAF configuration directories.
    - Enable the agent to detect changes in security configurations.
    - Enable support for precompiled publication of WAF configurations from NGINX Instance Manager.

    You can also apply these settings automatically during installation by using the `--nginx-app-protect-mode` flag:

    ```shell
    curl https://<NMS_FQDN>/install/nginx-agent > install.sh
    sudo sh ./install.sh --nginx-app-protect-mode precompiled-publication
    ```

3. Restart NGINX Agent:

    ```shell
    sudo systemctl restart nginx-agent
    ```



### Verify installation

After installing and configuring the NGINX Agent, verify that your NGINX App Protect WAF instances appear in NGINX Instance Manager.


{{<tabs name="agent-verify">}}

{{%tab name="UI"%}}

You should now be able to view your NGINX App Protect WAF instances in the Instance Manager user interface. Take the steps below to verify that NGINX Agent is installed and reporting data to Instance Manager.

1. {{< include "nim/webui-nim-login.md" >}}
2. In the left menu, select **Instances**.
3. Confirm that each instance shows an NGINX App Protect WAF version in the **NGINX App Protect** column.
4. Select an instance and scroll to the **App Protect Details** section to confirm status and build information.

{{%/tab%}}

{{%tab name="API"%}}

{{< see-also >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /see-also >}}

Use the REST API to confirm the version and status of NGINX App Protect WAF:

{{<bootstrap-table "table">}}

| Method | Endpoint                     |
|--------|------------------------------|
| GET    | `/api/platform/v1/instances` |
| GET    | `/api/platform/v1/systems`   |

{{</bootstrap-table>}}


- Send a `GET` request to `/api/platform/v1/systems` to check version info:

    **Example response:**

    ```json
    {
      "count": 3,
      "items": [
        {
          "appProtect": {
            "attackSignatureVersion": "2022.11.16",
            "status": "active",
            "threatCampaignVersion": "2022.11.15",
            "version": "build-3.954.0"
          }
        }
      ]
    }
    ```

- Send a `GET` request to `/api/platform/v1/instances` to check how many instances have NGINX App Protect WAF installed:

    **Example response:**

    ```json
    {
    "count": 3,
    "items": [
        [...]
    ],
    "nginxAppProtectWAFCount": 2,
    "nginxPlusCount": 3
    }
    ```

{{%/tab%}}
{{</tabs>}}

### Configure Docker Compose for NGINX App Protect WAF v5

#### Before you begin

Before configuring Docker Compose, make sure you’ve completed the following steps:

- Installed NGINX App Protect WAF v5 using the [official installation guide]({{< ref "/nap-waf/v5/admin-guide/install.md" >}}).
- Created a `docker-compose.yaml` file during the installation process.

This section explains how to modify that file so NGINX App Protect WAF can work with NGINX Instance Manager.

#### Edit the Docker Compose file

1. Edit the `docker-compose.yaml` file created during installation.

   To give NGINX App Protect WAF access to the policy and log profile bundles written by NGINX Instance Manager, make the following changes:

   - Add the line `user: 101:<group-id>` to each service. The group ID should match the NGINX Agent group on your system. You can find the group ID by running:

        ```shell
        cat /etc/group
        ```

   - Add `/etc/nms` to the volume maps for both services.

        **Example:**

        ```yaml
        version: "3.9"

        services:
          waf-enforcer:
            container_name: waf-enforcer
            image: private-registry.nginx.com/nap/waf-enforcer:5.2.0
            user: 101:1002
            environment:
              - ENFORCER_PORT=50000
            ports:
              - "50000:50000"
            volumes:
              - /opt/app_protect/bd_config:/opt/app_protect/bd_config
              - /etc/nms:/etc/nms
            networks:
              - waf_network
            restart: always

          waf-config-mgr:
            container_name: waf-config-mgr
            image: private-registry.nginx.com/nap/waf-config-mgr:5.2.0
            user: 101:1002
            volumes:
              - /opt/app_protect/bd_config:/opt/app_protect/bd_config
              - /opt/app_protect/config:/opt/app_protect/config
              - /etc/app_protect/conf:/etc/app_protect/conf
              - /etc/nms:/etc/nms
            restart: always
            network_mode: none
            depends_on:
              waf-enforcer:
                condition: service_started

        networks:
          waf_network:
            driver: bridge
        ```

2. Restart the containers:

    ```shell
    docker compose restart
    ```

---

## Onboard security policies {#onboard-security-policies}

NGINX Instance Manager provides the same [default security policies](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-configuration) as NGINX App Protect WAF:

- **NGINX Default Policy**: Provides [OWASP Top 10](https://owasp.org/www-project-top-ten/) and Bot protection.
- **NGINX Strict Policy**: Contains more restrictive blocking criteria than the default policy.

If you plan to use these built-in policies, you can skip to [Add WAF configuration to NGINX instances](#add-waf-config).

If you’ve created custom security policies on your NGINX App Protect WAF instances, you can upload them to NGINX Instance Manager using the REST API. These policies must be uploaded so NGINX Instance Manager can compile and publish them across your data plane.

### Upload custom security policies

To upload a policy, follow these steps:

1. Encode the JSON policy using `base64`.

   **Example:**

   ```shell
   base64 -i ./ignore-xss-policy-example.json
   ```

2. Create a JSON request that includes the base64-encoded policy from step 1 as the value for the `content` field.
   
   Replace the example string below with the actual base64-encoded output you generated.

    ```json
    {
      "metadata": {
        "name": "ignore-xss-example",
        "displayName": "Ignore cross-site scripting example",
        "description": "Security policy that intentionally ignores cross-site scripting"
      },
      "content": "<base64-encoded-policy>"
    }
    ```

3. Send the request to the Instance Manager REST API to create the policy:

    ```shell
    curl -X POST https://<NIM_FQDN>/api/platform/v1/security/policies \
    -H "Authorization: Bearer <access token>" \
    -H "Content-Type: application/json" \
    -d @policy.json
    ```

    You should receive a success response with the policy metadata.

4. To verify that your policy was successfully onboarded, send a GET request:

    ```shell
    curl -X GET https://<NIM_FQDN>/api/platform/v1/security/policies \
    -H "Authorization: Bearer <access token>"
    ```

    The response includes a list of all security policies managed by NGINX Instance Manager.

---

## Add WAF configuration to NGINX instances {#add-waf-config}

The [NGINX App Protect WAF configuration guide](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-configuration-overview) shows where and how to add security directives to your NGINX configuration. NGINX Instance Manager includes the same default security policies as NGINX App Protect WAF:

- **NGINX Default Policy**: Provides [OWASP Top 10](https://owasp.org/www-project-top-ten/) and bot protection out of the box.
- **NGINX Strict Policy**: Contains more restrictive criteria for blocking traffic, with a higher risk of false positives.

You can use these default policies as-is or customize them for your app. Security Monitoring dashboards can help you fine-tune policy settings.

Keep the following in mind when configuring NGINX App Protect WAF through NGINX Instance Manager:

- Instance Manager compiles JSON security policies into `.tgz` bundles.
- Use the `app_protect_policy_file` directive to reference custom policies.

  If you're using precompiled publication with NGINX Agent, make sure to change the file extension from `.json` to `.tgz`. The filename remains the same. NGINX Instance Manager doesn't support referencing both `.json` and `.tgz` in the same NGINX configuration.

- If you're using custom policies, make sure NGINX Agent has permission to access the directories where those policy files are stored. Update the `config_dirs` setting in the NGINX Agent's configuration file if needed.
- NGINX Instance Manager uses the default log profiles that come with NGINX App Protect WAF. You can reference them with the `app_protect_security_log` directive. Custom log profiles aren't supported.

If you're using different directories on the data plane, update paths accordingly in your NGINX configuration.

### Edit the NGINX configuration

Add the NGINX App Protect WAF directives in the appropriate context (`http`, `server`, or `location`). Here's an example:

```nginx
server {
  ...

  location / {
    # Enable NGINX App Protect WAF
    app_protect_enable on;

    # Reference a custom security policy bundle
    app_protect_policy_file /etc/nms/ignore-xss.tgz;

    # Enable security logging
    app_protect_security_log_enable on;

    # Reference the log profile bundle
    app_protect_security_log /etc/nms/log-default.tgz /var/log/nginx/security-violations.log;

    ...
  }
}
```

If you’re using NGINX Instance Manager with Security Monitoring, your configuration may already include the following directive:

```nginx
app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
```

**Don’t change this value.** See the [Security Monitoring setup guide]({{< ref "/nim/nginx-app-protect/security-monitoring/set-up-app-protect-instances.md" >}}) for more details.

If you’re using NGINX App Protect WAF v5:

- You must add the `app_protect_enforcer_address` directive to the `http` context:

    ```nginx
    app_protect_enforcer_address 127.0.0.1:50000;
    ```

- JSON policies and log profiles aren’t supported. You must precompile and publish them using NGINX Instance Manager. Make sure the precompiled_publication setting in the NGINX Agent configuration is set to true.

    See the [NGINX App Protect WAF configuration guide]({{< ref "/nap-waf/v5/configuration-guide/configuration.md" >}}) for details.

{{<tabs name="add_security">}}
{{%tab name="UI"%}}

1. {{< include "nim/webui-nim-login.md" >}}
2. In the left menu, select **Instances** or **Instance Groups**.
3. From the **Actions** menu (**...**), select **Edit Config** for the instance or group.
4. If you’re using precompiled publication, change any `.json` file extensions to `.tgz`.
5. If you want to apply a default policy, select **Apply Security**, then copy the policy snippet and paste it into your configuration.
6. Add the directives inside an `http`, `server`, or `location` block.
7. Select **Publish** to push the configuration.

{{%/tab%}}

{{%tab name="API"%}}

{{< see-also >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /see-also >}}

You can use the NGINX Instance Manager REST API to deploy your NGINX App Protect WAF configuration.

{{<bootstrap-table "table">}}

| Method | Endpoint                                                            |
|--------|---------------------------------------------------------------------|
| GET    | `/api/platform/v1/systems/{systemUID}/instances`                    |
| POST   | `/api/platform/v1/security/{systemUID}/instances/{nginxUID}/config` |

{{</bootstrap-table>}}

{{<important>}}Before deploying a configuration to an instance group, make sure all instances in the group are running the same version of NGINX App Protect WAF. Otherwise, the deployment may fail.{{</important>}}

1. Send a `GET` request to the `/api/platform/v1/systems/{systemUID}/instances` endpoint to list all instances. This response includes the unique identifier (UID) of the instance that you want to update.

    ```shell
    curl -X GET https://{{NMS_FQDN}}/api/platform/v1/systems/{systemUID}/instances \
     -H "Authorization: Bearer <access token>"
    ```

2. Add the NGINX App Protect WAF configuration to your NGINX config file (`nginx.conf` or another config file located in a valid `config_dirs` path on the data plane host):

    - At a minimum, add the following directive:

        ```nginx
        app_protect_enable on;
        ```
    
    - If precompiled publication is enabled, change any `.json` policy references to `.tgz`.
    - If you want to apply a default policy, you can use:

        ```nginx
        app_protect_policy_file /etc/nms/NginxDefaultPolicy.tgz;
        ```

        or

        ```nginx
        app_protect_policy_file /etc/nms/NginxStrictPolicy.tgz;
        ```

    - Add the directives to an `http`, `server`, or `location` context.

3. Encode the updated NGINX configuration file using base64.

    ```shell
    base64 -i /etc/nginx/nginx.conf
    ```

4. Send a `POST` request to the `/api/platform/v1/security/{systemUID}/instances/{nginxUID}/config` endpoint to deploy the configuration. Replace `<base64-encoded-content>` with your encoded config:

    ```shell
    curl -X POST https://{{NMS_FQDN}}/api/platform/v1/security/{systemUID}/instances/{nginxUID}/config \
    -H "Authorization: Bearer <access token>" \
    --header "Content-Type: application/json" \
    -d '{
    "configFiles": {
      "rootDir": "/etc/nginx",
      "files": [
        {
          "name": "nginx.conf",
          "contents": "<base64-encoded-content>"
        }
      ]
    },
    "validateConfig": true
    }'
    ```

{{%/tab%}}
{{</tabs>}}

### Verify configuration

After you add NGINX App Protect WAF directives to your NGINX configuration, you can verify the setup in the NGINX Instance Manager web interface.

To confirm that the NGINX App Protect WAF configuration was applied:

1. {{< include "nim/webui-nim-login.md" >}}
2. In the left navigation menu, select **Instances**.
3. In the **NGINX App Protect** column, confirm that the correct version is listed.
4. Select the instance. Then, scroll to the **App Protect Details** section.
5. Confirm that the **App Protect WAF** status is **Active**, and the **Build** matches the version installed on the instance.

---

## Troubleshooting

If you're having trouble with NGINX App Protect WAF, try the steps below. If these don't solve the issue, reach out to F5 NGINX Customer Support.

### Check that NGINX App Protect WAF is not installed on the NGINX Instance Manager host

NGINX App Protect WAF and the WAF compiler shouldn't run on the same host. To check:

1. Log in to the NGINX Instance Manager host from a terminal.
2. Run the command that matches your operating system:

   - For Debian-based systems:

     ```shell
     dpkg -s app-protect
     ```

   - For RPM-based systems:

     ```shell
     rpm -qi | grep app-protect
     ```

If NGINX App Protect WAF is installed, follow the [uninstall instructions]({{< ref "/nap-waf/v4/admin-guide/install.md#uninstall-app-protect" >}}).

### Check that the WAF compiler version matches the NGINX App Protect WAF version

Each NGINX App Protect WAF version has a matching WAF compiler version. To confirm:

1. Log in to the NGINX Instance Manager host.
2. Run the following command to see installed compiler versions:

   ```shell
   ls -l /opt/nms-nap-compiler
   ```

### Confirm the WAF compiler is working correctly

You can verify that the WAF compiler is installed and responding:

```shell
sudo /opt/nms-nap-compiler/app_protect-<version>/bin/apcompile -h
```

**Example:**

```shell
sudo /opt/nms-nap-compiler/app_protect-5.342.0/bin/apcompile -h
```

**Expected output:**

```text
USAGE:
    /opt/nms-nap-compiler/app_protect-5.342.0/bin/apcompile <options>

Examples:
    /opt/nms-nap-compiler/app_protect-5.342.0/bin/apcompile -p /path/to/policy.json -o mypolicy.tgz
    /opt/nms-nap-compiler/app_protect-5.342.0/bin/apcompile -p policyA.json -g myglobal.json -o /path/to/policyA_bundle.tgz
    /opt/nms-nap-compiler/app_protect-5.342.0/bin/apcompile -g myglobalsettings.json --global-state-outfile /path/to/myglobalstate.tgz
    /opt/nms-nap-compiler/app_protect-5.342.0/bin/apcompile -b /path/to/policy_bundle.tgz --dump
    /opt/nms-nap-compiler/app_protect-5.342.0/bin/apcompile -l logprofA.json -o /path/to/logprofA_bundle.tgz
```

### Confirm NGINX Agent configuration on the NGINX App Protect WAF instance

Open the `/etc/nginx-agent/nginx-agent.conf` file and make sure it includes the right settings.

```yaml
# List of directories the agent monitors for config files
config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"

# Enable necessary NGINX App Protect extensions
extensions:
  - nginx-app-protect
  - nap-monitoring

nginx_app_protect:
  # Report interval for NGINX App Protect details — how often the agent checks for changes
  report_interval: 15s
  # Set to true to publish precompiled policies and log profiles from NGINX Instance Manager
  precompiled_publication: true

nap_monitoring:
  # Buffer size for the collector — holds log lines and parsed entries
  collector_buffer_size: 50000
  # Buffer size for the processor — processes log lines from the buffer
  processor_buffer_size: 50000
  # IP address where the agent listens for syslog messages
  syslog_ip: "127.0.0.1"
  # Port number for receiving syslog messages
  syslog_port: 514
```

### Confirm access to the NGINX packages repository

If automatic downloads for Attack Signatures or Threat Campaigns are failing, check whether the repo certificate and key are set up correctly.

Run this command to test access:

```shell
curl --key /etc/ssl/nginx/nginx-repo.key --cert /etc/ssl/nginx/nginx-repo.crt https://pkgs.nginx.com/app-protect-security-updates/index.xml
```

**Expected output:**

```text
...
<repositories>
<repository distro="centos" version="6" arch="x86_64" prefix="centos/6/x86_64/">
</repository>
<repository distro="centos" version="7" arch="x86_64" prefix="centos/7/x86_64/">
<package type="rpm">
  <name>app-protect-attack-signatures</name>
  <arch>x86_64</arch>
  <version epoch="0" ver="2019.07.16" rel="1.el7.ngx"/>
  <location href="RPMS/app-protect-attack-signatures-2019.07.16-1.el7.ngx.x86_64.rpm"/>
</package>
...
```

---

## What's Next

Now that configuration management is set up, you can use the NGINX Instance Manager REST API to:

- Manage NGINX App Protect WAF security policies.
- View system information about your NGINX App Protect WAF instances.
- Update Attack Signatures and Threat Campaigns.

To learn more, see [Manage WAF Security Policies and Security Log Profiles]({{< ref "/nim/nginx-app-protect/manage-waf-security-policies.md" >}}).
