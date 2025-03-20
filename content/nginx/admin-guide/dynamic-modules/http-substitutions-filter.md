---
description: Replace text in response bodies, using regular expressions and fixed
  strings, with the HTTP Substitutions Filter dynamic module supported by NGINX, Inc.
docs: DOCS-389
title: HTTP Substitutions Filter
toc: true
weight: 100
type:
- how-to
---

<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the HTTP Substitutions Filter module package `nginx-plus-module-subs-filter`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-subs-filter
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-subs-filter
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-subs-filter
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-subs-filter
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-subs-filter
   ```

<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in F5 NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_subs_filter_module.so;
   ```

2. Perform additional configuration as required by the [module](https://github.com/yaoweibin/ngx_http_substitutions_filter_module).

3. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```

<span id="info"></span>
## More Info

- [NGINX Substitution Filter Module Reference](https://github.com/yaoweibin/ngx_http_substitutions_filter_module)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
