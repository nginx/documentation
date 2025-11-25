---
title: Export NGINX instance metrics
weight: 500
toc: true
nd-docs: DOCS-1882
---

## Overview

The F5 NGINX Agent now includes an embedded [OpenTelemetry](https://opentelemetry.io) collector, streamlining observability and metric collection for NGINX instances. By default, the NGINX Agent sends key metrics to the [NGINX One Console]({{< ref "/nginx-one-console/nginx-configs/metrics/review-metrics" >}}), providing quick visibility into server performance through pre-configured dashboards.  

With this feature, you can collect: 

  - Metrics from NGINX Plus and NGINX Open Source
  - Host metrics such as CPU, memory, disk, and network activity from virtual machines (VMs) or containers
     
For users requiring deeper integration with third-party observability tools, the NGINX Agent supports exporting additional metrics through the embedded OpenTelemetry collector. Tools such as Prometheus, Splunk, and other OpenTelemetry-compatible platforms can be configured to ingest these metrics, as detailed in the rest of this document. 

{{< call-out "note" >}}
The OpenTelemetry exporter is enabled by default. Once a valid connection to the management plane is established, the NGINX Agent will automatically begin exporting metrics to the NGINX One Console.
{{< /call-out >}} 

### Key benefits

* Seamless Integration: No need to deploy an external OpenTelemetry Collector. All components are embedded within the Agent for streamlined observability.
* Standardized Protocol: Support for OpenTelemetry standards ensures interoperability with a wide range of observability backends, including Prometheus, Splunk, and more.

### Verify that metrics are exported

You can validate that metrics are successfully exported by using the methods below:

- **NGINX One dashboard**

   - When an instance has connected to NGINX One Console [See: Connect to NGINX One Console]({{< ref "/nginx-one-console/connect-instances/add-instance.md" >}}), you should see metrics showing on the NGINX One Console Dashboard.

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

{{<tabs name="custom-otel-configuration">}}

{{%tab name="VM"%}}

1. Edit the configuration file as root `vim /etc/nginx-agent/nginx-agent.conf`
1. Add the collector property
1. Save and restart the NGINX agent service `sudo systemctl restart nginx-agent`

  ```yaml
  collector:
    additional_config_paths:
      - "/etc/nginx-agent/my_config.yaml"
  ```

{{%/tab%}}

{{%tab name="Container"%}}

1. Run the Docker container: 

Use the following command to run the NGINX Agent docker container. Replace the placeholder values (`YOUR_JWT_HERE`, `DPK`, `/path/to/my_config.yaml`, and `<version-tag>`) with the appropriate values for your environment: 

  ```bash
  sudo docker run \
  --env=NGINX_LICENSE_JWT="YOUR_JWT_HERE" \
  --env=NGINX_AGENT_COMMAND_SERVER_PORT=443 \
  --env=NGINX_AGENT_COMMAND_SERVER_HOST=agent.connect.nginx.com \
  --env=NGINX_AGENT_COMMAND_AUTH_TOKEN="DPK" \
  --env=NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY=false \
  --env=NGINX_AGENT_COLLECTOR_ADDITIONAL_CONFIG_PATHS="/etc/nginx-agent/my_config.yaml" \
  --volume=/path/to/my_config.yaml:/etc/nginx-agent/my_config.yaml:ro \
  --restart=always \
  --runtime=runc \
  -d private-registry.nginx.com/nginx-plus/agentv3:<version-tag>
  ```

{{%/tab%}}

{{</tabs>}}

#### Example usage

{{< call-out "important" >}} NGINX Agent uses `/default` for naming its default processors, exporters and pipelines using the same naming in your own config might cause issues with sending metrics to your management plane {{< /call-out >}}

#### Add Prometheus Exporter Configuration

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
        - <nginxplus or nginx> # Use nginxplus for NGINX Plus or nginx for OSS
      processors:
        - resource/default
      exporters:
        - prometheus
```



#### Third-party OTel Collector

```yaml
exporters:
  otlp/local-collector:
    endpoint: "my-local-collector.com:443"

service:
  pipelines:
    metrics/otlp-example-pipeline:
      receivers:
        - nginxplus/nginx # Use nginxplus for NGINX Plus or nginx for OSS
      processors:
        - resource/default
      exporters:
        - otlp/local-collector
```

#### Add Debug Exporter

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
        - nginxplus/nginx # Use nginxplus for NGINX Plus or nginx for OSS
      processors:
        - resource/default
      exporters:
        - debug
```



### Troubleshooting

To view the merged OpenTelemetry configuration, change the NGINX Agent log level to "debug" in `/etc/nginx-agent/nginx-agent.conf`:

```yaml
 log:
   level: debug 
