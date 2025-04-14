---
description: This section describes how to uninstall an F5 NGINX Plus dynamic module.
docs: DOCS-402
title: Uninstalling a dynamic module
toc: true
weight: 100
type:
- how-to
---

## Instructions

1. To uninstall a dynamic module:

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum remove <dynamic_module_name>
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf remove <dynamic_module_name>
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt remove <dynamic_module_name>
   ```

   For SLES:

   ```shell
   sudo zypper remove <dynamic_module_name>
   ```

   For FreeBSD:

   ```shell
   sudo pkg delete <dynamic_module_name>
   ```

## Configuration

After uninstalling the package, you will need to disable the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Disable dynamic loading of the module by removing the corrsponding [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive.

2. In NGINX Plus configuration file, remove all directives related to the dynamic module.

3. Test the NGINX Plus configuration. In a terminal, type-in the command:

    ```shell
    nginx -t
    ```

    Expected output of the command:

    ```shell
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf is successful
    ```

4. Reload the NGINX Plus configuration to enable the module:

    ```shell
    nginx -s reload
    ```

## More Info

- [NGINX Module Reference](https://nginx.org/en/docs/)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

