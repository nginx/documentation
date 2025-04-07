---
title: NGINX App Protect WAF 3.12
weight: 640
toc: true
type: reference
product: NAP-WAF
docs: DOCS-943
---

September 21, 2022

This release includes new signatures for [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense) feature as follows:

- Added the following Spam Bot bot signatures: RealStresser, Orbbot, xx032_bo9vs83_2a, Antoine
- Added the following Exploit Tool bot signatures: RealityCheats, Mitel MiVoice Exploiter, joxypoxy, nvd0rz, CVE-2019-11043, Anan mal 123
- Added the following Crawler bot signatures: Zoombot, Webpage Inspector Crawler, ThinkChaos
- Added the following Search Engine bot signatures: SeekportBot
- Added the following Service Agent bot signatures: PolycomRealPresenceTrio, Cisco SPA112
- Added the following HTTP Library bot signatures: pyvmomi

### New Features

- (Tech Preview) Adaptive Violation Rating (AdVR)

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_27+3.1088.1-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_27+3.1088.1-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_27+3.1088.1-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-27+3.1088.1-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-27+3.1088.1-1.el8.ngx.x86_64.rpm

##### Oracle Linux 8.1+

- app-protect-27+3.1088.1-1.el8.ngx.x86_64.rpm

### Resolved Issues

- 6587 Fixed - There are warnings and unexpected leftovers during NGINX App protect WAF uninstallation.
- 6696 Fixed - NGINX App Protect WAF compilation is triggered when the security policy is unchanged.
- 5263 Fixed - Under certain conditions, NGINX App Protect WAF may not match signatures as expected.
- 5440 Fixed - Under certain conditions, attack signature violations may not be triggered.

### **Important Notes**

- This release introduces a change in dependency of [Attack Signatures]({{< ref "/nap-waf/v4/admin-guide/install.md#attack-signatures-dependency-change-in-nginx-app-protect-waf" >}}) and [Threat Campaigns]({{< ref "/nap-waf/v4/admin-guide/install.md#threat-campaigns-dependency-change-in-nginx-app-protect-waf" >}}) packages. From version 3.12, when the user performs the clean install (installing NGINX App Protect WAF for the first time), it will install the latest  Attack Signatures/Threat Campaigns package. This will keep the customers up to date with the latest Attack Signatures/Threat Campaigns and provide protection against the latest threats.<br><br>
In case the user has an older version of NGINX App Protect WAF and never installed the Attack Signatures/Threat Campaigns package, upgrading NGINX App Protect will install the latest Attack Signatures/Threat Campaigns. However, if they have installed the Attack Signatures/Threat Campaigns package previously at any point in time, NGINX App Protect WAF will not install the latest Attack Signatures/Threat Campaigns.<br><br>
The user can upgrade or downgrade the Attack Signature/Threat Campaigns regardless of the installed version of NGINX App Protect WAF.

- As a part of the bug fix `6448`, from release 3.12, NGINX App Protect WAF will accept the Unicode characters in JSON or XML payload. The `relax_unicode_in_json` parameter is now enabled by default in NGINX App Protect WAF.<br>
In NGINX App Protect WAF versions prior to 3.12, the default value for `relax_unicode_in_json` was disabled. When the default value is enabled, a bad unicode character does not produce a JSON malformed violation. A bad unicode character might be a legal Unicode character that does not appear in the mapping of the system’s JSON parser.<br><br>
For more information, refer to article on [relax_unicode_in_json](https://support.f5.com/csp/article/K58055038).

- When upgrading the NGINX App Protect WAF deployments on Virtual Machines (VM), where the upgrade includes a NGINX Plus release upgrade as well, customers might witness some error messages about the upgrade failure. <br>
Customers are advised to ignore these messages and continue with the [upgrade procedure]({{< ref "/nap-waf/v4/admin-guide/install.md#upgrading-app-protect" >}}) as described in the NGINX App Protect WAF Admin guide.
Additional NGINX restart might be required in order to complete the upgrade procedure. The issue is fixed as a part of release 3.12 and upgrades from this release onwards should not encounter this issue.

- Adaptive Violation Rating (AdVR) capability is offered as Tech Preview for Ubuntu 20.04 (Focal Fossa) Operating System (OS). Customers who wish to evaluate this capability are encouraged to contact their local F5 App Protect WAF representative for more details.
