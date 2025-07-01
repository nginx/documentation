---
description: This section describes how to uninstall an F5 NGINX Plus dynamic module.
nd-docs: DOCS-402
title: Uninstalling a dynamic module
toc: true
weight: 100
type:
- how-to
---
You may need to uninstall a dynamic module in NGINX Plus in several scenarios:

- The module is being replaced with a newer or alternative version. For example, the [OpenTracing]({{< ref "opentracing.md" >}}) module has been replaced by the [OpenTelemetry]({{< ref "opentelemetry.md" >}}) module. The [Cookie-Flag]({{< ref "cookie-flag.md" >}}) dynamic module has been superseded by natively supported [`proxy_cookie_flags`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags) directive.

- The module is no longer supported, for example, the [NGINX ModSecurity WAF]({{< ref "nginx-waf.md" >}}) module.

- The operating system is not supported by the module. See the the [Dynamic Modules]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) section of the [NGINX Plus Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}).

- The module it is no longer required, uninstalling it helps optimize resource usage and reduce maintenance overhead.

- The module is causing runtime errors or configuration conflicts that affect stability or performance.

- Security or compliance policies require removal, particularly in regulated environments where only approved or certified modules are allowed.

## Instructions

To uninstall a dynamic module, run the appropriate command for your operating system in a terminal, replacing `<MODULE-NAME>` with the actual package name, for example, `nginx-plus-module-cookie-flag`.

-  For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum remove <MODULE-NAME>
   ```

-  For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf remove <MODULE-NAME>
   ```

-  For Debian and Ubuntu:

   ```shell
   sudo apt remove <MODULE-NAME>
   ```

-  For SLES:

   ```shell
   sudo zypper remove <MODULE-NAME>
   ```

-  For FreeBSD:

   ```shell
   sudo pkg delete <MODULE-NAME>
   ```

## Configuration

After uninstalling the package, you will need to disable the module in the NGINX configuration file.

1. In a text editor, open the NGINX Plus configuration file:
   - `/etc/nginx/nginx.conf` for Linux
   - `/usr/local/etc/nginx/nginx.conf` for FreeBSD

2. Disable dynamic loading of the module by removing the corresponding [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive.

3. Remove all directives related to the dynamic module.

4. Save the configuration.

5. Test the NGINX Plus configuration. In a terminal, type-in the command:

    ```shell
    nginx -t
    ```

    Expected output of the command:

    ```shell
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf is successful
    ```

5. Reload the NGINX Plus configuration:

    ```shell
    nginx -s reload
    ```

## More info

- [NGINX modules reference](https://nginx.org/en/docs/)

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})
