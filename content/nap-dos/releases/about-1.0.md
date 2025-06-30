---
title: NGINX App Protect 1.0
toc: true
weight: 260
nd-docs: DOCS-672
---

Here you can find the release information for F5 NGINX App Protect DoS v1. NGINX App Protect DoS provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 1.0

July 6, 2021

### New Features

#### Protection against application layer Denial of Service attacks

- GET and POST flood <br>
- Slowloris, Slowread, Slowpost <br>
- Distributed variations of attacks (see above) <br>
- Challenge Collapsar (CC) attack/random URIs <br>

#### False-positive management mechanisms

- HTTP Redirection
- Client-side validation
- TLS fingerprinting

#### Use Cases

#### Application Types

- Traditional HTML-based web applications
- XML-based web services
- REST APIs (JSON)

#### Deployment Options

- Kubernetes Per-pod proxy
- Kubernetes Per-service proxy
- API Gateway
- Traditional edge proxy

### Supported Packages

#### App Protect DoS

##### CentOS 7.4+

- app-protect-dos-24+1.69.6-1.el7.ngx.el7.ngx.x86_64.rpm

##### Debian 10

- app-protect-dos_24+1.69.6-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_24+1.69.6-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_24+1.69.6-1~focal_amd64.deb

#### NGINX Plus

- NGINX Plus R24

### Known Issues

- `proxy_request_buffering off` is not supported.

- NGINX App Protect DoS does not protect `grpc` and `http2` services. The traffic is bypassed.

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.
