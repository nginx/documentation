---
title: Turn off F5 WAF for NGINX
description: "Turn off F5 WAF for NGINX on an NGINXaaS deployment using the NGINXaaS Console."
weight: 120
toc: true
f5-docs: DOCS-000
url: /nginxaas/overview/app-protect/disable-waf/
f5-content-type: how-to
f5-product: F5 Application Delivery Service
f5-product-former: F5 NGINXaaS
canonical: /f5ads/overview/app-protect/disable-waf/
f5-keywords: "F5 WAF, app protect, turn off, NGINXaaS Console"
f5-summary: >
  This page explains how to turn off F5 WAF for NGINX on an NGINXaaS deployment through the NGINXaaS Console.
  You need this when you no longer want WAF protection applied to your deployment.
f5-audience: operator
contentVars:
  product: NGINXaaS
---

{{< renamed-notice >}}

## Overview
This guide explains how to turn off F5 WAF for NGINX on an NGINX as a Service (NGINXaaS) deployment.

## Before you start
You must remove the WAF directives from your NGINX config file before attempting to turn off WAF.

## Turn off WAF protection

{{< include "/nginxaas/access-console.md" >}}

1. Go to your NGINXaaS deployment.

2. Edit your deployment.

3. Turn off **WAF** for your deployment.

4. Select **Save Changes** to begin the deployment process.
