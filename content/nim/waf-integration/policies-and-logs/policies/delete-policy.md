---
nd-docs: DOCS-354
title: Delete a security policy
description: Remove an existing F5 WAF for NGINX security policy using the NGINX Instance Manager web interface or REST API.
toc: true
weight: 300
nd-content-type: how-to
nd-product: NIMNGR
---

You can delete a security policy using either the NGINX Instance Manager web interface or the REST API.

---

{{<tabs name="delete-security-policy">}}

{{%tab name="Web interface"%}}

To delete a policy in the web interface:

1. In your browser, go to the FQDN for your NGINX Instance Manager host and log in.
1. From the Launchpad, select **Instance Manager**.
1. In the left menu, select **WAF > Policies**.
1. On the **Security Policies** page, locate the policy you want to delete.
1. Select the **Actions** menu (**...**) and choose **Delete**.

{{%/tab%}}

{{%tab name="API"%}}

To delete a policy using the REST API:

1. Retrieve the policy’s UID by sending a `GET` request to the Security Policies endpoint:

   ```shell
   curl -X GET https://{{NIM_FQDN}}/api/platform/v1/security/policies \
     -H "Authorization: Bearer <access token>"
   ```

1. Use the policy UID in a `DELETE` request:

{{< table >}}
| Method | Endpoint                                                   |
|--------|------------------------------------------------------------|
| DELETE | `/api/platform/v1/security/policies/{policy-uid}` |
{{</ table >}}

**Example:**

```shell
curl -X DELETE https://{{NIM_FQDN}}/api/platform/v1/security/policies/<policy-uid> \
  -H "Authorization: Bearer <access token>"
```

{{%/tab%}}

{{</tabs>}}
