---
description: Replace text in response bodies, using regular expressions and fixed
  strings, with the HTTP Substitutions Filter dynamic module supported by NGINX, Inc.
docs: DOCS-389
doctypes:
- task
title: HTTP Substitutions Filter
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Install the HTTP Substitutions Filter module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-subs-filter
   ```
   
   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-subs-filter
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-subs-filter
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_subs_filter_module.so;
   ```

3. Perform additional configuration as required by the [module](https://github.com/yaoweibin/ngx_http_substitutions_filter_module).

4. Reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX Substitution Filter Module Reference](https://github.com/yaoweibin/ngx_http_substitutions_filter_module)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
