---
title: Update a security policy
description: Update an existing F5 WAF for NGINX policy using the F5 NGINX Instance Manager web interface or REST API.
toc: true
weight: 200
f5-content-type: how-to
f5-product: NIMNGR
f5-summary: >
  Update an existing F5 WAF for NGINX security policy in F5 NGINX Instance Manager using the web interface or REST API.
  This guide covers editing the policy JSON and saving the updated version so you can deploy it to your instances.
---

You can update an existing F5 WAF for NGINX security policy using either the F5 NGINX Instance Manager web interface or the REST API.

---

{{<tabs name="update-security-policy">}}

{{%tab name="Web interface"%}}

To update a policy in the web interface:

1. Log in to NGINX Instance Manager.
1. From the Launchpad, select **NGINX Instance Manager**.
1. In the left menu, select **WAF > Policies**.
1. On the **Security Policies** page, select **Edit** from the **Actions** column for the policy you want to update.
1. The policy editor opens. Change the policy as described in [Create a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/create-policy.md" >}}).
1. After making your changes, select **Save**.

{{< call-out "note" "Note" >}}Editing a policy creates a new revision, whether or not you've deployed it.{{< /call-out >}}

{{%/tab%}}

{{%tab name="API"%}}

To update a policy using the REST API, use `POST` with `isNewRevision=true`. Both the `POST` and `PUT` methods create a new policy revision. However, `PUT` is deprecated — use `POST` instead.

{{< table >}}
| Method | Endpoint |
|--------|-----------|
| POST | `/api/platform/v1/security/policies?isNewRevision=true` |
| PUT (deprecated) | `/api/platform/v1/security/policies/{policy_uid}` |
{{</ table >}}

**Example using POST (creates a new policy revision):**

```shell
curl -X POST https://<NIM_FQDN>/api/platform/v1/security/policies?isNewRevision=true \
  -H "Authorization: Bearer <access token>" \
  -H "Content-Type: application/json" \
  -d @update-xss-policy.json
```

**Example using PUT (creates a new policy revision, deprecated):**

{{< call-out "caution" "Deprecated" >}}The `PUT` method is deprecated. Use `POST` with `isNewRevision=true` instead.{{< /call-out >}}

1. Get the policy UID:

   ```shell
   curl -X GET https://<NIM_FQDN>/api/platform/v1/security/policies \
     -H "Authorization: Bearer <access token>"
   ```

1. Include the UID in your `PUT` request:

   ```shell
   curl -X PUT https://<NIM_FQDN>/api/platform/v1/security/policies/{policy-uid} \
     -H "Authorization: Bearer <access token>" \
     -H "Content-Type: application/json" \
     -d @update-xss-policy.json
   ```

After updating the policy, you can [publish it]({{< ref "/nim/waf-integration/policies-and-logs/publish/publish-to-instances.md" >}}) to selected instances or instance groups.

{{%/tab%}}

{{</tabs>}}
