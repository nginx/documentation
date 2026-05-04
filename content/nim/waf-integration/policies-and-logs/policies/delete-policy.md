---
title: Delete a security policy
description: Remove an existing F5 WAF for NGINX security policy using the F5 NGINX Instance Manager web interface or REST API.
toc: true
weight: 300
nd-content-type: how-to
nd-product: NIMNGR
nd-summary: >
  Remove an existing F5 WAF for NGINX security policy from F5 NGINX Instance Manager using the web interface or REST API.
  Deleting a policy permanently removes it and its version history from NGINX Instance Manager.
---

You can delete a security policy using either the F5 NGINX Instance Manager web interface or the REST API.

---

{{<tabs name="delete-security-policy">}}

{{%tab name="Web interface"%}}

To delete a policy in the web interface:

1. Log in to NGINX Instance Manager.
1. From the Launchpad, select **NGINX Instance Manager**.
1. In the left menu, select **WAF > Policies**.
1. On the **Security Policies** page, locate the policy you want to delete.
1. Select the **Actions** menu (**...**) and choose **Delete**.

{{%/tab%}}

{{%tab name="API"%}}

To delete a policy using the REST API:

1. Retrieve the policy’s UID by sending a `GET` request to the Security Policies endpoint:

   ```shell
   curl -X GET https://<NIM_FQDN>/api/platform/v1/security/policies \
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
curl -X DELETE https://<NIM_FQDN>/api/platform/v1/security/policies/<policy-uid> \
  -H "Authorization: Bearer <access token>"
```

{{%/tab%}}

{{</tabs>}}
