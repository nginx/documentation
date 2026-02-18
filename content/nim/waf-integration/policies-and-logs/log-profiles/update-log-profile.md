---
title: Update a security log profile
description: Update an existing F5 WAF for NGINX security log profile or create a new revision using the NGINX Instance Manager REST API.
toc: true
weight: 200
nd-content-type: how-to
nd-product: NIMNGR
---
You can update an existing F5 WAF for NGINX security log profile using the NGINX Instance Manager REST API. Depending on your workflow, you can either overwrite the current version or create a new revision.

To update a log profile, use one of the following methods:

- `POST` with the `isNewRevision=true` parameter to create a new revision.
- `PUT` with the log profile UID to overwrite the existing version.

{{< call-out "note" "Access the REST API" >}}
{{< include "nim/how-to-access-nim-api.md" >}}
{{< /call-out >}}

| Method | Endpoint                                                           |
|--------|--------------------------------------------------------------------|
| POST   | `/api/platform/v1/security/logprofiles?isNewRevision=true`         |
| PUT    | `/api/platform/v1/security/logprofiles/{security-log-profile-uid}` |

### Create a new revision

```shell
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles?isNewRevision=true \
    -H "Authorization: Bearer <access token>" \
    -H "Content-Type: application/json" \
    -d @update-default-log.json
```

### Overwrite an existing log profile

To overwrite an existing security log profile:

1. Retrieve the profile’s UID:

    ```shell
    curl -X PUT https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles/<log-profile-uid> \
      -H "Authorization: Bearer <access token>" \
      -H "Content-Type application/json" \
      -d @update-log-profile.json
    ```

2. Update the log profile using the UID:

    ```shell
    curl -X PUT https://{{NIM_FQDN}}/api/platform/v1/security/logprofiles/<log-profile-uid> \
      -H "Authorization: Bearer <access token>" \
      -H "Content-Type: application/json" \
      -d @update-log-profile.json
      ```

After updating the security log profile, you can [publish it to specific instances or instance groups]({{< ref "/nim/waf-integration/policies-and-logs/publish/_index.md" >}}).
