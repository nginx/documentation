---
title: Publish updates to instances
description: Deploy updated F5 WAF for NGINX security policies, log profiles, signatures, and threat campaigns to your NGINX instances or instance groups using the Publish API.
toc: true
weight: 100
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-summary: >
  Deploy updated F5 WAF for NGINX security configurations to your NGINX instances or instance groups using the F5 NGINX Instance Manager Publish API.
  You can publish security policies, log profiles, attack signatures, bot signatures, and threat campaigns in a single request.
---

Use the F5 NGINX Instance Manager Publish API to deploy updated security configurations to your NGINX instances or instance groups.
You can publish security policies, log profiles, attack signatures, bot signatures, and threat campaigns.

Call this endpoint **after** you’ve created or updated the resources you want to deploy.

{{< call-out class="note" title="Access the REST API" >}}
{{< include "nim/how-to-access-nim-api.md" >}}
{{< /call-out >}}

| Method | Endpoint |
|--------|-----------|
| POST | `/api/platform/v1/security/publish` |

### Information to include in your request

Include the following details in your request body, depending on what you’re publishing:

- Instance and instance group UIDs
- Policy UID and name
- Log profile UID and name
- Attack signature library UID and version
- Bot signature library UID and version
- Threat campaign UID and version

### Example request

```shell
curl -X POST https://<NIM_FQDN>/api/platform/v1/security/publish \
    -H "Authorization: Bearer <ACCESS_TOKEN>" \
    -H "Content-Type: application/json" \
    -d @publish-request.json
```

Replace `<NIM_FQDN>` with the fully qualified domain name (FQDN) of your NGINX Instance Manager host and `<ACCESS_TOKEN>` with your access token.

{{< details summary="JSON request" open=true >}}

```json
{
  "publications": [
    {
      "attackSignatureLibrary": {
        "uid": "<ATTACK_SIGNATURE_LIBRARY_UID>",
        "versionDateTime": "2022.10.02"
      },
      "botSignatureLibrary": {
        "uid": "<BOT_SIGNATURE_LIBRARY_UID>",
        "versionDateTime": "2022.10.03"
      },
      "instanceGroups": [
        "<INSTANCE_GROUP_UID>"
      ],
      "instances": [
        "<INSTANCE_UID>"
      ],
      "logProfileContent": {
        "name": "default-log-profile",
        "uid": "<LOG_PROFILE_UID>"
      },
      "policyContent": {
        "name": "default-enforcement",
        "uid": "<POLICY_UID>"
      },
      "threatCampaign": {
        "uid": "<THREAT_CAMPAIGN_UID>",
        "versionDateTime": "2022.10.01"
      }
    }
  ]
}
```

Replace the placeholders as follows:

- `<ATTACK_SIGNATURE_LIBRARY_UID>`: the unique identifier (UID) of the attack signature library
- `<BOT_SIGNATURE_LIBRARY_UID>`: the unique identifier (UID) of the bot signature library
- `<INSTANCE_GROUP_UID>`: the unique identifier (UID) of the instance group
- `<INSTANCE_UID>`: the unique identifier (UID) of the instance
- `<LOG_PROFILE_UID>`: the unique identifier (UID) of the log profile
- `<POLICY_UID>`: the unique identifier (UID) of the security policy
- `<THREAT_CAMPAIGN_UID>`: the unique identifier (UID) of the threat campaign library

{{< /details >}}

{{< details summary="JSON response" open=true >}}

```json
{
  "deployments": [
    {
      "deploymentUID": "ddc781ca-15d6-46c9-86ea-e7bdb91e8dec",
      "links": {
        "rel": "/api/platform/v1/security/deployments/ddc781ca-15d6-46c9-86ea-e7bdb91e8dec"
      },
      "result": "Publish security content request Accepted"
    }
  ]
}
```

{{< /details >}}
