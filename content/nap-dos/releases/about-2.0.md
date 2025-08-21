---
title: F5 DoS for NGINX 2.0
toc: true
weight: 220
nd-docs: DOCS-674
---

Here you can find the release information for F5 F5 DoS for NGINX v2.0. F5 DoS for NGINX provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 2.0

October 20, 2021

### New Features

#### [Protection of gRPC services against application layer Denial of Service attacks]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}})

- **Message flood**
  Attacker supplies multiple gRPC requests that exceed the service capacity.
- **Concurrent large requests**
  Attacker supplies a number of concurrent large requests that exceed the server capacity of concurrent requests.
- **Slow gRPC POST**
  Attacker supplies a number of concurrent slow POST gRPC requests that exceed the server capacity of concurrent requests.
- **HTTP/2 attack on gRPC service**
  Attacker runs typical DoS HTTP/2 attacks: HTTP flood and slow attacks on gRPC service.

#### [Protection of HTTP/2 services against application layer Denial of Service attacks]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}})

### Supported Packages

#### App Protect DoS

##### CentOS 7.4+ / UBI7

- app-protect-dos-25+2.0.1-1.el7.ngx.el7.ngx.x86_64.rpm

##### Debian 10

- app-protect-dos_25+2.0.1-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_25+2.0.1-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_25+2.0.1-1~focal_amd64.deb

#### NGINX Plus

- NGINX Plus R25

### Resolved Issues

- Security log keeps working on removed Protected Objects.

- Monitoring requests show up in the access log.

- `app_protect_dos_name` longer than 32 characters creates a garbage name in the logs.

- Created protected objects for the not configured contexts.

- Wrong reporting of attack status with arbitrator.

- Wrong `impact_rps` value in **Bad actor expired** log message.

- Rate limit in Access Log should be optional.

### Important Notes

- `proxy_request_buffering` off is not supported.

- gRPC and HTTP/2 protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for these use cases, otherwise, the attack will not be detected.

- gRPC and HTTP/2 protection are available only on Debian 10, Ubuntu 18.04 and Ubuntu 20.04 platforms. For the rest of the platforms, F5 DoS for NGINX does not protect gRPC and HTTP/2 services. The traffic is bypassed.

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- New optional configuration parameters of the directive `app_protect_dos_monitor` to support gRPC and HTTP/2 protocols.
- Added new fields in Security Log:

  - `baseline_dps` (datagrams per second) instead of `baseline_tps`, `incoming_datagrams` <br>
  - `successful_responses` instead of `successful_transactions` <br>
  - `unsuccessful_requests` instead of `unsuccessful_requests_count`.

- In the case of an upgrade from the previous `app-protect-dos` version, it's necessary to remove the old `nginx-plus` and install the new `app-protect-dos` that will install a correspondent version of `nginx-plus` as described in the [F5 DoS for NGINX Deployment Guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}).
