---
title: NGINX App Protect WAF 3.5
weight: 750
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-662
---

September 6, 2021

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_24+3.639.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_24+3.639.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_24+3.639.0-1~focal_amd64.deb

##### Alpine 3.10

- app-protect-24.3.639.0-r1.apk

##### CentOS / RHEL / Amazon Linux 2

- app-protect-24+3.639.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 4494 Added - New timeout directive which allows the user to configure the period of time between reconnect retries of the module to the web application firewall (WAF) engine.
- 4454 Fixed - Workers disconnected prematurely on reload when there is a lot of traffic.
- 4317 Fixed - Connection errors on more than 16 workers on multiple reloads.
- 4526 Fixed - Maximum policy size limit of 1MB in NGINX App Protect WAF. Limit was removed.
- 4519 Fixed - OpenAPI based policies that contains identically named path parameters with different configurations for different locations do not correctly enforce the specific validations for each unique location.
- 4560 Fixed - After a policy with a manual type signature set has been applied, changes to that signature set, or any same-named set in another policy, were not recognized.
- 4565 Fixed - Under certain conditions, NGINX App Protect WAF may crash while processing HTML traffic. Fixed CVE-2021-23050.
- 4566 Fixed - When processing certain traffic, NGINX App Protect WAF attack signatures may not match as intended. Fixed K30150004.
- 4584 Fixed - When no NGINX App Protect WAF configuration has changed on a device, but the hostname of the device has changed, NGINX App Protect WAF failed to start.

### Important Notes

This version introduces the removal of the `bd_agent` process. This process is no longer required starting with NGINX App Protect WAF version 3.5.
The removal of `bd_agent` reduces the memory usage of NGINX App Protect WAF by ~100 MB.
The `bd_agent` executable is still available on the system, but will not consume any CPU resources if it is run. Existing orchestration systems that include this process will continue to work as expected.
