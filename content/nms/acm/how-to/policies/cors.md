---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  handle Cross-Origin Resource Sharing for your backend services.
docs: DOCS-1130
title: CORS
toc: true
weight: 500
type:
- reference
---

## Overview

{{< include "acm/how-to/policies-intro" >}}

---

## About the Policy

The CORS policy allows users to configure API Gateways to set the required headers to allow Cross-Origin Resource Sharing (CORS). CORS is a series of headers instructing web browsers which origins should be permitted to load resources other than the API Gateway origin.

### Intended Audience

{{< include "acm/how-to/policies/api-owner-persona.md">}}

---

## Before You Begin

To complete the steps in this guide, you need the following:

- API Connectivity Manager is installed, licensed, and running.
- An [API gateway environment]({{< relref "/nms/acm/getting-started/add-api-gateway" >}})
- A [published API Gateway]({{< relref "/nms/acm/getting-started/publish-api-proxy" >}})

---

## Policy Settings

<!-- Update the following table with the policy's params -->

The following table lists the configurable settings and their default values for the policy.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field               | Datatype     | Possible Values                                                                    | Description                                                                                                                                                                | Required | Default                                                                   |
| ------------------- | ------------ | ---------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------- |
| `allowCredentials`  | boolean      | `true`, `false`                                                                    | When set to `true`, the `Access-Control-Allow-Credentials` header is set to `true` for all responses.                                                                      | No       | `false`                                                                   |
| `allowHeaders`      | string array | Example: `["X-header-name", "Authorization"]`                                      | Used to set the `Access-Control-Allow-Headers` header, which tells the browser which headers can be used in the request.                                                   | No       | `["Authorization", "Origin", "Content-Type", "Accept", "X-Cache-Status"]` |
| `allowMethods`      | string array | `["GET", "HEAD", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "TRACE", "CONNECT"]` | Used to set the `Access-Control-Allow-Methods` header, which tells the browser which methods can be used in the request.                                                   | No       | `["GET", "HEAD", "OPTIONS"]`                                              |
| `allowOrigins`      | Origin array | Example: `[{"exact":"example1.com"},{"exact":"example2.com"}]`                     | Used to set the `Access-Control-Allow-Origins` header, which tells the browser which origins can make a request. If set to `[{"exact":"*"}]` all origins will be accepted. | No       | `[{"exact":"*"}]`                                                         |
| `exposedHeaders`    | string array | Example: `[ "header-name", "x-correlation-id", "*" ]`                              | Used to set the `Access-Control-Expose-Headers` header, which tells the browser which headers can be accessed in the response.                                             | No       | `[]`                                                                      |
| `maxAge`            | integer      | 5–60000                                                                            | Used to set the `Access-Control-Max-Age` header, which tells the browser what is the maximum length of time in seconds that preflight requests can be cached               | No       | N/A                                                                       |
| `preflightContinue` | boolean      | `true`, `false`                                                                    | When set to `true`, preflight requests are proxied to the backend service. Otherwise, they are handled by the API Gateway.                                                  | No       | `false`                                                                   |

{{< /bootstrap-table >}}


{{< note >}}
Setting a wildcard (`*`) in `exposedHeaders` does not include headers related to `Access-Control-Allow-Credentials`; those must explicitly be added to exposed headers.
{{< /note >}}

---

## Adding XYZ Policy

{{<tabs name="policy-implementation">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To create an CORS policy using the REST API, send an HTTP `PUT` request to the Proxies endpoint.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Method | Endpoint                                                |
| ------ | ------------------------------------------------------- |
| `POST` | `/services/workspaces/{SERVICE_WORKSPACE_NAME}/proxies` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

``` json
{
  "policies": {
    "cors": [
      {
        "action": {
          "allowCredentials": true,
          "allowMethods": [
            "GET", "HEAD", "PUT", "PATCH", "POST"
          ],
          "allowOrigins": [
            {
              "exact": "example.com"
            }
          ],
          "exposedHeaders": [
            "header-name", "x-correlation-id"
          ],
          "maxAge": 30000
        }
      }
    ]
  }
}
```

</details>

{{%/tab%}}

{{%tab name="UI"%}}

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Services**.
3. Select a workspace in the list that contains the API Proxy you want to update.
4. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
5. On the left menu, select **API Proxy > Advanced > Policies**.
6. On the *Advanced > Policies* page, on the **API Proxy** tab, locate **CORS**. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Add Policy**.
7. Modify the CORS configuration as needed.
8. Select **Save** to apply the policy to the API Proxy.
9. Select **Save and Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}

{{</tabs>}}

---
