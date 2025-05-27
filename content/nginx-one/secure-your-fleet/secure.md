---
title: "Set up security alerts"
weight: 500
toc: true
type: how-to
product: NGINX One
docs: DOCS-000
---

The F5 Distributed Cloud generates alerts from all its services including NGINX One. You can configure rules to send those alerts to a receiver of your choice. These instructions walk you through how to configure an email notification when we see new CVEs or detect security issues with your NGINX instances.

This page describes basic steps to set up an email alert. For authoritative documentation, see
[Alerts - Email & SMS](https://flatrender.tora.reviews/docs-v2/shared-configuration/how-tos/alerting/alerts-email-sms).

## Configure alerts to be sent to your email

To configure security-related alerts, follow these steps:

1. Navigate to the F5 Distributed Cloud Console at https://INSERT_YOUR_TENANT_NAME.console.ves.volterra.io. 
1. Find **Audit Logs & Alerts** > **Alerts Management**.
1. Select **Add Alert Receiver**.
1. Configure the **Alert Receivers**
   1. Enter the name of your choice
   1. (Optional) Specify a label and description
1. Under **Receiver**, select Email and enter your email address.
1. Select **Save and Exit**.
1. Your Email receiver should now appear on the list of Alert Receivers.
1. Under the Actions column, select Verify Email.
1. Select **Send email** to confirm.
1. You should receive a verification code in the email provided. Copy that code.
1. Under the Actions column, select **Enter verification code**.
1. Paste the code and select **Verify receiver**.

## Configure Alert Policy

Next, configure the policy that identifies when you'll get an alert. 

1. Navigate to **Alerts Management > Alert Policies**.
1. Select **Add Alert Policy**.
   1. Enter the name of your choice
   1. (Optional) Specify a label and description
1. Under Alert Reciever Configuration > Alert Receivers, select the Alert Receiver you just created
1. Under Policy Rules select Configure.
1. Select Add Item.
1. Under Select Alerts (TBD)
1. Set the Action as Send and select Apply

Now set a second alert related to Common Vulnerabilities and Exposures (CVEs).

1. Select Add Item.
1. Under Select Alerts {adding additional Alert type for CVE).
1. Set the Action as Send and select Apply.
1. Select **Save and Exit**.
