---
title: "Set Up RBAC"
date: 2022-03-24T16:23:50-07:00
description: "Follow the steps in this tutorial to limit access to features using role-based access control (RBAC)."
# Assign weights in increments of 100
weight: 300
draft: false
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-919"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "configuration", "security", "rbac"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
aliases:
- /nginx-instance-manager/admin-guide/set-up-rbac/
- /admin-guides/access-control/add-users/
---

{{< custom-styles >}}

{{< shortversions "2.1.0" "latest" "nimvers" >}}

## Overview

With role-based access control, or RBAC, you can define permissions for users and control which resources and areas they have access to.

Here are some key concepts related to RBAC:

- **Users**: Users are individual accounts identified by a username and credentials. You have the flexibility to create users directly within NGINX Management Suite or integrate an external identity provider.
- **Roles**: Roles represent a collection of permissions associated with one or more features. Each role determines the actions that can be performed for each feature, such as create, read, update, or delete. The pre-defined `admin` role provides full access to all features.

   Users can have multiple roles simultaneously. In such cases, the permissions granted by each role are combined, providing an additive effect. For instance, a user with two roles, one granting read access to all NGINX instances and the other allowing create, update, and delete access to a specific instance, will be able to read all instances while having the ability to create, update, or delete only the designated instance for which they have permission.

- **Groups**: Groups are collections of users. Groups are exclusively used in conjunction with external identity providers. Users from external identity providers cannot be directly assigned roles within NGINX Management Suite. However, they inherit roles through their group memberships.
- **Features**: Features in NGINX Management Suite are specific functional components or capabilities that allow users to perform various tasks and access related resources. 


The following table lists the features you can assign roles to:

{{< include "admin-guides/access-control/rbac-features.md" >}}

<br>

{{< call-out "important" "API Connectivity Manager's features" >}}The features belonging to API Connectivity Manager are available only when that module is installed.
Instance Manager **should not** be used to manage the same configurations as API Connectivity Manager. To avoid potential configuration issues, only READ permissions should be enabled for Staged Configs, Instance Groups, and Instance Management. This will ensure that configurations can only be viewed in Instance Manager. {{< /call-out >}}

---

## Add Users {#add-users}

{{< include "admin-guides/access-control/add-users.md" >}}

---

## Create a Role {#create-role}

{{< include "admin-guides/access-control/create-role.md" >}}

---

## Assign Roles {#assign-roles}

{{< include "admin-guides/access-control/assign-roles.md" >}}

---

## Built-In Roles {#build-in-roles}

API Connectivity Manager comes pre-configured with roles suitable for API Owners and Infrastructure Admins.

- **API Owner**: The individuals or teams who are responsible for designing, creating, and maintaining APIs.
- **Infrastructure Admin**: Infrastructure Administrators ensure uniform governance across an organization’s infrastructure by setting policies at the infrastructure level, enabling teams to build APIs without interruption while adhering to the organization’s standards.

### ACM API Owner {#acm-api-owner}

{{< include "acm/rbac/api-owner-role.md" >}}

{{<see-also>}}The tutorial [Set Up RBAC for API Owners]({{< relref "/nms/acm/tutorials/rbac-api-owners.md">}}) provides an example of how to configure RBAC for API owners.{{</see-also>}}

### ACM Infra Admin {#acm-infra-admin}

{{< include "acm/rbac/infra-admin-role.md" >}}

{{<see-also>}}The tutorial [Set Up RBAC for Infra Admins]({{< relref "/nms/acm/tutorials/rbac-infra-admins.md">}}) provides an example of how to configure RBAC for Infrastructure Administrators.{{</see-also>}}

---

## Create a User Group {#create-group}


{{< include "admin-guides/access-control/create-group.md" >}}

{{< see-also >}}Refer to the "[Provision Users and Groups with SCIM](({{< relref "/nms/admin-guides/access-control/scim-provisioning.md" >}}))" topic for instructions on automating user and group creation using the [SCIM API](http://www.simplecloud.info).{{< /see-also >}}


---

## What's Next

- [Set Up Authentication]({{< relref "/nms/admin-guides/access-control/configure-authentication" >}})
- [Set up Azure Active Directory as an OIDC Identity Provider]({{< relref "/nms/admin-guides/access-control/oidc-azure.md" >}})
