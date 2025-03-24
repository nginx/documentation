---
description: Compress server responses, or decompress them for clients that don't
  support compression, to improve delivery speed and reduce overhead on the server.
docs: DOCS-440
title: Compression and Decompression
toc: true
weight: 400
type:
- how-to
---

This section describes how to configure compression or decompression of responses, as well as sending compressed files.

## Introduction

Compressing responses often significantly reduces the size of transmitted data. However, since compression happens at runtime it can also add considerable processing overhead which can negatively affect performance. NGINX performs compression before sending responses to clients, but does not “double compress” responses that are already compressed (for example, by a proxied server).

## Enabling Compression

To enable compression, include the [gzip](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip) directive with the `on` parameter.

```nginx
gzip on;
```

By default, NGINX compresses responses only with MIME type `text/html`. To compress responses with other MIME types, include the [gzip_types](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_types) directive and list the additional types.

```nginx
gzip_types text/plain application/xml;
```

To specify the minimum length of the response to compress, use the [gzip_min_length](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_min_length) directive. The default is 20 bytes (here adjusted to 1000):

```nginx
gzip_min_length 1000;
```

By default, NGINX does not compress responses to proxied requests (requests that come from the proxy server). The fact that a request comes from a proxy server is determined by the presence of the `Via` header field in the request. To configure compression of these responses, use the [gzip_proxied](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_proxied) directive. The directive has a number of parameters specifying which kinds of proxied requests NGINX should compress. For example, it is reasonable to compress responses only to requests that will not be cached on the proxy server. For this purpose the `gzip_proxied` directive has parameters that instruct NGINX to check the `Cache-Control` header field in a response and compress the response if the value is `no-cache`, `no-store`, or `private`. In addition, you must include the `expired` parameter to check the value of the `Expires` header field. These parameters are set in the following example, along with the `auth` parameter, which checks for the presence of the `Authorization` header field (an authorized response is specific to the end user and is not typically cached):

```nginx
gzip_proxied no-cache no-store private expired auth;
```

As with most other directives, the directives that configure compression can be included in the `http` context or in a `server` or `location` configuration block.

The overall configuration of gzip compression might look like this.

```nginx
server {
    gzip on;
    gzip_types      text/plain application/xml;
    gzip_proxied    no-cache no-store private expired auth;
    gzip_min_length 1000;
    ...
}
```

## Enabling Decompression

Some clients do not support responses with the `gzip` encoding method. At the same time, it might be desirable to store compressed data, or compress responses on the fly and store them in the cache. To successfully serve both clients that do and do not accept compressed data, NGINX can decompress data on the fly when sending it to the latter type of client.

To enable runtime decompression, use the [gunzip](https://nginx.org/en/docs/http/ngx_http_gunzip_module.html#gunzip) directive.

```nginx
location /storage/ {
    gunzip on;
    ...
}
```

The `gunzip` directive can be specified in the same context as the `gzip` directive:

```nginx
server {
    gzip on;
    gzip_min_length 1000;
    gunzip on;
    ...
}
```

Note that this directive is defined in a separate [module](https://nginx.org/en/docs/http/ngx_http_gunzip_module.html) that might not be included in an NGINX Open Source  build by default.

## Sending Compressed Files

To send a compressed version of a file to the client instead of the regular one, set the [gzip_static](https://nginx.org/en/docs/http/ngx_http_gzip_static_module.html#gzip_static) directive to `on` within the appropriate context.

```nginx
location / {
    gzip_static on;
}
```

In this case, to service a request for **/path/to/file**, NGINX tries to find and send the file **/path/to/file.gz**. If the file doesn’t exist, or the client does not support gzip, NGINX sends the uncompressed version of the file.

Note that the `gzip_static` directive does not enable on-the-fly compression. It merely uses a file compressed beforehand by any compression tool. To compress content (and not only static content) at runtime, use the `gzip` directive.

This directive is defined in a separate [module](https://nginx.org/en/docs/http/ngx_http_gzip_static_module.html) that might not be included in an NGINX Open Source  build by default.
