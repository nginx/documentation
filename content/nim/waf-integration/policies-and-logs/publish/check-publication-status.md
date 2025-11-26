---
title: Check publication status
description: Verify the deployment status of published F5 WAF for NGINX security policies, log profiles, and related updates in NGINX Instance Manager.
toc: true
weight: 200
nd-content-type: how-to
nd-product: NIMNGR
nd-docs: 
---

After you publish security updates, you can check their deployment status using the NGINX Instance Manager REST API.

These endpoints help you verify whether security policies, log profiles, and other configurations were successfully deployed to instances or instance groups.

{{< call-out "note" "Access the REST API" >}}
{{< include "nim/how-to-access-nim-api.md" >}}
{{< /call-out >}}

---

### Check publication status for a security policy

To view deployment status for a specific policy, send a `GET` request to the Security Deployments Associations API using the policy name.

| Method | Endpoint                                                           |
|--------|--------------------------------------------------------------------|
| GET    | `/api/platform/v1/security/deployments/associations/{policy-name}` |

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/security/deployments/associations/ignore-xss" \
  -H "Authorization: Bearer <access token>"
```

In the response, check the `lastDeploymentDetails` field under `instance` or `instanceGroup.instances` for deployment results.

---

### Check publication status for a security log profile

| Method | Endpoint                                                                            |
|--------|-------------------------------------------------------------------------------------|
| GET    | `/api/platform/v1/security/deployments/logprofiles/associations/{log-profile-name}` |

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/security/deployments/logprofiles/associations/default-log" \
  -H "Authorization: Bearer <access token>"
```

The response includes a `lastDeploymentDetails` field for each instance or instance group.

---

### Check status for a specific instance

To view deployment status for a specific instance, provide the system UID and instance UID.

| Method | Endpoint                                                         |
|--------|------------------------------------------------------------------|
| GET    | `/api/platform/v1/systems/{system-uid}/instances/{instance-uid}` |

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/systems/<system-uid>/instances/<instance-uid>" \
  -H "Authorization: Bearer <access token>"
```

In the response, the `lastDeploymentDetails` field shows deployment status, timestamps, and any related error messages.

---

### Check deployment result by deployment ID

When you use the Publish API to [publish security content](#publish-policy), NGINX Instance Manager assigns a deployment ID to the request.  
You can use this ID to check the final result of the publication.

| Method | Endpoint                                                         |
|--------|------------------------------------------------------------------|
| GET    | `/api/platform/v1/systems/instances/deployments/{deployment-id}` |

Example:

```shell
curl -X GET "https://{{NIM_FQDN}}/api/platform/v1/systems/instances/deployments/<deployment-id>" \
  -H "Authorization: Bearer <access token>"
```

The response includes detailed deployment information, including success or failure status and any compiler error messages.
