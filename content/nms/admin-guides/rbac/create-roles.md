---
title: "Create and Manage Roles"
date: 2023-08-03T10:50:23-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to easily create and manage user roles with NGINX Management Suite to tailor access according to your needs."
# Assign weights in increments of 100
weight: 200
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1272"
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

## Built-In Roles

### API Connectivity Manager

API Connectivity Manager comes pre-configured with roles suitable for API Owners and Infrastructure Admins.

- **API Owner**: The individuals or teams who are responsible for designing, creating, and maintaining APIs.
- **Infrastructure Admin**: Infrastructure Administrators ensure uniform governance across an organization’s infrastructure by setting policies at the infrastructure level, enabling teams to build APIs without interruption while adhering to the organization’s standards.

#### ACM API Owner {#acm-api-owner}

{{< include "acm/rbac/api-owner-role.md" >}}

{{<see-also>}}The tutorial [Set Up RBAC for API Owners]({{< relref "/nms/acm/tutorials/rbac-api-owners.md">}}) provides an example of how to configure RBAC for API owners.{{</see-also>}}

<br>

#### ACM Infra Admin {#acm-infra-admin}

{{< include "acm/rbac/infra-admin-role.md" >}}

{{<see-also>}}The tutorial [Set Up RBAC for Infra Admins]({{< relref "/nms/acm/tutorials/rbac-infra-admins.md">}}) provides an example of how to configure RBAC for Infrastructure Administrators.{{</see-also>}}

## Next Steps

### Assign Roles to Users or User Groups

After creating RBAC roles, your next task in configuring RBAC is to assign these roles to the right users or user groups. This step ensures that permissions line up with individual responsibilities within the organization, creating a clear and understandable structure for access control.

- [Assign Roles to Users or User Groups]({{< relref "nms/admin-guides/rbac/assign-roles.md" >}})