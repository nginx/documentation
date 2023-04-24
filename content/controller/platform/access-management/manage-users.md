---
authors: []
categories:
- platform management
- account settings
date: "2020-10-26T15:32:41-06:00"
description: Create and manage User resources
docs: DOCS-784
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
title: Manage Users
toc: true
weight: 20
---

## Overview

This topic explains how to create and manage User resources.

A User resource represents an NGINX Controller User account. [Assign Roles to Users]({{< relref "/platform/access-management/manage-roles.md" >}}) to define what actions Users can perform in NGINX Controller and what [Environment(s)]({{< relref "/services/manage-environments.md" >}}) Users can access.

By default, all users have `READ` permissions for Analytics, Users, Roles, and Licenses. You can use the `/platform/roles` endpoint in the [NGINX Controller REST API]({{< relref "api/_index.md" >}}) to extend or narrow this default set of permissions.

### Create a User

{{< include "users/add-users.md" >}}

### Edit or Delete a User

{{< include "users/edit-delete-users.md" >}}

## What's Next

- [Create a Role or Role Group]({{< relref "/platform/access-management/manage-roles.md" >}})
- [Create an Authentication Provider]({{< relref "/platform/access-management/manage-active-directory-auth-provider.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
