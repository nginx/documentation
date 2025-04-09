---
description: This quick-start tutorial shows you how to get started using F5 NGINX
  Controller with NGINX Plus.
docs: DOCS-260
title: Trial NGINX Controller with NGINX Plus
toc: true
weight: 110
type:
- tutorial
---

## Overview

This quick-start tutorial shows you how to get started using F5 NGINX Controller with NGINX Plus.

{{< caution >}}In this tutorial, NGINX Controller will install an embedded, self-hosted PostgreSQL database suitable for demo and trial purposes only. **These instructions are not meant for use in production environments**.{{< /caution >}}

{{< see-also >}}If you want to try out NGINX Controller with the Application Security add-on, refer to [Trial NGINX Controller with App Security]({{< ref "/controller/admin-guides/install/try-nginx-controller-app-sec.md" >}}).{{< /see-also >}}

&nbsp;

---

## Technical Requirements

Make sure to review the [NGINX Controller Technical Specifications Guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}) for the requirements for your distribution and desired configuration.

### Supported Distributions

NGINX Controller, the NGINX Controller Agent, and the NGINX Controller Application Security Add-on support the following distributions and architectures.

{{< see-also >}}Refer to the [NGINX Plus Technical Specifications](https://docs.nginx.com/nginx/technical-specs/) guide for the distributions that NGINX Plus supports.{{< /see-also >}}

{{< bootstrap-table "table table-striped table-bordered" >}}

|Distribution<br>and Version|NGINX Controller <br> (Control Plane)|Agent <br> (Data Plane)|ADC App. Sec.<br>(Data Plane)|APIM Adv. Sec.<br>(Data Plane)|Notes|
|--- |--- |--- |--- |--- |--- |
|Amazon Linux<br>2<br>(x86_64)| Not supported|v3.0+ |Not supported|Not supported| |
|Amazon Linux<br>2017.09+<br>(x86_64)| Not supported |v3.0+|Not supported |Not supported| |
|CentOS<br>6.5+<br>(x86_64)| Not supported |v3.0+| Not supported |Not supported| &#8226; CentOS 6.5 and later versions in the CentOS 6 family are partially supported. <br> &#8226; This distribution does not support <a href="#avrd">AVRD</a>.|
|CentOS<br>7.4+<br>(x86_64)|v3.0+|v3.0+ | v3.12+ |v3.19+| &#8226; CentOS 7.4 and later versions in the CentOS 7 family are supported.|
|Debian<br>8<br>(x86_64)| Not supported |v3.0–3.21|Not supported|Not supported|&#8226; This distribution does not support <a href="#avrd">AVRD</a>.|
|Debian<br>9<br>(x86_64)|v3.0+|v3.0–3.21 | v3.12+ |v3.19+ | |
|Debian<br>10<br>(x86_64)| Not supported |v3.17+ | v3.17+ |v3.19+| See the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/) for requirements for Debian 10. |
|Red Hat Enterprise Linux<br>6.5+| Not supported |v3.0+| Not supported | Not supported| &#8226; RHEL 6.5 and later versions in the RHEL 6 family are partially supported.|
|Red Hat Enterprise Linux<br>7.4+<br>(x86_64)|v3.5+|v3.5+ | v3.12+|v3.19+| &#8226; RHEL 7.4 and later versions in the RHEL 7 family are supported.<br>&#8226; SELinux may interfere with NGINX Controller installation and operation. If you do enable SELinux, it must use permissive mode. Use of enforcing mode is not supported. |
|Red Hat Enterprise Linux<br>8.0+<br>(x86_64)|v3.22+|v3.22+ | v3.22+| Not supported | &#8226; RHEL 8.0 and later versions in the RHEL 8 family are supported. <br>&#8226; SELinux may interfere with NGINX Controller installation and operation. If you do enable SELinux, it must use permissive mode. Use of enforcing mode is not supported. |
|Ubuntu<br>18.04 LTS<br>(x86_64)|v3.0+|v3.0+ |v3.13+|v3.19+| |
|Ubuntu<br>20.04 LTS<br>(x86_64)|v3.20+|v3.12+|v3.16.1+|v3.19+| |

{{< /bootstrap-table >}}

<a name="avrd"></a>

#### Analytics, Visibility, and Reporting Daemon (AVRD)

NGINX Controller v3.1 and later use an Analytics, Visibility, and Reporting daemon (AVRD) to aggregate and report app-centric metrics, which you can use to track and check the health of your apps. To learn more about these metrics, see the [NGINX Metrics Catalog]({{< ref "/controller/analytics/catalogs/metrics.md" >}}) topic.

### Hardware Specs

The following minimum hardware specifications are required for each node running NGINX Controller:

- RAM: 8 GB RAM
- CPU: 8-Core CPU @ 2.40 GHz or similar
- Disk space: 155–255 GB free disk space. 255 GB of free space is recommended if NGINX Controller App Security is enabled. See the [Storage Requirements]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#storage-requirements" >}}) section for a categorized list of the storage requirements.

### Supported NGINX Plus Versions

NGINX Controller supports the following [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) versions:

{{< bootstrap-table "table table-striped table-bordered" >}}

| NGINX Plus | NGINX Controller | NGINX Controller ADC | NGINX Controller APIM |
|------------|------------------|----------------------|-----------------------|
| R30        | Not supported    | 3.22.9+              | Not supported         |
| R29        | Not supported    | 3.22.9+              | 3.19.6+               |
| R28        | Not supported    | 3.22.6+              | 3.19.6+               |
| R27        | Not supported    | 3.22.4+              | 3.19.6+               |
| R26        | Not supported    | 3.22.2+              | 3.19.6+               |
| R25        | Not supported    | 3.20.1+              | 3.19.2+               |
| R24        | 3.17+            | 3.20+                | 3.18+                 |
| R23        | 3.12+            | 3.20.0 - 3.22.2      | 3.18+                 |
| R22        | 3.5+             | 3.20.0 - 3.22.1      | 3.18+                 |
| R21        | 3.5 - 3.12       | Not supported        | Not supported         |
| R20        | 3.0 - 3.12       | Not supported        | Not supported         |
| R19        | 2.6 - 3.5        | Not supported        | Not supported         |

{{< /bootstrap-table >}}

---

## Sign Up for a Trial License

First, you need to sign up for a trial license for NGINX Controller. The trial includes access to NGINX Plus, the NGINX Controller Application Delivery module, and the Application Security add-on.

1. Go to [MyF5](https://account.f5.com/myf5) and create a new account.
1. Verify your account and log in to MyF5.
1. On the MyF5 landing page, activate the NGINX Controller free trial.
1. On the MyF5 **Trials** page, select Launch Your Trial.
1. Download the NGINX Controller package.
1. Make note of your Association Token. You will use this to [license your NGINX Controller instance]({{< ref "/controller/platform/licensing-controller.md#add-a-license-to-nginx-controller" >}}).

&nbsp;

---

## Install NGINX Controller Prerequisites

{{< include "controller/helper-script-prereqs.md" >}}

&nbsp;

---

## Install NGINX Controller

Install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured. NGINX Controller does not support pre-configured Kubernetes implementations at this time. The installer for NGINX Controller will install and configure Kubernetes for you.

{{< important >}}Before installing NGINX Controller, you must **disable swap on the host**; this is required by Kubernetes in order for the kubelet to work properly. Refer to your Linux distribution documentation for specific instructions for disabling swap for your system. For more information about this requirement, see the AskF5 knowledge base article [K82655201](https://support.f5.com/csp/article/K82655201) and the [kubeadm installation guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) in the Kubernetes documentation.{{< /important >}}

{{< caution >}}**For RHEL 8 deployments**, complete the additional prerequisite steps in the [Installing NGINX on RHEL 8]({{< ref "/controller/admin-guides/install/install-nginx-controller-rhel-8.md" >}}) guide before installing NGINX Controller. RHEL 8 support is a **beta** feature.{{< /caution >}}

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

      {{< see-also >}}Refer to the [NGINX Controller Technical Specifications Guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#local-or-external-storage" >}}) for more information about the volume options and requirements.{{< /see-also >}}

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
To add a license using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a PUT request to the `/platform/license` endpoint. Provide your CAT or NGINX Controller license as a base64-encoded string in the JSON request body.
{{< /see-also >}}


&nbsp;

---

## Install NGINX Plus

### Prerequisites

- Make sure to review the [NGINX Plus Technical Specifications Guide](https://docs.nginx.com/nginx/technical-specs/) for the requirements for your distribution and desired configuration.
- You'll need the NGINX Plus certificate and public key files (`nginx-repo.crt` and `nginx-repo.key`) that were provided when you signed up for the trial license. If you don't have these files, you can use the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}) to download them.

#### How to Download the NGINX Plus Cert and Key using the NGINX Controller API

The NGINX Controller API uses session cookies to authenticate requests. The session cookie is returned in response to a `GET /api/v1/platform/login` request. See the Login endpoint in the [NGINX Controller API Reference]({{< ref "/controller/api/_index.md" >}}) documentation for information about session cookie timeouts and invalidation.

{{< tip >}}
You can send a GET request to the login endpoint to find the status of the session token.
{{< /tip >}}

For example:

- Login and capture the session cookie:

  ```curl
  curl -c cookie.txt -X POST --url 'https://198.51.100.10/api/v1/platform/login' --header 'Content-Type: application/json' --data '{"credentials": {"type": "BASIC","username": "arthur@example.net","password": "<password>"}}'
  ```

- Use the session cookie to authenticate and get the session status:

  ```curl
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://198.51.100.10/api/v1/platform/login'
  ```


<br>

To use the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}) to download your NGINX Plus certificate and key bundle as a gzip or JSON file, send a GET request to the `/platform/licenses/nginx-plus-licenses/controller-provided` endpoint.

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

### Steps

Take the following steps to install NGINX Plus:

{{< important >}}
You need the NGINX Plus certificate and public key files (`nginx-repo.crt` and `nginx-repo.key`) that were provided when you signed up for the trial license.
{{< /important >}}

1. First, make sure to review the [NGINX Plus Technical Specifications Guide](https://docs.nginx.com/nginx/technical-specs/) for the requirements for your distribution and desired configuration.
2. To install NGINX Plus, follow the instructions in the [NGINX Plus Installation Guide](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/). Refer to the relevant section for your distribution.

&nbsp;

---

## Add an NGINX Plus Instance to NGINX Controller

{{< include "controller/add-existing-instance.md" >}}

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
