---
nd-docs: DOCS-789
title: Add a license (connected)
description: "Download a JWT license from MyF5 and apply it to F5 NGINX Instance Manager in a connected (internet-accessible) environment."
toc: true
weight: 10
nd-content-type: how-to
nd-product: NIMNGR
nd-summary: >
  Download a JWT license from MyF5 and apply it to F5 NGINX Instance Manager in a connected environment to unlock all features.
  The license validates your subscription and enables automatic usage reporting to F5 over the internet.
---

{{< call-out "note" "F5 NGINX Instance Manager 2.22 and later" >}}Starting with version 2.22, NGINX Instance Manager no longer requires a JWT license. All features are available immediately after installation. If you're running version 2.21 or earlier, follow the steps on this page.{{< /call-out >}}

## Overview

To unlock all features in NGINX Instance Manager, you'll need to add a JSON Web Token (JWT) license from MyF5. This guide shows you how to set up your network for reporting, download the license file, and apply it to NGINX Instance Manager. You can also cancel the license at any time.

## Before you begin

NGINX Instance Manager automatically reports subscription entitlement and usage data to F5 when internet access is available. Make sure port `443` is open for these URLs:

- https://product.apis.f5.com/
- https://product-s.apis.f5.com/ee


## Download the license from MyF5 {#download-license}

To download the JSON Web Token license from MyF5:

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

## Add the license to NGINX Instance Manager {#apply-license}

To add the license to NGINX Instance Manager:

{{< include "nim/admin-guide/license/add-license-webui.md" >}}

NGINX Instance Manager connects to F5's servers to retrieve your entitlements. When complete, your entitlements and usage details appear on the **Licenses** page.

(Optional) To automatically report license entitlement and usage data to F5, select **Enable Continuous Connection**. Verify your network is set up for reporting.

## Cancel a license

To cancel a license:

1. Go to the **Licenses > Overview** page (`https://<NIM_FQDN>/ui/settings/license`).
2. Select **Terminate**, and confirm the action.
