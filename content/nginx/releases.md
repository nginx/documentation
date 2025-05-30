---
description: Release information for F5 NGINX Plus, a complete application delivery
  platform, including new features and a list of supported platforms.
docs: DOCS-472
title: Releases
toc: true
weight: 300
type:
- concept
---

<span id="support"></span>
### Software Development Policy

Each F5 NGINX Plus release reaches End of Software Development (EoSD) on the release date of the next version. For NGINX Plus, EoSD means no additional features or routine bug fixes will be applied to that version.
Critical bug patches and security updates are applied to the two (2) most recent releases of NGINX Plus.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
| NGINX Plus Release | Release Date | End of Software Development | End of Security Updates | End of Technical Support |
|---------------------|--------------|-----------------------------|-------------------------|--------------------------|
| R34                | 1st April 2025 | R35 release date           | R36 release date       | 31st March 2027         |
| R33                | 19th Nov 2024  | 1st April 2025             | R35 release date       | 18th Nov 2026           |
| R32                | 29th May 2024  | 19th Nov 2024              | 1st April 2025         | 28th May 2026           |
| R31                | 19th Dec 2023  | 29th May 2024              | 18th Nov 2024          | 18th Dec 2025           |
| R30                | 15th Aug 2023  | 19th Dec 2023              | 28th May 2024          | 14th Aug 2025           |
| R29                | 2nd May 2023   | 15th Aug 2023              | 18th Dec 2023          | 1st May 2025            |

{{< /bootstrap-table >}}

We strongly recommend running the latest version of NGINX Plus in production to ensure you have the latest features, security updates, and critical patches.

### Technical Support Services

F5 offers 24 months of technical support for each F5 NGINX Plus release. The 24-month support period begins on the initial release date for each version of NGINX Plus, as noted in the table. The release of a patch (for example, `NGINX Plus R33p2`) does not reset the 24-month technical support period for the impacted release.


<span id="r34"></span>
## NGINX Plus Release 34 (R34)
_01 April 2025_<br/>
_Based on NGINX Open Source 1.27.4_

NGINX Plus R34 is a feature release:

- [OIDC authentication support]({{< ref "nginx/admin-guide/security-controls/configuring-oidc.md" >}}) via native [ngx_http_oidc_module](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) module.

- NGINX usage reporting: [proxy](https://nginx.org/en/docs/ngx_mgmt_module.html#proxy) support.
- [Caching](https://blog.nginx.org/blog/optimizing-resource-usage-for-complex-ssl-configurations) of SSL certificates and secret keys with variables for [http](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_cache) and [stream](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_certificate_cache).

- The [`keepalive_min_timeout`](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_min_timeout) directive.

- TLSv1.2 and TLSv1.3 are the default [SSL protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) (if supported by the OpenSSL library). If OpenSSL 1.0.0 or older is used, the default SSL protocols are TLSv1 and TLSv1.1.

- Bugfixes in QUIC and HTTP/3, mail proxy, the MP4 module, the `proxy_store` and `proxy_bind` directives.

- Security: insufficient check in virtual servers handling with TLSv1.3 SNI allowed to reuse SSL sessions in a different virtual server, to bypass client SSL certificates verification ([CVE-2025-23419](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2025-23419)).


NGINX Plus R34 is supported on:

{{< bootstrap-table "table table-striped table-bordered" >}}
| Distribution                     | Versions                          |
|----------------------------------|-----------------------------------|
| AlmaLinux                        | 8, 9                              |
| Alpine Linux                     | 3.18, 3.19, 3.20, 3.21            |
| Amazon Linux                    | 2 LTS, 2023                       |
| Debian                           | 11, 12                            |
| FreeBSD                          | 13, 14                            |
| Oracle Linux                     | 8.1+, 9                           |
| RHEL                              | 8.1+, 9.0+                        |
| Rocky Linux                      | 8, 9                              |
| SUSE Linux Enterprise Server     | 15 SP5+                           |
| Ubuntu                           | 20.04 LTS, 22.04 LTS, 24.04 LTS   |
{{< /bootstrap-table >}}

**Notes:**

- Alpine Linux 3.17 is removed
- Alpine Linux 3.18 is deprecated
- Alpine Linux 3.21 is new in this release
- SUSE Linux Enterprise Server 12 is removed
- Ubuntu 20.04 is deprecated
- the [OpenTracing]({{< ref "nginx/admin-guide/dynamic-modules/opentracing.md" >}}) dynamic module is no longer available. It is recommended to use the [OpenTelemetry Distributed Tracing]({{< ref "nginx/admin-guide/dynamic-modules/opentelemetry.md" >}}) module, which incorporates all the features of the OpenTracing module.

More information: [Announcing NGINX Plus R34](https://community.f5.com/kb/technicalarticles/f5-nginx-plus-r34-release-now-available/340300)


### NGINX Plus R34 Update {#r34_p1}

NGINX Plus R34 P1<br/>
_28 May 2025_

This is a bugfix release for NGINX Plus R34.

- Fixed license expiration warning issue in the NGINX Plus live activity monitoring dashboard specifically for deployments utilizing marketplace images of NGINX Plus.


<span id="r33"></span>
## NGINX Plus Release 33 (R33)
_19 November 2024_<br/>
_Based on NGINX Open Source 1.27.2_

NGINX Plus R33 is a feature release:

- Licensing: Each NGINX Plus instance now requires a JWT license file. The JWT must be obtained from [MyF5](https://account.f5.com/myf5) and is expected to be located at `/etc/nginx/` for Linux or
`/usr/local/etc/nginx/` for FreeBSD or at the path specified by the [`license_token`](https://nginx.org/en/docs/ngx_mgmt_module.html#license_token) in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) context.

- NGINX usage reporting: Usage report is sent to F5 licensing endpoint [every hour](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) using the [secure](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_verify) connection. The initial usage report should be sent once NGINX Plus starts after installation or upgrade to R33. If the initial usage report is not received by the endpoint, NGINX Plus will stop processing traffic. A 180-day grace period can be [enabled](https://nginx.org/en/docs/ngx_mgmt_module.html#enforce_initial_report) to submit the initial usage report.

  Optionally, for network-restricted environments, reporting can be [configured](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) to [NGINX Instance Manager]({{< ref "nim/index.md" >}}) from which the report can be sent to F5 licensing endpoint.

  For more information about licensing and usage reporting, see [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}}) article and [`ngx_mgmt_module`](https://nginx.org/en/docs/ngx_mgmt_module.html) module documentation.

- OCSP stapling support and client certificate validation with OCSP
in the [stream](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html) module with the
[`ssl_ocsp`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_ocsp) and [`ssl_ocsp_responder`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_ocsp_responder) directives.

- SSL key logging with the
`ssl_key_log` directive for [http](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_key_log), [stream](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_key_log),
[proxy](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_key_log), [grpc](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_key_log), [uwsgi](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_key_log) that allows logging SSL keys created during client and upstream connections to the file.
The argument is a file name in the `SSLKEYLOGFILE` format compatible with Wireshark.

- SSL Certificate Caching: Fixed loading of trusted CA bundles containing entries with duplicate Distinguished Name (DN).

- Change: the [`ssl_client_certificate`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_client_certificate) directive is not required for client SSL certificates verification.

- Response trailers support in proxy with the [`proxy_pass_trailers`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass_trailers) directive that allows passing trailer fields from a proxied server to a client.

- The [NGINX JavaScript]({{< ref "nginx/admin-guide/dynamic-modules/nginscript.md" >}}) module was updated to version [0.8.7](https://nginx.org/en/docs/njs/changes.html#njs0.8.7), featuring QuickJS [runtime support](https://nginx.org/en/docs/njs/engine.html).

- Added initial support for Post Quantum Cryptography.

{{< bootstrap-table "table table-striped table-bordered" >}}
| Distribution                     | Versions                          |
|----------------------------------|-----------------------------------|
| AlmaLinux                        | 8, 9                              |
| Alpine Linux                     | 3.17, 3.18, 3.19, 3.20            |
| Amazon Linux                    | 2 LTS, 2023                       |
| Debian                           | 11, 12                            |
| FreeBSD                          | 13, 14                            |
| Oracle Linux                     | 8.1+, 9                           |
| RHEL                              | 8.1+, 9.0+                        |
| Rocky Linux                      | 8, 9                              |
| SUSE Linux Enterprise Server     | 12, 15 SP5+                       |
| Ubuntu                           | 20.04 LTS, 22.04 LTS, 24.04 LTS   |
{{< /bootstrap-table >}}


**Notes:**

- Alpine Linux 3.16 is removed
- Alpine Linux 3.17 is deprecated
- Alpine Linux 3.20 is new in this release
- CentOS 7.4+ is removed
- RHEL 7.4+ is removed
- Oracle Linux 7.4+ is removed
- SUSE Linux Enterprise Server 12 is deprecated
- support for s390x architecture removed
- the [Lua]({{< ref "nginx/admin-guide/dynamic-modules/lua.md" >}}) module is no longer available for SUSE Linux Enterprise Server 12

More information: [Announcing NGINX Plus R33](https://community.f5.com/kb/technicalarticles/announcing-nginx-plus-r33-release/336403)


<span id="r33_p1"></span>
### NGINX Plus R33 Updates

NGINX Plus R33 P1<br/>
_4 December 2024_

This is a bugfix release for NGINX Plus R33.

- Resolved an issue related to product code detection on Azure Marketplace VMs.


NGINX Plus R33 P2<br/>
_5 February 2025_

This is a security release for NGINX Plus R33.

- Security Fix [CVE-2025-23419](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2025-23419) in SNI that adds a restriction for TLSv1.3 cross-SNI session resumption.

<span id="r32"></span>
## NGINX Plus Release 32 (R32)
_29 May 2024_<br/>
_Based on NGINX Open Source 1.25.5_

NGINX Plus R32 is a feature release:

- SSL certificate caching that improves the NGINX startup time and memory usage in cases of configurations with large number of locations with relatively small number of unique certificate/key pairs

- The [`stream_pass`](https://nginx.org/en/docs/stream/ngx_stream_pass_module.html) module that allows passing the accepted connection directly to any configured listening socket in `http`, `stream`, `mail`, and other similar modules

- NGINX Plus [official container images](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/)

- [Virtual servers](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server_name) in the [`stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) module

- The `deferred`, `accept_filter`, and `setfib` parameters of the [listen](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) directive in the [`stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) module

- Cache line size detection for some architectures

- Security fixes:

  - Heap Overflow w/ write ([CVE-2024-32760](https://my.f5.com/manage/s/article/K000139609)): Undisclosed HTTP/3 encoder instructions can cause NGINX worker processes to terminate or cause other possible impacts

  - Stack Overflow / Use after free ([CVE-2024-31079](https://my.f5.com/manage/s/article/K000139611)): Undisclosed HTTP/3 requests can cause NGINX worker processes to terminate or cause other possible impacts. This attack requires that a request be specifically timed during the connection draining process, which the attacker has no visibility and limited influence over

  - Null Pointer Dereference w/ Empty Header ([CVE-2024-35200](https://my.f5.com/manage/s/article/K000139612)): Undisclosed HTTP/3 requests can cause NGINX worker processes to terminate or cause other possible impacts

  - Memory Disclosure during QUIC handshake ([CVE-2024-34161](https://my.f5.com/manage/s/article/K000139627)): When the network infrastructure supports a Maximum Transmission Unit (MTU) of 4096 or greater without fragmentation, undisclosed QUIC messages can cause NGINX worker processes to terminate or cause leakage of previously freed memory

- Bugfixes:

  - in the [MQTT Filter](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html) module: malformed packets when using default properties

  - in the [zone_sync](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) module: memory leak on configuration reload

  - Unexpected connection closure while using 0-RTT in QUIC

  - Connections with pending AIO operations might be closed prematurely during graceful shutdown of old worker processes

  - Socket leak alerts no longer logged when fast shutdown was requested after graceful shutdown of old worker processes

  - A socket descriptor error, a socket leak, or a segmentation fault in a worker process (for SSL proxying) might occur if AIO was used in a subrequest

  - A segmentation fault might occur in a worker process if SSL proxying was used along with the [image_filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html) directive and errors with code 415 were redirected with the [error_page](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) directive

  - Bugfixes and improvements in HTTP/3

- New features and bugfixes in njs:

  - setting the `Server `header for outgoing header

  - QuickJS engine support in CLI

NGINX Plus R32 is supported on:

{{< bootstrap-table "table table-striped table-bordered" >}}
| Distribution                     | Versions                          |
|----------------------------------|-----------------------------------|
| AlmaLinux                        | 8, 9                              |
| Alpine Linux                     | 3.16, 3.17, 3.18, 3.19            |
| Amazon Linux                     | 2 LTS, 2023                       |
| CentOS                           | 7.4+                              |
| Debian                           | 11, 12                            |
| FreeBSD                          | 13, 14                            |
| Oracle Linux                     | 7.4+, 8.1+, 9                     |
| RHEL                             | 7.4+, 8.1+, 9.0+                  |
| Rocky Linux                      | 8, 9                              |
| SUSE Linux Enterprise Server     | 12 SP5, 15 SP2                    |
| Ubuntu                           | 20.04 LTS, 22.04 LTS, 24.04 LTS   |
{{< /bootstrap-table >}}

**Notes:**

- Ubuntu 24.04 LTS is new in this release
- CentOS 7 is deprecated
- RHEL 7 is deprecated
- Oracle Linux 7 is deprecated
- FreeBSD 12 is removed
- [OpenTracing dynamic module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/opentracing/) (package name is `nginx-plus-module-opentracing-module`) is deprecated
- [ModSecurity WAF dynamic module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginx-waf/) (package name is `nginx-plus-module-modsecurity`) reached end of support and is no longer available

More information: [Announcing NGINX Plus R32](https://www.f5.com/company/blog/nginx/announcing-NGINX-plus-R32)


<span id="r32_p1"></span>
### NGINX Plus R32 Updates

These are security releases for NGINX Plus R32.

NGINX Plus R32 P1<br/>
_14 August 2024_

- Security:

  - In the [MQTT Filter](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html) module, undisclosed requests can cause an increase in memory resource utilization ([CVE-2024-39792](https://my.f5.com/manage/s/article/K000140108))

  - In the [MP4](https://nginx.org/en/docs/http/ngx_http_mp4_module.html) module, a specially crafted `mp4` file can cause NGINX worker memory over-read resulting in its termination by using a specially crafted `mp4` file ([CVE-2024-7347](https://my.f5.com/manage/s/article/K000140529))

- Various fixes in SSL certificate caching


NGINX Plus R32 P2<br/>
_5 February 2025_

- Security Fix [CVE-2025-23419](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2025-23419) in SNI that adds a restriction for TLSv1.3 cross-SNI session resumption.

- Regression issue fix in SSL Certificate Caching.

<span id="r31"></span>
## NGINX Plus Release 31 (R31)
_19 December 2023_<br/>
_Based on NGINX Open Source 1.25.3_

NGINX Plus R31 is a feature release:

- [Native usage reporting](https://nginx.org/en/docs/ngx_mgmt_module.html)
of NGINX Plus installations to [NGINX Instance Manager](https://docs.nginx.com/nginx-management-suite/nim/)

- The [$upstream_last_server_name](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#var_upstream_last_server_name) variable that keeps the name of the last selected upstream server and allows passing it to the proxied server through SNI

- Notable startup speedup when using a large number of locations

- [HTTP/3 and QUIC](https://nginx.org/en/docs/http/ngx_http_v3_module.html) features and bugfixes:

  - Path MTU Discovery (PMTUD) feature

  - support for `TLS_AES_128_CCM_SHA256` cipher suite

  - support for [`server_tokens`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_tokens) with variables

  - bugfixes and improvements

- New features in njs:

  - the `js_periodic` directive for [http](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_periodic) and [stream](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_periodic) that allows specifying a JS handler to run at regular intervals

  - the `Console` object:
[`error()`](https://nginx.org/en/docs/njs/reference.html#console_error),
[`info()`](https://nginx.org/en/docs/njs/reference.html#console_info),
[`log()`](https://nginx.org/en/docs/njs/reference.html#console_log),
[`time()`](https://nginx.org/en/docs/njs/reference.html#console_time),
[`timeEnd()`](https://nginx.org/en/docs/njs/reference.html#console_time_end),
[`warn()`](https://nginx.org/en/docs/njs/reference.html#console_warn) methods

  - the [`fs()`](https://nginx.org/en/docs/njs/reference.html#njs_api_fs) module: the [`fs.existsSync()`](https://nginx.org/en/docs/njs/reference.html#fs_existssync) method

  - [shared dictionary](https://nginx.org/en/docs/njs/reference.html#ngx_shared): the [`items()`](https://nginx.org/en/docs/njs/reference.html#dict_items) method

- MQTT bugfixes and improvements:

  - the `CONNECT` message was rejected when a password was not provided

  - the `CONNECT` message parsing is stopped when the message length is less than the number of bytes received

  - added the `Will` topic and `Will` payload for MQTT Version 3.1.1 if the `CONNECT` message is rewritten

- Various bugfixes and improvements:

  - the `Status` response header line with an empty reason phrase from the backend was handled incorrectly

  - memory leak during reconfiguration when using the PCRE2 library

  - improved detection of misbehaving clients when using HTTP/2

- The [OpenTracing](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/opentracing/) module introduced in NGINX Plus [R18](#r18) is deprecated, it recommended to use the [OpenTelemetry Distributed Tracing](https://nginx.org/en/docs/ngx_otel_module.html) module that incorporates all the features of the OpenTracing module.

NGINX Plus R31 is supported on:

{{< bootstrap-table "table table-striped table-bordered" >}}
| Distribution                     | Versions                          |
|----------------------------------|-----------------------------------|
| AlmaLinux                        | 8, 9                              |
| Alpine Linux                     | 3.16, 3.17, 3.18, 3.19            |
| Amazon Linux                     | 2 LTS, 2023                       |
| CentOS                           | 7.4+                              |
| Debian                           | 11, 12                            |
| FreeBSD                          | 12.1+, 13, 14                     |
| Oracle Linux                     | 7.4+, 8.1+, 9                     |
| RHEL                             | 7.4+, 8.1+, 9.0+                  |
| Rocky Linux                      | 8, 9                              |
| SUSE Linux Enterprise Server     | 12 SP5, 15 SP2                    |
| Ubuntu                           | 20.04 LTS, 22.04 LTS              |
{{< /bootstrap-table >}}


**Notes:**

- Alpine Linux 3.19 is new in this release
- FreeBSD 14 is new in this release
- Alpine Linux 3.15 is removed
- FreeBSD 12 is deprecated
- OpenTracing dynamic module (package name is `nginx-plus-module-opentracing-module`) is deprecated

More information: [Announcing NGINX Plus R31](https://www.nginx.com/blog/nginx-plus-r31-released/)

<span id="r31_p1"></span>
### NGINX Plus R31 Update

This is an improvement release for NGINX Plus R31.

NGINX Plus R31 P1<br/>
_14 February 2024_

- Security: a segmentation fault might occur in a worker process if HTTP/3 was used ([CVE-2024-24989](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2024-24989), [CVE-2024-24990](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2024-24990))

- Management module: fixed a potential crash that might happen while using a system resolver

More information: [Updating NGINX for the Vulnerabilities in the HTTP/3 Module](https://www.nginx.com/blog/updating-nginx-for-the-vulnerabilities-in-the-http-3-module/)

<span id="r31_p2"></span>
NGINX Plus R31 P2<br/>
_29 May 2024_

- Security:

  - Heap Overflow w/ write ([CVE-2024-32760](https://my.f5.com/manage/s/article/K000139609)): Undisclosed HTTP/3 encoder instructions can cause NGINX worker processes to terminate or cause other possible impacts

  - Stack Overflow / Use after free ([CVE-2024-31079](https://my.f5.com/manage/s/article/K000139611)): Undisclosed HTTP/3 requests can cause NGINX worker processes to terminate or cause other possible impacts. This attack requires that a request be specifically timed during the connection draining process, which the attacker has no visibility and limited influence over

  - Null Pointer Dereference w/ Empty Header ([CVE-2024-35200](https://my.f5.com/manage/s/article/K000139612)): Undisclosed HTTP/3 requests can cause NGINX worker processes to terminate or cause other possible impacts

  - Memory Disclosure during QUIC handshake ([CVE-2024-34161](https://my.f5.com/manage/s/article/K000139627)): When the network infrastructure supports a Maximum Transmission Unit (MTU) of 4096 or greater without fragmentation, undisclosed QUIC messages can cause NGINX worker processes to terminate or cause leakage of previously freed memory

<span id="r31_p3"></span>
NGINX Plus R31 P3<br/>
_14 August 2024_

- Security:

  - In the [MQTT Filter](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html) module, undisclosed requests can cause an increase in memory resource utilization ([CVE-2024-39792](https://my.f5.com/manage/s/article/K000140108))

  - In the [MP4](https://nginx.org/en/docs/http/ngx_http_mp4_module.html) module, a specially crafted `mp4` file can cause NGINX worker memory over-read resulting in its termination by using a specially crafted `mp4` file ([CVE-2024-7347](https://my.f5.com/manage/s/article/K000140529))



<span id="r30"></span>
## NGINX Plus Release 30 (R30)
_15 August 2023_<br/>
_Based on NGINX Open Source 1.25.1_

NGINX Plus R30 is a feature release:

- Native support for [HTTP/3 and QUIC](https://nginx.org/en/docs/http/ngx_http_v3_module.html)

- Version [`9`](https://nginx.org/en/docs/http/ngx_http_api_module.html#compatibility) of the [API](https://nginx.org/en/docs/http/ngx_http_api_module.html):

  - Per-worker connection statistics including accepted, dropped, active and idle connections, total and current requests

- The [Prometheus-njs module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/prometheus-njs/) now supports version [`9`](https://nginx.org/en/docs/http/ngx_http_api_module.html) of the [API](https://nginx.org/en/docs/http/ngx_http_api_module.html)

- DNS reload optimization: now DNS name expiry time for dynamically-resolved upstream hosts is preserved across reloads

- The new [`mqtt_buffers`](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html#mqtt_buffers) directive in the [MQTT Filter](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html) module that specifies the number of buffers allocated per connection, the directive also supersedes the [`mqtt_rewrite_buffer_size`](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html#mqtt_buffer_size) directive

- The [`ssl`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) directive deprecated in NGINX Plus Release 16 was removed, the `ssl` parameter of the [`listen`](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive should be used instead

- The new [`http2`](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2) directive
obsoletes the `http2` parameter of the [`listen`](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive which is now deprecated

- HTTP/2 server push removed, the [`http2_push`](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_push), [`http2_push_preload`](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_push_preload), [`http2_max_concurrent_pushes`](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_concurrent_pushesd) directives are made obsolete

- Optional NGINX diagnostic scripts that collect the data
required for troubleshooting are available as a separate download package

- New features in [njs](http://nginx.org/en/docs/njs):

  - global NGINX properties: [`ngx.build`](https://nginx.org/en/docs/njs/reference.html#ngx_build), [`ngx.conf_file_path`](https://nginx.org/en/docs/njs/reference.html#ngx_conf_file_path), [`ngx.error_log_path`](https://nginx.org/en/docs/njs/reference.html#ngx_error_log_path), [`ngx.prefix`](https://nginx.org/en/docs/njs/reference.html#ngx_prefix), [`ngx.version`](https://nginx.org/en/docs/njs/reference.html#ngx_version), [`ngx.version_number`](https://nginx.org/en/docs/njs/reference.html#ngx_version_number), [`ngx.worker_id`](https://nginx.org/en/docs/njs/reference.html#ngx_worker_id)

  - the `js_shared_dict_zone` directive for [http](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_shared_dict_zone) and [stream](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_shared_dict_zone) that allows declaring a dictionary shared between worker processes

  - [ES13-compliant](https://nginx.org/en/docs/njs/compatibility.html) `Array` methods: `from()`, `toSorted()`, `toSpliced()`, `toReversed()`

  - [`CryptoKey`](https://nginx.org/en/docs/njs/reference.html#cryptokey) properties in `WebCrypto` API: [`algorithm`](https://nginx.org/en/docs/njs/reference.html#cryptokey_alg), [`extractable`](https://nginx.org/en/docs/njs/reference.html#cryptokey_extractable), [`type`](https://nginx.org/en/docs/njs/reference.html#cryptokey_type), [`usages`](https://nginx.org/en/docs/njs/reference.html#cryptokey_usages)

- The GeoIP2 module is no longer available for Amazon Linux 2 as the EPEL repository doesn't provide the `libmaxminddb` library required to build the module

NGINX Plus R30 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                      |
|-----------------------------------|-------------------------------|
| AlmaLinux                         | 8, 9                          |
| Alpine Linux                      | 3.16, 3.17, 3.18              |
| Amazon Linux                     | 2 LTS, 2023                   |
| CentOS                            | 7.4+                          |
| Debian                            | 11, 12                        |
| FreeBSD                           | 12.1+, 13                     |
| Oracle Linux                      | 7.4+, 8.1+, 9                 |
| RHEL                              | 7.4+, 8.1+, 9.0+              |
| Rocky Linux                       | 8, 9                          |
| SUSE Linux Enterprise Server      | 12 SP5, 15 SP2                |
| Ubuntu                            | 20.04 LTS, 22.04 LTS          |
{{</bootstrap-table>}}


**Notes:**

- Alpine Linux 3.18 is new in this release
- Debian 12 is new in this release
- Alpine Linux 3.15 is deprecated
- Alpine Linux 3.14 is removed
- Ubuntu 18.04 is removed
- The GeoIP2 dynamic module (package name is `nginx-plus-module-geoip2`) for Amazon Linux 2 is no longer provided

More information: [Announcing NGINX Plus R30](https://www.nginx.com/blog/nginx-plus-r30-released/)


<span id="r30_p1"></span>
### NGINX Plus R30 Update

This is an improvement release for NGINX Plus R30.

NGINX Plus R30 P1<br/>
_11 October 2023_

- Additional protection against HTTP/2 Rapid Reset Attack vulnerability ([CVE-2023-44487](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-44487)) that may affect NGINX only when it is configured with the [keepalive requests](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_requests) value substantially higher than the default value. Limitations in HTTP/2 protocol allow clients to produce a higher RPS rate than expected from a configured HTTP/2 [max concurrent streams](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_concurrent_streams) setting which can be exploited to trigger a Denial-of-Service attack.

More information: [HTTP/2 Rapid Reset Attack Impacting NGINX Products](https://www.nginx.com/blog/http-2-rapid-reset-attack-impacting-f5-nginx-products/)


<span id="r30_p2"></span>
NGINX Plus R30 P2<br/>
_14 February 2024_

- Security: a segmentation fault might occur in a worker process if HTTP/3 was used ([CVE-2024-24990](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2024-24990))

More information: [Updating NGINX for the Vulnerabilities in the HTTP/3 Module](https://www.nginx.com/blog/updating-nginx-for-the-vulnerabilities-in-the-http-3-module/)


<span id="r29"></span>
## NGINX Plus Release 29 (R29)
_02 May 2023_<br/>
_Based on NGINX Open Source 1.23.4_

NGINX Plus R29 is a feature release:

- MQTT messaging protocol support with the [MQTT Preread](https://nginx.org/en/docs/stream/ngx_stream_mqtt_preread_module.html) and [MQTT Filter](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html) modules

- [SAML Authentication reference implementation](https://github.com/nginxinc/nginx-saml) based on native njs [XML support](http://nginx.org/en/docs/njs/reference.html#xml)

- OpenTelemetry Distributed Tracing [module](https://nginx.org/en/docs/ngx_otel_module.html), distributed in NGINX Plus packages (package name is `nginx-plus-module-otel`) and is available as a [dynamic module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/opentelemetry/)

- Experimental support for [HTTP/3 and QUIC](https://nginx.org/en/docs/http/ngx_http_v3_module.html), distributed in NGINX Plus packages (package name is `nginx-plus-quic`)

- TLS 1.3 is enabled by default (the `TLSv1.3` parameter of the [ssl_protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) directive)

- The [internal_redirect](https://nginx.org/en/docs/http/ngx_http_internal_redirect_module.html#internal_redirect) directive and module that allows internal redirects after checking [request](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) and [connection](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html) processing limits, and [access](https://nginx.org/en/docs/http/ngx_http_access_module.html) limits

- New feature in [OpenID Connect reference implementation](https://github.com/nginxinc/nginx-openid-connect): support for access token

- The [Prometheus-njs module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/prometheus-njs/) now supports version [`8`](https://nginx.org/en/docs/http/ngx_http_api_module.html#compatibility) of the [API](https://nginx.org/en/docs/http/ngx_http_api_module.html), including SSL extended statistics for each HTTP [upstream](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_upstream) and stream [upstream](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_upstream), SSL extended statistics for each HTTP [server zone](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_server_zone) and stream [server zone](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_server_zone), and extended statistics for [SSL](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_ssl_object)

- The NGINX JavaScript ([njs](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/)) module for NGINX Plus was updated to version [0.7.12](http://nginx.org/en/docs/njs/changes.html#njs0.7.12), featuring extended [Fetch API](https://nginx.org/en/docs/njs/reference.html#ngx_fetch) and [WebCrypto API](http://nginx.org/en/docs/njs/reference.html#builtin_crypto), [XML module](https://nginx.org/en/docs/njs/reference.html#xml_node) to parse and modify XML documents, [Zlib module](https://nginx.org/en/docs/njs/reference.html#zlib) to support compression

NGINX Plus R29 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                      |
|-----------------------------------|-------------------------------|
| AlmaLinux                         | 8, 9                          |
| Alpine Linux                      | 3.15, 3.16, 3.17              |
| Amazon Linux                      | 2 LTS, 2023                   |
| CentOS                            | 7.4+                          |
| Debian                            | 11                            |
| FreeBSD                           | 12.1+, 13                     |
| Oracle Linux                      | 7.4+, 8.1+, 9                 |
| RHEL                              | 7.4+, 8.1+, 9.0+              |
| Rocky Linux                       | 8, 9                          |
| SUSE Linux Enterprise Server      | 12 SP5, 15 SP2                |
| Ubuntu                            | 20.04 LTS, 22.04 LTS          |
{{</bootstrap-table>}}

**Notes:**

- Amazon Linux 2023 is new in this release
- Alpine Linux 3.14 is deprecated
- Ubuntu 18.04 is deprecated
- Alpine Linux 3.13 is removed
- The ModSecurity dynamic module (package name is `nginx-plus-module-modsecurity`) is no longer supported

More information: [Announcing NGINX Plus R29](https://www.nginx.com/blog/nginx-plus-r29-released/)


<span id="r29_p1"></span>
### NGINX Plus R29 Update

This is an improvement release for NGINX Plus R29.

NGINX Plus R29 P1<br/>
_11 October 2023_

- Additional protection against HTTP/2 Rapid Reset Attack vulnerability ([CVE-2023-44487](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-44487)) that may affect NGINX only when it is configured with the [keepalive requests](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_requests) value substantially higher than the default value. Limitations in HTTP/2 protocol allow clients to produce a higher RPS rate than expected from a configured HTTP/2 [max concurrent streams](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_concurrent_streams) setting which can be exploited to trigger a Denial-of-Service attack.

More information: [HTTP/2 Rapid Reset Attack Impacting NGINX Products](https://www.nginx.com/blog/http-2-rapid-reset-attack-impacting-f5-nginx-products/)


<span id="r28"></span>
## NGINX Plus Release 28 (R28)
_29 November 2022_<br/>
_Based on NGINX Open Source 1.23.2_

NGINX Plus R28 is a feature release:

- API version 8 update:

  - SSL extended statistics for each HTTP [upstream](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_upstream) and stream [upstream](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_upstream)

  - SSL extended statistics for each HTTP [server zone](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_server_zone) and stream [server zone](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_server_zone)

  - Extended statistics for [SSL](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_ssl_object) endpoint

- PROXY protocol v2 TLV variables for Amazon Web Services, Google Cloud Platform, and Microsoft Azure in [HTTP](https://nginx.org/en/docs/http/ngx_http_proxy_protocol_vendor_module.html) and [stream](https://nginx.org/en/docs/stream/ngx_stream_proxy_protocol_vendor_module.html)

- The `proxy_protocol_tlv_` variable for [HTTP](http://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_tlv_) and [stream](http://nginx.org/en/docs/stream/ngx_stream_core_module.html#var_proxy_protocol_tlv_) that can keep different TLV types from the PROXY protocol header including SSL TLV types

- [Sticky cookie](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky) load-balancing method now can accept variables in the [SameSite](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_samesite) attribute in addition to  `Strict`, `Lax`,or `None` values

- NGINX Plus live activity monitoring dashboard now supports HTTP status code statistics and extended SSL statistics for upstreams and server zones

- TLS session tickets encryption keys are now automatically rotated when using shared memory in the [`ssl_session_cache`](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache) directive

- Looking up of IPv4 addresses while resolving now can be disabled with the `ipv4=off` parameter of the [`resolver`](http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive.

- Changes in handling multiple headers with identical names.

  - Most of the known duplicate upstream response headers are now ignored with a warning.

  - Duplicate `Content-Length` and `Transfer-Encoding` headers are now rejected as well as the responses with invalid `Content-Length` or `Transfer-Encoding` headers, or if both `Content-Length` and `Transfer-Encoding` are present in the response.

NGINX Plus R28 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                            |
|-----------------------------------|-------------------------------------|
| AlmaLinux                         | 8, 9                                |
| Alpine Linux                      | 3.13, 3.14, 3.15, 3.16, 3.17        |
| Amazon Linux                      | 2 LTS                               |
| CentOS                            | 7.4+                                |
| Debian                            | 11                                  |
| FreeBSD                           | 12.1+, 13                           |
| Oracle Linux                      | 7.4+, 8.1+, 9                       |
| RHEL                              | 7.4+, 8.1+, 9.0+                    |
| Rocky Linux                       | 8, 9                                |
| SUSE Linux Enterprise Server      | 12 SP5, 15 SP2                      |
| Ubuntu                            | 18.04 LTS, 20.04 LTS, 22.04 LTS     |
{{</bootstrap-table>}}

**Notes:**

- AlmaLinux 8 and 9 are new in this release
- Alpine Linux 3.17 is new in this release
- Oracle Linux 9 is new in this release
- Rocky Linux 8 and 9 are new in this release
- Debian 10 is removed
- Alpine Linux 3.13 is deprecated

More information: [Announcing NGINX Plus R28](https://www.nginx.com/blog/nginx-plus-r28-released/)


<span id="r27"></span>
## NGINX Plus Release 27 (R27)
_28 June 2022_<br/>
_Based on NGINX Open Source 1.21.6_

NGINX Plus R27 is a feature release:

- API version 8:

  - SSL statistics for each HTTP [upstream](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_upstream) and stream [upstream](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_upstream)

  - SSL statistics for each HTTP [server zone](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_server_zone) and stream [server zone](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_server_zone)

- JWT Authentication: error code can be customized with the `error` parameter of the [`auth_jwt_require`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_require) directive if any additional condition of JWT validation fails

- HTTP health checks: the [`keepalive_time`](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check_keepalive_time) parameter of the [`health_check`](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) directive
that enables keepalive connections for health checks and specifies the time
during which requests can be processed through one keepalive connection

- The [Prometheus-njs module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/prometheus-njs/) now supports version [`7`](https://nginx.org/en/docs/http/ngx_http_api_module.html#compatibility) of the [API](https://nginx.org/en/docs/http/ngx_http_api_module.html), including `/stream/limit_conns/`, `/http/limit_conns/`, `/http/limit_req/` data, and HTTP status code statistics for [upstreams](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_upstream), [server zones](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_server_zone) and [location zones](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_location_zone)

- [kTLS](https://www.nginx.com/blog/improving-nginx-performance-with-kernel-tls/) is now also available on RHEL 9.0 and Ubuntu 22.04


NGINX Plus R27 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                            |
|-----------------------------------|-------------------------------------|
| Alpine Linux                      | 3.13, 3.14, 3.15, 3.16              |
| Amazon Linux                      | 2 LTS                               |
| CentOS                            | 7.4+                                |
| Debian                            | 10, 11                              |
| FreeBSD                           | 12.1+, 13                           |
| Oracle Linux                      | 7.4+, 8.1+                          |
| RHEL                              | 7.4+, 8.1+, 9.0+                    |
| SUSE Linux Enterprise Server      | 12 SP5, 15 SP2                      |
| Ubuntu                            | 18.04 LTS, 20.04 LTS, 22.04 LTS     |
{{</bootstrap-table>}}

**Notes:**

- Alpine Linux 3.16 is new in this release
- RHEL 9.0+ is new in this release
- Ubuntu 22.04 LTS is new in this release
- Debian 10 is deprecated
- Alpine 3.12 is no longer supported
- CentOS 8 is no longer supported
- Power 8 architecture is no longer supported

More information: [Announcing NGINX Plus R27](https://www.nginx.com/blog/nginx-plus-r27-released/)

<span id="r27_p1"></span>
### NGINX Plus R27 Update

This is a bug‑fix release for NGINX Plus R27.

NGINX Plus R27 P1<br/>
_19 October 2022_

- In HLS ([CVE-2022-41743](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-41743)) and MP4 ([CVE-2022-41741](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-41741)) modules when processing specially crafted video files a memory corruption, or a memory disclosure in MP4 module ([CVE-2022-41742](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-41742)) could happen.

<span id="r26"></span>
## NGINX Plus Release 26 (R26)
_15 February 2022_<br/>
_Based on NGINX Open Source 1.21.5_

NGINX Plus R26 is a feature release:

- JWT key caching with the
[`auth_jwt_key_cache`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_cache) directive

- Enhanced ALPN support with the [`ssl_alpn`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_alpn) directive for stream, and the `$ssl_alpn_protocol` variable for [HTTP](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#var_ssl_alpn_protocol) and [stream](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#var_ssl_alpn_protocol)

- The [`$ssl_curve`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#var_ssl_curve) variable that returns the negotiated curve used for SSL handshake key exchange process

- The [`proxy_half_close`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_half_close) directive for stream that allows closing one side of a connection while the data is still transmitted

- The [`mp4_start_key_frame`](https://nginx.org/en/docs/http/ngx_http_mp4_module.html#mp4_start_key_frame) directive in the MP4 module that forces a video to always start with a key frame


NGINX Plus R26 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                            |
|-----------------------------------|-------------------------------------|
| Alpine Linux                      | 3.12, 3.13, 3.14, 3.15              |
| Amazon Linux                      | 2 LTS                               |
| CentOS                            | 7.4+, 8.1+                          |
| Debian                            | 10, 11                              |
| FreeBSD                           | 12.1+, 13                           |
| Oracle Linux                      | 7.4+, 8.1+                          |
| RHEL                              | 7.4+, 8.1+, 9.0+                    |
| SUSE Linux Enterprise Server      | 12 SP5, 15 SP2                      |
| Ubuntu                            | 18.04 LTS, 20.04 LTS, 22.04 LTS     |
{{</bootstrap-table>}}

**Notes:**

- Alpine Linux 3.15 is new in this release
- Added support for IBM Z (s390x) for CentOS 8+, RHEL 8+, and Ubuntu 20.04 LTS
- RHEL 8.0+ was updated to RHEL 8.1+
- CentOS 8.0+ was updated to CentOS 8.1+
- CentOS 8 is deprecated
- Power 8 is deprecated
- Alpine 3.12 is deprecated
- Alpine 3.11 is no longer supported
- The [`js_include`](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_include) directive was removed, the [`js_import`](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_import) directive should be used instead
- The [`aio sendfile`](https://nginx.org/en/docs/http/ngx_http_core_module.html#aio) directive was removed, the [`sendfile`](https://nginx.org/en/docs/http/ngx_http_core_module.html#sendfile) directive should be used instead
- The third-party `Cookie‑Flag` was removed from the dynamic modules repository, the [`proxy_cookie_flags`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags) directive should be used instead
- Swagger UI with REST API YAML specification is not included into NGINX Plus packages by default any more and now is a part of [docs.nginx.com](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#the-swagger-ui)

More information: [Announcing NGINX Plus R26](https://www.nginx.com/blog/nginx-plus-r26-released/)

<span id="r26_p1"></span>
### NGINX Plus R26 Update

This is a bug‑fix release for NGINX Plus R26.

NGINX Plus R26 P1<br/>
_19 October 2022_

- In HLS ([CVE-2022-41743](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-41743)) and MP4 ([CVE-2022-41741](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-41741)) modules when processing specially crafted video files a memory corruption, or a memory disclosure in MP4 module ([CVE-2022-41742](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-41742)) could happen.

<span id="r25"></span>
## NGINX Plus Release 25 (R25)
_28 September 2021_<br/>
_Based on NGINX Open Source 1.21.3_

NGINX Plus R25 is a feature release:

- JWT authentication:

  - support for signed and then encrypted Nested JWT with the `nested` parameter of the [auth_jwt_type](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_type) directive

  - additional conditions for JWT validation can be specified with the [auth_jwt_require](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_require) directive

  - the [$jwt_payload](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#var_jwt_payload) variable that returns either enclosed JWS token for Nested JWT, or JSON with claims for JWE

  - now it is possible to have multiple [auth_jwt_key_file](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) and [auth_jwt_key_request](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) directives within the same context

  - asymmetric RSA-OAEP cryptographic algorithms for JWE

- API version 7: HTTP status code statistics are now collected per-code, in addition to aggregation per-class, for [upstreams](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_upstream), [server zones](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_server_zone), and [location zones](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_http_location_zone)

- Stream health checks: introduced the [persistent](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_persistent) parameter in the [health_check](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check) directive that enables persistence of mandatory health check status during configuration reload

- TCP Fast Open support with the `fastopen` parameter of the [listen](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) directive in the stream module

- Mail proxy:

  - the number of errors before closing the connection can be specified with the [max_errors](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#max_errors) directive to mitigate against ALPACA attack

  - support for POP3 and IMAP pipelining

  - the `Auth-SSL-Protocol` and `Auth-SSL-Cipher` header lines are now [passed](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#protocol) to the mail proxy authentication server


- Security hardening of HTTP request parsing. NGINX Plus will return an error if:

  - spaces or control characters are found in the request line, header names, or the `Host` request header line

  - the `CONNECT` method is used

  - both `Content-Length` and `Transfer-Encoding` header lines are present in the request

- Request body filters API now permits buffering of the data being processed.

- Support for dynamic SSL certificate loading for [http](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate), [grpc](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_certificate), and [uwsgi](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_certificate) backends


NGINX Plus R25 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                            |
|-----------------------------------|-------------------------------------|
| Alpine Linux                      | 3.11, 3.12, 3.13, 3.14              |
| Amazon Linux                      | 2 LTS                               |
| CentOS                            | 7.4+, 8.0+                          |
| Debian                            | 10, 11                              |
| FreeBSD                           | 12.1+, 13                           |
| Oracle Linux                      | 7.4+                                |
| RHEL                              | 7.4+, 8.0+                          |
| SUSE Linux Enterprise Server      | 12 SP5, 15 SP2                      |
| Ubuntu                            | 18.04 LTS, 20.04 LTS                |
{{</bootstrap-table>}}

**Notes:**

- Alpine 3.14 is new in this release
- Alpine 3.10 is no longer supported
- Amazon Linux (2018.03+) is no longer supported
- Debian 11 is new in this release
- FreeBSD 11.4+ is no longer supported
- Ubuntu 16.04 is no longer supported

More information: [Announcing NGINX Plus R25](https://www.nginx.com/blog/nginx-plus-r25-released/)

<span id="r25_p1"></span>
### NGINX Plus R25 Update

This is a bug‑fix release for NGINX Plus R25.

NGINX Plus R25 P1<br/>
_14 December 2021_

- Swagger UI updated to version 4.1.2
- Fixed a crash that might happen when an upstream server was updated via the API

<span id="r24"></span>
## NGINX Plus Release 24 (R24)
_27 April 2021_<br/>
_Based on NGINX Open Source 1.19.10_

NGINX Plus R24 is a feature release:

- Support for JSON Web Encryption added to the [JSON Web Token (JWT) module](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_type)

- HTTP health checks: introduced the [persistent](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check_persistent) parameter in the [health_check](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) directive that enables persistence to mandatory health checks after reload

- Flags in the [proxy_cookie_flags](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags) directive can now contain variables

- Support for [PROXY Protocol](https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt) in mail (the `proxy_protocol` parameter of the [listen](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#listen) directive, [proxy_protocol](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#proxy_protocol) and [set_real_ip_from](https://nginx.org/en/docs/mail/ngx_mail_realip_module.html#set_real_ip_from) directives)

- If free worker connections are exhausted, NGINX Plus starts closing not only keepalive connections, but also connections in [lingering_close](https://nginx.org/en/docs/http/ngx_http_core_module.html#lingering_close)

- The maximum duration of a persistent connection can be limited with the
`keepalive_time` directive for [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_time) and [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_time) servers

- New variable, [$connection_time](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_connection_time), that keeps connection time

NGINX Plus R24 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                 |
|-----------------------------------|------------------------------------------|
| Alpine Linux                      | 3.10, 3.11, 3.12, 3.13                   |
| Amazon Linux                      | 2018.03+, 2 LTS                          |
| CentOS                            | 7.4+, 8.0+                               |
| Debian                            | 10                                       |
| FreeBSD                           | 11.4+, 12.1+, 13                         |
| Oracle Linux                      | 7.4+                                     |
| RHEL                              | 7.4+, 8.0+                               |
| SUSE Linux Enterprise Server      | 12 SP5, 15 SP2                           |
| Ubuntu                            | 16.04 LTS, 18.04 LTS, 20.04 LTS         |
{{</bootstrap-table>}}

**Notes:**

- FreeBSD 13 is new in this release
- Alpine 3.13 is new in this release
- SUSE Linux Enterprise Server 15 SP2 is new in this release
- CentOS 7 (aarch64) is new in this release
- Amazon Linux 1 (2018) is deprecated
- Ubuntu 16.04 is deprecated
- Alpine Linux 3.10 is deprecated
- Debian 9 is no longer supported
- Amazon Linux 2 now depends on OpenSSL 1.1 package.

**Upgrade Note:**

NGINX Plus repositories have been separated into individual repositories based on operating system distribution and license subscription. Before upgrading from previous NGINX Plus versions, you must first reconfigure your repositories to point to the correct location. To reconfigure your repository, follow the [installation instructions](http://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/) for your operating system.

More information: [Announcing NGINX Plus R24](https://www.nginx.com/blog/nginx-plus-r24-released/)

<span id="r24_p1"></span>
### NGINX Plus R24 Updates
These are bug‑fix releases for NGINX Plus R24.

NGINX Plus R24 P1<br/>
_18 May 2021_

- Resolver: an [issue](https://support.f5.com/csp/article/K12331123) in NGINX resolver may allow an attacker who is able to forge UDP packets from the specified DNS server to cause a 1-byte memory overwrite, resulting in a worker process interruption or other unspecified impact ([CVE-2021-23017](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-23017))

NGINX Plus R24 P2<br/>
_14 December 2021_

- Swagger UI updated to version 4.1.2

<span id="r23"></span>
## NGINX Plus Release 23 (R23)
_8 December 2020_<br/>
_Based on NGINX Open Source 1.19.5_

NGINX Plus R23 is a feature release:

- gRPC health checks: introduced the [type=grpc](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check_grpc) parameter in the [health_check](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) directive that enables active health checks of gRPC upstream servers

- [Sticky cookie](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky) load-balancing method now can accept the [SameSite](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_samesite) attribute with `Strict`, `Lax`,or `None` values

- Support for cookie flags with the [proxy_cookie_flags](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags) and [userid_flags](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_flags) directives

- Introduced script that performs [unprivileged installation](https://docs.nginx.com/nginx/admin-guide/installing-nginx#unpriv_install) of NGINX Plus

- New command-line switch to redefine an error log file: [-e](https://nginx.org/en/docs/switches.html)

- New [set](https://nginx.org/en/docs/stream/ngx_stream_set_module.html#set) directive for stream that allows setting a value for a variable

- Added support for arbitrary [OpenSSL configuration commands](https://www.openssl.org/docs/man1.1.1/man3/SSL_CONF_cmd.html) with the [ssl_conf_command](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_conf_command) directive

- The [ssl_reject_handshake](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_reject_handshake) directive that allows rejecting the SSL handshake in the `server` block

- Support for [proxy_smtp_auth](http://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#proxy_smtp_auth) user authentication on the SMTP backend in mail proxy

- Cache manager improved to monitor the minimum amount of free space (the `min_free` parameter of the [proxy_cache_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive)

NGINX Plus R23 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                 |
|-----------------------------------|------------------------------------------|
| Alpine Linux                      | 3.10, 3.11, 3.12                         |
| Amazon Linux                      | 2018.03+, 2 LTS                          |
| CentOS                            | 7.4+, 8.0+                               |
| Debian                            | 9, 10                                    |
| FreeBSD                           | 11.4+, 12.1+                             |
| Oracle Linux                      | 7.4+                                     |
| RHEL                              | 7.4+, 8.0+                               |
| SUSE Linux Enterprise Server      | 12, 15                                   |
| Ubuntu                            | 16.04 LTS, 18.04 LTS, 20.04 LTS         |
{{</bootstrap-table>}}

**Notes:**

- Alpine 3.12 is new in this release
- Alpine 3.9 is no longer supported
- CentOS/RHEL 6.x is no longer supported
- Debian 10 (aarch64) is new in this release
- Ubuntu 19.10 is no longer supported

More information: [Announcing NGINX Plus R23](https://www.nginx.com/blog/nginx-plus-r23-released/)

<span id="r23_p1"></span>
### NGINX Plus R23 Update

This is a bug‑fix release for NGINX Plus R23.

NGINX Plus R23 P1<br/>
_18 May 2021_

- Resolver: an [issue](https://support.f5.com/csp/article/K12331123) in NGINX resolver may allow an attacker who is able to forge UDP packets from the specified DNS server to cause a 1-byte memory overwrite, resulting in a worker process interruption or other unspecified impact ([CVE-2021-23017](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-23017))

<span id="r22"></span>
## NGINX Plus Release 22 (R22)
_9 June 2020_<br/>
_Based on NGINX Open Source 1.19.0_

NGINX Plus R22 is a feature release:

- Client certificate OCSP validation
- Realtime [limit_conn](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html) and [limit_req](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) dashboard charts
- [Delay](https://nginx.org/en/docs/http/ngx_http_core_module.html#auth_delay) on authentication failure

NGINX Plus R22 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                        |
|-----------------------------------|-------------------------------------------------|
| Alpine Linux                      | 3.9, 3.10, 3.11                                 |
| Amazon Linux                      | 2018.03+, 2 LTS                                 |
| CentOS                            | 6.5+, 7.4+, 8.0+                                |
| Debian                            | 9, 10                                           |
| FreeBSD                           | 11.3+, 12.1+                                    |
| Oracle Linux                      | 6.5+, 7.4+                                      |
| RHEL                              | 6.5+, 7.4+, 8.0+                                |
| SUSE Linux Enterprise Server      | 12, 15                                          |
| Ubuntu                            | 16.04 LTS, 18.04 LTS, 19.10, 20.04 LTS          |
{{</bootstrap-table>}}

**Notes:**

- Alpine 3.8 is no longer supported

More information: [Announcing NGINX Plus R22](https://www.nginx.com/blog/nginx-plus-r22-released/)

<span id="r21"></span>
## NGINX Plus Release 21 (R21)
_7 April 2020_<br/>
_Based on NGINX Open Source 1.17.9_

NGINX Plus R21 is a feature release:

- Support for a variable parameter to the [grpc_pass](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_pass) directive enables dynamic gRPC routing

NGINX Plus R21 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                        |
|-----------------------------------|-------------------------------------------------|
| Alpine Linux                      | 3.8, 3.9, 3.10, 3.11                            |
| Amazon Linux                      | 2018.03+, 2 LTS                                 |
| CentOS                            | 6.5+, 7.4+, 8.0+                                |
| Debian                            | 9, 10                                           |
| FreeBSD                           | 11.2+, 12.0+                                    |
| Oracle Linux                      | 6.5+, 7.4+                                      |
| RHEL                              | 6.5+, 7.4+, 8.0+                                |
| SUSE Linux Enterprise Server      | 12, 15                                          |
| Ubuntu                            | 16.04 LTS, 18.04 LTS, 19.10, 20.04 LTS          |
{{</bootstrap-table>}}

**Notes:**

- Alpine 3.11 is new in this release
- Ubuntu 20.04 is new in this release
- Ubuntu 19.04 is no longer supported
- NGINX Plus is no longer available for 32‑bit (i386) platforms. Applies to:
  - CentOS/Oracle Linux/RHEL 6.5+ (x86_64 still supported)
  - Debian 9, 10 (x86_64 still supported)
  - Ubuntu 16.04 LTS  (x86_64, aarch64, ppc64le still supported)

More information: [Announcing NGINX Plus R21](https://www.nginx.com/blog/nginx-plus-r21-released/)

<span id="r20"></span>
## NGINX Plus Release 20 (R20)
_3 December 2019_<br/>
_Based on NGINX Open Source 1.17.6_

NGINX Plus R20 is a feature release:

- Enhancements to rate limiting: endpoint in NGINX Plus API for real‑time metrics, [$limit_req_status](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_status) variable captures request's rate‑limiting status in access log
- Enhancements to connection limiting: endpoint in NGINX Plus API for real‑time metrics, [$limit_conn_status](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_status) variable captures request's connection‑limiting status in access log, dry‑run mode with [limit_conn_dry_run](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_dry_run) directive
- Support in key‑value store for matching on start of character strings (new `type=prefix` parameter to [keyval_zone](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone) directive)
- Separate DNS resolution in each upstream group ([resolver](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive)
- PROXY Protocol variables capture IP address and port of original proxy server ([$proxy_protocol_server_{addr,port}](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_server_addr))
- Security improvements for HTTP/2: better detection of invalid client behavior, improved error responses, improved functioning of [proxy_request_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_request_buffering) and [worker_shutdown_timeout](https://nginx.org/en/docs/ngx_core_module.html#worker_shutdown_timeout) directives

NGINX Plus R20 R20 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                        |
|-----------------------------------|-------------------------------------------------|
| Alpine Linux                      | 3.8, 3.9, 3.10                                  |
| Amazon Linux                      | 2018.03+, 2 LTS                                 |
| CentOS                            | 6.5+, 7.4+, 8.0+                                |
| Debian                            | 9, 10                                           |
| FreeBSD                           | 11.2+, 12.0+                                    |
| Oracle Linux                      | 6.5+, 7.4+                                      |
| RHEL                              | 6.5+, 7.4+, 8.0+                                |
| SUSE Linux Enterprise Server      | 12, 15                                          |
| Ubuntu                            | 16.04 LTS, 18.04 LTS, 19.04, 19.10              |
{{</bootstrap-table>}}

**Notes:**

- CentOS 8.0+ is new in this release
- FreeBSD 12.1 is new in this release
- RHEL 8.1 is new in this release
- Ubuntu 19.10 is new in this release

More information: [Announcing NGINX Plus R20](https://www.nginx.com/blog/nginx-plus-r20-released/)

<span id="r19"></span>
## NGINX Plus Release 19 (R19)
_13 August 2019_<br/>
_Based on NGINX Open Source 1.17.3_

NGINX Plus R19 is a feature release:

- Metrics for individual [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) blocks (enabled by [status_zone](https://nginx.org/en/docs/http/ngx_http_status_module.html#status_zone) directive)
- Metrics about DNS resolver functionality (new `status_zone` parameter to [resolver](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive)
- Two new tabs on NGINX Plus live activity monitoring dashboard for metrics about DNS and clustering; per‑location metrics are also reported
- Dry‑run mode for testing effects of [request‑rate limits](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req) on production traffic without actually enforcing them (new [limit_req_dry_run](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_dry_run) directive)
- Support in key‑value store for IP address ranges in CIDR notation as well as individual addresses (new `type=ip` parameter to [keyval_zone](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone) directive)
- Expiration time can be set for each key‑value entry to override default expiration time, either at creation time for new entry or as a modification to existing entry
- The parameter to the [limit_rate](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate), [limit_rate_after](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate_after), [proxy_download_rate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_download_rate), and [proxy_upload_rate](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_upload_rate) directives can be a variable

NGINX Plus R19 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                        |
|-----------------------------------|-------------------------------------------------|
| Alpine Linux                      | 3.8, 3.9, 3.10                                  |
| Amazon Linux                      | 2018.03+, 2 LTS                                 |
| CentOS                            | 6.5+, 7.4+                                      |
| Debian                            | 9, 10                                           |
| FreeBSD                           | 11.2+, 12.0                                     |
| Oracle Linux                      | 6.5+, 7.4+                                      |
| RHEL                              | 6.5+, 7.4+, 8                                   |
| SUSE Linux Enterprise Server      | 12, 15                                          |
| Ubuntu                            | 16.04 LTS, 18.04 LTS, 19.04                     |
{{</bootstrap-table>}}

**Notes:**

- Alpine Linux 3.10 is new in this release
- Debian 8 is no longer supported
- Debian 10 is new in this release
- Ubuntu 14.04 LTS and 18.10 are no longer supported
- Ubuntu 19.04 is new in this release

More information: [Announcing NGINX Plus R19](https://www.nginx.com/blog/nginx-plus-r19-released/)

<span id="r18"></span>
## NGINX Plus Release 18 (R18)
_9 April 2019_<br/>
_Based on NGINX Open Source 1.15.10_

NGINX Plus R18 is a feature release:

- Dynamic SSL certificate loading, either from [file](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) or from [key-value](https://nginx.org/en/docs/http/ngx_http_keyval_module.html) storage (for the latter case, prefix the variable with `data:`)
- New features in [OpenID Connect reference implementation](https://github.com/nginxinc/nginx-openid-connect): opaque session tokens as a browser cookie, refresh tokens to refresh expired ID tokens without user interaction, and a logout URL
- Additional logic for verifying arbitrary variables in active health checks (new `require` parameter to [match](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#match) directive)
- Wildcard support for [listen](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) directive means same [zone_sync](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync) configuration can now be used for all instances in a cluster
- Port ranges supported for [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive
- For TCP/UDP, existing connections to proxied upstream server can be explicitly closed after server is removed from upstream group due to health check failure, API call, or re-resolve action (new [proxy_session_drop](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_session_drop) directive)
- New variable, [$upstream_bytes_sent](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#var_upstream_bytes_sent), contains number of bytes sent to an upstream server
- New or updated dynamic modules:
  - [Brotli](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/brotli/) (New): General‑purpose, lossless data compression algorithm
  - [OpenTracing](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/opentracing/) (New): Ability to instrument NGINX Plus with OpenTracing‑compliant requests for a range of distributed tracing services, such as Datadog, Jaeger, and Zipkin
  - [Lua](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/lua//) (Updated): Scripting language for NGINX Plus, updated to use LuaJIT 2.1
  - [NGINX JavaScript](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) (Updated): JavaScript module for NGINX Plus, updated to version [0.3.0](https://nginx.org/en/docs/njs/changes.html#njs0.3.0)

NGINX Plus R18 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                        |
|-----------------------------------|-------------------------------------------------|
| Alpine Linux                      | 3.8, 3.9                                        |
| Amazon Linux                      | 2018.03+, 2 LTS                                 |
| CentOS                            | 6.5+, 7.4+                                      |
| Debian                            | 8.0, 9.0                                        |
| FreeBSD                           | 11.2+, 12.0                                     |
| Oracle Linux                      | 6.5+, 7.4+                                      |
| RHEL                              | 6.5+, 7.4+, 8                                   |
| SUSE Linux Enterprise Server      | 12, 15                                          |
| Ubuntu                            | 14.04 LTS, 16.04 LTS, 18.04, 18.10              |
{{</bootstrap-table>}}

**Notes:**

- Amazon Linux 2017.09 is no longer supported; minimum supported version is now 2018.03
- CentOS/Oracle/Red Hat Enterprise Linux 7.3 is no longer supported; minimum supported version is now 7.4
- Debian 8.0 will be removed at NGINX Plus R19
- Ubuntu 14.04 will be removed at NGINX Plus R19

More information: [Announcing NGINX Plus R18](https://www.nginx.com/blog/nginx-plus-r18-released/)

### NGINX Plus R18 Update

This is a bug‑fix release for NGINX Plus R18.

NGINX Plus R18 P1<br/>
_6 August 2019_

- Security patch: When using HTTP/2 a client might cause excessive memory consumption and CPU usage ([CVE-2019-9511](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-9511), [CVE-2019-9513](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-9513), [CVE-2019-9516](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-9516))

<span id="r17"></span>
## NGINX Plus Release 17 (R17)
_11 December 2018_<br/>
_Based on NGINX Open Source 1.15.7_

NGINX Plus R17 is a feature release:

- Support for TLS 1.3 using `TLSv1.3` parameter to [ssl_protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) directive
- Two‑stage [rate limiting](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) with the new `delay=` parameter; excessive requests are initially delayed and then ultimately rejected
- Support for the Ed25519 and Ed448 cryptographic algorithms added to the [JSON Web Token (JWT) module](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html)
- Ability to fetch JSON Web Keys (JWK) directly from identity provider (IdP) when using OpenID Connect (new [auth_jwt_key_request](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request) directive)
- TCP keepalives between NGINX Plus and the proxied server (new [proxy_socket_keepalive](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_socket_keepalive) directive)
- Control over how long HTTP keepalive connection between NGINX Plus and proxied server can be idle before being closed (new [keepalive_timeout](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_timeout) directive)
- For UDP, number of packets sent from NGINX Plus to  proxied server before new UDP "session" to that server is started can be set explicitly (new [proxy_requests](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_requests) directive)
- [Zone Synchronization](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) module can now pass server name using SNI when connecting to cluster nodes for server name verification (new [zone_sync_ssl_server_name](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_server_name) directive)
- The NGINX JavaScript module has been updated:
  - Support for arguments objects
  - Support for non‑integer fractions
  - Support for additional time methods: `console.time()` and `console.timeEnd()`
  - Variables and functions can be redeclared
  - Integration with the NGINX Stream module for TCP/UDP applications has been refactored to use various return functions, including a `send()` method for modifying ingress trafficl egress traffic is now available through a callback

NGINX Plus R17 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                        |
|-----------------------------------|-------------------------------------------------|
| Alpine Linux                      | 3.8, 3.9                                        |
| Amazon Linux                      | 2017.09, 2 LTS                                  |
| CentOS                            | 6.5+, 7.0+                                      |
| Debian                            | 8.0, 9.0                                        |
| FreeBSD                           | 11.2+, 12.0                                     |
| Oracle Linux                      | 6.5+, 7.0+                                      |
| RHEL                              | 6.5+, 7.0+                                      |
| SUSE Linux Enterprise Server      | 12, 15                                          |
| Ubuntu                            | 14.04 LTS, 16.04 LTS, 18.04, 18.10              |
{{</bootstrap-table>}}

**Notes:**

- Alpine Linux 3.8 and 3.9 are new in this release
- CentOS/Oracle Linux/RHEL 7.3 will be removed at NGINX Plus R18
- FreeBSD 11.2 and 12.0 are new in this release; versions 10.4 and 11.1 are no longer supported
- Ubuntu 14.04 will be removed at NGINX Plus R19
- Ubuntu 18.10 is new in this release

More information: [Announcing NGINX Plus R17](https://www.nginx.com/blog/nginx-plus-r17-released/)

<span id="r16"></span>
## NGINX Plus Release 16 (R16)
_5 September 2018_<br/>
_Based on NGINX Open Source 1.15.2_

NGINX Plus R16 is a feature release:

- [Rate limiting](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) in a cluster using [Zone Synchronization](https://www.nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) module
- [Key-value store](https://nginx.org/en/docs/http/ngx_http_keyval_module.html) in a cluster using [Zone Synchronization](https://www.nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) module
- Timeouts in [Key-Value Store](https://nginx.org/en/docs/http/ngx_http_keyval_module.html) module
- New [random](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#random) load‑balancing algorithm with Random with Two Choices variant, for which [least_time](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_time) or [least_conn](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_conn) can be used to decide between the two choices
- UDP load balancing ([stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) module) enhanced with support for multiple UDP packets from the client, enabling use of more complex UDP protocols such as OpenVPN, VoIP, and VDI
- Support for [PROXY Protocol v2 (PPv2) header](https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt), and ability to inspect custom TLV values in header
- Support for [AWS PrivateLink](https://aws.amazon.com/privatelink/), Amazon's technology for creating secure tunnels into a VPC
- opaque session token support in the [OpenID Connect reference implementation](https://github.com/nginxinc/nginx-openid-connect)
- New [$ssl_preread_protocol](https://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html#var_ssl_preread_protocol) variable to distinguish between SSL/TLS and other protocols when forwarding traffic using a TCP ([stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html)) proxy
- New [Encrypted Session](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/encrypted-session/) dynamic module
- The NGINX JavaScript module has been updated:
  - Single object (`r`) is used to access both request and response attributes associated with each HTTP request
  - New language support: `bytesFrom()`, `padStart()`, `padEnd()`, `getrandom()`, `getentropy()`, and binary literals

NGINX Plus R16 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                       |
|-----------------------------------|------------------------------------------------|
| Amazon Linux                      | 2017.09, 2 LTS                                 |
| CentOS                            | 6.5+, 7.0+                                     |
| Debian                            | 8.0, 9.0                                       |
| FreeBSD                           | 10.4+, 11.1+                                   |
| Oracle Linux                      | 6.5+, 7.0+                                     |
| RHEL                              | 6.5+, 7.0+                                     |
| SUSE Linux Enterprise Server      | 12                                             |
| Ubuntu                            | 14.04 LTS, 16.04 LTS, 18.04                    |
{{</bootstrap-table>}}

**Notes:**

- FreeBSD 10.4+ and 11.1+ are new in this release; versions 10.3 and 11.0 are no longer supported
- Amazon Linux 2 (LTS) is updated to the GA version.
- Ubuntu 17.10 is no longer supported
- The Upstream Conf and Extended Status modules are superseded by the [NGINX Plus API](https://nginx.org/en/docs/http/ngx_http_api_module.html) module and are no longer distributed in NGINX Plus (see our [transition guide](https://www.nginx.com/blog/transitioning-to-nginx-plus-api-configuration-monitoring/) for details)
- The [New Relic plug‑in](https://newrelic.com/integrations/nginx) for NGINX has been updated to use the new NGINX Plus API, but is no longer supported by NGINX, Inc.

More information: [Announcing NGINX Plus R16](https://www.nginx.com/blog/nginx-plus-r16-released/)

### NGINX Plus R16 Update

This is a bug‑fix release for NGINX Plus R16.

NGINX Plus R16 P1<br/>
_30 October 2018_

- Security patch: When using HTTP/2 a client might cause excessive memory consumption ([CVE-2018-16843](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-16843)) and CPU usage ([CVE-2018-16844](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-16844))
- Security patch: Processing of a specially crafted MP4 file with the ngx\_http\_mp4\_module might result in worker process memory disclosure ([CVE-2018-16845](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-16845))

<span id="r15"></span>
## NGINX Plus Release 15 (R15)
_10 April 2018_<br/>
_Based on NGINX Open Source 1.13.10_

NGINX Plus R15 is a feature release:

- Proxying, load balancing, and SSL-termination of gRPC traffic
- HTTP/2 server push
- Sticky learn session persistence in a cluster using new [Zone Synchronization](https://www.nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) module, which synchronizes [shared memory zones](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) across a cluster of NGINX Plus instances
- [OpenID Connect (OIDC) authorization code flow](https://github.com/nginxinc/nginx-openid-connect), enabling integration with CA Single Sign-On (formerly SiteMinder), ForgeRock OpenAM, Keycloak, Okta, and other identity providers
- Subrequests from the [NGINX JavaScript](https://www.nginx.com/blog/introduction-nginscript/) module
- Crypto libraries in NGINX JavaScript module with support for common hash functions MD5, SHA-1, and SHA-256
- Inheritance of the `CAP_NET_RAW` Linux capability so that transparent proxying does not require worker processes to have root privileges
- New [auth_jwt_leeway](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_leeway) directive to compensate for clock skew between NGINX Plus and identity provider
- Performance enhancements and bug fixes to [NGINX WAF](https://www.nginx.com/products/nginx-waf/) module
- Updates to [LDAP authentication reference implementation](https://github.com/nginxinc/nginx-ldap-auth)
- New [$upstream_queue_time](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#var_upstream_queue_time) variable to hold the amount of time a request spends in the [upstream queue](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#queue)
- New [$ssl_preread_alpn_protocols](https://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html#var_ssl_preread_alpn_protocols) variable to hold the Application Layer Protocol Negotiation (ALPN) protocols presented by client
- New [Cookie-Flag](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/cookie-flag/) dynamic module

NGINX Plus R15 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                       |
|-----------------------------------|------------------------------------------------|
| Amazon Linux                      | 2017.09, 2 LTS                                 |
| CentOS                            | 6.5+, 7.0+                                     |
| Debian                            | 8.0, 9.0                                       |
| FreeBSD                           | 10.3, 11.0                                     |
| Oracle Linux                      | 6.5+, 7.0+                                     |
| RHEL                              | 6.5+, 7.0+                                     |
| SUSE Linux Enterprise Server      | 12                                             |
| Ubuntu                            | 14.04 LTS, 16.04 LTS, 17.10, 18.04             |
{{</bootstrap-table>}}

**Notes:**

- Ubuntu 17.04 is no longer supported
- nginScript is now known as the NGINX JavaScript module
- The NGINX Plus API version has been incremented to 3; all previous versions of the NGINX Plus API are still supported
- This is the last release to support the deprecated dynamic (on-the-fly) reconfiguration and extended status APIs (see our [transition guide](https://www.nginx.com/blog/transitioning-to-nginx-plus-api-configuration-monitoring/) for details)

More information: [Announcing NGINX Plus R15](https://www.nginx.com/blog/nginx-plus-r15-released/)

### NGINX Plus R15 Updates

These are bug‑fix releases for NGINX Plus R15.

NGINX Plus R15 P2<br/>
_30 October 2018_

- Security patch: When using HTTP/2 a client might cause excessive memory consumption ([CVE-2018-16843](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-16843)) and CPU usage ([CVE-2018-16844](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-16844))
- Security patch: Processing of a specially crafted mp4 file with the ngx_http_mp4_module might result in worker process memory disclosure ([CVE-2018-16845](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-16845))

NGINX Plus R15 P1<br/>
_12 April 2018_

- Third‑party modules might not be loaded due to signature incompatibility

<span id="r14"></span>
## NGINX Plus Release 14 (R14)
_12 December 2017_
_NGINX Open Source build 1.13.7_

NGINX Plus R14 is a feature release:

- Nested JSON Web Token (JWT) claims, array data, and longer key sizes (256‑, 384‑, and 512‑bit) for JWT signing algorithms, providing more flexibility and security when validating JWTs
- Clustering support for the [sticky_learn](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_learn) method of session persistence, as a technology preview of distribution of session state data in a cluster
- [Key‑value store](https://nginx.org/en/docs//http/ngx_http_keyval_module.html) and NGINX Plus API in the `stream` context, making the same key‑value store features are available for TCP/UDP applications as for HTTP applications
- New NGINX Plus [dashboard](https://demo.nginx.com/) utilizing the NGINX Plus API which was introduced in [NGINX Plus R13](#r13)
- Improvements to [NGINX JavaScript](https://www.nginx.com/blog/introduction-nginscript/) module, including the ability to manage JSON objects, read content from filesystems, and backtrace to errors and exceptions to further improve troubleshooting
- Ability to encode client certificates in a HTTP header and send them to backend applications with the [$ssl_client_escaped_cert](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#variables) variable
- Enhanced DNS resolver that preserves the list of upstream IP addresses across a reload of the NGINX Plus configuration
- Ability to drain upstream servers extended to file‑based configurations with the [drain](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) parameter to the upstream `server` directive

</ul>

NGINX Plus R14 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution                    | Versions                                       |
|-----------------------------------|------------------------------------------------|
| Amazon Linux                      | 2016.09, 2 (2017.12)                           |
| CentOS                            | 6.5+, 7.0+                                     |
| Debian                            | 8.0, 9.0                                       |
| FreeBSD                           | 10.3, 11.0                                     |
| Oracle Linux                      | 6.5+, 7.0+                                     |
| RHEL                              | 6.5+, 7.0+                                     |
| SUSE Linux Enterprise Server      | 12                                             |
| Ubuntu                            | 14.04 LTS, 16.04 LTS, 17.04, 17.10             |
{{</bootstrap-table>}}

**Notes:**

- Debian 7.0 is no longer supported
- Ubuntu 17.10 is new in this release
- The Upstream Conf and Extended Status APIs were deprecated in [NGINX Plus R13](#r13); support will continue only through NGINX Plus R15 (see our [transition guide](https://www.nginx.com/blog/transitioning-to-nginx-plus-api-configuration-monitoring/) for details)

More information: [Announcing NGINX Plus R14](https://www.nginx.com/blog/nginx-plus-r14-released/)

### NGINX Plus R14 Updates

This is a bug‑fix release for NGINX Plus R14.

NGINX Plus R14 P1<br/>
_25 January 2018_

- Live activity monitoring: Reinstated some missing tooltips for the dashboard
- NGINX Plus API: HTTP Basic Authentication support for read‑write mode

<span id="r13"></span>
## NGINX Plus Release 13 (R13)
_29 August 2017_<br/>
_Based on NGINX Open Source 1.13.4_

NGINX Plus R13 is a feature release:

- Ability to send duplicate all incoming traffic to a dedicated server (the [mirror](https://nginx.org/en/docs/http/ngx_http_mirror_module.html#mirror) directive)
- Improvements to [NGINX JavaScript](https://www.nginx.com/blog/introduction-nginscript/) module, including the new interactive shell to facilitate development of NGINX JavaScript code
- New [NGINX Plus API](https://nginx.org/en/docs/http/ngx_http_api_module.html) that incorporates the functionality of the previous [upstream_conf](https://nginx.org/en/docs/http/ngx_http_upstream_conf_module.html) and [(extended) status](https://nginx.org/en/docs/http/ngx_http_status_module.html) APIs; it includes a [Swagger](https://demo.nginx.com/swagger-ui/) specification and adds support for [key‑value stores](https://nginx.org/en/docs//http/ngx_http_keyval_module.html)
- New build tool ([download here](https://hg.nginx.org/pkg-oss/raw-file/default/build_module.sh)) that creates installable packages of the many third‑party modules available for NGINX and NGINX Plus
- Ability to gracefully shut down all live client connections when restarting NGINX Plus (the [worker_shutdown_timeout](https://nginx.org/en/docs/ngx_core_module.html#worker_shutdown_timeout) directive)
- Support for adding HTTP trailers (the [add_trailer](https://nginx.org/en/docs/http/ngx_http_headers_module.html#add_trailer) directive)
- Improvement to session persistence: quicker establishment of sticky sessions between clients and upstream groups (the `header` parameter to the [sticky learn](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky) directive)
- Support for the third‑party [HTTP Substitutions Filter](https://github.com/yaoweibin/ngx_http_substitutions_filter_module) module, distributed in NGINX Plus packages and available on the [Dynamic Modules](https://www.nginx.com/products/modules/) page

NGINX Plus R13 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                |
|------------------------|------------------------------------------|
| Amazon Linux           | 2016.09+                                 |
| CentOS                 | 6.5+, 7.0+                               |
| Debian                 | 7.0, 8.0, 9.0                            |
| FreeBSD                | 10.3, 11.0                               |
| Oracle Linux           | 6.5+, 7.0+                               |
| RHEL                   | 6.5+, 7.0+                               |
| Ubuntu                 | 14.04 LTS, 16.04 LTS, 17.04              |
{{</bootstrap-table>}}

**Notes:**

- CentOS/Oracle Linux/RHEL 5.10+ is no longer supported
- Ubuntu 12.04 LTS and 16.10 are no longer supported
- Ubuntu 17.04 is new in this release
- The `sticky_cookie_insert` directive (deprecated in [NGINX Plus R2](#r2)) has been removed
- The [upstream_conf](https://nginx.org/en/docs/http/ngx_http_upstream_conf_module.html) and [(extended) status](https://nginx.org/en/docs/http/ngx_http_status_module.html) APIs are deprecated by the new [NGINX Plus API](https://nginx.org/en/docs/http/ngx_http_api_module.html) and will be removed in a future release

More information: [Announcing NGINX Plus R13](https://www.nginx.com/blog/nginx-plus-r13-released)

<span id="r12"></span>
## NGINX Plus Release 12 (R12)
_14 March 2017_<br/>
_Based on NGINX Open Source 1.11.10_

NGINX Plus R12 is a feature release:

- Synchronization of NGINX Plus configuration across instances in a cluster, from a single primary node (new `nginx_sync` package)
- Updates to Extended Status module [data set](https://nginx.org/en/docs/http/ngx_http_status_module.html#data), including NGINX Plus version (`nginx_build`), usage statistics for shared memory zones (under the `slabs/` subtree), and additional upstream fields (`name`, `service`)
- New statistics displayed on [live activity monitoring dashboard](http://demo.nginx.com/): NGINX Plus version, response time metrics, shared memory zones usage, and server names for upstreams
- [Support](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_use_stale) for the `stale-while-revalidate` and `stale-if-error` extensions to the `Cache-Control` header, as defined by [RFC 5861](https://www.ietf.org/rfc/rfc5861.txt)
- Ability to bypass cache for byte range requests after a specified offset (the [proxy_cache_max_range_offset](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_max_range_offset) directive)
- Length of `Vary` and `ETag` cache headers increased to 128 bytes; note that the on‑disk cache format has changed, so cached content is invalidated after the upgrade and must be refreshed from the origin server
- `mandatory` parameter to the `health_check` directive ([HTTP](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) and [Stream](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check)) which requires servers newly added to an `upstream` group to pass the associated health check before receiving real traffic
- “Zero config” UDP [health check](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check) which does not require specifying a [match](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match) block
- Support in the Stream module for verification of [client SSL certificates](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_verify_client) for TCP applications
- [SSL variables](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#variables) representing various details about client certificates and capabilities (`$ssl_ciphers`, `$ssl_client_v_end`, `$ssl_client_v_start`, `$ssl_client_v_remain`, and `$ssl_curves`)
- The `$ssl_client_verify` variable includes the reason for failure
- The `$ssl_client_i_dn` and `ssl_client_s_dn` variables comply with [RFC 2253](https://www.ietf.org/rfc/rfc2253.txt); legacy variants are available as `$ssl_client_i_dn_legacy` and `$ssl_client_s_dn_legacy`
- Support for accessing arbitrary JWT fields as [variables](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html)
- Support for JSON escaping in access logs (the `escape` parameter to the [log_format](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) directive)
- WebP support in the [Image-Filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html) module.
- Output from the `nginx` `-T` command excludes duplicated sections of configuration
- Improvements to memory usage and performance, including upstream [queue](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#queue) optimization

NGINX Plus R12 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                             |
|------------------------|------------------------------------------------------|
| Amazon Linux           | 2016.09+                                             |
| CentOS                 | 5.10+, 6.5+, 7.0+                                    |
| Debian                 | 7.0, 8.0, 9.0                                        |
| FreeBSD                | 10.3, 11.0                                           |
| Oracle Linux           | 5.10+, 6.5+, 7.0+                                    |
| RHEL                   | 5.10+, 6.5+, 7.0+                                    |
| SLES                   | 12, 12 SP1                                           |
| Ubuntu                 | 12.04 LTS, 14.04 LTS, 16.04 LTS, 16.10               |
{{</bootstrap-table>}}

**Notes:**

- CentOS/Oracle Linux/RHEL 5.10+ will be removed at NGINX Plus R13
- Debian 9 is new in this release
- FreeBSD 9 is no longer supported
- Ubuntu 12.04 LTS will be removed at NGINX Plus R13

More information: [Announcing NGINX Plus R12](https://www.nginx.com/blog/nginx-plus-r12-released/)

### NGINX Plus R12 Updates

These are bug‑fix releases for NGINX Plus R12.

NGINX Plus R12 P3<br/>
_29 June 2017_

- Content caching: Cache response might contain additional internal cache header data

NGINX Plus R12 P2<br/>
_30 March 2017_

- Live activity monitoring: Response time metric was miscalculated under certain conditions

NGINX Plus R12 P1<br/>
_14 March 2017_

- Live activity monitoring: Dashboard might hang with certain configurations

<span id="r11"></span>
## NGINX Plus Release 11 (R11)
_25 October 2016_<br/>
_Based on NGINX Open Source 1.11.5_

NGINX Plus R11 is a feature release:

- Dynamic modules binary compatibility between NGINX Plus and the corresponding version of open source NGINX
- Enhancements to the Stream module: custom [logging](https://nginx.org/en/docs/stream/ngx_stream_log_module.html) with a number of additional [variables](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#variables), [PROXY protocol support](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) for incoming connections, support for [obtaining](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html) real IP address and port from PROXY protocol header, and ability to [extract the server name](https://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html) from SNI into a variable for purposes such as custom routing
- Updates to the Extended Status module [data set](https://nginx.org/en/docs/http/ngx_http_status_module.html#data), including additional Stream metrics (`sessions`, `discarded`)
- Cache manager support for iterative operations mode when deleting old cache files, reducing the disk load (see the `manager_files`, `manager_threshold`, and `manager_sleep` parameters of the [proxy_cache_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive)
- Support for variables in the `domain` parameter to the [sticky](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky) directive
- New variable `$upstream_bytes_received` for both [Stream](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#var_upstream_bytes_received) and [HTTP](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#var_upstream_bytes_received))

NGINX Plus R11 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                             |
|------------------------|------------------------------------------------------|
| Amazon Linux           | 2016.03+                                             |
| CentOS                 | 5.10+, 6.5+, 7.0+                                    |
| Debian                 | 7.0, 8.0                                             |
| FreeBSD                | 9.3, 10.1+, 11.0                                     |
| Oracle Linux           | 5.10+, 6.5+, 7.0+                                    |
| RHEL                   | 5.10+, 6.5+, 7.0+                                    |
| SLES                   | 12, 12 SP1                                           |
| Ubuntu                 | 12.04 LTS, 14.04 LTS, 16.04 LTS, 16.10               |
{{</bootstrap-table>}}

**Notes:**

- FreeBSD 11.0 is new in this release
- Ubuntu 16.10 is new in this release
- The `nginx-plus-extras` package is no longer provided; migrate to the `nginx-plus` package and then install the needed [dynamic modules](https://www.nginx.com/products/dynamic-modules)

More information: [Announcing NGINX Plus R11](https://www.nginx.com/blog/nginx-plus-r11-released/)

<span id="r10"></span>
## NGINX Plus Release 10 (R10)
_23 August 2016_<br/>
_Based on NGINX Open Source 1.11.3_

NGINX Plus R10 is a feature release:

- New dynamic module: [ModSecurity](https://www.nginx.com/waf) (package name is `nginx-plus-module-modsecurity`) built on an early release of ModSecurity 3.0
- New dynamic module: nginScript (package name is `nginx-plus-module-njs`)
- Support for client authentication using [JSON Web Tokens (JWT)](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html)
- Enhancements to the [Stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) module used for TCP/UDP load balancing (more [NGINX variables](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#variables), [resolver](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#resolver) support, [map](https://nginx.org/en/docs/stream/ngx_stream_map_module.html) module, [geo](https://nginx.org/en/docs/stream/ngx_stream_geo_module.html) module, [geoip](https://nginx.org/en/docs/stream/ngx_stream_geoip_module.html) module, and [split_clients](https://nginx.org/en/docs/stream/ngx_stream_split_clients_module.html) A/B testing support)
- Support for dual‑stack RSA/ECC certificates by defining multiple [ssl_certificate](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) and [ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key) directives on the same virtual server
- Support for IP Transparency and Direct Server Return (DSR) using the `transparent` parameter to the [proxy_bind](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_bind) directive. DSR only supported for UDP load balancing.
- Support for the `IP_BIND_ADDRESS_NO_PORT` socket option where available, allowing for many more upstream connections (requires Linux kernel 4.2 or later)
- HTTP/2 improvements: support for unbuffered upload,and various bug fixes
- New NGINX variables: [$request_id](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_request_id), [$proxy_protocol_port](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_proxy_protocol_port), [$realip_remote_port](https://nginx.org/en/docs/http/ngx_http_realip_module.html#var_realip_remote_port)
- Modules updated (both in `nginx-plus-extras` and as dynamic modules):

  - [Headers-More](http://github.com/openresty/headers-more-nginx-module) module updated to version 0.31
  - [Lua](http://github.com/openresty/lua-nginx-module) module updated to version 0.10.6
  - [Phusion Passenger Open Source](https://blog.phusion.nl/tag/passenger-releases/) module updated to version 5.0.30
  - [Set-Misc](http://github.com/openresty/set-misc-nginx-module) module updated to version 0.31

NGINX Plus R10 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                             |
|------------------------|------------------------------------------------------|
| Amazon Linux           | 2016.03+                                             |
| CentOS                 | 5.10+, 6.5+, 7.0+                                    |
| Debian                 | 7.0, 8.0                                             |
| FreeBSD                | 9.3, 10.1+                                           |
| Oracle Linux           | 5.10+, 6.5+, 7.0+                                    |
| RHEL                   | 5.10+, 6.5+, 7.0+                                    |
| SLES                   | 12, 12 SP1                                           |
| Ubuntu                 | 12.04 LTS, 14.04 LTS, 16.04 LTS                      |
{{</bootstrap-table>}}

**Notes:**

- Ubuntu 15.10 is no longer supported
- NGINX Plus R10 is the last release to include the `nginx-plus-extras` package; if using this package, migrate to the `nginx-plus` package and then install the needed [dynamic modules](https://www.nginx.com/products/dynamic-modules)

More information: [Announcing NGINX Plus R10](https://www.nginx.com/blog/nginx-plus-r10-released/)

<span id="r9"></span>
## NGINX Plus Release 9 (R9)
_12 April 2016_<br/>
_Based on NGINX Open Source 1.9.13_

NGINX Plus R9 is a feature release:

- Dynamic loading of modules (both NGINX‑authored and third‑party). The NGINX‑authored modules supported in this release:
  - [nginx-plus-module-geoip](https://nginx.org/en/docs/http/ngx_http_geoip_module.html)
  - [nginx-plus-module-image-filter](https://nginx.org/en/docs/http/ngx_http_image_filter_module.html)
  - [nginx-plus-module-perl](https://nginx.org/en/docs/http/ngx_http_perl_module.html)
  - [nginx-plus-module-xslt](https://nginx.org/en/docs/http/ngx_http_xslt_module.html)

  The third‑party modules supported in this release:

  - [nginx-plus-module-headers-more](https://github.com/openresty/headers-more-nginx-module)
  - [nginx-plus-module-lua](https://github.com/openresty/lua-nginx-module)
  - [nginx-plus-module-passenger](https://www.phusionpassenger.com/)
  - [nginx-plus-module-rtmp](https://github.com/arut/nginx-rtmp-module)
  - [nginx-plus-module-set-misc](https://github.com/openresty/set-misc-nginx-module)

- UDP load balancing support, configured in the [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) configuration context
- Support for retrieving upstream servers configuration via DNS `SRV` records, configured with the new `service` parameter to the [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) directive
- Automatic retrying of DNS requests over TCP when UDP responses are truncated
- Failed nonidempotent HTTP requests (`POST`, `LOCK`, `PATCH`) are no longer retried with the other servers in the `upstream` group, unless the `non_idempotent` parameter is included in the [proxy_next_upstream](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream) directive
- Improved cache metadata accounting
- Automatic binding of worker processes to available CPUs using the new `auto` parameter of the [worker_cpu_affinity](https://nginx.org/en/docs/ngx_core_module.html#worker_cpu_affinity) directive
- Optional offloading of some cache write operations to thread pools, configured with the [aio_write on](https://nginx.org/en/docs/http/ngx_http_core_module.html#aio_write) directive
- Support for customizing the `Server` response header, as well as the signature in standard error messages
- Updated live activity monitoring dashboard
- In the `nginx-plus-extras` package:
  - [Headers-More](http://github.com/openresty/headers-more-nginx-module) module updated to version  .29
  - [Lua](http://github.com/openresty/lua-nginx-module) module updated to version 0.10.2
  - [Phusion Passenger Open Source](https://blog.phusion.nl/tag/passenger-releases/) module updated to version 5.0.26

NGINX Plus R9 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                             |
|------------------------|------------------------------------------------------|
| Amazon Linux           | 2016.03+                                             |
| CentOS                 | 5.10+, 6.5+, 7.0+                                    |
| Debian                 | 7.0, 8.0                                             |
| FreeBSD                | 9.3, 10.1+                                           |
| Oracle Linux           | 5.10+, 6.5+, 7.0+                                    |
| RHEL                   | 5.10+, 6.5+, 7.0+                                    |
| SLES                   | 12, 12 SP1                                           |
| Ubuntu                 | 12.04 LTS, 14.04 LTS, 15.10, 16.04 LTS               |
{{</bootstrap-table>}}

**Note:**

- Ubuntu 15.04 is no longer supported.

More information: [Announcing NGINX Plus R9](https://www.nginx.com/blog/nginx-plus-r9-released/)

### NGINX Plus R9 Updates

This is a bug‑fix release for NGINX Plus R9.

NGINX Plus R9 P1<br/>
_25 May 2016_

- Segmentation fault might occur when writing a client request body to a temporary file
- Specially crafted request might cause NGINX worker process to crash due to a NULL pointer dereference ([CVE-2016-4450](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-4450))

<span id="r8"></span>
## NGINX Plus Release 8 (R8)
_19 January 2016_<br/>
_Based on NGINX Open Source 1.9.9_

NGINX Plus R8 is a feature release:

- [OAuth Technology Preview](https://www.nginx.com/blog/oauth-technology-preview/), which performs OAuth 2.0 processing for proxied applications
- Improved [HTTP/2](https://nginx.org/en/docs/http/ngx_http_v2_module.html) implementation now included in the `nginx-plus` and `nginx-plus-extras` packages; the `nginx-plus-http2` package is deprecated
- Caching improvements, including support for caching [HEAD](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_convert_head) requests and more effective caching of large files with the [Cache Slice](https://nginx.org/en/docs/http/ngx_http_slice_module.html) module
- Changes to upstream groups made with the [on‑the‑fly reconfiguration API](https://nginx.org/en/docs/http/ngx_http_upstream_conf_module.html) can now be configured to [persist](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#state) across restarts and configuration reloads
- Support for sending health check requests to a specified port (the `port` parameter to the [health_check](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) directive)
- Enhancement to the [Real IP](https://nginx.org/en/docs/http/ngx_http_realip_module.html) module: the new `$realip_remote_addr` variable represents the original client IP address
- Enhancement to [syslog](https://nginx.org/en/docs/syslog.html) logging: the `nohostname` parameter disables logging of the hostname field, which is unnecessary when logging to a local `syslog` server
- Updated live activity monitoring dashboard
- In the `nginx-plus-extras` package:
  - [Headers-More](https://github.com/openresty/headers-more-nginx-module) module updated to version 0.28
  - [Lua](https://github.com/openresty/lua-nginx-module) module updated to version 0.9.20
  - [Phusion Passenger Open Source](https://blog.phusion.nl/tag/passenger-releases/) module updated to version 5.0.22
  - [Redis](https://github.com/openresty/lua-resty-redis) module for Lua access updated to version 0.21

NGINX Plus R8 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                             |
|------------------------|------------------------------------------------------|
| Amazon Linux           |                                                     |
| CentOS                 | 5.10+, 6.5+, 7.0                                     |
| Debian                 | 7.0, 8.0                                             |
| FreeBSD                | 9.3, 10.1+                                           |
| Oracle Linux           | 5.10+, 6.5+, 7.0                                     |
| RHEL                   | 5.10+, 6.5+, 7.0                                     |
| SLES                   | 12, 12 SP1                                           |
| Ubuntu                 | 12.04 LTS, 14.04 LTS, 15.04, 15.10                   |
{{</bootstrap-table>}}

NGINX Plus R8 does not include the `nginx-plus-lua` package; if you previously used this package, migrate to the `nginx-plus-extras` package

More information: [Announcing NGINX Plus R8](https://www.nginx.com/blog/nginx-plus-r8-released/)

### NGINX Plus R8 Updates

These are bug‑fix releases for NGINX Plus R8.

NGINX Plus R8 P3<br/>
_24 February 2016_

- HTTP/2: `client_body_timeout` directive was not handled correctly

NGINX Plus R8 P2<br/>
_11 February 2016_

- Logging: Buffer over‑read might occur while logging invalid request headers
- HTTP/2: Various fixes

NGINX Plus R8 P1<br/>
_26 January 2016_

- Resolver: Limit `CNAME` resolutions to prevent remote attackers from causing a denial of service ([CVE-2016-0747](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-0747))

<span id="r7"></span>
## NGINX Plus Release 7 (R7)
_15 September 2015_<br/>
_Based on NGINX Open Source 1.9.4_

NGINX Plus R7 is a feature release:

- Support for HTTP/2 in the new `nginx-plus-http2`package (the `nginx-plus` and `nginx-plus-extras` packages continue to support SPDY)

    **Note:** Before installing the `nginx-plus-http2` package, you must remove the `spdy` parameter on all `listen` directives in your configuration (replace it with the `http2` and `ssl` parameters to enable support for HTTP/2). NGINX Plus fails to start if any `listen` directives have the `spdy` parameter.

- Support for proxying [NTLM](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ntlm) requests
- Enhancements to [TCP load balancing](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) and proxying:
  - [Access controls](https://nginx.org/en/docs/stream/ngx_stream_access_module.html)
  - [Connection limiting](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html)
  - Bandwidth limiting for [upload](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_upload_rate) and [download](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_download_rate)
  - Client‑side [PROXY protocol](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_protocol) support
  - Ability to [set local IP address](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_bind) of origin for outgoing connections
  - New `backlog` parameter to [listen](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) directive to limit size of queue of pending connections
  - New [tcp_nodelay](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#tcp_nodelay) directive to control use of OS `TCP_NODELAY` option
- More efficient distribution of connections across NGINX Plus worker processes (new `reuseport` parameter to the [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive)
- [Thread pools](https://nginx.org/en/docs/ngx_core_module.html#thread_pool) for multithreaded reading and sending of files without blocking worker processes
- Live activity monitoring dashboard redesigned to use tabs
- Additional live activity monitoring metrics in the [Status](https://nginx.org/en/docs/http/ngx_http_status_module.html#compatibility) module (dataset version 6)
- Additional arguments to playlist and fragment URIs in the [HLS](https://nginx.org/en/docs/http/ngx_http_hls_module.html) module (`start`, `end`, and `offset`)
- New `-T` flag on `nginx` command to dump the configuration to standard output in a standardized format
- New [$upstream_connect_time](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#var_upstream_connect_time) variable to capture the connection time to upstream servers
- [sub_filter](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter) directive now supports variables in both the string being replaced and the replacement string; multiple `sub_filter` directives can appear at a configuration level
- In the `nginx-plus-extras` package:
  - New [Redis](http://github.com/openresty/lua-resty-redis) module for access to Redis databases through Lua
  - [Headers-More](http://github.com/openresty/headers-more-nginx-module) module updated to version 0.26
  - [Lua](http://github.com/openresty/lua-nginx-module) module updated to version 0.9.16
  - [Phusion Passenger Open Source](https://blog.phusion.nl/tag/passenger-releases/) module updated to version 5.0.15
  - [Set-Misc](http://github.com/openresty/set-misc-nginx-module) module updated to version 0.29

NGINX Plus R7 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                  |
|------------------------|-------------------------------------------|
| CentOS                 | 5.10+, 6.5+, 7.0+                         |
| Debian                 | 7.0, 8.0                                 |
| FreeBSD                | 9.3, 10.1+                               |
| Oracle Linux           | 5.10+, 6.5+, 7.0+                         |
| RHEL                   | 5.10+, 6.5+, 7.0+                         |
| SLES                   | 12                                       |
| Ubuntu                 | 12.04 LTS, 14.04 LTS, 15.04               |
{{</bootstrap-table>}}

**Notes:**

- Debian 6.0 is no longer supported
- SLES 11 SP3 is no longer supported
- Ubuntu 10.04 LTS and 14.10 are no longer supported
- The `nginx-plus-extras` package has additional dependencies
- NGINX Plus R7 is the last release that includes the `nginx-plus-lua` package; customers using the package will have to migrate to the `nginx-plus-extras` package in NGINX Plus R8

More information and important upgrade information for users of the Phusion Passenger Open Source module: [Announcing NGINX Plus Release 7](https://www.nginx.com/blog/nginx-plus-r7-released/)

<span id="r6"></span>
## NGINX Plus Release 6 (R6)
_14 April 2015_<br/>
_Based on NGINX Open Source 1.7.11_

NGINX Plus R6 is a feature release:

- TCP proxy enhancements (health checks, dynamic reconfiguration, SSL support, logging, status counters)
- New Least-Time load‑balancing algorithm
- Support for unbuffered upload ([proxy_request_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_request_buffering) directive)
- Proxy SSL authentication support for HTTP and uwsgi
- Proxy cache enhancements (variables in value of [proxy_cache](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache) directive, new `use_temp_path` parameter to [proxy_cache_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive)
- Mail proxy supports client SSL certificates
- Enhancement to Autoindex module (new [autoindex_format](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_format) directive)
- New live activity monitoring dashboard
- In the `nginx-plus-extras` package:
  - [Lua](https://github.com/openresty/lua-nginx-module) module updated to version 0.9.16rc1
  - [Phusion Passenger Open Source](https://blog.phusion.nl/tag/passenger-releases/) module updated to version 4.0.59
  - [Set-Misc](http://github.com/openresty/set-misc-nginx-module) module updated to version 0.28

NGINX Plus R6 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                             |
|------------------------|------------------------------------------------------|
| CentOS                 | 5.10+, 6.5+, 7.0                                     |
| Debian                 | 6.0, 7.0, 8.0                                        |
| FreeBSD                | 9.3, 10.1                                            |
| Oracle Linux           | 5.10+, 6.5+, 7.0                                     |
| RHEL                   | 5.10+, 6.5+, 7.0                                     |
| SLES                   | 11 SP3, 12                                           |
| Ubuntu                 | 10.04 LTS, 12.04 LTS, 14.04 LTS, 14.10               |
{{</bootstrap-table>}}

The `nginx-plus-extras` package has additional dependencies.

More information: [Announcing NGINX Plus Release 6 with Enhanced Load Balancing, High Availability, and Monitoring Features](https://www.nginx.com/blog/nginx-plus-r6-released/)

<span id="r5"></span>
## NGINX Plus Release 5 (R5)
_2 December 2014_<br/>
_Based on NGINX Open Source 1.7.7_

NGINX Plus R5 is a feature release:

- Proxying and load balancing of raw TCP traffic (the [Stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) module)
- Sticky session timeout now applies from the most recent request in the session
- Upstream “draining” can be used to remove an upstream server without interrupting any user sessions (new `drain` parameter to the [upstream_conf](https://nginx.org/en/docs/http/ngx_http_upstream_conf_module.html#upstream_conf) directive)
- Improved control over request retries in the event of failure, based on number of tries and time; also available for FastCGI, memcached, SCGI, and uwsgi modules
- `Vary` field in response header is correctly handled for caching (multiple variants of the same resource can be cached); note that the on‑disk cache format has changed, so upgrading to R5 invalidates cached content
- Improved caching support for byte‑range requests
- Control of upstream bandwidth (new [proxy_limit_rate](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_limit_rate) directive)
- In the `nginx-plus-extras` package:
  - [Lua](https://github.com/openresty/lua-nginx-module) module updated to version 0.9.13
  - [Phusion Passenger Open Source](https://blog.phusion.nl/tag/passenger-releases/) module updated to version 4.0.53
- In the nginx-plus-lua</span> package:
  - [Lua](https://github.com/openresty/lua-nginx-module) module updated to version 0.9.13

NGINX Plus R5 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                             |
|------------------------|------------------------------------------------------|
| CentOS                 | 5.9, 6.5, 7.0                                        |
| Debian                 | 6.0, 7.0                                             |
| FreeBSD                | 9.3, 10.0                                            |
| Oracle Linux           | 5.10+, 6.5+, 7.0                                     |
| RHEL                   | 5.9, 6.5, 7.0                                        |
| SLES                   | 11 SP3, 12                                           |
| Ubuntu                 | 10.04 LTS, 12.04 LTS, 14.04 LTS, 14.10               |
{{</bootstrap-table>}}

The `nginx-plus-extras` and `nginx-plus-lua` packages have additional dependencies.

More information: [NGINX Plus R5 Released](https://www.nginx.com/blog/nginx-plus-r5-released/)

<span id="r4"></span>
## NGINX Plus Release 4 (R4)
_24 July 2014_<br/>
_Based on NGINX Open Source 1.7.3_

NGINX Plus R4 is a feature release:

- Ability to verify backend SSL certificates
- Support for SNI while working with SSL backends
- Passphrases for SSL private keys can now be stored in an external file
- New load‑balancing method based on user‑defined keys with optional consistency ([hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash) directive)
- New session affinity mechanism (sticky learn) based on server‑initiated sessions
- Cache revalidation now uses `If-None-Match` header field when possible
- Conditional logging for requests (new `if` parameter to the [access_log](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log) directive)
- Ability to retrieve a subset of the live activity monitoring data
- [MP4](https://nginx.org/en/docs/http/ngx_http_mp4_module.html) module now supports the `end` argument in request URIs, which sets the end point of playback
- In the `nginx-plus-extras` package:
  - [Lua](https://github.com/openresty/lua-nginx-module) module updated to version 0.9.10
  - [Phusion Passenger Open Source](https://blog.phusion.nl/tag/passenger-releases/) module updated to version 4.0.45
- In the nginx-plus-lua</span> package:
  - [Lua](https://github.com/openresty/lua-nginx-module) module updated to version 0.9.10

NGINX Plus R4 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                       |
|------------------------|------------------------------------------------|
| CentOS                 | 5.9, 6.5, 7.0                                  |
| Debian                 | 6.0, 7.0                                       |
| FreeBSD                | 9.2, 10.0                                      |
| Oracle Linux           | 5.10+, 6.5+, 7.0                               |
| RHEL                   | 5.9, 6.5, 7.0                                  |
| SLES                   | 11 SP3                                         |
| Ubuntu                 | 10.04 LTS, 12.04 LTS, 14.04 LTS                |
{{</bootstrap-table>}}

The `nginx-plus-extras` and  `nginx-plus-lua` packages have additional dependencies.

More information: [NGINX Plus R4 Released](https://www.nginx.com/blog/nginx-plus-r4-released/)

<span id="r3"></span>
## NGINX Plus Release 3 (R3)
_2 April 2014_<br/>
_Based on NGINX Open Source 1.5.12‑1_

NGINX Plus R3 is a feature release:

- Automatic re‑resolution of hostnames in upstream groups allows group members to be updated on‑the‑fly using DNS
- New connection limits and an internal connection queue protect servers from connection overload and improve connection scheduling by NGINX Plus’ load balancing
- Support for PROXY protocol
- SPDY support updated to comply with draft 3.1
- Additional controls over SSL have been added to control the use of session tickets and reduce time to first byte
- Support for IPv6 DNS resolution

NGINX Plus R3 is supported on:

{{<bootstrap-table "table table-striped table-bordered">}}
| OS Distribution       | Versions                                       |
|------------------------|------------------------------------------------|
| CentOS                 | 5.9, 6.5                                       |
| Debian                 | 6.0, 7.0                                       |
| FreeBSD                | 9.2, 10.0                                      |
| Oracle Linux           | 5.10+, 6.5+, 7.0                               |
| RHEL                   | 5.9, 6.5                                       |
| SLES                   | 11 SP3                                         |
| Ubuntu                 | 10.04 LTS, 12.04 LTS, 12.10, 13.10, 14.04 LTS  |
{{</bootstrap-table>}}

The `nginx-plus-extras` and `nginx-plus-lua` packages have additional dependencies.

More information: [NGINX Plus R3 Released](https://www.nginx.com/blog/nginx-plus-r3-released/)

<span id="r2"></span>
## NGINX Plus Release 2 (R2)
_12 December 2013_<br/>
_Based on NGINX Open Source 1.5.7‑1_

NGINX Plus R2 is a feature release:

- Enhanced sticky routing support
- Additional status metrics for virtual hosts and cache zones
- Cache purge support (also available for FastCGI)
- Support for cache revalidation
- Support for authorization based on the result of a subrequest (new [ngx_http_auth_request_module](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html) module)

### NGINX Plus R2 Updates

Security Update to NGINX Plus Release R2
_21 March 2014_<br/>
_Based on NGINX Open Source 1.5.7‑4_

- Fixes vulnerability in experimental SPDY implementation in NGINX Open Source 1.5.7‑3 and earlier.

Functional Update to NGINX Plus R2
_5 March 2014_<br/>
_Based on NGINX Open Source 1.5.7‑3_

- NGINX Plus now correctly applies the value set with the [client_max_body_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) directive when processing HTTP requests that contain chunk‑encoded body data.

Functional Update to NGINX Plus R2
_13 February 2014_<br/>
_Based on NGINX Open Source 1.5.7‑2_

- Updates to MP4 and HLS streaming functionality
- Fix for premature closing of connections when using SPDY with proxy cache
- Updates to implementation of SPDY/2
- Added **status.html** file for live activity monitoring, missing from some packages

<span id="r1"></span>
## NGINX Plus Initial Release (R1)
_22 August 2013_<br/>
_Based on NGINX Open Source 1.5.3‑1_

NGINX Plus is the fully supported, commercial version of NGINX. It includes most NGINX open source modules and adds further features:

- Application health checks
- Live activity monitoring (implemented in the Extended Status module)
- Advanced load balancing
- On‑the‑fly</span> reconfiguration of load‑balanced upstream groups
- Extended logging capabilities
- High availability setup
- Adaptive media streaming
