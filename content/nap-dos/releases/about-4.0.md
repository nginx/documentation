---
title: NGINX App Protect DoS 4.0
toc: true
weight: 120
docs: DOCS-1115
---

Here you can find the release information for F5 NGINX App Protect DoS v4.0. NGINX App Protect DoS provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 4.0

January 31, 2023

### New Features

- Distributed Denial of Service (DDoS) protection feature for WebSocket services. <br> Refer to the [Configuration Example]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#monitor-directive-app_protect_dos_monitor" >}}) for WebSocket services here.<br>
- DDoS protection against slow attacks has been improved using machine learning algorithm on all types of traffic.
- `app_protect_dos_monitor` directive, which monitors the proxied server, supports a new type of protocol - "WebSocket".


### Supported Packages

#### App Protect DoS

##### CentOS 7.4+ / RHEL 7.4+ / UBI7

- app-protect-dos-28+4.0.1-1.el7.ngx.x86_64.rpm

##### RHEL 8 / UBI8

- app-protect-dos-28+4.0.1-1.el8.ngx.x86_64.rpm

##### Debian 11

- app-protect-dos_28+4.0.1.-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_28+4.0.1-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_28+4.0.1-1~focal_amd64.deb

##### Alpine 3.15

- app-protect-dos-28.4.0.1-r1.apk

#### NGINX Plus

- NGINX Plus R28

### Important Notes

- WebSocket protection requires active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for these use cases, otherwise, the attack will not be detected.

- Installing accelerated mitigation feature (install `app-protect-dos-ebpf`) configures `nginx` and `admd` to run with root privileges.

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

- gRPC and HTTP/2 protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for the attack to be detected.

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 and RHEL 7 / UBI 7 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Monitor directive `app_protect_dos_monitor` with `proxy_protocol` parameter can not be configured on Ubuntu 18.04. As a result, gRPC and HTTP/2 DoS protection for `proxy_protocol` configuration is not supported.

- Slow attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- The recommended option of running NGINX Plus in a Docker Container is with the `daemon off` flag. It's mandatory for UBI 8.
