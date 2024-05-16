---
description: This document describes role-based access control (RBAC) in NGINX Management
  Suite, outlining essential concepts and features. It serves as a starting point,
  linking to additional resources and how-to topics for those looking to set up and
  manage access controls effectively.
docs: DOCS-919
doctypes:
- tutorial
tags:
- docs
title: Getting Started with RBAC
toc: true
weight: 1
---

<style>
h2 {
  border-top: 1px solid #ccc;
  padding-top:20px;
}
</style>

{{< shortversions "2.1.0" "latest" "nimvers" >}}

## Overview

Role-Based Access Control (RBAC) is a security system that governs access to resources within a software application. By assigning specific roles to users or groups, RBAC ensures that only authorized individuals have the ability to perform certain actions or access particular areas.

The value of RBAC lies in its ability to provide clear and structured control over what users can see and do. This makes it easier to maintain security, streamline user management, and ensure compliance with internal policies or regulations. By giving users only the permissions they need to fulfill their roles, RBAC reduces the risk of unauthorized access and fosters a more efficient and secure operating environment.

The following are essential concepts related to RBAC:

- **Users**: Users are individual accounts identified by a username and credentials. You have the option to create users within NGINX Management Suite using basic authentication or to integrate with an external identity provider using OpenID Connect (OIDC).
- **Roles**: Roles are sets of permissions linked to one or more features. Each role specifies the actions that are allowed for each feature, such as creating, reading, updating, or deleting. The pre-defined `admin` role grants full access to all features.

   Users can have multiple roles simultaneously. In such cases, the permissions granted by each role are combined, providing an additive effect. For instance, a user with two roles, one granting read access to all NGINX instances and the other allowing create, update, and delete access to a specific instance, will be able to read all instances while having the ability to create, update, or delete only the designated instance for which they have permission.

- **Groups**: Groups are collections of users. They are used only when integrating with external identity providers. Users from these providers can't be assigned roles directly within NGINX Management Suite but inherit roles through membership in groups.
- **Features**: In NGINX Management Suite, features refer to distinct functional components or capabilities that let users perform a variety of tasks and access related resources. The sections below outline the features available for the NGINX Management Suite platform and modules.
- **Resource Object**: These are specific elements within a feature that can be targeted for precise access control. Essentially, a resource object is a finer-grained component within a feature that you can control access to. For example, if you are working with the Instance Management feature, you have the option to apply access control to specific entities like Resource Groups and/or Systems. This allows for more nuanced management of permissions within NGINX Management Suite.

## Features {#features}

The NGINX Management Suite platform and modules have their own set of capabilities called features, listed below. System administrators can decide who can access these features, and how they do so, by defining role-based access control. In the "[Next Steps](#next-steps)" section at the bottom, you'll find links to resources for adding users and creating roles.

<br>

{{< note >}}The availability of certain features depends on whether a module is licensed. To see the differences between the features you can use with the licensed and unlicensed versions of NGINX Management Suite, please refer to the topic [Add a License]({{< relref "nms/installation/add-license.md#license-comparison" >}}).{{< /note >}}

### NGINX Management Suite Platform

{{< include "admin-guides/rbac/features/platform.md" >}}

#### Endpoints

Explore the API endpoints for the NGINX Management Suite platform by going to **https://<NMS_FQDN>/ui/docs**. Replace `<NMS_FQDN>` with the fully qualified domain name (FQDN) of your NGINX Management Suite host, which is the complete domain name specific to your system.

---

### Instance Manager

{{< include "admin-guides/rbac/features/instance-manager.md" >}}


#### Endpoints

Explore the API endpoints for Instance Manager by going to **https://<NMS_FQDN>/ui/docs**. Replace `<NMS_FQDN>` with the fully qualified domain name (FQDN) of your NGINX Management Suite host, which is the complete domain name specific to your system.

---

### API Connectivity Manager

{{< include "admin-guides/rbac/features/api-connectivity-manager.md" >}}


#### Endpoints

Explore the API endpoints for API Connectivity Manager by going to **https://<NMS_FQDN>/ui/docs/API-Connectivity-Manager**. Replace `<NMS_FQDN>` with the fully qualified domain name (FQDN) of your NGINX Management Suite host, which is the complete domain name specific to your system.

#### Built-In Roles

API Connectivity Manager comes pre-configured with roles suitable for API Owners and Infrastructure Admins.

- **API Owner**: The individuals or teams who are responsible for designing, creating, and maintaining APIs.
- **Infrastructure Admin**: Infrastructure Administrators ensure uniform governance across an organization’s infrastructure by setting policies at the infrastructure level, enabling teams to build APIs without interruption while adhering to the organization’s standards.

##### ACM API Owner {#acm-api-owner}

{{< include "acm/rbac/api-owner-role.md" >}}

{{<see-also>}}The tutorial [Set Up RBAC for API Owners]({{< relref "/nms/acm/tutorials/rbac-api-owners.md">}}) provides an example of how to configure RBAC for API owners.{{</see-also>}}

##### ACM Infra Admin {#acm-infra-admin}

{{< include "acm/rbac/infra-admin-role.md" >}}

{{<see-also>}}The tutorial [Set Up RBAC for Infra Admins]({{< relref "/nms/acm/tutorials/rbac-infra-admins.md">}}) provides an example of how to configure RBAC for Infrastructure Administrators.{{</see-also>}}

## Next Steps {#next-steps}

In the following topics, you'll learn how to add users and set up authentication methods such as basic authentication and OpenID Connect (OIDC). Once you've added users, you can create roles and assign them to individuals or user groups to provide access to specific features.

### Add Users and Configure Authentication

- [Set Up Basic Authentication]({{< relref "nms/admin-guides/authentication/basic-authentication.md" >}})
- [Getting Started with OIDC]({{< relref "nms/admin-guides/authentication/oidc/getting-started-oidc.md" >}})

### Create and Assign Roles

- [Create and Manage Roles]({{< relref "nms/admin-guides/rbac/create-roles.md" >}})
- [Assign Roles to Users or User Groups]({{< relref "nms/admin-guides/rbac/assign-roles.md" >}})
