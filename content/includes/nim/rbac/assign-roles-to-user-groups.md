---
nd-docs: DOCS-1301
---

{{< call-out "important" "User groups require an OIDC identity provider" >}}User groups require an external identity provider configured for OpenID Connect (OIDC) authentication, as described in [Getting started with OIDC]({{< ref "/nim/admin-guide/authentication/oidc/getting-started.md" >}}). Users from an external identity provider cannot be assigned roles directly in NGINX Instance Manager. Instead, they inherit roles based on their group membership.{{< /call-out >}}

To assign roles to a user group, follow these steps:

1. In a web browser, go to the FQDN for your NGINX Instance Manager host and log in.
2. Select the **Settings** gear icon in the upper-right corner.
3. From the left navigation menu, select **User Groups**.
4. Select a user group from the list, then select **Edit**.
5. In the **Roles** list, choose the role(s) you want to assign to the group.
6. Select **Save**.
