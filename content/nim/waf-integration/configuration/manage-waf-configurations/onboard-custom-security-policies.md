---
title: Onboard custom security policies
description: Add your own custom security policies to F5 NGINX Instance Manager using the JSON editor or REST API.
toc: true
weight: 400
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-summary: >
  Add custom F5 WAF for NGINX security policies to F5 NGINX Instance Manager using the JSON editor or REST API.
  Use this option when you need application-specific rules or want to integrate policies created outside NGINX Instance Manager.
---

After verifying that F5 WAF for NGINX is active on your instances, you can onboard your own custom security policies. Use this option when you need to apply application-specific rules or integrate policies created in other environments.

## Before you begin

- Make sure the policy you plan to onboard is valid JSON and follows the F5 WAF for NGINX schema.  
- Confirm that the NGINX Agent has permission to access the directory where you’ll store your bundles.  
- Review the [F5 WAF for NGINX configuration guide]({{< ref "/waf/policies/configuration.md" >}}) for examples of policy structure and directive usage.

## Add a custom policy

{{<tabs name="custom_policy">}}
{{%tab name="Web interface"%}}

{{< call-out class="note" title="Version note" >}}The **Upload Policy** option was available in F5 NGINX Instance Manager 2.20.0 and earlier. In 2.22.0 and later, use the following procedure to add a custom policy using the JSON tab.{{< /call-out >}}

1. {{< include "nim/webui-nim-login.md" >}}
2. In the left menu, go to **WAF > Policies**.
3. Select **Create**.
4. Select the **JSON** tab.
5. In the text area, remove the existing default policy content.
6. Paste your custom policy JSON.
7. Correct any policy validation errors shown by the interface.
8. Select **Add Policy**.

{{%/tab%}}

{{%tab name="API"%}}

{{< call-out class="note" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /call-out>}}

Use the **NGINX Instance Manager** REST API to onboard policies programmatically.

{{<table>}}

| Method | Endpoint |
|--------|-----------|
| POST | `/api/platform/v1/security/policies` |
| GET | `/api/platform/v1/security/policies` |

{{</table >}}

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
