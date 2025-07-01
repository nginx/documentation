---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  set response headers to send to your clients.
nd-docs: DOCS-1135
title: Proxy Response Headers
toc: true
weight: 1150
type:
- reference
---

## Overview

{{< include "acm/how-to/policies-intro" >}}

## About the Policy

Customize the Proxy Response Headers policy to include or exclude headers in the proxy response. By default, the standard headers are included in the response. In addition, you can specify whether the header is always included regardless of the response code. You can also add custom headers and values to include in the response.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Workflow for Applying Policy

To apply the policy or make changes to it, here’s what you need to do:

- Create an environment or edit an existing one.
- Check the advanced settings for the environment to see if the policy has been applied.
- Edit the policy to make changes for each environment. Save and publish the changes.

---

## Policy Settings

The following table lists the configurable settings and their default values for the policy.

### Standard Headers


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field        | Datatype | Possible&nbsp;Values     | <div style="width:400px">Description</div>                                        | Required | Default               |  Always Include|
|--------------|----------|---------------------|----------------------------------------------------|----------|-----------------------|---------|
| `web-security-headers`   | boolean  | true/false   | When set to true, the default headers are passed in proxy response. For more information, refer to the Web Security Headers section.   | No      | true       | true |
| `latency-headers` | boolean   | true/false | When set to true, the default headers are passed in proxy response. For more information, refer to the Latency Headers section.  | No      | true | false |
| `cache-headers`   | boolean  | true/false | When set to true, the default headers are passed in proxy response. For more information, refer to the Cache Headers section.  | No      |       true    | true |
| `client-headers` | boolean   | true/false | When set to true, X-Client-Original-IP header is passed in proxy response. For more information, refer to the Client Headers section. | No      | true | true |
| `hide-nginx-headers` | boolean   | true/false | When set to true, nginx version is not passed in Server header in proxy response. For more information, refer to the Hide NGINX Headers section. | No      | false | false |
| `correlation-id` | boolean   | true/false | When set to true, the correlation id header is passed in proxy response. For more information, refer to the Correlation ID Headers section. | No      | true | true |

{{< /bootstrap-table >}}


### Web Security Headers


{{< bootstrap-table "table table-striped table-bordered" >}}

| Header        | Example | Directive     | <div style="width:400px">Description</div>  |
|--------------|----------|---------------------|----------------------------------------------------|
| `Strict-Transport-Security`   | Strict-Transport-Security: max-age=31536000; includeSubDomains  | add_header Strict-Transport-Security "max-age=31536000; includeSubDomains"  [always]   | HSTS response header informs browsers that the site should only be accessed using HTTPS, and that any future attempts to access it using HTTP should automatically be converted to HTTPS. |
| `X-Frame-Options` | X-Frame-Options: SAMEORIGIN   | add_header X-Frame-Options SAMEORIGIN [always] | The X-Frame-Options HTTP response header can be used to indicate whether or not a browser should be allowed to render a page in iframe. Sites can use this to avoid click-jacking attacks, by ensuring that their content is not embedded into other sites. |
| `X-Content-Type-Options`   | X-Content-Type-Options: nosniff  | add_header X-Content-Type-Options nosniff [always] | The X-Content-Type-Options response HTTP header is a marker used by the server to indicate that the MIME types advertised in the Content-Type headers should be followed and not be changed. The header allows you to avoid MIME type sniffing by saying that the MIME types are deliberately configured. |
| `X-Xss-Protection` | X-Xss-Protection: 1; mode=block   | add_header X-Xss-Protection "1; mode=block" [always] | The HTTP X-XSS-Protection response header is a feature of Internet Explorer, Chrome and Safari that stops pages from loading when they detect reflected cross-site scripting (XSS) attacks. These protections are largely unnecessary in modern browsers when sites implement a strong Content-Security-Policy that disables the use of inline JavaScript ('unsafe-inline'). |

{{< /bootstrap-table >}}


### Latency Headers


{{< bootstrap-table "table table-striped table-bordered" >}}

| Header        | Example | Directive     | <div style="width:400px">Description</div>  |
|--------------|----------|---------------------|----------------------------------------------------|
| `X-Backend-Latency`   | X-Backend-Latency: 0.744  | add_header X-Backend-Latency $upstream_header_time [always]   | Backend/Upstream response time |
| `X-Total-Request-Response-Latency` | X-Total-Request-Response-Latency: 0.743   | add_header X-Total-Request-Response-Latency $request_time [always] | Request time |
| `X-Backend-Connection-Time`   | X-Backend-Connection-Time: 0.433  | add_header X-Backend-Connection-Time $upstream_connect_time [always] | Backend/Upstream connect time  |


{{< /bootstrap-table >}}


### Cache Headers


{{< bootstrap-table "table table-striped table-bordered" >}}

| Header        | Example | Directive     | <div style="width:400px">Description</div>  |
|--------------|----------|---------------------|----------------------------------------------------|
| `Cache-Control`   | Cache-Control: public, must-revalidate, proxy-revalidate  | add_header Cache-Control "public, must-revalidate, proxy-revalidate" [always]   | The Cache-Control HTTP header field holds directives (instructions) — in both requests and responses — that control caching in browsers and shared caches (e.g. Proxies, CDNs). |

{{< /bootstrap-table >}}


### Client Headers


{{< bootstrap-table "table table-striped table-bordered" >}}

| Header        | Example | Directive     | <div style="width:400px">Description</div>  |
|--------------|----------|---------------------|----------------------------------------------------|
| `X-Client-Original-IP`   | X-Client-Original-IP: 172.10.10.10  | add_header X-Client-Original-IP $realip_remote_addr [always]   | Client original IP.  |

{{< /bootstrap-table >}}


### Hide NGINX Headers


{{< bootstrap-table "table table-striped table-bordered" >}}

| Header        | Example | Directive     | <div style="width:400px">Description</div>  |
|--------------|----------|---------------------|----------------------------------------------------|
| `Server`   | Server: nginx   | server_tokens off   | NGINX version is not passed in Server header in proxy response. Server: nginx [nginx/1.23.2]  |


{{< /bootstrap-table >}}


### Correlation ID Headers


{{< bootstrap-table "table table-striped table-bordered" >}}

| Header        | Example | Directive     | <div style="width:400px">Description</div>  |
|--------------|----------|---------------------|----------------------------------------------------|
| `<correlation-id-header-name>`   | x-correlation-id: 26fd65ab0bbe36e546e3da14f4aea89f   | add_header `<correlation-id-header-name> <correlation-id> [always]`   | There must also be a request-correlation-id policy that will tell you the header name that gets used. The correlation id value is usually the $request_id but there is logic that that can be overridden by a specific value in the request header itself.  |


{{< /bootstrap-table >}}


### Custom Headers


{{< bootstrap-table "table table-striped table-bordered" >}}

| Header        | Example | Directive     | <div style="width:400px">Description</div>  |
|--------------|----------|---------------------|----------------------------------------------------|
| `<custom-header-name>`   | x-custom-header: 3da14f4aea89f   | add_header `<custom-header-name> <custom-header-value> [always]`   | Add a custom header.  |


{{< /bootstrap-table >}}


---

## Adding the Policy

{{<tabs name="policy-implementation">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To create or update a Response Headers policy using the REST API, send an HTTP `PUT` request to the Environment endpoint.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Method | Endpoint            |
|--------|---------------------|
| `PUT` | `/infrastructure/workspaces/{workspace}/environments/{environment}` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

``` json
{
    "policies": {
        "proxy-response-headers": [
            {
                "action": {
                    "config": [
                        {
                            "always": true,
                            "enabled": true,
                            "name": "web-security-headers"
                        },
                        {
                            "always": true,
                            "enabled": true,
                            "name": "correlation-id"
                        },
                        {
                            "always": false,
                            "enabled": true,
                            "name": "latency-headers"
                        },
                        {
                            "always": true,
                            "enabled": true,
                            "name": "cache-headers"
                        },
                        {
                            "always": false,
                            "enabled": false,
                            "name": "hide-nginx-headers"
                        },
                        {
                            "always": true,
                            "enabled": true,
                            "name": "client-headers"
                        }
                    ],
                    "customResponseHeaders": [
                        {
                            "always": true,
                            "key": "x-custom-header",
                            "value": "3da14f4aea89f"
                        }
                    ]
                }
            }
        ]
    }
}
```

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To create/update Response Headers policy using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Infrastructure**.
3. Choose the workspace that includes the environment for the cluster you want to add the policy to.
4. Select the environment for your cluster.
5. In the list of clusters, locate the cluster you want to add the policy to. On the **Actions** menu (represented by an ellipsis, ...), select **Edit Advanced Config**.
6. On the left menu, select **Global Policies**.
7. From the list of policies, locate the policy, then select **Add Policy** from the **Actions** menu (represented by an ellipsis, ...).
8. Select **Save and Submit** to deploy the configuration.

{{%/tab%}}

{{</tabs>}}
