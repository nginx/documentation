---
description: Load modules dynamically into F5 NGINX Plus at runtime to add specialized
  functionality, including features authored by third parties.
nd-docs: DOCS-383
title: Dynamic Modules
toc: true
weight: 10
type:
- how-to
---

## Overview

F5 NGINX Plus uses a modular architecture. New features and functionality can be added with software modules, which can be plugged into a running NGINX Plus instance on demand. Dynamic modules add functionality to NGINX Plus such as [geolocating users by IP address]({{< ref "/nginx/admin-guide/dynamic-modules/geoip2.md" >}}), [resizing images]({{< ref "/nginx/admin-guide/dynamic-modules/image-filter.md" >}}), and embedding [NGINX JavaScript njs]({{< ref "/nginx/admin-guide/dynamic-modules/nginscript.md" >}}) or [Lua]({{< ref "/nginx/admin-guide/dynamic-modules/lua.md" >}}) scripts into the NGINX Plus event‑processing model. Modules are created both by NGINX and third‑party developers.

<img src="/nginx/images/nginx-plus-dynamic-module-plug-ins.png" alt="NGINX Plus allows features to be plugged in on demand" width="500" height="500" style="border:2px solid #666666; padding:2px; margin:2px;" />

Dynamic modules are shared object files (`.so`) that can be loaded at runtime using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the NGINX configuration.

NGINX maintains the official NGINX Plus repository, which also provides packaged binaries for both [NGINX‑authored]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#nginx-authored-dynamic-modules" >}}) and [NGINX‑certified community]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#nginx-certified-community-dynamic-modules" >}}) dynamic modules. All modules in this repository are fully tested to ensure full compatibility with NGINX Plus.

For module‑specific installation and usage instructions, select the corresponding package name in the table.


{{< bootstrap-table "table table-striped table-bordered" >}}
| Name                            | Description                       | Package name     |
|---------------------------------|-----------------------------------|--------------------|
| [Brotli](https://github.com/google/ngx_brotli) | Brotli compression support with modules for dynamic compression and for serving pre-compressed `.br` files. | [`nginx-plus-module-brotli`]({{< ref "/nginx/admin-guide/dynamic-modules/brotli.md" >}}) |
| [Encrypted-Session](https://github.com/openresty/encrypted-session-nginx-module) | AES-256 based encryption/decryption of NGINX variables. | [`nginx-plus-module-encrypted-session`]({{< ref "/nginx/admin-guide/dynamic-modules/encrypted-session.md" >}}) |
| [FIPS Status Check](https://github.com/ogarrett/nginx-fips-check-module) | Verifies if OpenSSL is operating in FIPS mode. | [`nginx-plus-module-fips-check`]({{< ref "/nginx/admin-guide/dynamic-modules/fips.md" >}})|
| [GeoIP](https://nginx.org/en/docs/http/ngx_http_geoip_module.html) | Enables IP-based geolocation using the precompiled MaxMind databases. | [`nginx-plus-module-geoip`]({{< ref "/nginx/admin-guide/dynamic-modules/geoip.md" >}}) |
| [GeoIP2](https://github.com/leev/ngx_http_geoip2_module)  | Uses MaxMind GeoIP2 for enhanced geolocation. | [`nginx-plus-module-geoip2`]({{< ref "/nginx/admin-guide/dynamic-modules/geoip2.md" >}})|
| [Headers-More](https://github.com/openresty/headers-more-nginx-module) | Extends the NGINX [Headers](https://nginx.org/en/docs/http/ngx_http_headers_module.html) module to modify request and response headers. | [`nginx-plus-module-headers-more`]({{< ref "/nginx/admin-guide/dynamic-modules/headers-more.md" >}}) |
| [HTTP Substitutions Filter](https://github.com/yaoweibin/ngx_http_substitutions_filter_module) | Enables regex and string-based substitutions in response bodies. | [`nginx-plus-module-subs-filter`]({{< ref "/nginx/admin-guide/dynamic-modules/http-substitutions-filter.md" >}}) |
| [Image-Filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html) | Adds on-the-fly support for JPEG, GIF, PNG, and WebP image resizing and cropping. | [`nginx-plus-module-image-filter`]({{< ref "/nginx/admin-guide/dynamic-modules/image-filter.md" >}}) |
| [Lua](https://github.com/openresty/lua-nginx-module) | Embeds Lua programming language. | [`nginx-plus-module-lua`]({{< ref "/nginx/admin-guide/dynamic-modules/lua.md" >}})|
| [NGINX Developer Kit](https://github.com/vision5/ngx_devel_kit) | Provides helper macros for module development. | [`nginx-plus-module-ndk`]({{< ref "/nginx/admin-guide/dynamic-modules/ndk.md" >}}) |
| [njs Scripting Language](https://nginx.org/en/docs/njs/) | Adds JavaScript-like scripting for advanced server-side logic in NGINX configuration file. | [`nginx-plus-module-njs`]({{< ref "/nginx/admin-guide/dynamic-modules/nginscript.md" >}}) |
| [OpenTelemetry](https://nginx.org/en/docs/ngx_otel_module.html#directives) | Adds distributed tracing support via OpenTelemetry. | [`nginx-plus-module-otel`]({{< ref "/nginx/admin-guide/dynamic-modules/opentelemetry.md" >}}) |
| [Perl](https://nginx.org/en/docs/http/ngx_http_perl_module.html)| Integrates Perl scripting for advanced customization. | [`nginx-plus-module-perl`]({{< ref "/nginx/admin-guide/dynamic-modules/perl.md" >}}) |
| [Phusion Passenger](https://www.phusionpassenger.com/library/install/nginx/) | Application server for Node.js, Python, Ruby. | [`nginx-plus-module-passenger`]({{< ref "/nginx/admin-guide/dynamic-modules/passenger-open-source.md" >}}) |
| [Prometheus-njs](https://github.com/nginx/nginx-prometheus-exporter) | Converts [NGINX Plus metrics](https://demo.nginx.com/swagger-ui/) into Prometheus format. | [`nginx-plus-module-prometheus`]({{< ref "/nginx/admin-guide/dynamic-modules/prometheus-njs.md" >}}) |
| [RTMP](https://github.com/arut/nginx-rtmp-module) | Adds streaming capabilities (RTMP, HLS, MPEG-DASH, FFmpeg support).| [`nginx-plus-module-rtmp`]({{< ref "/nginx/admin-guide/dynamic-modules/rtmp.md" >}}) |
| [Set-Misc](https://github.com/openresty/set-misc-nginx-module) | Adds `set_*` directives for scripting (extend NGINX [Rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) module). | [`nginx-plus-module-set-misc`]({{< ref "/nginx/admin-guide/dynamic-modules/set-misc.md" >}}) |
| [SPNEGO for Kerberos](https://github.com/stnoonan/spnego-http-auth-nginx-module) | Adds support for [GSS‑API based](https://www.rfc-editor.org/rfc/rfc2743) SPNEGO/Kerberos authentication. | [`nginx-plus-module-auth-spnego`]({{< ref "/nginx/admin-guide/dynamic-modules/spnego.md" >}}) |
| [XSLT](https://nginx.org/en/docs/http/ngx_http_xslt_module.html) | Applies XSLT transformations to XML responses. | [`nginx-plus-module-xslt`]({{< ref "/nginx/admin-guide/dynamic-modules/xslt.md" >}}) |
{{< /bootstrap-table >}}

### Community dynamic modules 
Besides the modules provided in the official repository, a wide range of third-party modules is available through community-driven projects such as [Awesome NGINX GitHub project](https://github.com/agile6v/awesome-nginx#third-party-modules). Many of these modules can be [compiled as dynamic modules]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#install_modules_oss" >}}) and used with your NGINX Plus or NGINX Open Source deployments.

### NGINX Certified Partner dynamic modules
 In addition to the modules authored by NGINX and community third‑party developers, NGINX Certified Partner Modules are available for purchase from commercial third parties. Certified Modules are distributed and supported by their authors. NGINX has tested the modules extensively and [certifies](https://www.f5.com/go/partner/nginx-certified-module-program-documentation) that they do not interfere with standard NGINX Plus functionality.

NGINX Certified Partner modules can be found on the [F5 Dynamic Modules page](https://www.f5.com/go/product/nginx-modules?filter=module-author%3Anginx-certified-partner).

### Prerequisites

To get started using dynamic modules, first install the [latest NGINX Plus release]({{< ref "/nginx/releases.md" >}}), following the [installation instructions]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). Dynamic modules are supported since [NGINX Plus Release 9]({{< ref "/nginx/releases.md#r9" >}}).

## Getting started with the dynamic modules repository

You can access and install the modules from the NGINX Plus repository using standard package management tools such as `apt`, `dnf`, `pkg`, `yum`, or `zypper`.

### Displaying the list of available modules

To see the list of available modules, run this command (for Debian and Ubuntu):

```shell
apt update && \
apt-cache search nginx-plus-module
```

The output of the command:

```shell
nginx-plus-module-auth-spnego/stable
  NGINX Plus 3rd-party kerberos authentication dynamic module

nginx-plus-module-brotli/stable
  NGINX Plus 3rd-party brotli compression dynamic modules

nginx-plus-module-encrypted-session/stable
  NGINX Plus 3rd-party encrypted session dynamic module

nginx-plus-module-fips-check/stable
  NGINX Plus 3rd-party FIPS status check dynamic module

nginx-plus-module-geoip/stable
  NGINX Plus GeoIP dynamic modules

nginx-plus-module-geoip2/stable
  NGINX Plus 3rd-party GeoIP2 dynamic modules

nginx-plus-module-headers-more/stable
  NGINX Plus 3rd-party headers-more dynamic module

nginx-plus-module-image-filter/stable
  NGINX Plus image filter dynamic module

nginx-plus-module-lua/stable
  NGINX Plus 3rd-party Lua dynamic modules

nginx-plus-module-ndk/stable
  NGINX Plus 3rd-party NDK dynamic module

nginx-plus-module-njs/stable
  NGINX Plus njs dynamic modules

nginx-plus-module-opentracing/stable
  NGINX Plus 3rd-party OpenTracing dynamic module

nginx-plus-module-otel/stable
  NGINX Plus OpenTelemetry dynamic module

nginx-plus-module-passenger/stable
  NGINX Plus 3rd-party Passenger dynamic module

nginx-plus-module-perl/stable
  NGINX Plus Perl dynamic module

nginx-plus-module-prometheus/stable
  NGINX Plus Prometheus exporter NJS module

nginx-plus-module-rtmp/stable
  NGINX Plus 3rd-party RTMP dynamic module

nginx-plus-module-set-misc/stable
  NGINX Plus 3rd-party set-misc dynamic module

nginx-plus-module-subs-filter/stable
  NGINX Plus 3rd-party substitution dynamic module

nginx-plus-module-xslt/stable
  NGINX Plus xslt dynamic module

```

The command output also includes an optional debugging symbols package available for each module, for example, `nginx-plus-module-njs-dbg`. These packages are intended for troubleshooting and diagnostics and should be installed only in debugging or development environments. For more information, see [Debugging NGINX]({{< ref "/nginx/admin-guide/monitoring/debugging.md" >}}).

### Installing and loading the module

To install a package, for example, [NGINX JavaScript (njs) dynamic modules]({{< ref "nginscript.md" >}}) for Ubuntu, run the command in a terminal:

```shell
sudo apt update && \
sudo apt install nginx-plus-module-njs
```

Then you include the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the NGINX Plus configuration file for each dynamic module. The path to the dynamic modules default directory depends on your operating system:

- `/usr/lib64/nginx/modules/` for most Linux operating systems
- `/usr/lib/nginx/modules` for Debian, Ubuntu, Alpine
- `/usr/local/etc/nginx/modules` for FreeBSD

For example, to enable the `njs` dynamic modules after the installation of the `nginx-plus-module-njs` package:

- in a text editor, open the NGINX Plus configuration file:
   - `/etc/nginx/nginx.conf` for Linux
   - `/usr/local/etc/nginx/nginx.conf` for FreeBSD

- on the top-level (or the “`main`” context, before any `http` or `stream` blocks), specify the path to the target `.so` file with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive:

   ```nginx
   load_module modules/ngx_http_js_module.so;
   load_module modules/ngx_stream_js_module.so;

   http {
       #...
   }

   stream {
       #...
   }
   ```

### Caveats

Certain dynamic modules may be unavailable on specific operating system versions due to platform limitations. For detailed compatibility information, see the [NGINX Plus Technical Specifications]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}).


## Compiling your own dynamic modules

To compile your own dynamic modules, see the [Compiling Third-Party Dynamic Modules for NGINX Plus](https://www.f5.com/company/blog/nginx/compiling-dynamic-modules-nginx-plus) blogpost.


## Uninstalling a dynamic module

To uninstall a dynamic module, see the [Uninstalling a dynamic module]({{< ref "uninstall.md" >}}) article.

## See Also

- [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Compiling third-party dynamic modules](https://www.f5.com/company/blog/nginx/compiling-dynamic-modules-nginx-plus)

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
