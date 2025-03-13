---
docs: DOCS-1272
title: Create and manage roles
toc: true
weight: 200
type:
- how-to
---

## Overview

NGINX Instance Manager emphasizes role-based access control (RBAC) to manage user permissions. A predefined `admin` role is available for initial setup and administration, but you can create custom roles to match specific responsibilities, such as for API Owners or Infrastructure Admins. This lets organizations fine-tune access and permissions to suit their needs.

## Create roles {#create-roles}

{{< include "nim/rbac/create-roles.md" >}}

## Edit roles {#edit-roles}

To modify an existing role in NGINX Instance Manager, follow these steps:

1. In a web browser, go to the FQDN of your NGINX Instance Manager host and log in.
2. Select the **Settings** gear icon in the upper-right corner.
3. From the left navigation menu, select **Roles**.
4. From the list, select the role you want to update.
5. Select **Edit Role** and make changes to any of the editable fields if needed:
   - **Display name**: an optional, user-friendly name for the role
   - **Description**: an optional, brief summary of the role

6. To add new permissions to the role:

   1. Select **Add Permission**.
   2. In the **Module** list, select the relevant module.
   3. In the **Feature** list, select the feature you're assigning permissions for. 

   4. Select **Add Additional Access** to grant a CRUD (Create, Read, Update, Delete) access level.

      - In the **Access** list, select the access level(s) you want to assign.

   5. Select **Save**.

7. To edit an existing permission, select **Edit** next to the permission name.

   1. In the **Edit Permission** form, modify the **Module**, **Feature**, or access levels as needed.

8. After making your changes, select **Save**.

## Next steps

### Assign roles to users or user groups

Once you’ve created roles, assign them to users or user groups to ensure that permissions align with responsibilities. This helps maintain clear and organized access control.

- [Assign roles to users or user groups]({{< relref "/nim/admin-guide/rbac/assign-roles.md" >}})
