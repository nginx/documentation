---
description: Learn how to use the F5 NGINX Management Suite API Connectivity Manager
  to manage HTTP API Gateways by applying a backend configuration policy.
nd-docs: DOCS-1141
toc: true
weight: 650
title: HTTP Backend Configuration
type:
- concept
---

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## About the Backend Configuration Policy

The backend configuration policy allows API Owners to manage their backend services with a common set of configuration options. These configuration options are applied to all service targets in a given backend service.

The backend configuration policy provides the ability to configure:

- [Load balancing](#load-balancing)
- [Keep-Alive connections](#keep-alive-connections)
- [Connection settings](#connection-settings)
- [Queues](#queues)
- [Buffers](#buffers)
- [Session Cookies](#session-cookies)
- [NTLM Authentication](#ntlm-authentication)

Later sections of this guide will cover each of these areas in turn.

### Intended Audience

{{< include "acm/how-to/policies/api-owner-persona.md">}}

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with an [API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have published one or more [API Gateways]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}})

---

## Workflow for Applying Policy

To apply the policy or make changes to it, here's what you need to do:

- [Edit an existing environment or create a new one]({{< ref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#add-environment" >}}).
- Check the advanced settings for the environment to see if the policy has been applied.
- Edit the policy to make changes for each environment. Save and publish the changes.

---

## Target Backend Service

It is possible to target specific backend services with a backend configuration policy through the use of labels. Backend services whose label matches that configured in the backend configuration policy target backend policy label will have that configuration applied. If no target backend policy label is provided, the backend configuration policy will be applied to all backend services with the label is set as default.

### Configuring Target Backend Service

Take the steps in this section to configure a backend configuration policy for specific backend service targets by label. In the example below, the backend configuration policy keepalive settings will be applied to all backend service targets with the `petstore-api` label.

{{<tabs name="add_backend_target">}}
{{%tab name="API"%}}

Send a `POST` request to add a load balancer configuration to the API Proxy through the backend-config policy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


```json
{
   "policies": {
      "backend-config": [
         {
            "action": {
               "targetBackendPolicyLabel" : "petstore-api",
               "keepCacheConnectionAlive": 32,
               "keepAliveRequests": 1000,
               "keepAliveTime": "1h",
               "keepAliveTimeout": "60s"
            }
         }
      ]
   }
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                      | Type    | Possible Values         | Description                                                                                                                                                        | Required      | Default value |
|----------------------------|---------|-------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------------|
| `targetBackendPolicyLabel` | string  | Example: `petstore-api` | Target backend labels for policy application. If not supplied this backend service configuration would be applied to the default backend service of the API proxy. | No            | `default`     |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md">}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **HTTP Backend Config**.
1. To apply the backend configuration policy to backend service targets, set the **Target Backend Policy Label** as the label of the backend service targets.
1. Select **Add** to apply the backend configuration policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

---

## Load Balancing

Six load balancing options are available; round robin (default), least connections, least response time, hashed key value, IP hash, or random.

### Balancing Algorithms

#### Round Robin

This algorithm distributes requests to the application in a round-robin fashion to each backend service target in equal and circular order. As the default load balancing algorithm, it applies to all upstream server blocks containing backend service targets.

#### Least Connections

This algorithm distributes requests to the server with the least number of active connections. If there are several servers, they are tried sequentially using the round-robin balancing method.

#### Least Time

{{< call-out "note" >}} This load balancing algorithm is available as part of the F5 NGINX Plus commercial subscription. {{< /call-out >}}

This algorithm distributes requests to the server with the least average response time and least number of active connections. If there are several servers, they are tried sequentially using the round-robin balancing method.

If the `HEADER` measurement is specified, the time to receive the response header is used. If the `LAST_BYTE` measurement is specified, the time to receive the full response is used. If the `LAST_BYTE_INFLIGHT` parameter is specified, incomplete requests are also considered.

#### Hash

This algorithm distributes requests with client-server mapping based on the hashed `key` value. The `key` can contain text, variables, and their combinations. Note that adding or removing a server from the group may result in remapping most of the keys to different servers. The method is compatible with the [Cache::Memcached](https://metacpan.org/pod/Cache::Memcached) Perl library.

If the `consistent` parameter is specified, the [ketama](https://www.metabrew.com/article/libketama-consistent-hashing-algo-memcached-clients) consistent hashing method will be used instead. The method ensures that only a few keys will be remapped to different servers when a server is added to or removed from the group. This helps to achieve a higher cache hit ratio for caching servers. The method is compatible with the [Cache::Memcached::Fast](https://metacpan.org/pod/Cache::Memcached::Fast) Perl library with the `ketama_points` parameter set to 160.

#### IP Hash

This algorithm distributes requests between servers based on client IP addresses. The first three octets of a client's IPv4 address, or an entire IPv6 address are used as a hashing key, ensuring that requests from the same client will always be passed to the same server except when the server is unavailable. In the latter case, client requests will be passed to another server. Most probably, it will always be the same server as well.

If one of the servers needs to be temporarily removed, it should be marked with the down parameter to preserve the current hashing of client IP addresses.

### Configuring a Load Balancer

Follow the steps in this section to configure request load balancing across backend service targets.

{{<tabs name="add_load_balancing">}}
{{%tab name="API"%}}

Send a `POST` request to add a load balancer configuration to the API Proxy through the backend-config policy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


```json
{
   "policies": {
      "backend-config": [
         {
            "action": {
               "loadBalancing": {
                  "algorithm": "ROUND_ROBIN",
                  "leastTimeMeasurement": "HEADER",
                  "hashKey": "$request_uri",
                  "consistentHashing": true,
                  "randomTwo": true,
                  "randomMethod": "LEAST_CONN"
               }
            }
         }
      ]
   }
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                  | Type    | Possible Values                                                                      | Description                                                                                                                                                       | Required      | Default value |
|------------------------|---------|--------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------------|
| `algorithm`            | string  | One of: <br>[`ROUND_ROBIN`, `LEAST_CONN`, `LEAST_TIME`, `HASH`, `IP_HASH`, `RANDOM`] | The load balancing algorithm to use. Default `ROUND_ROBIN` is used without any configuration.                                                                     | No            | `ROUND_ROBIN` |
| `leastTimeMeasurement` | string  | One of: <br>[`HEADER`, `LAST_BYTE`, `LAST_BYTE_INFLIGHT`]                            | Optional configuration option for `LEAST_TIME` algorithm.  The measurement used to determine `LEAST_TIME`.                                                        | No            | `HEADER`      |
| `hashKey`              | string  | Text, variables, and their combinations.                                             | Required configuration option for `HASH` algorithm. Example: `$request_uri`                                                                                       | Semi-optional | N/A           |
| `consistentHashing`    | boolean | `true/false`                                                                         | Optional configuration option for `HASH` algorithm. Uses ketama consistent hashing method.                                                                        | No            | `true`        |
| `randomTwo`            | boolean | `true/false`                                                                         | Optional configuration option for `RANDOM` algorithm. Instructs NGINX to randomly select two servers and then choose a server using the specified `randomMethod`. | No            | `true`        |
| `randomMethod`         | string  | One of: <br>[`LEAST_CONN`, `LEAST_TIME`, `LAST_TIME_HEADER`, `LEAST_TIME_LAST_BYTE`] | Optional configuration option for `RANDOM` algorithm. Specifies which load balancing algorithm to use for a randomly selected server.                             | No            | `LEAST_CONN`  |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md">}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **HTTP Backend Config**.
1. To enable a load balancer other than the default round-robin, enable the toggle for **Add an alternate load balancer**.
1. Select your **Load Balancing Algorithm** from the drop-down menu.
   - For `LEAST_TIME` define the **Least Time Measurement**
   - For `HASH` define the **Hash Key** and if **Consistent Hashing** is required.
   - For RANDOM set if **Random Two** should be used and the **Random Method** load balancing algorithm.
1. Select **Add** to apply the backend configuration policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

---

## Keep-Alive Connections

HTTP keepalive (persistent) connections [[RFC-2068]](https://www.rfc-editor.org/rfc/rfc2068.html#section-8) are a necessary performance feature that reduce latency and allow web pages to load faster. HTTP uses a mechanism called keepalive connections to hold open the TCP connection between the client and the server after an HTTP transaction has completed. If the client needs to conduct another HTTP transaction, it can use the idle keepalive connection rather than creating a new TCP connection.

If lots of clients use HTTP keepalives and the web server has a concurrency limit or scalability problem, then performance plummets once that limit is reached. It does not take many clients to exhaust the concurrency limit in many contemporary web and application servers and any thread‑ or process‑based web or application server is vulnerable to concurrency limitations.

NGINX uses a different architecture that does not suffer from the concurrency problems described above. It transforms slow client connections to optimized benchmark‑like connections to extract the best performance from your servers. This allows each NGINX process to easily scale to tens, thousands, or hundreds of thousands of connections simultaneously.

### Configuring Keep-Alive Connections

Follow the steps in this section to configure HTTP keepalives for your backend service targets.

{{<tabs name="add_keepalive">}}
{{%tab name="API"%}}

Send a `POST` request to add a keepalive connection configuration to the API Proxy through the backend-config policy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


```json
{
   "policies" : {
      "backend-config" : [
         {
            "action" : {
               "keepCacheConnectionAlive": 32,
               "keepAliveRequests": 1000,
               "keepAliveTime": "1h",
               "keepAliveTimeout": "60s"
            }
         }
      ]
   }
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                      | Type    | Possible Values | Description                                                                                                                                                                                                                                                              | Required | Default value |
|----------------------------|---------|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `keepCacheConnectionAlive` | integer | integer >= `1`  | Activates the cache for connections to upstream servers. Sets the maximum number of idle keepalive connections to upstream servers that are preserved in the cache of each worker process. When this number is exceeded, the least recently used connections are closed. | No       | `32`          |
| `keepAliveRequests`        | integer | integer >= `1`  | Sets the maximum number of requests that can be served through one keepalive connection.                                                                                                                                                                                 | No       | `1000`        |
| `keepAliveTime`            | string  | Example: `1h`   | Limits the maximum time during which requests can be processed through one keepalive connection. Follows NGINX configuration time measurement units syntax.                                                                                                              | No       | `1h`          |
| `keepAliveTimeout`         | string  | Example: `60s`  | Sets a timeout during which an idle keepalive connection to an upstream server will stay open. Follows NGINX configuration time measurement units syntax.                                                                                                                | No       | `60s`         |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md">}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **HTTP Backend Config**.
1. Go to the **Keep-Alive Connection Settings** section.
1. If non-default values are required, enter configuration values for:
   - Keep-Alive Max Cache Connections Alive
   - Keep-Alive Requests
   - Keep-Alive Time
   - Keep-Alive Timeout
1. Select **Add** to apply the backend configuration policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

---

## Connection Settings

The connection settings can be configured for maximum client request body size, establishing a connection timeout, maximum time for reading a response from the proxied server, or maximum time transmitting a request to the proxied server.

### Client Max Body Size

Sets the maximum allowed size of the client request body. If the size of a request exceeds the configured value, the `413 (Request Entity Too Large)` error is returned to the client.

### Connect Timeout

Defines a timeout for establishing a connection with a proxied server. Please note that this timeout cannot usually exceed 75 seconds.

### Read Timeout

Defines a timeout for reading a response from the proxied server. The timeout is set only between two successive read operations, not for the transmission of the whole response. The connection is closed if the proxied server does not transmit anything within this time.

### Send Timeout

Sets a timeout for transmitting a request to the proxied server. The timeout is set only between two successive write operations, not for the transmission of the whole request. The connection is closed if the proxied server does not receive anything within this time.

### Configuring Connection Settings

This section explains how to configure connection settings for your backend service targets.

{{<tabs name="add_connection_settings">}}
{{%tab name="API"%}}

Send a `POST` request to add request settings configuration to the API Proxy through the backend-config policy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


```json
{
   "policies" : {
      "backend-config" : [
         {
            "action" : {
               "clientMaxBodySize" : "2m",
               "connectTimeout": "30s",
               "readTimeout": "30s",
               "sendTimeout": "30s"
            }
         }
      ]
   }
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field               | Type    | Possible Values | Description                                                                                                                    | Required | Default value |
|---------------------|---------|-----------------|--------------------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `clientMaxBodySize` | string  | Example: `2m`   | Sets the maximum allowed size of the client request body. Follows NGINX configuration file measurement units syntax.           | No       | N/A           |
| `connectTimeout`    | string  | Example: `30s`  | Sets a timeout for establishing a connection with a proxied server. Follows NGINX configuration time measurement units syntax. | No       | N/A           |
| `readTimeout`       | string  | Example: `30s`  | Sets a timeout for reading a response from the proxied server. Follows NGINX configuration time measurement units syntax.      | No       | N/A           |
| `sendTimeout`       | string  | Example: `30s`  | Sets a timeout for transmitting a request to the proxied server. Follows NGINX configuration time measurement units syntax.    | No       | N/A           |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md">}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **HTTP Backend Config**.
1. Go to the **Connection Settings** section.
1. If non-default values are required, enter configuration values for:
   - Connect Timeout
   - Read Timeout
   - Send Timeout
   - Client Max Body Size
1. Select **Add** to apply the backend configuration policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

---

## Queues

If an upstream server cannot be selected immediately while processing a request, the request will be placed into the queue. The queue configuration specifies the maximum number of requests that can be in the queue simultaneously. If the queue is filled up, or the server to pass the request to cannot be selected within the time period specified in the timeout parameter, the `502 (Bad Gateway)` error will be returned to the client.

### Configuring a Queue

Follow the steps in this section to configure a queue for your backend service targets.

{{<tabs name="add_queue">}}
{{%tab name="API"%}}

Send a `POST` request to add a queue configuration to the API Proxy through the backend-config policy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


```json
{
   "policies" : {
      "backend-config" : [
         {
            "action" : {
               "queue" : {
                  "maxNumberOfRequests": 10,
                  "timeOut": "60s"
               }
            }
         }
      ]
   }
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                 | Type    | Possible Values | Description                                                                                                                    | Required | Default value |
|-----------------------|---------|-----------------|--------------------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `maxNumberOfRequests` | integer | Example: `10`   | Maximum number of requests that can be in the queue at the same time. If not set then no queue will be configured.             | Yes      | N/A           |
| `timeout`             | string  | Example: `60s`  | Sets a timeout for establishing a connection with a proxied server. Follows NGINX configuration time measurement units syntax. | No       | `60s`         |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md">}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **HTTP Backend Config**.
1. Go to the **Queue Settings** section.
1. To configure a queue, enable the toggle for **Add a queue**.
   - Set the **Maximum number of requests** (required).
   - Set the **Queue timeout" (default 60s).
1. Select **Add** to apply the backend configuration policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

---

## Buffers

{{< call-out "note" >}}See the [Module ngx_http_proxy_module](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) topic for more information about the directives mentioned in this section.{{< /call-out>}}

When buffering is enabled, NGINX receives a response from the proxied server as soon as possible, saving it into the buffers set by the `proxy_buffer_size` and `proxy_buffers` directives.

- Depending on the operating system, the `proxy_buffer_size` directive is 4 KB or 8 KB. This directive sets the buffer size for reading the first part of the response received from the proxied server. This part usually contains a small response header. By default, the buffer size is equal to one memory page.

- The `proxy_buffers` directive controls the size and the number of buffers allocated for a request. Increasing the number of buffers lets you buffer more information.

If the complete response doesn't fit into memory, a part can be saved to a temporary file on the disk. The default max size of this temporary file is 1024 MB, and the default write size is 8 KB or 16 KB, depending on the operating system.

When configuring proxy buffers, the total size of the `proxy_buffers` (number * size) must be greater than the size of the `proxy_busy_buffers_size` minus one buffer. The default `proxy_busy_buffers_size` is 8 KB or 16 KB, depending on the operating system.

If you get the error `[emerg] \"proxy_busy_buffers_size\"` `must be less than the size of all` `\"proxy_buffers\" minus one buffer` in NGINX in the data plane, it is because the proxy buffer total number and size are configured incorrectly.

### Examples

<details open>
<summary>Example valid Proxy Buffers number and size</summary>

```text
proxy busy buffers size : 16 KB
proxy buffer number     : 8
proxy buffer size       : 4 KB
total buffer size       : 32 KB

busy_buffers_size < total buffer size - buffer
16 KB < 32 KB - 4 KB
16 KB < 28 KB
True: Valid proxy buffer number & size configuration
```

</details>

<details open>
<summary>Example invalid proxy buffers number and size</summary>

```text
proxy busy buffers size : 16 KB
proxy buffer number     : 2
proxy buffer size       : 2k
total buffer size       : 8 KB

busy_buffers < total buffer size - buffer
16 KB < 8 KB - 2k
16 KB < 6k
False: Invalid proxy buffer number & size configuration
```

</details>

### Tuning Proxy Buffers Number and Size

When using proxy buffering, we recommend that the complete response from upstream can be held in memory to avoid reading or writing to disk, which is significantly slower.

If the response from upstream arrives fast and the client is slower, NGINX preserves the response in buffers, allowing it to close the upstream connection quickly.

If the allocated buffer size doesn't allow storing the complete response in memory, it will be stored on disk, which is slower.

Fine-tuning the `proxy_buffers` number and size depends on the body response size of your application.

To determine the size of the HTML/data returned by a resource, you can use the following command:

```bash
curl -so /dev/null https://nginx.org/ -w '%{size_download}'
```

Set `proxy_buffers` in a way that it equals the total maximum size of response data.

For example, if the uncompressed body size is 8955 bytes (72 KB), you must set 72 KB worth of buffer size, either 18 4-KB-sized buffers or 9 8-KB-sized buffers.

### Configuring Buffers

Follow the steps in this section to configure buffers for your backend service targets.

{{<tabs name="add_buffers">}}
{{%tab name="API"%}}

Send a `POST` request to add a buffer configuration to the API Proxy through the backend-config policy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


```json
{
   "policies" : {
      "backend-config" : [
         {
            "action" : {
               "buffer": {
                  "number": 42,
                  "size": "16KB"
               }
            }
         }
      ]
   }
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field    | Type    | Possible Values | Description                                                                                                                                                          | Required | Default value |
|----------|---------|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `number` | integer | integer >= `2`  | Sets the number of buffers used for reading a response from the proxied server for a single connection.                                                              | Yes      | N/A           |
| `size`   | string  | size >= `1K`    | Sets the size of the buffers used for reading a response from the proxied server for a single connection. Follows NGINX configuration file measurement units syntax. | Yes      | `60s`         |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md">}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **HTTP Backend Config**.
1. Go to the **Buffer Settings** section.
1. To configure a queue, enable the toggle for **Add a buffer**.
   - Set the **Number of buffers** (required).
   - Set the **Buffer size** (required).
1. Select **Add** to apply the backend configuration policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

---

## Session Cookies

Enables session affinity, which causes requests from the same client to be passed to the same server in a group of servers. With the cookie method used, information about the designated server is passed in an HTTP cookie generated by NGINX.

A request from a client not yet bound to a particular server is passed to the server selected by the configured balancing method. Further requests with this cookie will be passed to the designated server. If the designated server cannot process a request, the new server is selected as if the client has not been bound yet.

As a load balancing method always tries to evenly distribute the load considering already bound requests, the server with a higher number of active bound requests has less possibility of getting new unbound requests.

### Configuring Session Cookies

Folow the steps in this section to configure session cookies for your backend service targets.

{{<tabs name="add_session_affinity">}}
{{%tab name="API"%}}

Send a `POST` request to add a session cookie configuration to the API Proxy through the backend-config policy. If any configuration parameters are omitted, the corresponding fields are not set.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


```json
{
   "policies" : {
      "backend-config" : [
         {
            "action" : {
               "sessionCookie" : {
                  "name"       : "auth_cookie",
                  "path"       : "/path/to/set",
                  "expiresIn"  : "1h",
                  "domainName" : ".example.com",
                  "httpOnly"   : true,
                  "secure"     : true,
                  "sameSite"   : "STRICT"
               }
            }
         }
      ]
   }
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field        | Type    | Possible Values                       | Description                                                                                                                                                                           | Required | Default value |
|--------------|---------|---------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `name`       | string  | Example: `auth_cookie`                | Sets the name of the cookie to be set or inspected.                                                                                                                                   | Yes      | N/A           |
| `path`       | string  | Example: `/path/to/set`               | Defines the path for which the cookie is set.                                                                                                                                         | No       | N/A           |
| `expiresIn`  | string  | Example: `1h`                         | Sets cookie expiry. If the parameter is not specified, it will cause the cookie to expire at the end of a browser session. Follows NGINX configuration time measurement units syntax. | No       | N/A           |
| `domainName` | string  | Example: `.example.com`               | Defines the domain for which the cookie is set. Parameter value can contain variables.                                                                                                | No       | N/A           |
| `httpOnly`   | boolean | `true/false`                          | Adds the `HttpOnly` attribute to the cookie.                                                                                                                                          | No       | N/A           |
| `secure`     | boolean | `true/false`                          | Adds the `Secure` attribute to the cookie.                                                                                                                                            | No       | N/A           |
| `sameSite`   | string  | One of: <br>[`STRICT`, `LAX`, `NONE`] | Adds the `SameSite` attribute to the cookie.                                                                                                                                          | No       | N/A           |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md">}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **HTTP Backend Config**.
1. Go to the **Buffer Settings** section.
1. To configure session cookies, enable the toggle for **Session Affinity/Cookies Settings**.
   1. Set the **Name** of the cookie (required).
   1. Set the **Path** (optional).
   1. Set the cookie **Expires in** (optional). If the parameter is not specified, it will cause the cookie to expire at the end of a browser session.
   1. Set the **Domain Name** (optional).
   1. Enable the **HTTP Only** toggle to add the HttpOnly attribute to the cookie (optional).
   1. Enable the **Secure** toggle to add the Secure attribute to the cookie (optional).
   1. Set the **Same Site** attribute value (optional).
1. Select **Add** to apply the backend configuration policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

---

## NTLM Authentication

Allows proxying requests with [NTLM Authentication](https://en.wikipedia.org/wiki/Integrated_Windows_Authentication). The upstream connection is bound to the client connection once the client sends a request with the `Authorization` header field value starting with `Negotiate` or `NTLM`. Further client requests will be proxied through the same upstream connection, keeping the authentication context.  When enabled, the HTTP Protocol version is set to 1.1.

### Configuring NTLM Authentication

Follow the steps in this section to configure session cookies for your backend service targets.

{{<tabs name="add_ntlm">}}
{{%tab name="API"%}}

Send a `POST` request to enable NTLM authentication for the API Proxy through the backend-config policy.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


```json
{
   "policies" : {
      "backend-config" : [
         {
            "action" : {
               "enableNTLMAuthn": false
            }
         }
      ]
   }
}
```


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field             | Type    | Possible Values | Description                                         | Required | Default value |
|-------------------|---------|-----------------|-----------------------------------------------------|----------|---------------|
| `enableNTLMAuthn` | boolean | `true/false`    | Enables proxying requests with NTLM Authentication. | No       | `false`       |

{{< /bootstrap-table >}}


{{%/tab%}}
{{%tab name="UI"%}}

1. {{< include "acm/webui-acm-login.md">}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **HTTP Backend Config**.
1. Go to the **Connection Settings** section.
1. To enable NTLM, enable the toggle for **Enable NTLM Authn**.
1. Select **Add** to apply the backend configuration policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

---

## Reference Backend Configuration Policy API Request Body

```json
{
   "policies": {
      "backend-config": [
         {
            "action": {
               "targetBackendPolicyLabel" : "default",
               "keepCacheConnectionAlive": 32,
               "keepAliveRequests": 1000,
               "keepAliveTime": "1h",
               "keepAliveTimeout": "60s",
               "connectTimeout": "30s",
               "readTimeout": "30s",
               "sendTimeout": "30s",
               "clientMaxBodySize": "2m",
               "enableNTLMAuthn": false,
               "loadBalancing": {
                  "algorithm": "LEAST_CONN",
                  "leastTimeMeasurement": "HEADER",
                  "hashKey": "$request_uri",
                  "consistentHashing": true,
                  "randomTwo": true,
                  "randomMethod": "LEAST_CONN"
               },
               "queue": {
                  "maxNumberOfRequests": 10,
                  "timeOut": "60s"
               },
               "buffer": {
                  "number": 8,
                  "size": "8k"
               },
               "sessionCookie": {
                  "name": "auth_cookie",
                  "path": "/",
                  "expiresIn": "1h",
                  "domainName": ".example.com",
                  "httpOnly": true,
                  "secure": true,
                  "sameSite": "strict"
               }
            }
         }
      ]
   }
}
```
