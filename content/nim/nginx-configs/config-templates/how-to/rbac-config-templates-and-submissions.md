---
title: RBAC for config templates and submissions
draft: false
description: ''
weight: 300
toc: true
docs: DOCS-1505
personas:
- devops
- netops
- secops
- support
type:
- tutorial
---

## Overview

With role-based access control (RBAC), administrators can determine who can create, read, update, and delete templates and template submissions. This access control helps you securely manage your NGINX configurations and deployments.

## Before You Begin

- Ensure the user is added as a [basic authentication]({{< ref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md" >}}) or [OpenID Connect (OIDC)]({{< ref "/nim/admin-guide/authentication/oidc/getting-started.md" >}}) user in F5 NGINX Instance Manager.
- Familiarize yourself with the concepts of [Roles]({{< ref "/nim/admin-guide/rbac/assign-roles.md" >}}) and [Permissions]({{< ref "/nim/admin-guide/rbac/create-roles.md" >}}) within Instance Manager as they are crucial for managing access.

## Assign Roles for Templates and Template Submissions

To complete these steps, you need administrator access.

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.

2. Select **Settings** (gear icon) in the upper-right corner of the dashboard.

3. Select **Users** from the left menu to manage individual users or **User Groups** for managing access at a group level.

4. Define access to templates and template submissions:
   - To ensure proper management of NGINX configurations, [create or edit roles]({{< ref "/nim/admin-guide/rbac/create-roles.md" >}}) to specify access to templates and template submissions. This may involve defining CRUD permissions specific to managing NGINX configurations.

   - **Restricting access to templates** is essential for controlling who can create and modify templates. This responsibility generally falls to administrators with a comprehensive understanding of NGINX configurations.

   - **Restricting access to template submissions** limits who can change submitted template inputs. This role could be assigned to application development teams, allowing them to deploy and manage their apps themselves.

5. Assign or modify roles:
   - For individual users, select a user from the list and click **Edit User**. For user groups, select a group and click **Edit**.
   - In the **Roles** list, select the roles you want to assign to the user or user group. Ensure that the roles include permissions for managing templates and/or template submissions.

6. After assigning roles and permissions, select **Save** to apply the changes.

---

## Additional Templating Resources

{{< include "nim/templates/additional-templating-resources.md" >}}

