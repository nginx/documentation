---
title: Monitoring and Tracing
toc: true
description: Learn about the monitoring and tracing features available in F5 NGINX
  Service Mesh.
weight: 20
nd-docs: DOCS-693
type:
- how-to
---

## Overview

F5 NGINX Service Mesh can integrate with your Prometheus, Grafana, and tracing backends for exporting metrics and tracing data.

If you do not have Prometheus, Grafana, or tracing backends deployed, you can follow the [Observability Tutorial]( {{< ref "/mesh/tutorials/observability.md" >}}) to deploy a basic demo setup.

{{< call-out "important" >}}
In order to prevent automatic sidecar injection into your Prometheus, Grafana, and tracing deployments, they should be deployed in a namespace where auto-injection is disabled. Alternatively, you can disable auto-injection for these deployments specifically by adding the `injector.nsm.nginx.com/auto-inject: disabled` label to the *PodTemplateSpec* of the deployments.
{{< /call-out >}}

### Prometheus

{{< call-out "warning" >}}
We do not currently support Prometheus deployments running with TLS encryption.
{{< /call-out >}}

To use NGINX Service Mesh with your Prometheus deployment:

1. Connect your existing Prometheus Deployment to NGINX Service Mesh:

   The expected address format is `<service-name>.<namespace>:<port>`

   - *At deployment*:

      Run the `nginx-meshctl deploy` command with the `--prometheus-address` flag.

      For example:

      ```bash
      nginx-meshctl deploy ...  --prometheus-address "my-prometheus.example-namespace:9090"
      ```

   - *At runtime*:

      You can use the [NGINX Service Mesh API]({{< ref "api-usage.md#modifying-the-global-mesh-configuration" >}})
      to update the Prometheus address that the control plane uses to get metrics.

      The example below demonstrates how to update the `meshconfig` resource:

      ```yaml
      spec:
         prometheusAddress: my-prometheus.example-namespace:9090
      ```

1. Add the `nginx-mesh-sidecars` scrape config to your Prometheus configuration.
   If you are deploying NGINX Plus Ingress Controller with the NGINX Service Mesh, add the `nginx-plus-ingress` scrape config as well.
   Consult the [Metrics]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#nginx-plus-ingress-controller-metrics" >}} ) section of the NGINX Ingress Controller Deployment tutorial for more information about the metrics collected.

   - {{< icon "download" >}} {{< link "/examples/nginx-mesh-sidecars-scrape-config.yaml" "`nginx-mesh-sidecars-scrape-config.yaml`" >}}
   - {{< icon "download" >}} {{< link "/examples/nginx-plus-ingress-scrape-config.yaml" "`nginx-plus-ingress-scrape-config.yaml`" >}}

{{< call-out "note" >}}
For more information on how to view and understand the metrics that we track, see our [Prometheus Metrics]({{< ref "prometheus-metrics.md" >}}) guide.
{{< /call-out>}}

### Grafana
The custom NGINX Service Mesh Grafana dashboard `NGINX Mesh Top` can be imported into your Grafana instance.
For instructions and a list of features, see the [Grafana example](https://github.com/nginxinc/nginx-service-mesh/tree/main/examples/grafana) in the `nginx-service-mesh` GitHub repo.


### Tracing with OpenTelemetry

NGINX Service Mesh can export tracing data using `OpenTelemetry`. Tracing data can be exported to an OpenTelemetry Protocol (OTLP) gRPC Exporter, such as the [OpenTelemetry (OTEL) Collector](https://opentelemetry.io/docs/collector/), which can then export data to one or more upstream collectors like [Jaeger](https://www.jaegertracing.io/), [DataDog](https://docs.datadoghq.com/tracing/), LightStep, or many others. Before installing the mesh, deploy an OTEL Collector that is [configured to export data](https://opentelemetry.io/docs/collector/configuration/#exporters) to an upstream collector that you have already deployed or have access to.

Tracing relies on the trace headers passed through each microservice in an application in order to build a full trace of a request. If you don't configure your app to pass trace headers, you'll get disjointed traces that are more difficult to understand. See the [OpenTelemetry Instrumentation](https://opentelemetry.io/docs/instrumentation/) guide for information on how to instrument your application to pass trace headers.

- *At deployment*:

   Use the `--telemetry-exporters` flag to point the mesh to your OTLP exporter:

   ```bash
   nginx-meshctl deploy ... --telemetry-exporters "type=otlp,host=otel-collector.example-namespace.svc,port=4317"
   ```

   You can set the desired sampler ratio to use for tracing by adding the `--telemetry-sampler-ratio` flag to your deploy command.
   The sampler ratio must be a float between `0` and `1`. The sampler ratio sets the probability of sampling a span; this means that a sampler ratio of `0.1` sets a 10% probability the span is sampled. For example:

   ```bash
   nginx-meshctl deploy ... --telemetry-sampler-ratio 0.1
   ```

- *At runtime*:

   You can use the [NGINX Service Mesh API]({{< ref "api-usage.md#modifying-the-global-mesh-configuration" >}}) to update the telemetry configuration.

   The example below demonstrates how to update the `meshconfig` resource:

   ```yaml
   telemetry:
      exporters:
         otlp:
            host: otel-collector.example-namespace.svc
            port: 4317
      samplerRatio: 0.1
   ```

If configured correctly, tracing data that is generated or propagated by the NGINX Service Mesh sidecar will be exported to the OTEL Collector, and then exported to the upstream collector(s), as shown in the following example diagram:

{{< img src="img/opentelemetry.png" alt="OpenTelemetry Data Flow" >}}
*Tracing data flow using the OpenTelemetry Collector*
