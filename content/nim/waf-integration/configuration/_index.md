---
title: Set up WAF configuration management
description: Learn how to manage F5 WAF for NGINX configurations in F5 NGINX Instance Manager using the web interface or REST API.
f5-docs: 
weight: 200
f5-content-type: landing-page
f5-landing-page: true
f5-product: NIMNGR
url: /nginx-instance-manager/waf-integration/configuration/
f5-summary: >
  Set up F5 WAF for NGINX configuration management in F5 NGINX Instance Manager.
  This section covers installing the WAF compiler, onboarding WAF instances, managing configurations on those instances, and updating attack signatures and threat campaigns.
---

F5 NGINX Instance Manager helps you configure and manage F5 WAF for NGINX, so you can keep your applications secure and up to date.  
This guide explains how to set up NGINX Instance Manager to manage your WAF configurations.

## Before you begin

{{< include "/nim/waf/nim-waf-before-you-begin.md" >}}

## Featured content

{{<card-section showAsCards="true" >}}
  {{<card title="Install the WAF Compiler" titleUrl="install-waf-compiler/" >}}
    Set up the WAF compiler so NGINX Instance Manager can precompile and manage F5 WAF for NGINX security configurations.
  {{</card>}}
  {{<card title="Set up attack signatures, bot signature, and threat campaigns" titleUrl="setup-signatures-and-threats/" >}}
    Keep F5 WAF for NGINX up to date with the latest attack signatures, bot signatures, and threat campaigns.
  {{</ card >}}
    {{<card title="Set up compiler resource pruning" titleUrl="compiler-resource-pruning/" >}}
    Automatically remove unused compiled security resources in NGINX Instance Manager to keep your system clean and efficient.
  {{</ card >}}
    {{<card title="Onboard instances" titleUrl="onboard-instances/" >}}
    Connect and configure your F5 WAF for NGINX instances so they can be managed in NGINX Instance Manager.
  {{</ card >}}
    {{<card title="Configure WAF on instances" titleUrl="manage-waf-configurations/" >}}
    Configure, customize, and verify F5 WAF for NGINX policies on your managed instances.
  {{</ card >}}
    {{<card title="Troubleshooting" titleUrl="troubleshooting/" >}}
    Resolve common issues with F5 WAF for NGINX and NGINX Instance Manager by verifying installation, configuration, and connectivity.
  {{</ card >}}
{{</card-section>}}  