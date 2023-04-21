---
title: "Set Up RBAC for Infra Admins"
date: 2023-03-02T13:09:51-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to set up role-based access control (RBAC) for Infra Admins using the built-in and custom roles available in the NGINX Management Suite API Connectivity Manager."
# Assign weights in increments of 100
weight: 115
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1174"
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

This tutorial will show you how to use the Role-Based Access Control (RBAC) features of API Connectivity Manager to give Infra Admins tailored levels of access to features in NGINX Management Suite. You will learn how to create roles to grant users access to workspaces and features, as well as how to add and assign users to those roles.

### Intended Audience

This guide is meant for NGINX Management Suite Administrators who can add users and create and assign roles.

### What is RBAC?

{{< include "admin-guides/access-control/what-is-rbac.md" >}}

---

## Use Case

Jon Manzana, who recently joined Acme Co., is a Senior Infrastructure Administrator for the Product Development business unit. Jon installs and maintains the IT infrastructure, monitors system performance and troubleshoots issues, and implements and maintains the IT policies and procedures.

In the following example, Jon is added to the "ACM Infra Admin" role and granted `CRUD` (Create, Read, Update, and Delete) access to the "product-development" workspace.

### Workflow

In the steps that follow, we will:

- Create a role that gives members access to an Infrastructure workspace,
- Add a new user,
- Add the user to an Infrastructure workspace and the "ACM Infra Admin" role.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

{{<comment>}}Confirm pre-reqs and add links to topics.{{</comment>}}

- API Connectivity Manager is installed, licensed, and running
- One or more [Infrastructure workspaces]({{< relref "acm/how-to/infrastructure/manage-api-infrastructure.md#create-workspace" >}})

---

## Built-In Role

API Connectivity Manager comes pre-configured with an "ACM Infra Admin" role suitable for Infrastructure Admins.

- **Infrastructure Admin**: Infrastructure Administrators ensure uniform governance across an organization’s infrastructure by setting policies at the infrastructure level, enabling teams to build APIs without interruption while adhering to the organization’s standards.

### ACM Infra Admin {#acm-infra-admin}

{{< include "acm/rbac/infra-admin-role.md" >}}

---

## Create Custom Roles

In addition to the built-in ACM RBAC roles, you can create custom roles to give users tailored levels of access to workspaces and features.

### Example: Create a workspace role

In the following example, we'll create a role for the "product-development" workspace that grants members `READ` access by default. Afterward, in the next section, we'll add a user and assign him the built-in "ACM Infra Admin" role to grant additional permissions to the workspace.

To create an Infrastructure workspace role:

1. Go the the FQDN for you NGINX Management Suite host in a web browser and log in.
2. On the top-right of the page, select the **Settings** (gear) icon.
3. On the left menu, select **Roles**.
4. Select **Create**.
5. On the Create Role page, complete the necessary fields:

   - **Name**: Type a name for the role. For example, "product-development".
   - **Display Name**: Type a name to show for the role.
   - **Description**: Add a brief description for the role.

6. Select **Add Permission**.
7. From the **Module** list, select **API Connectivity Manager**.
8. From the **Feature** list, select **Infra Workspace**.
9. In the **Access** list, select the permission(s) you want to grant. For example, `READ`.
10. In the **Applies to** list, select **Infra-Workspace**.
11. From the **Select Values** list, select the workspace you want to apply the access to. For example, "product-development".
12. Select **Save**.

---

## Add Users

When adding users, you can assign them to roles to grant tailored access levels. Role-based access is cumulative, meaning that if a user is given `READ` access to a feature in one role and CRUD access in another, they will have CRUD access for that feature.

In the following example, we'll create a user named Jon Manzana and add him to the "production-workspace" role we created above, granting him `READ` access to that workspace. In addition, since Jon is an Infrastructure Admin, we'll also add him to the pre-configured [ACM Infra Admin](#acm-infra-admin) role, giving him `CRUD` access to all workspaces he's been assigned to. Combining the "production-workspace" and "ACM Infra Admin" roles, Jon will be granted CRUD access to the “product-development”.

To add a user to NGINX Management Suite:

1. Go the the FQDN for you NGINX Management Suite host in a web browser and log in.
2. On the top-right of the page, select the **Settings** (gear) icon.
3. On the left menu, select **Users**.
4. Select **Create**.
5. On the Create User page, complete the necessary fields:

   - **Username**: Enter a unique name for the user. For example, "jon-manzana".
   - **Email**: Enter the user's email address. For example, "j.manzana@acmecorp.com".
   - **First Name**: Add the user's first name. For example, "Jon".
   - **Last Name**: Add the user's last name. For example, "Manzana".
   - **Description**: Enter an optional short description for the user. For example, "Sr. Infrastructure Administrator".
   - **Roles**: Select one or more roles to assign to the user.

      For example, for our imaginary new hire Jon Manzana, select the built-in `ACM Infra Admin` role to give him those [default permissions](#acm-infra-admin). Then select the "product-development" role to assign him to that workspace. Because role-based access is cumulative, Jon, as an ACM Infra Admin, is granted `CRUD` access for the Dev Portal Setup and Environments features in the "product-development" workspace, rather than the `READ` access that's assigned to members of "product-development" by default.

6. Select **Save**.
