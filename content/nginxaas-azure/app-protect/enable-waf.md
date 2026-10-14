---
title: Turn on F5 WAF for NGINX
weight: 200
toc: true
url: /nginxaas-azure/app-protect/enable-waf/
f5-content-type: how-to
f5-product: NGINXaaS for Azure
---

## Overview

This guide explains how to turn on F5 WAF for NGINX on a F5 NGINX as a Service for Azure (NGINXaaS) deployment. [F5 WAF for NGINX](https://docs.nginx.com/nginx-app-protect-waf/v5) provides web application firewall (WAF) security protection for your web applications, including OWASP Top 10; response inspection; Meta characters check; HTTP protocol compliance; evasion techniques; disallowed file types; JSON & XML well-formedness; sensitive parameters & Data Guard.

## Before you start

- F5 WAF for NGINX is only available on NGINXaaS for Azure deployments with the **Standard v3** [plan]({{< ref "/nginxaas-azure/billing/overview.md/#standard-v3-plan" >}}) (and the deprecated **Standard v2** [plan]({{< ref "/nginxaas-azure/billing/overview.md/#standard-v2-plan-deprecated" >}}))

## Turn on WAF protection

F5 WAF for NGINX is turned off by default. Turn it on for your NGINXaaS deployment by following these steps:

Access the [Microsoft Azure portal](https://portal.azure.com)

1. Go to your NGINXaaS for Azure deployment.

2. Select F5 WAF for NGINX in the left menu.

3. Select **Enable F5 WAF for NGINX**.

## What's next

[Configure F5 WAF for NGINX]({{< ref "/nginxaas-azure/app-protect/configure-waf.md" >}})
