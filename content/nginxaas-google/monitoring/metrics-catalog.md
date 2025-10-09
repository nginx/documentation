---
title: Metrics catalog
weight: 400
toc: false
nd-docs: DOCS-000
url: /nginxaas/google/monitoring/metrics-catalog/
type:
- concept
---

F5 NGINXaaS for Google Cloud (NGINXaaS) provides a rich set of metrics that you can use to monitor the health and performance of your NGINXaaS deployment. This document provides a catalog of the metrics that are available for monitoring NGINXaaS for Google Cloud.

## Available metrics

- [Available metrics](#available-metrics)
- [Metrics](#metrics)
  - [NGINX config statistics](#nginx-config-statistics)
  - [NGINX connections statistics](#nginx-connections-statistics)
  - [NGINX requests and response statistics](#nginx-requests-and-response-statistics)
  - [NGINX SSL statistics](#nginx-ssl-statistics)
  - [NGINX cache statistics](#nginx-cache-statistics)
  - [NGINX worker statistics](#nginx-worker-statistics)
  - [NGINX upstream statistics](#nginx-upstream-statistics)
  - [NGINX stream statistics](#nginx-stream-statistics)

## Metrics

The following metrics are reported by NGINXaaS for Google Cloud in Google Cloud Monitoring.
The metrics are categorized by the namespace used in Google Cloud Monitoring. The labels allow you to filter or split your queries in Google Cloud Monitoring providing you with a granular view over the metrics reported.

### NGINX config statistics

{{< table >}}

| **Metric**            | **Labels** | **Type** | **Description**                                                                                                                                                                                                                                                                                                           | **Roll-up per** |
| --------------------- | -------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| nginx.config.reloads  | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location | count    | The total number of NGINX configuration reloads since NGINX was last started.                                                                                                                                                                                                                                           | deployment      |

{{< /table >}}

### NGINX connections statistics

{{< table >}}

| **Metric**                   | **Labels** | **Type** | **Description**                                                                                               | **Roll-up per** |
|------------------------------|----------------|----------|---------------------------------------------------------------------------------------------------------------|-----------------|
| nginx.http.connections      | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_connections_outcome | count    | The total number of client connections since NGINX was last started, categorized by outcome (accepted, active, dropped, idle). | deployment      |
| nginx.http.connection.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_connections_outcome | gauge    | The current number of client connections, categorized by outcome (accepted, active, dropped, idle).          | deployment      |

{{< /table >}}

### NGINX requests and response statistics

{{< table >}}

| **Metric**                   | **Labels** | **Type** | **Description**                                                                                               | **Roll-up per** |
|----------------------------------------|-----------------------------|-------|-----------------------------------------------------------------------------------------------------------------------------|---------------|
| nginx.http.request.count               | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location | gauge | The total number of client requests received since the last collection interval.                                            | deployment    |
| nginx.http.requests                    | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_zone_type | count | The total number of client requests received since NGINX was last started or reloaded.                                     | zone          |
| nginx.http.responses                   | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_zone_type | count | The total number of HTTP responses sent to clients since NGINX was last started or reloaded.                               | zone          |
| nginx.http.response.count              | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_status_range, nginx_zone_name, nginx_zone_type | gauge | The total number of HTTP responses sent to clients since the last collection interval, grouped by status code range.       | zone          |
| nginx.http.response.status             | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_status_range, nginx_zone_name, nginx_zone_type | count | The total number of responses since NGINX was last started or reloaded, grouped by status code range.                      | zone          |
| nginx.http.request.processing.count    | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_zone_type | gauge | The number of client requests that are currently being processed.                                                          | zone          |
| nginx.http.request.discarded           | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_zone_type | count | The total number of requests completed without sending a response.                                                         | zone          |
| nginx.http.request.io                  | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_io_direction, nginx_zone_name, nginx_zone_type | count | The total number of HTTP bytes transferred (receive/transmit).                                                             | zone          |
| nginx.http.limit_conn.requests         | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_limit_conn_outcome, nginx_zone_name | count | The total number of connections to an endpoint with a limit_conn directive.                                               | zone          |
| nginx.http.limit_req.requests          | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_limit_req_outcome, nginx_zone_name | count | The total number of requests to an endpoint with a limit_req directive.                                                   | zone          |

{{< /table >}}

### NGINX SSL statistics

{{< table >}}

| **Metric**                   | **Labels** | **Type** | **Description**                                                                                               | **Roll-up per** |
|----------------------------------------|-----------------------------|-------|-----------------------------------------------------------------------------------------------------------------------------|---------------|
| nginx.ssl.handshakes                  | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_ssl_status, nginx_ssl_handshake_reason | count | The total number of SSL handshakes (successful and failed).                                                              | deployment    |
| nginx.ssl.certificate.verify_failures | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_ssl_verify_failure_reason | count | The total number of SSL certificate verification failures, categorized by reason.                                         | deployment    |

{{< /table >}}

### NGINX cache statistics

{{< table >}}

| **Metric**                   | **Labels** | **Type** | **Description**                                                                                               | **Roll-up per** |
|----------------------------------------|-----------------------------|-------|-----------------------------------------------------------------------------------------------------------------------------|---------------|
| nginx.cache.bytes_read                | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_cache.outcome, nginx_cache_name | count | The total number of bytes read from the cache or proxied server.                                                         | cache         |
| nginx.cache.responses                 | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_cache_outcome, nginx_cache_name | count | The total number of responses read from the cache or proxied server.                                                     | cache         |
| nginx.cache.memory.limit              | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_cache_name | gauge | The limit on the maximum size of the cache specified in the configuration.                                               | cache         |
| nginx.cache.memory.usage              | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_cache_name | gauge | The current size of the cache.                                                                                           | cache         |

{{< /table >}}

### NGINX memory statistics

{{< table >}}

| **Metric**                   | **Labels** | **Type** | **Description**                                                                                               | **Roll-up per** |
|----------------------------------------|-----------------------------|-------|-----------------------------------------------------------------------------------------------------------------------------|---------------|
| nginx.slab.page.free                  | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name | gauge | The current number of free memory pages in the shared memory zone.                                                       | zone          |
| nginx.slab.page.limit                 | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name | gauge | The total number of memory pages (free and used) in the shared memory zone.                                              | zone          |
| nginx.slab.page.usage                 | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name | gauge | The current number of used memory pages in the shared memory zone.                                                       | zone          |
| nginx.slab.page.utilization           | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name | gauge | The current percentage of used memory pages in the shared memory zone.                                                   | zone          |
| nginx.slab.slot.usage                 | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_slab_slot_limit, nginx_zone_name | gauge | The current number of used memory slots.                                                                                 | zone          |
| nginx.slab.slot.free                  | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_slab_slot_limit, nginx_zone_name | gauge | The current number of free memory slots.                                                                                 | zone          |
| nginx.slab.slot.allocations           | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_slab_slot_limit, nginx_slab_slot_allocation_result, nginx_zone_name | count | The number of attempts to allocate memory of specified size.                                                             | zone          |

{{< /table >}}

### NGINX upstream statistics

{{< table >}}

| **Metric**              | **Labels** | **Type** | **Description**                                                                                               | **Roll-up per** |
|-----------------------------------|-----------------------------|-------|-----------------------------------------------------------------------------------------------------------------------------|---------------|
| nginx.http.upstream.keepalive.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name | gauge | The current number of idle keepalive connections per HTTP upstream.                                                         | upstream      |
| nginx.http.upstream.peer.io | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_io_direction, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | The total number of bytes transferred per HTTP upstream peer.                                                               | peer          |
| nginx.http.upstream.peer.connection.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | gauge | The average number of active connections per HTTP upstream peer.                                                            | peer          |
| nginx.http.upstream.peer.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_peer_state, nginx_zone_name, nginx_upstream_name | gauge | The current count of peers on the HTTP upstream grouped by state.                                                          | upstream      |
| nginx.http.upstream.peer.fails | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | The total number of unsuccessful attempts to communicate with the HTTP upstream peer.                                       | peer          |
| nginx.http.upstream.peer.header.time | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | gauge | The average time to get the response header from the HTTP upstream peer.                                                   | peer          |
| nginx.http.upstream.peer.health_checks | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_health_check, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | The total number of health check requests made to an HTTP upstream peer.                                                   | peer          |
| nginx.http.upstream.peer.requests | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | The total number of client requests forwarded to the HTTP upstream peer.                                                   | peer          |
| nginx.http.upstream.peer.response.time | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | gauge | The average time to get the full response from the HTTP upstream peer.                                                     | peer          |
| nginx.http.upstream.peer.responses | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_status_range, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | The total number of responses obtained from the HTTP upstream peer grouped by status range.                                | peer          |
| nginx.http.upstream.peer.unavailables | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | Number of times the server became unavailable for client requests.                                                         | peer          |
| nginx.http.upstream.peer.state | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_peer_state, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | gauge | Current state of an upstream peer in deployment (1 if deployed, 0 if not).                                                | peer          |
| nginx.http.upstream.queue.limit | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name | gauge | The maximum number of requests that can be in the queue at the same time.                                                  | upstream      |
| nginx.http.upstream.queue.overflows | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name | count | The total number of requests rejected due to the queue overflow.                                                           | upstream      |
| nginx.http.upstream.queue.usage | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name | gauge | The current number of requests in the queue.                                                                               | upstream      |
| nginx.http.upstream.zombie.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name | gauge | The current number of upstream peers removed from the group but still processing active client requests.                   | upstream      |

{{< /table >}}

### NGINX stream statistics

{{< table >}}

| **Metric**                   | **Labels** | **Type** | **Description**                                                                                               | **Roll-up per** |
|----------------------------------------|-----------------------------|-------|-----------------------------------------------------------------------------------------------------------------------------|---------------|
| nginx.stream.io | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_io_direction, nginx_zone_name | count | The total number of Stream bytes transferred (receive/transmit).                                                          | zone          |
| nginx.stream.connection.accepted | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name | count | The total number of connections accepted from clients.                                                                    | zone          |
| nginx.stream.connection.discarded | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name | count | Total number of connections completed without creating a session.                                                         | zone          |
| nginx.stream.connection.processing.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name | gauge | The number of client connections that are currently being processed.                                                      | zone          |
| nginx.stream.session.status | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_status_range, nginx_zone_name | count | The total number of completed sessions grouped by status range.                                                           | zone          |
| nginx.stream.upstream.peer.io | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_io_direction, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | The total number of Stream upstream peer bytes transferred.                                                               | peer          |
| nginx.stream.upstream.peer.connection.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | gauge | The current number of Stream upstream peer connections.                                                                   | peer          |
| nginx.stream.upstream.peer.connection.time | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | gauge | The average time to connect to the stream upstream peer.                                                                 | peer          |
| nginx.stream.upstream.peer.connections | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | The total number of client connections forwarded to this stream upstream peer.                                           | peer          |
| nginx.stream.upstream.peer.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_peer_state, nginx_zone_name, nginx_upstream_name | count | The current number of stream upstream peers grouped by state.                                                             | upstream      |
| nginx.stream.upstream.peer.fails | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address | count | The total number of unsuccessful attempts to communicate with the stream upstream peer.                                   | peer          |
| nginx.stream.upstream.peer.health_checks | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_health_check, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | The total number of health check requests made to the stream upstream peer.                                              | peer          |
| nginx.stream.upstream.peer.response.time | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | gauge | The average time to receive the last byte of data for the stream upstream peer.                                          | peer          |
| nginx.stream.upstream.peer.ttfb.time | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | gauge | The average time to receive the first byte of data for the stream upstream peer.                                         | peer          |
| nginx.stream.upstream.peer.unavailables | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | How many times the server became unavailable for client connections due to max_fails threshold.                          | peer          |
| nginx.stream.upstream.peer.state | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_peer_state, nginx_zone_name, nginx_upstream_name, nginx_peer_address, nginx_peer_name | count | Current state of upstream peers in deployment (1 if any peer matches state, 0 if none).                                 | peer          |
| nginx.stream.upstream.zombie.count | nginxaas_account_id, nginxaas_namespace, nginxaas_deployment_object_id, nginxaas_deployment_name, nginxaas_deployment_location, nginx_zone_name, nginx_upstream_name | gauge | The current number of peers removed from the group but still processing active client connections.                       | upstream      |

{{< /table >}}
