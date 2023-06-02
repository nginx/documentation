---
docs: 1028
---

NGINX Management Suite comes pre-configured with an administrator role called `admin`. Additional roles can be created as needed.

The `admin` user or any user with `CREATE` permission for the **User Management** feature can create a role.

To create a role, follow these steps:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. From the left navigation menu, select **Roles**.
4. Select **Create**.
5. On the **Create Role** form, provide the following details:

   - **Name**: The name to use for the role.
   - **Display name**: An optional, user-friendly name to show for the role.
   - **Description**: An optional, brief description of what the role is.

6. To add permissions:

   1. Select **Add Permission**.
   2. In the **Module** list, select the module you're creating a permission for.
   3. In the **Feature** list, select a feature you're creating a permission for. {{<comment>}}link to features topic{{</comment>}}
   4. Select **Add Additional Access** to add a CRUD (Create, Read, Update, Delete) access level.

      - In the **Access** list, select the access level(s) you want to grant.

   5. Select **Save**.

7. Repeat step 6 to add more permissions for other features.
8. When you've added all the necessary permissions, select **Save** to create the role.
