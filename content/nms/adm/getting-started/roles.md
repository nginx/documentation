---
title: Setting up User Roles
description: Learn how to set up basic roles for managing the App Delivery Manager module.
weight: 200
draft: false
toc: true
tags: ["docs"]
docs: "DOCS-1136"
---

{{< custom-styles>}}

Before using the App Delivery Manager module, we recommend setting up [role-based access control](https://docs.nginx.com/nginx-management-suite/admin-guides/access-control/set-up-rbac) (RBAC) for the teams that will be using the product. All App Delivery Manager API endpoints are backed by RBAC as well and bring unique considerations due to its object hierarchy. These are described in the [RBAC]({{< relref "/nms/adm/about/rbac-overview.md" >}}) section of **App Delivery Manager Concepts**. By default, users (except the Admin) are denied access to any endpoints unless explicitly given permission.

## Standard Roles

The App Delivery Manager module allows you to create different types of users, each with its own set of roles, to ensure that each app team can work in isolation. In its simplest form, there would be a single role for a [platform ops](https://www.nginx.com/resources/glossary/what-is-platform-ops/) team, which gives them full permissions to the App Delivery Manager environment endpoint as well as the NGINX Management Suite Instance Manager endpoints. In addition, each app team should be given a role while allows them to create apps for a particular environment or set of environments.

The platform ops team might want to have more control besides setting up the environments and may also want to manage the life cycle of the gateways that are used in each environment.

{{< note >}}
The NGINX Management Suite user interface (UI) makes background calls to related objects for each App Delivery Manager endpoint as it generates the web pages. This is not always clear, so the guidelines below takes this into consideration. See the [App Delivery Manager API Overview]({{< relref "/nms/adm/about/api-overview.md" >}}) to learn more about the relationship between the objects.{{< /note >}}

### Minimum Role for Platform Ops Team

The following table shows the **minimum** permissions that should be granted to a platform ops user, assuming the platform ops team wants to control all Instance Manager-related resources and App Delivery Manager environment resources:

{{<bootstrap-table "table table-striped table-bordered">}}


| RBAC Resource             | Module | Permissions                  |
| ------------------------- | ------ | ---------------------------- |
| Analytics*                | Instance Manager    | Read                         |
| Certs                     | Instance Manager    | Create, Read, Update, Delete |
| Instance Management       | Instance Manager    | Create, Read, Update, Delete |
| Instance Groups           | Instance Manager    | Create, Read, Update, Delete |
| Security Policies         | Instance Manager    | Create, Read, Update, Delete |
| Site Management           | App Delivery Manager    | Create, Read, Update, Delete |
| Environment Management    | App Delivery Manager    | Create, Read, Update, Delete |
| App Management*           | App Delivery Manager    | Read                         |
| Gateway Management*       | App Delivery Manager    | Read                         |
| TCP Component Management* | App Delivery Manager    | Read                         |
| Web Component Management* | App Delivery Manager    | Read                         |
| Nginx Plus Usage*         | Instance Manager    | Read                         |
| Scan*                     | Instance Manager    | Read                         |
{{</bootstrap-table>}}

\* Suggested permissions to aid in troubleshooting, but not strictly necessary.

As mentioned, these are the minimum roles required. If the platform ops team must also act as the administrator, they will need full rights to all resources, including `User Management` and `Licensing`.

#### Fine-Tuned RBAC Restrictions

Some resources allow fine-tuning of how the RBAC is applied to individual objects for that resource type. Below is a list of the additional adjustments that should be made for each of these resources:

* Certs
  * all systems
* Instance Management
  * all systems
* Instance Groups
  * all Instance Groups
* Environment Management
  * all environments

### Minimum role for App Teams

The following table shows the minimum permissions (RBAC) that should be granted to each app team, assuming the team is given access to only their own environment `envX` (they could, in theory, own multiple environments):

{{<bootstrap-table "table table-striped table-bordered">}}


| RBAC Resource             | Module | Permissions                  |
| --------------------------- | -------- | ------------------------------ |
| Analytics                 | Instance Manager    | Read                         |
| Certs*                    | Instance Manager    | Read                         |
| Instance Management       | Instance Manager    | Read                         |
| Instance Groups           | Instance Manager    | Read                         |
| Security Policies         | Instance Manager    | Read                         |
| Site Management           | App Delivery Manager    | Read                         |
| Environment Management    | App Delivery Manager    | Read                         |
| App Management            | App Delivery Manager    | Create, Read, Update, Delete |
| Gateway Management*       | App Delivery Manager    | Create, Read, Update, Delete |
| TCP Component Management* | App Delivery Manager    | Create, Read, Update, Delete |
| Web Component Management* | App Delivery Manager    | Create, Read, Update, Delete |

{{</bootstrap-table>}}

\* These settings depend on the role the platform ops team wants to have regarding the NGINX configurations. If the platform ops team wants to manage the traffic going into the NGINX instances, they will want CRUD (create, read, update, and delete) control of the Gateways and restrict app teams to read-only permissions. Another restriction the platform ops team may want to impose is restricting the app teams to either Web or TCPUDP components. Finally, they can allow app teams to add their own certs or restrict the available certs (in the example provided, the app team has access to use any certs installed on the system).

As mentioned, these are the minimum roles required. If the platform ops team decides each app team should be able to see resources from other app teams, they can modify the fine-tuned permissions below to allow this.

#### Fine-Tuned RBAC Restrictions

Some resources allow fine-tuning of how the RBAC is applied to individual objects for that resource type. Below is a list of the additional adjustments that should be made for each of these resources:

* Certs
  * all systems or restricted set
* Instance Groups
  * all Instance Groups or restricted set
* Site Management
  * all sites or restricted set
* Environment Management
  * environment `envX`
* App Management
  * environment `envX`
  * all Apps
* Gateway Management
  * environment `envX`
  * all Gateways
* Web Component Management
  * environment `envX`
  * all Apps
  * all Web Components
* TCP Component Management
  * environment `envX`
  * all Apps
  * all TCP Components
