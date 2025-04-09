---
description: Create an OpenTelemetry Protocol (OTLP) Integration for F5 NGINX Controller.
docs: DOCS-565
title: OTLP Integration
weight: 30
---

## OTLP Integration Requirements

Confirm that your OpenTelemetry Collector server meets the following configuration requirements:

### Transport protocol

The OpenTelemetry Collector server should be configured to allow the following OTLP receiver protocols:

- HTTP  - for unencrypted connections.
- HTTPS - for encrypted connections. Certificate validation and mutual TLS are **not** supported.
- gRPC  - for unencrypted gRPC connections.
- gRPC + TLS - for encrypted gRPC connections. Certificate validation and mutual TLS are **not** supported.

### OTLP protocol

The server should expose the OTLP receiver.

The forwarder produces an OTLP protocol `ExportMetricsServiceRequest` message with the following restrictions:

- every metric is mapped to `Gauge`.
- unit is set to `1`(no unit).
- the `ResourceMetrics` fields for `SchemaUrl` and `Resource` are empty.
- the `InstrumentationLibraryMetric` fields for `InstrumentationLibrary` and `SchemaUrl` are empty.

### Authentication

Authentication is currently not supported.

### Example configuration for OpenTelemetry Collector

The following example configuration for OpenTelemetry Collector can receive OTLP on HTTP and HTTPS endpoints and forward it to DataDog:

```yaml
receivers:
  otlp/https:
    protocols:
      http:
        endpoint: "0.0.0.0:4318"
        tls_settings:
          cert_file: /etc/otel/server.crt
          key_file: /etc/otel/server.key
  otlp/http:
    protocols:
      http:
        endpoint: "0.0.0.0:4319"
  otlp/grpc_tls:
    protocols:
      grpc:
        endpoint: "0.0.0.0:4418"
        tls_settings:
          cert_file: /etc/otel/server.crt
          key_file: /etc/otel/server.key
  otlp/grpc:
    protocols:
      grpc:
        endpoint: "0.0.0.0:4419"
exporters:
    datadog:
        api:
          key: key
service:
  pipelines:
    metrics/1:
      receivers: [otlp/http, otlp/https, otlp/grpc_tls, otlp/grpc]
      exporters: [datadog]
```

## Add an OTLP Integration

Take the following steps to create an integration for OpenTelemetry Collector:

1. Open the F5 NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select **Create Integration**.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. In the **Integration Type** list, select `GENERIC_INTEGRATION`.
10. In the **Endpoint URI** box, add the one of HTTP, HTTPS, gRPC or gRPC+TLS endpoint for your OpenTelemetry Collector. This is the same address that's configured in the OpenTelemetry Collector config in the receivers section. See the [example config]({{< ref "/controller/platform/integrations/otlp-integration.md#example-configuration-for-opentelemetry-collector" >}}):

    - HTTP endpoint should be `http://collector_ip:4319`
    - HTTPS endpoint should be `https://collector_ip:4318`
    - gRPC endpoint should be `tcp://collector_ip:4419`
    - gRPC with TLS endpoint should be `tcp+tls://collector_ip:4418`

11. In the **Credential Type** list, select `UNAUTHENTICATED` (at this time we do not support any authentication methods).
12. Select **Submit**.
