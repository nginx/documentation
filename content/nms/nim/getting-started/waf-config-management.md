---
description: Learn how to use F5 NGINX Management Suite Instance Manager to publish
  NGINX App Protect WAF configurations.
docs: DOCS-1114
title: WAF Configuration Management
toc: true
weight: 100
---

## Overview

You can use F5 NGINX Management Suite Instance Manager to publish configurations to your NGINX App Protect WAF data plane instances.

## Publish WAF Configurations

1. Set up your NGINX Management Suite Instance Manager instance:

   - [Install the WAF Compiler]({{< relref "/nim/nginx-app-protect/setup-waf-config-management#install-the-waf-compiler" >}})

   - [Set up the Attack Signatures and Threat Campaigns]({{< relref "/nim/nginx-app-protect/setup-waf-config-management#set-up-attack-signatures-and-threat-campaigns" >}})

2. In Instance Manager, [onboard the App Protect Instances]({{< relref "/nim/nginx-app-protect/setup-waf-config-management#onboard-nginx-app-protect-waf-instances" >}}) you want to publish policies and log profiles to.

3. [Create the security policies]({{< relref "/nim/nginx-app-protect/manage-waf-security-policies#create-security-policy" >}}).

4. [Create the security log profiles]({{< relref "/nim/nginx-app-protect/manage-waf-security-policies#create-security-log-profile" >}}).

5. [Add or edit a WAF Configuration]({{< relref "/nim/nginx-app-protect/setup-waf-config-management#add-waf-config" >}}) to your NGINX Instances, and publish using Instance Manager.

   {{<note>}}Map the App Protect directives on NGINX configuration to `.tgz` file extensions (not `.json`).{{< /note >}}
