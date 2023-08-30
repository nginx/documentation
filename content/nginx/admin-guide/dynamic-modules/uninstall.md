---
description: This section describes how to uninstall an NGINX Plus dynamic module.
docs: DOCS-402
doctypes:
- task
title: Uninstalling a dynamic module
toc: true
weight: 100
---


<span id="uninstall"></span>
## Instructions

1. To uninstall a dynamic module:

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:
  
   ```shell
   yum remove <dynamic_module_name>
   ```

   For Amazon Linux 2023:

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

2. Remove the corresponding [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive from NGINX Plus configuration file.

3. In NGINX Plus configuration file, remove all directives related to the dynamic module.

4. Reload NGINX Plus:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX Module Reference](https://nginx.org/en/docs/)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})

