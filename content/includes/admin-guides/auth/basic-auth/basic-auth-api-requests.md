---
docs: DOCS-1295
---

To use basic authentication for API requests, include your base64-encoded credentials as a "Basic" token in the "Authorization" header. Here's how you can do it with cURL:

``` bash
curl -X GET "https://<NMS_FQDN>/api/platform/<API_VERSION>/systems" -H "Authorization: Basic YWRtaW..."
```

In this example, replace `<NMS_FQDN>` with your NGINX Management Suite's fully qualified domain name and `<API_VERSION>` with the API version you want to use.

The flag `-H "Authorization: Basic YWRtaW..."` sets the "Authorization" header with your base64-encoded username and password. Replace `YWRtaW...` with your actual encoded credentials.

<br>

{{< call-out "warning" "Security Consideration" >}}You can use basic authentication for API requests, but you should be cautious: credentials are sent as base64-encoded text, which is not secure encryption. If your data gets intercepted, the encoding is easily reversible. In production environments where security is critical, we recommend [switching to OpenID Connect (OIDC)]({{< relref "nms/admin-guides/authentication/oidc/getting-started-oidc.md" >}}).{{< /call-out >}}
