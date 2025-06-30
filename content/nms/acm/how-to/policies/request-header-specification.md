---
description: Learn how to set up the Request Header Specification policy in API Connectivity
  Manager to process headers with invalid characters.
nd-docs: DOCS-1263
title: Request Header Specification
toc: true
weight: 1300
type:
- how-to
---

## Overview

{{< include "acm/how-to/policies-intro" >}}

---

## About the Policy

Use the Request Header Specification policy to allow headers that would normally be considered invalid. This can be used to treat underscores as valid or allow all special header characters.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Workflow for Applying Policy

To apply the policy or make changes to it, here's what you need to do:

- [Edit an existing environment or create a new one]({{< ref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#add-environment" >}}).
- Check the advanced settings for the environment to see if the policy has been applied.
- Edit the policy to make changes for each environment. Save and publish the changes.

---

## Policy Settings


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field            | Type   | Possible Values                | Description                                                  | Required | Default Value      |
|------------------|--------|--------------------------------|--------------------------------------------------------------|----------|--------------------|
| `invalidHeadersBehaviour` | string | Example:<br>`ALLOW_ALL` | This can be set to `IGNORE_ALL` (the default behavior for NGINX), `ALLOW_UNDERSCORE`, or `ALLOW_ALL` | YES      | `ALLOW_ALL` |

{{< /bootstrap-table >}}


---

## Applying the Policy

You can apply this policy using either the web interface or the REST API. Configuring the policy to `invalidHeadersBehaviour: IGNORE_ALL` will result in the same behavior as not applying the policy.

<br>

{{<tabs name="add_request_correlation_id_policy">}}

{{%tab name="API"%}}

To create a Request Correlation ID policy using the REST API, send an HTTP `POST` request to the Environment endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                            |
|--------|---------------------------------------------------------------------|
| `POST` | `/infrastructure/workspaces/{workspace}/environments/{environment}` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

```json
{
  "policies": {
    "request-correlation-id": [
      {
        "action": {
          "invalidHeadersBehaviour": "ALLOW_ALL"
        }
      }
    ]
  }
}
```

This JSON example defines a Request Header Specification policy.

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To add a Request Header Specification policy using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Infrastructure**.
3. Choose the workspace that includes the environment for the cluster you want to add the policy to.
4. Select the environment for your cluster.
5. In the list of clusters, locate the cluster you want to add the policy to. On the **Actions** menu (represented by an ellipsis, `...`), select **Edit Advanced Config**.
6. On the left menu, select **Global Policies**.
7. From the list of policies, locate the **Request Header Specification** policy, then select **Add Policy** from the **Actions** menu (represented by an ellipsis, `...`).
8. On the **Request Header Specification** form, choose which configuration is appropriate for your environment.
9. Select **Add** to apply the policy to the cluster.
10. Select **Save and Submit** to deploy the configuration.

{{%/tab%}}

{{</tabs>}}
