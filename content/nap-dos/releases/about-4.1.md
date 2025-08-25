---
title: F5 DoS for NGINX 4.1
toc: true
weight: 110
nd-docs: DOCS-1203
---

Here you can find the release information for F5 F5 DoS for NGINX v4.1. F5 DoS for NGINX provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 4.1

May 2, 2023

In this release, F5 DoS for NGINX supports NGINX Plus R29.

### New Features

- Support for NGINX Plus R29
- Support for Rocky Linux 8

### Supported Packages

#### App Protect DoS

##### CentOS 7.4+ / RHEL 7.4+ / UBI7

- app-protect-dos-29+4.1.2-1.el7.ngx.x86_64.rpm

##### RHEL 8 and Rocky Linux 8

- app-protect-dos-29+4.1.2-1.el8.ngx.x86_64.rpm

##### Debian 11

- app-protect-dos_29+4.1.2-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_29+4.1.2-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_29+4.1.2-1~focal_amd64.deb

##### Alpine 3.15

- app-protect-dos-29.4.1.2-r1.apk

#### NGINX Plus

- NGINX Plus R29


### Important Notes

- Installing L4 accelerated mitigation feature (install `app-protect-dos-ebpf`) configures `nginx` and `admd` to run with root privileges.

- Support for `proxy_protocol` configuration: `proxy_protocol` monitor parameter should be used when the `listen` directive of the correspondent server block contains the `proxy_protocol` parameter.

- If NGINX App Protect WAF is installed, app protect should be disabled for the location of DoS Live Activity Monitoring API.

    For example:

    ```shell
    location /api {
    app_protect_enable off;
    app_protect_dos_api;
    }
    ```

- Port configuration in `app_protect_dos_monitor` should correspond to the port, the server listens to. Misconfiguration can potentially cause a false attack declaration.

    For example:

    ```shell
        server {
            listen 8080;
            location / {  app_protect_dos_monitor "myservice.com:8080";  }
        }
    ```

- `proxy_request_buffering` off is not supported.

- gRPC and HTTP/2 protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for the attack to be detected.

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 and RHEL 7 / UBI 7 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Monitor directive `app_protect_dos_monitor` with `proxy_protocol` parameter can not be configured on Ubuntu 18.04. As a result, gRPC and HTTP/2 DoS protection for `proxy_protocol` configuration is not supported.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- The recommended option of running NGINX Plus in a Docker Container is with the `daemon off` flag. It's mandatory for UBI 8.

- The package dependencies for F5 DoS for NGINX have changed in this release, replacing the `curl` dependencies with `libcurl` only. For more information, see the [F5 DoS for NGINX Deployment Guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md#prerequisites" >}}).
