---
title: Deploy using the NGINXaaS Console
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/create-deployment/deploy-portal/
type:
- how-to
---

## Overview

This guide explains how to deploy F5 NGINXaaS for Google Cloud (NGINXaaS) using [Google Cloud Console](https://console.cloud.google.com) and the NGINXaaS Console. The deployment process involves creating a new deployment, configuring the deployment, and testing the deployment.

## Before you begin

Before you can deploy NGINXaaS, follow the steps in the [Prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites/" >}}) topic to subscribe to the NGINXaaS for Google Cloud offer in the Google Cloud Marketplace.

### Create a network attachment

NGINXaaS requires a [network attachment](https://cloud.google.com/vpc/docs/about-network-attachments) to connect your consumer Virtual Private Cloud (VPC) network and your NGINXaaS deployment's VPC network.

1. Access the [Google Cloud Console](https://console.cloud.google.com/).
1. Create a consumer VPC network and subnetwork. See [Google's documentation on creating a VPC and subnet](https://cloud.google.com/vpc/docs/create-modify-vpc-networks#console_1) for a step-by-step guide.
   - The region you choose in this step must match the region where your NGINXaaS deployment will be created.
1. Create a Network Attachment in your new subnet that automatically accepts connections. See [Google's documentation on creating a Network Attachment](https://cloud.google.com/vpc/docs/create-manage-network-attachments#console_1) for a step-by-step guide.

## Access the NGINX as a Service Console

Once you have completed the subscription process and created a network attachment, you can access the NGINXaaS Console.

- If you have just completed the subscription process, access the console selecting **Manage on provider**.
- In any other cases, visit [https://console.nginxaas.net/](https://console.nginxaas.net/) to access the NGINXaaS Console.
- Log in to the console with your Google credentials.

## Create or import an NGINX configuration

{{< include "/nginxaas-google/create-or-import-nginx-config.md" >}}

## Create a new deployment

In the NGINXaaS Console,
1. On the left menu, select **Deployments**.
1. Select **Add deployment** to create a new deployment.

   - Enter a **Name**.
   - Add an optional description for your deployment.
   - Enter the ID of the Network Attachment created above and select the **+** icon or select a previously used **Network attachment** from the list.
   - Select an **NGINX configuration** from the list.
   - Select the **NGINX configuration version** from the list.
   - Select **Add** to begin the deployment process.

Your new deployment will appear in the list of deployments. The status of the deployment will be "Pending" while the deployment is being created. Once the deployment is complete, the status will change to "Ready".

## Configure your deployment

1. To open the details of your deployment, select its name from the list of deployments.
   - You can view the details of your deployment, including the status, region, network attachment, NGINX configuration, and more.
1. Select **Edit** to modify the deployment name, description, and NGINX configuration. Select **Update** to save your changes.
1. Select the configuration name to see the configuration details. On the **Configuration details** page, select **Edit** to modify the configuration file.

## Test your deployment

To test connectivity to your NGINXaaS deployment, you will need to set up [Private Service Connect backend](https://cloud.google.com/vpc/docs/private-service-connect-backends).

1. Access the [Google Cloud Console](https://console.cloud.google.com/).
1. Create a public IP address. See [Google's documentation on reserving a static address](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_3) for a step-by-step guide.
1. Create a Network Endpoint Group (NEG). See [Google's documentation on creating a NEG](https://cloud.google.com/vpc/docs/access-apis-managed-services-private-service-connect-backends#console) for a step-by-step guide.
   - For **Target service**, enter your NGINXaaS deployment's Service Attachment.
   - For **Producer port**, enter the port your NGINX server is listening on. If you're using the default NGINX config, enter port `80`.
   - For **Network** and **Subnetwork** select your consumer VPC network and subnet.
1. Create a proxy-only subnet in your consumer VPC. See [Google's documentation on creating a proxy-only subnet](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_1) for a step-by-step guide.
1. Create a regional external proxy Network Load Balancer. See [Google's documentation on configuring the load balancer](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_6) for a step-by-step guide.
   - For **Network**, select your consumer VPC network.
   - For **Backend configuration**, follow [Google's step-by-step guide to add a backend](https://cloud.google.com/vpc/docs/access-apis-managed-services-private-service-connect-backends#console_5).
   - In the **Frontend configuration** section,
      - For **IP address**, select the public IP address created earlier.
      - For **Port number**, enter the same port as your NEG's Producer port, for example, port `80`.
1. Connect to your NGINXaaS deployment using the public IP address created earlier.

## What's next

[Manage your NGINXaaS users]({{< ref "/nginxaas-google/getting-started/manage-users-accounts.md" >}})