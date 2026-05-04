---
title: Delete security log profiles (REST API)
description: Remove an existing F5 WAF for NGINX security log profile from F5 NGINX Instance Manager using the REST API.
toc: true
weight: 800
f5-content-type: how-to
f5-product: NIMNGR
f5-summary: >
  Remove an existing F5 WAF for NGINX security log profile from F5 NGINX Instance Manager using the REST API.
  Deleting a log profile permanently removes it and its version history from NGINX Instance Manager.
---
You can delete an existing F5 WAF for NGINX security log profile from F5 NGINX Instance Manager using the REST API.
Deleting a log profile permanently removes it from the system.

To delete a security log profile, send a `DELETE` request to the Security Log Profiles API using the profile’s UID.

{{< call-out "note" "Access the REST API" >}}
{{< include "nim/how-to-access-nim-api.md" >}}
{{< /call-out >}}

| Method | Endpoint                                                           |
|--------|--------------------------------------------------------------------|
| DELETE | `/api/platform/v1/security/logprofiles/{security-log-profile-uid}` |


1. Retrieve the UID:

    ```shell
    curl -X GET https://<NIM_FQDN>/api/platform/v1/security/logprofiles \
        -H "Authorization: Bearer <access token>"
    ```

2. Send the delete request:

    ```shell
    curl -X DELETE https://<NIM_FQDN>/api/platform/v1/security/logprofiles/<log-profile-uid> \
        -H "Authorization: Bearer <access token>"
    ```
