---
docs: DOCS-1027
---

To create a user group, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. On the left navigation menu, select **User Groups**.
1. Select **Create**.
1. On the **Create Group** form, enter information for the group:

   - <i class="fa fa-asterisk" aria-hidden="true" style="color: red;"></i> (Required) **Group Name**: The name or Object ID of the group. 
   
      - The value must exactly match the group name or Object ID used in the identity provider.
      - A group can reference only one identity provider.
      - You must add a group claim to your token within your identity provider.

   - **Display Name**: A friendly name to show for the group.
   - **Description**: A brief summary of the group.

1. <i class="fa fa-asterisk" aria-hidden="true" style="color: red;"></i> (Required) In the **Roles** list, select one or more roles to assign to the group.

   {{<note>}}To ensure full access to the NGINX Management Suite platform, at least one user group must be assigned the `admin` role. This role grants users comprehensive privileges and permissions within the platform.{{</note>}}

1. Select **Save** to create the group.

