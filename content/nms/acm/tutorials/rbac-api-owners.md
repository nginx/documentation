---
title: "Set Up RBAC for API Owners"
date: 2023-03-02T13:09:51-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to use both built-in and custom roles to configure role-based access control for NGINX Management Suite API Connectivity Manager."
# Assign weights in increments of 100
weight: 110
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1173"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{< custom-styles >}}

## Overview

This tutorial will show you how to use the Role-Based Access Control (RBAC) features of API Connectivity Manager to give API Owners tailored levels of access to features in NGINX Management Suite. You will learn how to create roles to grant users access to workspaces and features, as well as how to add and assign users to those roles.

### Intended Audience

This guide is meant for NGINX Management Suite Administrators who can add users and create and assign roles.

### What is RBAC?

{{< include "admin-guides/access-control/what-is-rbac.md" >}}

---

## Use Case

Jane Smith has joined Acme Co. as an API developer for the Human Resources department. Jane will be working in a Services workspace called "hr-api-services," and she needs `CRUD` (Create, Read, Update, and Delete) access for the API Docs, Dev Portal Setup, and Proxy Config features in that workspace.

### Workflow

In the steps that follow, we will:

- Create a role that gives members access to a Services workspace,
- Add a new user,
- Assign the user to a Services workspace and the "ACM API Owner" role.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

{{<comment>}}Confirm pre-reqs and add links to topics.{{</comment>}}

- API Connectivity Manager is installed, licensed, and running
- One or more [Service workspaces]({{< relref "acm/how-to/services/publish-api.md#create-a-service-workspace" >}})

---

## Built-In Role

API Connectivity Manager comes pre-configured with an "ACM API Owner" role suitable for API Owners.

- **API Owner**: The individuals or teams who are responsible for designing, creating, and maintaining APIs.

### ACM API Owner {#acm-api-owner}

{{< include "acm/rbac/api-owner-role.md" >}}

---

## Create Custom Roles

In addition to the built-in ACM RBAC roles, you can create custom roles to give users tailored levels of access to workspaces and features.

### Example: Create a workspace role

In the following example, we'll create a role for the "hr-api-services" workspace that grants members `READ` access by default. Afterward, in the next section, we'll add a user and assign her the built-in "ACM API Owner" role to grant additional permissions to the workspace.

To create a Services workspace role:

1. Go the the FQDN for you NGINX Management Suite host in a web browser and log in.
2. On the top-right of the page, select the **Settings** (gear) icon.
3. On the left menu, select **Roles**.
4. Select **Create**.
5. On the Create Role page, complete the necessary fields:

   - **Name**: Type a name for the role. For example, "hr-api-services"
   - **Display Name**: Type a name to show for the role.
   - **Description**: Add a brief description for the role.

6. Select **Add Permission**.
7. From the **Module** list, select **API Connectivity Manager**.
8. From the **Feature** list, select **Service Workspace**.
9. In the **Access** box, select the permission(s) you want to grant. For example, `READ`.
10. In the **Applies to** list, select **Service-Workspace**.
11. From the **Select values** list, select the workspace you want to apply the access to. For example, "hr-api-services".
12. Select **Save**.

---

## Add Users

When adding users, you can assign them to roles to grant tailored access levels. Role-based access is cumulative, meaning that if a user is given `READ` access to a feature in one role and `CRUD` access in another, they will have `CRUD` access for that feature.

In this example, we'll create a user named Jane Smith. We'll add her as an [ACM API Owner](#acm-api-owner) in the "hr-api-services" workspace.

To add a user to NGINX Management Suite:

1. Go the the FQDN for you NGINX Management Suite host in a web browser and log in.
2. On the top-right of the page, select the **Settings** (gear) icon.
3. On the left menu, select **Users**.
4. Select **Create**.
5. On the Create User page, complete the necessary fields:

   - **Username**: Enter a unique name for the user. For example, "jane-smith".
   - **Email**: Enter the user's email address. For example, "j.smith@acmecorp.com".
   - **First Name**: Add the user's first name. For example, "Jane".
   - **Last Name**: Add the user's last name. For example, "Smith".
   - **Description**: Enter an optional short description for the user. For example, "Senior Software Engineer".
   - **Roles**: Select one or more roles to assign to the user.

      For example, for our imaginary new hire Jane Smith, select the built-in `ACM API Owner` role to give her those [default permissions](#acm-api-owner). Then select the "hr-api-services" role to assign her to that workspace. Because role-based access is cumulative, Jane, as an ACM API Owner, is granted `CRUD` access for the API Docs, Dev Portal Setup, and Proxy Config features in the "hr-api-services" workspace, rather than the `READ` access that's assigned to members of "hr-api-services" by default.

6. Select **Save**.
