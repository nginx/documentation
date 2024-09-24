---
description: ''
docs: DOCS-995
doctypes:
- task
title: NGINX App Protect DoS Release 3.1
toc: true
weight: 140
---

Here you can find the release information for F5 NGINX App Protect DoS v3.1. NGINX App Protect DoS provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 3.1

November 29, 2022

In this release, NGINX App Protect DoS supports NGINX Plus R28.

### New Features

- Support for NGINX Plus R28.
- NGINX App protect DoS can be deployed behind L4/L7 load balancers when L4 protection is enabled.
- Fixed the issue: Installing NGINX App protect DoS with L4 (eBPF) mitigation behind L4/L7 load balancer may result in the load balancer's starvation during an attack.
- Support for [proxy_protocol]({{< relref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#monitor-directive-app_protect_dos_monitor" >}}) configuration for server health monitoring.<br>
Previously, server health monitoring could not be used when the listen directive of the correspondent server block contained the `proxy_protocol` parameter.<br>
This disallowed using NGINX App protect DoS for Denial of Service (DoS) protection for HTTP2 and gRPC protected objects in the `proxy_protocol` configuration.


### Supported Packages

#### App Protect DoS

##### CentOS 7.4+ / RHEL 7.4+ / UBI7

- app-protect-dos-28+3.1.7-1.el7.ngx.x86_64.rpm

##### RHEL 8 / UBI8

- app-protect-dos-28+3.1.7-1.el8.ngx.x86_64.rpm

##### Debian 11

- app-protect-dos_28+3.1.7-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_28+3.1.7-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_28+3.1.7-1~focal_amd64.deb

##### Alpine 3.15

- app-protect-dos-28.3.1.7-r1.apk

#### NGINX Plus

- NGINX Plus R28


### Important Notes

- Installing L4 accelerated mitigation feature (install `app-protect-dos-ebpf`) configures `nginx` and `admd` to run with root privileges.

- Support for `proxy_protocol` configuration: `proxy_protocol` monitor parameter should be used when the listen directive of the correspondent server block contains the `proxy_protocol` parameter.

- If NGINX App Protect WAF is installed, app protect should be disabled for the location of DoS Live Activity Monitoring API.

    For example:

    ```shell
    location /api {
    app_protect_enable off;
    app_protect_dos_api;
    }
    ```

- Misconfiguration of `app_protect_dos_monitor` potentially can cause a false attack declaration.
Port configuration should correspond to the port the server listens to.

    For example:

    ```shell
        server {
            listen 8080;
            location / {  app_protect_dos_monitor "myservice.com:8080";  }
        }
    ```

- `proxy_request_buffering` off is not supported.

- gRPC and HTTP/2 protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for these use cases, otherwise, the attack will not be detected.

- [TLS fingerprint]({{< relref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 and RHEL 7 / UBI 7 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Monitor directive (app_protect_monitor) with the `proxy_protocol` parameter can not be configured on Ubuntu 18.04. As a result, gRPC and HTTP/2 DoS protection for `proxy_protocol` configuration is not supported.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- The recommended option of running NGINX Plus in a Docker Container is with the `daemon off` flag. It's mandatory for UBI 8.
