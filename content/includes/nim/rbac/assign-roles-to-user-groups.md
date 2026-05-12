---
f5-product: NIMNGR
f5-docs: DOCS-1301
f5-files:
- content/nim/admin-guide/rbac/assign-roles.md
- content/nim/security-monitoring/give-access-to-security-monitoring-dashboards.md
---

{{< call-out "important" "User groups require an OIDC identity provider" >}}User groups require an external identity provider set up for OpenID Connect (OIDC) authentication, as described in [Getting started with OIDC]({{< ref "/nim/admin-guide/authentication/oidc/getting-started.md" >}}). You can't assign roles directly to users from an external identity provider in NGINX Instance Manager. Instead, they inherit roles based on their group membership.{{< /call-out >}}

To assign roles to a user group, follow these steps:

1. In a web browser, go to the FQDN for your NGINX Instance Manager host and log in.
2. Select the **Settings** gear icon in the upper-right corner.
3. From the left navigation menu, select **User Groups**.
4. Select a user group from the list, then select **Edit**.
5. In the **Roles** list, select the role(s) you want to assign to the group.
6. Select **Save**.
