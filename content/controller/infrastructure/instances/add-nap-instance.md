---
description: Learn how to register an F5 NGINX App Protect instance with NGINX Controller
  for use with the ADC module.
nd-docs: DOCS-770
title: Add an NGINX App Protect Instance
toc: true
weight: 20
type:
- how-to
---

## Overview

Follow the directions in this topic to deploy F5 NGINX App Protect and add the instance to NGINX Controller.

## Deploy NGINX App Protect

<div data-proofer-ignore>

Install NGINX App Protect on a host accessible by your NGINX Controller instance by following the appropriate steps for your operating system in the [Using NGINX App Protect with NGINX Controller]({{< ref "controller/admin-guides/install/install-for-controller.md" >}}) guide.

{{< note >}}
If you install NGINX App Protect by using any of the OS-specific install guides, **do not make changes to the `nginx.conf` file**.
The NGINX Controller Agent manages `nginx.conf` settings and will make the appropriate adjustments for you.
{{< /note >}}

</div>

## Add the NGINX App Protect Instance

Take the steps below to add the NGINX App Protect instance by using the NGINX Controller user interface.

{{< include "controller/add-existing-instance.md" >}}

## What's Next

- [Set up NGINX Controller Agent to emit Security Events]({{< ref "/controller/admin-guides/config-agent/configure-the-agent.md#enable-security-events" >}})
- [Learn about App Security]({{< ref "/controller/app-delivery/security/concepts/what-is-waf.md" >}})
- [Manage App Security]({{< ref "/controller/app-delivery/security/tutorials/add-app-security-with-waf.md" >}})

{{< versions "3.11" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
