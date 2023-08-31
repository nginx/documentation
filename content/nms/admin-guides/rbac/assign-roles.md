---
title: "Assign Roles to Users or User Groups"
date: 2023-08-08T15:25:05-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 210
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1273"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{< custom-styles >}}

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

## Before You Begin

This topic assumes you have already created users or user groups that can be assigned roles. If you need to complete these steps, choose one of the links below:

- To create users, follow the instructions in the [Set Up Basic Authentication]({{< relref "/nms/admin-guides/authentication/basic-authentication.md" >}}).
- To create user groups, follow the instructions in [Getting Started with OIDC]({{< relref "/nms/admin-guides/authentication/oidc/getting-started-oidc.md" >}}).


## Assign Roles to Users (Basic Authentication)

{{< include "admin-guides/rbac/assign-roles-to-users.md" >}}

## Assign Roles to User Groups (OIDC)

{{< include "admin-guides/rbac/assign-roles-to-user-groups.md" >}}
