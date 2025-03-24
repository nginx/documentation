---
description: This quick-start tutorial shows you how to get started using F5 NGINX
  Controller with the Application Security Add-on.
docs: DOCS-259
title: Trial NGINX Controller with App Security
toc: true
weight: 115
type:
- tutorial
---

## Overview

This quick-start tutorial shows you how to get started using F5 NGINX Controller with the Application Security Add-on ("App Security"). The App Security add-on to the NGINX Controller Application Delivery Module enables a web application firewall (WAF) that you can use to protect your apps.

Take the steps in this guide to deploy NGINX Controller with App Security and deploy NGINX App Protect with NGINX Plus as a data plane instance for use with NGINX Controller.

{{< caution >}}In this tutorial, NGINX Controller will install an embedded, self-hosted PostgreSQL database suitable for demo and trial purposes only. **These instructions are not meant for use in production environments**.{{< /caution >}}

{{< note >}}If you already have an active NGINX Controller trial and want to add App Security to it, you can start with the [Install NGINX App Protect with NGINX Plus](#install-nginx-app-protect-with-nginx-plus) section. {{< /note >}}

&nbsp;

---

## Technical Requirements

Be sure to review the [NGINX Controller Technical Specifications Guide]({{< relref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}) for additional requirements for your desired distribution and configuration.

### Supported Distributions

NGINX Controller with App Security supports the following distributions for deploying NGINX App Protect:

- CentOS 7 (7.4+)
- Red Hat Enterprise Linux 7 (7.4+)
- Debian 9
- Ubuntu 18.04 LTS, Ubuntu 20.04 LTS

### Hardware Specs

The following minimum hardware specifications are required for each node running NGINX Controller:

- RAM: 8 GB RAM
- CPU: 8-Core CPU @ 2.40 GHz or similar
- Disk space: 155–255 GB free disk space. 255 GB of free space is recommended if NGINX Controller App Security is enabled. See the [Storage Requirements]({{< relref "/controller/admin-guides/install/nginx-controller-tech-specs.md#storage-requirements" >}}) section for a categorized list of the storage requirements.

### Supported NGINX Versions

The App Security add-on for the NGINX Controller Application Delivery module is compatible with the versions of NGINX Plus and NGINX App Protect shown in the table below. New releases of NGINX Controller ADC support the last four versions of NGINX Plus at release time.

{{< see-also >}}
Refer to [Using NGINX App Protect with NGINX Controller]({{< relref "controller/admin-guides/install/install-for-controller.md" >}}) for installation instructions and additional information.
{{< /see-also >}}

{{< bootstrap-table "table table-striped table-bordered" >}}

| NGINX Controller version            | NGINX App Protect version(s)                                                                    | NGINX Plus version(s)          |
|-------------------------------------|-------------------------------------------------------------------------------------------------|--------------------------------|
| NGINX Controller ADC v3.22.9        | v4.5 <hr> v4.3, v4.4 <hr> v4.0, v4.1, v4.2 <hr> v3.12, v3.11 | R30 <hr> R29 <hr> R28 <hr> R27 |
| NGINX Controller ADC v3.22.8        | v4.0, v4.1 <hr> v3.12, v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6                 | R28 <hr> R27 <hr> R26 <hr> R25 |
| NGINX Controller ADC v3.22.7        | v4.0, v4.1 <hr> v3.12, v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6                 | R28 <hr> R27 <hr> R26 <hr> R25 |
| NGINX Controller ADC v3.22.6        | v4.0, v4.1 <hr> v3.12, v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6                 | R28 <hr> R27 <hr> R26 <hr> R25 |
| NGINX Controller ADC v3.22.5        | v3.12, v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2     | R27 <hr> R26 <hr> R25 <hr> R24 |
| NGINX Controller ADC v3.22.4        | v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2            | R27 <hr> R26 <hr> R25 <hr> R24 |
| NGINX Controller ADC v3.22.3        | v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 | R26 <hr> R25 <hr> R24 <hr> R23 |
| NGINX Controller ADC v3.22.2        | v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3          | R26 <hr> R25 <hr> R24 <hr> R23 |
| NGINX Controller ADC v3.22, v3.22.1 | v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                  | R25 <hr> R24 <hr> R23 <hr> R22 |
| NGINX Controller ADC v3.21          | v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                              | R25 <hr> R24 <hr> R23 <hr> R22 |
| NGINX Controller ADC v3.20.1        | v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                              | R25 <hr> R24 <hr> R23 <hr> R22 |
| NGINX Controller ADC v3.20          | v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                                        | R24 <hr> R23 <hr> R22          |
| NGINX Controller APIM v3.19.2       | v3.6 <hr> v3.5, v3.4                                                                            | R25 <hr> R24                   |
| NGINX Controller APIM v3.19         | v3.5, v3.4                                                                                      | R24                            |
| NGINX Controller v3.18              | v3.5, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                                                    | R24 <hr> R23 <hr> R22          |
| NGINX Controller v3.17              | v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                                                          | R24 <hr> R23 <hr> R22          |
| NGINX Controller v3.16              | v3.1, v3.0, v2.3 <hr> v2.1.1                                                                    | R23 <hr> R22                   |
| NGINX Controller v3.14, v3.15       | v3.0, v2.3 <hr> v2.1.1                                                                          | R23 <hr> R22                   |
| NGINX Controller v3.13              | v2.3 <hr> v2.1.1                                                                                | R23 <hr> R22                   |
| NGINX Controller v3.12              | v2.1.1                                                                                          | R22                            |

{{< /bootstrap-table >}}

&nbsp;

---

## Sign Up for a Trial License

{{< note >}}If you already have an active NGINX Controller trial instance that you want to add App Security to, you can skip this section.{{< /note >}}

First, you need to sign up for a trial license for NGINX Controller. The trial includes access to NGINX Plus, the NGINX Controller Application Delivery module, and the Application Security add-on.

1. Go to [MyF5](https://account.f5.com/myf5) and create a new account.
1. Verify your account and log in to MyF5.
1. On the MyF5 landing page, activate the NGINX Controller free trial.
1. On the MyF5 **Trials** page, select Launch Your Trial.
1. Download the NGINX Controller package.
1. Make note of your Association Token. You will use this to [license your NGINX Controller instance]({{< relref "/controller/platform/licensing-controller.md#add-a-license-to-nginx-controller" >}}).


&nbsp;

---

## Install NGINX Controller Prerequisites

{{< note >}}If you already have an active NGINX Controller trial instance that you want to add App Security to, you can skip this section.{{< /note >}}

{{< include "controller/helper-script-prereqs.md" >}}

&nbsp;

---

## Install NGINX Controller

{{< note >}}If you already have an active NGINX Controller trial instance that you want to add App Security to, you can skip this section.{{< /note >}}

Install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured. NGINX Controller does not support pre-configured Kubernetes implementations at this time. The installer for NGINX Controller will install and configure Kubernetes for you.

{{< important >}}Before installing NGINX Controller, you must **disable swap on the host**; this is required by Kubernetes in order for the kubelet to work properly. Refer to your Linux distribution documentation for specific instructions for disabling swap for your system. For more information about this requirement, see the AskF5 knowledge base article [K82655201](https://support.f5.com/csp/article/K82655201) and the [kubeadm installation guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) in the Kubernetes documentation.{{< /important >}}

{{< caution >}}**For RHEL 8 deployments**, complete the additional prerequisite steps in the [Installing NGINX on RHEL 8]({{< relref "/controller/admin-guides/install/install-nginx-controller-rhel-8.md" >}}) guide before installing NGINX Controller. RHEL 8 support is a **beta** feature.{{< /caution >}}

To install NGINX Controller, take the following steps:

1. Download the NGINX Controller installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).
1. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

1. Run the installation script:

    ```bash
    cd controller-installer
    ./install.sh
    ```

1. When prompted to use an embedded config DB, type `y`.

1. The installation script walks through a series of steps and asks for the following inputs:

    - **Config database volume type**: Specify the type of volume to use to store the config database: local, NFS, or AWS. We recommend choosing `local` for demo and trial purposes.

      {{< see-also >}}Refer to the [NGINX Controller Technical Specifications Guide]({{< relref "/controller/admin-guides/install/nginx-controller-tech-specs.md#local-or-external-storage" >}}) for more information about the volume options and requirements.{{< /see-also >}}

    - **Analytics database volume type**: Specify the type of volume to use to store the analytics database: local, NFS, or AWS. We recommend choosing `local` for demo and trial purposes.
    - **EULA**: Read the end-user license agreement. Type either `y` to accept or `n` to exit.
    - **SMTP**
      - **SMTP Host**: Provide the host name or IP address of an SMTP server. This is used to send password recovery emails. For trial purposes, if you don't need to receive these communications, you can enter a value of "example.com" or something similar.
      - **SMTP Port**: The port of the SMTP server.
      - **SMTP Authentication**: Select `y` or `n` to authenticate when connecting to the SMTP server.
      - **Use TLS for SMTP Communication**: Select `y` or `n` to use SSL for SMTP server connections.
      - **Do not reply email address**: The sender's email address. For example, `donotreply@example.com`.
    - **Admin**
      - **First name**: The first name for the initial admin user.
      - **Last name**: The last name for the initial admin user.
      - **Email address**: The contact email address for the initial admin user.
      - **Password**: The initial admin's password. Passwords must be 6-64 characters long and must include letters and digits.
    - **FQDN**: Fully qualified domain name (FQDN) -- a resolvable domain name for the NGINX Controller server. You can use the FQDN to access the NGINX Controller web interface.
      Additionally, the FQDN is used by Controller Agents when connecting to NGINX Controller.
    - **SSL/TLS certificates**: Type `y` to generate and use self-signed certs for running NGINX Controller over HTTPS, or type `n` to provide your own certs.

        {{< important >}}
If you provide your own SSL/TLS certificates, you'll need a complete certificate chain file, with the intermediate CA cert appended to the server cert; the server certificate must appear **before** the chained certificates in the combined file.
        {{< /important >}}

1. Log in to NGINX Controller at `https://<Controller-FQDN>/login`. Use the admin email address and password that you provided during the installation process.

1. Once NGINX Controller is installed, you may safely delete the installer package that you downloaded and extracted.

&nbsp;

---

## License NGINX Controller

To add a license to NGINX Controller, take the following steps:

1. Go to `https://<Controller-FQDN>/platform/license` and log in.
1. In the **Upload a license** section, select an upload option:

    - **Upload license file** -- Locate and select your license file in the file explorer.
    - **Paste your Association Token or license file** -- Paste your customer Association Token or the contents of your NGINX Controller license file. These are available on the [MyF5 Customer Portal](https://account.f5.com/myf5).

1. Select **Save license**.

{{< see-also >}}
To add a license using the [NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}), send a PUT request to the `/platform/license` endpoint. Provide your CAT or NGINX Controller license as a base64-encoded string in the JSON request body.
{{< /see-also >}}


&nbsp;

---

## Install NGINX App Protect with NGINX Plus

[NGINX App Protect](https://www.nginx.com/products/nginx-app-protect/) is the security data plane for NGINX Controller App Security. Your NGINX App Protect installation will include NGINX Plus.

{{< important >}}
If you are adding App Security to an existing NGINX Controller trial, we recommend that you take the steps in this section to deploy a new NGINX App Protect instance, rather than adding the App Protect module to an existing NGINX Plus instance.

NGINX Controller App Security is supported for use with a limited subset of the OS distributions that are supported by the NGINX Controller Agent and NGINX Plus. If you are planning to add NGINX App Protect to an existing NGINX Plus instance, be sure to check the [Supported Distributions](#supported-distributions) section above to verify that your NGINX Plus instance supports NGINX App Protect.
{{< /important >}}

### Prerequisites

- Be sure to review the [NGINX Plus Technical Specifications](https://docs.nginx.com/nginx/technical-specs/) for the requirements for your distribution and desired configuration.
- You'll need the NGINX Plus certificate and public key files (`nginx-repo.crt` and `nginx-repo.key`) when installing NGINX App Protect. If you don't have these files, you can use the [NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}) to download them.

#### Download the NGINX App Protect Cert and Key

Take the steps below to download the cert and key files by using the NGINX Controller REST API.

The NGINX Controller API uses session cookies to authenticate requests. The session cookie is returned in response to a `GET /api/v1/platform/login` request. See the Login endpoint in the [NGINX Controller API Reference]({{< relref "/controller/api/_index.md" >}}) documentation for information about session cookie timeouts and invalidation.

{{< tip >}}
You can send a GET request to the login endpoint to find the status of the session token.
{{< /tip >}}

For example:

- Login and capture the session cookie:

  ```curl
  curl -c cookie.txt -X POST --url 'https://<ip address>/api/v1/platform/login' --header 'Content-Type: application/json' --data '{"credentials": {"type": "BASIC","username": "<username>","password": "<password>"}}'
  ```

- Use the session cookie to authenticate and get the session status:

  ```curl
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://<ip address>/api/v1/platform/login'
  ```


<br>

To use the [NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}) to download your NGINX Plus certificate and key bundle as a gzip or JSON file, send a GET request to the `/platform/licenses/nginx-plus-licenses/controller-provided` endpoint.

For example:

- Download JSON file:

  ```bash
  curl -b cookie.txt -c cookie.txt --header 'Content-Type: application/json' -X GET --url 'https://192.0.2.0/api/v1/platform/licenses/nginx-plus-licenses/controller-provided'  --output nginx-plus-certs.json
  ```

- Download GZIP file:

  ```bash
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://192.0.2.0/api/v1/platform/licenses/nginx-plus-licenses/controller-provided' --output nginx-plus-certs.gz
  ```

{{< note >}}
If you are using a self-signed certificate you will need to add `-k` (allow insecure connections) to your curl command to be able to download your NGINX Plus certificate and key bundle.
{{< /note >}}


Once you have downloaded your certificate and key bundle you will need to expand the `.gz` file to get your certificate and key pair.

For example:

```bash
gunzip nginx-plus-certs.gz
```

### Deploy NGINX App Protect

<div data-proofer-ignore>

Install NGINX App Protect on a host accessible by your NGINX Controller instance by following the appropriate steps for your operating system in the [Using NGINX App Protect with NGINX Controller]({{< relref "controller/admin-guides/install/install-for-controller.md" >}}) guide.

{{< note >}}
If you install NGINX App Protect by using any of the OS-specific install guides, **do not make changes to the `nginx.conf` file**.
The NGINX Controller Agent manages `nginx.conf` settings and will make the appropriate adjustments for you.
{{< /note >}}

</div>

&nbsp;

---

## Add the NGINX App Protect Instance to NGINX Controller

{{< include "controller/add-existing-instance.md" >}}

&nbsp;

---

## What's Next

You should now be ready to start your NGINX Controller with App Security trial. Refer to the following topics to get started:

- [Configure the NGINX Controller Agent]({{< relref "/controller/admin-guides/config-agent/configure-the-agent.md" >}})
- [Set Up Metrics Collection]({{< relref "/controller/admin-guides/config-agent/configure-metrics-collection.md" >}})
- [Forward Metrics Data to an External Service]({{< relref "/controller/analytics/forwarders/_index.md" >}})
- [Set up NGINX Controller Services]({{< relref "/controller/services/overview.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
