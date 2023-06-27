---
title: "Add a License"
description: "Learn how to license NGINX Management Suite using a JWT or S/MIME license, explore the features accessible in licensed and unlicensed modes, and troubleshoot common issues associated with license upload and entitlement retrieval." 
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

NGINX Management Suite offers several features that do not require a license; however, most features require a valid license to use. The [License Comparison](#license-comparison) section below provides more details about the included features and their license requirements. 

Trial licenses, subscription licenses, and licenses under the Flexible Consumption Program (FCP) are available through [MyF5](https://my.f5.com).

There are two types of license files available for the NGINX Management Suite: JSON Web Token (JWT) and S/MIME. We recommend using the JSON Web Token (JWT) for most use cases.

### JWT License {#jwt-license}

When licensing NGINX Management Suite, we recommend using the JSON Web Token (JWT) license that's provided. A JSON Web Token (JWT) is a secure and self-contained data format used to transmit information between parties as a JSON object. JWTs are commonly employed for authentication and authorization in web applications.

The JWT license offers the following advantages:

- **Automatic Updates**: With the JWT, entitlements can be automatically updated without the need to apply a separate license; for example, when renewing a license, extending the expiration date, or amending a license to increase capacity or add new modules.

- **Reporting for Flexible Consumption Program customers**: FCP customers can conveniently fulfill their reporting requirements by directly submitting usage reports to F5 from NGINX Management Suite.

NGINX Management Suite must be able to communicate with the F5 licensing servers for initial licensing, updates, and reporting.

### S/MIME License {#smime-license}

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

The following tables show which features are available when NGINX Management Suite is unlicensed or licensed.

### Unlicensed Mode

Without a license, you can still use the following features of NGINX Management Suite. The Scan feature is READ only. The defa

#### NGINX Management Suite Platform

{{<bootstrap-table "table table-striped table-bordered">}}
| User  | Feature                       | Description                                                                                     | Access |
|-------|-------------------------------|-------------------------------------------------------------------------------------------------|--------|
| admin | Licensing                     | Allows access to view and manage licenses.                                                      | CRUD   |
| admin | NGINX&nbsp;Plus&nbsp;Counting | Allows access to view the number of registered NGINX Plus instances and track Kubernetes usage. | CRUD   |
| admin | Scan                          | Allows access to scan for NGINX Instances.                                                      | READ   |
| admin | User Management               | Allows access to view and manage roles, users, and user groups.                                 | CRUD   |
{{</bootstrap-table>}}

### Licensed Mode

When NGINX Management Suite is licensed, the full range of features is available for the NGINX Management Suite platform and any installed modules.

{{<call-out "tip" "Manage access with RBAC">}}To learn how to manage and control access to features in NGINX Management Suite using role-bassed access control, refer to the topic [Set up RBAC]({{< relref "/nms/admin-guides/access-control/set-up-rbac.md" >}}).{{</call-out>}}


{{< include "admin-guides/access-control/rbac-features.md" >}}

---

## Troubleshooting

### Can't Upload a License

If you have issues uploading a license, make sure you're using the newest version of these [supported web browsers]({{< relref "/nms/tech-specs.md#supported-browsers" >}}):

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge)

### Unable to retrieve entitlements

If you're using a JWT license file, make sure NGINX Management Suite has Internet connectivity port 443.
