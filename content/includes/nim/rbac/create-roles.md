---
nd-product: NIMNGR
nd-docs: DOCS-1028
nd-files:
- content/nim/admin-guide/authentication/oidc/getting-started.md
- content/nim/admin-guide/authentication/oidc/keycloak-setup.md
- content/nim/admin-guide/authentication/oidc/microsoft-entra-setup.md
- content/nim/admin-guide/rbac/create-roles.md
- content/nim/security-monitoring/give-access-to-security-monitoring-dashboards.md
---

Roles in NGINX Instance Manager are a critical part of [role-based access control (RBAC)]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}). By creating roles, you define the access levels and permissions for different user groups that correspond to groups in your Identity Provider (IdP).

NGINX Instance Manager comes pre-configured with an administrator role called `admin`. Additional roles can be created as needed.

The `admin` user or any user with `CREATE` permission for the **User Management** feature can create a role.

1. Go to the FQDN for your NGINX Instance Manager host and log in.
1. Select the **Settings** (gear) icon.
1. Select **Roles**.
1. Select **Create**.
1. On the **Create Role** form, provide the following details:

   - **Name**: The name to use for the role.
   - **Display Name**: An optional, user-friendly name to show for the role.
   - **Description**: An optional, brief description of the role.

1. To add permissions:

   1. Select **Add Permission**.
   2. From the **Module** list, select the module you're creating the permission for.
   3. From the **Feature** list, select the feature you're granting permission for. To learn more about features, see [Get started with RBAC]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}).
   4. Select **Add Additional Access** to choose a CRUD (Create, Read, Update, Delete) access level.
      - From the **Access** list, select the access level(s) you want to grant.
   5. Select **Save**.

1. Repeat step 6 if you need to add more permissions for other features.
1. When you've added all the necessary permissions, select **Save** to create the role.

#### Example scenario

Suppose you need to create an "app-developer" role. Users with this role can create and edit applications, but can't delete them or perform administrative tasks. You would name the role `app-developer`, select the relevant features, and grant permissions that align with the application development process while restricting administrative functions.
