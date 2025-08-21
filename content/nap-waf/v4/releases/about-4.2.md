---
title: F5 WAF for NGINX 4.2
weight: 310
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1172
---

March 29, 2023

This release includes new signatures for [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense):

- Added the following Site Monitor bot signatures: 404enemy, Munin Monitor
- Added the following Spam Bot bot signatures: 01h4x, AIBOT
- Added the following Service Agent bot signatures: 404checker, Adyen, Autohost Threat Intel API, Paystack, Pixalate, PureRef, TwilioProxy, SpamExperts
- Added the following Crawler bot signatures: FullStoryBot, GeedoBot, infoobot, IonCrawl, MuscatFerret Crawler, NETVIBES Crawler, SeobilityBot, SMTBot, Summify, WEDOS Crawler, Yahoo Ad monitoring
- Added the following RSS Reader bot signatures: Feed Wrangler, flusio, Page2RSS, Unread RSS Reader
- Added the following Vulnerability Scanner bot signature: Node.js, zerodium Tester
- Added the following DoS Tool bot signature: Siege DoS Tool
- Added the following Exploit Tool bot signature: Criptonize Mirai Installer


### New Features

- [GraphQL Protection]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#securing-graphql-apis-with-nginx-app-protect-waf" >}})

### Supported Packages

#### App Protect

##### Debian 11

- app-protect_28+4.218.0-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect_28+4.218.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_28+4.218.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-28+4.218.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-28+4.218.0-1.el8.ngx.x86_64.rpm

##### Alpine 3.16

- app-protect-28.4.218.0-r1.apk

##### Oracle Linux 8.1+

- app-protect-28+4.218.0-1.el8.ngx.x86_64.rpm


### Resolved Issues

- 7411 Fixed - The Protocol Buffers library has been updated to enable the usage of keywords that were previously unsupported in gRPC IDL files.

- 7986 Fixed - When converting a policy from BIG-IP, collections with wildcardOrder, such as "urls", may result with the default "*" element being in the wrong order relative to the other wildcard entries. This lead to unexpected and incorrect policy enforcement.
convert-policy now writes these elements in the correct order. Importing a policy with an unexpected order also works as expected.

- 7939 Fixed - Requests blocked due to `VIOL_ATTACK_SIGNATURE` although all signatures disabled.

- 7199 Fixed - Alignment of notification and availability of NGINX App Protect Signature updates.


### **Important Note**

- This release introduces a change in the package dependencies for F5 WAF for NGINX. Customers who work in a SELinux-enforced environment should now explicitly list `app-protect-selinux` package when performing App Protect clean install and upgrade.<br><br>
F5 WAF for NGINX’s SELinux module is now an optional package (meaning -  **not included in default installation**). In order to install `app-protect` with `app-protect-selinux` package, use the following command:<br>

  ```shell
  yum install app-protect app-protect-selinux
  ```
