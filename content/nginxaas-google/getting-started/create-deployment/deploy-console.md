---
title: Deploy using the NGINXaaS Console
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/create-deployment/deploy-console/
type:
- how-to
---

## Overview

This guide explains how to deploy F5 NGINXaaS for Google Cloud (NGINXaaS) using [Google Cloud Console](https://console.cloud.google.com) and the NGINXaaS Console. The deployment process involves creating a new deployment, configuring the deployment, and testing the deployment.

## Before you begin

Before you can deploy NGINXaaS, follow the steps in the [Prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites/" >}}) topic to subscribe to the NGINXaaS for Google Cloud offering in the Google Cloud Marketplace.

### Create a network attachment

NGINXaaS requires a [network attachment](https://cloud.google.com/vpc/docs/about-network-attachments) to connect your consumer Virtual Private Cloud (VPC) network and your NGINXaaS deployment's VPC network.

1. Access the [Google Cloud Console](https://console.cloud.google.com/).
1. Create a consumer VPC network and subnetwork. See [Google's documentation on creating a VPC and subnet](https://cloud.google.com/vpc/docs/create-modify-vpc-networks#console_1) for a step-by-step guide.
   - The region you choose in this step must match the region where your NGINXaaS deployment will be created.
1. Create a network attachment in your new subnet that automatically accepts connections. See [Google's documentation on creating a network attachment](https://cloud.google.com/vpc/docs/create-manage-network-attachments#console_1) for a step-by-step guide.
1. Make a note of the network attachment ID. You will need it in the next steps to create your NGINXaaS deployment.

   {{< call-out "caution" >}}NGINXaaS for Google Cloud currently supports the following regions:

   {{< table "table" >}}
   |NGINXaaS Geography | Google Cloud Regions |
   |-----------|---------|
   | US  | us-west1, us-east1, us-central1 |
   | EU    | europe-west2, europe-west1 |
   {{< /table >}}

   {{< /call-out >}}

## Access the NGINXaaS Console

Once you have completed the subscription process and created a network attachment, you can access the NGINXaaS Console.

- Visit [https://console.nginxaas.net/](https://console.nginxaas.net/) to access the NGINXaaS Console.
- Log in to the console with your Google credentials.
- Select the appropriate Geography to work in, based on the region your network attachment was created in.

## Create or import an NGINX configuration

{{< include "/nginxaas-google/create-or-import-nginx-config.md" >}}

## Create a new deployment

Next, create a new NGINXaaS deployment using the NGINXaaS Console:

1. On the left menu, select **Deployments**.
1. Select {{< icon "plus" >}} **Add Deployment** to create a new deployment.

   - Enter a **Name**.
   - Add an optional description for your deployment.
   - Change the **NCU Capacity** if needed.
      - The default value of `20 NCU` should be adequate for most scenarios.
      - This value must be a multiple of `10`.
   - In the Cloud Details section, enter the network attachment ID that [you created earlier](#create-a-network-attachment) or select it in the  **Network attachment** list.
      - The network attachment ID is formatted like the following example: `projects/my-google-project/regions/us-east1/networkAttachments/my-network-attachment`.
   - In the Apply Configuration section, select an NGINX configuration [you created earlier](#create-or-import-an-nginx-configuration) from the **Choose Configuration** list.
   - Select a **Configuration Version** from the list.
   - Select **Submit** to begin the deployment process.

Your new deployment will appear in the list of deployments. The status of the deployment will be "Pending" while the deployment is being created. Once the deployment is complete, the status will change to "Ready".

## Configure your deployment

In the NGINXaaS Console,

1. To open the details of your deployment, select its name from the list of deployments.
   - You can view the details of your deployment, including the status, region, network attachment, NGINX configuration, and more.
1. Select **Edit** to modify the deployment description, and NCU Capacity.
   - You can also configure monitoring from here. Detailed instructions can be found in [Enable Monitoring]({{< ref "/nginxaas-google/monitoring/enable-monitoring.md" >}})
1. Select **Update** to save your changes.
1. Select the Configuration tab to view the current NGINX configuration associated with the deployment.
1. Select **Update Configuration** to change the NGINX configuration associated with the deployment.
1. To modify the contents of the NGINX configuration, see [Update an NGINX Configuration]({{< ref "/nginxaas-google/getting-started/nginx-configuration/nginx-configuration-console.md#update-an-nginx-configuration" >}}).

## Set up connectivity to your deployment

To set up connectivity to your NGINXaaS deployment, you will need to configure a [Private Service Connect backend](https://cloud.google.com/vpc/docs/private-service-connect-backends).

1. Access the [Google Cloud Console](https://console.cloud.google.com/).
1. Create a public IP address. See [Google's documentation on reserving a static address](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_3) for a step-by-step guide.
1. Create a Network Endpoint Group (NEG). See [Google's documentation on creating a NEG](https://cloud.google.com/vpc/docs/access-apis-managed-services-private-service-connect-backends#console) for a step-by-step guide.
   - For **Target service**, enter your NGINXaaS deployment's Service Attachment, which is visible on the `Deployment Details` section for your deployment.
   - For **Producer port**, enter the port your NGINX server is listening on. If you're using the default NGINX config, enter port `80`.
   - For **Network** and **Subnetwork** select your consumer VPC network and subnet.
1. Create a proxy-only subnet in your consumer VPC. See [Google's documentation on creating a proxy-only subnet](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_1) for a step-by-step guide.
1. Create a regional external proxy Network Load Balancer. See [Google's documentation on configuring the load balancer](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_6) for a step-by-step guide.
   - For **Network**, select your consumer VPC network.
   - For **Backend configuration**, follow [Google's step-by-step guide to add a backend](https://cloud.google.com/vpc/docs/access-apis-managed-services-private-service-connect-backends#console_5).
   - In the **Frontend configuration** section,
      - For **IP address**, select the public IP address created earlier.
      - For **Port number**, enter the same port as your NEG's Producer port, for example, port `80`.

## Test your deployment

1. To test your deployment, go to the IP address created in [Set up connectivity to your deployment]({{< ref "/nginxaas-google/getting-started/create-deployment/deploy-console.md#set-up-connectivity-to-your-deployment" >}}) using your favorite web browser.

## What's next

[Manage your NGINXaaS users]({{< ref "/nginxaas-google/getting-started/manage-users-accounts.md" >}})