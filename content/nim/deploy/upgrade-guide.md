---
description: This guide explains how to upgrade NGINX Instance Manager, NGINX Agent, and NGINX Plus.
docs: DOCS-920
doctypes:
- tutorial
tags:
- docs
title: Upgrade Guide
toc: true
weight: 600
draft: true
---

## Overview

This guide explains how to upgrade NGINX Instance Manager, NGINX Agent, and NGINX Plus to their latest versions. It includes steps to back up your current configuration, run the upgrade script, and verify the results. You’ll also find instructions for troubleshooting any potential upgrade issues.

{{< call-out "tip" "" "">}}Make sure to read the NGINX Instance Manager release notes for important information before upgrading.{{</call-out>}}

---

##  {#pre-upgrade-steps}

- Review release notes
- 



## Upgrade NGINX Instance Manager

### Instance Manager

- [Upgrade Instance Manager on a virtual machine or bare metal]({{< relref "/nim/deploy/vm-bare-metal/install.md#upgrade-nim" >}})
- [Upgrade Instance Manager from a Helm Chart]({{< relref "/nim/deploy/kubernetes/deploy-using-helm.md#helm-upgrade-nim" >}})
- [Upgrade Instance Manager in an offline environment]({{< relref "/nim/disconnected/offline-install-guide.md#upgrade-nim-offline" >}})

### Security Monitoring

- [Upgrade Security Monitoring on a virtual machine or bare metal]({{< relref "/nim/monitoring/security-monitoring/deploy/install-security-monitoring.md#upgrade-security-monitoring" >}})

---

## Upgrade NGINX Agent {#upgrade-nginx-agent}

To upgrade NGINX Agent, refer to the [NGINX Agent Installation and Upgrade Guide](https://docs.nginx.com/nginx-agent/installation-upgrade/).

---

## Upgrade NGINX Plus

For instructions on upgrading NGINX Plus, see the [NGINX Plus Installation and Upgrade Guide](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

---

## Troubleshooting

If you encounter problems with the upgrade, you can [create a support package]({{< relref "/nms/support/support-package.md" >}}). The support package script compiles system and service information into a tar archive for troubleshooting. If you contact [NGINX Customer Support]({{< relref "/nms/support/contact-support.md" >}}), they may ask you to provide the support package file.

The [AskF5 knowledge base](https://support.f5.com/csp/home) is a helpful resource for articles related to upgrade issues and solutions.