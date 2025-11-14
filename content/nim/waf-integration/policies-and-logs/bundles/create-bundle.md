---
title: Create a security policy bundle
description: Create a precompiled security bundle that packages your F5 WAF for NGINX policies, signatures, and threat campaigns into a single file for efficient, reusable deployment across instances.
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIM
nd-docs: 
---

NGINX Instance Manager lets you package your complete F5 WAF for NGINX configuration into a precompiled bundle for faster, more reliable deployments.  

A security policy bundle includes your policies, attack signatures, bot signatures, and threat campaigns—compiled into a single `.tgz` file that can be deployed across multiple instances.  

Precompiling with NGINX Instance Manager reduces processing overhead on WAF instances and ensures consistent, reusable configurations.

{{< call-out "note" "See also" >}}For a full overview of how NGINX Instance Manager handles WAF policy management, compilation, and deployment, see [How WAF policy management works]({{< ref "/nim/waf-integration/overview.md" >}}).{{< /call-out >}}

{{<tabs name="create-bundles">}}

{{%tab name="Web interface"%}}

To create a security policy bundle using the NGINX Instance Manager web interface:

1. In your browser, go to the FQDN for your NGINX Instance Manager host and log in.
2. In the left menu, select **WAF > Policies**.
3. On the **Security Policies** page, find the policy you want to create a bundle for.
4. Select the **Actions** menu (…) and choose **Compile**.
5. Check the **Compilation Status** column to monitor the bundle creation progress.  
   - The default status is **Not Compiled**.  
   - Other states include **Compiling**, **Compiled**, and **Error**.

> **Note:** By default, **Compile** uses the latest revision of the selected policy, the latest available compiler version, and the most recent versions of attack signatures, bot signatures, and threat campaigns.

{{% /tab %}}

{{%tab name="REST API"%}}

To create a security policy bundle, send a `POST` request to the Security Policy Bundles API. The policies you want to include in the bundle must already exist in NGINX Instance Manager.

Each bundle includes:

- A security policy  
- Attack signatures  
- Bot signatures  
- Threat campaigns  
- A version of F5 WAF for NGINX  
- Supporting files required to compile and deploy the bundle  

### Required fields

- `appProtectWAFVersion`: The version of F5 WAF for NGINX to target.  
- `policyName`: The name of the policy to include. Must reference an existing policy.  
- `policyUID`: Optional. If omitted, the latest revision of the specified policy is used. This field does **not** accept the keyword `latest`.  

If you don’t include `attackSignatureVersionDateTime`, `botSignatureVersionDateTime`, or `threatCampaignVersionDateTime`, the latest versions are used by default. You can also set them explicitly by using `"latest"` as the value.

| Method | Endpoint |
|--------|-----------|
| POST | `/api/platform/v1/security/policies/bundles` |

Example:

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/policies/bundles \
  -H "Authorization: Bearer <access token>" \
  -H "Content-Type: application/json" \
  -d @security-policy-bundles.json
```

{{< details summary="JSON request" open=true >}}

```json
{
  "bundles": [
    {
      "appProtectWAFVersion": "4.457.0",
      "policyName": "default-enforcement",
      "policyUID": "<policy-uid>",
      "attackSignatureVersionDateTime": "2023.06.20",
      "botSignatureVersionDateTime": "2023.07.09",
      "threatCampaignVersionDateTime": "2023.07.18"
    },
    {
      "appProtectWAFVersion": "4.279.0",
      "policyName": "default-enforcement",
      "attackSignatureVersionDateTime": "latest",
      "botSignatureVersionDateTime": "latest",
      "threatCampaignVersionDateTime": "latest"
    },
    {
      "appProtectWAFVersion": "4.457.0",
      "policyName": "ignore-xss"
    }
  ]
}
```

{{< /details >}}

{{< details summary="JSON response" open=true >}}

```json
{
  "items": [
    {
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.457.0",
        "policyName": "default-enforcement",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.06.20",
        "botSignatureVersionDateTime": "2023.07.09",
        "threatCampaignVersionDateTime": "2023.07.18",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiling",
        "message": ""
      }
    },
    {
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.279.0",
        "policyName": "default-enforcement",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.08.10",
        "botSignatureVersionDateTime": "2023.08.09",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiling",
        "message": ""
      }
    },
    {
      "metadata": {
        "created": "2023-10-04T23:19:58.502Z",
        "modified": "2023-10-04T23:19:58.502Z",
        "appProtectWAFVersion": "4.457.0",
        "policyName": "ignore-xss",
        "policyUID": "<policy-uid>",
        "attackSignatureVersionDateTime": "2023.08.10",
        "botSignatureVersionDateTime": "2023.08.09",
        "threatCampaignVersionDateTime": "2023.08.09",
        "uid": "<bundle-uid>"
      },
      "content": "",
      "compilationStatus": {
        "status": "compiling",
        "message": ""
      }
    }
  ]
}
```

{{< /details >}}

{{% /tab %}}

{{< /tabs >}}
