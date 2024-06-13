---
docs: DOCS-1027
---

{{< call-out "important" "Group names must match with your IdP" >}}To ensure that NGINX Management Suite and your Identity Provider (IdP) work together seamlessly, group names must exactly match between the two systems. If the group names do not correspond, the OIDC integration will not work, preventing users from accessing the NGINX Management Suite. For instance, if you have a group named "app-developers" in your IdP, you must create a user group named "app-developers" in NGINX Management Suite. The group claim must also be part of the token your IdP generates. For guidance on how to add group claims, refer to your IdP's documentation. {{</call-out>}}

Users from an external identity provider can’t be assigned roles directly in NGINX Management Suite, but they inherit roles through group memberships.

Here's how to create a user group and assign roles to it:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. From the left navigation menu, select **User Groups**.
1. Select **Create**.
1. In the **Create Group** form, provide information for the group:

   - <i class="fa fa-asterisk" aria-hidden="true" style="color: red;"></i> (Required) **Group Name**: The name or Object ID of the group.  It's essential to carefully follow these guidelines:

      - The value must **exactly match** the group name or Object ID used in the identity provider.
      - A group can be linked to only one identity provider.
      - You must add a group claim to your token within your identity provider.

   - **Display Name**: Enter a friendly name for the group.
   - **Description**: Provide a brief summary of the group.

1. <i class="fa fa-asterisk" aria-hidden="true" style="color: red;"></i> (Required) Choose one or more roles from the **Roles** list to assign to the group.

   {{<important>}} To ensure full access to the NGINX Management Suite platform, you must assign the `admin` role to at least one user group. This role grants users comprehensive privileges and permissions within the platform.{{</important>}}

1. Select **Save** to create the group.

#### Example Scenario

Imagine you've created a role called "app-developer" that lets people develop, create, and modify applications, but not delete them or perform administrative tasks. You want this role to correspond to a group in your IdP named "app-developers."

In this case, you'd select the "app-developer" role when creating the "app-developers" user group in NGINX Management Suite. Users from the Identity Provider who belong to the "app-developers" group will then inherit the "app-developer" role and the associated permissions in NGINX Management Suite.
