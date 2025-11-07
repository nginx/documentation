---
title: Export NGINX instance metrics
weight: 450
toc: true
nd-docs: DOCS-1882
---

## Overview

F5 NGINX Agent now includes an embedded [OpenTelemetry](https://opentelemetry.io/) collector, streamlining observability and metric collection for NGINX instances. With this feature, you can collect:

* Metrics from NGINX Plus and NGINX Open Source
* Host metrics (CPU, memory, disk, and network activity) from VMs or Containers

{{< call-out "note" >}}
The OpenTelemetry exporter is enabled by default. Once a valid connection to the management plane is established, the Agent will automatically begin exporting metrics.
{{< /call-out >}}

### Key benefits

* Seamless Integration: No need to deploy an external OpenTelemetry Collector. All components are embedded within the Agent for streamlined observability.
* Standardized Protocol: Support for OpenTelemetry standards ensures interoperability with a wide range of observability backends, including Jaeger, Prometheus, Splunk, and more.

### Verify that metrics are exported

You can validate that metrics are successfully exported by using the methods below:

- **NGINX One dashboard**

   - When an instance has connected to NGINX One Console [See: Connect to NGINX One Console]({{< ref "/nginx-one/connect-instances/add-instance.md" >}}), you should see metrics showing on the NGINX One Console Dashboard.

- **Agent logs**

   Check the OpenTelemetry Collector logs for confirmation of successful metric processing:

   1. Open the file: `/var/log/nginx-agent/opentelemetry-collector-agent.log`
   2. Look for the following logs:

      ```text
      Everything is ready. Begin running and processing data.
      ```

### Custom OTel Configuration 

NGINX Agent generates a default OpenTelemetry config (located at `/etc/nginx-agent/opentelemetry-collector-agent.yaml`) to send metrics to your management plane. An option is provided to 
bring your own [OpenTelemetry configs](https://opentelemetry.io/docs/collector/configuration/) which will be merged with the NGINX Agent default config.

The **order of the OpenTelemetry config files matters**: the last config in the list will take priority over others listed, if they have the same value configured.

To have NGINX Agent use your own OpenTelemetry config:

1. Edit the configuration file as root `vim /etc/nginx-agent/nginx-agent.conf`
2. Add the collector property
3. Save and restart the NGINX agent service `sudo systemctl restart nginx-agent`

```yaml
collector:
  additional_config_paths:
    - "/etc/nginx-agent/my_config.yaml"
```

#### Example usage

{{< call-out "important" >}} NGINX Agent uses `/default` for naming its default processors, exporters and pipelines using the same naming in your own config might cause issues with sending metrics to your management plane {{< /call-out >}}

- **Add Prometheus Exporter**

{{< tabs name="prometheus-exporter" >}}
{{% tab name="NGINX Plus" %}}

```yaml
exporters:
  prometheus:
    endpoint: "127.0.0.1:5643"
    resource_to_telemetry_conversion:
      enabled: true
      namespace: test-space

service:
  pipelines:
    metrics/prometheus-example-pipeline:
      receivers:
        - nginxplus
      processors:
        - resource/default
      exporters:
        - prometheus
```

{{% /tab %}}
{{% tab name="NGINX OSS" %}}

```yaml
exporters:
  prometheus:
    endpoint: "127.0.0.1:5643"
    resource_to_telemetry_conversion:
      enabled: true
      namespace: test-space

service:
  pipelines:
    metrics/prometheus-example-pipeline:
      receivers:
        - nginx
      processors:
        - resource/default
      exporters:
        - prometheus
```

{{% /tab %}}
{{< /tabs >}}


- **Third-party OTel Collector**

{{< tabs name="third-party-collector" >}}
{{% tab name="NGINX Plus" %}}

```yaml
exporters:
  otlp/local-collector:
    endpoint: "my-local-collector.com:443"
    timeout: 10s
    retry_on_failure:
      enabled: true
      initial_interval: 10s
      max_interval: 60s
      max_elapsed_time: 10m
    tls:
      insecure: true

service:
  pipelines:
    metrics/otlp-example-pipeline:
      receivers:
        - nginxplus
      processors:
        - resource/default
      exporters:
        - otpl/local-collector
```

{{% /tab %}}
{{% tab name="NGINX OSS" %}}

```yaml
exporters:
  otlp/local-collector:
    endpoint: "my-local-collector.com:443"
    timeout: 10s
    retry_on_failure:
      enabled: true
      initial_interval: 10s
      max_interval: 60s
      max_elapsed_time: 10m
    tls:
      insecure: true

service:
  pipelines:
    metrics/otlp-example-pipeline:
      receivers:
        - nginx
      processors:
        - resource/default
      exporters:
        - otpl/local-collector
```

{{% /tab %}}
{{< /tabs >}}


- **Add Debug Exporter**

{{< tabs name="debug-exporter" >}}
{{% tab name="NGINX Plus" %}}

```yaml
exporters:
  debug:
    verbosity: detailed
    sampling_initial: 5
    sampling_thereafter: 200

service:
  pipelines:
    metrics/debug-example-pipeline:
      receivers:
        - nginxplus
      processors:
        - resource/default
      exporters:
        - debug
```

{{% /tab %}}
{{% tab name="NGINX OSS" %}}

```yaml
exporters:
  debug:
    verbosity: detailed
    sampling_initial: 5
    sampling_thereafter: 200

service:
  pipelines:
    metrics/debug-example-pipeline:
      receivers:
        - nginx
      processors:
        - resource/default
      exporters:
        - debug
```

{{% /tab %}}
{{< /tabs >}}



### Troubleshooting

To view the merged OpenTelemetry configuration set the NGINX Agent log level to "debug" in `/etc/nginx-agent/nginx-agent.conf`, and restart NGINX Agent:

1. Edit the configuration file `sudo vim /etc/nginx-agent/nginx-agent.conf`
1. Change the log property
   ```yaml
   log:
     level: debug 
