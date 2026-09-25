---
title: Turn off F5 WAF for NGINX
linkTitle: Turn off F5 WAF protection
description: "Turn off F5 WAF for NGINX on an F5 Application Delivery Service deployment using the F5 ADS Console."
weight: 120
toc: true
f5-docs: DOCS-000
url: /f5ads/overview/app-protect/disable-waf/
canonical: /f5ads/overview/app-protect/disable-waf/
f5-content-type: how-to
f5-product: F5 Application Delivery Service
f5-keywords: "F5 WAF, app protect, turn off, F5 ADS Console"
f5-summary: >
  This page explains how to turn off F5 WAF for NGINX on an F5 Application Delivery Service deployment through the F5 ADS Console.
  You need this when you no longer want WAF protection applied to your deployment.
f5-audience: operator
contentVars:
  product: ADS
---

## Overview

This guide explains how to turn off F5 WAF for NGINX on an F5 Application Delivery Service (F5 ADS) deployment.

## Before you start

You must remove the WAF directives from your NGINX config file before attempting to turn off WAF.

## Turn off WAF protection

{{< include "/f5ads/access-console.md" >}}

1. Go to your F5 ADS deployment.

2. Edit your deployment.

3. Turn off **WAF** for your deployment.

4. Select **Save Changes** to begin the deployment process.
