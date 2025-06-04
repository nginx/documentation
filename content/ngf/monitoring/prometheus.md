---
title: Monitoring with Prometheus and Grafana
weight: 200
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1418
---

This document describes how to monitor NGINX Gateway Fabric using Prometheus and Grafana. It explains installation and configuration, as well as what metrics are available.

## Overview

NGINX Gateway Fabric metrics are displayed in [Prometheus](https://prometheus.io/) format. These metrics are served through a metrics server orchestrated by the controller-runtime package on HTTP port `9113`. When installed, Prometheus automatically scrapes this port and collects metrics. [Grafana](https://grafana.com/) can be used for rich visualization of these metrics.

{{< call-out "important" "Security note for metrics" >}}

Metrics are served over HTTP by default. Enabling HTTPS will secure the metrics endpoint with a self-signed certificate. When using HTTPS, adjust the Prometheus Pod scrape settings by adding the `insecure_skip_verify` flag to handle the self-signed certificate. For further details, refer to the [Prometheus documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#tls_config).

{{< /call-out >}}

## Installing Prometheus and Grafana

{{< note >}} These installations are for demonstration purposes and have not been tuned for a production environment. {{< /note >}}

### Prometheus

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus -n monitoring --create-namespace --set server.global.scrape_interval=15s
```

Once running, you can access the Prometheus dashboard by using port-forwarding in the background:

```shell
kubectl port-forward -n monitoring svc/prometheus-server 9090:80 &
```

Visit [http://127.0.0.1:9090](http://127.0.0.1:9090) to view the dashboard.

### Grafana

```shell
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana -n monitoring --create-namespace
```

Once running, you can access the Grafana dashboard by using port-forwarding in the background:

```shell
kubectl port-forward -n monitoring svc/grafana 3000:80 &
```

Visit [http://127.0.0.1:3000](http://127.0.0.1:3000) to view the Grafana UI.

The username for login is `admin`. The password can be acquired by running:

```shell
kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

#### Configuring Grafana

In the Grafana UI menu, go to `Connections` then `Data sources`. Add your Prometheus service (`http://prometheus-server.monitoring.svc`) as a data source.

Download the following sample dashboard and Import as a new Dashboard in the Grafana UI.

- {{< download "ngf/grafana-dashboard.json" "ngf-grafana-dashboard.json" >}}

## Available metrics in NGINX Gateway Fabric

NGINX Gateway Fabric provides a variety of metrics for monitoring and analyzing performance. These metrics are categorized as follows:

### NGINX/NGINX Plus metrics

NGINX metrics include NGINX-specific data such as the total number of accepted client connections. These metrics are
collected through NGINX Agent and are reported by each NGINX Pod.

NGINX Gateway Fabric currently supports a subset of all metrics available through NGINX OSS and Plus. Listed below are
the supported metrics along with a small accompanying description.

Metrics provided by NGINX Open Source include:
- `nginx_http_connection_count_connections`: The current number of connections.
- `nginx_http_connections_total`: The total number of connections, since NGINX was last started or reloaded.
- `nginx_http_request_count_requests`: The total number of client requests received, since the last collection interval.
- `nginx_http_requests_total`: The total number of client requests received, since NGINX was last started or reloaded.

In addition to the previous metrics provided by NGINX Open Source, NGINX Plus includes:
- `nginx_config_reloads_total`: The total number of NGINX config reloads.
- `nginx_http_response_count_responses`: The total number of HTTP responses sent to clients since the last collection interval, grouped by status code range.
- `nginx_http_response_status_responses_total`: The total number of responses since NGINX was last started or reloaded, grouped by status code range.
- `nginx_http_request_discarded_requests_total`: The total number of requests completed without sending a response.
- `nginx_http_request_processing_count_requests`: The number of client requests that are currently being processed.
- `nginx_http_request_byte_io_bytes_total`: The total number of HTTP byte IO.
- `nginx_http_upstream_keepalive_count_connections`: The current number of idle keepalive connections per HTTP upstream.
- `nginx_http_upstream_peer_connection_count_connections`: The average number of active connections per HTTP upstream peer.
- `nginx_http_upstream_peer_byte_io_bytes_total`: The total number of byte IO per HTTP upstream peer.
- `nginx_http_upstream_peer_count_peers`: The current count of peers on the HTTP upstream grouped by state.
- `nginx_http_upstream_peer_fails_attempts_total`: The total number of unsuccessful attempts to communicate with the HTTP upstream peer.
- `nginx_http_upstream_peer_header_time_milliseconds`: The average time to get the response header from the HTTP upstream peer.
- `nginx_http_upstream_peer_health_checks_requests_total`: The total number of health check requests made to a HTTP upstream peer.
- `nginx_http_upstream_peer_requests_total`: The total number of client requests forwarded to the HTTP upstream peer.
- `nginx_http_upstream_peer_response_time_milliseconds`: The average time to get the full response from the HTTP upstream peer.
- `nginx_http_upstream_peer_responses_total`: The total number of responses obtained from the HTTP upstream peer grouped by status range.
- `nginx_http_upstream_peer_state_is_deployed`: Current state of an upstream peer in deployment.
- `nginx_http_upstream_peer_unavailables_requests_total`: Number of times the server became unavailable for client requests (“unavail”).
- `nginx_http_upstream_queue_limit_requests`: The maximum number of requests that can be in the queue at the same time.
- `nginx_http_upstream_queue_overflows_responses_total`: The total number of requests rejected due to the queue overflow.
- `nginx_http_upstream_queue_usage_requests`: The current number of requests in the queue.
- `nginx_http_upstream_zombie_count_is_deployed`: The current number of upstream peers removed from the group but still processing active client requests.
- `nginx_slab_page_free_pages`: The current number of free memory pages.
- `nginx_slab_page_usage_pages`: The current number of used memory pages.
- `nginx_slab_slot_allocations_total`: The number of attempts to allocate memory of specified size.
- `nginx_slab_slot_free_slots`: The current number of free memory slots.
- `nginx_slab_slot_usage_slots`: The current number of used memory slots.
- `nginx_ssl_certificate_verify_failures_certificates_total`: The total number of SSL certificate verification failures.
- `nginx_ssl_handshakes_total`: The total number of SSL handshakes.

### NGINX Gateway Fabric metrics

Metrics specific to NGINX Gateway Fabric include:

- `event_batch_processing_milliseconds`: Time in milliseconds to process batches of Kubernetes events.

All these metrics are under the `nginx_gateway_fabric` namespace and include a `class` label set to the GatewayClass of NGINX Gateway Fabric. For example, `nginx_gateway_fabric_event_batch_processing_milliseconds_sum{class="nginx"}`.

### Controller-runtime metrics

Provided by the [controller-runtime](https://github.com/kubernetes-sigs/controller-runtime) library, these metrics include:

- General resource usage like CPU and memory.
- Go runtime metrics such as the number of Go routines, garbage collection duration, and Go version.
- Controller-specific metrics, including reconciliation errors per controller, length of the reconcile queue, and reconciliation latency.

## Change the default metrics configuration

You can configure monitoring metrics for NGINX Gateway Fabric using Helm or Manifests.

### Using Helm

If you're setting up NGINX Gateway Fabric with Helm, you can adjust the `metrics.*` parameters to fit your needs. For detailed options and instructions, see the [Helm README](https://github.com/nginx/nginx-gateway-fabric/blob/v{{< version-ngf >}}/charts/nginx-gateway-fabric/README.md).

### Using Kubernetes manifests

For setups using Kubernetes manifests, change the metrics configuration by editing the NGINX Gateway Fabric manifest that you want to deploy. You can find some examples in the [deploy](https://github.com/nginx/nginx-gateway-fabric/tree/v{{< version-ngf >}}/deploy) directory.

#### Disabling metrics

If you need to disable metrics:

1. Set the `-metrics-disable` [command-line argument]({{< ref "/ngf/reference/cli-help.md">}}) to `true` in the NGINX Gateway Fabric Pod's configuration. Remove any other `-metrics-*` arguments.
2. In the Pod template for NGINX Gateway Fabric, delete the metrics port entry from the container ports list:

   ```yaml
   - name: metrics
     containerPort: 9113
   ```

3. Also, remove the following annotations from the NGINX Gateway Fabric Pod template:

   ```yaml
   annotations:
     prometheus.io/scrape: "true"
     prometheus.io/port: "9113"
   ```

#### Changing the default port

To change the default port for metrics:

1. Update the `-metrics-port` [command-line argument]({{< ref "/ngf/reference/cli-help.md">}}) in the NGINX Gateway Fabric Pod's configuration to your chosen port number.
2. In the Pod template, change the metrics port entry to reflect the new port:

   ```yaml
   - name: metrics
     containerPort: <new-port>
   ```

3. Modify the `prometheus.io/port` annotation in the Pod template to match the new port:

   ```yaml
   annotations:
       <...>
       prometheus.io/port: "<new-port>"
       <...>
   ```

#### Enabling HTTPS for metrics

For enhanced security with HTTPS:

1. Enable HTTPS security by setting the `-metrics-secure-serving` [command-line argument]({{< ref "/ngf/reference/cli-help.md">}}) to `true` in the NGINX Gateway Fabric Pod's configuration.

2. Add an HTTPS scheme annotation to the Pod template:

   ```yaml
   annotations:
       <...>
       prometheus.io/scheme: "https"
       <...>
   ```
