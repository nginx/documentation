---
description: Load modules dynamically into F5 NGINX Plus at runtime to add specialized
  functionality, including features authored by third parties.
title: Dynamic modules overview
toc: true
weight: 10
f5-content-type: how-to
f5-product: NGINX Plus
---

F5 NGINX Plus has a modular architecture that lets you extend its functionality without rebuilding the NGINX Plus binary. Dynamic modules are shared object (`.so`) files that are installed separately and loaded at runtime with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive in the NGINX configuration. After a module is installed and configured, NGINX Plus loads it when it starts or reloads its configuration. This lets you add or update supported modules independently of the core NGINX Plus binary.

NGINX provides a set of dynamic modules as prebuilt NGINX Plus packages. Community and third-party modules may also be available, but they must be built for a compatible NGINX Plus release.

The set of dynamic modules that ships with prebuilt NGINX Plus packages differs from the ones available with NGINX Open Source. For a list of official dynamic modules packages available for  NGINX Open Source, see the [NGINX Open Source dynamic modules documentation](https://nginx.org/en/linux_packages.html#dynmodules).

<img src="/nginx/images/nginx-plus-dynamic-module-plug-ins.png" alt="NGINX Plus allows features to be plugged in on demand" width="500" height="500" style="border:2px solid #666666; padding:2px; margin:2px;" />


## Types of dynamic modules

There are four basic categories of dynamic modules in NGINX. This documentation focuses on NGINX-authored and NGINX-certified Community modules, which are distributed as prebuilt packages through the official `nginx-plus` repository.

{{< table >}}

| Type                    | Description        | Distribution Method   | F5 NGINX Support|
|-------------------------|--------------------|-----------------------|-----------------|
| [NGINX-authored](#nginx-authored-dynamic-modules) | Developed and distributed by NGINX | Prebuilt packages from `nginx-plus` official repo | Full support |
| [NGINX-certified Community](#nginx-certified-community-dynamic-modules) | Tested and distributed by NGINX | Prebuilt packages from `nginx-plus` official repo | Installation and basic configuration support |
| [NGINX Certified Partner](#nginx-certified-partner-dynamic-modules) | Partner-built modules verified through [NGINX’s certification](https://www.f5.com/go/partner/nginx-certified-module-program-documentation) | Provided by partners | Provided by partners |
| [Community](#community-dynamic-modules) | Developed and distributed by third‑party contributors | [Self-compiled](#install_modules_oss) | No support|

{{< /table >}}

## NGINX-authored and NGINX-certified dynamic modules

NGINX‑authored and NGINX‑certified community modules are available as packaged binaries from the official NGINX Plus repository. 

{{< table >}}
| Package name | Module type | Description | Reference documentation |
|---|---|---|---|
| [`nginx-plus-module-acme`]({{< ref "/nginx/admin-guide/dynamic-modules/acme.md" >}}) | Native | Automatic certificate management ([ACMEv2](https://www.rfc-editor.org/rfc/rfc8555.html)) protocol support. | [ACME](https://github.com/nginx/nginx-acme) |
| [`nginx-plus-module-brotli`]({{< ref "/nginx/admin-guide/dynamic-modules/brotli.md" >}}) | Third-party | Brotli compression support with modules for dynamic compression and for serving pre-compressed `.br` files. | [Brotli](https://github.com/google/ngx_brotli) |
| [`nginx-plus-module-encrypted-session`]({{< ref "/nginx/admin-guide/dynamic-modules/encrypted-session.md" >}}) | Third-party | AES-256 based encryption/decryption of NGINX variables. | [Encrypted-Session](https://github.com/openresty/encrypted-session-nginx-module) |
| [`nginx-plus-module-fips-check`]({{< ref "/nginx/admin-guide/dynamic-modules/fips.md" >}}) | Third-party | Verifies if OpenSSL is operating in FIPS mode. | [FIPS Status Check](https://github.com/ogarrett/nginx-fips-check-module) |
| [`nginx-plus-module-geoip`]({{< ref "/nginx/admin-guide/dynamic-modules/geoip.md" >}}) | Native | Enables IP-based geolocation using the precompiled MaxMind databases. | [GeoIP](https://nginx.org/en/docs/http/ngx_http_geoip_module.html) |
| [`nginx-plus-module-geoip2`]({{< ref "/nginx/admin-guide/dynamic-modules/geoip2.md" >}}) | Third-party | Uses MaxMind GeoIP2 for enhanced geolocation. | [GeoIP2](https://github.com/leev/ngx_http_geoip2_module) |
| [`nginx-plus-module-headers-more`]({{< ref "/nginx/admin-guide/dynamic-modules/headers-more.md" >}}) | Third-party | Extends the NGINX [Headers](https://nginx.org/en/docs/http/ngx_http_headers_module.html) module to modify request and response headers. | [Headers-More](https://github.com/openresty/headers-more-nginx-module) |
| [`nginx-plus-module-subs-filter`]({{< ref "/nginx/admin-guide/dynamic-modules/http-substitutions-filter.md" >}}) | Third-party | Enables regex and string-based substitutions in response bodies. | [HTTP Substitutions Filter](https://github.com/yaoweibin/ngx_http_substitutions_filter_module) |
| [`nginx-plus-module-image-filter`]({{< ref "/nginx/admin-guide/dynamic-modules/image-filter.md" >}}) | Native | Adds on-the-fly support for JPEG, GIF, PNG, and WebP image resizing and cropping. | [Image-Filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html) |
| [`nginx-plus-module-lua`]({{< ref "/nginx/admin-guide/dynamic-modules/lua.md" >}}) | Third-party | Embeds Lua programming language. | [Lua](https://github.com/openresty/lua-nginx-module) |
| [`nginx-plus-module-ndk`]({{< ref "/nginx/admin-guide/dynamic-modules/ndk.md" >}}) | Third-party | Provides helper macros for module development. | [NGINX Developer Kit](https://github.com/vision5/ngx_devel_kit) |
| [`nginx-plus-module-njs`]({{< ref "/nginx/admin-guide/dynamic-modules/nginscript.md" >}}) | Native | Adds JavaScript-like scripting for advanced server-side logic in NGINX configuration file. | [njs Scripting Language](https://nginx.org/en/docs/njs/) |
| [`nginx-plus-module-otel`]({{< ref "/nginx/admin-guide/dynamic-modules/opentelemetry.md" >}}) | Native | Adds distributed tracing support via OpenTelemetry. | [OpenTelemetry](https://nginx.org/en/docs/ngx_otel_module.html#directives) |
| [`nginx-plus-module-perl`]({{< ref "/nginx/admin-guide/dynamic-modules/perl.md" >}}) | Native | Integrates Perl scripting for advanced customization. | [Perl](https://nginx.org/en/docs/http/ngx_http_perl_module.html) |
| [`nginx-plus-module-passenger`]({{< ref "/nginx/admin-guide/dynamic-modules/passenger-open-source.md" >}}) | Third-party | Application server for Node.js, Python, Ruby. | [Phusion Passenger](https://www.phusionpassenger.com/library/install/nginx/) |
| [`nginx-plus-module-prometheus`]({{< ref "/nginx/admin-guide/dynamic-modules/prometheus-njs.md" >}}) | Native | Converts [NGINX Plus metrics](https://demo.nginx.com/swagger-ui/) into Prometheus format. | [Prometheus-njs](https://github.com/nginx/nginx-prometheus-exporter) |
| [`nginx-plus-module-rtmp`]({{< ref "/nginx/admin-guide/dynamic-modules/rtmp.md" >}}) | Third-party | Adds streaming capabilities (RTMP, HLS, MPEG-DASH, FFmpeg support). | [RTMP](https://github.com/arut/nginx-rtmp-module) |
| [`nginx-plus-module-set-misc`]({{< ref "/nginx/admin-guide/dynamic-modules/set-misc.md" >}}) | Third-party | Adds `set_*` directives for scripting (extend NGINX [Rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) module). | [Set-Misc](https://github.com/openresty/set-misc-nginx-module) |
| [`nginx-plus-module-auth-spnego`]({{< ref "/nginx/admin-guide/dynamic-modules/spnego.md" >}}) | Third-party | Adds support for [GSS‑API based](https://www.rfc-editor.org/rfc/rfc2743) SPNEGO/Kerberos authentication. | [SPNEGO for Kerberos](https://github.com/stnoonan/spnego-http-auth-nginx-module) |
| [`nginx-plus-module-xslt`]({{< ref "/nginx/admin-guide/dynamic-modules/xslt.md" >}}) | Native | Applies XSLT transformations to XML responses. | [XSLT](https://nginx.org/en/docs/http/ngx_http_xslt_module.html) |
{{< /table >}}


### Getting started with the dynamic modules repository

You can access and install the modules from the NGINX Plus repository using standard package management tools such as `apt`, `dnf`, `pkg`, `yum`, or `zypper`.

Installing a dynamic module involves following steps:

- Verify that NGINX Plus is installed and that you can access the `nginx-plus` repository.
- Install the module package from the repository.
- Load the module using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive.
- Configure the module in the NGINX configuration file.

### Step 1: Verify NGINX Plus installation

To get started with dynamic modules, first make sure [NGINX Plus]({{< ref "/nginx/releases.md" >}}) is installed:

```shell
nginx -v
```
The command should display the installed NGINX Plus version. If it returns `nginx: command not found` or similar, install NGINX Plus by following the [installation instructions]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

Also verify that the NGINX Plus repository certificate and key are present and readable:

```shell
sudo ls -l /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key
sudo test -r /etc/ssl/nginx/nginx-repo.crt && echo "Certificate is readable"
sudo test -r /etc/ssl/nginx/nginx-repo.key && echo "Key is readable"
```
If either file is missing or a certificate-related error occurs when accessing the repository, follow the [NGINX Plus installation instructions]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

### Step 2: Choose the module

To view the list of the dynamic module packages available from the NGINX Plus repository, run the command:

- for Debian and Ubuntu:

  ```shell
  sudo apt update && \
  sudo apt-cache search nginx-plus-module
  ```

- for RHEL, CentOS, Oracle Linux, Rocky Linux, AlmaLinux, Amazon Linux 2023:

  ```shell
  sudo dnf makecache && \
  sudo dnf search nginx-plus-module
  ```

- for SLES:

  ```shell
  sudo zypper refresh && \
  sudo zypper search nginx-plus-module
  ```

- for Alpine Linux:

  ```shell
  sudo apk update && \
  sudo apk search nginx-plus-module
  ```

Example command output (truncated):

```shell
...
nginx-plus-module-geoip - NGINX Plus GeoIP dynamic modules
nginx-plus-module-geoip-dbg - debug symbols for the nginx-plus-module-geoip
nginx-plus-module-geoip2 - NGINX Plus 3rd-party GeoIP2 dynamic modules
nginx-plus-module-geoip2-dbg - debug symbols for the nginx-plus-module-geoip2
nginx-plus-module-headers-more - NGINX Plus 3rd-party headers-more dynamic module
nginx-plus-module-headers-more-dbg - debug symbols for the nginx-plus-module-headers-more
nginx-plus-module-image-filter - NGINX Plus image filter dynamic module
nginx-plus-module-image-filter-dbg - debug symbols for the nginx-plus-module-image-filter
nginx-plus-module-lua - NGINX Plus 3rd-party Lua dynamic modules
nginx-plus-module-lua-dbg - debug symbols for the nginx-plus-module-lua
...
```

For each module, the repository also includes an optional debugging symbols package available for each module, ending with `-dbg`. These packages are intended for troubleshooting and diagnostics only and should be installed in debugging or development environments. For more information, see [Debugging NGINX]({{< ref "/nginx/admin-guide/monitoring/debugging.md" >}}).

### Step 3: Dynamic module package installation

To install a binary package, run the command in a terminal that corresponds to your operating system, replacing `<MODULE_NAME>` with the actual binary package name, for example, `nginx-plus-module-njs`.

- For RHEL, CentOS, Oracle Linux:

  ```shell
  sudo yum update && \
  sudo yum install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Amazon Linux 2023,  AlmaLinux and Rocky Linux:

  ```shell
  sudo dnf update && \
  sudo dnf install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Debian and Ubuntu:

  ```shell
  sudo apt update && \
  sudo apt install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib/nginx/modules`

- For FreeBSD:

  ```shell
  sudo pkg update && \
  sudo pkg install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/local/etc/nginx/modules`

- For SUSE Linux Enterprise:

  ```shell
  sudo zypper refresh && \
  sudo zypper install <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib64/nginx/modules/`

- For Alpine Linux:

  ```shell
  sudo apk update && \
  sudo apk add <MODULE_NAME>
  ```

  The resulting  `.so` file will be installed to: `/usr/lib/nginx/modules`


 ### Step 4: Enable a dynamic module

After installing a dynamic module package, load the module into NGINX Plus by using the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive.

1. In a text editor, open the NGINX Plus configuration file:
   - `/etc/nginx/nginx.conf` for Linux
   - `/usr/local/etc/nginx/nginx.conf` for FreeBSD

1. On the top-level (or the “`main`” context, before any `http` or `stream` blocks), specify the path to the `.so` file with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive. By default, the files are expected to be in the `/modules` directory. The path to the directory depends on your operating system:

   - `/usr/lib64/nginx/modules/` for most Linux operating systems
   - `/usr/lib/nginx/modules` for Debian, Ubuntu, Alpine
   - `/usr/local/etc/nginx/modules` for FreeBSD

   If there are several dynamic modules, specify each module with a separate `load_module` directive:

   ```nginx
   load_module modules/<MODULE_NAME_1>.so;
   load_module modules/<MODULE_NAME_2>.so;

   http {
       #...
   }

   stream {
       #...
   }
   ```

   Replace `<MODULE_NAME_1>` with the name of the first dynamic module and `<MODULE_NAME_2>` with the name of the second dynamic module.

1. Save the changes.

1. Check the new configuration for syntactic validity:

   ```shell
   nginx -t
   ```

1. Reload the NGINX Plus configuration:

   ```shell
   nginx -s reload
   ```

   After installing the module, you will need to configure the module in the NGINX Plus configuration file. Follow the usage and setup instructions provided in the module’s official documentation.


### Caveats

Dynamic modules are supported on the same distributions as NGINX Plus, but certain modules may be unavailable on specific operating system versions because of platform limitations. For detailed compatibility information, see the [Dynamic Modules]({{< ref "/nginx/technical-specs.md#dynamic-modules" >}}) section in NGINX Plus Technical Specifications.

## Community dynamic modules

Community dynamic modules are open source extensions developed and distributed by third‑party contributors of the NGINX community.

These modules are not available in the official NGINX repository. To use them, you must download the source code from the module's repository and [compile it against the NGINX Open Source version](#compile-your-own-dynamic-module) that matches your NGINX Plus version.

The lists of community modules can be found across different community-driven resources, for example, [Awesome NGINX GitHub project](https://github.com/agile6v/awesome-nginx#third-party-modules).


## NGINX Certified Partner dynamic modules
 
In addition to the modules authored by NGINX and community third‑party developers, NGINX Certified Partner Modules are available for purchase from commercial third parties. These modules are verified through [NGINX’s certification process](https://www.f5.com/go/partner/nginx-certified-module-program-documentation). Installation packages, documentation, and support are provided directly by the partners.

{{< table >}}

| Name                            | Description                       | Commercial Support |
|---------------------------------|-----------------------------------|--------------------|
| [CQ botDefence](https://www.cequence.ai/contact-us/) | Simplify traffic analysis to prevent fraud and theft that may result from automated bot attacks against your public-facing web, mobile, and API-based applications. | [Support](https://www.cequence.ai/demo/) provided by [Cequence](https://www.cequence.ai) |
| [Curity Identity Server](https://developer.curity.io/) | Powerful OAuth and OpenID Connect server, used for logging in and securing millions of users, access to API and mobile apps over APIs and microservices. | [Support](https://curity.io/support/professional-services/) and docs [[1]](https://curity.io/resources/learn/nginx-phantom-token-module/), [[2]](https://curity.io/resources/learn/nginx-oauth-proxy/) provided by [Curity](https://curity.io/support/professional-services/) |
| [DeviceAtlas](https://deviceatlas.com/deviceatlas-nginx-module) | Detect what devices users are using, including smartphones, laptops, and weareable devices, and use this data to deliver customized experiences. | [Support](https://deviceatlas.com/resources/support) and [docs](https://docs.deviceatlas.com/apis/enterprise/c/3.1.3/README.Nginx.html) provided by [DeviceAtlas](https://deviceatlas.com/resources/support) |
| [ForgeRock Policy Agent](https://backstage.forgerock.com/downloads/browse/am/featured/web-agents) | In conjunction with ForgeRock Access Management, allows you to authenticate your application and API access. | [Support](https://support.pingidentity.com/s/) and [docs](https://backstage.forgerock.com/docs/openam-web-policy-agents/2023.9/installation-guide/install-nginx.html) provided by [PingIdentity](https://www.pingidentity.com) |
| [HUMAN Security for F5 NGINX](https://docs.humansecurity.com/home) | Provides the required enforcement layer to protect websites and apps from modern automated security threats. | Support provided by [HUMAN Security](https://docs.humansecurity.com/home) |
| IDFConnect SSO/Rest | Integrates your web access management platform's full capabilities with NIGNX Plus. | Support and docs provided by IDFConnect |
| [OPSWAT](https://www.f5.com/go/product/nginx-modules) | Scalable solutions to protect your networks and applications from malware and unknown (zero-day) malicious file content. | [Support](https://www.opswat.com/support) and [docs](https://www.opswat.com/docs/mdicap/integrations/nginx-integration-module) provided by [OPSWAT](https://www.opswat.com/) |
| [Passenger Enterprise](https://www.phusionpassenger.com/features) | An application server with support for Meteor, Node.js, Python, and Ruby apps. | [Support](https://www.phusionpassenger.com/support) and [docs](https://www.phusionpassenger.com/docs/advanced_guides/install_and_upgrade/nginx/install_as_nginx_module.html) provided by [Phusion](https://www.phusionpassenger.com/) |
| [Ping Access](https://support.pingidentity.com/s/marketplace-integration/a7i1W0000004ICRQA2/pingaccess-agent-for-nginx-plus) | Centralized management of access security with advanced contextual policies to secure your mobile and web properties in any domain. | [Support](https://support.pingidentity.com/s/) and [docs](https://docs.pingidentity.com/pingaccess/latest/agents_and_integrations/pa_agent_for_nginx.html) provided by [PingIdentity](https://www.pingidentity.com) |
| [PingIntelligence](https://hub.pingidentity.com/datasheets/3742-pingintelligence-apis) | A complete solution to secure an organization's API across on-premises, public and private clouds, and hybrid IT environments. | [Support](https://support.pingidentity.com/s/) and [docs](https://docs.pingidentity.com/pingintelligence/5.1/pingintelligence_integrations/pingintelligence_nginx_plus_integration.html) provided by [PingIdentity](https://www.pingidentity.com) |
| [Seer Box by Plurbius One](https://seerbox.it/en/) | Cloud-native web application security manager which provides thorough monitoring and protection capabilities. | Support provided by [Seer Box](https://support.seerbox.it/) |
| [Signal Sciences](https://docs.fastly.com/en/ngwaf/about-the-nginx-module) | Intelligently detects malicious requests and blocks them without false positives, while the patented fail-open architecture allows legitimate requests through. | [Support](https://support.fastly.com/s/) and [docs](https://docs.fastly.com/en/ngwaf/installing-the-nginx-dynamic-module) provided by [Fastly](https://www.fastly.com/)|
| [Wallarm](https://www.wallarm.com/company) | The Wallarm WAF provides enterprise-grade protection against advanced Layer 7 application attacks. | [Support](https://www.wallarm.com/support) and [docs](https://docs.wallarm.com/installation/nginx-native-node-internals/#nginx-node) provided by [Wallarm](https://wallarm.com/) |
| [WURFL InFuse](https://www.scientiamobile.com/secondary-products/wurfl-infuze-module-for-nginx-plus/) | Give developers the most advanced, accurate, and high-performance device detection in the industry. | [Support](https://www.scientiamobile.com/support/) and [docs](https://docs.scientiamobile.com/documentation/infuze/infuze-nginx-plus-module-user-guide) provided by [Scientiamobile](https://www.scientiamobile.com/) |
| [51Degrees Device Detection](https://github.com/51Degrees/device-detection-nginx) | Improve speed of response and accuracy, delivering an optimal user experience and high-fidelity analysis. | [Support](https://51degrees.com/pricing/index) and [docs](https://github.com/51Degrees/device-detection-nginx/blob/main/README.md) provided by [51Degrees](https://51degrees.com/about-us) |

{{< /table >}}

The complete list of Certified Partner Modules can be found on the [F5.com Dynamic Modules](https://www.f5.com/go/product/nginx-modules?filter=module-author%3Anginx-certified-partner) page.


## Compile your own dynamic module

You can compile your own dynamic module, or compile a community dynamic module to work with NGINX Plus. To ensure binary compatibility, the module must be compiled against the NGINX Open Source version that corresponds to your installed NGINX Plus release. The module must also be built with compatible configuration options and the `--with-compat` build parameter.

1. Identify the NGINX Open Source version that matches your NGINX Plus version. In a terminal, run the command:

   ```shell
   nginx -v
   ```

   Expected output of the command:

   ```shell
   nginx version: nginx/1.31.6 (nginx-plus-r37.2.0)
   ```

1. Prepare the build environment.

   We strongly recommend compiling dynamic modules on a separate system, referred to as the “build environment”. This approach minimizes the risk and complexity for the system where NGINX Plus will be upgraded, referred to as the “production environment”. The build environment should meet the following requirements:

   - The same operating system as the production environment
   - The same NGINX version as the production environment
   - Compiler and `make` utilities
   - [PCRE](http://pcre.org/) library (development files)
   - [Zlib](http://www.zlib.net/) compression libraries (development files)

   To verify that the required prerequisites are installed in your build environment, run the following commands:

   - For Debian and Ubuntu:

     ```shell
     sudo apt update && \
     sudo apt install gcc make libpcre3-dev zlib1g-dev
     ```

   - For CentOS, Oracle Linux, and RHEL:

     ```shell
     sudo yum update && \
     sudo yum install gcc make pcre-devel zlib-devel
     ```

1. Obtain NGINX Open Source.

   - Identify the NGINX Open Source version that corresponds to your version of NGINX Plus. See [NGINX Plus Releases]({{< ref "nginx/releases.md" >}}).

   - Download the sources for the appropriate NGINX Open Source mainline version, in this case 1.31.6:

     ```shell
     wget -qO - https://nginx.org/download/nginx-1.31.6.tar.gz | tar zxfv -
     ```

1. Obtain the source for the dynamic module.

   The source code for the dynamic module can be placed in any directory in the build environment. As an example, here we're copying the [NGINX “Hello World” module](https://github.com/perusio/nginx-hello-world-module.git/) from GitHub:

   ```shell
   git clone https://github.com/perusio/nginx-hello-world-module.git
   ```

1. Compile the dynamic module.

   First, establish binary compatibility by running the `configure` script with the `‑‑with‑compat` option. Then compile the module with `make modules`.

   ```shell
   cd nginx-1.31.6/ && \
   ./configure --with-compat --add-dynamic-module=../<MODULE_SOURCES> && \
   make modules
   ```

   Replace `<MODULE_SOURCES>` with the path to the dynamic module sources.

   The **.so** file generated by the build process is placed in the **objs** subdirectory:

   ```shell
   ls objs/*.so
   ```

   Expected command output:

   ```shell
   objs/ngx_http_hello_world_module.so
   ```

1. Make a copy of the module file and include the NGINX Open Source version in the filename. This makes it simpler to manage multiple versions of a dynamic module in the production environment.

   ```shell
   cp objs/ngx_http_hello_world_module.so ./ngx_http_hello_world_module_1.31.6.so
   ```

1. Transfer the resulting `.so` file from your build environment to the production environment.

1. In your production environment, copy the resulting `.so` file to the dynamic modules directory. The path to the directory depends on your operating system:

   - `/usr/lib64/nginx/modules/` for most Linux operating systems
   - `/usr/lib/nginx/modules` for Debian, Ubuntu, Alpine
   - `/usr/local/etc/nginx/modules` for FreeBSD

   ```shell
   sudo cp ngx_http_hello_world_module_1.31.6.so /usr/local/nginx/modules/ngx_http_hello_world_module_1.31.6.so
   ```

1. After installing the module, you need to load the module into NGINX Plus. Add the load_module directive in the top‑level (main) context of your `nginx.conf` configuration file (not within the `http` or `stream` context):

   ```nginx
   load_module modules/ngx_http_hello_world_module.so;
   ```

1. Perform the configuration required by the module. In the `http` context, add a `location` block with the `hello_world` directive provided by the `Hello World` module. Requests to the `location` return the response `hello world`:

   ```nginx
   server {
       listen 80;

       location / {
            hello_world;
       }
   } 
   ```

1. Reload your NGINX Plus configuration and test it with a simple request:

   ```shell
   nginx -s reload
   curl http://localhost/

   hello world
   ```


## Uninstalling a dynamic module

To uninstall a dynamic module, see [Uninstalling a dynamic module]({{< ref "uninstall.md" >}}).

## See Also

- [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Compiling third-party dynamic modules](https://www.f5.com/company/blog/nginx/compiling-dynamic-modules-nginx-plus)

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
