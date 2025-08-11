---
description: Instrument NGINX with OpenTracing-compliant requests for a range of distributed
  tracing services, such as Zipkin, Jaeger and Datadog. Note that the opentracing
  module provides the framework for recording traces; you will also need to install
  a service-specific tracing module.  This module (“tracer”) pushes traces to the
  collector and analyser provided by that service.
nd-docs: DOCS-395
title: OpenTracing
toc: true
weight: 100
type:
- how-to
---

{{< call-out "note" >}} The `nginx-plus-module-opentracing` package is no longer available in the NGINX Plus repository.{{< /call-out >}}

The module was deprecated in [NGINX Plus Release 31]({{< ref "/nginx/releases.md#r31" >}}) and removed in [NGINX Plus Release 34]({{< ref "/nginx/releases.md#r34" >}}). Its functionality has been replaced with the [OpenTelemetry]({{< ref "/nginx/admin-guide/dynamic-modules/opentelemetry.md" >}}) module.

To remove the module, follow the [Uninstalling a dynamic module]({{< ref "uninstall.md" >}}) instructions.


## More info

- [NGINX plugin for OpenTracing GitHub project](https://github.com/opentracing-contrib/nginx-opentracing)

- [NGINX dynamic modules]({{< ref "/nginx/admin-guide/dynamic-modules/dynamic-modules.md" >}})

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
