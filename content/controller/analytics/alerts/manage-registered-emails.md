---
description: Learn how to manage the email addresses that receive automatic alert
  notifications.
docs: DOCS-522
title: Manage Registered Email Addresses
toc: true
weight: 310
type:
- concept
---

## Overview

In order to receive email notifications for [Alerts]({{< relref "/controller/analytics/alerts/about-alerts.md" >}}), you need to provide a valid email address and complete the verification process.

{{< important >}}
You will not receive any alert notifications via email until you verify your email address. Any alert notification emails that were triggered by alert rules prior to the email address being verified will not be re-sent.
{{< /important >}}

## List Registered Email Addresses

To find the list of registered email addresses:

1. Open the F5 NGINX Controller user interface and log in.
1. On the **Analytics** menu, select **Alerts**.
1. On the **Alert Rules Overview** page, select **Manage Email Addresses**.
1. All registered email addresses are displayed in the Manage Email Addresses panel. To close the panel, select **Done**.

{{<important>}}The **Manage Email Addresses** button is not displayed if you don't have any Alerts configured. If this is the case, you can add a new email address when you [create an alert rule]({{< relref "/controller/analytics/alerts/manage-alerts.md#add-an-alert-rule" >}}).{{</important>}}

## Add a New Email Address

To add a new email address:

1. Open the NGINX Controller user interface and log in.
1. On the **Analytics** menu, select **Alerts**.
1. On the **Alert Rules Overview** page, select **Manage Email Addresses**.
1. In the **Manage Email Addresses** panel:
1. Select **Add Email Address**.
1. Provide the desired email address.
1. Select the submit (plus sign) icon.
1. Select **Done** to close the Manage Email Addresses panel.
1. Check your email inbox for a message with the subject `[controller-team] Email verification`.
1. Click on the link provided in the email to complete the verification process.

## Re-send a Verification Email

To re-send a verification email to a newly-registered email address:

1. Open the NGINX Controller user interface and log in.
1. On the **Analytics** menu, select **Alerts**.
1. On the **Alert Rules Overview** page, select **Manage Email Addresses**.
1. Select the Resend verification (circular arrows) icon to the right of the email address.
1. Select **Done** to close the Manage Email Addresses panel.

## Remove a Registered Email Address

To remove a registered email address:

1. Open the NGINX Controller user interface and log in.
1. On the **Analytics** menu, select **Alerts**.
1. On the **Alert Rules Overview** page, select **Manage Email Addresses**.
1. On the **Manage Email Addresses** panel, select the Delete email address (trash can) icon to the right of the email address that you want to remove.
1. In the **Delete Email Address** pop-up window, select **Delete** to confirm.
1. Select **Done** to close the Manage Email Addresses panel.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
