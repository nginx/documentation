---
description: Analyze your software performance by instrumenting, generating, collecting,
  and exporting telemetry data.
docs: DOCS-1207
title: OpenTelemetry
toc: true
weight: 100
type:
- how-to
---

<span id="overview"></span>
## Module Overview

The module provides [OpenTelemetry](https://opentelemetry.io/) distributed tracing support. The module supports [W3C](https://w3c.github.io/trace-context/) context propagation and OTLP/gRPC export protocol.

 {{< note >}} the code of NGINX OpenTelemetry module is open source since [NGINX Open Source](https://nginx.org) 1.25.2 and <a href="../../../releases/#r30">F5 NGINX Plus Release 30</a>. The source code is available on [GitHub](https://github.com/nginxinc/nginx-otel).{{< /note >}}


<span id="install"></span>
## Installation

1. Check the [Technical Specifications]({{< relref "../../technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2. Install the OpenTelemetry module package `nginx-plus-module-otel`.

   For CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-otel
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   dnf install nginx-plus-module-otel
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-otel
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-otel
   ```

   For Alpine:

   ```shell
   apk add nginx-plus-module-otel
   ```

   For FreeBSD:

   ```shell
   pkg install nginx-plus-module-otel
   ```

   {{< note >}} the OpenTelemetry module cannot be installed on RHEL/Oracle Linux/AlmaLinux/Rocky Linux 7, Ubuntu 18.04, and Amazon Linux 2. {{< /note >}}


<span id="configure"></span>

## Configuration

After installation you will need to enable and configure the module in NGINX Plus configuration file `nginx.conf`.

1. Enable dynamic loading of the module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_otel_module.so;
   ```

2. Test the configuration and reload NGINX Plus to enable the module:

   ```shell
   nginx -t && nginx -s reload
   ```


<span id="directives"></span>
## Module directives

<span id="otel_exporter"></span>
### `otel_exporter`

**Syntax:** `otel_exporter { ... }`;

**Default:** &mdash;

**Context:** [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http)

Specifies OTel data export parameters:

- `endpoint` &mdash; the address of OTLP/gRPC endpoint that will accept telemetry data.
- `interval` &mdash; the maximum interval between two exports, by default is 5 seconds.
- `batch_size` &mdash; the maximum number of spans to be sent in one batch per worker, by default is `512`.
- `batch_count` &mdash; the number of pending batches per worker, spans exceeding the limit are dropped, by default is `4`.

**Example:**

```nginx
otel_exporter {
    endpoint    localhost:4317;
    interval    5s;
    batch_size  512;
    batch_count 4;
}
```

<br>

<span id="otel_service_name"></span>
### `otel_service_name`

**Syntax:**  `otel_service_name` <i>name</i>;

**Default:** `otel_service_name` <i>unknown_service:nginx</i>;

**Context:** [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http)

Sets the [“service.name”](https://opentelemetry.io/docs/specs/otel/resource/semantic_conventions/#service) attribute of the OTel resource.
<br>
<br>

<span id="otel_trace"></span>
### `otel_trace`

**Syntax:** `otel_trace` <i>on</i> | <i>off</i> | <i>$variable</i>;

**Default:** `otel_trace` <i>off</i>;

**Context:** [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http), [`server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [`location`](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)

Enables or disables OpenTelemetry tracing. The directive can also be enabled by specifying a variable.

**Example:**

```nginx
split_clients "$otel_trace_id" $ratio_sampler {
               10%              on;
               *                off;
}

server {
    location / {
        otel_trace         $ratio_sampler;
        otel_trace_context inject;
        proxy_pass         http://backend;
    }
}
```

<br>

<span id="otel_trace_context"></span>
### `otel_trace_context`

**Syntax:** `otel_trace_context` <i>extract</i> | <i>inject</i> | <i>propagate</i> | <i>ignore</i>;

**Default:** `otel_trace_context` <i>ignore</i>;

**Context:** [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http), [`server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [`location`](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)

Specifies how to propagate [traceparent/tracestate](https://www.w3.org/TR/trace-context/#design-overview) headers:

- `extract` &mdash; uses an existing trace context from the request, so that the identifiers of a [trace](#var_otel_trace_id) and the [parent span](#var_otel_parent_id) are inherited from the incoming request.
- `inject` &mdash; adds a new context to the request, overwriting existing headers, if any.
- `propagate` &mdash; updates the existing context (combines `extract` and `inject`).
- `ignore` &mdash; skips context headers processing.
<br>

<br>

<span id="otel_span_name"></span>
### `otel_span_name`

**Syntax:** `otel_span_name` <i>name</i>;

**Default:** &mdash;

**Context:** [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http), [`server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [`location`](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)

Defines the name of the OTel [span](https://opentelemetry.io/docs/concepts/observability-primer/#spans). By default, it is a name of the location for a request. The name can contain variables.
<br>
<br>

<span id="otel_span_attr"></span>
### `otel_span_attr`

**Syntax:** `otel_span_attr` <i>name</i> <i>value</i>;

**Default:** &mdash;

**Context:** [`http`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http), [`server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [`location`](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)

Adds a custom OTel span attribute. The value can contain variables.
<br>


<span id="span_attributes"></span>
## Default span attributes

The following [span attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/http.md) are added automatically:

- `http.method`
- `http.target`
- `http.route`
- `http.scheme`
- `http.flavor`
- `http.user_agent`
- `http.request_content_length`
- `http.response_content_length`
- `http.status_code`
- `net.host.name`
- `net.host.port`
- `net.sock.peer.addr`
- `net.sock.peer.port`


<span id="variables"></span>
## Module variables

<span id="var_otel_trace_id"></span>
### `$otel_trace_id`
the identifier of the trace the current span belongs to, for example, `56552bc4daa3bf39c08362527e1dd6c4`

<span id="var_otel_span_id"></span>
### `$otel_span_id`
the identifier of the current span, for example, `4c0b8531ec38ca59`

<span id="var_otel_parent_id"></span>
### `$otel_parent_id`
the identifier of the parent span, for example, `dc94d281b0f884ea`

<span id="var_otel_parent_sampled"></span>
### `$otel_parent_sampled`
the `sampled` flag of the parent span, can be `1` or `0`
<br>
<br>

<span id="example"></span>
## Usage examples

### Simple Tracing

Dumping all the requests could be useful even in non-distributed environment.

```nginx
http {
    otel_trace on;
    server {
        location / {
        proxy_pass http://backend;
        }
    }
}
```

### Parent-based Tracing

```nginx
http {
    server {
        location / {
            otel_trace $otel_parent_sampled;
            otel_trace_context propagate;

            proxy_pass http://backend;
        }
    }
}
```

### Ratio-based Tracing

```nginx
http {
    # trace 10% of requests
    split_clients $otel_trace_id $ratio_sampler {
        10%     on;
        *       off;
    }

    # or we can trace 10% of user sessions
    split_clients $cookie_sessionid $session_sampler {
        10%     on;
        *       off;
    }

    server {
        location / {
            otel_trace $ratio_sampler;
            otel_trace_context inject;

            proxy_pass http://backend;
        }
    }
}
```

<span id="info"></span>
## More Info

- [NGINX OpenTelemetry module on GitHub](https://github.com/nginxinc/nginx-otel)

- [NGINX Dynamic Modules]({{< relref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< relref "../../technical-specs.md" >}})
