---
title: Prometheus Metrics
description: How to set up and view prometheus metrics for valuable workload insights
weight: 40
toc: true
nd-docs: DOCS-840
type:
- how-to
---

## Overview

F5 NGINX Service Mesh integrates with Prometheus for metrics and Grafana for visualizations.

{{< note >}}
To configure NGINX Service Mesh to use Prometheus when deploying, refer to the [Monitoring and Tracing]( {{< ref "/mesh/guides/monitoring-and-tracing.md#prometheus" >}} ) guide for instructions.
{{< /note >}}

The mesh supports the [SMI spec](https://github.com/servicemeshinterface/smi-spec), including traffic metrics.
The NGINX Service Mesh creates an extension API Server and shim that query Prometheus and return the results in a traffic metrics format. See [SMI Traffic Metrics]( {{< ref "smi-traffic-metrics.md" >}}) for more information.

{{< note >}}
Occasionally metrics are reset when the nginx-mesh-sidecar reloads NGINX Plus. If traffic is flowing and you
fail to see metrics, retry after 30 seconds.
{{< /note >}}

If you are deploying NGINX Plus Ingress Controller with the NGINX Service Mesh, make sure to configure the NGINX Plus Ingress Controller to export metrics.
Refer to the [Metrics]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#nginx-plus-ingress-controller-metrics" >}} ) section of the NGINX Plus Ingress Controller Deployment tutorial for instructions.

### Prometheus Metrics

The NGINX Service Mesh sidecar exposes the following metrics in Prometheus format via the `/metrics` path on port 8887:

- [NGINX Plus metrics](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/prometheus-njs/#exported-metrics).
- `upstream_server_response_latency_ms`: a histogram of upstream server response latencies in milliseconds.
The response time is the time from when NGINX establishes a connection to an upstream server to when the last byte of the response body is received by NGINX.

All metrics have the namespace `nginxplus`, for example `nginxplus_http_requests_total` and `nginxplus_upstream_server_response_latency_ms_count`.

#### Examples

This section includes a set of example metrics that you may plug into your existing Prometheus-based tooling to gain insights into the traffic flowing through your applications.

##### HTTP

- View the rate of requests currently flowing:

  ```promQL
  irate(nginxplus_http_requests_total[30s])
  ```

- View unsuccessful response codes of your applications:

  ```promQL
  nginxplus_upstream_server_responses{code=~"3xx|4xx|5xx"}
  ```

  This can be used to form more complex queries such as current success rate:

  ```promQL
  sum(irate(nginxplus_upstream_server_responses{code=~"1xx|2xx"}[30s])) by (app, version) / sum(irate(nginxplus_upstream_server_responses[30s])) by (app, version)
  ```

##### UDP/TCP

- View the current throughput of clients sending to upstreams:

  ```promQL
  irate(nginxplus_stream_upstream_server_sent[30s])
  ```

- You can also see the total number of connections made:

  ```promQL
  nginxplus_stream_upstream_server_connections
  ```

- (**TCP Only**): NGINX Service Mesh exposes a whole host of latency information for TCP connections:

  ```promQL
  nginxplus_stream_upstream_server_connect_time
  ```

  ```promQL
  nginxplus_stream_upstream_server_first_byte_time
  ```

  ```promQL
  nginxplus_stream_upstream_server_response_time
  ```

#### Labels

All metrics have the following labels:

{{% table %}}
| Metric Name                           | Description                                                                                                                                                                                                          |
|---------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| job                                   | Prometheus job name. All metrics scraped from an nginx-mesh-sidecar have a job name of `nginx-mesh-sidecars`, and all metrics scraped from an NGINX Plus Ingress Controller have a job name of `nginx-plus-ingress`. |
| pod                                   | Name of the Pod.                                                                                                                                                                                                     |
| namespace                             | Namespace where the Pod resides.                                                                                                                                                                                     |
| instance                              | Address of the Pod.                                                                                                                                                                                                  |
| pod_template_hash                     | Value of the pod-template-hash Kubernetes label.                                                                                                                                                                     |
| deployment, statefulset, or daemonset | Name of the Deployment, StatefulSet, or DaemonSet that the Pod belongs to.                                                                                                                                           |
{{% /table %}}

Metrics for upstream servers, such as `nginxplus_upstream_server_requests`, have these additional labels:

{{% table %}}
| Metric Name | Description                                                                                                                                                                                                                                  |
|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| code        | Response code of the upstream server. For NGINX Plus metrics, the code will be one of the following: 1xx, 2xx, 3xx, 4xx, or 5xx. For the `upstream_server_response_latency_ms` metrics, the code is the specific response code, such as 201. |
| upstream    | Name of the upstream server group.                                                                                                                                                                                                           |
| server      | Address of the upstream server selected by NGINX.                                                                                                                                                                                            |
{{% /table %}}

Metrics for outgoing requests have the following destination labels:

{{% table %}}
| Metric Name                                                   | Description                                                                     |
|---------------------------------------------------------------|---------------------------------------------------------------------------------|
| dst_pod                                                       | Name of the Pod that the request was sent to.                                   |
| dst_service                                                   | Name of the Service that the request was sent to.                               |
| dst_deployment, dst_statefulset, or dst_daemonset             | Name of the Deployment, StatefulSet, or DaemonSet that the request was sent to. |
| dst_namespace                                                 | Namespace that the request was sent to.                                         |
{{% /table %}}

Metrics exported by NGINX Plus Ingress Controller have these additional labels:

{{% table %}}
| Metric Name        | Description                                                                                                                                                                                  |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ingress            | Set to true if ingress traffic is enabled.                                                                                                                                                   |
| egress             | Set to true if egress traffic is enabled.                                                                                                                                                    |
| class              | Ingress class of the NGINX Plus Ingress Controller.                                                                                                                                          |
| resource_type      | Type of resource: VirtualServer, VirtualServerRoute, or Ingress.                                                                                                                             |
| resource_name      | Name of the VirtualServer, VirtualServerRoute, or Ingress resource.                                                                                                                          |
| resource_namespace | Namespace of the resource. This value is kept for backwards compatibility; for consistency with NGINX Service Mesh metrics you can use `dst_namespace` for queries and filters.              |
| service            | Service the request was sent to. This value is kept for backwards compatibility; for consistency with NGINX Service Mesh metrics you can use `dst_service` for queries and filters.          |
| pod_name           | Name of the Pod that the request was sent to. This value is kept for backwards compatibility; for consistency with NGINX Service Mesh metrics you can use `dst_pod` for queries and filters. |
{{% /table %}}

##### Filter Prometheus Metrics using Labels

Here are some examples of how you can use the labels above to filter your Prometheus metrics:

- Find all upstream server responses with server side errors for deployment `productpage-v1` in namespace `prod`:

    ```promQL
    nginxplus_upstream_server_responses{deployment="productpage-v1",namespace="prod",code="5xx"}
    ```

- Find all upstream server responses with successful response codes for deployment `productpage-v1` in namespace `prod`:

    ```promQL
    nginxplus_upstream_server_responses{deployment="productpage-v1",namespace="prod",code=~"1xx|2xx"}
    ```

- Find the p99 latency of all requests sent from deployment `productpage-v1` in namespace `prod` to service `details` in namespace `prod` over the last 30 seconds:

    ```promQL
    histogram_quantile(0.99, sum(irate(nginxplus_upstream_server_response_latency_ms_bucket{namespace="prod",deployment="productpage-v1",dst_service="details"}[30s])) by (le))
    ```

- Find the p90 latency of all requests sent from deployment `productpage-v1` in namespace `prod` to service `details` in namespace `prod` over the last 30 seconds, excluding 301 response codes:

    ```promQL
    histogram_quantile(0.90, sum(irate(nginxplus_upstream_server_response_latency_ms_bucket{namespace="prod",deployment="productpage-v1",dst_service="details",code!="301"}[30s])) by (le))
    ```

- Find the p50 latency of all successful(response codes of 200, or 201) requests sent from deployment `productpage-v1` in namespace `prod` to service `details` in namespace `prod` over the last 30 seconds:

    ```promQL
    histogram_quantile(0.50, sum(irate(nginxplus_upstream_server_response_latency_ms_bucket{namespace="prod",deployment="productpage-v1",dst_service="details",code=~"200|201"}[30s])) by (le))
    ```

- Find all active connections for the NGINX Plus Ingress Controller:

    ```promQL
    nginxplus_connections_active{job="nginx-plus-ingress"}
    ```

### Grafana

The custom NGINX Service Mesh Grafana dashboard `NGINX Mesh Top` can be imported into your Grafana instance.
For instructions and a list of features, see the [Grafana example](https://github.com/nginxinc/nginx-service-mesh/tree/main/examples/grafana) in the `nginx-service-mesh` GitHub repo.

To view Grafana, port-forward your Grafana Service:

```bash
kubectl port-forward -n <grafana-namespace> svc/grafana 3000
```
