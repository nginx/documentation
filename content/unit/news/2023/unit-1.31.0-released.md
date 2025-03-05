---
title: Unit 1.31.0 Released
weight: 200
---

We are delighted to announce Unit 1.31.0, which marks a significant milestone
following the release of 1.30 in May. Over the past 15 weeks, our dedicated
team has been hard at work developing an innovative language module for NGINX
Unit. We are excited to introduce the Unit WebAssembly (WASM) feature as part
of this release, which represents a significant leap forward in Unit's
capabilities.

This is a technology preview of WebAssembly support in Unit, and we look
forward to learning more about the use cases and ideas that the community will
share with us.

This release also brings a notable addition to our repertoire - the ability to
send response headers and harness the power of response header variables within
the configuration. These enhancements will greatly increase the flexibility and
customization options available to you.

Complementing these key advancements, we have carefully addressed a spectrum of
minor bug fixes and introduced additional refinements to ensure a seamlessly
enhanced user experience.

- Thanks to our newest contributor,
  [synodriver](https://github.com/nginx/unit/commits?author=synodriver)
  for adding Python support to ASGI `lifespan_state`
- the `unitc` CLI tool now provides interactive editing of
  configuration URIs

## Server-Side WebAssembly: Technology Preview

WebAssembly adoption has grown rapidly over the past two years. The flexibility
that comes with this new binary format is remarkable. In particular,
server-side WebAssembly offers many advantages for application developers.
Since Unit already provides native support for various programming language
runtimes, it was a natural progression to take on the challenge of adding
server-side WebAssembly support to NGINX Unit.

Unit can now run WebAssembly modules as a native application type. Read more in
our blog post:
[Introducing a Technology Preview for Server-Side WebAssembly on NGINX Unit](https://www.nginx.com/blog/server-side-webassembly-nginx-unit/).

## Working with Response Headers

Having full control over the HTTP response headers sent back to the client is a
feature our community has been waiting for. With 1.31, we are adding support
for adding, removing, or overriding HTTP response headers using the Unit router
and using the values in dedicated response header variables. Let's see what we
can do with 1.31 and response headers.

### Set Response Headers

As mentioned above, you use Unit’s router to add, remove, or override response
headers. In most cases, the router will already be in use. If your listener
points to a router object like this, you are good to go.

```json
{
    "listeners": {
        "*:80": {
            "pass": "routes"
        }
    }
}
```

If not, and you are new to the world of Unit Routes, be sure to read the
[documentation]({{< relref "/unit/configuration.md#configuration-routes" >}})
before diving into this new
feature.

Let's start with a simple use case. We are using Unit to host a frontend along
with a web API. The languages or the Unit application object do not really
matter in this case. The current configuration looks like this:

```json
{
    "listeners": {
        "*:8080": {
            "pass": "routes/app"
        }
    },

    "routes": {
        "app": [
            {
                "match": {
                    "uri": [
                        "/api/*"
                    ]
                },

                "action": {
                    "pass": "applications/api"
                }
            },
            {
                "action": {
                    "share": [
                        "/var/www/frontend$uri",
                        "/var/www/frontend/index.html"
                    ]
                }
            }
        ]
    }
}
```

A newly introduced `response_headers` object can be added to any
`action` object. The `response_headers` object contains a list of
key/value pairs, each of which defines a single header. If a header name
matches a response header already present in the response, its value is
replaced. Otherwise, a new response header is created. A value of `null`
omits the header from the response. An empty string does not. Let's change the
configuration to demonstrate what all this means. First, we want to hide an
`X-Version` header sent by the API application:

```json
{
    "action": {
        "pass": "applications/api",
        "response_headers": {
            "X-Version": null
        }
    }
}
```

For our front-end, we want to add a version hash to identify the deployed
version without digging into the sources:

```json
{
    "action": {
        "share": [
            "/var/www/frontend$uri",
            "/var/www/frontend/index.html"
        ],
        "response_headers": {
            "X-FE-Version": "abc1234def"
        }
    }
}
```

In addition to fixed values, you can call an NJS function to create a value
using some more complex rules. To do this, use a template literal:

```json
"Upper-Case": "`${host.toUpperCase()}`"
```

If this sounds all new to you, read more about the NGINX JavaScript Engine in
Unit in our [documentation]({{< relref "/unit/scripting.md" >}}).

### Use Response Header Variables

With 1.31 and the ability to control response headers, we have added a new set
of variables. When Unit receives a response from an application hosted on Unit,
and you want to modify an existing response header based on the value that was
shared by the application, it becomes imperative for Unit to retain that
specific value. This is where the newly introduced response header variables
come into play.

The format of the new variables is based on other variables that Unit already
supports in the router. To retrieve the value of a particular HTTP header, use
`response_header` as the key identifier, followed by
`name_of_the_header` enclosed in `${}`. If you are new to using
variables with Unit during request processing, use this
[documentation]({{< relref "/unit/configuration.md#configuration-variables" >}})
to learn more. Let's look at this through an example
use case.

In the following configuration, we want to add a charset to the
`Content-Type` response header that was already set by the application:

```json
[
    {
        "action": {
            "pass": "applications/calc",
            "response_headers": {
                "Content-Type": "${response_header_content_type};charset=iso-8859-1"
            }
        }
    }
]
```

Since the `Content-Type` header already exists in the response, Unit will
change its value.

## CLI Interactive Mode

In 1.29, we introduced a wrapper script for curl to simplify interaction with
the Unit API. In 1.31, we added an interactive edit mode to this script:

```console
$ unitc EDIT /config
```

This opens the given endpoint's JSON configuration in the editor currently
defined in `$EDITOR`. In most cases this will default to
`nano`. If you want to use something else, like `vim`:

```console
$ EDITOR=vim unitc EDIT /config
```

Saving the changes automatically applies the changes and reconfigures Unit.

## Changes in Behavior

Nothing new here.

## Full Changelog

```none
Changes with Unit 1.31.0                                         31 Aug 2023

    *) Change: if building with njs, version 0.8.0 or later is now required.

    *) Feature: technology preview of WebAssembly application module.

    *) Feature: "response_headers" option to manage headers in the action
       and fallback.

    *) Feature: HTTP response header variables.

    *) Feature: ASGI lifespan state support. Thanks to synodriver.

    *) Bugfix: ensure that $uri variable is not cached.

    *) Bugfix: deprecated options were unavailable.

    *) Bugfix: ASGI applications inaccessible over IPv6.
```
