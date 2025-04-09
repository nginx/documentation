---
title: NGINX App Protect WAF 3.10
weight: 680
toc: true
type: reference
product: NAP-WAF
docs: DOCS-846
---

May 25, 2022

This release includes updated signatures for the [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense) feature as follows:

- Added the following Spam Bot bot signatures: MediaControl Rumble, Internet Fuzzer, NEKO
- Added the following Service Agent bot signatures: ShadowByte, BackupLand, Virusdie, DropboxPreviewBot, GnowitNewsbot, SiteScoreBot, Hardenize
- Added the following Exploit Tool bot signatures: Jndi Tomcat Exploiter, struts-pwn, Onapsis ICMAD tool, b3astmode, TNAS, Abyssal, Web shell injector for Joomla, QBOT
- Added the following Crawler bot signatures: FAST Enterprise Crawler, fluid, ANSSI, INETDEX-BOT, BluechipBacklinks, MRGbot, webgains-bot
- Added the following HTTP Library bot signatures: AutoIt
- Added the following Vulnerability Scanner bot signatures: SpringShell XSS Detector
- Updated the following Exploit Tool bot signatures: Hello, World
- Updated the following Spam Bot bot signatures: facebot
- Updated the following Service Agent bot signatures: unshortenit
- Updated the following Search Engine bot signatures: startpage, startpage

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_26+3.890.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_26+3.890.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_26+3.890.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-26+3.890.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-26+3.890.0-1.el8.ngx.x86_64.rpm

### Resolved Issues

- 5800 Fixed - Fixed warning message on Attack Signatures or Threat Campaigns removal on debian-based operating systems.
- 5946 Fixed - When using custom security policy in transparent mode with bot defense enabled - NGINX App Protect WAF blocks requests without User-Agent.
- 5947 Fixed - When using default security policy - NGINX App Protect WAF reports wrong [outcome_reason]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#available-security-log-attributes" >}})) when sending requests without User-Agent.
- 5780 Fixed - Vulnerability in NGINX App Protect WAF allows a user in some particular circumstances to compose a Security Policy with arbitrary code which will be executed where it is deployed.
- 6008 Fixed - Using an external reference `botDefenseReference` for the bot-defense configuration did not correctly take effect on the policy.
- 6196 Fixed - Updated information on changing the [total_xml_memory]({{< ref "/nap-waf/v4/admin-guide/install.md#post-installation-checks" >}}) value in NGINX App Protect WAF Admin guide.

### **Important Note**

When upgrading the NGINX App Protect WAF deployments on Virtual Machines (VM), where the upgrade includes a NGINX Plus release upgrade as well, customers might witness an error message about the upgrade failure.<br>
Customers are advised to ignore this message and continue with the [upgrade procedure]({{< ref "/nap-waf/v4/admin-guide/install.md#upgrading-app-protect" >}}) as described in the NGINX App Protect WAF Admin guide.
