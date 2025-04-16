---
description: Instrument NGINX with OpenTracing-compliant requests for a range of distributed
  tracing services, such as Zipkin, Jaeger and Datadog. Note that the opentracing
  module provides the framework for recording traces; you will also need to install
  a service-specific tracing module.  This module (“tracer”) pushes traces to the
  collector and analyser provided by that service.
docs: DOCS-395
title: OpenTracing
toc: true
weight: 100
type:
- how-to
---

{{< note >}} The module no longer available since F5 NGINX Plus [Release 34]({{< ref "nginx/releases.md#r34" >}}). The [OpenTelemetry]({{< ref "nginx/admin-guide/dynamic-modules/opentelemetry.md" >}}) module is available since NGINX Plus [Release 29]({{< ref "nginx/releases.md#r29" >}}) that incorporates the features of the OpenTracing module.{{< /note >}}


<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the OpenTracing module package `nginx-plus-module-opentracing`.

   For Amazon Linux 2, CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update && \
   sudo yum install nginx-plus-module-opentracing
   ```

   {{< note >}}the OpenTracing module cannot be installed on CentOS 6, Oracle Linux 6, and RHEL 6. {{< /note >}}

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update && \
   sudo dnf install nginx-plus-module-opentracing
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update && \
   sudo apt install nginx-plus-module-opentracing
   ```

   For SLES:

   ```shell
   sudo zypper refresh && \
   sudo zypper install nginx-plus-module-opentracing
   ```

   {{< note >}} the OpenTracing module cannot be installed on SLES 12. {{< /note >}}

   For Alpine:

   ```shell
   apk add nginx-plus-module-opentracing
   ```

   For FreeBSD:

   ```shell
   sudo pkg update && \
   sudo pkg install nginx-plus-module-opentracing
   ```


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_http_opentracing_module.so;

   http {
       # ...
   }
   ```

2. Perform additional configuration as required by the [module](https://github.com/opentracing-contrib/nginx-opentracing). You will also need to [install a tracer](https://github.com/opentracing-contrib/nginx-opentracing#building-from-source) (“portable binary plugin”) for your selected service.

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


<span id="info"></span>
## More Info

- [NGINX plugin for OpenTracing Reference](https://github.com/opentracing-contrib/nginx-opentracing)

- [NGINX Dynamic Modules]({{< ref "nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})

- [Uninstalling a Dynamic Module]({{< ref "uninstall.md" >}})
