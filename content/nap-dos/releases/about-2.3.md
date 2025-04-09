---
title: NGINX App Protect DoS 2.3
toc: true
weight: 170
docs: DOCS-856
---

Here you can find the release information for F5 NGINX App Protect DoS v2.3. NGINX App Protect DoS provides behavioral protection against Denial of Service (DoS) for your web applications.

## Release 2.3

May 9, 2022

### New Features

- [Support for Alpine 3.15 deployment]({{< ref "learn-about-deployment.md#alpine-315-installation" >}})
- [DoS Live Activity Monitoring]({{< ref "/nap-dos/monitoring/live-activity-monitoring.md" >}})
- [New Arbitrator FQDN/IP directive]({{< ref "learn-about-directives-and-policy.md#arbitrator-fqdn-directive-app_protect_dos_arb_fqdn" >}})

### Supported Packages

#### App Protect DoS

##### CentOS 7.4+ / RHEL 7.4+ / UBI7

- app-protect-dos-26+2.3.46-1.el7.ngx.el7.ngx.x86_64.rpm

##### RHEL 8 / UBI8

- app-protect-dos-26+2.3.46-1.el8.ngx.el8.ngx.x86_64.rpm

##### Debian 10

- app-protect-dos_26+2.3.46-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect-dos_26+2.3.46-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect-dos_26+2.3.46-1~focal_amd64.deb

##### Alpine 3.15

- app-protect-dos-26.2.3.48-r1.apk

#### NGINX Plus

- NGINX Plus R26

### Resolved Issues

- Improved Security logger configuration parsing: Detects invalid JSON structure, generates an appropriate message if field/value is not valid, doesn't stop on the first failure.

### Important Notes

- Misconfiguration of `app_protect_dos_monitor` potentially can cause a false attack declaration.
Port configuration should correspond to the port the server listens to.

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

Please note that the above syntax for the Monitor directive is old but still supported.

The new syntax for the Monitor directive is as stated below, where **protocol** and **timeout** arguments are optional and default. Refer to [Learn about Directives and Policy](/nginx-app-protect-dos/directives-and-policy/learn-about-directives-and-policy/#monitor-directive-app_protect_dos_monitor) for more details on Monitor directive new syntax.

For example:

`app_protect_dos_monitor uri=myservice.com:8080/ protocol=http1 timeout=5;`
<br><br>

- `proxy_request_buffering` off is not supported.

- gRPC and HTTP/2 protection require active monitoring of the protected service. The directive `app_protect_dos_monitor` is mandatory for these use cases, otherwise, the attack will not be detected.

- [TLS fingerprint]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#policy-directive-app_protect_dos_policy_file" >}}) feature is not used in CentOS 7.4 and RHEL 7/UBI 7 due to the old OpenSSL version. The required OpenSSL version is 1.1.1 or higher.

- Slow POST attack always mitigates with block action while other types of attacks can also be mitigated with redirection or JS challenges.

- The recommended option of running NGINX Plus in a Docker Container is with the `daemon off` flag. It's mandatory for UBI 8.
