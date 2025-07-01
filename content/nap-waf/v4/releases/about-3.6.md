---
title: NGINX App Protect WAF 3.6
weight: 740
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-663
---

October 13, 2021

In this release support for NGINX App Protect WAF is added to NGINX Plus R25.

### New Features

[New configuration setting added for never logging requests from a specified IP address range]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#deny-allow-and-never-log-lists" >}})

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_25+3.671.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_25+3.671.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_25+3.671.0-1~focal_amd64.deb

##### CentOS / RHEL / Amazon Linux 2

- app-protect-25+3.671.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 4578 Fixed - Signature sets with *alarm* and *block* turned off still contribute to Violation Rating.
- 4461 Fixed - When installing an older version of NGINX App Protect WAF in Debian/Ubuntu system, the installation fails due to unmet dependent packages.
- 4658 Fixed - Fixing issue with input normalization.
- 4704 Fixed - The package for Red Hat Universal Base Image 7 (RHEL UBI7) (registry.redhat.io/ubi7/ubi) supports image tag [7.9-511](https://catalog.redhat.com/software/containers/ubi7/ubi/5c3592dcd70cc534b3a37814?tag=7.9-511&push_date=1633049208000). More recent base images are not yet supported.

### Known Issues

- 4236 - Policy converter currently supports exported policies in XML format from BIG-IP versions up to 16.0.x. No limitation for exported policies in JSON format.
