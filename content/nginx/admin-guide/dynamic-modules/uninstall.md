---
description: This section describes how to uninstall an F5 NGINX Plus dynamic module.
docs: DOCS-402
title: Uninstalling a dynamic module
toc: true
weight: 100
type:
- how-to
---

<span id="uninstall"></span>
## Instructions

1. To uninstall a dynamic module:

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum remove <dynamic_module_name>
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf remove <dynamic_module_name>
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get remove <dynamic_module_name>
   ```

   For SLES:

   ```shell
   zypper remove <dynamic_module_name>
   ```

   For FreeBSD:

   ```shell
   pkg delete <dynamic_module_name>
   ```


<span id="configure"></span>

## Configuration

After uninstalling the package, you will need to disable the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Disable dynamic loading of the module by removing the corrsponding [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive.

2. In NGINX Plus configuration file, remove all directives related to the dynamic module.

3. Test the configuration and reload NGINX Plus to disable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

- [NGINX Module Reference](https://nginx.org/en/docs/)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})

