---
title: "Rate Limiting"
description: Learn how to use the NGINX Management Suite API Connectivity Manager Rate Limiting policy to protect backend servers. The Rate Limiting policy lets you limit connections and the rate of requests based on request URI, client IP address, or authenticated clients.


weight: 1300
toc: true
tags: [ "docs" ]
docs: "DOCS-1251"
doctypes: ["API Connectivity Manager", "api management", "task"]
journeys: ["getting started", "using"]
personas: ["netops", "secops"]
---

{{<custom-styles>}}

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## About the Policy

Use the Rate Limit policy to throttle the number of requests over a given time that enters an application.
Specify multiple rate limit stipulations on a single policy based off of the **Request URI**, **Client IP address** or the **Authenticated Client ID**.
The policy can also specify the type of traffic shaping required to allow burst traffic or two-stage rate limiting

#### Intended Audience

This guide is meant for NGINX Management Suite Administrators who can modify or create policies on an API Gateway Proxy

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with an [API Gateway]({{< relref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have published one or more [API Gateways]({{< relref "/nms/acm/getting-started/publish-api-proxy" >}})


## Policy Settings

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
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
{{< raw-html>}}</div>{{</raw-html>}}

---

## Applying the Policy

You can apply this policy using either the web interface or the REST API. The policy uses `x-correlation-id` as the default HTTP header name, or you can provide a custom header value.

<br>

{{<tabs name="add_request_correlation_id_policy">}}

{{%tab name="API"%}}

Send a `POST` request to add the Rate limit policy to the API Proxy.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                                            |
|--------|---------------------------------------------------------------------|
| `POST` | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies`             |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

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
2. Select **Edit Proxy** from the **Actions** menu for the desired API Proxy.
3. On the **Policies** tab, select **Add Policy** from the **Actions** menu for **Rate Limit**.
4. Multiple Rate limit stipulations can be added for a policy.
5. Configure the associated **Key**, **Limit**, **Unit** **Zone Size** and **Zone size  unit** for each stipulation.
6. Optionally you can customize the type of rate limiting that is applied to the policy. Choose from one of the 3  following options
   1. **Buffer excess requests**: will allow bursts of requests to be stored in a buffer
   2. **Buffer excess requests no delay**: will allow bursts of requests to get processed immediately while there is space in the buffer
   3. **Throttle excess requests**: will enable Two-Stage rate limiting

7. Set custom error return code conditions if rate limiting **is exceeded**.
8. Select **Add** to apply the Rate Limit policy to the Proxy. Then select **Save & Publish** to deploy the configuration to the API Proxy.
9. Select **Add** to apply the policy to the cluster. 
10. Select **Save and Submit** to deploy the configuration.

{{%/tab%}}

{{</tabs>}}

---

## Common use-cases
See the following resources for example use cases of Rate Limiting;

1. https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-2-protecting-backend-services/
2. https://www.nginx.com/blog/rate-limiting-nginx/

