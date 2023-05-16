---
title: "Installation Guide"
description: "Follow the steps in this guide to install the NGINX Management Suite Instance Manager and API Connectivity Manager modules."
date: "2021-12-21T12:00:00-07:00"
toc: true
versions: []
weight: 200

categories:
- installation
- platform management
doctypes:
- tutorial
draft: false
journeys:
- getting started
- using
personas:
- devops
- netops
- secops
- support
tags:
- docs
docs: "DOCS-799"
aliases: 
- /nginx-instance-manager/getting-started/installation/install-guide/
- /nginx-instance-manager/installation/install-guide/
- /admin-guides/installation/install-guide/
---

{{< custom-styles >}}

## Overview

{{< include "nms/nim-core-module.md" >}}

## Requirements

To install the NGINX Management Suite, you need the following:

- A trial or paid subscription for NGINX Management Suite. Sign up for [NGINX Management Suite at MyF5](https://account.f5.com/myf5).
- A Linux instance for hosting the NGINX Management Suite platform and modules.
- An installed version of [NGINX Plus or NGINX OSS](#install-nginx).

Make sure to open any network firewall so external systems have access. NGINX Management Suite uses port `443` for both the gRPC and API/web interfaces.

---

## Prepare Your Platform

### Install NGINX {#install-nginx}

{{< include "nms/prepare-nms-platform/install-nginx.md" >}}

### Install ClickHouse {#install-clickhouse}

{{< include "nms/prepare-nms-platform/install-clickhouse.md" >}}

### (Optional) Install and Configure Vault {#install-vault}

{{< include "nms/prepare-nms-platform/configure-vault.md" >}}

### Add NGINX Management Suite Repository {#add-nms-repo}

To install NGINX Management Suite, you need to add the official repository to pull the pre-compiled `deb` and `rpm` packages from.

#### Download Repository Certificate and Key Files

{{< include "nms/prepare-nms-platform/place-cert-key-files.md" >}}

#### Set Up NGINX Management Suite Repository {#add-yum-apt}

Select the tab matching your distribution type, then follow the instructions to set up the NGINX Management Suite repository.

<br>

{{<tabs name="install_repo">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

{{< include "nms/prepare-nms-platform/add-nms-yum-repo.md" >}}

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

{{< include "nms/prepare-nms-platform/add-nms-apt-repo.md" >}}

{{%/tab%}}
{{</tabs>}}

---

## Install NGINX Management Suite Modules {#install-nms-modules}

Select the tab for the NGINX Management Suite module that you want to install.

<br>

{{<tabs name="install-nms-modules">}}

{{%tab name="Instance Manager"%}}

## Install Instance Manager

{{< include "nim/installation/install-nim.md" >}}

### Enable and Start the Platform Services

{{< include "nms/services/enable-start-nms-nim.md" >}}

### Post-Installation Steps

{{< include "admin-guides/installation/optional-installation-steps.md" >}}

{{%/tab%}}

{{%tab name="API Connectivity Manager"%}}

## Dependencies with Instance Manager

{{< include "tech-specs/acm-nim-dependencies.md" >}}

---

## Install ACM on Management Plane

{{< include "acm/installation/install-acm.md" >}}

### Post-Installation Steps

{{< include "admin-guides/installation/optional-installation-steps.md" >}}

### Start and Enable ACM Services

{{< include "acm/installation/enable-start-nms-acm.md" >}}

---

## Install ACM Data Plane

{{< include "acm/installation/install-acm-dataplane.md" >}}

---

## Install Developer Portal

{{< include "acm/installation/install-acm-dev-portal.md" >}}

{{%/tab%}}

{{%tab name="Security Monitoring"%}}

## Install Security Monitoring Module

### Dependencies with Instance Manager

{{< include "tech-specs/security-management-plane-dependencies.md" >}}

### Installation Steps

{{< include "security/install-sm.md" >}}

---

## Set Up Data Plane Instances for Security Monitoring

Follow the steps in the [Setup Guide]({{< relref "/nms/security/how-to/set-up-app-protect-instances" >}}) to set up your NGINX App Protect WAF data plane instances for use with Security Monitoring.

{{%/tab%}}

{{</tabs>}}

---

## Access the Web Interface {#web-interface}

{{< include "nms/access-web-interface.md" >}}

---

## How To Look Up the Installed Version

{{< include "nms/look-up-version.md" >}}

---

## Troubleshooting

{{< include "support/troubleshooting-guide.md" >}}

---

## What's Next

- [Add a License]({{< relref "/nms/admin-guides/getting-started/add-license.md" >}})
- [Troubleshoot Issues]({{< relref "/nms/support/troubleshooting.md" >}})
- [Configure Instance Manager with a Config File]({{< relref "/nms/admin-guides/getting-started/configure-with-config.md" >}})
