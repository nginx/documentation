---
title: Key features
weight: 200
toc: true
---

From the start, our vision for Unit was versatility, speed, and reliability. Here's how we tackle these goals.

## Flexibility

- The [entire configuration]({{< relref "/unit/controlapi.md#configuration-api/">}}) is managed dynamically over HTTP via a friendly [RESTful JSON API]({{< relref "/unit/controlapi.md#configuration-mgmt">}}).
- Updates to the configuration are performed granularly at runtime with zero interruption.
- Requests are [routed]({{< relref "/unit/configuration.md#configuration-routes">}}) between [static content]({{< relref "/unit/configuration.md#configuration-static">}}), upstream [servers]({{< relref "/unit/configuration.md#configuration-proxy">}}), and local [apps]({{< relref "/unit/configuration.md#configuration-applications">}}).
- Request filtering and dispatching uses elaborate [matching rules]({{< relref "/unit/configuration.md#configuration-routes-matching">}}) that enable [regular expressions]({{< relref "/unit/configuration.md#configuration-routes-matching-patterns">}}), [response header]({{< relref "/unit/configuration.md#configuration-response-headers">}}) awareness, and `njs` [scripting]({{< relref "/unit/scripting/">}}).
- Apps in multiple languages and language versions run [side by side]({{< relref "/unit/configuration.md#configuration-applications">}}).
- Server-side [WebAssembly]({{< relref "/unit/configuration.md#configuration-wasm">}}) is natively supported.
- Common [language-specific APIs]({{< relref "/unit/howto/overview.md#howto-frameworks">}}) for all supported languages run seamlessly.
- Upstream [server groups]({{< relref "/unit/configuration.md#configuration-upstreams">}}) provide dynamic load balancing using a weighted round-robin method.
- Originating IP identification [supports]({{< relref "/unit/configuration.md#configuration-listeners-xff">}}) **X-Forwarded-For** and similar header fields.

## Performance

- Requests are asynchronously processed in threads with efficient event loops (`epoll`, `kqueue`).
- Syscalls and data copy operations are kept to a necessary minimum.
- 10,000 inactive HTTP keep-alive connections take up only a few MBs of memory.
- Router and app processes rely on low-latency IPC built with lock-free queues over shared memory.
- Built-in [statistics]({{< relref "/unit/statusapi.md">}}) provide insights into Unit's performance.
- The number of per-app processes is defined statically or [scales]({{< relref "/unit/configuration.md#configuration-proc-mgmt-prcs">}}) preemptively within given limits.
- App and instance usage statistics are collected and [exposed]({{< relref "/unit/statusapi.md">}}) via the API.
- Multithreaded request processing is supported for [Java]({{< relref "/unit/configuration.md#configuration-java">}}), [Perl]({{< relref "/unit/configuration.md#configuration-perl">}}), [Python]({{< relref "/unit/configuration.md#configuration-python">}}), and [Ruby]({{< relref "/unit/configuration.md#configuration-ruby">}}) apps.

## Security & robustness

- Client connections are handled by a separate non-privileged router process.
- Low-resource conditions (out of memory or descriptors) and app crashes are handled gracefully.
- [SSL/TLS]({{< relref "/unit/certificates.md">}}) with [SNI]({{< relref "/unit/configuration.md#configuration-listeners-ssl">}}), [session cache and tickets]({{< relref "/unit/configuration.md#configuration-listeners-ssl-sessions">}}) is integrated (OpenSSL 1.0.1 and later).
- Different apps are isolated in separate processes.
- Apps can be additionally containerized with namespace and file system [isolation]({{< relref "/unit/configuration.md#configuration-proc-mgmt-isolation">}}).
- Static file serving benefits from [chrooting]({{< relref "/unit/configuration.md#configuration-share-path">}}), symlink and mount point [traversal restrictions]({{< relref "/unit/configuration.md#configuration-share-resolution">}}).

## Supported app languages

Unit interoperates with:

- [Binary-compiled languages](https://www.nginx.com/blog/nginx-unit-adds-assembly-language-support/) in general: using the embedded `libunit` library.
- [Go]({{< relref "/unit/configuration.md#configuration-go">}}): by [overriding]({{< relref "/unit/configuration.md#updating-go-apps">}}) the `http` module.
- [JavaScript (Node.js)]({{< relref "/unit/configuration.md#configuration-nodejs">}}): by automatically [overloading]({{< relref "/unit/installation.md#installation-nodejs-package">}}) the `http` and `websocket` modules.
- [Java]({{< relref "/unit/configuration.md#configuration-java">}}): by using the Servlet Specification 3.1 and WebSocket APIs.
- [Perl]({{< relref "/unit/configuration.md#configuration-perl">}}): by using PSGI.
- [PHP]({{< relref "/unit/configuration.md#configuration-php">}}): by using a custom SAPI module.
- [Python]({{< relref "/unit/configuration.md#configuration-python">}}): by using WSGI or ASGI with WebSocket support.
- [Ruby]({{< relref "/unit/configuration.md#configuration-ruby">}}): by using the Rack API.
- [WebAssembly]({{< relref "/unit/configuration.md#configuration-wasm">}}): by using Wasmtime.
