---
authors: []
categories:
- platform management
- account settings
date: "2020-10-26T15:32:41-06:00"
description: Create and manage Roles and Role Groups
docs: DOCS-783
doctypes:
- tutorial
draft: false
journeys:
- researching
- getting started
- using
menu:
  docs:
    parent: Access Management
personas:
- devops
roles:
- admin
tags:
- docs
title: Manage Roles and Role Groups
toc: true
weight: 30
---

## Overview

This topic explains how to create and manage Roles and Role Groups.

- **Roles** define a set of permissions that allow or prevent Users from performing operations in NGINX Controller or in an [Environment]({{< relref "/services/manage-environments.md" >}}).

- **Role Groups** act as a collection of Roles that you can manage as a single resource. All members of a Role Group are assigned the same set of Roles. Role Groups can be mapped only to external auth provider groups; they can not be assigned to local users.

## Predefined Roles and Role Groups

NGINX Controller provides the following predefined Roles and Role Groups:

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Role    | Role Group    | Permissions | Details |
|---------|---------------|-------------|---------|
| `admin` | `admin_group` | Full        | The predefined `admin` Role and `admin_group` Role Group have full permissions for all Environments and can publish API Definitions. |
| `user`  | `user_group`  | Write       | The predefined `user` Role and `user_group` Role Group have write access to Environments and can publish API Definitions. |
| `guest` | `guest_group` | Read-Only   | The predefined `guest` Role and `guest_group` Role Group have read-only access to Environments and cannot publish API Definitions. |

{{< important >}}
Beginning in NGINX Controller 3.12, users no longer need to have one of the predefined roles. Users are granted a basic set of `READ` permissions for Analytics, Users, Roles, and Licenses. Users without a built-in role no longer have the implicit `READ` permissions for all Environments, Identity Providers, API Definitions, Locations, Providers, and Integrations. You can use the `/platform/roles` endpoint in the [NGINX Controller REST API]({{< relref "api/_index.md" >}}) to extend or narrow a role's set of permissions.
{{< /important >}}

## Permissions

Permissions are based on the API namespace. Permissions are *implicit deny*, that is, a permission is denied unless the user or group is explicitly allowed to perform the permission.

The four permission levels are:

- `FULL` - can create, modify, and delete resources
- `WRITE` - can create and modify resources, but can't delete
- `READ` - can get info about a resource
- `NONE` - no access

By default, all users have `READ` permissions for Analytics, Users, Roles, and Licenses.

{{< tip >}}
You can use the `/platform/roles` endpoint in the [NGINX Controller REST API]({{< relref "api/_index.md" >}}) to extend this default set of permissions.
{{< /tip >}}

### Example: Inheriting Permissions

Whether for a collection or a specific resource instance, each permission contains a path to a resource and a permission level. Resources that are deeper in the path hierarchy inherit permissions from their parents unless explicitly overwritten. Refer to the [NGINX Controller API Reference Guide]({{< relref "api/_index.md" >}}) for the resource paths.

In this example, all resources under `/services/environments/` inherit `READ` access:

```json
{
     "access": "READ",
     "path": "/services/environments/"
}
```

Requests made to the following endpoints are treated as such:

- /services/environments/test - `READ`
- /services/environments/staging - `READ`
- /services/environments/test/apps/cart - `READ`
- /services/environments/staging/apps/register - `READ`

### Example: Overriding Inherited Permissions

In this example, the `test` Environment is expressly denied access, overwriting the `READ` access set at the parent level:

```json
{
     "access": "READ",
     "path": "/services/environments/"
},
{
     "access": "NONE",
     "path": "/services/environments/test"
}
```

Requests made to the following endpoints are treated as such:

- /services/environments/test - `DENY`
- /services/environments/staging - `READ`
- /services/environments/test/apps/cart - `DENY`
- /services/environments/staging/apps/register - `READ`

### Understanding a Role's Permissions

When you [view the details for a Role](#view-edit-or-delete-a-role), you can see the Role's permissions for the NGINX Controller settings and Environments.

The following table shows how to evaluate the permissions list. Permissions are applied in order of specificity. A wildcard (*) in a path is more specific than no information, and a resource name in a path is more specific than a wildcard.

| Path                 | Role            | Permission | Explanation  |
|----------------------|-----------------|------------|--------------|
| `/`                  | `admin`, `user` | `FULL`     | Full access to all exposed endpoints, except for endpoints that are explicitly denied. |
| `/`                  | `guest`         | `READ`     | Read-only access to all exposed endpoints, except for endpoints that are explicitly denied or allowed write access. |
| `/platform/users/`   | `user`          | `READ`     | Read-only access to the collection of users. This role can view other user accounts but cannot create new users. |
| `/platform/users/*/` | `user`          | `WRITE`    | Write access to update existing users; for example, users can update their user accounts. |
| `/platform/global/`  | `guest`         | `NONE`     | No access to view or update the global settings for NGINX Controller. |

## Overlapping Role Assignments

When users are assigned to multiple overlapping Roles, permissions are determined as follows:

- The most specific restriction wins.
- The least permissive restriction breaks a tie.

So, for example, if you're adding a user to a Role that grants `WRITE` access to the `Production` Environment, and you add the same user to another Role that grants `READ` access to `Production`, the user will have `READ` access, that is, the least permissive restriction.

{{< tip >}}

When assigning Roles or Role Groups for users, you should assign the least permissive Role needed for users to complete their tasks.

{{< /tip >}}

## Create a Role

{{< note >}}
Roles must belong to [Environments]({{< relref "/services/manage-environments.md#about-environments" >}}). If you don't already have an Environment, or you don't want to place your new Role(s) in your existing Environment, you should [create a new Environment]({{< relref "/services/manage-environments.md#create-an-environment" >}}) before you continue.

The `/platform/roles` endpoint in the [NGINX Controller REST API]({{< relref "api/_index.md" >}}) allows more freedom when creating roles. You can use the Roles API to grant permissions outside of environments, for example to `/reports/`.

{{< /note >}}

{{< include "roles/add-roles.md" >}}

## View, Edit, or Delete a Role

{{< include "roles/view-edit-delete-role.md" >}}

## Create a Role Group

{{< include "roles/add-role-groups.md" >}}

## View, Edit, or Delete a Role Group

{{< include "roles/view-edit-delete-role-group.md" >}}

## What's Next

- [Create a User]({{< relref "/platform/access-management/manage-users.md" >}})
- [Create an Authentication Provider]({{< relref "/platform/access-management/manage-active-directory-auth-provider.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
