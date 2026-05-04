---
title: Create and deploy profiles (REST API)
description: Create and upload a new F5 WAF for NGINX security log profile to F5 NGINX Instance Manager using the REST API.
toc: true
weight: 600
f5-content-type: how-to
f5-product: NIMNGR
f5-summary: >
  Create and upload a new F5 WAF for NGINX security log profile to F5 NGINX Instance Manager using the REST API.
  Log profiles define how security events are recorded and exported from your NGINX instances.
---

You can create and upload new F5 WAF for NGINX security log profiles using the F5 NGINX Instance Manager REST API.

A log profile defines how security events are recorded and exported from your NGINX instances.

To upload a log profile, send a `POST` request to the Security Log Profiles API endpoint. The log profile must be encoded in `base64`; sending plain JSON causes the request to fail.

{{< call-out "note" "Access the REST API" >}}
{{< include "nim/how-to-access-nim-api.md" >}}
{{< /call-out >}}

{{< table >}}

| Method | Endpoint                                |
|--------|-----------------------------------------|
| POST   | `/api/platform/v1/security/logprofiles` |

{{< /table >}}


Example:

```shell
curl -X POST https://<NIM_FQDN>/api/platform/v1/security/logprofiles \
    -H "Authorization: Bearer <access token>" \
    -d @default-log-example.json
```

<details open>
<summary>JSON Request</summary>

```json
{
  "metadata": {
    "name": "default-log-example"
  },
  "content": "Cgl7CgkJImZpbHRlciI6IHsKCQkJInJlcXVlc3RfdHlwZSI6ICJpbGxlZ2FsIgoJCX0sCgkJImNvbnRlbnQiOiB7CgkJCSJmb3JtYXQiOiAiZGVmYXVsdCIsCgkJCSJtYXhfcmVxdWVzdF9zaXplIjogImFueSIsCgkJCSJtYXhfbWVzc2FnZV9zaXplIjogIjVrIgoJCX0KCX0="
}
```

</details>

<details open>
<summary>JSON Response</summary>

```json
{
  "metadata": {
    "created": "2023-07-05T22:09:19.634358096Z",
    "externalIdType": "",
    "modified": "2023-07-05T22:09:19.634358096Z",
    "name": "default-log-example",
    "revisionTimestamp": "2023-07-05T22:09:19.634358096Z",
    "uid": "<log-profile-uid>"
  },
  "selfLink": {
    "rel": "/api/platform/v1/security/logprofiles/<log-profile-uid>"
  }
}
```
