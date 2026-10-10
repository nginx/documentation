---
title: Connect upstream applications using the AWS CLI
description: "Use the AWS CLI to create a VPC peering connection so an F5 Application Delivery Service for AWS deployment can reach applications in your upstream VPC."
weight: 120
toc: true
f5-docs: DOCS-000
f5-content-type: how-to
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 ADS for AWS, VPC peering, AWS CLI, upstream connectivity, upstream network, route table"
f5-summary: >
  Learn how to use the AWS CLI to create a VPC peering connection between your upstream VPC and an F5 Application Delivery Service for AWS
  deployment, and configure routing so the deployment can reach your upstream applications.
f5-audience: operator
---

This guide shows how to use the AWS CLI to let an F5 Application Delivery Service for AWS deployment reach applications in your upstream network. You create an upstream virtual private cloud (VPC) and request a VPC peering connection to your deployment's VPC. Then you accept the connection in F5 ADS and update routing and security rules so traffic can flow between the two VPCs.

For more background on VPC peering, see AWS's [Create a VPC peering connection](https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html) documentation.

## Before you begin

- The [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed and configured with credentials that can manage VPC resources in your upstream AWS account.
- An F5 ADS deployment. See [Create a new deployment]({{< ref "/f5ads/aws/deploy/create-deployment/deploy-console.md#create-a-new-deployment" >}}).
- Your deployment's **AWS Account ID**, **VPC ID**, **IPv4 CIDR**, and **IPv6 CIDR** (if you plan to use IPv6), found on the deployment's Details tab.

{{< call-out class="caution" >}}
F5 ADS doesn't currently support cross-region VPC peering connections. A peering connection from any region other than the deployment's region will be rejected.
{{< /call-out >}}

## Create your upstream VPC

If you already have an upstream VPC that hosts the applications your deployment needs to reach, skip to [Request a VPC peering connection](#request-a-vpc-peering-connection) and use its VPC ID instead.

{{< call-out class="caution" title="CIDR overlap" >}}
Your upstream VPC CIDR block must not overlap with the deployment's VPC CIDRs, or the CIDRs of other peered upstream VPCs. If CIDRs overlap, VPC peering will fail. See [Upstream network]({{< ref "/f5ads/aws/overview.md#upstream-network" >}}) for more information.
{{< /call-out >}}

Otherwise, create a new VPC in the same AWS Region as your deployment. Replace `<UPSTREAM_VPC_CIDR>` with a CIDR block for the VPC and `<AWS_REGION>` with your deployment's region:

```bash
aws ec2 create-vpc \
    --cidr-block <UPSTREAM_VPC_CIDR> \
    --region <AWS_REGION>
```

Example output:

```json
{
    "Vpc": {
        "VpcId": "vpc-0123456789abcdef1",
        "CidrBlock": "10.1.0.0/16",
        "State": "pending"
    }
}
```

Record the `VpcId`. You'll need it in the following steps.

## Request a VPC peering connection

From your upstream AWS account, request a peering connection targeting your deployment VPC. Replace `<UPSTREAM_VPC_ID>` with your upstream VPC ID, `<DEPLOYMENT_VPC_ID>` and `<DEPLOYMENT_AWS_ACCOUNT_ID>` with the values from your deployment Details tab, and `<AWS_REGION>` with your deployment region:

```bash
aws ec2 create-vpc-peering-connection \
    --vpc-id <UPSTREAM_VPC_ID> \
    --peer-vpc-id <DEPLOYMENT_VPC_ID> \
    --peer-owner-id <DEPLOYMENT_AWS_ACCOUNT_ID> \
    --region <AWS_REGION>
```

Example output:

```json
{
    "VpcPeeringConnection": {
        "VpcPeeringConnectionId": "pcx-0123456789abcdef0",
        "Status": {
            "Code": "initiating-request"
        }
    }
}
```

Record the `VpcPeeringConnectionId`. You'll need it in the following steps.

## Accept the peering connection in F5 ADS

F5 ADS accepts the peering connection request on the deployment side. You don't accept it using the AWS CLI.

1. In the F5 ADS Console, open your deployment's **Details** tab and select **Edit**.
1. Go to **Cloud Details** > **Upstream Network**, select **+ Add Entry**, and add the `VpcPeeringConnectionId` you recorded when you requested the VPC peering connection.
1. Select **Save Changes** to allow F5 ADS to accept the peering connection request.

Confirm the connection is active, replacing `<VPC_PEERING_CONNECTION_ID>`:

```bash
aws ec2 describe-vpc-peering-connections \
    --vpc-peering-connection-ids <VPC_PEERING_CONNECTION_ID> \
    --region <AWS_REGION> \
    --query "VpcPeeringConnections[0].Status"
```

Wait until `Code` shows `active` before continuing.

## Update your route tables

Add a route in your upstream VPC's route tables so traffic destined for the deployment CIDRs goes through the peering connection. Replace `<ROUTE_TABLE_ID>` with your upstream route table ID and `<DEPLOYMENT_IPV4_CIDR>` with the deployment's IPv4 CIDR:

```bash
aws ec2 create-route \
    --route-table-id <ROUTE_TABLE_ID> \
    --destination-cidr-block <DEPLOYMENT_IPV4_CIDR> \
    --vpc-peering-connection-id <VPC_PEERING_CONNECTION_ID> \
    --region <AWS_REGION>
```

If you're using IPv6, add a matching route for the deployment's IPv6 CIDR. Replace `<DEPLOYMENT_IPV6_CIDR>`:

```bash
aws ec2 create-route \
    --route-table-id <ROUTE_TABLE_ID> \
    --destination-ipv6-cidr-block <DEPLOYMENT_IPV6_CIDR> \
    --vpc-peering-connection-id <VPC_PEERING_CONNECTION_ID> \
    --region <AWS_REGION>
```

Repeat this step for every route table associated with a subnet that needs to reach the deployment.

## Update your security group rules

Allow inbound traffic from the deployment CIDRs on the security groups attached to your upstream applications. Replace `<SECURITY_GROUP_ID>` with the security group protecting your upstream application, and `<DEPLOYMENT_IPV4_CIDR>` with the deployment's IPv4 CIDR:

```bash
aws ec2 authorize-security-group-ingress \
    --group-id <SECURITY_GROUP_ID> \
    --protocol tcp \
    --port 443 \
    --cidr <DEPLOYMENT_IPV4_CIDR> \
    --region <AWS_REGION>
```

{{< call-out class="note" >}}
Scope the ingress rule to only the port and protocol your upstream application expects, and only the deployment CIDRs. For example, `--cidr 10.1.0.0/24` rather than a broad range like `0.0.0.0/0`.
{{< /call-out >}}

## Verify the peering connection

Confirm the peering connection is active and routes are in place, replacing `<VPC_PEERING_CONNECTION_ID>` and `<ROUTE_TABLE_ID>`:

```bash
aws ec2 describe-vpc-peering-connections \
    --vpc-peering-connection-ids <VPC_PEERING_CONNECTION_ID> \
    --region <AWS_REGION> \
    --query "VpcPeeringConnections[0].{Status:Status.Code,CIDR:AccepterVpcInfo.CidrBlock}"

aws ec2 describe-route-tables \
    --route-table-ids <ROUTE_TABLE_ID> \
    --region <AWS_REGION> \
    --query "RouteTables[0].Routes"
```

After the connection is `active` and the routes and security group rules are in place, your deployment can reach your upstream applications. The deployment reaches them at the addresses that your NGINX configuration proxies to.

## What's next

- [Set up connectivity]({{< ref "/f5ads/aws/deploy/create-deployment/deploy-console.md#set-up-connectivity" >}})
- [Monitor your deployment]({{< ref "/f5ads/aws/monitoring/enable-monitoring.md" >}})
