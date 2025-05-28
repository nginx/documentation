---
title: Unit 1.32.0 Released
weight: 700
---

Unit 1.32.0 comes with a new language module for WebAssembly that supports
the WASI 0.2 HTTP world so that WebAssembly Components implementing this
interface can be hosted on Unit.

This new language module improves upon the existing WebAssembly support. We
recommend all users to use this new implementation for WebAssembly. We consider
the old **unit-wasm** module deprecated now.

Additionally, we have added the following features:

- Enhanced the {doc}`njs (NGINX JavaScript) experience <../../scripting>` by making all Unit variables
  accessible from JavaScript
- Added support for
  {ref}`conditional access logging <conditional-access-logging-news>`, to help
  you filter the requests that are logged
- Added support for changing Unit's control socket permissions
- Added a [new variable]({{<relref "/unit/configuration.md#configuration-variables" >}})
, **\$request_id**

...and much more! Keep reading to learn more about what changed since 1.31.1.

## WebAssembly: Support for Wasm components and the WASI 0.2 API

Since the release of Unit 1.31.0 in August 2023 and the announcement of our
technology preview for WebAssembly, a lot has changed and happened in the
WebAssembly ecosystem.

So we evolved and with 1.32.0, we are happy to announce the support for the
WebAssembly Component Model using the WASI 0.2 APIs. This opens the
possibilities to run Wasm Components compatible with the WASI 0.2 APIs on Unit
without having a need to rebuild them. This is also the first Language Module
for Unit that was driven by the Community. Special thanks to Alex Crichton
for the contribution!

We are preparing a blog post where we will dive deeper into the details of the
new WebAssembly language module. Stay tuned!

## Enhanced scripting support - Use Unit-variables in NGINX JavaScript

Using JavaScript in Unit's configuration unlocks almost endless opportunities.
A simple Unit configuration can be used to decide where a request should be
routed or rewritten to by creating the values for **pass** and **rewrite**
dynamically inside a JavaScript function.

Previously JavaScript modules had access to a
{doc}`limited set of objects and scalars <../../scripting>`. Now JavaScript has
access to all of {ref}`Unit's variables <configuration-variables>` through
the vars object.

In the following sample configuration, we set the **Cache-Control** header
based on the HTTP method. We do this by accessing the method variable as
**vars.method**. When the method starts with a "P" (POST, PUT, PATCH),
we do not want to cache the response. For all other methods we set a **max-age**
of 3600 seconds.

```json
{
    "action": {
        "pass": "applications/my_app",
           "response_headers": {
           "Cache-Control": "`${vars.method.startsWith('P') ? 'no-cache' : 'max-age=3600'}`"
           }
     }
}
```

## Conditional access logging {#conditional-access-logging-news}

Access logs are a great way to monitor the traffic sent to Unit.
However, you might find that certain requests, such as regular
health checks and automated UI tests, aren't ones you want
cluttering up your logs. While these checks are crucial for monitoring
the health of your services or web applications, they can significantly
increase the volume of data in your access logs, leading to unnecessary noise.

With conditional access logging, you can define rules to decide if a request
should be logged or not.

```json
{
    "access_log": {
        "if": "`${uri == '/health' ? false : true}`",
        "path": "/var/log/unit/access.log",
        "format": "`${host + ': ' + uri}`"
    }
}
```

In this example we don't want to log any health checks sent to Unit.
As shown in our example, to get the maximum out of the newly added **if**
option, you can combine it with our JavaScript scripting feature, but this
is not a must.

The **if** option also supports simple string validation to check if a value
is present in a request or not.

```json
{
    "access_log": {
        "if": "$cookie_session",
        "path": "…"
    }
}
```

In this example Unit will check the existence of a Cookie named session
and only log requests when it exists.

## CLI enhancements

The **unitc** command line tool is a convenient way of applying and editing Unit
configuration without constructing lengthy **curl(1)** commands or knowing where
the control socket is located. Unit 1.32.0 includes two useful enhancements to
**unitc** that are included in the official packages.

A Docker container ID can now be specified as the configuration target.
To access the configuration of a local Unit container, use the **docker://**
scheme to specify the container ID or name.

It is now also possible to convert Unit's configuration to and from YAML.
This can be convenient when a more compact format is desirable, such as when
storing it in a source control system. YAML format also provides an elegant way
of displaying Unit's usage statistics without the noise" of JSON.

Let's combine these two enhancements to display a compact form of Unit's usage
statistics from a Docker container:

```bash
$ unitc docker://f4f3d9e918e6 /status --format YAML
connections:
  accepted: 1067
  active: 13
  idle: 4
  closed: 1050
requests:
  total: 1307
applications:
  my_app:
     processes:
        running: 14
        starting: 0
        idle: 4
     requests:
        active: 10
```

Note that the [yq(1)](https://github.com/mikefarah/yq#install) tool is required
for YAML format conversion.

## Unit is now on GitHub!

This release is special! Special for us and the Community! As you may have
noticed we have moved more and more of our development and planning workloads
from our old systems to [GitHub](https://github.com/nginx/unit/).

GitHub is no longer just a read-only mirror. It now serves as the primary
source for our source code and tests. We invite you to create
[issues](https://github.com/nginx/unit/issues), contribute through
[pull requests](https://github.com/nginx/unit/pulls), or join our
[discussions](https://github.com/nginx/unit/discussions). There are many
ways to get involved with us.

We've also fully transitioned the development and maintenance of unit.nginx.org
to the [Github unit-docs](https://github.com/nginx/unit-docs/) repository.
We look forward to pull requests and issues that will improve our documentation.

## Changes in behavior and other updates

### Docker image uses **stderr**, so now you can send **access_log** to stdout

With 1.32.0 the **unit.log** file is symlinked to the container's
**/dev/stderr** instead of **/dev/stdout**. This leaves room for the
*access_log* to be redirected to **/dev/stdout** and will not populate
the Unit log messages to **stdout** which might be scraped by log collectors.

### unit.nginx.org/download/ is now sources.nginx.org/unit/

We have moved the location of the Unit tarballs from "unit.nginx.org/download/"
to a new, central source archive for NGINX:
[sources.nginx.org/unit/](https://sources.nginx.org/unit/).

The old link is currently proxying to the new location, but officially
deprecated now! Please update to the new location "sources.nginx.org/unit/".

## Wall of fame

Special Thanks to all external contributors helping us
making Unit better! With 1.32.0 we would like to send a shout out to:

- Alejandro Colomar
- Alex Crichton
- Andrei Vasiliu
- Chris Adams
- David Carlier
- Dean Coakley
- rustedsword
- Hippolyte Pello
- Javier Evans

## Full Changelog

```none
Changes with Unit 1.32.0                                         27 Feb 2024

  *) Feature: WebAssembly Components using WASI interfaces defined in
     wasi:http/proxy@0.2.0.

  *) Feature: conditional access logging.

  *) Feature: NJS variables access.

  *) Feature: $request_id variable contains a string that is formed using
     random data and can be used as a unique request identifier.

  *) Feature: options to set control socket permissions.

  *) Feature: Ruby arrays in response headers, improving compatibility
     with Rack v3.0.

  *) Feature: Python bytearray response bodies for ASGI applications.

  *) Bugfix: router could crash while sending large files. Thanks to
     rustedsword.

  *) Bugfix: serving static files from a network filesystem could lead to
     error.

  *) Bugfix: "uidmap" and "gidmap" isolation options validation.

  *) Bugfix: abstract UNIX socket name could be corrupted during
     configuration validation. Thanks to Alejandro Colomar.

  *) Bugfix: HTTP header field value encoding could be misinterpreted in
     Python module.

  *) Bugfix: Node.js http.createServer() accepts and ignores the "options"
     argument, improving compatibility with strapi applications, among
     others.

  *) Bugfix: ServerRequest.flushHeaders() implemented in Node.js module to
     make it compatible with Next.js.

  *) Bugfix: ServerRequest.httpVersion variable format in Node.js module.

  *) Bugfix: Node.js module handles standard library imports prefixed with
     "node:", making it possible to run newer Nuxt applications, among
     others.

  *) Bugfix: Node.js tarball location changed to avoid build/install
     errors.

  *) Bugfix: Go module sets environment variables necessary for building
     on macOS/arm64 systems.
```
