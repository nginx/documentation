---
authors: []
categories:
- installation
- infrastructure
- platform management
- services
- api management
- service mesh
- security
- analytics
date: "2020-10-26T15:32:41-06:00"
description: This quick-start tutorial shows you how to get started using NGINX Controller
  with the Application Security Add-on.
docs: DOCS-259
doctypes:
- tutorial
draft: false
journeys:
- getting started
menu:
  docs:
    parent: Installation
    weight: 20
personas:
- devops
- netops
- secops
roles:
- admin
- user
tags:
- docs
title: Trial NGINX Controller with App Security
toc: true
weight: 115
---

## Overview

This quick-start tutorial shows you how to get started using NGINX Controller with the Application Security Add-on ("App Security"). The App Security add-on to the NGINX Controller Application Delivery Module enables a web application firewall (WAF) that you can use to protect your apps.

Take the steps in this guide to deploy NGINX Controller with App Security and deploy NGINX App Protect with NGINX Plus as a data plane instance for use with NGINX Controller.

{{< caution >}}In this tutorial, NGINX Controller will install an embedded, self-hosted PostgreSQL database suitable for demo and trial purposes only. **These instructions are not meant for use in production environments**.{{< /caution >}}

{{< note >}}If you already have an active NGINX Controller trial and want to add App Security to it, you can start with the [Install NGINX App Protect with NGINX Plus](#install-nginx-app-protect-with-nginx-plus) section. {{< /note >}}

&nbsp;

---

## Technical Requirements

Be sure to review the [NGINX Controller Technical Specifications Guide]({{< relref "admin-guides/install/nginx-controller-tech-specs.md" >}}) for additional requirements for your desired distribution and configuration.

### Supported Distributions

{{< include "installer/tech-specs/nginx-controller/app-sec-oss.md" >}}

### Hardware Specs

{{< include "installer/tech-specs/nginx-controller/hw-specs.md" >}}

### Supported NGINX Versions

{{< include "installer/tech-specs/nginx-controller/supported-nginx-app-protect-versions.md" >}}

&nbsp;

---

## Sign Up for a Trial License

{{< note >}}If you already have an active NGINX Controller trial instance that you want to add App Security to, you can skip this section.{{< /note >}}

{{< include "installer/try-nginx-controller/sign-up-for-license.md" >}}

&nbsp;

---

## Install NGINX Controller Prerequisites

{{< note >}}If you already have an active NGINX Controller trial instance that you want to add App Security to, you can skip this section.{{< /note >}}

{{< include "controller/installer/helper-script/prereqs.md" >}}

&nbsp;

---

## Install NGINX Controller

{{< note >}}If you already have an active NGINX Controller trial instance that you want to add App Security to, you can skip this section.{{< /note >}}

{{< include "installer/try-nginx-controller/install-controller-trial.md" >}}

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
To add a license using the [NGINX Controller REST API]({{< relref "api/_index.md" >}}), send a PUT request to the `/platform/license` endpoint. Provide your CAT or NGINX Controller license as a base64-encoded string in the JSON request body.
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
- You'll need the NGINX Plus certificate and public key files (`nginx-repo.crt` and `nginx-repo.key`) when installing NGINX App Protect. If you don't have these files, you can use the [NGINX Controller REST API](https://docs.nginx.com/nginx-controller/api/reference/ctlr-v1) to download them.

#### Download the NGINX App Protect Cert and Key

Take the steps below to download the cert and key files by using the NGINX Controller REST API.

The NGINX Controller API uses session cookies to authenticate requests. The session cookie is returned in response to a `GET /api/v1/platform/login` request. See the Login endpoint in the [NGINX Controller API Reference]({{< relref "api/_index.md" >}}) documentation for information about session cookie timeouts and invalidation.

{{< tip >}}
You can send a GET request to the login endpoint to find the status of the session token.
{{< /tip >}}

For example:

- Login and capture the session cookie:
  
  ```curl
  curl -c cookie.txt -X POST --url 'https://198.51.100.10/api/v1/platform/login' --header 'Content-Type: application/json' --data '{"credentials": {"type": "BASIC","username": "arthur@arthurdent.net","password": "Towel$123"}}'
  ```

- Use the session cookie to authenticate and get the session status:

  ```curl
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://198.51.100.10/api/v1/platform/login'
  ```


<br>

To use the [NGINX Controller REST API]({{< relref "api/_index.md" >}}) to download your NGINX Plus certificate and key bundle as a gzip or JSON file, send a GET request to the `/platform/licenses/nginx-plus-licenses/controller-provided` endpoint.

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

{{< include "instances/deploy-app-protect.md" >}}

</div>

&nbsp;

---

## Add the NGINX App Protect Instance to NGINX Controller

{{< include "controller/instances/add-existing-instance.md" >}}

&nbsp;

---

## What's Next

You should now be ready to start your NGINX Controller with App Security trial. Refer to the following topics to get started:

- [Configure the NGINX Controller Agent]({{< relref "/admin-guides/config-agent/configure-the-agent.md" >}})
- [Set Up Metrics Collection]({{< relref "/admin-guides/config-agent/configure-metrics-collection.md" >}})
- [Forward Metrics Data to an External Service]({{< relref "/analytics/forwarders/_index.md" >}})
- [Set up NGINX Controller Services]({{< relref "/services/overview.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}