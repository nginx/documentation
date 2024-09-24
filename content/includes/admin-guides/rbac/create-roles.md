---
docs: DOCS-1028
---

Roles within NGINX Management Suite are a critical component of [role-based access control (RBAC)]({{< relref "nms/admin-guides/rbac/rbac-getting-started.md" >}}). By defining roles, you specify access levels and permissions for different user groups that map to groups in your Identity Provider (IdP).

NGINX Management Suite comes pre-configured with an administrator role called `admin`. Additional roles can be created as needed.

The `admin` user or any user with `CREATE` permission for the **User Management** feature can create a role.

Here's how to create a role and set its permissions:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. Select **Roles** from the left navigation menu.
4. Select **Create**.
5. On the **Create Role** form, provide the following details:

   - **Name**: The name to use for the role.
   - **Display name**: An optional, user-friendly name to show for the role.
   - **Description**: An optional, brief description of what the role is.

6. To add permissions:

   1. Select **Add Permission**.
   2. Choose the NGINX Management Suite module you're creating a permission for from the **Module** list.
   3. Select the feature you're granting permission for from the **Feature** list. To learn more about features, refer to [Getting Started with RBAC]({{< relref "nms/admin-guides/rbac/rbac-getting-started.md" >}}).
   4. Select **Add Additional Access** to add a CRUD (Create, Read, Update, Delete) access level.

      - Choose the access level(s) you want to grant from the **Access** list.

   5. Select **Save**.

7. Repeat step 6 if you need to add more permissions for other features.
8. When you've added all the necessary permissions, select **Save** to create the role.

#### Example Scenario

Imagine you need to create an “app-developer” role. This role permits users to create and edit applications without allowing them to delete or perform administrative tasks. You would name the role 'app-developer,' select one or more features, and grant permissions that align with the requirements of application development, avoiding features and permissions that enable deletion or other administrative functions.
