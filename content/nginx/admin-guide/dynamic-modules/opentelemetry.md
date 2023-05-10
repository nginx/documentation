---
description: Analyze your software performance by instrumenting, generating, collecting,
  and exporting telemetry data.
docs: DOCS-1207
doctypes:
- task
title: OpenTelemetry
toc: true
weight: 100
---


<span id="install"></span>
## Installation Instructions

1. Install the OpenTelemetry module.

   For Amazon Linux, Alma/Rocky Linux, CentOS, Oracle Linux, and RHEL:
   
   ```shell
   $ yum install nginx-plus-module-otel
   ```
   
   For Debian and Ubuntu:
   
   ```shell
   $ apt-get install nginx-plus-module-otel
   ```

   For SLES:
   
   ```shell
   $ zypper install nginx-plus-module-otel
   ```
   For Alpine:

   ```shell
   $ apk add nginx-plus-module-otel
   ```

   > **Note:** the OpenTelemetry module cannot be installed on RHEL/Oracle Linux/AlmaLinux/Rocky Linux 7, Ubuntu 18.04, and Amazon Linux 2.

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_otel_module.so;
   ```

3. Reload NGINX Plus to enable the module:

   ```shell
   $ nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX Module Reference for OpenTelemetry Module](https://nginx.org/en/docs/ngx_otel_module.html)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
