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

## Access the NGINX as a Service Console

Once you have completed the subscription process, you can access the NGINXaas Console:

- If you have just completed the subscription process, access the console selecting **Manage on provider**.
- In any other cases, visit [https://console.nginxaas.net/](https://console.nginxaas.net/) to access the NGINXaaS Console.
- Log in to the console with your Google credentials.

## Create or import an NGINX configuration

{{< include "/nginxaas-google/create-or-import-nginx-config.md" >}}

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

[Manage your NGINXaaS users]({{< ref "/nginxaas-google/getting-started/manage-users-accounts.md" >}})