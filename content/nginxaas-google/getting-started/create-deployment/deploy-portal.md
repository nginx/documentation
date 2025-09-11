---
title: Deploy using the portal
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/create-deployment/deploy-portal/
type:
- how-to
---

## Overview

This guide explains how to deploy F5 NGINXaaS for Google Cloud (NGINXaaS) using [Google Cloud Console](https://console.cloud.google.com). The deployment process involves creating a new deployment, configuring the deployment, and testing the deployment.

## Before you begin

{{< include "/nginxaas-google/subscribe.md" >}}

## Access the NGINX as a Service portal

Once you have completed the subscription process, you can access the NGINX as a Service portal:

- If you have just completed the subscription process, access the portal selecting **Manage on provider** 

- If you have already subscribed to the offer, access the portal visiting [https://console.nginxaas.net/](https://console.nginxaas.net/).
   
- Log in to the NGINXaaS console with your Google credentials.

## Create or import an NGINX configuration

1. On the left menu, select **Configurations**.
1. Select **Add Configuration** to add a new NGINX configuration.
1. You can either create a new configuration or copy an existing configuration:
   
   - Select **New configuration** to create a new config (using the default template or a blank file).
      - Provide a name for your configuration and an optional description.
      - Change the configuration path if needed.
      - Select **Next**.
   - Select **Copy existing configuration** to use one of the existing configuration files in your account as template.
      - Provide a name for your configuration and an optional description.
      - Change the configuration path if needed.
      - Use the **Choose configuration to copy** list to select the configuration file you want to copy.
      - Use the **Choose configuration version to copy** list to select the version of the configuration file you want to copy.
      - Select **Next**.

1. Modify the configuration file as needed and select **Save**.
   - You can import certificates using the **Add file** option.
   - The portal will validate the configuration file and display any errors or warnings.

## Create a new deployment

1. On the left menu, select **Deployments**.
1. Select **Add deployment** to create a new deployment.

   - Select a previously used **Network attachment** from the list or select the **+** icon to add a network attachment (See the Google Cloud documentation for more information about [network attachments](https://cloud.google.com/vpc/docs/create-manage-network-attachments)).
   - Add an optional description for your deployment.
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

< TBD >

## What's next

< TBD >