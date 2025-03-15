---
description: Learn how to use API Connectivity Manager's Request Correlation ID policy
  to add a unique identifier to each request entering your app, which you can use
  to trace end-to-end transactions in a distributed system.
docs: DOCS-1120
title: Request Correlation ID
toc: true
weight: 1300
type:
- how-to
---

## Overview

{{< include "acm/how-to/policies-intro" >}}

---

## About the Policy

Use the Request Correlation ID policy to add a unique identifier to each request that enters an application. With the Correlation ID policy, you can trace end-to-end transactions moving through components in a distributed system. This policy is applied by default and usually uses `x-correlation-id` as the default HTTP header name. However, you can also provide a custom header value if needed.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Workflow for Applying Policy

To apply the policy or make changes to it, here's what you need to do:

- [Edit an existing environment or create a new one]({{< relref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#add-environment" >}}).
- Check the advanced settings for the environment to see if the policy has been applied.
- Edit the policy to make changes for each environment. Save and publish the changes.

---

## Policy Settings


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field            | Type   | Possible Values                | Description                                                  | Required | Default Value      |
|------------------|--------|--------------------------------|--------------------------------------------------------------|----------|--------------------|
| `httpHeaderName` | string | Example:<br>`x-correlation-id` | The HTTP header name to use when passing the correlation ID. | YES      | `x-correlation-id` |

{{< /bootstrap-table >}}


---

## Applying the Policy

You can apply this policy using either the web interface or the REST API. The policy uses `x-correlation-id` as the default HTTP header name, or you can provide a custom header value.

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
          "httpHeaderName": "x-correlation-id"
        }
      }
    ]
  }
}
```

This JSON example defines a Request Correlation ID policy, which specifies that an HTTP header called `x-correlation-id` should be used when passing the correlation ID.

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To add a Request Correlation ID policy using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Infrastructure**.
3. Choose the workspace that includes the environment for the cluster you want to add the policy to.
4. Select the environment for your cluster.
5. In the list of clusters, locate the cluster you want to add the policy to. On the **Actions** menu (represented by an ellipsis, `...`), select **Edit Advanced Config**.
6. On the left menu, select **Global Policies**.
7. From the list of policies, locate the **Request Correlation ID** policy, then select **Add Policy** from the **Actions** menu (represented by an ellipsis, `...`).
8. On the **Request Correlation ID** form, complete the necessary fields:

   - **HTTP Header Name**: The HTTP header name to use when passing the correlation ID. The default is `x-corrrelation-id`.

9. Select **Add** to apply the policy to the cluster.
10. Select **Save and Submit** to deploy the configuration.

{{%/tab%}}

{{</tabs>}}
