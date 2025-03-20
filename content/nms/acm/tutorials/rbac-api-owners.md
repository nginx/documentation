---
description: Learn how to use both built-in and custom roles to configure role-based
  access control for F5 NGINX Management Suite API Connectivity Manager.
docs: DOCS-1173
title: Set Up RBAC for API Owners
toc: true
weight: 110
type:
- tutorial
---

## Overview

This tutorial will show you how to use the Role-Based Access Control (RBAC) features of API Connectivity Manager to give API Owners tailored levels of access to features in F5 NGINX Management Suite. You will learn how to create roles to grant users access to workspaces and features, as well as how to add and assign users to those roles.

### Intended Audience

This guide is meant for NGINX Management Suite Administrators who can add users and create and assign roles.

### What is RBAC?

{{< include "nim/rbac/what-is-rbac.md" >}}

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
- One or more [Service workspaces]({{< relref "/nms/acm/how-to/services/publish-api.md#create-a-service-workspace" >}})

---

## Built-In Role

API Connectivity Manager comes pre-configured with an "ACM API Owner" role suitable for API Owners.

- **API Owner**: The individuals or teams who are responsible for designing, creating, and maintaining APIs.

### ACM API Owner {#acm-api-owner}

{{< include "acm/rbac/api-owner-role.md" >}}

---

## Create Custom Roles

In addition to the built-in API Connectivity Manager RBAC roles, you can create custom roles to give users tailored levels of access to workspaces and features.

### Example: Create a workspace role

In the following example, we'll create a role for the "hr-api-services" workspace that grants members `READ` access by default. Afterward, in the next section, we'll add a user and assign her the built-in "ACM API Owner" role to grant additional permissions to the workspace.

To create a Services workspace role:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. From the left navigation menu, select **Roles**.
4. Select **Create**.
5. On the **Create Role** form, provide the following details:

   - **Name**: The name to use for the role. In this example, we'll name the role "hr-api-services".
   - **Display name**: An optional, user-friendly name to show for the role.
   - **Description**: An optional, brief summary of what the role is.

6. To add permissions:

   1. Select **Add Permission**.
   2. From the **Module** list, select **API Connectivity Manager**.
   3. In the **Feature** list, select **Service Workspace**.
   4. Select **Add Additional Access** to add a CRUD (Create, Read, Update, Delete) access level.

      - In the **Access** list, select the access level(s) you want to grant. In this example, we'll select `READ`.
      - In the **Applies to** list, select **Service-Workspace**.
      - In the **Select values** list, select the workspace you want to apply the access to. In this example, we'll select, "hr-api-services".

   5. Select **Save**.

7. Select **Save**.

---

## Add Users

When adding users, you can assign them to roles to grant tailored access levels. Role-based access is cumulative, meaning that if a user is given `READ` access to a feature in one role and `CRUD` access in another, they will have `CRUD` access for that feature.

In this example, we'll create a user named Jane Smith. We'll add her as an [ACM API Owner](#acm-api-owner) in the "hr-api-services" workspace.

To add users, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** (gear) icon in the upper-right corner.
1. On the left menu, select **Users**.
1. Select **Create**.
1. On the **Create User** form, enter the details for the user:

   - **Username**: A unique name to identify the user. For example, "jane-smith".
   - **Email**: The user's email address. For example, "<j.smith@acmecorp.com>".
   - **First Name**: The user's first name. For example, "Jane".
   - **Last Name**: The user's last name. For example, "Smith".
   - **Description**: An optional brief description of the user. For example, "Senior Software Engineer".

1. In the **Roles** list, select one or more roles to assign to the user.

   For example, for our imaginary new hire Jane Smith, select the built-in `ACM API Owner` role to give her those [default permissions](#acm-api-owner). Then select the "hr-api-services" role to assign her to that workspace. Because role-based access is cumulative, Jane, as an ACM API Owner, is granted `CRUD` access for the API Docs, Dev Portal Setup, and Proxy Config features in the "hr-api-services" workspace, rather than the `READ` access that's assigned to members of "hr-api-services" by default.

1. Select **Save**.
