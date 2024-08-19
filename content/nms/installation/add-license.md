---
description: Learn how to license NGINX Management Suite using a JWT or S/MIME license,
  explore the features accessible in licensed and unlicensed modes, and troubleshoot
  common issues associated with license upload and entitlement retrieval.
docs: DOCS-789
doctypes: task
title: Add a License
toc: true
weight: 500
---

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

{{<call-out "note" "Trial periods">}}
<br>

- JWT trial licenses expire 30 days after being applied to NGINX Management Suite.
- S/MIME trial licenses expire 30 days after they are issued.
{{</call-out>}}

To download a trial license for NGINX Management Suite:

1. Sign in to the [MyF5 Customer Portal](https://account.f5.com/myf5).
2. From the top menu, select **My Products & Plans > Trials**.
3. In the **My Trials** list, select your NGINX Management Suite trial.
4. Select the **Downloads and Licenses** link.
5. On the **Downloads and licenses** panel, select **Download License**. The license file is saved to your system.


### Subscription and Flexible Consumption Program

To download a subscription or Flexible Consumption Program license for NGINX Management Suite:

1. Sign in to the [MyF5 Customer Portal](https://account.f5.com/myf5).
2. From the top menu, select **My Products & Plans > Subscriptions**.
3. In the **Subscriptions** list, select your subscription that includes NGINX Management Suite.
4. On the Subscriptions Details form, select the **License** link for NGINX Management Suite. The license file is saved to your system.


---

## Apply License {#apply-license}

### How to Apply a JWT License {#apply-jwt-license}

{{<important>}}
<br>

To retrieve your entitlements, make sure to allow inbound and outbound access on port 443 to the following URLs:

- https://product.apis.f5.com
- https://product-s.apis.f5.com/ee

{{</important>}}

To upload and apply a JWT license for NGINX Management Suite:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** gear icon.
1. On the **Settings** menu, select **Licenses**.
1. Select **Get Started**.
1. Select **Browse** to upload the license, or you can simply drag and drop the license onto the form.
1. Select **Add**. NGINX Management Suite will automatically retrieve your product entitlements from F5's licensing servers.
1. (Optional) To send telemetry data to F5 NGINX, select the **Enable Continuous Connection** option. For detailed information about the data being transmitted and its purpose, refer to the topic [Configure Telemetry]({{< relref "/nms/admin-guides/configuration/configure-telemetry.md" >}}).

Your NGINX entitlements will now be visible on the **Licenses** page, along with information about your product usage relative to your entitled capacity.

You can return to this page at any time to cancel the license. Simply select **Terminate** and then confirm the action. This action will notify F5 that the license has been terminated.

### How to Apply an S/MIME License {#apply-smime-license}

To upload and apply an S/MIME license for NGINX Management Suite:

1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
1. Select the **Settings** gear icon.
1. On the **Settings** menu, select **Licenses**.
1. Select **Get Started**.
2. Select **Browse** to upload the license, or you can simply drag and drop the license onto the form.
3. Select **Add**.
4. Select **Done**.
5. (Optional) To send telemetry data to F5 NGINX, select the **Enable Continuous Connection** option. For detailed information about the data being transmitted and its purpose, refer to the topic [Configure Telemetry]({{< relref "/nms/admin-guides/configuration/configure-telemetry.md" >}}).

Your NGINX entitlements will now be visible on the **Licenses** page.

You can return to this page at any time to cancel the license. Simply select **Terminate** and then confirm the action.

---

## License Comparison {#license-comparison}

The following tables show which features are available when NGINX Management Suite is licensed or unlicensed.

### Unlicensed Mode Features

The NGINX Management Suite features listed in the table below are available without a license.

{{<bootstrap-table "table table-striped table-bordered">}}

| Feature                       | Description                                                                    | Access Type |
|-------------------------------|--------------------------------------------------------------------------------|-------------|
| Licensing                     | View and manage licenses.                                                      | CRUD        |
| NGINX&nbsp;Plus&nbsp;Counting | View the number of registered NGINX Plus instances and track Kubernetes usage. | CRUD        |
| Scan                          | Permits scanning for NGINX instances.                                          | READ        |
| User Management               | Create, configure, and manage roles, users, and user groups.                   | CRUD        |

{{</bootstrap-table>}}

### Licensed Mode Features

When you license an NGINX Management Suite module, you gain access to the full range of platform features as well as the module-specific features. See the tables below to learn what features each module offers.

{{<call-out "note" "Manage feature access with RBAC">}}You can control access to features in NGINX Management Suite with role-based access control (RBAC). For details, see [Getting Started with RBAC]({{< relref "/nms/admin-guides/rbac/rbac-getting-started.md" >}}).{{</call-out>}}


#### NGINX Management Suite Platform

{{< include "admin-guides/rbac/features/platform.md" >}}

<br>

#### Instance Manager

{{< include "admin-guides/rbac/features/instance-manager.md" >}}

<br>

#### Security Monitoring

{{< include "admin-guides/rbac/features/security-monitoring.md" >}}

<br>

---

## Troubleshooting

### Can't Upload a License

If you have issues uploading a license, make sure you're using the newest version of these [supported web browsers]({{< relref "/nms/tech-specs.md#supported-browsers" >}}):

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge)
