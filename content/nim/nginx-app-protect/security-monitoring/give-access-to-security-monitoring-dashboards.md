---
title: Add user access to Security Monitoring dashboards
weight: 200
toc: true
type: how-to
product: NIM
nd-docs: DOCS-1026
---

## Overview

F5 NGINX Security Monitoring tracks activity on NGINX App Protect WAF instances. The dashboards and logs show insights, detect threats, and help improve security policies.

This guide explains how to create a role to give users access to Security Monitoring and assign it to users or groups.

{{< call-out "note" >}}
This guide follows the principle of least privilege, so users only get access to Security Monitoring. You can create roles with different permissions if needed.
{{< /call-out >}}

---

## Before you begin

Make sure you complete these steps:

- Your account must have access to User Management in NGINX Instance Manager. Minimum permissions are:

  - **Module**: Settings
  - **Feature**: User Management
  - **Access**: `READ`, `CREATE`, `UPDATE`

- Use the table below to find the permissions you need:

  {{<bootstrap-table "table table-bordered table-hover">}}

  | Module(s)                         | Feature(s)            | Access                     | Description                                                                                              |
  |-----------------------------------|-----------------------|----------------------------|----------------------------------------------------------------------------------------------------------|
  | Instance&nbsp;Manager <hr> Security&nbsp;Monitoring | Analytics <hr> Security&nbsp;Monitoring | `READ` <hr> `READ`            | Gives read-only access to Security Monitoring dashboards. Users cannot access NGINX Instance Manager or Settings. |
  | Instance&nbsp;Manager <hr> Security&nbsp;Monitoring <hr> Settings | Analytics <hr> Security&nbsp;Monitoring <hr> User Management | `READ` <hr> `READ` <hr> `CREATE`,&nbsp;`READ`,&nbsp;`UPDATE` | Lets users view dashboards and manage accounts and roles.<br><br>{{< icon "lightbulb" >}} Best for "super-users" who manage dashboard access. Does not allow deleting accounts. |

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
