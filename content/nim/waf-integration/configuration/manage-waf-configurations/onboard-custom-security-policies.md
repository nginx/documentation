---
title: Onboard custom security policies
description: Upload and prepare your own security policy bundles for use with NGINX Instance Manager.
toc: true
weight: 400
nd-content-type: how-to
nd-product: NIM
nd-docs:
---

After verifying that F5 WAF for NGINX is active on your instances, you can onboard your own custom security policies. Use this option when you need to apply application-specific rules or integrate policies created in other environments. You’ll upload your JSON policy files, package them into `.tgz` bundles, and publish them through **F5 NGINX Instance Manager**.

## Before you begin

- Make sure the policy you plan to onboard is valid JSON and follows the F5 WAF for NGINX schema.  
- Confirm that the NGINX Agent has permission to access the directory where you’ll store your bundles.  
- Review the [F5 WAF for NGINX configuration guide]({{< ref "/waf/policies/configuration.md" >}}) for examples of policy structure and directive usage.

## Upload and publish a custom policy

{{<tabs name="custom_policy">}}
{{%tab name="Web interface"%}}

1. {{< include "nim/webui-nim-login.md" >}}
2. In the left menu, select **Security Policies**.
3. Choose **Upload Policy**, then select your `.json` or `.tgz` policy file.
4. If you uploaded a `.json` file, **NGINX Instance Manager** automatically compiles it into a `.tgz` bundle.
5. After upload, select **Publish** to make the policy available to your instances.

{{%/tab%}}

{{%tab name="API"%}}

{{< call-out "note" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /call-out>}}

Use the **NGINX Instance Manager** REST API to onboard policies programmatically.

{{<bootstrap-table "table">}}

| Method | Endpoint |
|--------|-----------|
| POST | `/api/platform/v1/security/policies` |
| GET | `/api/platform/v1/security/policies` |

{{</bootstrap-table>}}

Example — upload and publish a policy:

```shell
curl -X POST https://{{NMS_FQDN}}/api/platform/v1/security/policies \
 -H "Authorization: Bearer <access token>" \
 --header "Content-Type: multipart/form-data" \
 -F "file=@my-custom-policy.json"
```

The API response includes the policy ID. Use that ID to reference your custom policy in your NGINX configuration:

```nginx
app_protect_policy_file /etc/nms/my-custom-policy.tgz;
```

{{%/tab%}}
{{</tabs>}}
