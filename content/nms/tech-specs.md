---
date: "2021-12-21T12:00:00-07:00"
doctypes: reference
draft: false
title: Technical Specifications
description: This document outlines the requirements for the NGINX Management Suite and NGINX Agent, such as compatible platforms, hardware specifications, sizing advice, compatible web browsers, and more.
toc: true
weight: 20
docs: "DOCS-805"
aliases:
- /nginx-instance-manager/getting-started/technical-specifications/
- /nginx-instance-manager/about/technical-specifications/

---

{{< custom-styles >}}

## Overview

{{< include "nms/nim-core-module.md" >}}

---

## NGINX Management Suite

The guidelines in this section are applicable to the entire NGINX Management Suite gateway. Further, module-specific guidelines are highlighted in the respective sections of this document.

### Supported Distributions {#supported-distributions}

{{< include "tech-specs/nms-supported-distros.md" >}}

{{< note >}}If you're installing the API Connectivity Manager module, make sure to review the [supported distributions for the Developer Portal host](#dev-portal-supported-distributions). That list varies slightly from this one.{{< /note >}}

### Supported Deployment Environments {#supported-environments}

You can deploy the NGINX Management Suite gateway in the following environments:

- Bare Metal
- Container
- Public Cloud: AWS, Google Cloud Platform, and Microsoft Azure
- Virtual Machine

### Supported NGINX Versions {#nginx-versions}

{{< include "tech-specs/supported-nginx-versions.md" >}}

### Firewall Ports {#firewall}

The NGINX Management Suite and NGINX Agent services use the Unix domain socket by default and proxy through the gateway on port `443`.

### Supported Browsers {#supported-browsers}

The NGINX Management Suite web interface works best on the newest versions of these browsers:

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge)

### Logging {#logging}

The NGINX Management Suite stores its log files in `/var/log/nms`. To prevent your system from running out of disk space due to log growth, we suggest creating a separate partition for the logs or enabling [log rotation](http://nginx.org/en/docs/control.html#logs).

---

## Instance Manager {#instance-manager-tech-specs}

### Sizing Recommendations {#system-sizing}

The following sizing recommendations are the minimum sizing guidelines for Instance Manager. For improved performance, we strongly suggest using SSDs as your storage option.

### Standard NGINX Configuration Deployments

{{< include "tech-specs/nim-sizing-standard-deployment.md" >}}

### Large NGINX Configuration Deployments

{{< include "tech-specs/nim-sizing-large-deployment.md" >}}

### Support for NGINX App Protect WAF

{{< include "tech-specs/nim-app-protect-support.md" >}}

---

## API Connectivity Manager {#acm-tech-specs}

### Dependencies with Instance Manager

{{< include "tech-specs/acm-nim-dependencies.md" >}}

### ACM Supported NGINX Versions {#acm-supported-nginx}

{{< include "tech-specs/acm-supported-nginx.md" >}}

### Developer Portal Supported Distributions {#dev-portal-supported-distributions}

{{< include "tech-specs/acm-dev-portal-supported-distros.md" >}}

---

## Security Monitoring Module {#security-monitoring}

### Dependencies with Instance Manager

{{< include "tech-specs/security-management-plane-dependencies.md" >}}

### Dependencies with NGINX App Protect WAF and NGINX Plus

{{< include "tech-specs/security-data-plane-dependencies.md" >}}

---

## NGINX Agent (Data Plane)

### Supported Distributions

The NGINX Agent can run on most environments. For the supported distributions, see the [NGINX Technical Specs](https://docs.nginx.com/nginx/technical-specs/#supported-distributions) guide.

### Supported Deployment Environments {#agent-environments}

You can deploy the NGINX Agent in the following environments:

- Bare Metal
- Container
- Public Cloud: AWS, Google Cloud Platform, and Microsoft Azure
- Virtual Machine

### Supported NGINX Versions

The NGINX Agent works with all versions of NGINX OSS and NGINX Plus.

### Sizing Recommendations

{{< include "tech-specs/agent-sizing-recommendations.md" >}}

### Logging

The NGINX Agent utilizes log files and formats to collect metrics. Increasing the log formats and instance counts will result in increased log file sizes. To prevent system storage issues due to a growing log directory, it is recommended to add a separate partition for `/var/log/nginx-agent` and enable [log rotation](http://nginx.org/en/docs/control.html#logs).