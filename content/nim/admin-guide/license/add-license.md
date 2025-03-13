---
docs: DOCS-789
title: Add license
toc: true
weight: 1
type:
- how-to
---

## Overview

To unlock all of the features in NGINX Instance Manager, you’ll need to add a JSON Web Token (JWT) license from MyF5. This guide shows you how to set up your network for reporting, download the license file, and apply it to NGINX Instance Manager. If needed, you can also cancel the license at any time.

## Before you begin

### Set up your network for entitlement and usage reporting

NGINX Instance Manager can automatically report subscription entitlement and usage data to F5 if internet access is available. Ensure port `443` is open for these URLs:

- https://product.apis.f5.com/
- https://product-s.apis.f5.com/ee


## Download the license from MyF5 {#download-license}

To download the JSON Web Token license from MyF5:

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

## Add the license to NGINX Instance Manager {#apply-license}

To add the license to NGINX Instance Manager:

{{< include "nim/admin-guide/license/add-license-webui.md" >}}

NGINX Instance Manager will connect to F5’s servers to retrieve your entitlements. Once completed, your entitlements and usage details appear on the **Licenses** page.

(Optional) To automatically report license entitlement and usage data to F5, select **Enable Continuous Connection**. Make sure your network is configured for reporting.

## Canceling a license

To cancel a license:

1. Go to the **Licenses > Overview** page (`https://<NIM_FQDN>/ui/settings/license`).
2. Select **Terminate**, and confirm the action.
