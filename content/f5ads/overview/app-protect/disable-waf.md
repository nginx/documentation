---
title: Disable F5 WAF for NGINX 
description: "Disable F5 WAF for NGINX on an F5 Application Delivery Service deployment using the F5 ADS Console."
weight: 120
toc: true
f5-docs: DOCS-000
url: /f5ads/overview/app-protect/disable-waf/
f5-content-type: how-to
f5-product: F5 Application Delivery Service
f5-keywords: "F5 WAF, app protect, disable, F5 ADS Console"
f5-summary: >
  This page explains how to disable F5 WAF for NGINX on an F5 Application Delivery Service deployment through the F5 ADS Console.
  You need this when you no longer want WAF protection applied to your deployment.
f5-audience: operator
contentVars:
  product: ADS
---

## Overview

This guide explains how to disable F5 WAF for NGINX on an F5 Application Delivery Service (F5 ADS) deployment.

## Before you start

You must remove the WAF directives from your NGINX config file before attempting to disable WAF.

## Disable F5 WAF for NGINX

### Using the F5 ADS Console 

{{< include "/f5ads/access-console.md" >}}

1. Go to your F5 ADS deployment.

2. Edit your deployment.

3. Disable **WAF** for your deployment.

4. Select **Save Changes** to begin the deployment process.
