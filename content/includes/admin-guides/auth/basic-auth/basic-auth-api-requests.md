---
docs: DOCS-1295
---

To use basic authentication for API requests, include your base64-encoded credentials as a "Basic" token in the "Authorization" header. To set up base64-encoded
credentials, run the following command:

```bash
echo -n <username>:<password> | base64
```

Now you can include those credentials with your API request. Here's how you can do it with `curl`:

``` bash
curl -X GET "https://<NMS_FQDN>/api/platform/<API_VERSION>/systems" -H "Authorization: Basic <base64 encoded credentials>"
```

In this example, replace `<NMS_FQDN>` with your NGINX Management Suite's fully qualified domain name and `<API_VERSION>` with the API version you want to use.

<br>

{{< call-out "warning" "Security Consideration" >}}You can use basic authentication for API requests, but you should be cautious: credentials are sent as base64-encoded text, which is not secure encryption. If your data gets intercepted, the encoding is easily reversible. In production environments where security is critical, we recommend [switching to OpenID Connect (OIDC)]({{< relref "nms/admin-guides/authentication/oidc/getting-started-oidc.md" >}}).{{< /call-out >}}
