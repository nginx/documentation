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

## Overview

NGINX Management Suite offers several features that do not require a license; however, most features require a valid license to use. The License Comparison section below provides more details about the included features and their license requirements. 

For current customers, trial licenses, subscription licenses, and licenses under the Flexible Consumption Program (FCP) are available through [MyF5](https://my.f5.com).

There are two types of license files available for the NGINX Management Suite: JSON Web Token (JWT) and S/MIME. We recommend utilizing the JSON Web Token (JWT) for most use cases.

### JWT License

When licensing NGINX Management Suite, we recommend using the JSON Web Token (JWT) license that's provided. A JSON Web Token (JWT) is a secure and self-contained data format used to transmit information between parties as a JSON object. JWTs are commonly employed for authentication and authorization in web applications.

The JWT license offers the following advantages:

- **Automatic Updates**: With the JWT, entitlements can be automatically updated without the need to apply a separate license; for example, when renewing a license, extending the expiration date, or amending a license to increase capacity or add new modules.

- **Reporting for Flexible Consumption Program customers**: FCP customers can conveniently fulfill their reporting requirements by directly submitting usage reports to F5 from NGINX Management Suite.

NGINX Management Suite must be able to communicate with the F5 licensing servers for initial licensing, updates, and reporting.

### S/MIME License

Alternatively, you can use an S/MIME license in cases when NGINX Management Suite cannot connect to the F5 licensing servers. There are, however, some limitations with using the S/MIME license:

- **Limited Updates**: Updates to your subscription, such as renewals and amendments, will require applying a new S/MIME license file to ensure that the changes are reflected in the product.

---

## Download a License {#download-license}

### Trial License

{{< include "installation/download-trial-license.md" >}}

### Subscription and Flexible Consumption Program

{{< include "installation/download-subscription-license.md">}}

---

## Apply License {#apply-license}

### How to Apply a JWT License {#apply-jwt-license}

{{< include "installation/add-jwt-license.md" >}}

### How to Apply an S/MIME License {#apply-smime-license}

{{< include "installation/add-smime-license.md" >}}


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
| admin | NGINX Plus Counting | Core     | Allows access to view the number of registered NGINX Plus instances and track Kubernetes usage. | READ                                              |
| admin | Scan                | Platform | Allows access to scan for NGINX Instances.                           | CRUD                                                                  |
| admin | User Management     | Core     | Allows access to view and manage roles, users, and user groups.      | CRUD                                                                  |
{{</bootstrap-table>}}

### Licensed Mode

When NGINX Management Suite is licensed the full list of features are available, including those listed under Unlicensed Mode.

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
