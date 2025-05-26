---
title: NGINX App Protect DoS 2.1
toc: true
weight: 200
docs: DOCS-831
---

Here you can find the release information for F5 NGINX App Protect DoS v2.1. NGINX App Protect DoS provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 2.1

December 29, 2021

### New Features

- [Support for RHEL (7.4.x and above) Virtual Machine (VM) deployment]({{< ref "learn-about-deployment.md#rhel-74-installation" >}})
- [Support for RHEL 8 and UBI 8]({{< ref "learn-about-deployment.md#rhel-8-installation" >}})
- [GRPC and HTTP/2 protection support for Centos (7.4.x and above) and RHEL (7.4.x and above)]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}})

### Supported Packages

#### App Protect DoS

##### CentOS 7.4+ / RHEL 7.4+ / UBI7

- app-protect-dos-25+2.1.8-1.el7.ngx.el7.ngx.x86_64.rpm

##### RHEL 8 / UBI8

- app-protect-dos-25+2.1.8-1.el8.ngx.el8.ngx.x86_64.rpm

##### Debian 10

- app-protect-dos_25+2.1.8-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_25+2.1.8-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_25+2.1.8-1~focal_amd64.deb

#### NGINX Plus

- NGINX Plus R25

### Resolved Issues

- The `app_protect_dos_name` directive is not inherited by the inner blocks, causing to have more VSs than expected.

- Signature should not be created if good and bad actor use the same type of traffic.

- When there's a clear anomaly on the User-Agent header signal, the signature doesn't include it.

- HTTP Method signal is named incorrectly in signatures.

### Important Notes

- `proxy_request_buffering` off is not supported.

- gRPC and HTTP/2 protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for these use cases, otherwise, the attack will not be detected.

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 and RHEL 7 / UBI 7 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- The recommended option of running NGINX Plus in a Docker Container is with the `daemon off` flag. It's mandatory for UBI 8.
