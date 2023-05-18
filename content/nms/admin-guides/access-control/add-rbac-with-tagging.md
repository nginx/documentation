---
title: "(Deprecated) Set Up RBAC with Tagging"
description: "Deprecated in Instance Manager 2.1.0. This topic explains how to set up role-based access control with tags in Instance Manager."
date: 2021-12-21T12:00:00-07:00
draft: true
weight: 1000
doctypes: task
toc: true
tags: ["docs", "deprecated"]

docs: "DOCS-790"
aliases:
- /nginx-instance-manager/admin-guide/add-rbac-with-tagging/
- /nginx-instance-manager/admin-guide/rbac/add-rbac-with-tagging/
---

{{< shortversions "2.0.0" "2.0.1" "nimvers" >}}

## Overview

{{< deprecated >}}Adding tags to set up RBAC is deprecated in Instance Manager 2.1.0. To use the new RBAC, refer to the [Set Up RBAC]({{< relref "/nms/admin-guides/access-control/set-up-rbac" >}}) guide.
{{< /deprecated >}}

When [defining a role]({{< relref "/nms/admin-guides/access-control/configure-authentication.md#roles" >}}) in Instance Manager, you can use [tags]({{< relref "/nms/nim/how-to/nginx/add-tags.md" >}}) to restrict a role's permissions for groups of instances.

To access an instance with an assigned tag, a role must have `Instance Management` permission, and the permission needs to have a tag matching the instance's.

{{<note>}}
Changes made to a role may take up to 10 minutes to take effect.

Admin users can view, add, and change any system tags, as well as any access levels. Non-admin users are restricted to viewing only the roles and tags they've been assigned.

Untagged instances can be accessed by all users that have the `Instance Management` permission.
{{</note>}}

## Set Role Permissions Using the API

To set a role's permissions with tags using the Instance Manager Rest API, send a POST request similar to the following example to the Roles API:

```bash
curl -X POST "https://<NGINX-INSTANCE-MANAGER-FQDN>/api/platform/v1/roles" -H "authorization: Basic YWRtaW..." -H "content-type: application/json" -d "
{
  "metadata": {
    "description": "Role settings for managers",
    "displayName": "manager",
    "name": "manager"
  },
   "roleDef": {
    "permissions": [
      {
        "access": "READ",
        "scope": "INSTANCE-MANAGEMENT",
        "tags": [
          "env:prod"
        ]
      },
      {
        "access": "WRITE",
        "scope": "INSTANCE-MANAGEMENT",
        "tags": [
          "env:dev"
        ]
      }
    ]
  }
}"
```

{{<bootstrap-table "table table-striped table-bordered">}}
| Parameter          | Type | Description                                                                                                                                                                                                                        |
|--------------------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `permissions.access` | string    | The access level determines the role's ability to access a path or object.<br><br>The options are:<br><br>&#8226;&nbsp;READ: has read-only access (HTTP, GET requests)<br><br>&#8226;&nbsp;WRITE: has read and write access (POST, PUT, PATCH, DELETE requests)          |
| `permissions.scope`  | string    | Sets the scope the role has access to.<br><br>The options are:<br><br>&#8226;&nbsp;SETTINGS: has access to the Instance Manager settings APIs, including license, users, and roles<br><br>&#8226;&nbsp;INSTANCE-MANAGEMENT: has access to to the instance management APIs |
| `permissions.tags`   | string    | Tags are matched to resources in the API to determine access privileges. Tags can only be used with the INSTANCE-MANAGEMENT scope.                                                                                                 |
{{</bootstrap-table>}}

The example above defines a role with `READ` permission for instances with the `env:prod` tag and `WRITE` permission for instances with the `env:dev` tag.

For more information about the Roles API, see the Instance Manager REST API Documentation: `https://<NGINX-INSTANCE-MANAGER-FQDN>/ui/docs`.

## Set Role Permissions Using the Web Interface

1. Open the NGINX Management Suite web interface and log in.
2. Select the **Settings** gear icon.
3. In the left menu, select **Roles**.
4. Select **Create**.
5. On the **Create Role** form, complete the following:

   - In the **Name** box, type the name of the role.
   - In the **Display Name** box, type a display name for the role.
   - In the **Permissions** section, select **Create**.
   - In the **Scope** list, select **Instance Management**.
   - In the **Access** list, select the access level for the role. The options are `Read` or `Write`.
   - In the **Tags** list, select a tag or tags to apply to the role, or select **Add New Tag** to create a tag.

6. Select **Save**.

{{< img src="/rbac/role-create-with-tags.png" alt="Role creation: create role with tags." width="600" height="415" >}}</br>
