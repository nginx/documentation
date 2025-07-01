---
description: Learn how to set up role-based access control (RBAC) for Infra Admins
  using the built-in and custom roles available in the F5 NGINX Management Suite API
  Connectivity Manager.
nd-docs: DOCS-1174
title: Set Up RBAC for Infra Admins
toc: true
weight: 115
type:
- tutorial
---

## Overview

This tutorial will show you how to use the Role-Based Access Control (RBAC) features of API Connectivity Manager to give Infra Admins tailored levels of access to features in F5 NGINX Management Suite. You will learn how to create roles to grant users access to workspaces and features, as well as how to add and assign users to those roles.

### Intended Audience

This guide is meant for NGINX Management Suite Administrators who can add users and create and assign roles.

### What is RBAC?

{{< include "nim/rbac/what-is-rbac.md" >}}

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
- One or more [Infrastructure workspaces]({{< ref "/nms/acm/how-to/infrastructure/manage-api-infrastructure.md#create-workspace" >}})

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

In the following example, we'll create a role for the "product-development" workspace. This role will let members have `READ` access that workspace by default. Afterward, in the next section, we'll add a user and assign him the built-in "ACM Infra Admin" role. This will provide additional permissions to the workspace.

To create an Infrastructure workspace role:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. From the left navigation menu, select **Roles**.
4. Select **Create**.
5. On the **Create Role** form, provide the following details:

   - **Name**: The name to use for the role. In this example, we'll name the role "product-development".
   - **Display name**: An optional, user-friendly name to show for the role.
   - **Description**: An optional, brief summary of what the role is.

6. To add permissions:

   1. Select **Add Permission**.
   2. From the **Module** list, select **API Connectivity Manager**.
   3. In the **Feature** list, select, select **Infra Workspace**.
   4. Select **Add Additional Access** to add a CRUD (Create, Read, Update, Delete) access level.

      - In the **Access** list, select the access level(s) you want to grant. In this example, we'll select `READ`.
      - In the **Applies to** list, select **Infra-Workspace**.
      - In the **Select values** list, select the workspace you want to apply the access to. In this example, we'll select, "product-development".

   5. Select **Save**.

7. Select **Save**.

<br>

<div style="text-align:center;">{{< img src="acm/tutorials/rbac/infra-workspace-role.png" alt="Infrastructure Workspace" width="65%">}}</div>


---

## Add Users

When adding users, you can assign them to roles to give them specific access. Role-based access is cumulative, meaning that if a user is given `READ` access for a feature in one role and CRUD access in another, they will have CRUD access for that feature.

In the following example, we'll create a user named Jon Manzana. We'll add Jon to the "production-workspace" role we created above, granting him `READ` access to that workspace. Since Jon works as an Infrastructure Admin, we'll assign him the pre-configured [ACM Infra Admin](#acm-infra-admin) role, too. This will give Jon `CRUD` access to any workspace he's assigned to. By having both the "production-workspace" and "ACM Infra Admin" roles, Jon will get CRUD access to the “product-development” workspace.

<br>

To add a user to NGINX Management Suite:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. On the left menu, select **Users**.
1. Select **Create**.
1. On the **Create User** form, enter the details for the user:

   - **Username**: A unique name to identify the user. For example, "jon-manzana".
   - **Email**: The user's email address. For example, "<j.manzana@acmecorp.com>".
   - **First Name**: The user's first name. For example, "Jon".
   - **Last Name**: The user's last name. For example, "Manzana".
   - **Description**: An optional brief description of the user. For example, "Sr. Infrastructure Administrator".

1. In the **Roles** list, select one or more roles to assign to the user.

   For example, for our imaginary new hire Jon Manzana, select the built-in `ACM Infra Admin` role to give him those [default permissions](#acm-infra-admin). Then select the "product-development" role to assign him to that workspace. Because role-based access is cumulative, Jon, as an ACM Infra Admin, is granted `CRUD` access for the Dev Portal Setup and Environments features in the "product-development" workspace, rather than the `READ` access that's assigned to members of "product-development" by default.

1. Select **Save**.

<br>

<div style="text-align:center;">{{< img src="acm/tutorials/rbac/infra-admin-user.png" alt="Infra Admin User" width="65%">}}</div>
