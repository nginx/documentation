---
description: Platforms supported by F5 NGINX Plus and dynamically loaded modules,
  supported SSL/TLS versions, supported deployment environments, and list of modules
  built into NGINX Plus.
nd-docs: DOCS-473
title: Technical Specs
toc: true
weight: 400
type:
- concept
---

NGINX Plus is available only as a binary; it is not distributed as source code. For additional platforms and modules, [contact us](https://www.f5.com/products/get-f5).

## Supported Distributions {#supported-distributions}

{{< include "nginx-plus/supported-distributions.md" >}}

---

## Dynamic Modules

Dynamic modules are supported on the [same distributions as NGINX Plus](#supported-distributions), unless noted otherwise in the table below.

{{<bootstrap-table "table table-striped table-bordered">}}
| Distribution | **Module:** [AppProtect]({{< ref "/nap-waf/v5/admin-guide/install.md" >}}) | **Module:** [GeoIP]({{< ref "/nginx/admin-guide/dynamic-modules/geoip.md" >}}) | **Module:** [GeoIP2]({{< ref "/nginx/admin-guide/dynamic-modules/geoip2.md" >}}) | **Module:** [HA-Keepalived]({{< ref "/nginx/admin-guide/high-availability/ha-keepalived-nodes.md#configuring-keepalived-for-an-additional-passive-node" >}}) | **Module:** [NGINX sync]({{< ref "/nginx/admin-guide/high-availability/configuration-sharing.md#installing-nginx-sync-on-the-primary-machine" >}}) | **Module:** [OpenTelemetry]({{< ref "/nginx/admin-guide/dynamic-modules/opentelemetry.md" >}}) |
|--------------|------------|-------|---------|---------------|------------|---------------|
| **AlmaLinux** | ❌ | ❌ | ✓ | ✓ | ✓ | ✓ |
| **Alpine Linux 3.17 & 3.18** | ❌ | ✓ | ✓ | ❌ | ❌ | ✓ |
| **Alpine Linux 3.19, 3.20, 3.21, 3.22** | ✓ (x86_64 only) | ✓ | ✓ | ❌ | ❌ | ✓ |
| **Amazon Linux 2** | ❌ | ✓ | ❌ | ❌ | ✓ | ❌ |
| **Amazon Linux 2023** | ✓ (x86_64 only) | ❌ | ✓ | ❌ | ✓ | ✓ |
| **Debian 11 & 12** | ✓ (x86_64 only) | ✓ | ✓ | ✓ | ✓ | ✓ |
| **FreeBSD** | ❌ | ❌ | ✓ | ❌ | ❌ | ✓ |
| **Oracle Linux 8** | ✓ (x86_64 only) |  ❌ | ✓ | ✓ | ✓ | ✓ |
| **RHEL 8 & 9** | ✓ (x86_64 only) | ❌ | ✓ | ✓ | ✓ | ✓ |
| **Rocky Linux 8** | ❌ |  ❌ | ✓ | ✓ | ✓ | ✓ |
| **Rocky Linux 9** | ✓ (x86_64 only) | ❌ | ✓ | ✓ | ✓ | ✓ |
| **SLES** | ❌ | ✓ | ✓ | ✓ | ✓ | ❌ |
| **Ubuntu 20.04** | ❌ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Ubuntu 22.04 & 24.04** | ✓ (x86_64 only) | ✓ | ✓ | ✓ | ✓ | ✓ |
{{</bootstrap-table>}}

---


## Supported SSL/TLS versions

NGINX Plus supports the following SSL/TLS protocols:
- SSLv2
- SSLv3
- TLSv1
- TLSv1.1
- TLSv1.2
- TLSv1.3

You can configure which protocols to enable or disable with the [ssl_protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) directive.

TLSv1.2 and earlier are supported on all operating systems listed in [Supported Distributions](#supported-distributions).

TLSv1.3 is supported starting from NGINX Plus R17 and is enabled by default in NGINX Plus R29 and later. It requires OpenSSL 1.1.1 or higher. Note that not all operating systems supported by NGINX Plus include OpenSSL 1.1.1. Check your operating system's documentation to confirm TLSv1.3 compatibility.

TLSv1.2 and TLSv1.3 are the default SSL protocols starting from NGINX Plus R34 (if supported by the OpenSSL library). If OpenSSL 1.0.0 or older is used, the default SSL protocols are TLSv1 and TLSv1.1.

---

## Supported Deployment Environments

- Bare metal
- Containers and Kubernetes
- Public clouds: AWS, Google Cloud Platform, Microsoft Azure
- Virtual machines

---

## Recommended Hardware
See [Sizing Guide for Deploying NGINX Plus](https://www.f5.com/pdf/deployment-guide/Sizing-Guide-for-Deploying-NGINX-Plus-in-Virtualized-Environments-2021-06-03.pdf)

---

## Modules in the NGINX Plus Package

### Core

- [Core](https://nginx.org/en/docs/ngx_core_module.html) – Control basic functioning (mutexes, events, thread pools, workers, and so on)

### Clustering

- [Zone Sync](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) – Synchronize [shared memory zones](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#zone) among nodes in a cluster

### HTTP Core

- [HTTP Core](https://nginx.org/en/docs/http/ngx_http_core_module.html) – Process HTTP traffic
- [Addition](https://nginx.org/en/docs/http/ngx_http_addition_module.html) – Prepend and append data to a response
- [Auto Index](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html) – Generate directory listings
- [Charset](https://nginx.org/en/docs/http/ngx_http_charset_module.html) – Add character set in `Content-Type` field of HTTP response header, and define or convert between character sets
- [Empty GIF](https://nginx.org/en/docs/http/ngx_http_empty_gif_module.html) – Generate empty image response
- [Gunzip](https://nginx.org/en/docs/http/ngx_http_gunzip_module.html) – Decompress responses for clients that don’t support compression
- [Gzip](https://nginx.org/en/docs/http/ngx_http_gzip_module.html) – Use GZIP to compress HTTP responses
- [Gzip Static](https://nginx.org/en/docs/http/ngx_http_gzip_static_module.html) – Serve pre-compressed files from disk
- [Headers](https://nginx.org/en/docs/http/ngx_http_headers_module.html) – Add fields to HTTP response headers, including `Cache-Control` and `Expires`
- [Index](https://nginx.org/en/docs/http/ngx_http_index_module.html) – Specify index files used in directory requests
- [Internal Redirect](https://nginx.org/en/docs/http/ngx_http_internal_redirect_module.html) – Allow internal redirects after checking request or connection processing limits, and access limits
- [Random Index](https://nginx.org/en/docs/http/ngx_http_random_index_module.html) – Select random index file for directory request
- [Real IP](https://nginx.org/en/docs/http/ngx_http_realip_module.html) – Determine true origin IP address for proxied traffic
- [SSI](https://nginx.org/en/docs/http/ngx_http_ssi_module.html) – Process Server Side Includes (SSI) commands
- [User ID](https://nginx.org/en/docs/http/ngx_http_userid_module.html) – Set cookies that uniquely identify clients
- [WebDAV](https://nginx.org/en/docs/http/ngx_http_dav_module.html) – Implement WebDAV file management

### HTTP Access Control and Authentication

- [Access](https://nginx.org/en/docs/http/ngx_http_access_module.html) – Control access based on client IP address (support access control lists [ACLs])
- [Auth Basic](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html) – Implement HTTP Basic Authentication scheme
- [Auth JWT](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html) – Validate JSON Web Tokens
- [Auth Request](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html) – Determine client authorization using subrequests to external authentication server
- [Auth Require](https://nginx.org/en/docs/http/ngx_http_auth_require_module.html) – Variable-based access control support
- [OIDC](https://nginx.org/en/docs/http/ngx_http_oidc_module.html) – Implement authentication as a Relying Party in OpenID Connect solution
- [Referer](https://nginx.org/en/docs/http/ngx_http_referer_module.html) – Control access based on `Referer` field in HTTP request header
- [Secure Link](https://nginx.org/en/docs/http/ngx_http_secure_link_module.html) – Process encrypted, time-limited links to content

### HTTP Advanced Configuration

- [Browser](https://nginx.org/en/docs/http/ngx_http_browser_module.html) – Create variables based on `User-Agent` field in HTTP request header
- [Cache Slice](https://nginx.org/en/docs/http/ngx_http_slice_module.html) – Create byte-range segments of large files, for more efficient caching
- [Geo](https://nginx.org/en/docs/http/ngx_http_geo_module.html) – Create variables based on client IP address
- [Map](https://nginx.org/en/docs/http/ngx_http_map_module.html) – Create variables based on other variables in requests
- [Rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html) – Test and change URI of request
- [Split Clients](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html) – Partition clients for A/B testing
- [Sub](https://nginx.org/en/docs/http/ngx_http_sub_module.html) – Replace text string in response (rewrite content)

### HTTP Logging

- [Log](https://nginx.org/en/docs/http/ngx_http_log_module.html) – Log HTTP transactions locally or to `syslog`
- [Session Log](https://nginx.org/en/docs/http/ngx_http_session_log_module.html) – Log HTTP transactions aggregated per session

### HTTP Media Delivery

- [F4F](https://nginx.org/en/docs/http/ngx_http_f4f_module.html) – Stream HDS (Adobe HTTP Dynamic Streaming; filename extensions **.f4f**, **.f4m**, **.f4x**)
- [FLV](https://nginx.org/en/docs/http/ngx_http_flv_module.html) – Stream FLV (Flash Video; filename extension **.flv**)
- [HLS](https://nginx.org/en/docs/http/ngx_http_hls_module.html) – Stream HLS (Apple HTTP Live Streaming; filename extensions **.m3u8**, **.ts**) dynamically generated from MP4 or MOV (filename extensions **.m4a**, **.m4v**, **.mov**, **.mp4**, and **.qt**)
- [MP4](https://nginx.org/en/docs/http/ngx_http_mp4_module.html) – Stream MP4 (filename extensions **.m4a**, **.m4v**, **.mp4**)
- Streaming of RTMP and DASH is provided by the third-party [RTMP](https://github.com/arut/nginx-rtmp-module) module

### HTTP Proxying

- [FastCGI](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html) – Proxy and cache requests to FastCGI server
- [gRPC](https://nginx.org/en/docs/http/ngx_http_grpc_module.html) – Proxy requests to gRPC server
- [Memcached](https://nginx.org/en/docs/http/ngx_http_memcached_module.html) – Proxy requests to memcached server
- [Mirror](https://nginx.org/en/docs/http/ngx_http_mirror_module.html) – Send copy of requests to one or more additional servers
- [Proxy](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) – Proxy and cache requests to HTTP server
- [SCGI](https://nginx.org/en/docs/http/ngx_http_scgi_module.html) – Proxy and cache requests to SCGI server
- [Upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html) – Proxy and cache requests to load-balanced pool of servers
- [Upstream Health Checks](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html) – Verify servers in load-balanced pool are operational
- [uwsgi](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html) – Proxy and cache requests to uwsgi server

### HTTP Transaction Shaping

- [Limit Connections](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html) – Limit concurrent connections from a client IP address or other keyed value
- [Limit Requests](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) – Limit rate of request processing for a client IP address or other keyed value
- [Limit Responses](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate) – Limit rate of responses per client connection

### HTTP/2, HTTP/3 and SSL/TLS

- [HTTP/2](https://nginx.org/en/docs/http/ngx_http_v2_module.html) – Process HTTP/2 traffic
- [HTTP/3](https://nginx.org/en/docs/http/ngx_http_v3_module.html) – Process HTTP/3 traffic
- [SSL/TLS](https://nginx.org/en/docs/http/ngx_http_ssl_module.html) – Process HTTPS traffic

### Mail

- [Mail Core](https://nginx.org/en/docs/mail/ngx_mail_core_module.html) – Proxy mail traffic
- [Auth HTTP](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html) – Offload authentication processing from HTTP server
- [IMAP](https://nginx.org/en/docs/mail/ngx_mail_imap_module.html) – Implement capabilities and authentication methods for IMAP
- [POP3](https://nginx.org/en/docs/mail/ngx_mail_pop3_module.html) – Implement authentication methods for POP3 traffic
- [Proxy](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html) – Support proxy-related parameters for mail protocols
- [SMTP](https://nginx.org/en/docs/mail/ngx_mail_smtp_module.html) – Define accepted SASL authentication methods for SMTP clients
- [SSL/TLS](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html) – Implement SSL, STARTTLS, and TLS for mail protocols

### Programmability and Monitoring

- [NGINX Plus API](https://nginx.org/en/docs/http/ngx_http_api_module.html) – Provide REST API for accessing metrics, configuring upstream server groups dynamically, and managing key-value pairs, without the need to reload NGINX configuration
- [Key-Value Store](https://nginx.org/en/docs/http/ngx_http_keyval_module.html) – Create variables with values taken from key-value pairs managed by the [NGINX Plus API](https://nginx.org/en/docs/http/ngx_http_api_module.html#http_keyvals_)
- [Management](https://nginx.org/en/docs/ngx_mgmt_module.html) – [Configure licensing and usage reporting]({{< ref "solutions/about-subscription-licenses.md" >}}) of NGINX Plus installation to F5 licensing endpoint or [NGINX Instance Manager]({{< ref "nim/index.md" >}})

### TCP and UDP Proxying and Load Balancing

- [Stream](https://nginx.org/en/docs/stream/ngx_stream_module.html) – Process TCP and UDP traffic
- [Access](https://nginx.org/en/docs/stream/ngx_stream_access_module.html) – Support IP-based access control lists (ACLs)
- [Geo](https://nginx.org/en/docs/stream/ngx_stream_geo_module.html) – Create variables based on client IP address
- [Limit Conn](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html) – Limit concurrent connections by key
- [Log](https://nginx.org/en/docs/stream/ngx_stream_log_module.html) – Log TCP and UDP transactions
- [Map](https://nginx.org/en/docs/stream/ngx_stream_map_module.html) – Create variables based on other variables in requests
- [MQTT Preread](https://nginx.org/en/docs/stream/ngx_stream_mqtt_preread_module.html) – Forward MQTT traffic without processing it
- [MQTT Filter](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html) – Process Message Queuing Telemetry Transport protocol (MQTT) protocol
- [Proxy](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html) – Proxy requests to TCP and UDP servers
- [Pass](https://nginx.org/en/docs/stream/ngx_stream_pass_module.html) – Pass any accepted client connection to any configured listening socket in http, stream, mail, and other similar modules
- [Real IP](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html) – Determine true origin IP address for proxied traffic
- [Return](https://nginx.org/en/docs/stream/ngx_stream_return_module.html) – Return specified value to client and close connection
- [Split Clients](https://nginx.org/en/docs/stream/ngx_stream_split_clients_module.html) – Partition clients for A/B testing
- [SSL/TLS](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html) – Process TCP traffic secured with SSL/TLS
- [SSL/TLS Preread](https://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html) – Forward TCP traffic secured with SSL/TLS without decrypting it
- [Upstream](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html) – Proxy and cache traffic to load-balanced pool of servers
- [Upstream Health Checks](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html) – Verify servers in load-balanced pool are operational
