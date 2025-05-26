---
docs: DOCS-1295
---

To use basic authentication for API requests, include your base64-encoded credentials as a "Basic" token in the "Authorization" header. To create the base64-encoded credentials, run the following command:

```bash
echo -n <username>:<password> | base64
```

Once you've generated the credentials, you can include them in your API request. Here's how to do it with `curl`:

```bash
curl -X GET "https://<NIM_FQDN>/api/platform/<API_VERSION>/systems" -H "Authorization: Basic <base64_encoded_credentials>"
```

In this example, replace `<NIM_FQDN>` with your NGINX Instance Manager's fully qualified domain name and `<API_VERSION>` with the API version you want to use.

<br>

{{< call-out "warning" "Security consideration" >}}While basic authentication is an option for API requests, it comes with security risks: credentials are sent as base64-encoded text, which is not secure encryption. If the data is intercepted, the encoding can be easily reversed. For production environments, where security is critical, we strongly recommend [switching to OpenID Connect (OIDC)]({{< ref "/nim/admin-guide/authentication/oidc/getting-started.md" >}}).{{< /call-out >}}
