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

There are two types of license files available for NGINX Management Suite: JSON Web Token (JWT) and S/MIME. We recommend using the JSON Web Token (JWT) for most use cases.

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

{{<call-out "note" "License period">}}JWT trial licenses expire 30 days after being applied to NGINX Management Suite.{{</call-out>}}

To download a trial license for NGINX Management Suite:

1. Sign in to the [MyF5 Customer Portal](https://account.f5.com/myf5).
2. From the top menu, select **My Products & Plans > Trials**.
3. In the **My Trials** list, select your NGINX Management Suite trial.
4. Select the **Downloads and Licenses** link.
5. On the **Downloads and licenses** panel, select **Download License**. The license file is saved to your system.


### Subscription and Flexible Consumption Program

{{<call-out "note" "License period">}}S/MIME trial licenses expire 30 days after they are issued.{{</call-out>}}

To download a subscription or Flexible Consumption Program license for NGINX Management Suite:

1. Sign in to the [MyF5 Customer Portal](https://account.f5.com/myf5).
2. From the top menu, select **My Products & Plans > Subscriptions**.
3. In the **Subscriptions** list, select your subscription that includes NGINX Management Suite.
4. On the Subscriptions Details form, select the **License** link for NGINX Management Suite. The license file is saved to your system.


---

## Apply License {#apply-license}

### How to Apply a JWT License {#apply-jwt-license}

To upload and apply a JWT license for NGINX Management Suite:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
2. Select the **Settings** gear icon.
3. On the **Settings** menu, select **Licenses**.
4. Select **Get Started**.
5. Locate the `.jwt` file you [downloaded from MyF5]({{< relref "/nms/installation/add-license.md#download-license" >}}), then select **Upload**. NGINX Management Suite will automatically retrieve your product entitlements from F5's licensing servers.
6. Select **Review Entitlements** and confirm the correct product entitlements are listed.
7. Select **Submit**.
8. (Optional) To send telemetry data to F5 NGINX, select the **Enable Telemetry** option. For detailed information about the data being transmitted and its purpose, refer to the topic [Configure Telemetry]({{< relref "/nms/admin-guides/configuration/configure-telemetry.md" >}}).

Your NGINX entitlements will now be visible on the Licenses page, along with information about your product usage relative to your entitled capacity.

If needed, you can return to this page at any time to cancel the license by removing the `.jwt` file and revoking your entitlements. This action will notify F5 that the license has been terminated.

### How to Apply an S/MIME License {#apply-smime-license}

To upload and apply an S/MIME license for NGINX Management Suite:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** gear icon.
1. On the **Settings** menu, select **Licenses**.
1. Select **Get Started**.
1. Locate the `.lic` file that you [downloaded from MyF5]({{< relref "/nms/installation/add-license.md#download-license" >}}), then select **Upload**.

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
