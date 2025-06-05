---
title: "Set up security alerts"
weight: 500
toc: true
type: how-to
product: NGINX One
docs: DOCS-000
---

In this tutorial, you'll learn how to set up Alerts in F5 Distributed Cloud for CVEs or insecure configurations impacting your NGINX fleet. This tutorial is intended for those who operate NGINX and are resposible for keeping their infrastructure and application traffic secure. It assumes you have basic knowledge of:

- Installing Linux programs or running containers

By the end of this tutorial, you'll be able to:

- Access the NGINX One Console in F5 Distributed Cloud
- Connect NGINX instances to the NGINX One Console
- Review Security Risks associated with your NGINX fleet
- Configure Alert Policies in F5 Distributed Cloud

## Background

The NGINX One Console is a service for monitoring and managing NGINX. The Console is in the F5 Distributed Cloud and is included with all NGINX and F5 Distributed Cloud subscriptions. While NGINX is built to be secure and stable, critical vulnerabilities can occasionally emerge – and misconfigurations may leave your application or API exposed to attacks. 

## Before you begin

If you already have accessed F5 Distributed Cloud and have NGINX instances available, you can skip these steps.

### Confirm access to the F5 Distributed Cloud

Confirm an F5 Distributed Cloud tenant has been provisioned for you. Log in to MyF5 and review your subscriptions. You should see within one of your subscriptions "F5 Distributed Cloud Services". This could be in either an NGINX subscription or a Distributed Cloud. If the above does not appear in any of your subscriptions, reach out to either your F5 Account Team or Customer Success Manager.

You or someone in your organization should have received an email from no-reply@cloud.f5.com asking you to update your password when the tenant was created. The account name referenced in the E-Mail in bold is the tenant name.

Navigate to https://INSERT_YOUR_TENANT_NAME.console.ves.volterra.io/ to access the F5 Distributed Cloud. If you have never logged in, select the Forgot Password option. Alternatively,Iif someone within your organization has access, ask them to add you as a user within your tenant with a role providing permissions for NGINX One.

### Install an instance of NGINX

Ensure you have an instance of NGINX Open Source or NGINX Plus installed and available. This guide will provide instructions for connecting an instance installed in a Linux environment (VM or bare metal hardware) where you have command line access. However, we also have instructions for creating a Docker container with NGINX and the NGINX Agent installed and can connect using environment variables.

## Navigate to the NGINX One Console in the F5 Distributed Cloud

If you already have accessed the NGINX One Console, skip this section.

1. Navigate to https://INSERT_YOUR_TENANT_NAME.console.ves.volterra.io/, using the tenant name described earlier.
1. Log in to the F5 Distributed Cloud Console.
   1. If it is your first time logging in, you may ned to reset your password by selecting Forgot Password.
1. Select the NGINX One tile
1. Select Visit Service

## Connect at least one NGINX instance to the NGINX One Console

If you already have connected instances to the NGINX One Console, you can skip this section.

There are multiple ways to connect and NGINX instance depending on the environment. The instructions below walk you through using a `curl` command and installation script. We assume this is the first time you are connecting an instance.

You can also install NGINX Agent from our repositories and configure it manually. Alternatively you can use our official Docker images.

1. On the welcome screen, select Add Instance.
1. Generate a data plane key.
   A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One.
   1. In the Add Instance pane, select Generate Data Plane Key.
      Data plane keys are displayed only once and cannot be retrieved later. Be sure to copy and store this key securely.
      Data plane keys expire after one year. You can change this expiration date later by editing the key.

1. Install NGINX Agent 
   After you enter your data plane key, you’ll see a `curl` command similar to the one below. Copy and run this command on each NGINX instance to install NGINX Agent. Once installed, NGINX Agent typically registers with NGINX One within a few seconds.

NGINX Agent must be able to establish a connection to NGINX One Console’s Agent endpoint (agent.connect.nginx.com). Ensure that any firewall rules you have in place for your NGINX hosts allows network traffic to port 443 for all of the following IPs:

- 3.135.72.139
- 3.133.232.50
- 52.14.85.249

The NGINX One Console monitors all connected NGINX instances for CVEs and insecure configurations. Using the F5 Distributed Cloud's Alert Policies you can receive alerts for these risks in a manner of your choosing; for the purposes of this guide we will show you how to configure E-Mail alerts.

## Configure an active alert policy

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
