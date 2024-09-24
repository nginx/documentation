---
description: This document outlines the requirements for the NGINX Management Suite
  and NGINX Agent, such as compatible platforms, hardware specifications, sizing advice,
  compatible web browsers, and more.
docs: DOCS-805
doctypes: reference
title: Technical Specifications
toc: true
weight: 20
---

## Overview

{{< include "nms/nim-core-module.md" >}}

---

## F5 NGINX Management Suite

The guidelines in this section are applicable to the entire NGINX Management Suite gateway. Further, module-specific guidelines are highlighted in the respective sections of this document.

### Support for Prior Releases

Unless otherwise specified in the release notes, NGINX typically supports the **three most recent releases** of Instance Manager and NGINX App Protect WAF. This means, for example, if the latest release of Instance Manager is 2.11.0, NGINX would support versions ranging from 2.8.0 to 2.11.0. The same principle applies to the other modules.

If you are using an older version of a module, you might need to upgrade to an intermediate version before upgrading to the final version you want. Make sure to follow the recommended upgrade paths mentioned in each module's release notes for a successful upgrade process. For more detailed information and guidance on the upgrade process, you can refer to the [Upgrade Guide]({{<relref "/nms/installation/upgrade-guide.md" >}}).

**Module release notes**:

- [Instance Manager]({{< relref "/nms/nim/releases/release-notes.md" >}})
- [NGINX App Protect WAF]({{< relref "/nap-waf/v4/releases/_index.md" >}})

### Supported Linux Distributions {#supported-distributions}

{{< include "tech-specs/nms-supported-distros.md" >}}

<br>

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

## Security Monitoring Module {#security-monitoring}

### Dependencies with Instance Manager

{{< include "tech-specs/security-management-plane-dependencies.md" >}}

### Dependencies with NGINX App Protect WAF and NGINX Plus

{{< include "tech-specs/security-data-plane-dependencies.md" >}}

---

## NGINX Agent (Data Plane)

### Supported Distributions

The NGINX Agent can run on most environments. For the supported distributions, see the [NGINX Agent Technical Specs](https://docs.nginx.com/nginx-agent/technical-specifications/) guide.
