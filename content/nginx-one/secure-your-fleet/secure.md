---
title: "Set up security alerts"
weight: 500
toc: true
type: how-to
product: NGINX One
docs: DOCS-000
---

In this tutorial, you'll learn how to set up alerts in F5 Distributed Cloud. Once configured, you'll see the CVEs and insecure configurations associated with your NGINX fleet. This tutorial is intended for those resposible for keeping their NGINX infrastructure and application traffic secure. It assumes you know how to:

- Install Linux programs or run Docker containers

By the end of this tutorial, you'll be able to:

- Access the NGINX One Console in F5 Distributed Cloud
- Connect NGINX instances to the NGINX One Console
- Review Security Risks associated with your NGINX fleet
- Configure Alert Policies in F5 Distributed Cloud

## Background

NGINX One Console is a service to monitor and manage NGINX. It's a part of the F5 Distributed Cloud and is included with all NGINX and F5 Distributed Cloud subscriptions. While NGINX is built to be secure and stable, critical vulnerabilities can occasionally emerge – and misconfigurations may leave your applications or APIs exposed to attacks. 

## Before you begin

If you already have accessed F5 Distributed Cloud and have NGINX instances available, you can skip these steps and start to connect instances to the NGINX One Console..

### Confirm access to the F5 Distributed Cloud

Confirm an F5 Distributed Cloud tenant has been provisioned for you. Log in to MyF5 and review your subscriptions. You should see within one of your subscriptions "Distributed Cloud". This could be in either an NGINX subscription or a Distributed Cloud. If the above does not appear in any of your subscriptions, reach out to either your F5 Account Team or Customer Success Manager.

With access, you or someone in your organization should have an email from no-reply@cloud.f5.com asking you to update your password when the tenant was created. The account name referenced in the E-Mail in bold is the tenant name.

Navigate to https://INSERT_YOUR_TENANT_NAME.console.ves.volterra.io/ to access F5 Distributed Cloud. If you have never logged in, select the **Forgot Password?** option in the log in screen. Alternatively, if someone within your organization has access, ask them to add you as a user within your tenant with a role providing permissions for NGINX One.

### Confirm access to NGINX One Console in the F5 Distributed Cloud

Once you've logged in with your password, you should be able to see and select the NGINX One tile. 

1. Select the **NGINX One** tile<!-- Style note: this is the UI in DC -->
1. Select **Visit Service**

### Install an instance of NGINX

Ensure you have an instance of NGINX Open Source or NGINX Plus installed and available. This guide will provide instructions for connecting an instance installed in a Linux environment (VM or bare metal hardware) where you have command line access.
You can then connect that instance with the help of NGINX Agent and a data plane key.
<!-- possibl3 problem: i see conflict between how proposed docs for Agent 3.0 connect, in the way we configure /etc/nginx-agent/nginx-agent.conf and our N1C docs in Get Started.. Jason's mentioned an env variable.

: Jason, I think you noted about connections using environment variables. -->
<!--  Alternatively, we also have instructions for [Deploying NGINX and NGINX Plus with Docker]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md" >}}) -->

## Connect at least one NGINX instance to the NGINX One Console

If you already have connected instances to the NGINX One Console, you can start to [Configure an active alert policy]({{< ref "/nginx-one/secure-your-fleet.md/#configure-an-active-alert-policy" >}}).
Otherwise, you need to generate a data plane key, add an instance, and install NGINX Agent. We assume this is the first time you are connecting an instance.

### Add an instance

{{< include "/nginx-one/how-to/add-instance.md" >}}

### Generate a data plane key

{{< include "/nginx-one/how-to/generate-data-plane-key.md" >}}

### Install NGINX Agent

{{< include "/nginx-one/how-to/install-nginx-agent.md" >}}

You can also install NGINX Agent from our repositories and configure it manually. Alternatively you can use our official NGINX Docker images, pre-configured with NGINX Agent.

## Configure an active alert policy

The NGINX One Console monitors all connected NGINX instances for CVEs and insecure configurations. Using the F5 Distributed Cloud's Alert Policies you can receive alerts for these risks in a manner of your choosing; for the purposes of this guide we will show you how to configure E-Mail alerts.

The F5 Distributed Cloud generates alerts from all its services including NGINX One. You can configure rules to send those alerts to a receiver of your choice. These instructions walk you through how to configure an email notification when we see new CVEs or detect security issues with your NGINX instances.

This page describes basic steps to set up an email alert. For authoritative documentation, see
[Alerts - Email & SMS](https://docs.cloud.f5.com/docs-v2/shared-configuration/how-tos/alerting/alerts-email-sms).

## Configure alerts to be sent to your email

To configure security-related alerts, follow these steps:

1. Navigate to the F5 Distributed Cloud Console at https://INSERT_YOUR_TENANT_NAME.console.ves.volterra.io. 
1. Find **Audit Logs & Alerts** > **Alerts Management**.
1. Select **Add Alert Receiver**.
1. Configure the **Alert Receivers**
   1. Enter the name of your choice.
   1. (Optional) Specify a label and description.
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

1. Navigate to **Alerts Management > Alert Policies**
1. Select **Add Alert Policy**
   1. Enter the name of your choice
   1. (Optional) Specify a label and description
1. Under Alert Reciever Configuration > Alert Receivers, select the Alert Receiver you just created
1. Under Policy Rules select Configure
1. Select Add Item
1. Under Select Alerts (TBD)
1. Set the Action as Send and select Apply

Now set a second alert related to Common Vulnerabilities and Exposures (CVEs).

1. Select Add Item
1. Under Select Alerts {adding additional Alert type for CVE)
1. Set the Action as Send and select Apply
1. Select **Save and Exit**

You've now set up F5 Distributed Cloud to send you security-related alerts from NGINX One Console.
