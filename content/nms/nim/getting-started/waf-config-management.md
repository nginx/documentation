---
description: Learn how to use F5 NGINX Management Suite Instance Manager to publish
  F5 WAF for NGINX configurations.
nd-docs: DOCS-1114
title: WAF Configuration Management
toc: true
weight: 100
---

## Overview

You can use F5 NGINX Management Suite Instance Manager to publish configurations to your F5 WAF for NGINX data plane instances.

## Publish WAF Configurations

1. Set up your NGINX Management Suite Instance Manager instance:

   - [Install the WAF Compiler]({{< ref "/nim/nginx-app-protect/setup-waf-config-management#install-the-waf-compiler" >}})

   - [Set up the Attack Signatures and Threat Campaigns]({{< ref "/nim/nginx-app-protect/setup-waf-config-management#set-up-attack-signatures-and-threat-campaigns" >}})

2. In Instance Manager, [onboard the App Protect Instances]({{< ref "/nim/nginx-app-protect/setup-waf-config-management#onboard-nginx-app-protect-waf-instances" >}}) you want to publish policies and log profiles to.

3. [Create the security policies]({{< ref "/nim/nginx-app-protect/manage-waf-security-policies#create-security-policy" >}}).

4. [Create the security log profiles]({{< ref "/nim/nginx-app-protect/manage-waf-security-policies#create-security-log-profile" >}}).

5. [Add or edit a WAF Configuration]({{< ref "/nim/nginx-app-protect/setup-waf-config-management#add-waf-config" >}}) to your NGINX Instances, and publish using Instance Manager.

   {{< call-out "note" >}}Map the App Protect directives on NGINX configuration to `.tgz` file extensions (not `.json`).{{< /call-out >}}
