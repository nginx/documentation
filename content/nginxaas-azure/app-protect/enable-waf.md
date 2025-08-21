---
title: Enable App Protect WAF
weight: 200
toc: true
url: /nginxaas/azure/app-protect/enable-waf/
type:
- how-to
---

## Overview

This guide explains how to enable F5 F5 WAF for NGINX on a F5 NGINX as a Service for Azure (NGINXaaS) deployment. [F5 F5 WAF for NGINX](https://docs.nginx.com/nginx-app-protect-waf/v5) provides web application firewall (WAF) security protection for your web applications, including OWASP Top 10; response inspection; Meta characters check; HTTP protocol compliance; evasion techniques; disallowed file types; JSON & XML well-formedness; sensitive parameters & Data Guard.

## Before you start
- F5 WAF for NGINX can only be enabled on NGINXaaS for Azure deployments with the **Standard v2** [plan]({{< ref "/nginxaas-azure/billing/overview.md" >}})

## Enable NGINX App Protect

NGINX App Protect is disabled by default and needs to be explicitly enabled on an NGINXaaS deployment. Follow these steps:

### Using the Microsoft Azure Portal

Access the [Microsoft Azure portal](https://portal.azure.com)

1. Go to your NGINXaaS for Azure deployment.

2. Select NGINX app protect in the left menu.

3. Select **Enable App Protect**.

## What's next

[Configure App Protect WAF]({{< ref "/nginxaas-azure/app-protect/configure-waf.md" >}})
