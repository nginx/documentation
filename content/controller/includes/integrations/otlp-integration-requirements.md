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
- unit is set to `1 `(no unit).
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

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-554 -->