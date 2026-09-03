---
title: Disable F5 WAF for NGINX 
description: "Disable F5 WAF for NGINX on an NGINXaaS deployment using the NGINXaaS Console."
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/overview/app-protect/disable-waf/
f5-content-type: how-to
f5-product: F5 NGINXaaS
f5-keywords: "F5 WAF, app protect, disable, NGINXaaS Console"
f5-summary: >
  This page explains how to disable F5 WAF for NGINX on an NGINXaaS deployment through the NGINXaaS Console.
  You need this when you no longer want WAF protection applied to your deployment.
f5-audience: operator
contentVars:
  product: NGINXaaS
---

## Overview
This guide explains how to disable F5 WAF for NGINX on an NGINX as a Service (NGINXaaS) deployment.

## Before you start
You must remove the WAF directives from your NGINX config file before attempting to disable WAF.

## Disable F5 WAF for NGINX

### Using the NGINXaaS Console 

{{< include "/nginxaas/access-console.md" >}}

1. Go to your NGINXaaS deployment.

2. Edit your deployment.

3. Disable **WAF** for your deployment.

4. Select **Save Changes** to begin the deployment process.
