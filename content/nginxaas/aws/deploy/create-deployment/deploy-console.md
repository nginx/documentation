---
title: Deploy using the NGINXaaS Console
description: "Create, configure, and connect an F5 NGINXaaS for AWS deployment using the NGINXaaS Console."
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/deploy/create-deployment/deploy-console/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
f5-keywords: "NGINXaaS for AWS, create deployment, NGINXaaS Console, NCU, service frontend, PrivateLink, VPC peering"
f5-summary: >
  Learn how to create an F5 NGINXaaS for AWS deployment using the NGINXaaS Console.
  This guide covers configuring the deployment, setting up service frontend connectivity, and testing the deployment once it's ready.
f5-audience: operator
---

## Overview

This guide explains how to deploy F5 NGINXaaS for AWS using the [AWS Management Console](https://console.aws.amazon.com) and the [NGINXaaS Console](https://console.nginxaas.net/). The deployment process involves creating a new deployment, configuring the deployment, and testing the deployment.

## Before you begin

Before you can deploy NGINXaaS, follow the steps in the [Prerequisites]({{< ref "/nginxaas/aws/deploy/prerequisites/" >}}) topic to subscribe to the NGINXaaS for AWS offering in the AWS Marketplace.

## Access the NGINXaaS Console

{{< include "/nginxaas/access-console.md" >}}

## Create or import an NGINX configuration

{{< include "/nginxaas/create-or-import-nginx-config.md" >}}

## Create a new deployment

Create a new NGINXaaS deployment using the NGINXaaS Console:

1. On the left menu, select **Deployments**.
1. Select {{< icon "plus" >}} **Add Deployment**, then select **AWS** to create a new AWS deployment.

   - Enter a unique **Name**.
   - Add an optional description for your deployment.
   - Change the [**NCUs**]({{< ref "/nginxaas/aws/overview.md#nginx-capacity-unit-ncu" >}}) if needed.
      - The default value of `20` works for most common scenarios.
   - Select the AWS **Region** where you want the NGINXaaS deployment to be created.
   - Enter an **IPv4 CIDR Block** for the deployment's private network IP space.
      - NGINXaaS only accepts block sizes between `/22` and `/18`.
      - For more information on choosing a VPC CIDR block, refer to AWS's [VPC CIDR blocks](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html) documentation.

   {{< call-out class="caution" >}}
   NGINXaaS uses VPC peering for network connectivity to your upstream services. VPC peering requires all peered VPCs to have non-overlapping CIDR blocks so unique routing rules can be defined for each IP range.
   When selecting an IPv4 CIDR block for your AWS deployment, make sure the range doesn't match or overlap with any VPCs you plan to peer to the deployment's network.
   {{< /call-out >}}

   - In the **Apply NGINX Configuration** section, select an NGINX configuration [you created earlier](#create-or-import-an-nginx-configuration) from the **Choose Configuration** list.
   - Select a **Configuration Version** from the list.
   - Select **Managed Public Endpoint** or **Private Endpoint** under Service Frontend.
      - Refer to the [Service Frontend]({{< ref "/nginxaas/aws/overview.md#service-frontend" >}}) documentation for more information on these two frontend types.
   - If you selected **Managed Public Endpoint**, select **+ Add ACL Rule** to add an **Access Control List (ACL)** rule. If you don't add any ACL rules, no traffic is allowed to the deployment. For each rule, set:
      - **Protocol**: `Any`, `TCP`, or `UDP`.
      - **Port Range**: Only selectable when you choose a specific protocol.
      - **Source Prefixes**: A required list of IPv4 or IPv6 CIDR blocks to allow traffic from. Use `0.0.0.0/0` to allow traffic from all IPv4 addresses, and `::/0` to allow traffic from all IPv6 addresses.
      - **Description**: An optional description for the rule.
   - If you selected **Private Endpoint**, select **+ Add Entry** to add an entry to the **PrivateLink Connection Allow List**. If you don't add any entries, no PrivateLink connections are allowed.
      - Populate the allow list with either AWS account IDs or VPC endpoint IDs -- you can't mix both types in the same allow list:
      - **AWS account IDs**: You can add these now, or at any point later. Connections from an allowed AWS account are automatically accepted.
      - **VPC endpoint IDs**: After you create the deployment and its [interface VPC endpoint](#private-endpoint-traffic), add these entries to this allow list. This provides a stricter way to accept secure PrivateLink connections than trusting entire AWS account IDs.

1. Select **Add Deployment** to create the deployment.

Your new deployment will appear in the list of deployments. The status of the deployment is "Pending" while the deployment is being created. Once the deployment is complete, the status changes to "Ready".

## Edit your deployment

In the NGINXaaS Console,

1. Open the details of your deployment by selecting its name from the list of deployments.
   - You can view the details of your deployment, including the status, region, VPC endpoint service, NGINX configuration, and more.
1. Select **Edit** to modify the deployment.
   - From this form, you can edit the description or reserved [NCUs]({{< ref "/nginxaas/aws/overview.md#nginx-capacity-unit-ncu" >}}).
   - You can apply a different NGINX configuration or configuration version.
   - Configure upstream connectivity by adding entries to the **VPC Peering Connections** list as detailed further in [Upstream connectivity](#upstream-connectivity).
   - You can also modify the **Service Frontend** configuration, including frontend type, ACL rules (Managed Public Endpoint) or PrivateLink Connection Allow List entries (Private Endpoint) from here.
      - This is where you can add VPC endpoint IDs to the allow list after you [create an interface VPC endpoint](#private-endpoint-traffic).
   - You can configure monitoring here. For detailed instructions, see [Enable Monitoring]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
1. Select **Save Changes**.

To modify the contents of the NGINX configuration, see [Update an NGINX Configuration]({{< ref "/nginxaas/aws/deploy/nginx-configuration/nginx-configuration-console.md#update-an-nginx-configuration" >}}).

## Set up connectivity

### Private Endpoint traffic

If you selected **Private Endpoint** as the service frontend type, complete the following steps to allow client access. If you selected **Managed Public Endpoint**, skip this section.

To let clients in your AWS VPC connect directly to your deployment, create an interface VPC endpoint that targets your deployment's PrivateLink Endpoint Service Name:

{{< call-out class="caution" >}}
NGINXaaS doesn't currently support cross-region PrivateLink connections. You can only create an interface VPC endpoint in the same region as your deployment.
{{< /call-out >}}

1. After your deployment is created, open its Details tab and find the **PrivateLink Endpoint Service Name** under **Cloud Settings** > **Service Frontend**, for example `com.amazonaws.vpce.us-east-1.vpce-svc-0c0d939ca9a7ce020`.
1. Create an interface VPC endpoint that targets this Service Name. For step-by-step instructions, see AWS's [Connect to an endpoint service as the service consumer](https://docs.aws.amazon.com/vpc/latest/privatelink/create-endpoint-service.html#connect-to-endpoint-service) documentation. When prompted for **Service name**, enter the PrivateLink Endpoint Service Name from the previous step.
1. Note the new interface endpoint's **VPC Endpoint Id**, for example `vpce-0123456789abcdef0`, shown in the AWS VPC console **Endpoints** list.
1. Ensure your deployment's **PrivateLink Connection Allow List** includes the AWS account ID or VPC endpoint ID to accept the PrivateLink connection.
   - To add an entry to the allow list, go to your deployment's Details tab, select **Edit**, and add the VPC endpoint ID or AWS account ID to the allow list.

{{< call-out class="important" >}}
The allow list can contain either AWS account IDs or VPC endpoint IDs, but not both. If it uses AWS account IDs, NGINXaaS automatically accepts every PrivateLink connection from those accounts. If it uses VPC endpoint IDs, NGINXaaS accepts each endpoint's PrivateLink connection only after you add its ID to the list.

Removing an entry disconnects that PrivateLink connection from the deployment.
{{< /call-out >}}

### Upstream connectivity

To let your NGINXaaS deployment reach applications in your upstream network, create a VPC peering connection between your upstream VPC and the deployment's VPC:

{{< call-out class="caution" >}}
NGINXaaS doesn't currently support cross-region VPC peering connections. A peering connection from any region other than the deployment's region will be rejected.
{{< /call-out >}}

1. Open your deployment's Details tab and note its **AWS Account ID** and **VPC ID**.
1. From your upstream AWS account, create a VPC peering connection request targeting the deployment's AWS Account ID and VPC ID. For step-by-step instructions, see AWS's [Create a VPC peering connection](https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html) documentation.
1. Note the resulting **VPC Peering Connection ID**, for example `pcx-0123456789abcdef0`, shown in the AWS VPC console **Peering Connections** list.
1. On your deployment's Details tab, select **Edit**, go to **Cloud Details** > **Upstream Network**, select **+ Add Entry**, and add the VPC Peering Connection ID.
1. Select **Save Changes** to allow NGINXaaS to accept the peering connection request.
1. You must update your upstream VPC's route tables, network ACLs, and security groups to allow traffic to and from the deployment's VPC CIDRs.
   - Open your deployment's Details tab and note its **IPv4 CIDR** and **IPv6 CIDR** (if you plan to use IPv6).
   - See AWS's [Update your route tables for a VPC peering connection](https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-routing.html) and [Configure security group rules for your VPC](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-security-group-rules.html) documentation.

{{< call-out class="caution" title="CIDR overlap" >}}
Your upstream VPC CIDRs must not overlap with the deployment's VPC CIDRs, or the CIDRs of other peered upstream VPCs. If CIDRs overlap, VPC peering will fail. See [Upstream network]({{< ref "/nginxaas/aws/overview.md#upstream-network" >}}) for more information.
{{< /call-out >}}

## Test your deployment

How you test your deployment depends on the service frontend type you selected:

- **Managed Public Endpoint**: connect to the **Service Endpoint** URL shown on your deployment's Details tab, under **Cloud Settings** > **Service Frontend**, for example `http://speak-lp-9e9707dede.us-east-1.depl.nginxaas.net`.
- **Private Endpoint**: connect through the interface VPC endpoint you created in [Private Endpoint traffic](#private-endpoint-traffic). Because the endpoint is only reachable from within your VPC, you need a resource inside that VPC to test the connection:
   1. Launch an EC2 instance in the same VPC and subnet (or a subnet that can route to it) as your interface VPC endpoint.
   1. Open the interface endpoint's details in the AWS VPC console and note its **DNS names**.
   1. From the EC2 instance, connect to your NGINX configuration's listening port using one of the endpoint's DNS names, for example `curl https://vpce-0123456789abcdef0-abc12345.vpce-svc-0c0d939ca9a7ce020.us-east-1.vpce.amazonaws.com`.

## What's next

- [Monitor your deployment]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
- [Manage certificates in AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md" >}})
