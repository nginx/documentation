---
title: Turn on F5 WAF for NGINX
linkTitle: Turn on F5 WAF protection
description: "Turn on F5 WAF for NGINX on an F5 Application Delivery Service deployment using the F5 ADS Console."
weight: 100
toc: true
f5-docs: DOCS-000
url: /f5ads/overview/app-protect/enable-waf/
canonical: /f5ads/overview/app-protect/enable-waf/
f5-content-type: how-to
f5-product: F5 Application Delivery Service
f5-keywords: "F5 WAF, app protect, turn on, F5 ADS Console"
f5-summary: >
  This page explains how to turn on F5 WAF for NGINX on an F5 Application Delivery Service deployment through the F5 ADS Console.
  You need this because WAF is off by default and must be turned on explicitly to protect your applications.
f5-audience: operator
contentVars:
  product: ADS
---

## Overview

This guide explains how to turn on F5 WAF for NGINX on an F5 Application Delivery Service (F5 ADS) deployment. [F5 WAF for NGINX](https://docs.nginx.com/nginx-app-protect-waf/v5) provides web application firewall (WAF) security protection for your web applications, including OWASP Top 10; response inspection; Meta characters check; HTTP protocol compliance; evasion techniques; disallowed file types; JSON & XML well-formedness; sensitive parameters & Data Guard.

## Turn on WAF protection

F5 WAF for NGINX is turned off by default. Turn it on for your F5 ADS deployment by following these steps:

{{< include "/f5ads/access-console.md" >}}

1. Go to your F5 ADS deployment.

2. Edit your deployment.

3. Turn on **WAF** for your deployment.

4. Select **Save Changes** to begin the deployment process.

## What's next

[Configure F5 WAF for NGINX]({{< ref "/f5ads/overview/app-protect/configure-waf.md" >}})
