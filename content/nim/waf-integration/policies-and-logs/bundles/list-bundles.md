---
nd-docs: DOCS-367
title: List security policy bundles
description: View and filter the list of compiled F5 WAF for NGINX security bundles in NGINX Instance Manager, including their status, version, and associated policies.
toc: true
weight: 300
nd-content-type: how-to
nd-product: NIMNGR
---

{{<tabs name="list-bundles">}}

{{%tab name="Web interface"%}}

To view the list of security policy bundles using the NGINX Instance Manager web interface:

1. In your browser, go to the FQDN for your NGINX Instance Manager host and log in.
2. In the left menu, select **WAF > Policies**.

The list shows all available security policy bundles, including their compilation status and associated F5 WAF for NGINX version.

{{% /tab %}}

{{%tab name="REST API"%}}

To list all security policy bundles, send a `GET` request to the Security Policy Bundles API.

You’ll only see bundles you have `"READ"` permissions for.

You can use the following query parameters to filter results:

- `includeBundleContent`: Whether to include base64-encoded content in the response. Defaults to `false`.
- `policyName`: Return only bundles that match this policy name.
- `policyUID`: Return only bundles that match this policy UID.
- `startTime`: Return only bundles modified at or after this time.
- `endTime`: Return only bundles modified before this time.

If no time range is provided, the API defaults to showing bundles modified in the past 24 hours.

| Method | Endpoint |
|--------|-----------|
| GET | `/api/platform/v1/security/policies/bundles` |

Example:

```shell
curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/policies/bundles \
  -H "Authorization: Bearer <access token>"
```

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
        "status": "compiled",
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
        "status": "compiled",
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