---
title: Publish updates to instances
description: Deploy updated F5 WAF for NGINX security policies, log profiles, signatures, and threat campaigns to your NGINX instances or instance groups using the Publish API.
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIM
nd-docs: 
---

Use the NGINX Instance Manager Publish API to deploy updated security configurations to your NGINX instances or instance groups.  
You can publish security policies, log profiles, attack signatures, bot signatures, and threat campaigns.

Call this endpoint **after** you’ve created or updated the resources you want to deploy.

{{< call-out "note" "Access the REST API" >}}
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
curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/publish \
    -H "Authorization: Bearer <access token>" \
    -H "Content-Type: application/json" \
    -d @publish-request.json
```

{{< details summary="JSON request" open=true >}}

```json
{
  "publications": [
    {
      "attackSignatureLibrary": {
        "uid": "<attack-signature-library-uid>",
        "versionDateTime": "2022.10.02"
      },
      "botSignatureLibrary": {
        "uid": "<bot-signature-library-uid>",
        "versionDateTime": "2022.10.03"
      },
      "instanceGroups": [
        "<instance-group-uid>"
      ],
      "instances": [
        "<instance-uid>"
      ],
      "logProfileContent": {
        "name": "default-log-profile",
        "uid": "<log-profile-uid>"
      },
      "policyContent": {
        "name": "default-enforcement",
        "uid": "<policy-uid>"
      },
      "threatCampaign": {
        "uid": "<threat-campaign-uid>",
        "versionDateTime": "2022.10.01"
      }
    }
  ]
}
```

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
