---
nd-docs: DOCS-357
title: Update a security policy
description: Update an existing F5 WAF for NGINX policy using the NGINX Instance Manager web interface or REST API.
toc: true
weight: 200
nd-content-type: how-to
nd-product: NIMNGR
---

You can update an existing F5 WAF for NGINX security policy using either the NGINX Instance Manager web interface or the REST API.

---

{{<tabs name="update-security-policy">}}

{{%tab name="Web interface"%}}

To update a policy in the web interface:

1. In your browser, go to the FQDN for your NGINX Instance Manager host and log in.
1. From the Launchpad, select **Instance Manager**.
1. In the left menu, select **WAF > Policies**.
1. On the **Security Policies** page, select **Edit** from the **Actions** column for the policy you want to update.
1. The editor opens, allowing you to modify the policy as described in [Create a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/create-policy.md" >}}).
1. After making your changes, select **Save**.

{{%/tab%}}

{{%tab name="API"%}}

To update a policy using the REST API, send either a `POST` or `PUT` request to the Security Policies endpoint.

- Use `POST` with the `isNewRevision=true` parameter to create a new revision of an existing policy.
- Use `PUT` with the policy UID to overwrite the existing version.

{{< table >}}
| Method | Endpoint |
|--------|-----------|
| POST | `/api/platform/v1/security/policies?isNewRevision=true` |
| PUT | `/api/platform/v1/security/policies/{policy_uid}` |
{{</ table >}}

**Example using POST (create new revision):**

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/policies?isNewRevision=true \
  -H "Authorization: Bearer <access token>" \
  -H "Content-Type: application/json" \
  -d @update-xss-policy.json
```

**Example using PUT (overwrite existing):**

1. Retrieve the policy’s unique identifier (UID):

   ```shell
   curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/policies \
     -H "Authorization: Bearer <access token>"
   ```

1. Include the UID in your `PUT` request:

   ```shell
   curl -X PUT https://{{NIM_FQDN}}/api/platform/v1/security/policies/<policy-uid> \
     -H "Authorization: Bearer <access token>" \
     -H "Content-Type: application/json" \
     -d @update-xss-policy.json
   ```

After updating the policy, you can [publish it]({{< ref "/nim/waf-integration/policies-and-logs/publish/publish-to-instances.md" >}}) to selected instances or instance groups.

{{%/tab%}}

{{</tabs>}}
