---
title: Enable F5 WAF for NGINX 
description: "Enable F5 WAF for NGINX on an NGINXaaS deployment using the NGINXaaS Console."
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/overview/app-protect/enable-waf/
f5-content-type: how-to
f5-product: F5 NGINXaaS
f5-keywords: "F5 WAF, app protect, enable, NGINXaaS Console"
f5-summary: >
  This page explains how to enable F5 WAF for NGINX on an NGINXaaS deployment through the NGINXaaS Console.
  You need this because WAF is disabled by default and must be turned on explicitly to protect your applications.
f5-audience: operator
contentVars:
  product: NGINXaaS
---

## Overview

This guide explains how to enable F5 WAF for NGINX on a F5 NGINX as a Service (NGINXaaS) deployment. [F5 WAF for NGINX](https://docs.nginx.com/nginx-app-protect-waf/v5) provides web application firewall (WAF) security protection for your web applications, including OWASP Top 10; response inspection; Meta characters check; HTTP protocol compliance; evasion techniques; disallowed file types; JSON & XML well-formedness; sensitive parameters & Data Guard.

## Enable F5 WAF for NGINX

F5 WAF for NGINX is disabled by default and needs to be explicitly enabled on an NGINXaaS deployment. Follow these steps:

### Using the NGINXaaS Console 

{{< include "/nginxaas/access-console.md" >}}

1. Go to your NGINXaaS deployment.

2. Edit your deployment.

3. Enable **WAF** for your deployment.

4. Select **Save Changes** to begin the deployment process.

## What's next

[Configure F5 WAF for NGINX]({{< ref "/nginxaas/overview/app-protect/configure-waf.md" >}})
