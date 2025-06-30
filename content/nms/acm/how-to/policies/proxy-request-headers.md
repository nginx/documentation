---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  set request headers to send to your backend services.
nd-docs: DOCS-1129
toc: true
weight: 1100
title: Proxy Request Headers
type:
- reference
---

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## About the Policy

The Proxy Request Headers policy allows users to pass default and custom request headers to backend services.

This policy is enabled by default when you [publish an API Proxy]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}}).

### Intended Audience

{{< include "acm/how-to/policies/api-owner-persona.md">}}

---

## Before You Begin

To complete the steps in this guide, you need the following:

- API Connectivity Manager is installed, licensed, and running.
- An [API gateway environment]({{< ref "/nms/acm/getting-started/add-api-gateway" >}})
- A [published API Gateway]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}})

---

## Policy Settings {#policy-settings}

The following table lists the configurable settings and their default values for the policy.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                           | Type | Possible Values      | Description                                                                                                                                                                           | Required | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `proxyDefaultHeadersToBackend`                  | boolean  | `true`,<br>`false`   | <p>When set to `true`, the default headers are passed to backend services.</p><p>For more information, refer to the [Default Headers]({{< ref "#default-headers" >}}) section.</p> | No       | `True`  |
| `proxyCustomHeadersToBackend.`<br>`key`         | string   | Example: `my-header` | The name of the HTTP header.                                                                                                                                                          | Yes      | N/A     |
| `proxyCustomHeadersToBackend.`<br>`value`       | string   | Example: `var.test`  | <p>The value of the HTTP header.</p><p>For more information, refer to the [Header Value Prefixes]({{< ref "#value-prefixes" >}}) section.</p>                                      | Yes      | N/A     |
| `proxyCustomHeadersToBackend.`<br>`isSensitive` | boolean  | `true`,<br>`false`   | When set to `false`, the header will not appear in logs.                                                                                                                              | No       | `False` |

{{< /bootstrap-table >}}


### Default Headers {#default-headers}

{{<note>}}When `proxyDefaultHeadersToBackend` is `true`, the following headers are applied.{{</note>}}


{{< bootstrap-table "table table-striped table-bordered" >}}

| Header            | Description                                                |
|-------------------|------------------------------------------------------------|
| `Accept-Encoding` | Set to an empty string.                                    |
| `Host`            | Set to the IP address of the machine proxying the request. |
| `X-Real-IP`       | Set to the IP client's address.                            |
| `Connection`      | Set to an empty string.                                    |

{{< /bootstrap-table >}}


### Header Value Prefixes {#value-prefixes}

{{<note>}}When adding a custom header to `proxyCustomHeadersToBackend,` include one of the following prefixes for the `value` setting.{{</note>}}


{{< bootstrap-table "table table-striped table-bordered" >}}

| Prefix        | Example              | Description                                                                                                                                                                                    |
|---------------|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `var`         | var.content_length   | Pass a [valid NGINX variable](http://nginx.org/en/docs/varindex.html).                                                                                                                         |
| `header`      | header.referrer      | Pass a header from the client request.                                                                                                                                                         |
| `client`      | client.IP            | Pass a value from the client if a [Basic Auth]({{< ref "/nms/acm/how-to/policies/basic-authn" >}}) or [API Key]({{< ref "/nms/acm/how-to/policies/apikey-authn" >}}) policy has been configured. |
| `stringValue` | stringValue.MyString | Pass a static string.                                                                                                                                                                          |
| `token`       | token.sub            | Pass a value from the JSON Web Token (JWT) if the [OAuth2 JWT Assertion]({{< ref "/nms/acm/how-to/policies/jwt-assertion" >}}) policy has been configured.                                      |

{{< /bootstrap-table >}}


---

## Applying the Policy

You can apply this policy using either the web interface or the REST API.

<br>

{{<tabs name="add_proxy_request_policy">}}
{{%tab name="API"%}}

<br>

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To apply the Proxy Request Headers policy using the REST API, send an HTTP `PUT` request to the Proxies endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                |
|--------|---------------------------------------------------------|
| `PUT`  | `/services/workspaces/{SERVICE_WORKSPACE_NAME}/proxies` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

```json
{
  "policies": {
    "proxy-request-headers": [
      {
        "action": {
          "proxyHeaders": {
            "proxyDefaultHeadersToBackend": true,
            "proxyCustomHeadersToBackend": [
              {
                "key": "my-custom-header",
                "value": "stringValue.myValue",
                "isSensitive": true
              }
            ]
          }
        }
      }
    ]
  }
}
```

This JSON configures a policy for handling proxy request headers. It instructs the proxy to forward the default headers to the backend, and also to forward a custom header, `my-custom-header`, with a specific value, `stringValue.myValue`. The custom header is marked as sensitive, meaning it won't show up in the logs.

</details>

{{%/tab%}}
{{%tab name="UI"%}}

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Services**.
3. Select a workspace in the list that contains the API Proxy you want to update.
4. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
5. On the left menu, select **API Proxy > Advanced > Policies**.
6. On the *Advanced > Policies* page, on the **API Proxy** tab, locate **Proxy Request Headers**. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Policy**.
7. Toggle **Set Default Headers** on or off to include default headers or not. This setting is enabled by default.
8. To add custom headers, select **Add Custom Header**, then complete the necessary fields:

   - **Header**: The name of the custom HTTP header.
   - **Value**: The value of the custom HTTP header.

      The value must include one of the following prefixes:

        - `var.`
        - `header.`
        - `client.`
        - `stingValue.`
        - `token.`

      For example, to pass a static string for the value, you might type `stringValue.<my-value>` for the value.

      To learn more about the prefix options and formatting requirements, refer to the [Header Value Prefixes](#value-prefixes) section.

   - **Is Sensitive**: Turn on to prevent writing the custom header to logs.

9. Select **Save** to apply the policy to the API Proxy.
10. Select **Save and Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}
{{</tabs>}}

