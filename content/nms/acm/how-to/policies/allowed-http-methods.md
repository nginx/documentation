---
description: Learn how to block unwelcome requests to an endpoint by using the Allowed
  HTTP Methods policy in F5 NGINX Management Suite API Connectivity Manager.
nd-docs: DOCS-1121
title: Allowed HTTP Methods
toc: true
weight: 350
type:
- concept
---

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## About Allow HTTP Methods Policy

Use the *Allowed HTTP Methods* policy to specify which methods you want to allow, while automatically blocking all the others. As an example, you could allow only `GET` requests for static content.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Before You Begin

To complete the steps in this guide, you need the following:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more [Environments with an API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have [published one or more API Gateways]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}}).

---

## Policy Settings


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field            | Type  | Possible Values                                                        | Description                                                                                                                                                                                                                                                                                                                | Required | Default&nbsp;value    |
|------------------|-------|------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|-----------------------|
| `allowedMethods` | array | `GET`, `PUT`, `POST`, `PATCH`, `DELETE`, `CONNECT`, `OPTIONS`, `TRACE` | <p>This array contains all of the possible HTTP methods.</p><p>Methods listed in `allowedMethods` will be accepted; any omitted methods will be blocked with a return code of `405 Method Not Allowed` (default), or a code of your choice.</p><p>Note: `HEAD` requests are treated the same as `GET` requests.</p> | Yes      |                       |
| `returnCode`     | int   | In range `400-599`                                                     | The status code to be returned if a method isn't included in the `allowedMethods` array.                                                                                                                                                                                                                                   | No       | System assigned `405` |

{{< /bootstrap-table >}}


---

## Applying the Policy

Follow these steps to restrict which HTTP methods clients can use to access your API. If the request's HTTP method is not in the allowed methods list, a `405 Method Not Allowed` response is returned by default, or you can specify a different error code.

{{< call-out "note" >}} By enabling the `GET` method, the `HEAD` method is also enabled. {{< /call-out >}}

<br>

{{<tabs name="add_allowed_http_methods">}}

{{%tab name="API"%}}

{{< call-out "note" >}}{{< include "acm/how-to/access-acm-api.md" >}}{{< /call-out>}}

To create an *Allowed HTTP Methods* policy using the REST API, send an HTTP `POST` request to the Proxies endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                           |
|--------|----------------------------------------------------|
| `POST` | `/services/workspaces/{service-workspace}/proxies` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

```json
{
  "policies": {
    "allowed-http-methods": [
      {
        "action": {
          "allowedMethods": [
            "GET",
            "PUT",
            "POST",
            "PATCH",
            "DELETE",
            "CONNECT",
            "OPTIONS",
            "TRACE"
          ],
          "returnCode": 405
        }
      }
    ]
  }
}
```

This JSON defines an *Allowed HTTP Methods* policy that specifies which HTTP methods are allowed. The listed methods (`GET`, `PUT`, `POST`, `PATCH`, `DELETE`, `CONNECT`, `OPTIONS`, `TRACE`) are all allowed, and any other methods will return a `405 Method Not Allowed` response code.

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To create an *Allowed HTTP Methods* policy using the web interface:

1. {{< include "acm/webui-acm-login.md" >}}
2. On the left menu, select **Services**.
3. Select a workspace in the list that contains the API Proxy you want to update.
4. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
5. On the left menu, select **API Proxy > Advanced > Policies**.
6. On the *Advanced > Policies* page, on the **API Proxy** tab, locate **Allowed HTTP Methods**. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Add Policy**.
7. On the *Allowed HTTP Methods* form, complete the necessary fields:

   - **Allow following HTTP Methods**: Specify the HTTP methods you want to allow. Any methods that aren't included will be blocked.
   - **Custom response code for non-matching requests**: Specify the status code to return for blocked methods. The default is `405 Method Not Allowed`.

8. Select **Add** to apply the policy to the API proxy.
9. Select **Save and Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}

{{</tabs>}}
