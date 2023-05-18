---
title: "Add a License"
description: "This topic explains how to add licenses for NGINX Management Suite modules, including Instance Manager and API Connectivity Manager." 
date: 2021-12-21T12:00:00-07:00
draft: false
weight: 400
doctypes: task
toc: true
docs: "DOCS-789"
categories: ["configuration", "installation"]
aliases:
- /nginx-instance-manager/admin-guide/add-license/
---

{{< custom-styles >}}

## Download License {#download-license}

{{< include "installation/download-license.md" >}}

---

## Apply License {#apply-license}

{{< include "installation/add-license.md" >}}

---

## License Comparison {#license-comparison}

The following tables show which features are available for the `admin` user when NGINX Management Suite is licensed or unlicensed.

{{<see-also>}}
A **feature** is a grouping of functionality in NGINX Management Suite. For more information about features and role-assignments, see [Set Up RBAC]({{< relref "/nms/admin-guides/access-control/set-up-rbac.md" >}}).
{{</see-also>}}

### Unlicensed Mode

The following features are available when NGINX Management Suite is unlicensed:

{{<bootstrap-table "table table-striped table-bordered">}}
| User  | Feature             | Area     | Description                                                          | Access&nbsp;Type                                                      |
|-------|---------------------|----------|----------------------------------------------------------------------|-----------------------------------------------------------------------|
| admin | Licensing           | Core     | Allows access to view and manage licenses.                           | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |
| admin | NGINX Plus Counting | Core     | Allows access to view the number of registered NGINX Plus instances. | READ                                                                  |
| admin | Scan                | Platform | Allows access to scan for NGINX Instances.                           | CRUD                                                                  |
| admin | User Management     | Core     | Allows access to view and manage roles, users, and user groups.      | CRUD                                                                  |
{{</bootstrap-table>}}

### Licensed Mode

The following features are available when NGINX Management Suite is licensed.

#### Instance Manager

{{<bootstrap-table "table table-striped table-bordered">}}
| User  | Feature             | Area     | Description                                                          | Access&nbsp;Type                                                      |
|-------|---------------------|----------|----------------------------------------------------------------------|-----------------------------------------------------------------------|
| admin | Instance Groups     | Platform | Allows access to view and manage NGINX instance groups.              | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |
| admin | Instance Management | Platform | Allows access to view and manage NGINX instances.                    | CRUD                                                                  |
| admin | Licensing           | Core     | Allows access to view and manage licenses.                           | CRUD                                                                  |
| admin | NGINX Plus Counting | Core     | Allows access to view the number of registered NGINX Plus instances. | READ                                                                  |
| admin | Scan                | Platform | Allows access to scan for NGINX Instances.                           | CRUD                                                                  |
| admin | Staged Configs      | Platform | Allows access to view and manage staged NGINX configurations.        | CRUD                                                                  |
| admin | User Management     | Core     | Allows access to view and manage roles, users, and user groups.      | CRUD                                                                  |
{{</bootstrap-table>}}

#### API Connectivity Manager

{{< note >}}
The features belonging to API Connectivity Manager require that module to be installed.
{{< /note >}}

{{<bootstrap-table "table table-striped table-bordered">}}
| User  | Feature           | Area                     | Description                                                              | Access&nbsp;Type                                                      |
|-------|-------------------|--------------------------|--------------------------------------------------------------------------|-----------------------------------------------------------------------|
| admin | API Docs          | API Connectivity Manager | Allows access to view and manage API Docs to be published to Dev Portal. | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |
| admin | Dev Portal Setup  | API Connectivity Manager | Allows access to view and manage Dev Portals.                            | CRUD                                                                  |
| admin | Infra Workspace   | API Connectivity Manager | Allows access to view and manage Infrastructure Workspaces.              | CRUD                                                                  |
| admin | Environments      | API Connectivity Manager | Allows access to view and manage Environments.                           | CRUD                                                                  |
| admin | Proxy Config      | API Connectivity Manager | Allows access to view and manage Proxies.                                | CRUD                                                                  |
| admin | Service Workspace | API Connectivity Manager | Allows access to view and manage Service Workspaces.                     | CRUD                                                                  |
| admin | Job History       | API Connectivity Manager | Allows access to view and manage Job History.                            | CRUD                                                                  |
{{</bootstrap-table>}}

---

### App Delivery Manager

{{< note >}}
The features belonging to App Delivery Manager require that module to be installed.
{{< /note >}}

{{<bootstrap-table "table table-striped table-bordered">}}
| User  | Feature             | Area              | Description                                                          | Access&nbsp;Type                                                      |
|-------|---------------------|-------------------|----------------------------------------------------------------------|-----------------------------------------------------------------------|
| admin | Environments        | App Delivery Manager      | Allows access to view and manage environments.                      | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |
| admin | Apps        | App Delivery Manager      | Allows access to view and manage apps.                      | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |
| admin | Gateways        | App Delivery Manager      | Allows access to view and manage gateways.                      | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |
| admin | Web components        | App Delivery Manager      | Allows access to view and manage web components.                      | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |
| admin | TCP/UDP components        | App Delivery Manager      | Allows access to view and manage TCP/UDP components.                      | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |
| admin | Sites        | App Delivery Manager      | Allows access to view and manage sites.                      | [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) |


## Troubleshooting

### Can't Upload a License

If you have issues uploading a license, make sure you're using the newest version of these [supported web browsers]({{< relref "/nms/tech-specs.md#supported-browsers" >}}):

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge)
