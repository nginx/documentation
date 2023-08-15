---
docs: DOCS-1024
---

The default `admin` user or any user with `CREATE` permission for the **User Management** feature can create a role.

To add users, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. On the left menu, select **Users**.
4. Select **Create**.
5. On the **Create User** form, enter the details for the user:

   - **Username**: A unique username to identify the user.
   - **Email**: The user's email address.
   - **First Name**: The user's first name.
   - **Last Name**: The user's last name.
   - **Description**: (Optional) A brief description of the user.

6. In the **Roles** list, select one or more roles to assign to the user. See [Create a Role]({{< relref "/nms/admin-guides/access-control/set-up-rbac#create-role" >}}) to add roles to the list.
7. (Required for Basic Auth) Use the `basic_passwords.sh` script to add a user's encrypted password to the `/etc/nms/nginx/.htpasswd` file on the NGINX Management Suite server. For instructions, refer to the basic authentication topic [Set or Change User Passwords]({{< relref "/nms/admin-guides/access-control/configure-authentication.md#change-basic-password" >}}).

{{< note >}}
Changes made to a user may take up to 10 minutes to take effect.
{{< /note >}}

{{< see-also >}}Refer to the "[Provision Users and Groups with SCIM]({{< relref "/nms/admin-guides/access-control/scim-provisioning.md" >}})" topic for instructions on automating user and group creation using the SCIM API.{{< /see-also >}}
