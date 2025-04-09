---
description: Learn how to configure the Request Policy Size Limit policy to prevent
  Denial of Service (DoS) and other types of attacks.
docs: DOCS-1122
title: Request Body Size Limit
toc: true
weight: 1200
type:
- how-to
---

## Overview

{{< include "acm/how-to/policies-intro" >}}

---

## About the Policy

The *Request Body Size Limit* policy, which by default is set to 1 MB, is applied to all API gateway proxy requests. If the request exceeds this limit, it will be blocked and an error code will be returned. You can adjust the limit to meet your requirements, or you can disable the policy completely by setting the max size to 0.

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

| Field        | Type | Possible&nbsp;Values       | Description                                                                                                                | Required | Default             |
|--------------|----------|-----------------------|----------------------------------------------------------------------------------------------------------------------------|----------|---------------------|
| `size`       | string   | Example:<br>`1M` or `1K` | <p>Sets the maximum body size for client requests.</p><p>Megabytes, `M`, and Kilobytes, `K`, are the accepted units.</p>                  | No       | `1M`  |
| `returnCode` | integer  | In range:<br>`400-599`    | <p>The error code that is returned to the client when the size of a request exceeds the configured value.</p><p>The default error code is `413: Request Entity Too Large`.</p> | No       | `413` |

{{< /bootstrap-table >}}


---

## Applying the Policy

You can apply this policy using either the web interface or the REST API.

<br>

{{<tabs name="policy-implementation">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To add the Request Body Size Limit policy using the REST API, send an HTTP `POST` request to the Environments endpoint.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Method | Endpoint                                                                            |
|--------|-------------------------------------------------------------------------------------|
| `POST` | `/infrastructure/workspaces/{workspace}/environments/{environment}` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

``` json
{
  "policies": {
    "request-body-size-limit": [
      {
        "action": {
          "returnCode": 413,
          "size": "1M"
        }
      }
    ]
  }
}
```

</details>

This example Request Body Size Limit policy rejects requests exceeding one megabyte and returns error code `413`.

<br>

{{%/tab%}}

{{%tab name="UI"%}}

To add a Request Body Size Limit policy using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Infrastructure**.
3. Choose the workspace that contains your cluster's environment from the list of workspaces.
4. In the **Environments** section, select the environment name for your cluster.
5. In the list of clusters, locate the cluster you want to add the policy to. On the **Actions** menu (represented by an ellipsis, `...`), select **Edit Advanced Config**.
6. On the left menu, select **Global Policies**.
7. Locate the **Request Body Size Limit** policy in the list of policies. On the **Actions** menu (represented by an ellipsis, `...`), select **Add Policy**.
8. On the **Request Body Size Limit** form, complete the necessary fields:

   - **Error code**: Specify the error code to return when a request exceeds the maximum size. The default is `413`.
   - **Request body size**: Enter the maximum body size in megabytes or kilobytes. The default is 1 megabyte.
9. Select **Add** to apply the policy to the cluster.
10. Select **Save and Submit** to deploy the configuration.

{{%/tab%}}

{{</tabs>}}
