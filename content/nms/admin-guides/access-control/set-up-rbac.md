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

Instance Manager RBAC, or Role-Based Access Control, helps you control who has access to Instance Manager resources, what they can do, and what areas they have access to.

Instance Manager RBAC is an authorization system built around three core objects:

- **Roles**: A role definition, or role for short, is a collection of permissions for one or more [features](#feature-definition). A role definition lists the actions that can be performed for each feature: create, read, update, or delete. Instance Manager includes an `admin` built-in role with full access.
- **Users**: A user account is a username with a set of credentials. You can create users directly in Instance Manager, or you can add an external identity provider.
- **Groups**: A group is a collection of users. Groups in Instance Manager are used only with external identity providers. Users from an external identity provider can't be assigned roles directly in Instance Manager, but they inherit roles through group memberships.

Users can, and often will, have **multiple roles**. When this happens, permissions are *additive*, that is, the sum of the role assignments. For example, a user with two roles, the first role granting read access to all NGINX instances and one role granting create, update, and delete access to a specific instance, will be able to read all instances and create, update, or delete only the single instance she has permission for.

<a name="feature-definition"></a>

A **feature** is a grouping of functionality in Instance Manager.

{{< note >}}The features belonging to API Connectivity Manager are only accessible if that module is installed.
Instance Manager should not be used to manage the same configurations as API Connectivity Manager. To avoid configuration issues, only READ permissions should be enabled for the following features:
Staged Configs, Instance Groups, and Instance Management. This will ensure that configurations can be viewed only in Instance Manager. {{< /note >}}

The following table lists the features you can assign roles to:

{{<bootstrap-table "table table-striped table-bordered">}}
| Module                   | Feature             | Description                                                                       |
|--------------------------|---------------------|-----------------------------------------------------------------------------------|
| Settings                 | Licensing           | Allows access to view and manage licenses                                         |
| Settings                 | User Management     | Allows access to view and manage roles, users, and user groups                    |
| Instance Manager         | Analytics           | Allows access to the analytics endpoints, including metrics, catalogs, and events |
| Instance Manager         | Certs               | Allows access to view and manage certs for NGINX instances                        |
| Instance Manager         | Instance Groups     | Allows access to view and manage NGINX instance groups                            |
| Instance Manager         | Instance Management | Allows access to view and manage NGINX instances                                  |
| Instance Manager         | Scan                | Allows access to scan for NGINX Instances                                         |
| Instance Manager         | Staged Configs      | Allows access to view and manage staged NGINX configurations                      |
| Security Monitoring      | Security Monitoring | Allows access to the Security Monitoring dashboard and APIs                       |
| API Connectivity Manager | API Docs            | Allows access to view and manage API Docs to be published to Dev Portal           |
| API Connectivity Manager | Devportal Setup     | Allows access to view and manage Dev Portals                                      |
| API Connectivity Manager | Environments        | Allows access to view and manage environments                                     |
| API Connectivity Manager | Hostname            | Allows access to view and manage hostnames for deploying proxies to               |
| API Connectivity Manager | Infra Workspace     | Allows access to view and manage Infrastructure workspaces                        |
| API Connectivity Manager | Job History         | Allows access to view and manage job history                                      |
| API Connectivity Manager | Proxy Config        | Allows access to view and manage Proxies                                          |
| API Connectivity Manager | Service Workspace   | Allows access to view and manage Service workspaces                               |

{{</bootstrap-table>}}

---

## Create a Role {#create-role}

{{< include "admin-guides/access-control/create-role.md" >}}

{{<see-also>}}If you use the Security Monitoring module, see the [Create Role for Security Monitoring]({{<relref "/nms/security/how-to/create-role-security-monitoring" >}}) topic for instructions on creating a role for accessing the module's dashboards and REST API.{{</see-also>}}

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

## Add Users {#add-users}

{{< include "admin-guides/access-control/add-users.md" >}}

---

## Assign Roles {#assign-roles}

{{< include "admin-guides/access-control/assign-roles.md" >}}

---

## Create a Group {#create-group}

{{< important >}}**Groups are used only with external identity providers** configured to use OpenID Connect (OIDC) authentication, following the steps in the [Set Up Authentication Guide]({{< relref "/nms/admin-guides/access-control/configure-authentication.md#oidc-auth" >}}).{{< /important >}}

Users from an external identity provider can't be assigned roles directly in Instance Manager, but they inherit roles through group memberships.

The default `admin` user or any user with `CREATE` permission for the **User Management** feature can create a role.

To create a group, take the following steps:

1. Open the NGINX Management Suite web interface and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. On the left navigation menu, select **User Groups**.
4. Select **Create**.
5. On the **Create Group** form, enter information for the group:

   - **Group Name**: Required. The name for the group must match the group name in the external identity provider. A group can reference only a single identity provider.
   - **Display Name**: A friendly display name for the group.
   - **Description**: A brief summary of the group.

6. In the **Roles** list, select one or more roles to assign to the group.
7. Select **Save** to create the group.

{{< see-also >}}To automate creating users and groups using the [SCIM API](http://www.simplecloud.info), refer to the [Provision Users and Groups with SCIM]({{< relref "/nms/admin-guides/access-control/scim-provisioning.md" >}}) topic for instructions. Requires Instance Manager 2.3 or later.{{< /see-also >}}

---

## What's Next

- [Set Up Authentication]({{< relref "/nms/admin-guides/access-control/configure-authentication" >}})
- [Set up Azure Active Directory as an OIDC Identity Provider]({{< relref "/nms/admin-guides/access-control/oidc-azure.md" >}})
