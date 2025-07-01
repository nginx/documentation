---
title: NGINX App Protect DoS 2.4
toc: true
weight: 160
nd-docs: DOCS-890
---

Here you can find the release information for F5 NGINX App Protect DoS v2.4. NGINX App Protect DoS provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 2.4

June 28, 2022

### New Features

- [Support for Debian 11]({{< ref "learn-about-deployment.md#debian-10--debian-11-installation" >}})
- Accelerated bad actors detection when the signatures mitigation is disabled.

### Supported Packages

#### App Protect DoS

##### CentOS 7.4+ / RHEL 7.4+ / UBI7

- app-protect-dos-27+2.4.1-1.el7.ngx.el7.ngx.x86_64.rpm

##### RHEL 8 / UBI8

- app-protect-dos-27+2.4.1-1.el8.ngx.el8.ngx.x86_64.rpm

##### Debian 10

- app-protect-dos_27+2.4.1-1~buster_amd64.deb

##### Debian 11

- app-protect-dos_27+2.4.1-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_27+2.4.1-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_27+2.4.1-1~focal_amd64.deb

##### Alpine 3.15

- app-protect-dos-27.2.4.1-r1.apk

#### NGINX Plus

- NGINX Plus R27

### Resolved Issues

- Honoring allow/deny directives for restricting access to the NGINX App Protect DoS Live Activity Monitoring API location.

### Important Notes

- If NGINX App Protect WAF is installed, app protect should be disabled for the location of DoS Live Activity Monitoring API

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

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 and RHEL 7 / UBI 7 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- The recommended option of running NGINX Plus in a Docker Container is with the `daemon off` flag. It's mandatory for UBI 8.
