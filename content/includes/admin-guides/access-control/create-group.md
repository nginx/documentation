---
docs: DOCS-1027
---

{{< call-out "important" "User Groups require an OIDC Identity Provider" >}}User groups are only used with external identity providers configured for OpenID Connect (OIDC) authentication, as described in the [Set Up Authentication Guide]({{< relref "/nms/admin-guides/access-control/configure-authentication.md#oidc-auth" >}}). Users from an external identity provider cannot be assigned roles directly in NGINX Management Suite. However, they can inherit roles through their group memberships.{{< /call-out >}}

The default `admin` user or any user with `CREATE` permission for the **User Management** feature can create a group.

To create a user group, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.

1. On the left navigation menu, select **User Groups**.
1. Select **Create**.
1. On the **Create Group** form, enter information for the group:

   - **Group Name**: Required. The name for the group must match the group name in the external identity provider. A group can reference only a single identity provider.
   - **Display Name**: A friendly display name for the group.
   - **Description**: A brief summary of the group.

1. In the **Roles** list, select one or more roles to assign to the group.
1. Select **Save** to create the group.
