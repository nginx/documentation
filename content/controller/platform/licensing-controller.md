---
description: Follow these steps to license your F5 NGINX Controller.
docs: DOCS-787
title: License NGINX Controller
toc: true
weight: 120
type:
- how-to
---

## Overview

This topic explains how to upload and manage licenses for F5 NGINX Controller.

&nbsp;

---

## License Types

NGINX Controller licenses can be either connected or disconnected licenses:

- A **connected license** sends telemetry data to F5, which enables pricing based on usage. When adding a connected license, you must provide a customer Association Token, which you can get from the [MyF5 Customer Portal](https://account.f5.com/myf5).
- A **disconnected license** doesn't send telemetry data to F5. To add a disconnected license, you can upload the license file using the NGINX Controller web interface or the NGINX Controller API.

&nbsp;

---

## Get Your License

To access your license, get your Customer Access Token, or sign up for a trial license, visit the [MyF5 Customer Portal](https://account.f5.com/myf5).

&nbsp;

---

## Add or Update a License

To add or update a license for NGINX Controller, take the following steps:

1. Go to `https://<Controller-FQDN>/platform/license`.
1. In the **Upload a license** section of the page, select an upload option:

    - **Upload license file** -- Locate and select your license file in the file explorer.
    - **Paste your Association Token or license file** -- Paste your customer Association Token or the contents of your NGINX Controller license file. These are available on the [MyF5 Customer Portal](https://account.f5.com/myf5).

1. Select **Save license**.

{{< see-also >}}To add a license using the [NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}), send a PUT request to the `/platform/license` endpoint. Provide your CAT or NGINX Controller license as a base64-encoded string in the JSON request body.{{< /see-also >}}


&nbsp;

---

## View License Details

To view the details for your NGINX Controller license, take the following steps:

1. On the NGINX Controller menu, select **Platform** > **License** > **Controller License**.
2. On the **Licenses** page, you can view the details for the applied licenses, including license limitations, status, and the expiration date.

{{< see-also >}}To view the details for your license(s) using the [NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}), send a GET request to the `/platform/license` endpoint.{{< /see-also >}}
&nbsp;

---

## Delete a License

To delete a license using the [NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}), send a DELETE request to the `/platform/license` endpoint.

&nbsp;

---

## License Features

- When you license NGINX Controller, you have full access to all of the features included in the license.

- If you haven't licensed NGINX Controller, or if your license has expired, you can still access the following restricted set of features using the [NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}):

  - Log in and out of NGINX Controller
  - Manage licenses
  - Manage users
  - Manage user groups
  - Manage roles
  - Manage integration accounts
  - Manage support bundles
  - Manage backups
  - View alerts

&nbsp;

---

## Licensing FAQs

### How is a Workload Defined for Licensing Purposes?

Workloads are back-end objects (whether the workload is a stand-alone application or containerized) behind the NGINX Controller that receive traffic. For licensing purposes, workloads are calculated by counting the unique IP addresses used by workloads within each distinct location.

Workloads can be reused across instances within the same location without increasing the number of workloads counted. However, if a workload is referenced by instances across multiple locations, that workload will be counted once for each different location. For example, if workload 1.1.1.1 is referenced by instance1 and instance2, if both instance1 and instance2 are grouped under location1, then 1.1.1.1 will only be counted as one workload. However, if instance1 is grouped under location1 while instance2 is grouped under location2, then 1.1.1.1 will be counted twice.

### How is Aggregate Data Defined for Licensing Purposes?

Aggregate data is represented by the total volume of bytes in/out per hour for all of the data planes managed by NGINX Controller.

### How Do I Ensure My License for NGINX Controller Is Compliant?

To verify your license is compliant, check for the following:

- Make sure your usage is within the capacity that your license allows. Refer to the [View License Details]({{< relref "/controller/platform/licensing-controller.md#view-license-details" >}}) section for instructions.

- Ensure your license has not expired.

- If you are using an Association Token, make sure to allow incoming and outgoing connections on port 443 TCP. If you're running NGINX Controller v3.15 or earlier, also enable incoming and outgoing connections on port 8883 TCP. These ports are used for validating the entitlements for your license. Refer to the [NGINX Controller Technical Specifications Guide]({{< relref "/controller/admin-guides/install/nginx-controller-tech-specs.md#firewallip-settings" >}}) for these and other firewall requirements.

&nbsp;

---

## Troubleshoot Licensing Issues

If NGINX Controller appears to be unlicensed after a version upgrade, try the following options to resolve the issue.

- [Re-upload your NGINX Controller license]({{< relref "/controller/platform/licensing-controller.md#add-or-update-a-license" >}}).
- [Restore the NGINX Controller database from a backup]({{< relref "/controller/admin-guides/backup-restore/_index.md" >}}).

&nbsp;

---

## What's Next

- [Download the NGINX Plus Cert and Key Bundle]({{< relref "/controller/admin-guides/install/get-n-plus-cert-and-key.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
