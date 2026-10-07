---
title: Update log profiles (REST API)
description: Update an existing F5 WAF for NGINX security log profile or create a new revision using the F5 NGINX Instance Manager REST API.
toc: true
weight: 700
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-summary: >
  Update an existing F5 WAF for NGINX security log profile in F5 NGINX Instance Manager by overwriting it or creating a new revision using the REST API.
  This guide covers both methods and when to use each.
---
You can update an existing F5 WAF for NGINX security log profile using the F5 NGINX Instance Manager REST API. Depending on your workflow, you can either overwrite the current version or create a new revision.

To update a log profile, use one of the following methods:

- `POST` with the `isNewRevision=true` parameter to create a new revision.
- `PUT` with the log profile UID to overwrite the existing version.

{{< call-out class="note" title="Access the REST API" >}}
{{< include "nim/how-to-access-nim-api.md" >}}
{{< /call-out >}}

| Method | Endpoint                                                           |
|--------|--------------------------------------------------------------------|
| POST   | `/api/platform/v1/security/logprofiles?isNewRevision=true`         |
| PUT    | `/api/platform/v1/security/logprofiles/{security-log-profile-uid}` |

### Create a new revision

```shell
curl -X POST https://<NIM_FQDN>/api/platform/v1/security/logprofiles?isNewRevision=true \
    -H "Authorization: Bearer <ACCESS_TOKEN>" \
    -H "Content-Type: application/json" \
    -d @update-default-log.json
```

Replace `<NIM_FQDN>` with the fully qualified domain name (FQDN) of your NGINX Instance Manager host and `<ACCESS_TOKEN>` with your access token.

### Overwrite an existing log profile

To overwrite an existing security log profile:

1. Retrieve the profile’s UID:

    ```shell
    curl -X GET https://<NIM_FQDN>/api/platform/v1/security/logprofiles/<LOG_PROFILE_UID> \
      -H "Authorization: Bearer <ACCESS_TOKEN>" \
    ```

    Replace `<LOG_PROFILE_UID>` with the unique identifier (UID) of the log profile.

2. Update the log profile using the UID:

    ```shell
    curl -X PUT https://<NIM_FQDN>/api/platform/v1/security/logprofiles/<LOG_PROFILE_UID> \
      -H "Authorization: Bearer <ACCESS_TOKEN>" \
      -H "Content-Type: application/json" \
      -d @update-log-profile.json
      ```

After updating the security log profile, you can [publish it to specific instances or instance groups]({{< ref "/nim/waf-integration/policies-and-logs/publish/_index.md" >}}).
