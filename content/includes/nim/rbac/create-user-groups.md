---
nd-docs: DOCS-1027
---

{{< call-out "important" "Group names must match with your IdP" >}}To ensure that NGINX Instance Manager and your IdP work together seamlessly, group names must exactly match between the two systems. If the group names don’t match, the OIDC integration will fail, preventing users from accessing NGINX Instance Manager. For example, if you have a group called "app-developers" in your IdP, you must create a user group called "app-developers" in NGINX Instance Manager. The group claim must also be part of the token your IdP generates. Refer to your IdP's documentation for guidance on adding group claims.{{</call-out>}}

Here's how to create a user group and assign roles:

1. In a web browser, go to the FQDN for your NGINX Instance Manager host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. From the left navigation menu, select **User Groups**.
1. Select **Create**.
1. On the **Create Group** form, provide the following information:

   - **Group Name** (required): The group name or Object ID. This must **exactly match** the name used in the IdP.
   - **Display Name**: A friendly name for the group.
   - **Description**: A brief description of the group.

1. Select one or more roles from the **Roles** list to assign to the group.

   {{<important>}}At least one user group must have the `admin` role assigned.{{</important>}}

1. Select **Save** to create the group.

#### Example scenario

Imagine you’ve created a role called "app-developer" for users who develop, create, and modify applications but don’t need to perform administrative tasks. You want this role to correspond to a group in your IdP named "app-developers."

In this case, select the "app-developer" role when creating the "app-developers" user group in NGINX Instance Manager. Users in the "app-developers" group from the IdP will inherit the "app-developer" role in NGINX Instance Manager.
