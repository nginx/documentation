---
title: Deploy using the NGINXaaS Console
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/deploy/create-deployment/deploy-console/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

## Overview

This guide explains how to deploy F5 NGINXaaS for AWS using the [AWS Management Console](https://console.aws.amazon.com) and the [NGINXaaS Console](http://console.nginxaas.net/). The deployment process involves creating a new deployment, configuring the deployment, and testing the deployment.

## Before you begin

Before you can deploy NGINXaaS, follow the steps in the [Prerequisites]({{< ref "/nginxaas/aws/deploy/prerequisites/" >}}) topic to subscribe to the NGINXaaS for AWS offering in the AWS Marketplace.

## Access the NGINXaaS Console

Once you have completed the subscription process and created a VPC endpoint service, you can access the NGINXaaS Console.

- Visit [https://console.nginxaas.net/](https://console.nginxaas.net/) to access the NGINXaaS Console.
- Log in to the console with your preferred credentials to access the console Overview.

## Create or import an NGINX configuration

{{< include "/nginxaas/create-or-import-nginx-config.md" >}}

## Create a new deployment

Next, create a new NGINXaaS deployment using the NGINXaaS Console:

1. On the left menu, select **Deployments**.
1. Select {{< icon "plus" >}} **Add Deployment**, then select **AWS** to create a new AWS deployment.

   - Enter a **Name**.
   - Add an optional description for your deployment.
   - Change the **NCUs** if needed.
      - The default value of `20` should be adequate for most scenarios.
   - Select a **Region**.
   - Enter an **IPv4 CIDR Block**, or choose the pre-populated example, `10.0.0.0/22`. NGINXaaS only accepts block sizes between `/22` and `/18`. This is used to create the VPC in which your NGINXaaS deployment will exist. For more information on choosing a VPC CIDR block, refer to AWS's [VPC CIDR blocks](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html) documentation.
   - In the **Apply NGINX Configuration** section, select an NGINX configuration [you created earlier](#create-or-import-an-nginx-configuration) from the **Choose Configuration** list.
   - Select a **Configuration Version** from the list.
   - Select **Managed Public Endpoint** or **Private Endpoint** under Service Frontend.
      - Refer to the [Service Frontend]({{< ref "/nginxaas/aws/overview.md#service-frontend" >}}) documentation for more information on these two frontend types.
      - If you selected **Managed Public Endpoint**, select **+ Add ACL Rule** to add an **Access Control List (ACL)** rule. If you don't add any ACL rules, no traffic is allowed to the deployment. For each rule, set:
         - **Protocol**: `Any`, `TCP`, or `UDP`.
         - **Port Range**: Only selectable when you choose a specific protocol.
         - **Source Prefixes**: A required list of IPv4 or IPv6 CIDR blocks to allow traffic from. Use `0.0.0.0/0` to allow traffic from all IPv4 addresses, or `::/0` to allow traffic from all IPv6 addresses.
         - **Description**: An optional description for the rule.
      - If you selected **Private Endpoint**, select **+ Add Entry** to add an entry to the **PrivateLink Connection Allow List**. If you don't add any entries, no PrivateLink connections are allowed. Populate the allow list with either AWS account IDs or VPC endpoint IDs — you can't mix both types in the same allow list:
         - **AWS account IDs**: You can add these now, or at any point later. Connections from an allowed AWS account are automatically accepted.
         - **VPC endpoint IDs**: You typically can't add these yet, because no interface endpoint connections exist until after the deployment is created. Add these entries later from [Configure your deployment](#configure-your-deployment), after you [create an interface endpoint](#create-an-interface-endpoint).
   - Select **Submit** to begin the deployment process.

Your new deployment will appear in the list of deployments. The status of the deployment will be "Pending" while the deployment is being created. Once the deployment is complete, the status will change to "Ready".

## Configure your deployment

In the NGINXaaS Console,

1. To open the details of your deployment, select its name from the list of deployments.
   - You can view the details of your deployment, including the status, region, VPC endpoint service, NGINX configuration, and more.
1. Select **Edit** to modify the deployment description, NCUs.
   - You can also configure monitoring from here. Detailed instructions can be found in [Enable Monitoring]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
   - You can also add, remove, or update the Service Frontend ACL rules (Managed Public Endpoint) or PrivateLink Connection Allow List entries (Private Endpoint) from here. This is how you add a VPC endpoint ID to the allow list after you [create an interface endpoint](#create-an-interface-endpoint).
1. Select **Update** to save your changes.
1. Select the Configuration tab to view the current NGINX configuration associated with the deployment.
1. Select **Update Configuration** to change the NGINX configuration associated with the deployment.
1. To modify the contents of the NGINX configuration, see [Update an NGINX Configuration]({{< ref "/nginxaas/aws/deploy/nginx-configuration/nginx-configuration-console.md#update-an-nginx-configuration" >}}).

## Set up connectivity

If you selected **Private Endpoint** as the service frontend type, complete the following steps to allow client access. If you selected **Managed Public Endpoint**, skip this section.

### Internal traffic

To let clients in your VPC connect directly to your deployment, create an interface VPC endpoint that targets your deployment's PrivateLink Endpoint Service Name:

1. After your deployment is created, open its Details tab and find the **PrivateLink Endpoint Service Name** under **Cloud Settings** > **Service Frontend**, for example `com.amazonaws.vpce.us-east-1.vpce-svc-0c0d939ca9a7ce020`.
1. Create an interface VPC endpoint that targets this Service Name. For step-by-step instructions, see AWS's [Connect to an endpoint service as the service consumer](https://docs.aws.amazon.com/vpc/latest/privatelink/create-endpoint-service.html#connect-to-endpoint-service) documentation. When prompted for **Service name**, enter the PrivateLink Endpoint Service Name from the previous step.
1. Note the new interface endpoint's **VPC Endpoint Id**, for example `vpce-0123456789abcdef0`, shown in the AWS VPC console **Endpoints** list.
1. If your deployment's **PrivateLink Connection Allow List** uses VPC endpoint IDs, go to [Configure your deployment](#configure-your-deployment), select **Edit**, and add the VPC endpoint ID to the allow list. NGINXaaS accepts the connection only when the endpoint ID is added.

{{< call-out class="note" >}}
The allow list can contain either AWS account IDs or VPC endpoint IDs, but not a mix of both. If your allow list uses AWS account IDs, you can skip the previous step, provided the AWS account ID initiating this connection is already in the allow list. Connections from an allowed AWS account are automatically accepted.
{{< /call-out >}}

### Upstream connectivity

To let your NGINXaaS deployment reach applications in your upstream network, create a VPC peering connection between your upstream VPC and the deployment's VPC:

1. Open your deployment's Details tab and note its **AWS Account ID** and **VPC ID**.
1. From your upstream AWS account, create a VPC peering connection request targeting the deployment's AWS Account ID and VPC ID. For step-by-step instructions, see AWS's [Create a VPC peering connection](https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html) documentation.
1. Note the resulting **VPC Peering Connection ID**, for example `pcx-0123456789abcdef0`, shown in the AWS VPC console **Peering Connections** list.
1. Go to [Configure your deployment](#configure-your-deployment), select **Edit**, go to **Cloud Details** > **Upstream Network**, select **+ Add Entry**, and add the VPC Peering Connection ID. Select **Update**. NGINXaaS accepts the peering connection request.
1. Update your upstream VPC's route tables and security groups to allow traffic to and from the deployment's VPC CIDR. See AWS's [Update your route tables for a VPC peering connection](https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-routing.html) and [Update your security groups to reference peer security groups](https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-security-groups.html) documentation.

{{< call-out class="caution" title="CIDR overlap" >}}
Your upstream VPC CIDRs must not overlap with the deployment's VPC CIDRs, or the CIDRs of other peered upstream VPCs. If CIDRs overlap, VPC peering will fail. See [Upstream network]({{< ref "/nginxaas/aws/overview.md#upstream-network" >}}) for more information.
{{< /call-out >}}

## Test your deployment

How you test your deployment depends on the service frontend type you selected:

- **Managed Public Endpoint**: connect to the **Service Endpoint** URL shown on your deployment's Details tab, under **Cloud Settings** > **Service Frontend**, for example `http://speak-lp-9e9707dede.us-east-1.depl.naas-dev.nginxlab.net`.
- **Private Endpoint**: connect through the interface VPC endpoint you created in [Internal traffic](#internal-traffic). Because the endpoint is only reachable from within your VPC, you need a resource inside that VPC to test the connection:
   1. Launch an EC2 instance in the same VPC and subnet (or a subnet that can route to it) as your interface VPC endpoint.
   1. Open the interface endpoint's details in the AWS VPC console and note its **DNS names**.
   1. From the EC2 instance, connect to your NGINX configuration's listening port using one of the endpoint's DNS names, for example `curl https://vpce-0123456789abcdef0-abc12345.vpce-svc-0c0d939ca9a7ce020.us-east-1.vpce.amazonaws.com`.

## What's next

- [Monitor your deployment]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
- [Manage certificates in AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md" >}})
