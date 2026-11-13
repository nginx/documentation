---
title: Update the comment on a security policy version
description: >
  Add, edit, or clear the comment on a version of an F5 WAF for NGINX security policy.
  Use a comment to record why you created or changed a version, without changing the
  policy content or creating a new version.
canonical: /nginx-instance-manager/waf-integration/policies-and-logs/policies/update-policy-version-comment/
toc: true
weight: 210
f5-content-type: how-to
f5-product: F5 NGINX Instance Manager
f5-keywords: "security policy comment, policy version comment, versionComment, update policy comment, clear policy comment, WAF policy version, PATCH"
f5-summary: >
  Add, edit, or clear the comment on a version of an F5 WAF for NGINX security policy
  in F5 NGINX Instance Manager, using the web interface or REST API.
f5-audience: admin
---

## Overview

Use this guide to add, edit, or clear the comment on a version of an F5 WAF for NGINX security policy. A comment helps you track why you created or changed that version.

When you update a comment, the policy content and version number stay the same. F5 NGINX Instance Manager doesn't create a new version. To change the policy content itself, see [Update a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/update-policy.md" >}}).

---

## Before you begin

Make sure you have permission to update security policies. Keep these limits in mind:

- A comment can contain up to 150 Unicode code points.
- You can't change the comment on the built-in `NginxDefaultPolicy` or `NginxStrictPolicy` policies.

---

{{<tabs name="update-policy-version-comment">}}

{{%tab name="Web interface"%}}

### Add a comment while you save a policy

1. Log in to NGINX Instance Manager.
1. From the Launchpad, select **NGINX Instance Manager**.
1. Select **WAF** > **Policies**.
1. Select **Create** to create a new policy, or select **Edit** from the **Actions** column for the policy you want to update.
1. Make your changes in the policy editor.
1. Select **Save & Add Comment**. The **Add Comment** dialog opens and shows the policy name and version number.
1. Enter a comment in the **Comment** box, then select **Save**. A counter shows how many of the 150 characters you've used.

### Edit or clear a comment on an existing version

1. Select **WAF** > **Policies**, then select the policy.
1. Select the **Versions** tab.
1. Select **Edit Comment** from the **Actions** column for the version you want to update. The **Edit Comment** dialog opens and shows the current comment.
1. Edit the text in the **Comment** box, then select **Save**. A counter shows how many of the 150 characters you've used. To clear the comment, remove its text and select **Save**.

{{< call-out class="note" title="Note" >}}
If a policy has more than 100 versions, NGINX Instance Manager warns that memory usage might increase. To reduce memory usage, delete unused versions or increase available memory. This warning doesn't block you from creating new versions.
{{< /call-out >}}

{{%/tab%}}

{{%tab name="API"%}}

Use `PATCH` to update the comment on a specific policy version.

{{< table >}}
| Method | Endpoint |
|--------|-----------|
| PATCH | `/api/platform/v1/security/policies/{securityPolicyUID}` |
{{</ table >}}

### Update a comment

1. Get the UID of the policy version you want to update:

   ```shell
   curl -G 'https://<NIM_FQDN>/api/platform/v1/security/policies' \
     -H "Authorization: Bearer <ACCESS_TOKEN>" \
     --data-urlencode 'versions=<POLICY_NAME>'
   ```

   Find the `versionNumber` you want in the response, then use its `uid` value. A version label such as `v2` isn't the UID.

1. Send a `PATCH` request with the new comment:

   ```shell
   curl -X PATCH 'https://<NIM_FQDN>/api/platform/v1/security/policies/<POLICY_VERSION_UID>' \
     -H "Authorization: Bearer <ACCESS_TOKEN>" \
     -H "Content-Type: application/json" \
     -d '{"versionComment":"Prepared for production rollout"}'
   ```

   Replace `<NIM_FQDN>` with your NGINX Instance Manager host, `<ACCESS_TOKEN>` with your access token, and `<POLICY_VERSION_UID>` with the UID of the version you want to update.

   A successful request returns HTTP `200` and the updated policy version metadata.

### Clear a comment

Send a `PATCH` request with an empty `versionComment` value:

```shell
curl -X PATCH 'https://<NIM_FQDN>/api/platform/v1/security/policies/<POLICY_VERSION_UID>' \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{"versionComment":""}'
```

{{%/tab%}}

{{</tabs>}}

---

## See also

- [Update a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/update-policy.md" >}})
- [Create a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/create-policy.md" >}})
- [Review a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/review-policy.md" >}})
