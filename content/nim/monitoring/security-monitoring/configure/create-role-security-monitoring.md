---
title: Add user access to Security Monitoring dashboards
description: Learn how to grant users access to the F5 NGINX Security Monitoring dashboards.
toc: true
weight: 200
doctype: how-to
product: NIM
docs: DOCS-1026

---

## Overview

You can use F5 NGINX Security Monitoring to monitor NGINX App Protect WAF instances. The Security Monitoring analytics dashboards and security logs provide protection insights and help you analyze possible threats or identify opportunities to tune your security policies.

By completing the steps in this topic, you will create a role that gives users access to the Security Monitoring module and logs, and assign it to user accounts or groups.

{{< note >}} The recommendations in this guide follow the principle of least privilege and do not grant users access to NGINX Instance Manager. You can create additional roles with custom modules, features, and permissions to suit your use case. {{</ note >}}

---

## Before you begin

Complete the following prerequisites before proceeding with this guide:

- NGINX Security Monitoring is [installed]({{< relref "/nim/monitoring/security-monitoring/install-security-monitoring.md" >}}) and running.
- Your user account needs to be able to access the User Management settings in NGINX Instance Manager.
  The minimum required role permissions are:

  - **Module**: Settings
  - **Feature**: User Management
  - **Access**: `READ`, `CREATE`, `UPDATE`

- Review the table below to determine the minimum permissions needed for your use case.

  {{<bootstrap-table "table table-bordered table-hover">}}

  | Module(s) | Feature(s) | Access | Description |
  |-------|--------|----|--------|
  | Instance&nbsp;Manager <hr> Security&nbsp;Monitoring | Analytics <hr> Security&nbsp;Monitoring | READ <hr> READ  | Read-only access that allows users to view the Security Monitoring dashboards. Users cannot access NGINX Instance Manager or Settings.|
  | Instance&nbsp;Manager <hr> Security&nbsp;Monitoring <hr> Settings | Analytics <hr> Security&nbsp;Monitoring <hr>User Management | READ <hr> READ <hr> CREATE,&nbsp;READ,&nbsp;UPDATE| Allows users to view the Security Monitoring dashboards and manage user accounts and roles.<br><br>{{< fa "lightbulb" >}} Recommended for a "super-user" who is responsible for managing other users' access to the security dashboards. This permission set does not allow the user to delete user accounts.|


 {{</bootstrap-table>}}

--- 

## Create a role

{{< include "nim/rbac/create-roles.md" >}}

---

## Assign the role

After you've created a role for Security Monitoring, assign the role to one or more users or to a user group.

---

### Assign the role to users

{{< include "nim/rbac/assign-roles-to-users.md" >}}

---

### Assign the role to user groups

{{< include "nim/rbac/assign-roles-to-user-groups.md" >}}
