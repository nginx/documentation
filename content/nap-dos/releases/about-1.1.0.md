---
title: NGINX App Protect DoS Arbitrator 1.1.0
toc: true
weight: 220
docs: DOCS-673
---

Here you can find the release information for F5 NGINX App Protect DoS Arbitrator v1.1.0.

## Arbitrator Service Release 1.1.0

December 1, 2021

This release is focused on security and stability.

### New Features

- Improve security by enabling the arbitrator to work as a non-root user.

- Remove operating system dependencies to work as a native service utilizing golang.

### Resolved Issues

- Special characters like a slash inside the protected object name prevented Arbitrator to save the state file.

### Important Notes

- The current release upgrades Arbitrator service only. This change is agnostic to NGINX App Protect DoS functionalities.

- `proxy_request_buffering` off is not supported.

- gRPC and HTTP/2 protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for these use cases, otherwise, the attack will not be detected.

- gRPC and HTTP/2 protection are available only on Debian 10, Ubuntu 18.04, and Ubuntu 20.04 platforms. For the rest of the platforms, NGINX App Protect DoS does not protect gRPC and HTTP/2 services. The traffic is bypassed.

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- New optional configuration parameters of the directive `app_protect_dos_monitor` to support gRPC and HTTP/2 protocols.
- Added new fields in Security Log:

  - `baseline_dps` (datagrams per second) instead of `baseline_tps`, `incoming_datagrams` <br>
  - `successful_responses` instead of `successful_transactions` <br>
  - `unsuccessful_requests` instead of `unsuccessful_requests_count`.

- In the case of an upgrade from the previous `app-protect-dos` version, it's necessary to remove the old `nginx-plus` and install the new `app-protect-dos` that will install a correspondent version of `nginx-plus` as described in the [NGINX App Protect DoS Deployment Guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}).
