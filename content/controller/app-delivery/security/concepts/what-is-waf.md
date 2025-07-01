---
description: Overview of the App Security module's WAF feature.
nd-docs: DOCS-483
title: About App Security
toc: true
weight: 100
type:
- concept
- reference
---

## Overview

The App Security Add-on for F5 NGINX Controller ADC lets you protect your applications with a web applications firewall (WAF). The WAF protects your apps from a variety of application layer attacks such as [cross-site scripting (XSS)](https://www.f5.com/services/resources/glossary/cross-site-scripting-xss-or-css), [SQL injection](https://www.f5.com/services/resources/glossary/sql-injection), and [cookie poisoning](https://www.f5.com/services/resources/glossary/cookie-poisoning), among others.

A WAF protects your web apps by filtering, monitoring, and blocking any malicious HTTP/S traffic traveling to the web application, and prevents any unauthorized data from leaving the app. It does this by adhering to a set of policies that help determine what traffic is malicious and what traffic is safe. Just as a proxy server acts as an intermediary to protect the identity of a client, a WAF operates in similar fashion but in the reverse—called a reverse proxy—acting as an intermediary that protects the web app server from a potentially malicious client.

{{< see-also >}} To learn more about what a WAF is and how it works, check out the F5 DevCentral video: [What is a Web Application Firewall?](https://www.youtube.com/watch?v=p8CQcF_9280){{< /see-also >}}

&nbsp;

## How it works

App Security on NGINX Controller provides an app‑centric self‑service model to address the security needs of modern apps.

The App Security add-on uses the NGINX App Protect Web Application Firewall (NGINX App Protect WAF) enforcement engine on the data path (data plane).
When you enable WAF on an app component using NGINX Controller, a security policy (sets of security controls and enforcement logic) is deployed and applied to configured NGINX App Protect instances that process traffic for the app component.

NGINX App Protect WAF inspects incoming traffic as specified in the Security Policy to identify potential threats. When malicious traffic is suspected or blocked, the NGINX Controller Analytics module logs security events and metrics. These are then included in the NGINX Controller Threat Visibility and Analytics reporting.

{{< see-also >}}To learn more, read the [Threat Visibility and Analytics](https://www.nginx.com/blog/threat-visibility-analytics-nginx-controller-app-security/) blog post on [nginx.com](https://nginx.com).{{< /see-also >}}

{{< img src="/ctlr/img/cas-overview.png" title="" alt="Controller App Security Overview Image" width="75%">}}

## Security Policy

In NGINX Controller, the Security Policy contains an NGINX App Protect WAF policy. The NGINX App Protect WAF policy has security controls and settings in a declarative JSON format. The Security Policy defines the rules and settings for application traffic inspection, detection of malicious traffic, and handling violations when they occur. For more about creating, updating, or deleting Security Policies, see the [Policies API Reference](https://docs.nginx.com/nginx-controller/api/ctlr-adc-api/#operation/listPolicies).

When enabling WAF to protect your Apps, you can either add your own custom Security Policy or use the default Security Policy.

## Security Strategy

A Security Strategy is a logical container for multiple Security Policies. In a Security Strategy, you can reference a Security Policy that represents a security risk profile. For example, you can map low- or high-risk security profiles to different Security Strategies as you deem fit for your Apps' specific use case or organizational needs.

When you enable security on the App Component, you can specify the Security Strategy to protect it. You can use the same Security Strategy across multiple app components. The Security Policy referenced in the Security Strategy detects and protects against malicious traffic to the App Component.

- **App Component** references **Security Strategy**;
- **Security Strategy** references **Security Policy**.

For more about creating, updating, or deleting Security Policies, see the [Strategies API Reference](https://docs.nginx.com/nginx-controller/api/ctlr-adc-api/#tag/Strategies).

You can use a custom Security Strategy to protect your Apps, or you can use NGINX Controller's default Security Strategy, which contains a pre-defined WAF policy.

{{< note >}}

The `/services/strategies/balanced_default` endpoint was replaced by `/security/strategies/balanced_default` in NGINX Controller ADC v3.18.

- Specify the `StrategyRef` setting with `/security/strategies/balanced_default` instead of `/services/strategies/balanced_default`.

Refer to the AskF5 knowledge base article [K02089505](https://support.f5.com/csp/article/K02089505) for more information.

{{< /note >}}

