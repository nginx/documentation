---
title: F5 DoS for NGINX 2.2
toc: true
weight: 180
nd-docs: DOCS-839
---

Here you can find the release information for F5 F5 DoS for NGINX v2.2. F5 DoS for NGINX provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 2.2

February 15, 2022

In this release, support for F5 DoS for NGINX is added to NGINX Plus R26.

### New Features

- **Improve Signature Lifecycle**

### Supported Packages

#### App Protect DoS

##### CentOS 7.4+ / RHEL 7.4+ / UBI7

- app-protect-dos-26+2.2.20-1.el7.ngx.el7.ngx.x86_64.rpm

##### RHEL 8 / UBI8

- app-protect-dos-26+2.2.20-1.el8.ngx.el8.ngx.x86_64.rpm

##### Debian 10

- app-protect-dos_26+2.2.20-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_26+2.2.20-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_26+2.2.20-1~focal_amd64.deb

#### NGINX Plus

- NGINX Plus R26

### Resolved Issues

- Monitor requests are sent in new connections. It improves monitoring health capability and allows better detection of slow POST attacks.

- Adaptive memory allocation by adminstall in order to support maximum cores.
  The amount of allocated memory for F5 DoS for NGINX is controlled by an argument of adminstall.
  The default value is 80 MB. For certain deployments, this amount of memory size is not enough.  The default memory size is adaptive now. If the Virtual Machine (VM) has a big number of CPU cores, then we can also increase the amount of memory. For the case of up to 4 CPU cores, the allocated memory is 80MB, for more than 4 CPU cores, the allocated memory will be calculated as 80MB + CPUs * 2.5MB


### Important Notes

- Misconfiguration of `app_protect_dos_monitor` can cause a false attack declaration. Port configuration should correspond to the port the server listens to.

    For example:

    ```shell
        server {
            listen 8080;
            server_name myservice.com;
            location / {
                app_protect_dos_monitor "myservice.com:8080/";
            }
        }
    ```
- `proxy_request_buffering` off is not supported.

- gRPC and HTTP/2 protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for these use cases, otherwise, the attack will not be detected.

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 and RHEL 7 / UBI 7 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- The recommended option of running NGINX Plus in a Docker Container is with the `daemon off` flag. It's mandatory for UBI 8.
