---
nd-docs: DOCS-1028
---

Roles in NGINX Instance Manager are a critical part of [role-based access control (RBAC)]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}). By creating roles, you define the access levels and permissions for different user groups that correspond to groups in your Identity Provider (IdP).

NGINX Instance Manager comes pre-configured with an administrator role called `admin`. Additional roles can be created as needed.

The `admin` user or any user with `CREATE` permission for the **User Management** feature can create a role.

Follow these steps to create a role and set its permissions:

1. In a web browser, go to the FQDN for your NGINX Instance Manager host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. From the left navigation menu, select **Roles**.
1. Select **Create**.
1. On the **Create Role** form, provide the following details:

   - **Name**: The name to use for the role.
   - **Display Name**: An optional, user-friendly name to show for the role.
   - **Description**: An optional, brief description of the role.

1. To add permissions:

   1. Select **Add Permission**.
   2. Choose the NGINX Instance Manager module you're creating the permission for from the **Module** list.
   3. Select the feature you're granting permission for from the **Feature** list. To learn more about features, refer to [Get started with RBAC]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}).
   4. Select **Add Additional Access** to choose a CRUD (Create, Read, Update, Delete) access level.
      - Choose the access level(s) you want to grant from the **Access** list.
   5. Select **Save**.

1. Repeat step 6 if you need to add more permissions for other features.
1. When you've added all the necessary permissions, select **Save** to create the role.

#### Example scenario

Suppose you need to create an "app-developer" role. This role allows users to create and edit applications but not delete them or perform administrative tasks. You would name the role `app-developer`, select the relevant features, and grant permissions that align with the application development process while restricting administrative functions.
