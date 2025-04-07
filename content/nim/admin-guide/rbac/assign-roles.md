---
docs: DOCS-1273
title: Assign roles to users or user groups
toc: true
weight: 210
type:
- how-to
---

## Overview

In NGINX Instance Manager, role-based access control (RBAC) lets you assign permissions to users or user groups based on their roles in the organization. This ensures that users only have access to the features they need. Before assigning roles, make sure you’ve created the necessary users or user groups. This guide covers how to assign roles to users using basic authentication and to user groups when using an OpenID Connect (OIDC) identity provider.

## Before you begin

{{<call-out "important" "First steps: Create users or user groups" >}}
Make sure you’ve already created users or user groups that can be assigned roles. If not, follow these guides:

- To create users, follow the instructions in [Set up basic authentication]({{< ref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md" >}}).
- To create user groups, follow the steps in [Getting started with OIDC]({{< ref "/nim/admin-guide/authentication/oidc/getting-started.md" >}}).
{{</call-out>}}



## Assign roles to users (basic authentication)

{{< include "/nim/rbac/assign-roles-to-users.md" >}}

## Assign roles to user groups (OIDC)

{{< include "/nim/rbac/assign-roles-to-user-groups.md" >}}
