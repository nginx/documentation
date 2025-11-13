---
title: "Set up security alerts"
weight: 500
toc: true
nd-content-type: how-to
nd-product: ONE
---

With this page, you'll learn how to set up alerts in F5 Distributed Cloud. Once configured, you'll see the CVEs and insecure configurations associated with your NGINX fleet. These instructions are intended for those responsible for keeping their NGINX infrastructure and application traffic secure. It assumes you know how to:

- Install Linux programs or run Docker containers

By the end of this tutorial, you'll be able to:

- Access the NGINX One Console in F5 Distributed Cloud
- Connect NGINX instances to the NGINX One Console
- Review Security Risks associated with your NGINX fleet
- Configure Alert Policies in F5 Distributed Cloud

## Background

NGINX One Console is a service to monitor and manage NGINX. It's a part of the F5 Distributed Cloud and is included with all NGINX and F5 Distributed Cloud subscriptions. While NGINX is built to be secure and stable, critical vulnerabilities can occasionally emerge – and misconfigurations may leave your applications or APIs exposed to attacks. 

## Before you begin

If you already have accessed F5 Distributed Cloud and have NGINX instances available, you can skip these steps and start to connect instances to the NGINX One Console.

### Confirm access to the F5 Distributed Cloud

{{< include "/nginx-one/cloud-access.md" >}}

### Confirm access to NGINX One Console in the F5 Distributed Cloud

Once you've logged in with your password, you should be able to see and select the NGINX One tile. 

1. Select the **NGINX One** tile
1. Select **Visit Service**

### Install an instance of NGINX

Ensure you have an instance of [NGINX Open Source or NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/" >}}) installed and available. This guide provides instructions for connecting an instance installed in a Linux environment (VM or bare metal hardware) where you have command line access.
Alternatively, we also have instructions for [Deploying NGINX and NGINX Plus with Docker]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md" >}}) with NGINX and the NGINX Agent installed. That deployment can connect with environment variables.

## Connect at least one NGINX instance to the NGINX One Console

If you already have connected instances to the NGINX One Console, you can start to [Configure an active alert policy]({{< ref "/nginx-one/secure-your-fleet/set-up-security-alerts.md#configure-an-active-alert-policy" >}}).
Otherwise, you need to add an instance, generate a data plane key, and install NGINX Agent. We assume this is the first time you are connecting an instance.

### Add an instance

{{< include "/nginx-one/how-to/add-instance.md" >}}

### Generate a data plane key

{{< include "/nginx-one/how-to/generate-data-plane-key.md" >}}

### Install NGINX Agent

{{< include "/nginx-one/how-to/install-nginx-agent.md" >}}

You can also install NGINX Agent from our repositories and configure it manually. Alternatively you can use our official NGINX Docker images, pre-configured with NGINX Agent.

## Configure an active alert policy

The NGINX One Console monitors all connected NGINX instances for CVEs and insecure configurations. Using the F5 Distributed Cloud's Alert Policies, you can receive alerts for these risks in a manner of your choosing; for the purposes of this guide, we show you how to configure email alerts.

The F5 Distributed Cloud generates alerts from all its services including NGINX One Console. You can configure rules to send those alerts to a receiver of your choice. These instructions walk you through how to configure an email notification when we see new CVEs or detect security issues with your NGINX instances.

This page describes basic steps to set up an email alert. For authoritative documentation, see
[Alerts - Email & SMS](https://docs.cloud.f5.com/docs-v2/shared-configuration/how-tos/alerting/alerts-email-sms).

## Configure alerts to be sent to your email

To configure security-related alerts, follow these steps:

1. Go to the F5 Distributed Cloud Console at https://INSERT_YOUR_TENANT_NAME.console.ves.volterra.io. 
1. Select **Audit Logs & Alerts**
1. Select **Alerts Management > Alert Receivers**
1. Select **Add Alert Receiver**
   1. Enter the name of your choice.
   1. (Optional) Specify a label and description.
1. Under **Receiver**, select **Email** and enter your email address.
1. Select **Add Alert Receiver**
   Your alert receiver should now appear on the list of Alert Receivers.
1. Select the **Actions** ellipsis (...) for your receiver. Select **Verify Email**.
1. Select **Send email** to confirm.
1. You should receive a verification code in the email provided. Copy that code.
1. Under the **Actions** column, select **Enter verification code**.
1. Paste the code and select **Verify receiver**.

## Configure Alert Policy

Next, configure the policy that identifies when you'll get an alert. You'll need to reference available alerts in our [NGINX One Console Glossary]({{< ref "/nginx-one/glossary.md#nginx-alerts/" >}}). Relevant security alerts include:

- SecurityRecommendationNGINX
- HighCVENGINX
- MediumCVENGINX
- LowCVENGINX

1. Go to **Alerts Management > Alert Policies**.
1. Select **Add Alert Policy**.
   1. Enter the name of your choice. You're limited to lower-case characters, numbers, and dashes.
   1. (Optional) Specify a label and description.
1. Under **Alert Reciever Configuration > Alert Receivers,** select the **Alert Receiver** you just created.
1. Under **Policy Rules** select **Configure**.
1. In the **Policy Rules** screen that appears, select **Add Item**.
1. In the **Route** window that appears, review the **Select Alerts** drop-down.
1. Under **Select Alerts** select a filter. Now select **Matching Custom Criteria > Alertname > Configure**. In the screen that appears, use **Exact Match** and copy/paste an alert name from the [NGINX One Console Glossary]({{< ref "/nginx-one/glossary.md#nginx-alerts" >}}).
1. Select **Apply** to exit the **Alertname** window.
1. Select **Apply** to exit the **Route** window.
1. Select **Apply** to exit the **Policy Rules** window.
1. You can now select the **Add Alert policy** button.
1. Set the **Action as Send** and select **Apply**.

## Create more alert policies  

Repeat the process described in [Configure Alert Policy](#configure-alert-policy) section. Repeat again if and as needed for all of the alerts in the 
[NGINX One Console Glossary]({{< ref "/nginx-one/glossary.md#nginx-alerts/" >}}).

## Activate the alert policy

Now to make sure your new policy works, add your new policies to the list of **Active Alert Policies**. To do so:

1. Select **Alerts Management > Active Alert Policies**
1. Select **Select Active Alert Policies**. 
1. In the **Select Active Alert Policies** window, select **Add Item**
1. In the drop-down box that appears, select the Alert Policy that you created. 
1. Select the **Add Select Active Alert Policies** button.	
1. Select **Add Item**

You've now set up F5 Distributed Cloud to send you alerts from NGINX One Console, to your email address. When the alert policy identifies an alert, it sends you an email from **alerts@cloud.f5.com**.

## Known issues

When you set up an email alert for a problem, you'll see the alert in:

- The F5 Distributed Cloud Console, under **Notifications > Alerts** in **Audit Logs & Alerts**
- An email with a subject like **<number> Alert Requires Action**

You may also get a follow-up email with the subject **Alert Resolved**.

{{< call-out "important" >}}

Sometimes an **Alert Resolved** email is sent even though the issue is still active.
To check the current status, go to the NGINX One Console.

For CVEs, the trusted source is:

- **NGINX One Console > Manage > Instances > `Instance hostname`**

Open the instance dashboard to see the latest list of CVEs. Use the Console, not email, to confirm whether an issue is resolved.

{{< /call-out >}}

## Summary

In this tutorial, you learned how to:

- Access the NGINX One Console
- Connect an NGINX instance
- Configure and activate an alert

You will now receive an email any time the F5 Distributed Cloud sees one or more of the alerts that you configued. 

## Next steps

Now that you have NGINX instances connected to the NGINX One Console, consider reviewing our [use cases]({{< ref "/nginx-one/" >}}) to see how you can easily manage your NGINX instances, draft new configurations, and more.
Additionally, you can review how to add additional Alert Receivers such as [SMS](https://docs.cloud.f5.com/docs-v2/shared-configuration/how-tos/alerting/alerts-email-sms), [Slack](https://docs.cloud.f5.com/docs-v2/shared-configuration/how-tos/alerting/alerts-slack), [PagerDuty](https://docs.cloud.f5.com/docs-v2/shared-configuration/how-tos/alerting/alerts-pagerduty), or with a [webhook](https://docs.cloud.f5.com/docs-v2/shared-configuration/how-tos/alerting/alerts-webhook).
