---
title: Unit 1.30.0 Released
weight: 300
---

We are happy to announce Unit 1.30.0! This release brings a new level of
sophistication to Unit’s configuration and enhances logging controls.

- Incoming URIs can now be rewritten as part of the routing process
- Configuration values can now be evaluated by referencing JavaScript modules
  and functions
- Each application can now write its diagnostic output to log files (or not at
  all)
- The steps taken by the router can now be logged for diagnostic purposes

Alongside 1.30.0, we are pleased to present [Docker official Images for NGINX
Unit](https://hub.docker.com/_/unit) and the new [OpenAPI specification](https://github.com/nginx/unit/blob/master/docs/unit-openapi.yaml) for
Unit’s control API.

## URI Rewrite

Rewriting the incoming URI to match the expectations of the application or
filesystem layout has been a much-requested feature. Now, the URI can be
rewritten by specifying a `rewrite` rule in a
[route action]({{< relref "/unit/configuration.md#configuration-routes-action" >}}).
.

In this example, all requests have `/api/v2` prepended to the original
URI before being passed to the application:

```json
{
    "routes": [
        {
            "action": {
                "rewrite": "/api/v2$uri",
                "pass": "applications/my_api"
            }
        }
    ]
}
```

With web applications and APIs, some URIs may need to be removed or replaced.
Unit simplifies the management of these URIs by utilizing the recursive nature
of routing. Rewritten requests can be sent back to start the routing process
again.

```json
{
    "routes": [
        {
            "match": {
                "uri": ["/api/v1/lookup", "/api/v2beta/search"]
            },
            "action": {
                "rewrite": "/api/v2/search",
                "pass": "routes"
            }
        },
        {
            "action": {
                "pass": "applications/my_api"
            }
        }
    ]
}
```

The rewritten URI can also be constructed programmatically by using JavaScript
expressions in the value. In this example, we convert all request URIs to
lowercase using the built-in capabilities of JavaScript:

```json
{
    "routes": [
        {
            "action": {
                "rewrite": "`${uri.toLowerCase()}`",
                "share": "/var/www$uri"
            }
        }
    ]
}
```

{{< note >}}
The path portion of the incoming URI is the only part that is rewritten,
and any original queries or arguments (anything following the `?`
character) are preserved.

The `$uri` and `$request_uri` variables are both updated during
the rewrite process. When using custom log formatting, use the
\$request_line variable to log the original URI.
{{< /note >}}

## Application Logging

Another new feature addresses a crucial need for diagnostics in application
management. One of the strengths of Unit is its ability to host multiple
applications simultaneously under a single daemon. However, this capability is
also a challenge when managing multiple application and error logs.

Today, we're excited to introduce per-application logging that allows you to
define the file where `stdout` and `stderr` streams will be
directed for each application. This makes it easy to access necessary log
entries when troubleshooting issues. The logging interface is independent of
the application module or language you use. As an example, let's consider a
Java SpringBoot application.

```json
"applications": {
    "my_spring_app": {
      "type": "java",
      "stdout": "/var/log/catalina.out",
      "stderr": "/var/log/spring_err.log",
      "webapp": "spring-0.0.1-SNAPSHOT.war",
      "working_directory": "/var/www/"
    }
}
```

Now, in an application configuration object, you can define a file target for
`stdout` as well as `stderr`.

By default, application logging is directed to {file}`/dev/null` (no output).
However, if `unitd` is started with the `--no-daemon` option,
application logging is sent to the console.

## Router Diagnostic Logging

Unit’s router is a powerful tool for handling incoming requests and taking
appropriate action. It's often used to offload request routing from application
frameworks, allowing Unit to serve static files and freeing up the framework to
focus on what it does best, i.e. dynamic content. However, as the
`routes` object grows in size and complexity, diagnosing why a request
was not handled as expected can be daunting.

With this release, you can now enable diagnostic logging of the routing process
to have full transparency on how each request is handled, including URI
rewrites. This feature is enabled by the `log_route` option in the
`settings/http` configuration object:

```json
{
    "settings": {
        "http": {
            "log_route": true
        }
    }
}
```

Remember the second URI rewrite example above? This is how its logs might look
after a request:

```none
<timestamp> [notice] 79575#31129125 *52 http request line "GET /api/v1/search?q=help HTTP/1.1"
<timestamp> [notice] 79575#31129125 *52 "routes/0" selected
<timestamp> [notice] 79575#31129125 *52 URI rewritten to "/api/v2/search"
<timestamp> [info] 79575#31129125 *52 "routes/0" discarded
<timestamp> [notice] 79575#31129125 *52 "routes/1" selected
```

Here, quoted route identifiers are URIs to the `/config` object in Unit's
control API, allowing direct access to more information about the route and its
corresponding action:

```console
$ unitc /config/routes/1

      {
          "action": {
              "pass": "applications/my_api"
          }
      }
```

## JavaScript Modules

Unit 1.29.0 added {doc}`NGINX JavaScript integration
<../2022/unit-1.29.0-released>`, allowing the use of JavaScript expressions in
configuration values. But managing complex JavaScript code within configuration
values can be difficult. With the latest release, JavaScript code can be
separated from configuration and managed as a standalone entity. Then, you can
use your JavaScript functions in configuration values, unlocking the full power
of configuration scripting.

JavaScript functions can extend Unit’s functionality in the following ways:

- Performing complex URI rewrites or sending `3xx` redirects
- Extracting attributes from cookies or authentication tokens for logging or
  routing
- Augmenting the router with business logic that goes beyond what `match`
  offers

As an example, let’s split clients across two versions of an application as a
[blue/green deployment](https://en.wikipedia.org/wiki/Blue-green_deployment)
on a single Unit instance.

This JavaScript module ({file}`split.js`) exports a single function that
accepts two parameters, `variant` (string) and `proportion` (number
0..1). The string `"green"` is returned if an MD5 hash of the
`variant` falls within a certain `proportion` of the address space.
MD5 produces a 128-bit value; we convert that to a positive integer and
multiply the proportion by 65536 for comparability.

```javascript
function clients(variant, proportion) {
    var c = require('crypto');
    var i = c.createHash('md5').update(variant).digest().readInt16BE() + 32768;
    return (proportion * 65536) > i ? 'green' : 'blue';
}

export default { clients }
```

JavaScript modules are managed similarly to TLS certificates in that they can
be uploaded via the control API to be referenced in the configuration. To
upload a module, `PUT` it as a resource under `/js_modules`:

```json
$ curl --unix-socket /path/to/control.sock -X PUT -d@split.js http://localhost/js_modules/split
$ # --- OR ---
$ unitc /js_modules/split < split.js
```

Now let’s use our function to decide which version of the application each
request is sent to:

```json
{
    "settings": {
        "js_module": "split"
    },

    "listeners": {
        "*:8080": {
            "pass": "`applications/${split.clients(remoteAddr,0.25)}`"
        }
    },

    "applications": {
        "blue": { … },
        "green": { … }
    }
}
```

With this configuration in place, 25% of all client IP addresses will be
directed to the `green` application, the remainder to the `blue`
application. The proportion can be changed on the fly by updating the value of
`/config/listeners/*:8080/pass`. Notice that the uploaded JavaScript
module must also be enabled in `settings`. For multiple modules, the
`js_module` value is an array of strings.

## Configurable Server Header

Unit includes a `Server` header in every response by default, identifying
itself and its version. It's recommended to exclude the version number for
security reasons in production environments. Now, this can be achieved by
setting the `server_version` value in
[settings]({{< relref "/unit/configuration.md#configuration-stngs" >}}).

## Updates for Language Modules

- Java 20 is now available on Ubuntu 23.04
- Expanded PHP’s HTTP response code range: missing files now return
  `404`, inaccessible files return `403`
- Added support for `filter_input()`

## Docker Official Images

We are thrilled that the Unit project has been recognized by Docker with
[official images on Docker Hub](https://hub.docker.com/_/unit).

Each of the Unit Docker Official Images are built from the official images for
the programming language in question. They now also support x86 and arm64
platforms.

Getting started with Unit on Docker is now as simple as:

```console
$ docker pull unit
```

Please update your automation pipelines to acquire images from
<https://hub.docker.com/_/unit>.

## OpenAPI Specification

We are glad to announce the first public release of our [OpenAPI specification](https://github.com/nginx/unit/blob/master/docs/unit-openapi.yaml) for NGINX
Unit. It aims to simplify configuring and integrating NGINX Unit deployments
and provide an authoritative source of knowledge about the control API.

Although the specification is still in the early beta stage, it is a promising
step forward for the NGINX Unit community. While working on it, we kindly ask
you to experiment and provide feedback to help improve its functionality and
usability.

## Changes in Behavior

The `configure` script for building Unit from source now has a default
`/usr/local/` value for `--prefix`, simplifying the process of
creating installable builds or packages.

Also, new configure options allow more precise control of Unit's directories,
replacing the deprecated `--incdir`, `--modules`, `--state`,
and `--tmp` options that will be removed in the future. See
`configure --help` for details.

Finally, Unix domain listen sockets are now removed when `unitd` shuts
down.

## Full Changelog

```none
Changes with Unit 1.30.0                                         10 May 2023

    *) Change: remove Unix domain listen sockets upon reconfiguration.

    *) Feature: basic URI rewrite support.

    *) Feature: NJS loadable modules support.

    *) Feature: per-application logging.

    *) Feature: conditional logging of route selection.

    *) Feature: support the keys API on the request objects in NJS.

    *) Feature: default values for 'make install' pathnames such as prefix;
       this allows to './configure && make && sudo make install'.

    *) Feature: "server_version" setting to omit the version token from
       "Server" header field.

    *) Bugfix: request header field values could be corrupted in some cases;
       the bug had appeared in 1.29.0.

    *) Bugfix: PHP error handling (added missing 403 and 404 errors).

    *) Bugfix: Perl applications crash on second responder call.
```
