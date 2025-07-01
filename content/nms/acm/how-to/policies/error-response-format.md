---
description: Learn how to use the F5 NGINX Management Suite API Connectivity Manager
  to configure the Error Response Format policy that customizes HTTP error codes and
  messages.
nd-docs: DOCS-1345
title: Error Response Format
toc: true
weight: 550
type:
- how-to
---

## Overview

{{< include "acm/how-to/policies-intro" >}}

---

## About the Policy

This policy specifies how the API gateway will intercept HTTP errors from the backend(s) and respond to the client with a standard or customized error response in JSON format.
The client will receive the Custom Status and Error Message in JSON format, instead of the standard HTTP error coming from the backend.
The Error Response Format policy is applied by default to any new environment.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Workflow for Applying Policy

To apply the policy or make changes to it, follow these steps:

- [Edit an existing environment or create a new one]({{< ref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#add-environment" >}}).
- Review the advanced settings for the environment to confirm if the policy has been applied.
- Edit the policy to make changes for each environment. Save and publish the changes.

---

## Policy Settings

{{< note >}}

Either `errorMessage` or `errorMessageBody` must be provided for each error code.

{{< /note >}}

{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                  | Type    | Possible Values                    | Description                                                                                                         | Required | Default Value |
|------------------------|---------|------------------------------------|---------------------------------------------------------------------------------------------------------------------|----------|---------------|
| `errorCode`            | int     | In range `400-599`                 | The error code that needs to be used by the NGINX data-plane to return to the user.                                 | Yes      | N/A           |
| `errorMessage`         | string  | Max length `2048`                  | The customized error message that needs to be used by the NGINX data-plane to convey error information.             | No       | N/A           |
| `errorMessageBody`     | object  | Example: `{"errMsg":"My Message"}` | The customized JSON errors that needs to be used by the NGINX data-plane to convey error information to the user.   | No       | N/A           |

{{< /bootstrap-table >}}

---

## Applying the Policy

You can apply this policy using the web interface or the REST API.

<br>

{{<tabs name="add_error_response_format_policy">}}

{{%tab name="API"%}}

To create an Error Response Format policy using the REST API, send an HTTP `POST` request to the environment endpoint.

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
     "error-response-format": [
        {
           "systemMetadata": {
              "appliedOn": "inbound",
              "context": "global"
           },
           "action": {
              "400": {
                 "errorCode": "13",
                 "errorMessage": "Bad Request"
              }
           }
        }
     ]
  }
}
```

This JSON example defines an Error Response policy.

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To add an Error Response Format policy using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
1. On the left menu, select **Infrastructure**.
1. Choose the workspace that includes the environment for the cluster you want to add the policy to.
1. Select the environment.
1. In the list of clusters, locate the cluster you want to add the policy to. On the **Actions** menu (represented by an ellipsis, `...`), select **Edit Advanced Config**.
1. On the left menu, select **Global Policies**.
1. From the list of policies, locate the **Error Response Format** policy, then select **Add Policy** from the **Actions** menu (represented by an ellipsis, `...`).
1. Configure the associated **Error Code**, **Error Message** and **Error Message Body** for each error code.
1. Additional entries can be created by selecting “Add Error Code” at the bottom of the table.
1. Select **Add** to apply the policy to the cluster.
1. Select **Save and Submit** to deploy the configuration.

{{%/tab%}}

{{</tabs>}}
