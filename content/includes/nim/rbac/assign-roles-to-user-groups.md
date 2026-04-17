---
nd-product: NIMNGR
nd-docs: DOCS-1301
nd-files:
- content/nim/admin-guide/rbac/assign-roles.md
- content/nim/security-monitoring/give-access-to-security-monitoring-dashboards.md
---

{{< call-out "important" "User groups require an OIDC identity provider" >}}User groups require an external identity provider configured for OpenID Connect (OIDC) authentication, as described in [Getting started with OIDC]({{< ref "/nim/admin-guide/authentication/oidc/getting-started.md" >}}). Users from an external identity provider cannot be assigned roles directly in NGINX Instance Manager. Instead, they inherit roles based on their group membership.{{< /call-out >}}

To assign roles to a user group:

1. Go to the FQDN for your NGINX Instance Manager host and log in.
2. Select the **Settings** gear icon.
3. Select **User Groups**.
4. Select a user group from the list, then select **Edit**.
5. In the **Roles** list, select the role(s) you want to assign.
6. Select **Save**.
