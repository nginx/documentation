---
authors: []
categories:
- services
- apps
- security
date: "2020-10-26T15:32:41-06:00"
description: Overview of the App Security module's WAF feature
docs: DOCS-483
doctypes:
- concept
- reference
draft: false
journeys:
- researching
- using
personas:
- devops
- netops
- secops
- support
roles:
- admin
tags:
- docs
title: About App Security
toc: true
weight: 100
---

## Overview

{{< include "security/what-is-waf.md" >}}

&nbsp;

## How it works

App Security on NGINX Controller provides an app‑centric self‑service model to address the security needs of modern apps.

The App Security add-on uses the NGINX App Protect Web Application Firewall (NGINX App Protect WAF) enforcement engine on the data path (data plane).
When you enable WAF on an app component using NGINX Controller, a security policy (sets of security controls and enforcement logic) is deployed and applied to configured NGINX App Protect instances that process traffic for the app component.

NGINX App Protect WAF inspects incoming traffic as specified in the Security Policy to identify potential threats. When malicious traffic is suspected or blocked, the NGINX Controller Analytics module logs security events and metrics. These are then included in the NGINX Controller Threat Visibility and Analytics reporting.

{{< see-also >}}To learn more, read the [Threat Visibility and Analytics](https://www.nginx.com/blog/threat-visibility-analytics-nginx-controller-app-security/) blog post on [nginx.com](https://nginx.com).{{< /see-also >}}

{{< img src="/ctlr/img/cas-overview.png" title="" alt="Controller App Security Overview Image" width="75%">}}

## Security Policy

In NGINX Controller, the Security Policy contains an NGINX App Protect WAF policy. The NGINX App Protect WAF policy has security controls and settings in a declarative JSON format. The Security Policy defines the rules and settings for application traffic inspection, detection of malicious traffic, and handling violations when they occur. For more about creating, updating, or deleting Security Policies, see the [Policies API Reference](https://docs.nginx.com/nginx-controller/api/reference/ctlr-v1/adc/docs/policies/v1/content/intro).

When enabling WAF to protect your Apps, you can either add your own custom Security Policy or use the default Security Policy.

## Security Strategy

A Security Strategy is a logical container for multiple Security Policies. In a Security Strategy, you can reference a Security Policy that represents a security risk profile. For example, you can map low- or high-risk security profiles to different Security Strategies as you deem fit for your Apps' specific use case or organizational needs.

When you enable security on the App Component, you can specify the Security Strategy to protect it. You can use the same Security Strategy across multiple app components. The Security Policy referenced in the Security Strategy detects and protects against malicious traffic to the App Component.
- **App Component** references **Security Strategy**; 
- **Security Strategy** references **Security Policy**.

For more about creating, updating, or deleting Security Policies, see the [Strategies API Reference](https://docs.nginx.com/nginx-controller/api/reference/ctlr-v1/adc/docs/strategies/v1/content/intro).

You can use a custom Security Strategy to protect your Apps, or you can use NGINX Controller's default Security Strategy, which contains a pre-defined WAF policy.

{{< note >}} 

The `/services/strategies/balanced_default` endpoint was replaced by `/security/strategies/balanced_default` in NGINX Controller ADC v3.18. 

- Specify the `StrategyRef` setting with `/security/strategies/balanced_default` instead of `/services/strategies/balanced_default`.

Refer to the AskF5 knowledge base article [K02089505](https://support.f5.com/csp/article/K02089505) for more information.

{{< /note >}}

