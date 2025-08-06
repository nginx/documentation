---
description: Learn how to create, configure, and implement health check policies for
  your HTTP and gRPC API Proxies using F5 NGINX Management Suite API Connectivity
  Manager.
nd-docs: DOCS-1125
title: Health Check
toc: true
weight: 610
type:
- reference
---

## Overview

{{< include "acm/how-to/policies-proxy-intro.md" >}}

## About the Policy

API Connectivity Manager can configure your API Proxies to continually test your backend service targets (upstream servers), avoid the servers that have failed, and gracefully add the recovered services to a load-balanced group. This continuous testing is also known as "Active Health Checks," whereas "Passive Health Checks" monitor transactions as they occur.

More information on NGINX health checks can be found at:

- <https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check>
- <https://docs.nginx.com/nginx/admin-guide/load-balancer/grpc-health-check/>

### Intended Audience

{{< include "acm/how-to/policies/api-owner-persona.md">}}

---

## HTTP Health Checks

### Before You Begin

To complete the steps in this guide, you need the following:

- API Connectivity Manager is installed, licensed, and running
- You have [one or more Environments with an API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway.md" >}})
- You have [published one or more API Gateways]({{< ref "/nms/acm/getting-started/publish-api-proxy.md" >}})
- Your backend service(s) has an HTTP health check endpoint and/or can return status codes in the range from 200 through 399 for health check requests.

### Policy Settings


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                                          | Datatype | Possible Values            | <div style="width:400px">Description</div>                                                                                                           | Required | Default value |
|----------------------------------------------------------------|----------|----------------------------|-----------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `targetBackendPolicyLabel`                                     | string   | Example: `default`         | This field is used to target a specific backend by label.                                                             | No       | `default`     |
| `transportProtocol`                                            | string   | One of `["http"]`          | The transport protocol used by the service. Only http is supported for now.                                           | No       | `http`        |
| `isMandatory`                                                  | bool     | `true/false`               | Requires every newly added server to pass all configured health checks before F5 NGINX Plus sends traffic to it.         | No       | `false`       |
| `persistent`                                                   | bool     | `true/false`               | Determines whether previous state is remembered after reloading configuration.                                        | No       | `false`       |
| `port`                                                         | int      | In range `1-65535`         | The port on the service that will provide the health check.                                                           | No       | N/A           |
| `interval`                                                     | int      | Integer (Max 2147483647)   | The length of time between each health check sent from Nginx to the respective service.                               | No       | 5             |
| `unhealthyThreshold`                                           | int      | Integer (Max 2147483647)   | Denotes the number of failed checks before the service is considered unhealthy.                                       | No       | 1             |
| `healthyThreshold`                                             | int      | Integer (Max 2147483647)   | Denotes the number of successful checks before the service is considered healthy.                                     | No       | 1             |
| `http`<br>`.uriPath`                                           | string   | Example: `/health`         | The URI used for the health check and is appended to the server domain name or IP address                             | No       | `/`           |
| `http`<br>`.responseMatch`<br>`.statusCode`<br>`.exact`        | int      | In range `100-599`         | List of specific status codes to match against                                                                        | No       | N/A           |
| `http`<br>`.responseMatch`<br>`.statusCode`<br>`.range`        | string   | Example: `["200-399"]`     | List of status code ranges to match against                                                                           | No       | N/A           |
| `http`<br>`.responseMatch`<br>`.header`<br>`.name`             | string   | Example: `header-name`     | Any valid header value from the response                                                                              | Yes      | N/A           |
| `http`<br>`.responseMatch`<br>`.header`<br>`.value`            | string   | Example: `header-value`    | Any valid header name from the response                                                                               | Yes      | N/A           |
| `http`<br>`.responseMatch`<br>`.header`<br>`.condition`        | string   | Regex: `^([=!~]\|!~)$`      | The matching operator for the header.  Uses NGINX Health Check `match` directive syntax                               | Yes      | N/A           |
| `http`<br>`.responseMatch`<br>`.body`<br>`.requiredVariable`   | string   | Example: `jsonFieldKey`    | Field in json of body to match against                                                                                | No       | N/A           |
| `http`<br>`.responseMatch`<br>`.body`<br>`.value`              | string   | Example: `jsonFieldValue`  | Any valid body content to be matched against                                                                          | Yes      | N/A           |
| `http`<br>`.responseMatch`<br>`.body`<br>`.condition`          | string   | Regex: `^!?~$`             | The matching operator for the body.  Uses NGINX Health Check `match` directive syntax                                 | Yes      | N/A           |
| `connectTimeout`                                               | string   | Example: `60s`             | Sets a timeout for establishing a connection with a proxied server.  Uses NGINX time measurement syntax               | No       | `1s`          |
| `readTimeout`                                                  | string   | Example: `60s`             | Sets a timeout for reading a response from the proxied server.  Uses NGINX time measurement syntax                    | No       | `1s`          |

{{< /bootstrap-table >}}


### Create an HTTP Health Check Policy

{{<tabs name="-create-http-health-check-policy">}}

{{%tab name="API"%}}

{{< call-out "note" >}}{{< include "acm/how-to/access-acm-api.md" >}}{{< /call-out>}}

To create an HTTP health check policy, send an HTTP `POST` to the Proxies endpoint.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/{SERVICE_WORKSPACE_NAME}/proxies` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

``` json
{
  "policies": {
    "backend-health-check": [
      {
        "action": {
          "targetBackendPolicyLabel": "default",
          "transportProtocol": "http",
          "isMandatory": true,
          "persistent": true,
          "port": 8080,
          "interval": 5,
          "unhealthyThreshold": 3,
          "healthyThreshold": 2,
          "http": {
            "uriPath": "/health_check",
            "responseMatch": {
              "statusCode": {
                "range": [
                  "200-399"
                ]
              },
              "header": {
                "name": "some-header",
                "value": "ok",
                "condition": "="
              },
              "body": {
                "requiredVariable": "jsonField",
                "value": "some-response-body",
                "condition": "~"
              }
            }
          },
          "connectTimeout": "10s",
          "readTimeout": "10s"
        }
      }
    ]
  }
}
```

</details>

<br>

{{%/tab%}}

{{%tab name="UI"%}}

To create a Health Check policy using the web interface:

1. {{< include "acm/webui-acm-login.md" >}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the left-side *API Proxy* menu, select **Policies**.
1. On the *Advanced > Policies* page, on the **API Proxy** tab, locate the **Backend Health Check** policy. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Add Policy**.
1. Complete the necessary fields:

   - **Apply the policy to**: Specify the label that was assigned to the backend service if it's different from the default value `default`.
   - **Transport Protocol**: Specify the transport protocol of the health check.  Currently, only HTTP is supported.
   - **Is Mandatory**: Toggle the switch to on if every new service target (server) must pass all configured health checks before NGINX Plus sends traffic to it.
   - **Port**: If the health check needs to be conducted on a port other than the one specified for the backend service targets, specify the port to use.
   - **Interval**: The length of time between each health check sent from NGINX Plus to the backend service targets.
   - **Unhealthy Threshold**: Denotes the number of failed checks before the service is considered unhealthy.
   - **Health Threshold**: Denotes the number of successful checks before the service is considered healthy.
   - **URI Path**: The endpoint (URI) that NGINX Plus uses for the health check requests.
   - **Status Code Exact**: The list of specific HTTP status codes to match against in the backend response.
   - **Status Code Range**: The list of HTTP status code ranges to match against in the backend response.
   - **Header Name**: The name of the header to use in the backend response matching.
   - **Header Condition**: The operator used when checking the header value.  Refer to the [NGINX `match` directive documentation](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html?&_ga=2.33487351.893608448.1680639753-1533979881.1676506809#match) for specifics.
   - **Header Value**: The header value to use in the backend response matching.
   - **Body Required Variable**: The field in the JSON of the backend response body to match against.
   - **Body Condition**: The operator used when checking the body value.  Refer to the [NGINX `match` directive documentation](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html?&_ga=2.33487351.893608448.1680639753-1533979881.1676506809#match) for specifics.
   - **Body Value**: The body value to use in the backend response matching.
   - **Connection Timeout**: Sets a timeout for establishing a connection with a proxied server. Follows NGINX configuration file measurement units syntax.
   - **Read Timeout**: Sets a timeout for reading a response from the proxied server. Follows NGINX configuration file measurement units syntax.

1. Select **Add** to apply the Health Check policy to the API Proxy.  Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}

{{</tabs>}}

### Verify the Policy

Confirm that the policy has been set up and configured correctly by taking these steps:

- Check that your backend service targets (upstream servers) are receiving health check endpoint calls.
- When `isMandatory` is set to `true`, verify that your backend service targets are not receiving proxied traffic until they clear the health checks.
- When `persistent` is set to `true`, the state and behavior for `interval`, `unhealthyThreshold`, `healthyThreshold`, and timeout-related parameters should be preserved between subsequent deployments of API proxies and environments.

---

## gRPC Health Checks

### Before You Begin

To complete the steps in this guide, you need the following:

- API Connectivity Manager is installed, licensed, and running
- You have [one or more Environments with a gRPC API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway.md" >}})
- You have [published one or more gRPC API Gateways]({{< ref "/nms/acm/how-to/services/publish-grpc-proxy.md" >}})
- Your backend service(s) implements the [gRPC health checking protocol](https://github.com/grpc/grpc/blob/master/doc/health-checking.md#grpc-health-checking-protocol) and/or returns a status code (normally `12` for `unimplemented`) for health check requests.

### Policy Settings


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                  | Datatype | Possible Values            | Description                                                                                                                 | Required | Default value |
|------------------------|----------|----------------------------|-----------------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `targetBackendLabel`   | string   | Example: `default`         | This field is used to target a specific backend by label.                                                                   | No       | `default`     |
| `mandatory`            | bool     | `true/false`               | Requires every newly added server to pass all configured health checks before NGINX Plus sends traffic to it.               | No       | `false`       |
| `persistent`           | bool     | `true/false`               | Determines whether previous state is remembered after reloading configuration.                                              | No       | `false`       |
| `port`                 | int      | In range `1-65535`         | The port on the service that will provide the health check.                                                                 | No       | N/A           |
| `interval`             | int      | Integer (Max 2147483647)   | The length of time between each health check sent from Nginx to the respective service.                                     | No       | N/A           |
| `passes`               | int      | Integer (Max 2147483647)   | Denotes the number of successful checks before the service is considered healthy.                                           | No       | N/A           |
| `fails`                | int      | Integer (Max 2147483647)   | Denotes the number of unsuccessful checks before the service is considered unhealthy.                                       | No       | N/A           |
| `grpc`<br>`.service`   | string   | Example: `RouteGuide`      | Defines the target GRPC service to be used for this health check                                                            | No       | N/A           |
| `grpc`<br>`.status`    | int      | Example: `12`              | The expected GRPC status code return code from the upstream gRPC backend to conclude that the health check was successful   | No       | N/A           |
| `connectTimeout`       | string   | Example: `60s`             | Sets a timeout for establishing a connection with a proxied server.  Uses NGINX time measurement syntax                     | No       | `1s`          |
| `readTimeout`          | string   | Example: `60s`             | Sets a timeout for reading a response from the proxied server.  Uses NGINX time measurement syntax                          | No       | `1s`          |

{{< /bootstrap-table >}}


### Create a gRPC Health Check Policy

{{<tabs name="create-grpc-health-check-policy">}}

{{%tab name="API"%}}

{{< call-out "note" >}}{{< include "acm/how-to/access-acm-api.md" >}}{{< /call-out>}}

To create a gRPC health check policy, send an HTTP `POST` to the Proxies endpoint.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

``` json
{
  "policies": {
    "grpc-backend-health-check": [
      {
        "action": {
          "mandatory": true,
          "persistent": true,
          "port": 84,
          "interval": 7,
          "fails": 3,
          "passes": 5,
          "connectTimeout": "6s",
          "readTimeout": "5s",
          "grpc": {
            "status": 12
          }
        }
      }
    ]
  }
}
```

</details>

<br>

{{%/tab%}}

{{%tab name="UI"%}}

To create a gRPC Health Check policy using the web interface:

1. {{< include "acm/webui-acm-login.md" >}}
1. On the left menu, select **Services**.
1. Select a workspace in the list that contains the API Proxy you want to update.
1. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
1. On the left-side *API Proxy* menu, select **Policies**.
1. On the *Advanced > Policies* page, on the **API Proxy** tab, locate the **gRPC Backend Health Check** policy. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Add Policy**.
1. Complete the necessary fields:

   - **Apply the policy to**: Provide the label that was assigned to a Backend Service if it is different from the default value `default
   - **Is Mandatory**: Toggle the switch to on if every new service target (server) must pass all configured health checks before NGINX Plus sends traffic to it.
   - **Port**: If the health check needs to be conducted on a port other than the one specified for the backend service targets, specify the port to use.
   - **Interval**: The length of time between each health check sent from NGINX Plus to the backend service targets.
   - The **gRPC** setting will determine which health check service will be contacted by NGINX and which status code will be expected.

1. Select **Add** to apply the Health Check policy to the API Proxy.  Then select **Save & Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}

{{</tabs>}}

### Verify the Policy

Confirm that the policy has been set up and configured correctly by taking these steps:

- Check that your backend service targets (upstream servers) are receiving health check endpoint calls. You may also find the tools [grpcurl](https://github.com/fullstorydev/grpcurl) and [grpc-health-probe](https://github.com/grpc-ecosystem/grpc-health-probe) helpful for debugging.
- When `mandatory` is set to `true`, verify that your backend service targets are not receiving proxied traffic until they clear the health checks.
- When `persistent` is set to `true`, state and behavior for `interval`, `passes`, `fails`, and timeout related parameters should be preserved between subsequent deployments of API Proxies and Environments.
