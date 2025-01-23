
<h1>Heres a h1 thing!</h1>
[Basic HTTP server features](#basic_http_features)  
[Other HTTP server features](#other_http_features)  
[Mail proxy server features](#mail_proxy_server_features)  
[TCP/UDP proxy server features](#generic_proxy_server_features)  
[Architecture and scalability](#architecture_and_scalability)  
[Tested OS and platforms](#tested_os_and_platforms)  

nginx ("_engine x_") is an HTTP web server, reverse proxy, content cache, load balancer, TCP/UDP proxy server, and mail proxy server. Originally written by [Igor Sysoev](http://sysoev.ru/en/) and distributed under the [2-clause BSD License](../LICENSE).

Known for flexibility and high performance with low resource utilization, nginx is:

*   the world's most popular web server \[[Netcraft](https://news.netcraft.com/archives/category/web-server-survey/)\];
*   consistently one of the most popular [Docker images](https://hub.docker.com/search?q=nginx) \[[DataDog](https://www.datadoghq.com/docker-adoption/#six)\];
*   powering multiple [Ingress Controllers for Kubernetes](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/), including [our own](https://github.com/nginxinc/kubernetes-ingress).

Enterprise distributions, commercial support and training are [available from F5, Inc.](enterprise.html)

#### Basic HTTP server features

*   Serving static and [index](docs/http/ngx_http_index_module.html) files, [autoindexing](docs/http/ngx_http_autoindex_module.html); [open file descriptor cache](docs/http/ngx_http_core_module.html#open_file_cache);
*   [Accelerated reverse proxying with caching](docs/http/ngx_http_proxy_module.html); [load balancing and fault tolerance](docs/http/ngx_http_upstream_module.html);
*   Accelerated support with caching of [FastCGI](docs/http/ngx_http_fastcgi_module.html), [uwsgi](docs/http/ngx_http_uwsgi_module.html), [SCGI](docs/http/ngx_http_scgi_module.html), and [memcached](docs/http/ngx_http_memcached_module.html) servers; [load balancing and fault tolerance](docs/http/ngx_http_upstream_module.html);
*   Modular architecture. Filters include [gzipping](docs/http/ngx_http_gzip_module.html), byte ranges, chunked responses, [XSLT](docs/http/ngx_http_xslt_module.html), [SSI](docs/http/ngx_http_ssi_module.html), and [image transformation](docs/http/ngx_http_image_filter_module.html) filter. Multiple SSI inclusions within a single page can be processed in parallel if they are handled by proxied or FastCGI/uwsgi/SCGI servers;
*   [SSL and TLS SNI support](docs/http/ngx_http_ssl_module.html);
*   Support for [HTTP/2](docs/http/ngx_http_v2_module.html) with weighted and dependency-based prioritization;
*   Support for [HTTP/3](docs/http/ngx_http_v3_module.html).

#### Other HTTP server features

*   Name-based and IP-based [virtual servers](docs/http/request_processing.html);
*   [Keep-alive](docs/http/ngx_http_core_module.html#keepalive_timeout) and pipelined connections support;
*   [Access log formats](docs/http/ngx_http_log_module.html#log_format), [buffered log writing](docs/http/ngx_http_log_module.html#access_log), [fast log rotation](docs/control.html#logs), and [syslog logging](docs/syslog.html);
*   3xx-5xx error codes [redirection](docs/http/ngx_http_core_module.html#error_page);
*   The rewrite module: [URI changing using regular expressions](docs/http/ngx_http_rewrite_module.html);
*   [Executing different functions](docs/http/ngx_http_rewrite_module.html#if) depending on the [client address](docs/http/ngx_http_geo_module.html);
*   Access control based on [client IP address](docs/http/ngx_http_access_module.html), [by password (HTTP Basic authentication)](docs/http/ngx_http_auth_basic_module.html) and by the [result of subrequest](docs/http/ngx_http_auth_request_module.html);
*   Validation of [HTTP referer](docs/http/ngx_http_referer_module.html);
*   The [PUT, DELETE, MKCOL, COPY, and MOVE](docs/http/ngx_http_dav_module.html) methods;
*   [FLV](docs/http/ngx_http_flv_module.html) and [MP4](docs/http/ngx_http_mp4_module.html) streaming;
*   [Response rate limiting](docs/http/ngx_http_core_module.html#limit_rate);
*   Limiting the number of simultaneous [connections](docs/http/ngx_http_limit_conn_module.html) or [requests](docs/http/ngx_http_limit_req_module.html) coming from one address;
*   [IP-based geolocation](docs/http/ngx_http_geoip_module.html);
*   [A/B testing](docs/http/ngx_http_split_clients_module.html);
*   [Request mirroring](docs/http/ngx_http_mirror_module.html);
*   Embedded [Perl](docs/http/ngx_http_perl_module.html);
*   [njs](docs/njs/index.html) scripting language.

#### Mail proxy server features

*   User redirection to [IMAP](docs/mail/ngx_mail_imap_module.html) or [POP3](docs/mail/ngx_mail_pop3_module.html) server using an external HTTP [authentication](docs/mail/ngx_mail_auth_http_module.html) server;
*   User authentication using an external HTTP [authentication](docs/mail/ngx_mail_auth_http_module.html) server and connection redirection to an internal [SMTP](docs/mail/ngx_mail_smtp_module.html) server;
*   Authentication methods:
    *   [POP3](docs/mail/ngx_mail_pop3_module.html#pop3_auth): USER/PASS, APOP, AUTH LOGIN/PLAIN/CRAM-MD5;
    *   [IMAP](docs/mail/ngx_mail_imap_module.html#imap_auth): LOGIN, AUTH LOGIN/PLAIN/CRAM-MD5;
    *   [SMTP](docs/mail/ngx_mail_smtp_module.html#smtp_auth): AUTH LOGIN/PLAIN/CRAM-MD5;
*   [SSL](docs/mail/ngx_mail_ssl_module.html) support;
*   [STARTTLS and STLS](docs/mail/ngx_mail_ssl_module.html#starttls) support.

#### TCP/UDP proxy server features

*   [Generic proxying](docs/stream/ngx_stream_proxy_module.html) of TCP and UDP;
*   [SSL](docs/stream/ngx_stream_ssl_module.html) and TLS [SNI](docs/stream/ngx_stream_ssl_preread_module.html) support for TCP;
*   [Load balancing and fault tolerance](docs/stream/ngx_stream_upstream_module.html);
*   Access control based on [client address](docs/stream/ngx_stream_access_module.html);
*   Executing different functions depending on the [client address](docs/stream/ngx_stream_geo_module.html);
*   Limiting the number of simultaneous [connections](docs/stream/ngx_stream_limit_conn_module.html) coming from one address;
*   [Access log formats](docs/stream/ngx_stream_log_module.html#log_format), [buffered log writing](docs/stream/ngx_stream_log_module.html#access_log), [fast log rotation](docs/control.html#logs), and [syslog logging](docs/syslog.html);
*   [IP-based geolocation](docs/stream/ngx_stream_geoip_module.html);
*   [A/B testing](docs/stream/ngx_stream_split_clients_module.html);
*   [njs](docs/njs/index.html) scripting language.

#### Architecture and scalability

*   One master and several worker processes; worker processes run under an unprivileged user;
*   [Flexible configuration](docs/example.html);
*   [Reconfiguration](docs/control.html#reconfiguration) and [upgrade of an executable](docs/control.html#upgrade) without interruption of the client servicing;
*   [Support](docs/events.html) for kqueue (FreeBSD 4.1+), epoll (Linux 2.6+), /dev/poll (Solaris 7 11/99+), event ports (Solaris 10), select, and poll;
*   The support of the various kqueue features including EV\_CLEAR, EV\_DISABLE (to temporarily disable events), NOTE\_LOWAT, EV\_EOF, number of available data, error codes;
*   The support of various epoll features including EPOLLRDHUP (Linux 2.6.17+, glibc 2.8+) and EPOLLEXCLUSIVE (Linux 4.5+, glibc 2.24+);
*   sendfile (FreeBSD 3.1+, Linux 2.2+, macOS 10.5+), sendfile64 (Linux 2.4.21+), and sendfilev (Solaris 8 7/01+) support;
*   [File AIO](docs/http/ngx_http_core_module.html#aio) (FreeBSD 4.3+, Linux 2.6.22+);
*   [DIRECTIO](docs/http/ngx_http_core_module.html#directio) (FreeBSD 4.4+, Linux 2.4+, Solaris 2.6+, macOS);
*   Accept-filters (FreeBSD 4.1+, NetBSD 5.0+) and TCP\_DEFER\_ACCEPT (Linux 2.4+) [support](docs/http/ngx_http_core_module.html#listen);
*   10,000 inactive HTTP keep-alive connections take about 2.5M memory;
*   Data copy operations are kept to a minimum.

#### Tested OS and platforms

*   FreeBSD 3 — 12 / i386; FreeBSD 5 — 12 / amd64; FreeBSD 11 / ppc; FreeBSD 12 / ppc64;
*   Linux 2.2 — 4 / i386; Linux 2.6 — 5 / amd64; Linux 3 — 4 / armv6l, armv7l, aarch64, ppc64le; Linux 4 — 5 / s390x;
*   Solaris 9 / i386, sun4u; Solaris 10 / i386, amd64, sun4v; Solaris 11 / x86;
*   AIX 7.1 / powerpc;
*   HP-UX 11.31 / ia64;
*   macOS / ppc, i386, x86\_64;
*   Windows XP, Windows Server 2003, Windows 7, Windows 10, Windows 11.