---
title: OpenTracing
description: Instrument NGINX with OpenTracing-compliant requests for a range of distributed tracing services, such as Zipkin, Jaeger and Datadog. Note that the opentracing module provides the framework for recording traces; you will also need to install a service-specific tracing module.  This module (“tracer”) pushes traces to the collector and analyser provided by that service.
weight: 100
doctypes: ["task"]
toc: true
docs: "DOCS-395"
---


> **Note**: Since NGINX Plus <a href="../../../releases/#r29">Release 29</a>, the [OpenTelemetry]({{< relref "opentelemetry.md" >}}) module is available that incorporates the features of the OpenTracing module.


<span id="install"></span>
## Installation Instructions

1. Install the OpenTracing module.

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:

   ```shell
   $ yum install nginx-plus-module-opentracing
   ```
   > **Note:** the OpenTracing module cannot be installed on CentOS 6, Oracle Linux 6, and RHEL 6.

   For Debian and Ubuntu:
   
   ```shell
    $ apt-get install nginx-plus-module-opentracing
   ```

   For SLES:

   ```shell
   $ zypper install nginx-plus-module-opentracing
   ```
   > **Note:**: the OpenTracing module cannot be installed on SLES 12.

   For Alpine:

   ```shell
   $ apk add nginx-plus-module-opentracing
   ```

2. Put the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the top‑level (“`main`”) context of NGINX Plus configuration file, **nginx.conf**:

   ```nginx
   load_module modules/ngx_http_opentracing_module.so;
   ```

3. Perform additional configuration as required by the [module](https://github.com/opentracing-contrib/nginx-opentracing). You will also need to [install a tracer](https://github.com/opentracing-contrib/nginx-opentracing#building-from-source) (“portable binary plugin”) for your selected service.

4. Reload NGINX Plus to enable the module:
   ```shell
   $ nginx -t && nginx -s reload
   ```


<span id="info"></span>
## More Info

* [NGINX plugin for OpenTracing Reference](https://github.com/opentracing-contrib/nginx-opentracing)

* [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

* [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
