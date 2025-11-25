---
title: Download a security policy bundle
description: Download a compiled F5 WAF for NGINX security bundle from NGINX Instance Manager as a `.tgz` file for reuse or offline deployment.
toc: true
weight: 200
nd-content-type: how-to
nd-product: NIMNGR
nd-docs: 
---

{{<tabs name="download-bundle">}}

{{%tab name="Web interface"%}}

To download a security policy bundle using the NGINX Instance Manager web interface:

1. In your browser, go to the FQDN for your NGINX Instance Manager host and log in.  
2. In the left menu, select **WAF > Policies**.  
3. On the **Security Policies** page, find the policy you want to download a bundle for.  
4. Select the **Actions** menu (…) and choose **Download Bundle**.  
   - The **Download Bundle** option is available only when the **Compilation Status** is **Compiled**.  
5. When the download starts, a `.tgz` file named `<PolicyName>-security-policy-bundle.tgz` is saved to your system.  

> **Note:** By default, **Download Bundle** retrieves the latest bundle revision of the selected policy.

{{% /tab %}}

{{%tab name="REST API"%}}

To download a specific security policy bundle, send a `GET` request to the Security Policy Bundles API using the policy UID and bundle UID in the URL path.

You must have `"READ"` permission for the bundle to retrieve it.

| Method | Endpoint |
|--------|-----------|
| GET | `/api/platform/v1/security/policies/{security-policy-uid}/bundles/{security-policy-bundle-uid}` |

Example:

```shell
curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/policies/<policy-uid>/bundles/<bundle-uid> \
  -H "Authorization: Bearer <access token>"
```

The response includes a `content` field that contains the bundle in base64 format. To use it, decode the content and save it as a `.tgz` file.

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/security/policies/<policy-uid>/bundles/<bundle-uid>" \
  -H "Authorization: Bearer <access token>" | jq -r '.content' | base64 -d > security-policy-bundle.tgz
```

{{< details summary="JSON response" open=true >}}

```json
{
  "metadata": {
    "created": "2023-10-04T23:19:58.502Z",
    "modified": "2023-10-04T23:19:58.502Z",
    "appProtectWAFVersion": "4.457.0",
    "policyUID": "<policy-uid>",
    "attackSignatureVersionDateTime": "2023.08.10",
    "botSignatureVersionDateTime": "2023.08.09",
    "threatCampaignVersionDateTime": "2023.08.09",
    "uid": "<bundle-uid>"
  },
  "content": "ZXZlbnRzIHt9Cmh0dHAgeyAgCiAgICBzZXJ2ZXIgeyAgCiAgICAgICAgbGlzdGVuIDgwOyAgCiAgICAgICAgc2VydmVyX25hbWUgXzsKCiAgICAgICAgcmV0dXJuIDIwMCAiSGVsbG8iOyAgCiAgICB9ICAKfQ==",
  "compilationStatus": {
    "status": "compiled",
    "message": ""
  }
}
```

{{< /details >}}

{{% /tab %}}

{{< /tabs >}}
