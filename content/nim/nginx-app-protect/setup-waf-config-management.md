---
description: Learn how to use F5 NGINX Management Suite Instance Manager to secure your
  applications with NGINX App Protect WAF security policies.
docs: DOCS-996
doctypes:
- task
tags:
- docs
title: Manage Your App Protect WAF Configs
toc: true
weight: 100
---

{{< shortversions "2.6.0" "latest" "nimvers" >}}

## Overview

Instance Manager helps you manage your F5 NGINX App Protect WAF configurations, making it easy to stay secure. This guide shows you how to set up Instance Manager to configure and manage NGINX App Protect WAF.

### Before You Begin

Complete the following prerequisites before proceeding with this guide.

- You have one or more instances of [NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect/admin-guide/install/) installed and running. See [Support for NGINX App Protect WAF]({{< relref "tech-specs#support-for-nginx-app-protect-waf" >}}) for a list of supported versions.

    {{<note>}}If you are using configuration management and the NGINX Management Suite Security Monitoring module, follow the instructions in the [setup guide]({{<relref "/nim/monitoring/security-monitoring/configure/set-up-app-protect-instances" >}}) to set up your NGINX App Protect instances before proceeding with this guide.{{</note>}}

- You have Instance Manager v2.6.0 or later [installed]({{< relref "/nim/deploy/vm-bare-metal/_index.md" >}}), licensed, and running.
  If you have a subscription to NGINX App Protect WAF, you can find your Instance Manager license in the subscription details section of [MyF5](https://my.f5.com).

### Limitations

{{<important>}}App Protect WAF Config management is currently not supported when [deploying Instance Manager on Kubernetes]({{<relref "/nim/deploy/kubernetes/deploy-using-helm.md" >}}).{{</important>}}

Instance Manager does not support the following NGINX App Protect features:

- [Policies with external references](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#external-references)
- [Policies with modifications](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#modifying-configurations)
- Custom signatures

---

## Install the WAF Compiler

Instance Manager can use the NGINX App Protect WAF compiler to "pre-compile" security configurations before syncing them to managed data plane instances. You'll need to install the WAF compiler package on the NGINX Management Suite host to enable this functionality. If you'll be continuing with WAF compilation on the data plane host, installing the WAF compiler on the NGINX Management Suite host is not necessary.

Be sure to download and install the correct WAF compiler version for your environment:

- Each NGINX App Protect version has a corresponding WAF compiler version. You must install the WAF compiler that matches the version of NGINX App Protect that you have running.
- If you have different NGINX App Protect versions running, install the correct WAF compiler package for each on the management plane host. Instance Manager will use the correct WAF compiler for each version to bundle the security configurations.
- You can create [instance groups]({{< relref "/nim/nginx-instances/manage-instance-groups" >}}) to keep track of and manage all instances that have the same version installed.

For more information about the WAF compiler, refer to the [Security Bundle Compilation]({{< relref "/nim/nginx-app-protect/overview-nap-waf-config-management#security-bundle" >}}) section of the Policy Configuration overview topic.

### WAF Compiler and Supported App Protect Versions {#nap-waf-compiler-compatibility}

The following table shows the NGINX App Protect WAF Release version and its corresponding WAF compiler version:

{{<bootstrap-table "table table-striped table-bordered">}}

| NGINX App Protect WAF Release version | WAF Compiler               |
|---------------------------------------|----------------------------|
| NGINX App Protect WAF 5.4.0           | nms-nap-compiler-v5.210.0  |
| NGINX App Protect WAF 5.3.0           | nms-nap-compiler-v5.144.0  |
| NGINX App Protect WAF 5.2.0           | nms-nap-compiler-v5.48.0   |
| NGINX App Protect WAF 5.1.0           | nms-nap-compiler-v5.17.0   |
| NGINX App Protect WAF 4.12.0          | nms-nap-compiler-v5.210.0  |
| NGINX App Protect WAF 4.11.0          | nms-nap-compiler-v5.144.0  |
| NGINX App Protect WAF 4.10.0          | nms-nap-compiler-v5.48.0   |
| NGINX App Protect WAF 4.9.0           | nms-nap-compiler-v5.17.0   |
| NGINX App Protect WAF 4.8.1           | nms-nap-compiler-v4.815.0  |
| NGINX App Protect WAF 4.8.0           | nms-nap-compiler-v4.762.0  |
| NGINX App Protect WAF 4.7.0           | nms-nap-compiler-v4.641.0  |
| NGINX App Protect WAF 4.6.0           | nms-nap-compiler-v4.583.0  |
| NGINX App Protect WAF 4.5.0           | nms-nap-compiler-v4.457.0  |
| NGINX App Protect WAF 4.4.0           | nms-nap-compiler-v4.402.0  |
| NGINX App Protect WAF 4.3.0           | nms-nap-compiler-v4.279.0  |
| NGINX App Protect WAF 4.2.0           | nms-nap-compiler-v4.218.0  |
| NGINX App Protect WAF 4.1.0           | nms-nap-compiler-v4.100.1  |
| NGINX App Protect WAF 4.0.0           | nms-nap-compiler-v4.2.0    |
| NGINX App Protect WAF 3.12.2          | nms-nap-compiler-v3.1088.2 |

{{</bootstrap-table>}}

<br>

{{<note>}}

- The install commands in this guide use an example version to show the correct command format.

  Be sure to replace the version string in the example with the correct version to suit your needs.
  You can find the package versions in the [NGINX App Protect WAF Release Notes](https://docs.nginx.com/nginx-app-protect/releases/).

- The WAF compiler installs to the `/opt` directory. Set the permission level for the directory as appropriate to allow write access by the owner (for example, `0755`).

{{</note>}}

### Debian or Ubuntu

Install the WAF compiler, then restart the `nms-integrations` service:

```bash
sudo apt-get install nms-nap-compiler-v5.210.0
```

{{<note>}}

- If you want to have more than one version of the `nms-nap-compiler` installed on your system at once, you'll need to append `-o Dpkg::Options::="--force-overwrite"` to the `nms-nap-compiler` installation commands after your initial `nms-nap-compiler` installation. For example, the installation command would look like this:

```bash
sudo apt-get install nms-nap-compiler-v5.210.0 -o Dpkg::Options::="--force-overwrite"
```

{{</note>}}

### RHEL 8.1 or later

Download the file dependencies.repo to `/etc/yum.repos.d`, enable the `codeready-builder` repository through subscription manager, and install the WAF compiler package:

```bash
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
sudo yum install nms-nap-compiler-v5.210.0
```

### RHEL 7.4 or later; CentOS
Download the file `dependencies.repo` to `/etc/yum.repos.d`, enable the RHEL 7 server repositories, and install the WAF compiler package.

```bash
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
sudo yum-config-manager --enable rhui-REGION-rhel-server-optional rhui-REGION-rhel-server-releases rhel-7-server-optional-rpms
sudo yum install nms-nap-compiler-v5.210.0
```

### Amazon Linux 2 LTS
Download the files `nms-amazon2.repo` and `app-protect-7.repo` to `/etc/yum.repos.d`, enable the `Extra Packages for Enterprise (EPEL)` repository, and install the WAF compiler package:

```bash
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms-amazon2.repo
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo
sudo amazon-linux-extras enable epel
sudo yum clean metadata
sudo yum install epel-release
sudo yum install nms-nap-compiler-v5.210.0
```

### Oracle Linux 7.4 or later
Download the file `dependencies.repo` to `/etc/yum.repos.d`, enable the `ol8_codeready_builder` repository, and install the WAF compiler package:

```bash
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
sudo yum-config-manager --enable ol8_codeready_builder
sudo yum install nms-nap-compiler-v5.210.0
```

### Download from MyF5

If you are not able to access the public NGINX repository, you can download all of the required packages from [MyF5](https://my.f5.com/).

Take the steps below to download the WAF compiler,  Attack Signatures, and Threat Campaigns packages from MyF5.

1. Log in to [MyF5](https://my.F5.com).
1. Go to **Resources** > **Downloads**.
1. Select **Group/Product Family**: **NGINX**.
1. Select **Product Line**: **NGINX App Protect**.
1. Select a **Product version**.
1. Select the **Linux distribution**, **distribution version**, and **Architecture**.
1. Download the WAF compiler package and transfer it to the NGINX Management Suite host.
1. Run the appropriate command on the host to install the WAF compiler package from the file.

    - Debian or Ubuntu:

    ``` bash
    sudo apt-get install -f /path/to/nms-nap-compiler-<version>_focal_amd64.deb
    ```

    {{<note>}}For Debian or Ubuntu, if you want to have more than one version of the `nms-nap-compiler` installed on your system at once, you'll need to append `-o Dpkg::Options::="--force-overwrite"` to the `nms-nap-compiler` installation commands after your initial `nms-nap-compiler` installation. For example, the installation command would look like this:

```bash
sudo apt-get install -f /path/to/nms-nap-compiler-<version>_focal_amd64.deb -o Dpkg::Options::="--force-overwrite"
```

    {{</note>}}

    - RHEL, CentOS, or Oracle Linux:

    ``` bash
    sudo yum install -f /path/to/nms-nap-compiler-<version>_el8.ngx.x86_64.rpm
    ```

### Automatically Download and Install New WAF Compiler

Once a version of the NGINX App Protect WAF compiler is manually installed on Instance Manager, the system will automatically download and install a new WAF compiler when it detects that an update is required. This typically happens when the NGINX App Protect WAF version on the data plane has been [upgraded](#upgrade-nap-waf-version-on-managed-instances) or when a new data plane with a different NGINX App Protect WAF version is added.

To enable the automatic download and installation of a new WAF compiler, you need to [upload your NGINX App Protect WAF certificate and key](#upload-nginx-app-protect-waf-certificate-and-key) to Instance Manager. This upload needs to be done only once. By providing the certificate and key, Instance Manager can securely fetch and install the latest WAF compiler from the NGINX repository.

If the automatic download and install of the new WAF compiler step fails, when publishing the NGINX configuration, the error message

``` text
missing the specific compiler, please install it and try again.
```

will appear. This happens if the NGINX App Protect WAF certificate and key are missing or not working, or if Instance Manager cannot connect to the NGINX Repository. Please check `/var/log/nms/nms.log` for errors.

If you see the following error, your NGINX App Protect WAF certificate and key are missing, invalid, or have expired:

```text
error when creating the nginx repo retriever - NGINX repo certificates not found
```

Also, please refer to [Install the WAF Compiler](#install-the-waf-compiler) for details on how to manually install the new WAF compiler.

---

## Set Up Attack Signatures and Threat Campaigns

NGINX App Protect provides predefined [Attack Signatures](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#configuring-attack-signatures) to protect your application against all attack types identified by the system. As new Attack Signatures are identified, they will become available for download so that your system will always have the most up-to-date protection.

[Threat Campaigns](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#threat-campaigns) is a threat intelligence feature included in an NGINX App Protect WAF subscription. The feature includes frequent update feeds containing contextual information about active attack campaigns currently being observed by F5 Threat Labs that NGINX App Protect WAF can provide protection against. Just like Attack Signatures, the Threat Campaign patterns are updated regularly. Unlike Attack Signatures, the NGINX App Protect WAF installation does not include any Threat Campaigns and you need to install them in order for the protection to take effect. Due to the highly dynamic nature of those campaigns the updates are issued far more frequently than the Attack Signatures. You need to install those updates close to the time they are issued in order to get the most effective protection.

In order to take advantage of new Attack Signature and Threat Campaign packages, you need to upload these packages to NGINX Management Suite.

You can either configure Instance Manager to download new versions automatically, or manage the files manually by downloading the packages from MyF5 and then uploading them to Instance Manager by using the REST API.

### Automatically Download Latest Packages {#automatically-download-latest-packages}

#### Upload NGINX App Protect WAF Certificate and Key

You will need to use your NGINX repo certificates to setup automatic retrieval of Attack Signatures and Threat Campaigns packages. When you upload your NGINX App Protect WAF certificate and key to NGINX Instance Manager, you are letting NGINX Instance Manager access the NGINX repo to get Attack Signature and Threat Campaign files on your behalf.

1. Log in to [MyF5](https://account.f5.com/myf5) and go to **My Products and Plans > Subscriptions** to download the SSL certificate (*nginx-repo.crt*) and private key (*nginx-repo.key*) for your NGINX App Protect subscription.
1. Create a JSON file, similar to the example below, that contains the text from your crt and key files.
   You will need to replace all of the newlines in the crt and key output with `\n`.

   ```json
   {
       "name": "nginx-repo",
       "nginxResourceType": "NginxRepo",
       "certPEMDetails": {
           "caCerts": [],
           "password": "",
           "privateKey": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDt71QRqMl/7/rv\n[CONTENT SNIPPED]\n-----END PRIVATE KEY-----\n",
           "publicCert": "-----BEGIN CERTIFICATE-----\nMIIEPzCCAyegAwIBAgIRANydR2VZ+mlt75SkttRyQTkwDQYJKoZIhvcNAQELBQAw\n[CONTENT SNIPPED]\n-----END CERTIFICATE-----",
           "type": "PEM"
       }
   }
   ```

1. Send an HTTP POST request to the [Instance Manager REST API]({{< relref "/nim/fundamentals/api-overview" >}}) to upload the repo certificate and key.

    <details open>
    <summary>Example request</summary>

    ```shell
    curl -X POST 'https://{{NMS_FQDN}}//api/platform/v1/certs'  \
        --header "Authorization: Bearer <access token>"      \
        --header "Content-Type: application/json"                \
        -d@nginx-repo-certs.json
    ```

    <details open>
    <summary>Example response</summary>

    ```json
    {
        "certAssignmentDetails": [],
        "certMetadata": [
            {
            "authorityKeyIdentifier": "<FINGERPRINT>",
            "commonName": "<SUBSCRIPTION NAME>",
            "expired": false,
            "expiry": 59789838,
            "issuer": "C=US, ST=Washington, L=Seattle,  Inc., O=F5 Networks\\, OU=Certificate Authority, CN=F5 PRD Issuing Certificate Authority TEEM V1",
            "publicKeyType": "RSA (2048 bit)",
            "serialNumber": "<SERIAL NUMBER>",
            "signatureAlgorithm": "SHA256-RSA",
            "subject": "CN=<SUBSCRIPTION NAME>",
            "subjectAlternativeName": "",
            "subjectKeyIdentifier": "<FINGERPRINT>",
            "thumbprint": "<THUMBPRINT>",
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
            "publicCert": "[CONTENT SNIPPED]",
            "type": "PEM"
        },
        "created": "2023-01-27T23:42:41.587760092Z",
        "modified": "2023-01-27T23:42:41.587760092Z",
        "name": "nginx-repo",
        "serialNumber": "<SERIAL NUMBER>",
        "uid": "d08d9f54-58dd-447a-a71d-6fa5aa0d880c",
        "validFrom": "2021-12-21T16:57:55Z",
        "validTo": "2024-12-20T00:00:00Z"
        }
    ```

#### Enable automatic downloads

Instance Manager can automatically download the latest Attack Signature and Threat Campaign versions. To enable automatic downloads, take the steps below.

1. Log in to the management plane host using SSH.
1. Open the `/etc/nms/nms.conf` file for editing.
1. Adjust the `app_protect_security_update` options, shown in the example below, to enable and configure automatic downloads:

    ``` yaml
    integrations:
      # enable this for integrations on tcp
      # address: 127.0.0.1:8037
      address: unix:/var/run/nms/integrations.sock
      # Dqlite config
      dqlite:
        addr: 127.0.0.1:7892
      app_protect_security_update:
        # Enable this setting to automatically retrieve the latest Attack Signatures and Threat Campaigns.
        enable: true
        # Enable this setting to specify how often, in hours, the latest Attack Signatures and Threat Campaigns are retrieved.
        # The default interval is 6 hours, the maximum interval is 48 hours, and the minimum is 1 hour.
        interval: 6
        # Enable this setting to specify how many updates to download for the latest Attack Signatures and Threat Campaigns.
        # By default, the 10 latest updates are downloaded. The maximum value is 20, and the minimum value is 1.
        number_of_updates: 10
    ```

1. Save the changes and close the file.
1. Restart the `nms-integrations` service:

    ```  bash
    sudo systemctl restart nms-integrations
    ```

If you do not see the latest Attack Signatures and Threat Campaigns packages downloaded as expected, please check `/var/log/nms/nms.log` for errors.

If you see the following error, your NGINX App Protect WAF certificate and key are invalid or have expired:

```text
error when creating the nginx repo retriever - NGINX repo certificates not found
```

### Manually Update Packages

#### Download packages from MyF5

1. Log in to [MyF5](https://my.f5.com), then go to **Resources** > **Downloads**.
1. Select **Group/Product Family**: **NGINX**.
1. Select **Product Line**: **NGINX App Protect**.
1. Select a **Product version** (a version that matches your WAF compiler version).
1. Select your **Linux Distribution**, **Version** and **Architecture**.
1. Find and download the deb or rpm package starting with "app-protect-attack-signatures" for Attack Signatures and "app-protect-threat-campaigns" for Threat Campaigns.
1. Using utilities such as *az* or *rpm2cpio|cpio* to extract the following 3 files from the package:
    - `signatures.bin.tgz` for Attack Signatures or `threat_campaigns.bin.tgz` for Threat Campaigns
    - `signature_update.yaml` for Attack Signatures or `threat_campaign_update.yaml`for Threat Campaigns
    - `version`

1. Using a file archive utility, such as *tar*, bundle the three files into a single `.tgz` file. For example:

    ```shell
    tar –czvf attack-signatures.tgz signatures.bin.tgz signature_update.yaml version
    ```

#### Upload packages to Instance Manager

You will need to use the [Instance Manager REST API]({{< relref "/nim/fundamentals/api-overview" >}}) to upload the bundled Attack Signatures and Threat Campaigns.

<details open>
<summary>Attack Signatures Example</summary>

```shell
curl -X POST 'https://{{NMS_FQDN}}//api/platform/v1/security/attack-signatures' \
    --header "Authorization: Bearer <access token>"      \
    --form 'revisionTimestamp="2022.11.16"'                 \
    --form 'filename=@"/attack-signatures.tgz"'
```

</details>

<details open>
<summary>Threat Campaigns Example</summary>

```shell
curl -X POST 'https://{{NMS_FQDN}}//api/platform/v1/security/threat-campaigns' \
    --header "Authorization: Bearer <access token>"      \
    --form 'revisionTimestamp="2022.11.15"'                 \
    --form 'filename=@"/threat-campaigns.tgz"'
```

</details>

{{<important>}}The bundle you upload for Attack Signatures or Threat Campaigns must correspond to the OS of your Instance Manager. For example, if your Instance Manager is running on ubuntu-20.04, then the bundle you upload for Attack Signatures or Threat Campaigns needs to be created from the ubuntu-20.04 packages.{{</important>}}

### Update the Security Monitoring Signature Database

The Security Monitoring module's analytics dashboards make use of a Signature Database to provide more information on Attack Signatures that have triggered Security Violations, such as the Signature's name, accuracy, and risk level.

To ensure that the dashboards show the most up-to-date information, you need to [update the Security Monitoring Signature Database]({{< relref "/nim/monitoring/security-monitoring/configure/update-signatures" >}})

---

## Setup Compiler Resource Pruning
You can configure the following compiler resources to prune automatically:

- Compiled Security Policies
- Compiled Security Log Profiles
- Attack Signatures
- Threat Campaigns

In the case of `compiled security policies` and `compiled security log profiles`, the definition of the `security policy` and/or `security log profile` is not removed. Only the compiled bundles associated with those resources are removed.

To enable automatic compiler resource pruning, please follow these steps:

1. Log in to the management plane host using SSH.
1. Open the `/etc/nms/nms.conf` file for editing.
1. Update the `policy_manager` field to contain the desired `time to live` values for each resource type; see the following snippet for an example of adding the necessary fields under `integrations`->`policy_manager`:

    ```yaml
    integrations:
    address: unix:/var/run/nms/integrations.sock
    dqlite:
        addr: 127.0.0.1:7892
    policy_manager:
        # Time to live for attack signatures. If the attack signatures exceed their TTL and are not deployed to an instance or
        # instance group they will be deleted from the database. Duration unit can be seconds (s), minutes (m), or hours (h).
        attack_signatures_ttl: 336h
        # Time to live for compiled bundles, this includes compiled security policies and compiled log profiles. If a compiled
        # bundle exceeds its TTL and is not deployed to an instance or instance group it will be deleted from the database. Note
        # that the compiled bundle is deleted, not the definition of it (i.e. the security policy or log profile definition).
        # Duration unit can be seconds (s), minutes (m), or hours (h).
        compiled_bundles_ttl: 336h
        # Time to live for threat campaigns. If the threat campaigns exceed their TTL and are not deployed to an instance or
        # instance group they will be deleted from the database. Duration unit can be seconds (s), minutes (m), or hours (h).
        threat_campaigns_ttl: 1440h
    app_protect_security_update:
        enable: true
        interval: 6
        number_of_updates: 10
    ```

1. Save the changes and close the file.
1. Restart the `nms-integrations` service:

    ```  bash
    sudo systemctl restart nms-integrations
    ```

The compiler resource pruning process occurs once upon start-up of the `nms-integrations` service and once every `24 hours` after the `nms-integrations` service has been started.

---

## Onboard NGINX App Protect WAF Instances

To onboard your NGINX App Protect WAF instances to Instance Manager, you need to install and configure NGINX Agent.

### Install NGINX Agent

1. Use SSH to connect to the NGINX App Protect WAF instance. Take the steps below for each instance to download and install NGINX Agent from the management plane host.

1. Download the NGINX Agent package from the NGINX Management Suite host and run the agent install script.

   {{< tip >}}You can add instances with the same version of NGINX App Protect installed to an instance group by running the agent install command on each instance with the optional `--instance-group`` flag.{{< /tip>}}
   {{< include "agent/installation/install-agent-api.md" >}}

### Configure NGINX Agent

1. Edit the NGINX Agent configuration file (`/etc/nginx-agent/nginx-agent.conf`) to allow access to the `/etc/app-protect` directory and enable reporting.

    - The agent needs access to any directories where NGINX App Protect configuration files are stored on the data plane host.
    - The `report_interval` is the length of time the agent waits between checks for changes to NGINX App Protect WAF configurations.
    - `precompiled_publication` enables the publication of precompiled NGINX App Protect security policies and log profiles.

   ```yaml
   ...
   config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"
   extensions:
     - nginx-app-protect
   nginx_app_protect:
      report_interval: 15s
      precompiled_publication: true
   ...
   ```

    {{<note>}}You can use the NGINX Agent installation script to add these fields:

```bash
# Download install script via API
curl https://<NMS_FQDN>/install/nginx-agent > install.sh

# Specify the -m | --nginx-app-protect-mode flag to set up management of NGINX App Protect on
# the instance. In the example below we specify 'precompiled-publication' for the flag value
# which will make the config field 'precompiled_publication' set to 'true', if you would like to
# set the config field 'precompiled_publication' to 'false' you can specify 'none' as the flag value.
sudo sh ./install.sh --nginx-app-protect-mode precompiled-publication
```

    {{</note>}}

1. Restart NGINX Agent.

    ``` bash
    sudo systemctl restart nginx-agent
    ```

### Verify Installation

{{<tabs name="agent-verify">}}

{{%tab name="UI"%}}

You should now be able to view your NGINX App Protect WAF instances in the Instance Manager user interface. Take the steps below to verify that NGINX Agent is installed and reporting data to Instance Manager.

1. {{< include "nim/webui-nim-login.md" >}}
1. Select **Instances**.
1. You should see the installed version listed in the **NGINX App Protect** column.
1. Select the instance, then scroll to the **App Protect Details** section. There, you should see the "App Protect WAF" status and "Build" should match the version installed on the instance.

{{%/tab%}}

{{%tab name="API"%}}

{{< see-also >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /see-also >}}

You can query the Instance Manager REST API to verify the following information:

- NGINX App Protect WAF version
- NGINX App Protect WAF running status
- Total number of instances with NGINX App Protect WAF installed, out of the total number of NGINX instances


{{<bootstrap-table "table">}}

| Method | Endpoint                     |
|--------|------------------------------|
| GET    | `/api/platform/v1/instances` |
| GET    | `/api/platform/v1/systems`   |

{{</bootstrap-table>}}


- Send an HTTP `GET` request to the `/api/platform/v1/systems` endpoint to find out what version of NGINX App Protect is running. This response will also show the Threat Campaign and Attack Signature package versions running on each instance.

    <details open>
    <summary>JSON response</summary>

    ```json
    {
    "count": 3,
    "items": [
        [...]
        "appProtect": {
        "attackSignatureVersion": "2022.11.16",
        "status": "active",
        "threatCampaignVersion": "2022.11.15",
        "version": "build-3.954.0"
        },
        [...]
    ]
    }
    ```

    </details>

- Send an HTTP `GET` request to the `/api/platform/v1/instances` endpoint to find out the number of instances with NGINX App Protect WAF installed. The total count will be in the `nginxAppProtectWAFCount` field in the response.

    For example:

    <details open>
    <summary>JSON response</summary>

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

    </details>

    <br/>

{{%/tab%}}
{{</tabs>}}

### Configure Docker Compose for NGINX App Protect WAF Version 5

Version 5 of NGINX App Protect WAF provides a container-based architecture that requires some configuration changes to operate with Instance Manager.

1. Edit the `docker-compose.yaml` you created according to [NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect-waf/v5/admin-guide/install/) to provide the containers with read access to the policies and log profiles written to the instance by Instance Manager.

    - Add the line `user: 101:nginx-agent-group` to each service, where `nginx-agent-group` is the ID of the NGINX Agent group. The value of this group ID can be determined with

    ```bash
    cat /etc/group
    ```

    - Add the directory `/etc/nms` to the volume maps for both services

    For example:

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

1. Restart the containers:

    ``` bash
    docker compose restart
    ```

---

## Onboard Security Policies

Instance Manager provides the same [default security policies](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-configuration) as NGINX App Protect WAF:

- **NGINX Default Policy**: provides [OWASP Top 10](https://owasp.org/www-project-top-ten/) and Bot security protection.
- **NGINX Strict Policy**: contains more restrictive criteria for blocking traffic than the default policy.

If you want to use the out-of-the-box policies, you can proceed to the next section: [Add WAF configuration to NGINX Instances](#add-waf-config).

Continue in this section if you have custom security policies that you want to upload to Instance Manager.

### Upload Custom Security Policies

If you onboarded NGINX App Protect WAF instances with existing security configurations, you'll need to use the Instance Manager REST API to onboard the security policies referenced in the `nginx.conf` on your NGINX App Protect instances.

To do so, take the steps below for each policy:

1. Use `base64` to encode the JSON policy.

    For example:

    ``` bash
    base64 -i ./ignore-xss-policy-example.json
    ```

    <details closed>
    <summary>ignore-xss-policy-example.json</summary>

    ```json
    {
        "policy": {
            "name": "ignore-xss",
            "template": {
                "name": "POLICY_TEMPLATE_NGINX_BASE"
            },
            "applicationLanguage": "utf-8",
            "enforcementMode": "blocking",
            "signatures": [
                {
                    "signatureId": 200001475,
                    "enabled": false
                },
                {
                    "signatureId": 200000098,
                    "enabled": false
                },
                {
                    "signatureId": 200001148,
                    "enabled": false
                },
                {
                    "signatureId": 200001480,
                    "enabled": false
                },
                {
                    "signatureId": 200001088,
                    "enabled": false
                }
            ],
            "bot-defense": {
                "settings": {
                    "isEnabled": false
                }
            },
            "headers": [
                {
                    "name": "*",
                    "type": "wildcard",
                    "decodeValueAsBase64": "disabled"
                },
                {
                    "name": "*-bin",
                    "type": "wildcard",
                    "decodeValueAsBase64": "required"
                },
                {
                    "name": "Referer",
                    "type": "explicit",
                    "decodeValueAsBase64": "disabled"
                },
                {
                    "name": "Authorization",
                    "type": "explicit",
                    "decodeValueAsBase64": "disabled"
                },
                {
                    "name": "Transfer-Encoding",
                    "type": "explicit",
                    "decodeValueAsBase64": "disabled"
                }
            ],
            "cookies": [
                {
                    "name": "*",
                    "type": "wildcard",
                    "decodeValueAsBase64": "disabled"
                }
            ],
            "parameters": [
                {
                    "name": "*",
                    "type": "wildcard",
                    "decodeValueAsBase64": "disabled"
                }
            ]
        }
    }
    ```

    </details>

1. Create a JSON request body that contains the encoded policy.

    For example:

    ```json
    {
    "metadata": {
        "name": "ignore-xss-example",
        "displayName": "Ignore Cross Site Scripting example",
        "description": "Security policy that intentionally ignores cross site scripting"
    },
    "content":
        "ewogICAgInBvbGljeSI6IHsKICAgICAgICAibmFtZSI6ICJpZ25vcmUteHNzIiwKICAgICAgICAidGVtcGxhdGUiOiB7CiAgICAgICAgICAgICJuYW1lIjogIlBPTElDWV9URU1QTEFURV9OR0lOWF9CQVNFIgogICAgICAgIH0sCiAgICAgICAgImFwcGxpY2F0aW9uTGFuZ3VhZ2UiOiAidXRmLTgiLAogICAgICAgICJlbmZvcmNlbWVudE1vZGUiOiAiYmxvY2tpbmciLAogICAgICAgICJzaWduYXR1cmVzIjogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAic2lnbmF0dXJlSWQiOiAyMDAwMDE0NzUsCiAgICAgICAgICAgICAgICAiZW5hYmxlZCI6IGZhbHNlCiAgICAgICAgICAgIH0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJzaWduYXR1cmVJZCI6IDIwMDAwMDA5OCwKICAgICAgICAgICAgICAgICJlbmFibGVkIjogZmFsc2UKICAgICAgICAgICAgfSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgInNpZ25hdHVyZUlkIjogMjAwMDAxMTQ4LAogICAgICAgICAgICAgICAgImVuYWJsZWQiOiBmYWxzZQogICAgICAgICAgICB9LAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAic2lnbmF0dXJlSWQiOiAyMDAwMDE0ODAsCiAgICAgICAgICAgICAgICAiZW5hYmxlZCI6IGZhbHNlCiAgICAgICAgICAgIH0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJzaWduYXR1cmVJZCI6IDIwMDAwMTA4OCwKICAgICAgICAgICAgICAgICJlbmFibGVkIjogZmFsc2UKICAgICAgICAgICAgfQogICAgICAgIF0sCiAgICAgICAgImJvdC1kZWZlbnNlIjogewogICAgICAgICAgICAic2V0dGluZ3MiOiB7CiAgICAgICAgICAgICAgICAiaXNFbmFibGVkIjogZmFsc2UKICAgICAgICAgICAgfQogICAgICAgIH0sCiAgICAgICAgImhlYWRlcnMiOiBbCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJuYW1lIjogIioiLAogICAgICAgICAgICAgICAgInR5cGUiOiAid2lsZGNhcmQiLAogICAgICAgICAgICAgICAgImRlY29kZVZhbHVlQXNCYXNlNjQiOiAiZGlzYWJsZWQiCiAgICAgICAgICAgIH0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJuYW1lIjogIiotYmluIiwKICAgICAgICAgICAgICAgICJ0eXBlIjogIndpbGRjYXJkIiwKICAgICAgICAgICAgICAgICJkZWNvZGVWYWx1ZUFzQmFzZTY0IjogInJlcXVpcmVkIgogICAgICAgICAgICB9LAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAibmFtZSI6ICJSZWZlcmVyIiwKICAgICAgICAgICAgICAgICJ0eXBlIjogImV4cGxpY2l0IiwKICAgICAgICAgICAgICAgICJkZWNvZGVWYWx1ZUFzQmFzZTY0IjogImRpc2FibGVkIgogICAgICAgICAgICB9LAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAibmFtZSI6ICJBdXRob3JpemF0aW9uIiwKICAgICAgICAgICAgICAgICJ0eXBlIjogImV4cGxpY2l0IiwKICAgICAgICAgICAgICAgICJkZWNvZGVWYWx1ZUFzQmFzZTY0IjogImRpc2FibGVkIgogICAgICAgICAgICB9LAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAibmFtZSI6ICJUcmFuc2Zlci1FbmNvZGluZyIsCiAgICAgICAgICAgICAgICAidHlwZSI6ICJleHBsaWNpdCIsCiAgICAgICAgICAgICAgICAiZGVjb2RlVmFsdWVBc0Jhc2U2NCI6ICJkaXNhYmxlZCIKICAgICAgICAgICAgfQogICAgICAgIF0sCiAgICAgICAgImNvb2tpZXMiOiBbCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJuYW1lIjogIioiLAogICAgICAgICAgICAgICAgInR5cGUiOiAid2lsZGNhcmQiLAogICAgICAgICAgICAgICAgImRlY29kZVZhbHVlQXNCYXNlNjQiOiAiZGlzYWJsZWQiCiAgICAgICAgICAgIH0KICAgICAgICBdLAogICAgICAgICJwYXJhbWV0ZXJzIjogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAibmFtZSI6ICIqIiwKICAgICAgICAgICAgICAgICJ0eXBlIjogIndpbGRjYXJkIiwKICAgICAgICAgICAgICAgICJkZWNvZGVWYWx1ZUFzQmFzZTY0IjogImRpc2FibGVkIgogICAgICAgICAgICB9CiAgICAgICAgXQogICAgfQp9CiAgICAgICAgCg=="
      }
    ```

1. Send an HTTP `POST` request to the `/api/platform/v1/security/policies` endpoint to create the policy on Instance Manager.

    For example:

    ```shell
    curl -X POST https://{{NMS_FQDN}}/api/platform/v1/security/policies \
    -H "Authorization: Bearer <access token>" --ContentType application/json \
    -d '{"content": "ewogICAgInBvbGljeSI6[CONTENT_SNIPPED]QogICAgfQp9CiAgICAgICAgCg==", \
    "metadata": {"description": "Ignore cross-site scripting is a security policy that intentionally ignores cross site scripting.", \
    "displayName": "Ignore cross-site scripting example", "name": "ignore-xss-example"}}'
    ```

    You should receive a success response similar to the example below:

    ```json
    {
        "metadata": {
            "created": "2022-12-16T03:41:53.516Z",
            "description": "Security policy that intentionally ignores cross site scripting",
            "displayName": "Ignore Cross Site Scripting example",
            "modified": "2022-12-16T03:47:34.465920964Z",
            "name": "ignore-xss-example",
            "revisionTimestamp": "2022-12-16T03:41:53.516Z",
            "uid": "23139e0a-4ac8-49f9-b7a0-0577b42c70c7"
        },
        "selfLink": {
            "rel": "/api/platform/v1/security/policies/23139e0a-4ac8-49f9-b7a0-0577b42c70c7"
        }
    }
    ```

1. Verify that your policies have been onboarded by sending an HTTP `GET` request to the `/api/platform/v1/security/policies` endpoint:

    ```shell
    curl -X GET https://{{NMS_FQDN}}/api/platform/v1/security/policies \
    -H "Authorization: Bearer <access token>z"
    ```

    You should receive a success response similar to the example below:

    <details closed>
    <summary>Example response</summary>

    ```json
    {
        "items": [
            {
                "content": "",
                "metadata": {
                    "created": "2022-12-14T00:04:07.646Z",
                    "description": "The default policy provides OWASP Top 10 and Bot security protection",
                    "displayName": "NGINX Default Policy",
                    "modified": "2022-12-14T00:04:07.646Z",
                    "name": "NginxDefaultPolicy",
                    "revisionTimestamp": "2022-12-14T00:04:07.646Z",
                    "uid": "ae7d2ffc-972d-4951-a7ba-2340e1b8fe1c"
                }
            },
            {
                "content": "",
                "metadata": {
                    "created": "2022-12-14T00:04:07.65Z",
                    "description": "The strict policy contains more restrictive criteria for blocking traffic than the default policy",
                    "displayName": "NGINX Strict Policy",
                    "modified": "2022-12-14T00:04:07.65Z",
                    "name": "NginxStrictPolicy",
                    "revisionTimestamp": "2022-12-14T00:04:07.65Z",
                    "uid": "94665634-0d7e-4b72-87e8-491d951c8510"
                }
            },
            {
                "content": "",
                "metadata": {
                    "created": "2022-12-16T03:41:53.516Z",
                    "description": "Security policy that intentionally ignores cross site scripting",
                    "displayName": "Ignore Cross Site Scripting example",
                    "modified": "2022-12-16T03:47:34Z",
                    "name": "ignore-xss-example",
                    "revisionTimestamp": "2022-12-16T03:41:53.516Z",
                    "uid": "23139e0a-4ac8-49f9-b7a0-0577b42c70c7"
                }
            }
        ]
    }
    ```

    </details>

---

## Add WAF Configuration to NGINX Instances {#add-waf-config}

The [NGINX App Protect WAF Configuration Guide](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-configuration-overview) provides information about how and where to add the directives that allow you to add security to your instances. Instance Manager ships with the same reference policies as NGINX App Protect WAF:

- NGINX Default Policy (`NginxDefaultPolicy.tgz`): Provides OWASP Top 10 and Bot security protection out of the box.
- NGINX Strict Policy (`NginxStrictPolicy.tgz`): Contains more restrictive criteria for blocking traffic than the default policy, with a higher risk of false positives.

You can use either of these policies as-is. Many users treat the reference policy as starting point and customize it to suit the needs of their applications. The Security Monitoring dashboards provide insights that can help you fine-tune your security policies.

When using Instance Manager to manage your WAF configuration, keep the following in mind:

- Instance Manager can compile JSON security policies into a `.tgz` bundle.
- You can reference custom policy files using the `app_protect_policy_file` directive.

  {{<important>}}If you already have JSON security policies referenced in your NGINX configuration, you can keep them as-is if precompiled publication is not enabled in the NGINX Agent. However, you'll need to change the file extension for the referenced files from `.json` to `.tgz` if precompiled publication is enabled. The file name for the compiled bundle will be the same as the original file. Instance Manager does not support both `.json` and `.tgz` files within a single NGINX configuration{{</important>}}

- If you are using custom policies, be sure NGINX Agent has permission to access the location(s) where the policies are stored on the data plane. To do so, edit the NGINX Agent configuration file on the data plane host and add the custom file path to the `config_dirs` setting.

- Instance Manager uses the NGINX App Protect WAF [default log profiles](https://docs.nginx.com/nginx-app-protect/logging-overview/security-log/#default-logging-content). You can specify the desired log profile by using the `app_protect_security_log` directive.
Instance Manager does not support the use of custom log profiles.

The examples in this guide use the default path for NGINX App Protect configuration files. If you have these files stored elsewhere on your data plane instance(s), be sure to use the correct file path when setting up your configuration.

### Edit the NGINX configuration {#update-nginx-conf}

By using the Instance Manager web interface or REST API, add the NGINX App Protect WAF configurations to the appropriate context in your NGINX configuration.

The example below shows the directives added to a `location` block:

```nginx
...
server {
  ...

  location / {
  ##Enable NGINX App Protect
  app_protect_enable on;
  ## Reference to a custom security policy bundle
  app_protect_policy_file /etc/nms/ignore-xss.tgz;
  ## enable logging
  app_protect_security_log_enable on;
  ## Reference to the log profile bundle
  app_protect_security_log /etc/nms/log-default.tgz;
  ...
}
```

{{< note >}}If you're using the NGINX Management Suite Security Monitoring module, you should already have the `app_protect_security_log` directive set to reference the `secops_dashboard.tgz` file as shown below. Do not change this setting.

```nginx
app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
```

Refer to the [Security Monitoring setup guide]({{< relref "/nim/monitoring/security-monitoring/configure/set-up-app-protect-instances" >}}) to learn more. {{</note>}}

{{<important>}}
NGINX configuration for NGINX App Protect Version 5 requires the following changes:

- The `app_protect_enforcer_address` directive must be included within the `http` context of the NGINX configuration:

   ```nginx
   app_protect_enforcer_address 127.0.0.1:50000;
   ```

- JSON policies and log profiles are not supported for Version 5, so all policies and log profiles must be precompiled and the `precompiled_publication` attribute in the NGINX Agent configuration must be set to `true`.

Refer to the [NGINX App Protect WAF Configuration Guide](https://docs.nginx.com/nginx-app-protect-waf/v5/configuration-guide/configuration/) to learn more.
{{</important>}}

Additional example configurations tailored for NGINX features can be found in the [NGINX App Protect WAF Configuration Guide](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#interaction-with-nginx-features).

<br>

{{<tabs name="add_security">}}
{{%tab name="UI"%}}

1. {{< include "nim/webui-nim-login.md" >}}
2. On the left menu, select **Instances** or **Instance Groups**.
3. Select **Edit Config** from the **Actions** menu (represented by an ellipsis, `...`) for the desired instance or instance group.
4. If precompiled publication is enabled, change the file extension from `.json` to `.tgz` if there are any referenced security policies in the file.
5. If you want to apply the default security policy, select **Apply Security** and then copy the desired policy snippet by selecting **Copy**.
6. Paste the snippet into an `http`, `server`, or `location` context in the configuration.

   If multiple policies have been published, the most granular policy will apply.

7. Select **Publish** to immediately push the updated configuration to the selected instance or instance group.

{{%/tab%}}
{{%tab name="API"%}}

{{< see-also >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /see-also >}}


{{<bootstrap-table "table">}}

| Method | Endpoint                                                            |
|--------|---------------------------------------------------------------------|
| GET    | `/api/platform/v1/systems/{systemUID}/instances`                    |
| POST   | `/api/platform/v1/security/{systemUID}/instances/{nginxUID}/config` |

{{</bootstrap-table>}}


1. Send an HTTP `GET` request to the `/api/platform/v1/systems/{systemUID}/instances` endpoint. This returns a list of all instances from which you can find the unique identifier (UID) of the instance that you want to update.
1. Add the desired configurations to your `nginx.conf` file, or to any other configuration file that's within the context defined in the NGINX Agent `config_dirs` setting.

   - At a minimum, you should add `app_protect_enable on;`.
   - If precompiled publication is enabled, change the file extension from `.json` to `.tgz` if there are any referenced security policies in the file.
   - If you'd like to use the default security policies, paste either of the policy snippets below into an `http`, `server`, or `location` context in the configuration file. The most granular policy will be applied if multiple policies have been published.

     ``` nginx
     app_protect_policy_file /etc/nms/NginxDefaultPolicy.tgz;
     app_protect_policy_file /etc/nms/NginxStrictPolicy.tgz;
     ```

1. Encode the configuration file using base64:

    ``` bash
    base64 -i /etc/nginx/nginx.conf
    ```

1. Provide the encoded string in `configFiles.files.contents`, as shown below.

    > **Important!** Before deploying an updated configuration to an instance group, ensure that all instances in the group have the same version of NGINX App Protect WAF installed. Otherwise, the deployment may fail.

    ```shell
    curl -X POST https://{{NMS_FQDN}}/api/platform/v1/systems/{systemUID}/instances/{nginxUID}/config -H "Authorization: Bearer <access token>" \
        --Content-Type application/json -d @
    ```

    <details open>
    <summary>JSON Response</summary>

    ```json
    {
    "auxFiles": {
        "files": [
        {
            "contents": "PCFET0NUWVBFIGh0bWw+CjxodG1sPgo8aGVhZD4KP<EXAMPLE_SNIPPED>",
            "name": "/var/www/html/index.nginx-debian.html"
        }
        ],

        "rootDir": "/"
    },

    "configFiles": {
        "files": [
        {
            "contents": "dXNlciB3d3ctZGF0YTsKd29ya2VyX3Byb2Nlc3Nlc<EXAMPLE_SNIPPED>",
            "name": "nginx.conf"
        }
        ],

        "rootDir": "/etc/nginx"
    },

    "configUID": "",
    "ignoreConflict": false,
    "validateConfig": true
    }
    ```

    </details>

{{%/tab%}}

{{</tabs>}}

### Verify Configuration

Once you have added the NGINX App Protect WAF directives to your NGINX configuration, you should see the NGINX App Protect WAF status reported as "Active". Take the steps below to verify the configuration in the Instance Manager web interface.

1. {{< include "nim/webui-nim-login.md" >}}
1. Select **Instances**.
1. You should see the installed version listed in the **NGINX App Protect** column.
1. Select the instance, then scroll to the **App Protect Details** section. There, you should see the "App Protect WAF" status is "Active". The "Build" should match the version installed on the instance.

---

## Troubleshooting

If you're having issues with NGINX App Protect WAF, we suggest trying the following troubleshooting steps. If none of them helps, please reach out to NGINX Customer Support for further assistance.

<details>
<summary>Verify that NGINX App Protect WAF is not installed on the NGINX Management Suite host</summary>

To ensure no library conflicts arise when installing `nms-nap-compiler`, verify that NGINX App Protect WAF is not installed on the NGINX Management Suite host. You can do this by taking the following steps:

1. Open an SSH connection to your NGINX Management Suite host and log in.
2. Run the following command:

    - Debian-based distributions, run `dpkg -s app-protect`
    - RPM-based distributions, run `rpm -qi grep app-protect`

If NGINX App Protect WAF is installed, you'll need to [uninstall it](https://docs.nginx.com/nginx-app-protect-waf/admin-guide/install/#uninstall-app-protect).

</details>

<details>
<summary>Verify the WAF compiler version and NGINX App Protect version match</summary>

Each NGINX App Protect WAF version has a corresponding version of the WAF compiler. You must install the correct WAF compiler version for the version of NGINX App Protect WAF running on the managed instance(s). Refer to [WAF Compiler and Supported App Protect Versions]( #nap-waf-compiler-compatibility) for compatibility details.

To view the installed version of the WAF compiler:

1. Open an SSH connection to your NGINX Management Suite host and log in.
2. Run the following command:

   ```shell
   ls -l /opt/nms-nap-compiler
   ```

</details>

<details>
<summary>Verify the WAF compiler is running properly</summary>

Check if the WAF compiler has been installed and is working properly by viewing the command-line help:

```bash
sudo /opt/nms-nap-compiler/app_protect-<version>/bin/apcompile -h
```

For example, to view the help description for WAF compiler 5.210.0, run the following command:

``` bash
sudo /opt/nms-nap-compiler/app_protect-5.210.0/bin/apcompile -h
```

The output looks similar to the following example:

```text
USAGE:
    /opt/nms-nap-compiler/app_protect-5.210.0/bin/apcompile <options>

Examples:
    /opt/nms-nap-compiler/app_protect-5.210.0/bin/apcompile -p /path/to/policy.json -o mypolicy.tgz
    /opt/nms-nap-compiler/app_protect-5.210.0/bin/apcompile -p policyA.json -g myglobal.json -o /path/to/policyA_bundle.tgz
    /opt/nms-nap-compiler/app_protect-5.210.0/bin/apcompile -g myglobalsettings.json --global-state-outfile /path/to/myglobalstate.tgz
    /opt/nms-nap-compiler/app_protect-5.210.0/bin/apcompile -b /path/to/policy_bundle.tgz --dump
    /opt/nms-nap-compiler/app_protect-5.210.0/bin/apcompile -l logprofA.json -o /path/to/logprofA_bundle.tgz
...
```

<br>

</details>

<details>
<summary>Verify NGINX Agent configuration on NGINX App Protect WAF instance</summary>

Configure NGINX Agent on your NGINX App Protect WAF instance with settings similar to the following example:

"/etc/nginx-agent/nginx-agent.conf"

```yaml
# path to aux file dirs can also be added
config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"

# Enable necessary NAP extensions
extensions:
    - nginx-app-protect
    - nap-monitoring

nginx_app_protect:
  # Report interval for NGINX App Protect details - the frequency the NGINX Agent checks NGINX App Protect for changes.
  report_interval: 15s
  # Enable precompiled publication from the NGINX Management Suite (true) or perform compilation on the data plane host (false).
  precompiled_publication: true

nap_monitoring:
  # Buffer size for collector. Will contain log lines and parsed log lines
  collector_buffer_size: 50000
  # Buffer size for processor. Will contain log lines and parsed log lines
  processor_buffer_size: 50000
  # Syslog server IP address the collector will be listening to
  syslog_ip: "127.0.0.1"
  # Syslog server port the collector will be listening to
  syslog_port: 514
```

<br>

</details>

<details>
<summary>Verify access to the NGINX packages repository</summary>

To allow Instance Manager to automatically download the latest Attack Signatures and Threat Campaigns, you need to [upload the certificate and key files]({{< relref "/nim/nginx-app-protect/setup-waf-config-management.md#upload-nginx-app-protect-waf-certificate-and-key" >}}) included with your subscription to allow access to the package repository.

If you already uploaded your certificate and key files, use the command below to verify that they allow access to the package repo:

```bash
curl --key /etc/ssl/nginx/nginx-repo.key --cert /etc/ssl/nginx/nginx-repo.crt https://pkgs.nginx.com/app-protect-security-updates/index.xml
```

<br>

The output looks similar to the following example:

``` text
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
<package type="rpm">
  <name>app-protect-attack-signatures</name>
  <arch>x86_64</arch>
  <version epoch="0" ver="2020.04.30" rel="1.el7.ngx"/>
<location href="RPMS/app-protect-attack-signatures-2020.04.30-1.el7.ngx.x86_64.rpm"/>
</package>
...
```

</details>

---

## What's Next

Now that configuration management is set up, you can use the Instance Manager REST API to manage security policies, view system information about your NGINX App Protect WAF instances, and update Attack Signatures and Threat Campaigns. Learn more in [Manage App Protect WAF Configuration using the REST API]({{< relref "manage-waf-security-policies" >}}).
