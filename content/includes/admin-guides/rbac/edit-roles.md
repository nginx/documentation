---
docs: DOCS-1302
---

To modify an existing role in NGINX Management Suite, follow the steps below:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. From the left navigation menu, select **Roles**.
4. From the list, select the role you want to update.
5. Select **Edit Role** and make changes to any of the editable fields if needed:
   - **Display name**: an optional, user-friendly name to show for the role
   - **Description**: an optional, brief summary of what the role is

6. To add new permissions to the role:

   1. Select **Add Permission**.
   2. In the **Module** list, select the module you're creating a permission for.
   3. In the **Feature** list, select a feature you're creating a permission for. {{<comment>}}link to features topic{{</comment>}}

   4. Select **Add Additional Access** to add a CRUD (Create, Read, Update, Delete) access level.

      - In the **Access** list, select the access level(s) you want to grant.

   5. Select **Save**.

7. To edit an existing permission for the role, select **Edit** found next to the permission name.

   1. On the **Edit Permission** form, you can modify the **Module**, **Feature**, current **Access** level or add more access options.

8. Once you've made all your changes, select **Save**.
