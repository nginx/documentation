To add users and assign roles, take the following steps:

1. Open the NGINX Management Suite web interface and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. On the left navigation menu, select **Users**.
4. Select **Create**.
5. On the **Create User** form, enter information for the user:

   - **Username**: A unique username to identify the user.
   - **Email**: The user's email address.
   - **First Name**: The user's first name.
   - **Last Name**: The user's last name.
   - **Description**: (Optional) A brief description of the user.

6. In the **Roles** list, select one or more roles to assign to the user. See [Create a Role]({{< relref "/nms/admin-guides/access-control/set-up-rbac#create-role" >}}) to add roles to the list.
7. (Required for Basic Auth) If you're using [basic auth]({{< relref "/nms/admin-guides/access-control/configure-authentication.md#basic-auth" >}}), add each user's username and password to the `/etc/nms/nginx/.htpasswd` file on the NGINX Management Suite server. See [Restricting Access with HTTP Basic Auth](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/) for instructions on working with a password file.

{{< note >}}
Changes made to a user may take up to 10 minutes to take effect.
{{< /note >}}

{{< see-also >}}To automate creating users and groups using the [SCIM API](http://www.simplecloud.info), refer to the [Provision Users and Groups with SCIM]({{< relref "/nms/admin-guides/access-control/scim-provisioning.md" >}}) topic for instructions. Requires Instance Manager 2.3 or later.{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1024 -->