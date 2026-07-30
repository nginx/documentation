---
title: Deploy using the NGINXaaS Console
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/deploy/create-deployment/deploy-console/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

## Overview

This guide explains how to deploy F5 NGINXaaS for AWS using the [AWS Management Console](https://console.aws.amazon.com) and the NGINXaaS Console. The deployment process involves creating a new deployment, configuring the deployment, and testing the deployment.

## Before you begin

Before you can deploy NGINXaaS, follow the steps in the [Prerequisites]({{< ref "/nginxaas/aws/deploy/prerequisites/" >}}) topic to subscribe to the NGINXaaS for AWS offering in the AWS Marketplace.

### Create a VPC endpoint service

NGINXaaS requires a [VPC endpoint service](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html) to connect your NGINXaaS deployment to your applications in your VPC. The VPC endpoint service must be created in a region we support.

{{< call-out class="caution" >}}
{{< include "/nginxaas/aws/supported-regions.md" >}}
{{< /call-out >}}

1. Access the [AWS Management Console](https://console.aws.amazon.com/).
1. Create a VPC and subnet, if you don't already have one for your upstream application servers. See [AWS's documentation on creating a VPC](https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc.html) for a step-by-step guide.
   - The region you select for the VPC endpoint service determines the region where your NGINXaaS deployment will be created. You do not manually select a region when creating an NGINXaaS deployment; it will automatically be created in the same region as the VPC endpoint service.
1. Create a Network Load Balancer that targets your upstream application servers. See [AWS's documentation on creating a Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-network-load-balancer.html) for a step-by-step guide.
1. Create a VPC endpoint service backed by that Network Load Balancer. See [AWS's documentation on creating a VPC endpoint service](https://docs.aws.amazon.com/vpc/latest/privatelink/create-endpoint-service.html) for a step-by-step guide. To ensure secure and controlled access to your VPC endpoint service, we strongly recommend leaving **Require acceptance** enabled on the endpoint service. This option helps maintain security by ensuring only trusted principals can connect to your service by letting you manually approve trusted connections. To start, you can leave the list of allowed principals empty and add the NGINXaaS deployment's AWS account after it is created.

   {{< call-out class="caution" >}}
   For development and testing purposes, or in scenarios where speed and simplicity are prioritized over security, you have the option to disable **Require acceptance** on the endpoint service. Please note that this approach is inherently less secure and may expose your service to unintended or unauthorized access. We encourage you to exercise caution if using the less restrictive option and to avoid using it in production or sensitive environments.
   {{< /call-out >}}

1. Make a note of the VPC endpoint service name as it will be needed in the next steps to create your NGINXaaS deployment. You can find the service name in the AWS Management Console by following the steps below:
   1. Go to **VPC** > **Endpoint Services** at the following link: https://console.aws.amazon.com/vpcconsole/home?region=us-east-1#EndpointServices: (replace `us-east-1` in the URL with your region).
   1. Open the desired endpoint service and copy the value from the **Service name** field. **Example format:** `com.amazonaws.vpce.us-east-1.vpce-svc-0123456789abcdef0`.

## Access the NGINXaaS Console

Once you have completed the subscription process and created a VPC endpoint service, you can access the NGINXaaS Console.

- Visit [https://console.nginxaas.net/](https://console.nginxaas.net/) to access the NGINXaaS Console.
- Log in to the console with your AWS credentials.
- Select the appropriate Geography to work in, based on the region your VPC endpoint service was created in.

## Create or import an NGINX configuration

{{< include "/nginxaas/create-or-import-nginx-config.md" >}}

## Create a new deployment

Next, create a new NGINXaaS deployment using the NGINXaaS Console:

1. On the left menu, select **Deployments**.
1. Select {{< icon "plus" >}} **Add Deployment** to create a new deployment.

   - Enter a **Name**.
   - Add an optional description for your deployment.
   - Change the **NCU Capacity** if needed.
      - The default value of `20 NCU` should be adequate for most scenarios.
   - In the Apply Configuration section, select an NGINX configuration [you created earlier](#create-or-import-an-nginx-configuration) from the **Choose Configuration** list.
   - Select a **Configuration Version** from the list.
   - In the Cloud Details section, enter the VPC endpoint service name that [you created earlier](#create-a-vpc-endpoint-service) or select it in the **VPC endpoint service** list.
      - The VPC endpoint service name is formatted like the following example: `com.amazonaws.vpce.us-east-1.vpce-svc-0123456789abcdef0`.
   - Select **Managed Public Endpoint** or **Private Endpoint** under Service Frontend. 
      - Refer to the [Service Frontend]({{< ref "/nginxaas/aws/overview.md#service-frontend" >}}) documentation for more information on these two frontend types.
   - Select **Submit** to begin the deployment process.

Your new deployment will appear in the list of deployments. The status of the deployment will be "Pending" while the deployment is being created. Once the deployment is complete, the status will change to "Ready".

{{< call-out class="important" >}}If **Require acceptance** is enabled on your VPC endpoint service, you will need to add the **NGINXaaS deployment AWS account** to the list of **Allowed principals** for the deployment to provision successfully. The NGINXaaS deployment `AWS Account ID` can be found under the `Cloud Info` section for your deployment. Failing to do so will leave the deployment in a `Pending` state, with details provided on the necessary actions required to proceed.{{< /call-out >}}

## Configure your deployment

In the NGINXaaS Console,

1. To open the details of your deployment, select its name from the list of deployments.
   - You can view the details of your deployment, including the status, region, VPC endpoint service, NGINX configuration, and more.
1. Select **Edit** to modify the deployment description and NCU Capacity.
   - You can also configure monitoring from here. Detailed instructions can be found in [Enable Monitoring]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
1. Select **Update** to save your changes.
1. Select the Configuration tab to view the current NGINX configuration associated with the deployment.
1. Select **Update Configuration** to change the NGINX configuration associated with the deployment.
1. To modify the contents of the NGINX configuration, see [Update an NGINX Configuration]({{< ref "/nginxaas/aws/deploy/nginx-configuration/nginx-configuration-console.md#update-an-nginx-configuration" >}}).

## Set up connectivity (Private Endpoint only)

If you selected **Private Endpoint** as the service frontend type, complete the following steps to allow client access. If you selected **Managed Public Endpoint**, skip this section.

### Internal traffic

To set up private connectivity to your NGINXaaS deployment, create an [interface VPC endpoint](https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html) in the same VPC as your internal clients.

1. Go to the [AWS Management Console](https://console.aws.amazon.com/) and select the account where you want to create networking resources for your F5 NGINXaaS deployment.
1. Create or reuse a [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc.html).
1. Create an interface VPC endpoint. See [AWS's documentation on creating an interface endpoint](https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html) for a step-by-step guide.
    - For **Service name**, enter your NGINXaaS deployment's Service Name, which is visible on the `Deployment Details` section for your deployment.


### External traffic

To set up public connectivity for external clients, front your interface VPC endpoint with a [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) for your NGINXaaS deployment.

1. Go to the [AWS Management Console](https://console.aws.amazon.com/) and select the account where you want to create networking resources for your F5 NGINXaaS deployment.
1. Create or reuse a [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc.html).
1. Create an interface VPC endpoint targeting your NGINXaaS deployment's Service Name, as described in [Internal traffic](#internal-traffic) above.
1. Allocate an [Elastic IP address](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-eips.html) for public access. See [AWS's documentation on allocating an Elastic IP address](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-eips.html#allocate-eip) for a step-by-step guide.
1. Create a target group with **Target type** set to **IP addresses**. See [AWS's documentation on creating a target group](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-target-group.html) for a step-by-step guide.
   - For **Protocol**, select **TCP**.
   - For **Port**, enter the port your NGINX server is listening on. If you're using the default NGINX config, enter port `80`.
   - Register the IP addresses of your interface VPC endpoint's elastic network interfaces as targets.
1. Create a Network Load Balancer. See [AWS's documentation on creating a Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-network-load-balancer.html) for a step-by-step guide.
   - For **Scheme**, select **Internet-facing**.
   - For **VPC**, select the VPC containing your interface VPC endpoint.
   - Associate the Elastic IP address you allocated earlier with the load balancer's subnet mapping.
   - In the **Listeners and routing** section, add a TCP listener on the same port as your target group and forward it to the target group you created.


Each listening port configured on NGINX requires its own target group and listener with a matching port. You can use the following helper script to automate these steps:

{{< details summary="Show helper script" >}}

   ```bash
   #!/bin/bash
   set -euo pipefail
   # Default values
   REGION=""
   VPC_ID=""
   SUBNET_IDS=""
   SERVICE_NAME=""
   PORTS="80"
   NLB_NAME="nginxaas-nlb"
   EIP_NAME="nginxaas-eip"

   # Prerequisites:
   # - AWS CLI installed and configured
   # - An existing VPC with subnets in the target region
   # - A valid VPC endpoint Service Name from F5 NGINXaaS for AWS

   # Function to display usage
   usage() {
      cat << EOF
   Usage: $0 --region REGION --vpc-id VPC_ID --subnets SUBNET_IDS --service-name SERVICE_NAME [--ports PORTS]

   Options:
      --region                  AWS Region
      --vpc-id                  VPC ID for the interface endpoint and load balancer
      --subnets                 Comma-separated list of subnet IDs for the load balancer (one per AZ)
      --service-name             NGINXaaS VPC endpoint Service Name
      --ports                   Comma-separated list of ports (default: 80)
      --help                    Show this help message

   Note: The interface VPC endpoint and Elastic IP will be automatically created as
      'nginxaas-vpce' and 'nginxaas-eip' respectively.
      These resources will not be deleted; if deleted, this script will create new ones.

   Example:
      $0 --region us-east-1 --vpc-id vpc-0123456789abcdef0 --subnets subnet-aaa,subnet-bbb \\
         --service-name "com.amazonaws.vpce.us-east-1.vpce-svc-0123456789abcdef0" \\
         --ports "80,443,8080"
   EOF
   }

   # Parse command line arguments
   while [[ $# -gt 0 ]]; do
      case $1 in
        --region)
            REGION="$2"
            shift 2
            ;;
        --vpc-id)
            VPC_ID="$2"
            shift 2
            ;;
        --subnets)
            SUBNET_IDS="$2"
            shift 2
            ;;
        --service-name)
            SERVICE_NAME="$2"
            shift 2
            ;;
        --ports)
            PORTS="$2"
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
      esac
   done

   # Validate required parameters
   missing_params=()
   [[ -z "$REGION" ]] && missing_params+=("--region")
   [[ -z "$VPC_ID" ]] && missing_params+=("--vpc-id")
   [[ -z "$SUBNET_IDS" ]] && missing_params+=("--subnets")
   [[ -z "$SERVICE_NAME" ]] && missing_params+=("--service-name")

   if [[ ${#missing_params[@]} -gt 0 ]]; then
      echo "Error: Missing required parameters: ${missing_params[*]}"
      usage
      exit 1
   fi

   IFS=',' read -ra SUBNET_ARRAY <<< "$SUBNET_IDS"

   # Create the interface VPC endpoint (skip if exists)
   echo "Creating interface VPC endpoint if it doesn't already exist..."
   VPCE_ID=$(aws ec2 describe-vpc-endpoints --region "$REGION" \
      --filters "Name=service-name,Values=$SERVICE_NAME" "Name=vpc-id,Values=$VPC_ID" \
      --query 'VpcEndpoints[0].VpcEndpointId' --output text 2>/dev/null || echo "None")

   if [[ "$VPCE_ID" == "None" || -z "$VPCE_ID" ]]; then
      VPCE_ID=$(aws ec2 create-vpc-endpoint --region "$REGION" \
         --vpc-id "$VPC_ID" \
         --service-name "$SERVICE_NAME" \
         --vpc-endpoint-type Interface \
         --subnet-ids "${SUBNET_ARRAY[@]}" \
         --tag-specifications 'ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=nginxaas-vpce}]' \
         --query 'VpcEndpoint.VpcEndpointId' --output text)
   fi
   echo "Using interface VPC endpoint: $VPCE_ID"

   # Fetch the endpoint's network interface IP addresses
   ENI_IDS=$(aws ec2 describe-vpc-endpoints --region "$REGION" \
      --vpc-endpoint-ids "$VPCE_ID" \
      --query 'VpcEndpoints[0].NetworkInterfaceIds' --output text)
   VPCE_IPS=$(aws ec2 describe-network-interfaces --region "$REGION" \
      --network-interface-ids $ENI_IDS \
      --query 'NetworkInterfaces[].PrivateIpAddress' --output text)

   # Allocate Elastic IP (skip if exists)
   echo "Allocating Elastic IP if it doesn't already exist..."
   EIP_ALLOC=$(aws ec2 describe-addresses --region "$REGION" \
      --filters "Name=tag:Name,Values=$EIP_NAME" \
      --query 'Addresses[0].AllocationId' --output text 2>/dev/null || echo "None")

   if [[ "$EIP_ALLOC" == "None" || -z "$EIP_ALLOC" ]]; then
      EIP_ALLOC=$(aws ec2 allocate-address --region "$REGION" --domain vpc \
         --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=$EIP_NAME}]" \
         --query 'AllocationId' --output text)
   fi
   echo "Using Elastic IP allocation: $EIP_ALLOC"

   # Convert comma-separated ports to array
   IFS=',' read -ra PORTS_ARRAY <<< "$PORTS"

   for P in "${PORTS_ARRAY[@]}"; do
      echo "Processing port $P..."

      # Create target group (skip if exists) - IP target type for PrivateLink
      TG_ARN=$(aws elbv2 describe-target-groups --region "$REGION" \
         --names "tg-$P" --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || echo "None")

      if [[ "$TG_ARN" == "None" || -z "$TG_ARN" ]]; then
         TG_ARN=$(aws elbv2 create-target-group --region "$REGION" \
            --name "tg-$P" \
            --protocol TCP --port "$P" \
            --target-type ip \
            --vpc-id "$VPC_ID" \
            --query 'TargetGroups[0].TargetGroupArn' --output text)

         # Register the interface endpoint's IPs as targets
         for IP in $VPCE_IPS; do
            aws elbv2 register-targets --region "$REGION" \
               --target-group-arn "$TG_ARN" \
               --targets "Id=$IP,Port=$P"
         done
      fi

      # Create the Network Load Balancer (skip if exists) - one NLB serves all ports
      NLB_ARN=$(aws elbv2 describe-load-balancers --region "$REGION" \
         --names "$NLB_NAME" --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null || echo "None")

      if [[ "$NLB_ARN" == "None" || -z "$NLB_ARN" ]]; then
         SUBNET_MAPPING="SubnetId=${SUBNET_ARRAY[0]},AllocationId=$EIP_ALLOC"
         NLB_ARN=$(aws elbv2 create-load-balancer --region "$REGION" \
            --name "$NLB_NAME" \
            --type network \
            --scheme internet-facing \
            --subnet-mappings "$SUBNET_MAPPING" \
            --query 'LoadBalancers[0].LoadBalancerArn' --output text)
      fi

      # Create listener forwarding to the target group (skip if exists)
      LISTENER_EXISTS=$(aws elbv2 describe-listeners --region "$REGION" \
         --load-balancer-arn "$NLB_ARN" \
         --query "Listeners[?Port==\`$P\`].ListenerArn" --output text)

      if [[ -z "$LISTENER_EXISTS" ]]; then
         aws elbv2 create-listener --region "$REGION" \
            --load-balancer-arn "$NLB_ARN" \
            --protocol TCP --port "$P" \
            --default-actions "Type=forward,TargetGroupArn=$TG_ARN"
      fi

      echo "Completed setup for port $P"
   done

   VIP=$(aws ec2 describe-addresses --region "$REGION" \
      --allocation-ids "$EIP_ALLOC" --query 'Addresses[0].PublicIp' --output text)
   echo "Setup complete! Public IP: $VIP"

   ```

{{< /details >}}

## Test your deployment

1. To test your deployment, connect to the IP address created in [Set up connectivity]({{< ref "/nginxaas/aws/deploy/create-deployment/deploy-console.md#set-up-connectivity-private-endpoint-only" >}}) or the service endpoint created with your managed public endpoint deployment.

{{< call-out class="note" >}}

The deployment is privately deployed in your subnet. If you want to route traffic to an application over the public internet, consider setting up a [NAT gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html).

{{< /call-out >}}

## What's next

- [Monitor your deployment]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
- [Manage certificates in AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md" >}})
