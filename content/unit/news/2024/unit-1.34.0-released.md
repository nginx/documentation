---
title: Unit 1.34.0 Released
weight: 100
---

We are pleased to announce the release of NGINX Unit 1.34.0. This release
includes a number of new features and changes:

## JSON formatted access logs

This release introduces the ability to specify a JSON format for access logs.

When defining an access log you can specify 'format' as an object defining
JSON field name/value pairs, e.g.

```json
{
    "access_log": {
        "path": "/tmp/access.log",
        "format": {
            "remote_addr": "$remote_addr",
            "time_local": "$time_local",
            "request_line": "$request_line",
            "status": "$status",
            "body_bytes_sent": "$body_bytes_sent",
            "header_referer": "$header_referer",
            "header_user_agent": "$header_user_agent"
        }
    }
}
```

The JSON *values* support being strings, variables and JavaScript.

## OpenTelemetry (OTEL)

This release includes initial support for OpenTelemtry (OTEL)
\<<https://opentelemetry.io/>>

This support has been added via the OpenTelemetry Rust SDK and as such
requires cargo/rust to build.

An example configuration looks like

```json
{
   "listeners": {
        "[::1]:8080": {
            "pass": "routes"
        }
    },

    "settings": {
        "telemetry": {
            "batch_size": 20,
            "endpoint": "http://example.com/v1/traces",
            "protocol": "http",
            "sampling_ratio": 1
        }
    },

     "routes": [
        {
            "match": {
                "headers": {
                    "accept": "*text/html*"
                }
            },
            "action": {
                "share": "/usr/share/unit/welcome/welcome.html"
            }
        }, {
            "action": {
                "share": "/usr/share/unit/welcome/welcome.md"
            }
        }
    ]
}
```

- **endpoint**

  The endpoint for the OpenTelemetry (OTEL) Collector. This is required.

  The value must be a URL to either a gRPC or HTTP endpoint.

- **protocol**

  Determines the protocol used to communicate with the endpoint. This is
  required.

  Can be either "http" or "grpc".

- **batch_size**

  Number of spans to cache before triggering a transaction with the
  configured endpoint. This is optional.

  This allows the user to cache up to N spans before the OpenTelemetry
  (OTEL) background thread sends spans over the network to the collector.

  Must be a positive integer.

- **sampling_ratio**

  Percentage of requests to trace. This is optional.

  This allows the user to only trace anywhere from 0% to 100% of requests
  that hit Unit. In high throughput environments this percentage should be
  lower. This allows the user to save space in storing span data, and to
  collect request metrics like time to decode headers and whatnot without
  storing massive amounts of duplicate superfluous data.

  Must be a positive floating point number.

  This support is disabled by default but can be enabled by passing --otel
  to ./configure.

## Changes to language modules

- The Perl language module no longer adds a 'new' constructor to parsed
  scripts. It's not required and could interfere with scripts that were
  trying to use 'new' themselves.

## Changes for developers

- -funsigned-char

  We now compile Unit with -funsigned-char, this ensures we are using the
  same char type on all platforms (what you get by default varies by
  platform).

  This is also a first step in getting rid of (mostly at least) our usage of
  u_char and using char instead, which better aligns with libc interfaces and
  so on.

## Full Changelog

```none
Changes with Unit 1.34.0                                     19 Dec 2024

    *) Feature: initial OpenTelemetry (OTEL) support. (Disabled by default).

    *) Feature: support for JSON formatted access logs.

    *) Bugfix: tweak the Perl language module to avoid breaking scripts in
               some circumstances.
```
