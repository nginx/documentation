---
docs: DOCS-1024
---

{{< note >}} Please note that the web interface does not support adding user passwords directly. Once you've created new users, refer to the following steps to [set user passwords](#set-basic-passwords).{{< /note >}}

To add users, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Instance Manager host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. On the left menu, select **Users**.
1. Select **Create**.
1. On the **Create User** form, enter the details for the user:

   - **Username**: A unique username to identify the user.
   - **Email**: The user's email address.
   - **First Name**: The user's first name.
   - **Last Name**: The user's last name.
   - **Description**: An optional brief description of the user.

1. In the **Roles** list, select one or more roles to assign to the user.

   Learn more about roles and how to create them in the [Getting started with RBAC]({{< relref "/nim/admin-guide/rbac/overview-rbac" >}}) topic.

1. (Required for Basic Auth) Add each user's username and password to the `/etc/nms/nginx/.htpasswd` file on the NGINX Instance Manager server. You can choose to run a script or make the changes manually. Refer to the [Set user passwords]({{< relref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md#set-basic-passwords" >}}) topic for instructions.

{{< see-also >}}Refer to the "[Provision users and groups with SCIM]({{< relref "/nim/admin-guide/authentication/oidc/scim-provisioning.md" >}})" topic for instructions on automating user and group creation using the SCIM API.{{< /see-also >}}
