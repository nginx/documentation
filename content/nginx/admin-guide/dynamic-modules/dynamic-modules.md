---
description: Load modules dynamically into NGINX Plus at runtime to add specialized
  functionality, including features authored by third parties.
docs: DOCS-383
doctypes:
- task
title: Dynamic Modules
toc: true
weight: 10
---

<span id="overview"></span>
## Overview

NGINX Plus uses a modular architecture. New features and functionality can be added with software modules, which can be plugged into a running NGINX Plus instance on demand. Dynamic modules add functionality to NGINX Plus such as [geolocating users by IP address]({{< relref "geoip2.md" >}}), [resizing images]({{< relref "image-filter.md" >}}), and embedding [NGINX JavaScript njs]({{< relref "nginscript.md" >}}) or [Lua]({{< relref "lua.md" >}}) scripts into the NGINX Plus event‑processing model. Modules are created both by NGINX and third‑party developers.

<img src="https://www.nginx.com/wp-content/uploads/2020/03/NGINX-Plus_dynamic-module-plug-ins.png" alt="NGINX Plus allows features to be plugged in on demand" width="500" height="500" style="border:2px solid #666666; padding:2px; margin:2px;" />

{{<note>}}
Dynamic modules plug into NGINX Plus to provide additional functionality.
{{</note>}}

NGINX maintains a repository of dynamic modules for NGINX Plus. All modules in our repository are fully tested and certified for correct interoperation with NGINX Plus.

There are many additional third‑party modules that are not included in the repository, but can be found in community projects like [awesome-nginx](https://github.com/agile6v/awesome-nginx#third-party-modules). You can [compile](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/#install_modules_oss) many of them as dynamic modules.


<span id="getting_started"></span>
## Getting Started with the Dynamic Modules Repository

You can access and download the modules in the NGINX Plus dynamic modules repository using standard package management tools such as `apt` and `yum`. For example, to install njs dynamic modules for Debian and Ubuntu, run the command:

```shell
apt-get install nginx-plus-module-njs
```

Then you include the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the NGINX Plus configuration file for each dynamic module. For example, to enable `njs` dynamic modules, specify the `load_module` directives in the top-level (“`main`”) context of the main NGINX Plus configuration file (**nginx.conf**):

```nginx
load_module modules/ngx_http_js_module.so;
load_module modules/ngx_stream_js_module.so;
```

For module‑specific instructions, see the list of modules in the same section of the NGINX Plus Admin Guide as this article:

- [Brotli]({{< relref "brotli.md" >}})
- [Cookie-Flag]({{< relref "cookie-flag.md" >}})
- [Encrypted-Session]({{< relref "encrypted-session.md" >}})
- [FIPS Status Check]({{< relref "fips.md" >}})
- [GeoIP]({{< relref "geoip.md" >}})
- [GeoIP2]({{< relref "geoip2.md" >}})
- [Headers-More]({{< relref "headers-more.md" >}})
- [HTTP Substitutions Filter]({{< relref "http-substitutions-filter.md" >}})
- [Image-Filter]({{< relref "image-filter.md" >}})
- [Lua]({{< relref "lua.md" >}})
- [njs Scripting Language]({{< relref "nginscript.md" >}})
- [NGINX ModSecurity WAF]({{< relref "nginx-waf.md" >}})
- [NGINX Developer Kit]({{< relref "ndk.md" >}})
- [OpenTelemetry]({{< relref "opentelemetry.md" >}})
- [OpenTracing]({{< relref "opentracing.md" >}})
- [Phusion Passenger Open Source]({{< relref "passenger-open-source.md" >}})
- [Perl]({{< relref "perl.md" >}})
- [Prometheus-njs]({{< relref "prometheus-njs.md" >}})
- [RTMP]({{< relref "rtmp.md" >}})
- [Set-Misc]({{< relref "set-misc.md" >}})
- [SPNEGO]({{< relref "spnego.md" >}})
- [XSLT]({{< relref "xslt.md" >}})


<span id="prereq"></span>
### Prerequisites

To get started using dynamic modules, first install the latest NGINX Plus release, following the [installation instructions]({{< relref "../installing-nginx/installing-nginx-plus.md" >}}). Dynamic modules are supported in <a href="../../../releases/#r9">NGINX Plus Release 9 (R9)</a> and later.


<span id="modules_all"></span>
### Displaying the List of Available Modules

To see the list of available modules, run this command (for Debian and Ubuntu):

```shell
apt-cache search nginx-plus-module
```

The output of the command:

```shell
nginx-plus-module-geoip - NGINX Plus, provided by NGINX, Inc. (GeoIP dynamic modules)
nginx-plus-module-geoip-dbg - Debugging symbols for the nginx-plus-module-geoip
nginx-plus-module-geoip2 - NGINX Plus, provided by NGINX, Inc. (3rd-party GeoIP2 dynamic modules)
nginx-plus-module-geoip2-dbg - Debugging symbols for the nginx-plus-module-geoip2
nginx-plus-module-headers-more - NGINX Plus, provided by NGINX, Inc. (3rd-party headers-more dynamic module)
nginx-plus-module-headers-more-dbg - Debugging symbols for the nginx-plus-module-headers-more
nginx-plus-module-image-filter - NGINX Plus, provided by NGINX, Inc. (image filter dynamic module)
nginx-plus-module-image-filter-dbg - Debugging symbols for the nginx-plus-module-image-filter
```

{{< note >}} There is an optional debugging symbols package available for every module. You can load and use the module without installing this package.{{< /note >}}


<span id="modules_nginx"></span>
### NGINX Plus Certified Modules

In addition to modules authored by NGINX and community third‑party developers, the repository contains NGINX Plus Certified Modules which are available for purchase from commercial third parties. Certified Modules are distributed and supported by their authors. NGINX has tested the modules extensively and certifies that they do not interfere with standard NGINX Plus functionality.

NGINX Plus Certified Modules are identified with this checkmark icon on the [Dynamic Modules page](https://www.nginx.com/products/nginx/modules):

![test](https://cdn-1.wp.nginx.com/wp-content/themes/nginx-theme/assets/img/product-page/module-icon.png)

Click the module box on that page and then the **GET MODULE** button.


<span id="caveats"></span>
### Caveats

Some modules are not available for certain OS versions because of OS limitations. For details, see the [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}}).


<span id="compile"></span>
## Compiling Your Own Dynamic Modules

To compile your own dynamic modules, please see our [blog](https://www.nginx.com/blog/compiling-dynamic-modules-nginx-plus/).


<span id="compile"></span>
## Uninstalling a Dynamic Module

To uninstall a dynamic module, please follow the [Uninstalling a dynamic module]({{< relref "uninstall.md" >}}) article.


<span id="info"></span>
## See Also

- [Installing NGINX Plus]({{< relref "../installing-nginx/installing-nginx-plus.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})

