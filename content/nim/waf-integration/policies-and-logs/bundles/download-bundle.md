---
title: Download a security policy bundle
description: Download a compiled F5 WAF for NGINX security bundle from F5 NGINX Instance Manager as a `.tgz` file for reuse or offline deployment.
toc: true
weight: 200
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-summary: >
  Download a compiled F5 WAF for NGINX security bundle from F5 NGINX Instance Manager as a .tgz file.
  Downloaded bundles can be reused for offline deployments or transferred to other NGINX Instance Manager environments.
---

{{<tabs name="download-bundle">}}

{{%tab name="Web interface"%}}

To download a security policy bundle using the F5 NGINX Instance Manager web interface:

1. In your browser, go to the FQDN for your NGINX Instance Manager host and log in.
2. In the left menu, select **WAF > Policies**.
3. On the **Security Policies** page, find the policy you want to download a bundle for.
4. Select the **Actions** menu (…) and choose **Download Bundle**.
   - The **Download Bundle** option is available only when the **Compilation Status** is **Compiled**.
5. When the download starts, a `.tgz` file named `<POLICY_NAME>-security-policy-bundle.tgz` is saved to your system.

> **Note:** By default, **Download Bundle** retrieves the policy's latest bundle revision using the newest WAF compiler version it has been compiled with.

{{% /tab %}}

{{%tab name="REST API"%}}

To download a specific security policy bundle, send a `GET` request to the Security Policy Bundles API using the policy UID and bundle UID in the URL path.

You must have `"READ"` permission for the bundle to retrieve it.

| Method | Endpoint |
|--------|-----------|
| GET | `/api/platform/v1/security/policies/{security-policy-uid}/bundles/{security-policy-bundle-uid}` |

Example:

```shell
curl -X GET https://<NIM_FQDN>/api/platform/v1/security/policies/{policy_uid}/bundles/{bundle_uid} \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

Replace the placeholders as follows:

- `<NIM_FQDN>`: the fully qualified domain name (FQDN) of your NGINX Instance Manager host
- `{policy_uid}`: the unique identifier (UID) of the security policy
- `{bundle_uid}`: the unique identifier (UID) of the security policy bundle
- `<ACCESS_TOKEN>`: your access token

The response includes a `content` field that contains the bundle in base64 format. To use it, decode the content and save it as a `.tgz` file.

Example:

```shell
curl -X GET "https://<NIM_FQDN>/api/platform/v1/security/policies/{policy_uid}/bundles/{bundle_uid}" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" | jq -r '.content' | base64 -d > security-policy-bundle.tgz
```

{{< details summary="JSON response" open=true >}}

```json
{
  "metadata": {
    "created": "2023-10-04T23:19:58.502Z",
    "modified": "2023-10-04T23:19:58.502Z",
    "appProtectWAFVersion": "4.457.0",
    "policyUID": "<POLICY_UID>",
    "attackSignatureVersionDateTime": "2023.08.10",
    "botSignatureVersionDateTime": "2023.08.09",
    "threatCampaignVersionDateTime": "2023.08.09",
    "uid": "<BUNDLE_UID>"
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
