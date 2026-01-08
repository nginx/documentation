---
nd-docs: DOCS-359
title: Create a security policy
description: Create and customize F5 WAF for NGINX security policies in NGINX Instance Manager using the web interface or REST API.
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIMNGR
---

You can create and manage security policies in F5 NGINX Instance Manager to control F5 WAF for NGINX behavior. When you create a policy, the interface provides guided options and presets aligned with F5 WAF for NGINX. If you’re familiar with WAF configuration, you can also customize your policy directly in JSON.

{{< call-out "note" "See also" >}}For a full overview of how NGINX Instance Manager handles WAF policy management, compilation, and deployment, see [How WAF policy management works]({{< ref "/nim/waf-integration/overview.md" >}}).{{< /call-out >}}

---

{{<tabs name="create-security-policy">}}

{{%tab name="Web interface"%}}

To create a security policy using the NGINX Instance Manager web interface:

1. In NGINX Instance Manager, go to **WAF > Policies**.
2. On the **Security Policies** page, select **Create**.
3. In **General Settings**, enter a name and description for the policy.
4. Choose an enforcement mode:
   - **Transparent** – Logs violations but doesn’t block requests.
   - **Blocking** – Blocks requests that match the configured policy.

   In the configuration file, this is set using the `enforcementMode` property.

5. To change character encoding, select **Show Advanced Fields**, then choose an application language. The default encoding is Unicode (`utf-8`).

### Configure a policy

When you use the web interface, a default policy is created automatically. You can also select **NGINX Strict** for a stricter configuration.

### Default policy and base template

The default policy is based on the base template, which serves as a starting point for all policies.

**Example default policy:**

```json
{
  "policy": {
    "name": "app_protect_default_policy",
    "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" }
  }
}
```

### Violation rating

The default policy uses the violation rating to assess risk and decide whether to block a request:

{{< table >}}
| Rating | Description |
|---------|-------------|
| 0 | No violation |
| 1–2 | False positive |
| 3 | Needs examination |
| 4–5 | Threat |
{{</ table >}}

By default, most violations and signature sets have Alarm enabled but not Block. If a request’s violation rating is 4 or 5, it’s blocked by the `VIOL_RATING_THREAT` violation, even if other violations are only set to Alarm. This approach minimizes false positives while maintaining strong protection.

To block requests with a rating of 3, enable blocking for the `VIOL_RATING_NEED_EXAMINATION` violation.

### Default blocking behavior

The following violations and signature sets are considered high accuracy and are configured to block requests regardless of violation rating:

- High-accuracy attack signatures
- Threat campaigns
- Malformed requests (for example, unparsable headers, cookies, or JSON/XML bodies)

{{%/tab%}}

{{%tab name="API"%}}

To create a security policy using the REST API, send a `POST` request to the Security Policies endpoint. The JSON policy must be encoded in `base64`. If you send plain JSON, the request fails.

{{< table >}}
| Method | Endpoint |
|--------|-----------|
| POST | `/api/platform/v1/security/policies` |
{{</ table >}}

**Example:**

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/policies \
  -H "Authorization: Bearer <access token>" \
  -H "Content-Type: application/json" \
  -d @ignore-xss-example.json
```

{{< details summary="JSON request" open=true >}}

```json
{
  "metadata": {
    "name": "ignore-cross-site-scripting",
    "displayName": "Ignore cross-site scripting",
    "description": "A security policy that intentionally ignores cross-site scripting."
  },
  "content": "ewoJInBvbGljeSI6IHsKCQkibmFtZSI6ICJzaW1wbGUtYmxvY2tpbmctcG9saWN5IiwKCQkic2lnbmF0dXJlcyI6IFsKCQkJewoJCQkJInNpZ25hdHVyZUlkIjogMjAwMDAxODM0LAoJCQkJImVuYWJsZWQiOiBmYWxzZQoJCQl9CgkJXSwKCQkidGVtcGxhdGUiOiB7CgkJCSJuYW1lIjogIlBPTElDWV9URU1QTEFURV9OR0lOWF9CQVNFIgoJCX0sCgkJImFwcGxpY2F0aW9uTGFuZ3VhZ2UiOiAidXRmLTgiLAoJCSJlbmZvcmNlbWVudE1vZGUiOiAiYmxvY2tpbmciCgl9Cn0="
}
```

{{< /details >}}

{{< details summary="JSON response" open=true >}}

```json
{
  "metadata": {
    "created": "2022-04-10T23:19:58.502Z",
    "description": "string",
    "displayName": "Ignore cross-site scripting",
    "modified": "2022-04-12T23:19:58.502Z",
    "name": "ignore-cross-site-scripting",
    "revisionTimestamp": "2022-04-12T23:19:58.502Z",
    "uid": "<policy-uid>"
  },
  "selfLink": {
    "rel": "/api/platform/v1/services/environments/prod"
  }
}
```

{{< /details >}}

{{%/tab%}}

{{< /tabs >}}
