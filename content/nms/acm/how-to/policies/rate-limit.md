---
description: Learn how to use the F5 NGINX Management Suite API Connectivity Manager
  Rate Limiting policy to protect backend servers. The Rate Limiting policy lets you
  limit connections and the rate of requests based on request URI, client IP address,
  or authenticated clients.
nd-docs: DOCS-1251
title: Rate Limiting
toc: true
weight: 1300
type:
- how-to
---

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## About the Policy

The Rate Limit policy can be used to throttle the number of requests in a time period that enter an application.
You can specify multiple rate limit stipulations with a single policy based on the **Request URI**, **Client IP address** or the **Authenticated Client ID**.
The policy can also specify the type of traffic shaping required to allow burst traffic or two-stage rate limiting.

### Intended Audience

This guide is meant for F5 NGINX Management Suite Administrators who can modify or create policies on an API Gateway Proxy.

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with an [API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have published one or more [API Gateways]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}}).


## Policy Settings


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                  | Type    | Possible Values                | Description                                                                                              | Required | Default Value      |
|------------------------|---------|--------------------------------|----------------------------------------------------------------------------------------------------------|----------|--------------------|
| `returnCode`           | int     |  In range `400-599`            | The return code that used when the total number of requests have been exceeded.                          | Yes      | `429`              |
| `grpcStatusCode`       | int     |  In range `400-599`            | The return code that used when the total number of requests have been exceeded.                          | No       | `429`              |
| `limits.rate`          | string  | Example:<br>`10r/s`            | The total number of requests allowed over a given amount of time.                                        | Yes      | `10r/s`            |
| `limits.rateLimitBy`   | string  | `uri`, `consumer`, `client.ip` | The value on which to apply the rate limiting on.                                                        | Yes      | `client.ip`        |
| `limits.zoneSize`      | string  | Example:<br>`10M`              | The size of the shared memory buffer for the proxy.                                                      | Yes      | `10M`              |
| `throttle.delay`       | int     | Example:<br>`5`                | The delay parameter defines the point at which, within the burst size, excessive requests are throttled. | No       | `N/A`              |
| `throttle.noDelay`     | boolean | `true/false`                   | Decides if the request should be processed immediately or stored in buffer.                              | No       | `N/A`              |
| `throttle.burst`       | int     | Example:<br>`10`               | Total number of requests that can be handled in a burst before rate limiting is exceeded.                | No       | `N/A`              |


{{< /bootstrap-table >}}


---

## Applying the Policy

You can apply this policy using the web interface or the REST API. The policy uses `x-correlation-id` as the default HTTP header name, or you can provide a custom header value.

<br>

{{<tabs name="add_request_correlation_id_policy">}}

{{%tab name="API"%}}

Send a `POST` request to add the Rate limit policy to the API Proxy.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                            |
|--------|---------------------------------------------------------------------|
| `POST` | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies`             |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

```json
{
  "policies": {
     "rate-limit": [
        {
           "systemMetadata": {
              "appliedOn": "inbound",
              "context": "proxy"
           },
           "action": {
              "limits": [
                 {
                    "rate": "10r/s",
                    "rateLimitBy": "client.ip",
                    "zoneSize": "10M"
                 }
              ]
           }
        }
     ]
  }
}
```

This JSON example defines a Request Correlation ID policy, which specifies that an HTTP header called `x-correlation-id` should be used when passing the correlation ID.

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To add a Request Correlation ID policy using the web interface:

1. In the ACM user interface, go to **Services > \{your workspace}**, where "your workspace" is the workspace that contains the API Proxy.
1. Select **Edit Proxy** from the **Actions** menu for the desired API Proxy.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **Rate Limit**.
1. Multiple Rate limit stipulations can be added for a policy.
1. Configure the associated **Key**, **Limit**, **Unit** **Zone Size** and **Zone size  unit** for each stipulation.
1. Optionally you can customize the type of rate limiting that is applied to the policy. Choose from one of the 3  following options
   1. **Buffer excess requests**: will allow bursts of requests to be stored in a buffer
   1. **Buffer excess requests no delay**: will allow bursts of requests to get processed immediately while there is space in the buffer
   1. **Throttle excess requests**: will enable Two-Stage rate limiting
1. Set custom error return code conditions if rate limiting **is exceeded**.
1. Select **Add** to apply the Rate Limit policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.
1. Select **Add** to apply the policy to the cluster.
1. Select **Save and Submit** to deploy the configuration.

{{%/tab%}}

{{</tabs>}}

---

## Common Use Cases
The following articles describe common use cases for rate limiting:

1. [Rate Limiting with NGINX and NGINX Plus](https://www.nginx.com/blog/rate-limiting-nginx/)
1. [Deploying NGINX as an API Gateway, Part 2: Protecting Backend Services](https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-2-protecting-backend-services/)
