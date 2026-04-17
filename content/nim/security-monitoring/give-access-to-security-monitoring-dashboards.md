---
title: Add user access to Security Monitoring dashboards
weight: 200
toc: true
nd-content-type: how-to
nd-product: NIMNGR
nd-docs: DOCS-1026
---

## Overview

Security Monitoring tracks activity on F5 WAF for NGINX instances. The dashboards and logs show insights, detect threats, and help improve security policies.

To give users access to Security Monitoring, you'll create a role and assign it to users or groups.

{{< call-out "note" >}}
These steps follow the principle of least privilege, so users only get access to Security Monitoring. You can create roles with different permissions if needed.
{{< /call-out >}}

---

## Before you begin

Make sure you have the following:

- Your account has access to User Management in NGINX Instance Manager. Minimum permissions are:

  - **Module**: Settings
  - **Feature**: User Management
  - **Access**: `READ`, `CREATE`, `UPDATE`

- You have the permissions listed in the following table:

  {{<bootstrap-table "table table-bordered table-hover">}}

  | Module(s)                         | Feature(s)            | Access                     | Description                                                                                              |
  |-----------------------------------|-----------------------|----------------------------|----------------------------------------------------------------------------------------------------------|
  | Instance&nbsp;Manager <hr> Security&nbsp;Monitoring | Analytics <hr> Security&nbsp;Monitoring | `READ` <hr> `READ`            | Users can view Security Monitoring dashboards. They can't view NGINX Instance Manager or Settings. |
  | Instance&nbsp;Manager <hr> Security&nbsp;Monitoring <hr> Settings | Analytics <hr> Security&nbsp;Monitoring <hr> User Management | `READ` <hr> `READ` <hr> `CREATE`,&nbsp;`READ`,&nbsp;`UPDATE` | Users can view dashboards and manage accounts and roles.<br><br>{{< icon "lightbulb" >}} Best for "super-users" who manage dashboard access. Users can't delete accounts. |

  {{</bootstrap-table>}}

---

## Create a role

{{< include "nim/rbac/create-roles.md" >}}

---

## Assign the role

Assign the Security Monitoring role to users or groups.

---

### Assign the role to users

{{< include "nim/rbac/assign-roles-to-users.md" >}}

---

### Assign the role to user groups

{{< include "nim/rbac/assign-roles-to-user-groups.md" >}}
