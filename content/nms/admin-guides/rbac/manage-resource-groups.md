---
description: Learn how to use F5 NGINX Management Suite Instance Manager to create  resource
  groups. These groups are used to manage multiple resources like instances, instance
  groups, and certificates as a single RBAC permission object.
docs: DOCS-1271
doctypes:
- tutorial
tags:
- docs
title: Working with Resource Groups
toc: true
weight: 300
---

{{< shortversions "2.12.0" "latest" "nimvers" >}}

## What Is a Resource Group?

Resource groups are containers that can house various resources, such as instances, instance groups, and certificates, that you can manage collectively. With resource groups, you can set up RBAC permissions for multiple resources as one entity. This is different from [Instance Groups]({{< relref "nms/nim/how-to/instances/manage-instance-groups.md" >}}), which act like a cluster where all instances must share the same configuration. Resource groups don't have this limitation. They function solely as an RBAC object, allowing you to manage multiple resources as if they were one item.


---

## Before You Begin

To complete the instructions in this guide, you need the following:

- An installed version of [F5 NGINX Management Suite Instance Manager]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}})
- One or more NGINX data plane instances

---

## Default Systems Set

When systems, also called instances, register with Instance Manager, they are automatically included in a default  resource group named `default-systems`.  You can use this default group to set base-level permissions for new instances until they are added to a more specific resource group.

---

## Create, Update, and Delete Resource Groups

### Create Resource Groups {#add-resource-groups}

{{<tabs name="create-resource-groups">}}

{{%tab name="UI"%}}

To create a  resource group using the web interface:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then select Settings from the Launchpad menu.
2. From the left-side menu, select **Resource Groups**.
3. Select **Create**.
4. In the **Basic Information** form, fill in the following details:

   - **Name**: Provide a unique name for the  resource group.
   - **Description**: Enter an optional description for the  resource group.

5. Select **Next**.
6. In the **Certs** form, select any certificates you want to include in the  resource group or leave the form blank. Then, select **Next**.
7. In the **Instance Groups** form, select any instance groups you want to include in the  resource group or leave the form blank. Then, select **Next**.
8. In the **Systems** form, select any instances you want to include in the  resource group or leave the form blank.
9. Select **Save** to create the  resource group.

{{%/tab%}}

{{%tab name="API"%}}

{{< see-also >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /see-also>}}

<br>

To create a  resource group using the REST API, send an HTTP `POST` request to the Resource Groups endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                             |
|--------|------------------------------------------------------|
| `POST` | `https://<NMS_FQDN>/api/platform/v1/resource-groups` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

The following request creates a  resource group named `my-resource-group` with the specified instance named `my-system` as a resource.

```json
{
  "resources": [
    {
      "module": "Instance Manager",
      "name": "my-system",
      "object": "Systems",
      "uid": "9bad47e6-5ed4-4522-96c0-6f507c2e7198"
    }
  ],
  "description": "my resource group",
  "name": "my-resource-group"
}
```

{{%/tab%}}

{{</tabs>}}



---

### Modify an Existing Resource Group

{{<tabs name="modify-resource-groups">}}

{{%tab name="UI"%}}

To make changes to an existing  resource group using the web interface:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then select Settings from the Launchpad menu.
2. From the left-side menu, select **Resource Groups**.
3. From the list of Resource Groups, select the one you want to update.
4. Select **Edit**.
5. In the **Basic Information** form, fill in the following details:

   - **Name**: Provide a unique name for the  resource group.
   - **Description**: Enter an optional description for the  resource group.

6. Select **Next**.
7. In the **Certs** form, select any certificates you want to include in the  resource group or leave the form blank. Then, select **Next**.
8. In the **Instance Groups** form, select any instance groups you want to include in the  resource group or leave the form blank. Then, select **Next**.
9. In the **Systems** form, select any instances you want to include in the  resource group or leave the form blank.
10. Select **Save** to apply the changes.

{{%/tab%}}

{{%tab name="API"%}}

<br>

You can assign resources (for example, instances) to resource groups in the following ways:

- (Preferred) Directly add the system to the  resource group with the Direct Add API.
- Alternatively, you can use the Update Resource Group API `PUT /api/platform/v1/resource-groups/{resourceGroupUid}`, but this method requires passing all systems that belong in the set with the call.

#### Use the Direct Add API

The direct add method saves you from having to build the entire list of all resources you want in a  resource group each time you want to add a new system.

To add a resource to a  resource group with the Direct Add API, send an HTTP `POST` request to the Resource Groups endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                                          |
|--------|-----------------------------------------------------------------------------------|
| `POST` | `https://<NMS_FQDN>/api/platform/v1/resource-groups/{resourceGroupUid}/resources` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

The following request adds an instance named `my-system` to the specified resource group, identified by the unique ID `{resourceGroupUid}`.

```json
{
    "module": "Instance Manager",
    "name": "my-system",
    "object": "Systems",
    "uid": "1ac1e001-f8af-463a-b6fd-3bfb2fc94542"
}
```

#### Updating the Entire Resource Group

To add one ore more resources to a  resource group by updating the  resource group:

1. Retrieve the JSON for the existing  resource group:

   `GET https://<NMS_FQDN>/api/platform/v1/resource-groups/{resourceGroupUid}`

2. Manually insert the new resource(s) to the `resources` list in the JSON.
3. Update the  resource group using the modified JSON:

   `PUT https://<NMS_FQDN>/api/platform/v1/resource-groups/{resourceGroupUid}`


{{%/tab%}}

{{</tabs>}}

---

### Remove Resources from Resource Groups

{{<tabs name="remove-resources">}}

{{%tab name="UI"%}}

To remove resources from an existing  resource group using the web interface:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then select Settings from the Launchpad menu.
2. From the left-side menu, select **Resource Groups**.
3. Find the  resource group you want to modify and select it.
4. Select **Edit**.
5. In the **Basic Information** form, make any changes if needed:

   - **Name**: Provide a unique name for the  resource group.
   - **Description**: Enter an optional description for the  resource group.

6. Select **Next**.
7. In the **Certs** form, uncheck any certificates you want to remove from the  resource group. Then, select **Next**.
8. In the **Instance Groups** form, uncheck any instance groups you want to remove from the  resource group. Then, select **Next**.
9. In the **Systems** form, uncheck any instances you want to remove from the  resource group.
10. Select **Save** to apply the changes.

{{%/tab%}}

{{%tab name="API"%}}

To remove a resource from a  resource group using the REST API, send an HTTP `DELETE` request to the Resource Groups endpoint.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                                                                                    |
|----------|-----------------------------------------------------------------------------------------------------------------------------|
| `DELETE` | `https://<NMS_FQDN>/api/platform/v1/resource-groups/{resourceGroupUid}/resources/{resourceUid}?moduleName=Instance Manager` |

{{</bootstrap-table>}}


{{%/tab%}}

{{</tabs>}}

---

### Delete Resource Groups

{{<tabs name="delete-resource-group">}}

{{%tab name="UI"%}}

To delete a  resource group using the web interface, follow these steps:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then select Settings from the Launchpad menu.
2. From the left-side menu, select **Resource Groups**.
3. From the list of Resource Groups, select the one you want to delete.
4. Select **Delete**.

{{%/tab%}}

{{%tab name="API"%}}

To delete a  resource group using the REST API, send an HTTP `DELETE` request to the Resource Groups endpoint.


{{<bootstrap-table "table">}}

| Method   | Endpoint                                                                |
|----------|-------------------------------------------------------------------------|
| `DELETE` | `https://<NMS_FQDN>/api/platform/v1/resource-groups/{resourceGroupUid}` |

{{</bootstrap-table>}}


{{%/tab%}}

{{</tabs>}}

---

### View List of Resource Groups

{{<tabs name="view-resource-groups">}}

{{%tab name="UI"%}}

To see the list of existing resource groups using the web interface, follow these steps:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then select Settings from the Launchpad menu.
2. From the left-side menu, select **Resource Groups**.

{{%/tab%}}

{{%tab name="API"%}}

To view the list of resource groups (omitting resources detail) using the REST API, send an HTTP `GET` request to the Resource Groups endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                               |
|--------|------------------------------------------------------------------------|
| `GET`  | `https://<NMS_FQDN>/api/platform/v1/resource-groups?showDetails=false` |

{{</bootstrap-table>}}


To view the list of resource groups (including resources detail) using the REST API, send an HTTP `GET` request to the Resource Groups endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                              |
|--------|-----------------------------------------------------------------------|
| `GET`  | `https://<NMS_FQDN>/api/platform/v1/resource-groups?showDetails=true` |

{{</bootstrap-table>}}


{{%/tab%}}

{{</tabs>}}

---

### View Resources in a Resource Group

{{<tabs name="view-resources-in-resource-group">}}

{{%tab name="UI"%}}

To see the list resources associated with a  resource group:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then select Settings from the Launchpad menu.
2. From the left-side menu, select **Resource Groups**.
3. Find the  resource group you want to inspect and select it.
4. Select a tab (for example, **Instance Groups**) to view the associated resources.

{{%/tab%}}

{{%tab name="API"%}}

To view the instances in a  resource group using the REST API, send an HTTP `GET` request to the Resource Groups endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                                |
|--------|-------------------------------------------------------------------------|
| `GET`  | `https://<NMS_FQDN>/api/platform/v1/resource-groups/{resourceGroupUid}` |

{{</bootstrap-table>}}


{{%/tab%}}

{{</tabs>}}

---

## Putting It All Together

### Example: Managing Test Environment Resources

In this section, we'll outline a practical example that sets up administrative control for servers in a test environment. Specifically, we will focus on granting an administrator the ability to view all available systems but restrict modifications to only those that belong to the **test-env-resources** resource group.

By following these steps, you'll create a resource group, define a special administrative role, and assign that role to a specific user. This approach provides an effective way to tailor access and manage resources in a targeted manner within NGINX Management Suite.


### Create a Resource Group Named test-env-resources

First, we'll create a resource group named **test-env-resources** that includes selected certificates, instances, and instance groups.

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select **Settings** from the Launchpad menu.
3. From the left-side menu, select **Resource Groups**.
4. Select **Create**.
5. **Enter Basic Information**:
   - **Name**: Enter **test-env-resources** as the unique name for the resource group.
   - **Description**: Enter **Test Environment Resources**.
   - Select **Next**.
6. **Select Certificates**: In the **Certs** form, select any certificates you want to include in the resource group or leave the form blank. Then, select **Next**.
7. **Choose Instance Groups**: In the **Instance Groups** form, select any instance groups you want to include in the resource group or leave it blank. Then, select **Next**.
8. **Add Systems**: In the **Systems** form, select any instances you want to include in the resource group or leave it blank.
9. Select **Save** to create the **test-env-resources**.

You have now created a specific resource group named **test-env-resources** with the resources you specified.

### Create the test-env-admin Role

Now, we'll create a role that has the ability to view all certificates, instance groups, and instances, and grants full Create, Read, Update, and Delete (CRUD) permissions specifically for the resources within the **test-env-resources** resource group.

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. From the left navigation menu, select **Roles**.
4. Select **Create**.
5. **Enter Role Details**:
   - **Name**: Enter **test-env-admin** as the name for the role.
   - **Description**: Enter **Test Environment Admin**.
6. **Add READ Permission for Certs**:
   - Select **Add Permission**.
   - In the **Module** list, select **Instance Manager**.
   - In the **Feature** list, select **Certs**.
   - Select **Add Additional Access**.
   - In the **Access** list, select **Read**.
   - In the **Applies to** fields, select **Certs** and **All**.
   - Select **Save**.
7. **Add READ Permission for Instance-Groups**:
   - Repeat step 6, but select **Instance-Groups** for the feature, **Read** for the access level, and **Instance Groups** and **All** for the **Applies to** fields.
8. **Add READ Permission for Instance-Management**:
   - Repeat step 6, but select **Instance-Management** for the feature and **Read** for the access level, and **Systems** and **All** for the **Applies** to fields.
9. **Add CRUD Permissions for Resource-Groups**:
   - Repeat step 6, but select **Settings** for module, **Resource Groups** for the feature, **Select All** for the access level, and **Resource Groups** and **test-env-resources** for the **Applies to** fields.
10. Select **Save** to create the **test-env-admin** role.

The **test-env-admin** role is now created with the specified access levels.

<br>

<div style="text-align:center";>{{< img src="admin/rbac/test-env-admin-role.png" alt="Create the test-env-admin role." >}}</div>

<br>

### Assign the test-env-admin Role to john-doe

Finally, we'll assign the **test-env-admin** role to a user named **john-doe**.

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the Settings (gear) icon in the upper-right corner.
3. On the left navigation menu, select **Users**.
4. Select **john-doe** from the user list, then select **Edit User**.
5. In the **Roles** list, select the **test-env-admin** role.
6. Select **Save**.

The **test-env-admin** role is now assigned to **john-doe**. He will have all the permissions and access levels defined in that role.

<br>

<div style="text-align:center";>{{< img src="admin/rbac/assign-test-env-admin-role.png" alt="Assign the test-env-admin role to john-doe." >}}</div>
