---
# We use sentence case and present imperative tone
title: "Enable OpenTelemetry"
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NIC
---

This topic describes how to enable [OpenTelemetry](https://opentelemetry.io/) for F5 NGINX Ingress Controller using the [native NGINX module](https://nginx.org/en/docs/ngx_otel_module.html).

## Before you begin

To complete this guide, you need the following pre-requisites:

- An [NGINX Ingress Controller installation]({{< ref "/nic/installation/" >}}) with OpenTelemetry (v5.1.0+)

## Load the OpenTelemetry module

To enable OpenTelemetry, you must first load the module by adding the [_otel-exporter-endpoint_ ConfigMap key]({{< ref "/nic/configuration/global-configuration/configmap-resource.md#modules" >}}), which takes an endpoint argument.

The following is an example of a OpenTelemetry collector running in your cluster as the target for exporting data:

```yaml
otel-exporter-endpoint: "http://otel-collector.default.svc.cluster.local:4317"
```

A complete ConfigMap example with all OpenTelemetry options could look as follows:

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/shared-examples/otel/nginx-config.yaml" >}}

## Enable OpenTelemetry

Once you have loaded the module, you can now enable OpenTelemetry.

You can configure it globally for all resources, or on a per resource basis.

### Global

To enable OpenTelemetry for all resources, set the _otel-trace-in-http_ ConfigMap key to `true`:

```yaml
otel-trace-in-http: "true"
```

### Per resource

You can configure OpenTelemetry on a per resource basis in NGINX Ingress Controller.

For this functionality, you must [enable snippets]({{< ref "/nic/configuration/ingress-resources/advanced-configuration-with-snippets.md" >}}) with the `-enable-snippets` command-line argument.

Based on the state of global configuration, you can selectively enable or disable metrics for each resource.

#### Enable a specific resource or path

With OpenTelemetry **disabled** globally, you can enable it for a specific resource using the server snippet annotation:

```yaml
nginx.org/server-snippets: |
    otel_trace on;
```

You can enable it for specific paths using [Mergeable Ingress resources]({{<  ref "/nic/configuration/ingress-resources/cross-namespace-configuration.md" >}}).

Use the server snippet annotation for the paths of a specific Minion Ingress resource:

```yaml
nginx.org/location-snippets: |
    otel_trace on;
```

#### Disable a specific resource or path

With OpenTelemetry **enabled** globally, you can disable it for a specific resource using the server snippet annotation:

 ```yaml
nginx.org/server-snippets: |
    otel_trace off;
```

You can disable it for specific paths using [Mergeable Ingress resources]({{<  ref "/nic/configuration/ingress-resources/cross-namespace-configuration.md" >}}).

Use the server snippet annotation for the paths of a specific Minion Ingress resource:

```yaml
nginx.org/location-snippets: |
    otel_trace off;
```

## Customize OpenTelemetry

{{< call-out "note" >}}

You cannot modify the additional directives in the _otel_exporter_ block using snippets.

{{< /call-out >}}

You can customize OpenTelemetry through the supported [OpenTelemetry module directives](https://nginx.org/en/docs/ngx_otel_module.html). 

Use the `location-snippets` ConfigMap keys or annotations to insert those directives into the generated NGINX configuration.