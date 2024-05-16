---
description: Learn how to easily create and manage user roles with NGINX Management
  Suite to tailor access according to your needs.
docs: DOCS-1272
doctypes:
- task
tags:
- docs
title: Create and Manage Roles
toc: true
weight: 200
---

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Overview

The NGINX Management Suite emphasizes role-based user access control. The suite includes a predefined `admin` role for initial setup and administration, but it doesn't stop there. Roles designed specifically for API Owners and Infrastructure Admins, for instance, let organizations finely delineate responsibilities and permissions. If these built-in roles don't meet your needs, it's easy to create your own.

## Create Roles {#create-roles}

{{< include "admin-guides/rbac/create-roles.md" >}}

## Edit Roles {#edit-roles}

{{< include "admin-guides/rbac/edit-roles.md" >}}

## Next Steps

### Assign Roles to Users or User Groups

After creating RBAC roles, your next task in configuring RBAC is to assign these roles to the right users or user groups. This step ensures that permissions line up with individual responsibilities within the organization, creating a clear and understandable structure for access control.

- [Assign Roles to Users or User Groups]({{< relref "nms/admin-guides/rbac/assign-roles.md" >}})
