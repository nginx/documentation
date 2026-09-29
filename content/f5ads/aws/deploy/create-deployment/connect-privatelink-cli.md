---
title: Connect to a private Endpoint deployment using the AWS CLI
description: "Use the AWS CLI to connect to an F5 Application Delivery Service for AWS deployment that uses a private endpoint service frontend"
weight: 110
toc: true
f5-docs: DOCS-000
f5-content-type: how-to
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 ADS for AWS, PrivateLink, AWS CLI, interface VPC endpoint, VPC endpoint, Private Endpoint, service frontend"
f5-summary: >
  Learn how to use the AWS CLI to create the AWS resources needed to connect to an F5 Application Delivery Service for AWS deployment
  configured with a Private Endpoint service frontend, starting from scratch with a new VPC.
f5-audience: operator
---

This guide shows how to use the AWS CLI to connect to an F5 Application Delivery Service for AWS deployment that's configured with a Private Endpoint service frontend. To connect, you create a VPC, a subnet, a security group, and an interface VPC endpoint that targets your deployment's PrivateLink Endpoint Service Name.

For information about endpoint service connections, see the AWS document, [Connect to an endpoint service as the service consumer](https://docs.aws.amazon.com/vpc/latest/privatelink/create-endpoint-service.html#connect-to-endpoint-service) documentation.

Before you start, you must have:

- The [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed and configured with credentials that can manage VPC resources.
- An F5 ADS deployment configured with a Private Endpoint service frontend. See [Create a new deployment]({{< ref "/f5ads/aws/deploy/create-deployment/deploy-console.md#create-a-new-deployment" >}}).
- The deployment's **PrivateLink Endpoint Service Name**, found on the deployment's **Details** tab under **Cloud Settings** > **Service Frontend**, for example, `com.amazonaws.vpce.us-east-1.vpce-svc-0c0d939ca9a7ce020`.

{{< call-out class="caution" >}}
Create the interface VPC endpoint in the same region as your deployment. F5 ADS doesn't currently support cross-region PrivateLink connections. 
{{< /call-out >}}

## Create a VPC

If you already have a VPC you want to connect from, skip to [Identify a subnet for the endpoint](#identify-a-subnet-for-the-endpoint) and use its VPC ID instead.

{{< call-out class="caution" title="CIDR overlap" >}}
The VPC's CIDR block must not overlap with your deployment's VPC CIDR block. Open the **Details** tab in your deployment to find the **IPv4 CIDR** (and **IPv6 CIDR**, if applicable) before you choose `<VPC_CIDR>`.
{{< /call-out >}}

Otherwise, create a new VPC. Replace `<VPC_CIDR>` with a CIDR block for the VPC (for example, `10.0.0.0/16`) and `<AWS_REGION>` with your deployment's region:

```bash
aws ec2 create-vpc \
    --cidr-block <VPC_CIDR> \
    --region <AWS_REGION>
```

Example output:

```json
{
    "Vpc": {
        "VpcId": "vpc-0123456789abcdef0",
        "CidrBlock": "10.0.0.0/16",
        "State": "pending"
    }
}
```

Record the `VpcId`. You'll need it in the following steps. For more background on VPC design, see AWS's [Create a VPC](https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc.html) documentation.

## Identify a subnet for the endpoint

The interface VPC endpoint needs a network interface in a subnet within the Availability Zone you plan to use. Replace `<VPC_ID>` with your VPC ID and `<AWS_REGION>` with your deployment's region, then list the subnets in your VPC:

```bash
aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=<VPC_ID>" \
    --region <AWS_REGION> \
    --query "Subnets[].{ID:SubnetId,AZ:AvailabilityZone,CIDR:CidrBlock}" \
    --output table
```

Use an existing subnet, or create a new one. Replace `<SUBNET_CIDR>` with an available CIDR block from your VPC and `<AZ>` with an Availability Zone in your region:

```bash
aws ec2 create-subnet \
    --vpc-id <VPC_ID> \
    --cidr-block <SUBNET_CIDR> \
    --availability-zone <AZ> \
    --region <AWS_REGION>
```

Example output:

```json
{
    "Subnet": {
        "SubnetId": "subnet-0123456789abcdef0",
        "VpcId": "vpc-0123456789abcdef0",
        "CidrBlock": "10.0.1.0/24",
        "AvailabilityZone": "us-east-1a",
        "State": "available"
    }
}
```

Record the `SubnetId` to use when you create the interface VPC endpoint.

## Create a security group for the endpoint

Create a security group that allows the traffic your clients need to send to the deployment. Replace `<VPC_ID>` with your VPC ID:

```bash
aws ec2 create-security-group \
    --group-name f5ads-privatelink-endpoint \
    --description "Allow traffic to F5 ADS PrivateLink endpoint" \
    --vpc-id <VPC_ID> \
    --region <AWS_REGION>
```

Record the returned `GroupId`, then add an ingress rule for the port your NGINX configuration listens on (for example, `443`). Replace `<SECURITY_GROUP_ID>` and `<CLIENT_CIDR>` with the CIDR range of the clients that need access:

```bash
aws ec2 authorize-security-group-ingress \
    --group-id <SECURITY_GROUP_ID> \
    --protocol tcp \
    --port 443 \
    --cidr <CLIENT_CIDR> \
    --region <AWS_REGION>
```

{{< call-out class="note" >}}
Scope the ingress rule to only the CIDR ranges or security groups that need to reach the deployment. For example, set `<CLIENT_CIDR>` to `10.0.1.0/24` to allow only clients in a specific subnet, instead of a broad range like `0.0.0.0/0`.
{{< /call-out >}}

## Create the interface VPC endpoint

Create the interface VPC endpoint, targeting the deployment's PrivateLink Endpoint Service Name. Replace `<VPC_ID>`, `<SUBNET_ID>`, and `<SECURITY_GROUP_ID>` with the values from the previous steps, and `<SERVICE_NAME>` with the **PrivateLink Endpoint Service Name** from the deployment's **Service Frontend** settings you noted earlier:

```bash
aws ec2 create-vpc-endpoint \
    --vpc-id <VPC_ID> \
    --vpc-endpoint-type Interface \
    --service-name <SERVICE_NAME> \
    --subnet-ids <SUBNET_ID> \
    --security-group-ids <SECURITY_GROUP_ID> \
    --region <AWS_REGION>
```

The command's output includes a `VpcEndpointId`, for example `vpce-0123456789abcdef0`. Record it to use when you allow the connection in the next step and to test connectivity.

The endpoint's initial state is `pending`. Check its state and DNS names with, replacing `<VPC_ENDPOINT_ID>`:

```bash
aws ec2 describe-vpc-endpoints \
    --vpc-endpoint-ids <VPC_ENDPOINT_ID> \
    --region <AWS_REGION> \
    --query "VpcEndpoints[0].{State:State,DNSEntries:DnsEntries}"
```

Wait until `State` shows `available` before continuing.

## Allow the connection in F5 ADS

Add the VPC endpoint ID to your deployment's **PrivateLink Connection Allow List** so F5 ADS accepts the connection:

1. In the F5 ADS Console, open your deployment's **Details** tab and select **Edit**.
1. Under **Service Frontend**, add the `VpcEndpointId` you recorded when you created the interface VPC endpoint to the **PrivateLink Connection Allow List**.
1. Select **Save Changes**.
--
{{< call-out class="important" >}}
F5 ADS accepts the PrivateLink connection only after you add the VPC endpoint ID (or its AWS account ID) to the allow list. Removing the entry disconnects the endpoint from the deployment.
{{< /call-out >}}

## Test the connection

From a resource inside the VPC (for example, an EC2 instance in the same subnet as the endpoint), connect to your NGINX configuration's listening port using one of the DNS names you recorded when you created the interface VPC endpoint:

```bash
curl https://vpce-0123456789abcdef0-abc12345.vpce-svc-0c0d939ca9a7ce020.us-east-1.vpce.amazonaws.com
```

## What's next

- [Set up connectivity]({{< ref "/f5ads/aws/deploy/create-deployment/deploy-console.md#set-up-connectivity" >}})
- [Monitor your deployment]({{< ref "/f5ads/aws/monitoring/enable-monitoring.md" >}})
