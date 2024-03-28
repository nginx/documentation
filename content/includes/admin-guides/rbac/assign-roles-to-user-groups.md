---
docs: DOCS-1301
---

{{< call-out "important" "User Groups require an OIDC identity provider" >}}User groups require an external identity provider configured for OpenID Connect (OIDC) authentication, as described in the [Getting Started with OIDC]({{< relref "/nms/admin-guides/authentication/oidc/getting-started-oidc.md" >}}). Users from an external identity provider cannot be assigned roles directly in NGINX Management Suite. Instead, they inherit roles by being members of user groups.{{< /call-out >}}

To assign roles to a user group, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. On the left navigation menu, select **User Groups**.
1. Select a user group from the list, then select **Edit**.
1. In the **Roles** list, select the role(s) that you want to assign to the user group.
1. Select **Save**.
