---
title: Deploy using the NGINXaaS Console
weight: 100
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/create-deployment/deploy-console/
nd-content-type: how-to
nd-product: NGOOGL
---

## Overview

This guide explains how to deploy F5 NGINXaaS for Google Cloud (NGINXaaS) using [Google Cloud Console](https://console.cloud.google.com) and the NGINXaaS Console. The deployment process involves creating a new deployment, configuring the deployment, and testing the deployment.

## Before you begin

Before you can deploy NGINXaaS, follow the steps in the [Prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites/" >}}) topic to subscribe to the NGINXaaS for Google Cloud offering in the Google Cloud Marketplace.

### Create a network attachment

NGINXaaS requires a [network attachment](https://cloud.google.com/vpc/docs/about-network-attachments) to connect your NGINXaaS deployment to your VPC network. The network attachment must be created in a region we support.

{{< call-out "caution" >}}
{{< include "/nginxaas-google/supported-regions.md" >}}
{{< /call-out >}}

1. Access the [Google Cloud Console](https://console.cloud.google.com/).
1. Create a consumer VPC network and subnetwork. See [Google's documentation on creating a VPC and subnet](https://cloud.google.com/vpc/docs/create-modify-vpc-networks#console_1) for a step-by-step guide.
   - The region you select for the network attachment determines the region where your NGINXaaS deployment will be created. You do not manually select a region when creating an NGINXaaS deployment; it will automatically be created in the same region as the network attachment.
1. Create a network attachment in your new subnet. See [Google's documentation on creating a network attachment](https://cloud.google.com/vpc/docs/create-manage-network-attachments#create-network-attachments) for a step-by-step guide.
   - For **production use cases**, we recommend setting the **Connection preference** on the Network Attachment resource to **Accept connections from selected projects**. This lets you manually approve trusted connections, as this setting cannot be changed later. To start, you can leave the list of accepted projects empty and add the NGINXaaS deployment project after it is created.
   - For **development use cases**, you can set the **Connection preference** to **Automatically accept connections from all projects**, which allows connections without manual approval. If you choose this option, you don't need to explicitly allow the NGINXaaS deployment project.
1. Make a note of the network attachment ID. You will need it in the next steps to create your NGINXaaS deployment.

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
   - In the Cloud Details section, enter the network attachment ID that [you created earlier](#create-a-network-attachment) or select it in the  **Network attachment** list.
      - The network attachment ID is formatted like the following example: `projects/my-google-project/regions/us-east1/networkAttachments/my-network-attachment`.
   - In the Apply Configuration section, select an NGINX configuration [you created earlier](#create-or-import-an-nginx-configuration) from the **Choose Configuration** list.
   - Select a **Configuration Version** from the list.
   - Select **Submit** to begin the deployment process.

Your new deployment will appear in the list of deployments. The status of the deployment will be "Pending" while the deployment is being created. Once the deployment is complete, the status will change to "Ready".

{{< call-out "important" >}}If the **Connection preference** on the Network Attachment resource is set to **Accept connections from selected projects**, you will need to add the **NGINXaaS deployment project** to the list of **Accepted projects** for the deployment to provision successfully. The NGINXaaS deployment `Project ID` can be found under the `Cloud Info` section for your deployment. Failing to do so will leave the deployment in a `Pending` state, with details provided on the necessary actions required to proceed.{{< /call-out >}}

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

1. Access the [Google Cloud Console](https://console.cloud.google.com/) and select the project where your networking resources for connecting to your F5 NGINXaaS deployment should be created.
1. Create or reuse a [VPC network](https://cloud.google.com/vpc/docs/create-modify-vpc-networks).
1. Create a proxy-only subnet in your consumer VPC. See [Google's documentation on creating a proxy-only subnet](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_1) for a step-by-step guide.
1. Create a public IP address. See [Google's documentation on reserving a static address](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_3) for a step-by-step guide.
1. Create a Private Service Connect Network Endpoint Group (PSC NEG). See [Google's documentation on creating a NEG](https://cloud.google.com/vpc/docs/access-apis-managed-services-private-service-connect-backends#console) for a step-by-step guide.
   - Set **Network endpoint group type** to **Private Service Connect NEG (Regional)**.
   - Set **Taget** to **Published service**.
   - For **Target service**, enter your NGINXaaS deployment's Service Attachment, which is visible on the `Deployment Details` section for your deployment.
   - For **Producer port**, enter the port your NGINX server is listening on. If you're using the default NGINX config, enter port `80`.
   - For **Network** and **Subnetwork** select your consumer VPC network and subnet.
1. Create a regional external proxy Network Load Balancer. See [Google's documentation on configuring the load balancer](https://cloud.google.com/load-balancing/docs/tcp/set-up-ext-reg-tcp-proxy-zonal#console_6) for a step-by-step guide.
   - For **Network**, select your consumer VPC network.
   - For **Backend configuration**, follow [Google's step-by-step guide to add a backend](https://cloud.google.com/vpc/docs/access-apis-managed-services-private-service-connect-backends#console_5).
   - In the **Frontend configuration** section,
      - For **IP address**, select the public IP address created earlier.
      - For **Port number**, enter the same port as your NEG's Producer port, for example, port `80`.


Each listening port configured on NGINX requires its own PSC network endpoint group with a matching port. You can use the following helper script to automate these steps:

{{< details summary="Show helper script" >}}

   ```bash
   #!/bin/bash
   set -euo pipefail
   # Default values
   PROJECT=""
   REGION=""
   NETWORK=""
   SA_URI=""
   PORTS="80"
   PROXY_SUBNET="psc-proxy-subnet"
   VIPNAME="psc-vip"

   # Prerequisites:
   # - gcloud CLI installed and configured
   # - An existing projectID and a VPC network created in that project
   # - A valid Service Attachment URI from F5 NGINXaaS

   # Function to display usage
   usage() {
      cat << EOF
   Usage: $0 --project PROJECT --region REGION --network NETWORK --service-attachment SA_URI [--ports PORTS]

   Options:
      --project                 GCP Project ID
      --region                  GCP Region
      --network                 VPC Network name
      --service-attachment      Service Attachment Self Link
      --ports                   Comma-separated list of ports (default: 80)
      --help                    Show this help message

   Note: Proxy subnet and public IP will be automatically created as 'psc-proxy-subnet' and 'psc-vip' respectively.
      These resources will not be deleted, if deleted this script will create new ones.

   Example:
      $0 --project my-project --region us-central1 --network my-vpc \\
         --service-attachment "projects/producer-proj/regions/us-central1/serviceAttachments/my-service" \\
            --ports "80,443,8080"
   EOF
   }

   # Parse command line arguments
   while [[ $# -gt 0 ]]; do
      case $1 in
        --project)
            PROJECT="$2"
            shift 2
            ;;
        --region)
            REGION="$2"
            shift 2
            ;;
        --network)
            NETWORK="$2"
            shift 2
            ;;
        --service-attachment)
            SA_URI="$2"
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
   [[ -z "$PROJECT" ]] && missing_params+=("--project")
   [[ -z "$REGION" ]] && missing_params+=("--region")
   [[ -z "$NETWORK" ]] && missing_params+=("--network")
   [[ -z "$SA_URI" ]] && missing_params+=("--service-attachment")

   if [[ ${#missing_params[@]} -gt 0 ]]; then
      echo "Error: Missing required parameters: ${missing_params[*]}"
      usage
      exit 1
   fi

   # Create proxy-only subnet (skip if exists)
   echo "Creating proxy-only subnet if it doesn't already exist..."
   if ! gcloud compute networks subnets describe $PROXY_SUBNET --region=$REGION --project=$PROJECT >/dev/null 2>&1; then
      gcloud compute networks subnets create $PROXY_SUBNET \
         --project=$PROJECT --region=$REGION \
         --network=$NETWORK \
         --range=192.168.1.0/24 \
         --purpose=REGIONAL_MANAGED_PROXY \
         --role=ACTIVE
   fi

   echo "Using proxy-only subnet: $PROXY_SUBNET"

   # Create regional VIP address (skip if exists)
   echo "Creating regional VIP address..."
   if ! gcloud compute addresses describe $VIPNAME --region=$REGION --project=$PROJECT >/dev/null 2>&1; then
    gcloud compute addresses create $VIPNAME --region=$REGION --project=$PROJECT
   fi
   VIP=$(gcloud compute addresses describe $VIPNAME --region=$REGION --project=$PROJECT --format='get(address)')
   echo "Using VIP address: $VIP"

   # Convert comma-separated ports to array
   IFS=',' read -ra PORTS_ARRAY <<< "$PORTS"

   for P in "${PORTS_ARRAY[@]}"; do
      echo "Processing port $P..."

      # Create Network Endpoint Group (skip if exists)
      if ! gcloud compute network-endpoint-groups describe psc-neg-$P --region=$REGION --project=$PROJECT >/dev/null 2>&1; then
         gcloud compute network-endpoint-groups create psc-neg-$P \
         --project=$PROJECT --region=$REGION \
         --network-endpoint-type=private-service-connect \
         --psc-target-service="$SA_URI" \
         --network=$NETWORK \
         --producer-port=$P
      fi

      # Create Backend Service (skip if exists) - NO HEALTH CHECKS for PSC
      if ! gcloud compute backend-services describe be-$P --region=$REGION --project=$PROJECT >/dev/null 2>&1; then
         gcloud compute backend-services create be-$P \
            --project=$PROJECT --region=$REGION \
            --protocol=TCP --load-balancing-scheme=EXTERNAL_MANAGED

         # Add backend to service
         gcloud compute backend-services add-backend be-$P \
            --project=$PROJECT --region=$REGION \
            --network-endpoint-group=psc-neg-$P \
            --network-endpoint-group-region=$REGION
      fi

      # Create Target TCP Proxy (skip if exists)
      if ! gcloud compute target-tcp-proxies describe tp-$P --region=$REGION --project=$PROJECT >/dev/null 2>&1; then
         gcloud compute target-tcp-proxies create tp-$P \
         --project=$PROJECT --region=$REGION --backend-service=be-$P
      fi

      # Create Forwarding Rule (skip if exists)
      if ! gcloud compute forwarding-rules describe fr-$P --region=$REGION --project=$PROJECT >/dev/null 2>&1; then
         gcloud compute forwarding-rules create fr-$P \
         --project=$PROJECT --region=$REGION \
         --address=$VIP --network=$NETWORK \
         --target-tcp-proxy=tp-$P --target-tcp-proxy-region=$REGION \
         --ports=$P --load-balancing-scheme=EXTERNAL_MANAGED \
         --network-tier=PREMIUM --ip-protocol=TCP
      fi

      echo "Completed setup for port $P"
   done
   echo "Setup complete! Public Virtual IP: $VIP"

   ```

{{< /details >}}

## Test your deployment

1. To test your deployment, go to the IP address created in [Set up connectivity to your deployment]({{< ref "/nginxaas-google/getting-started/create-deployment/deploy-console.md#set-up-connectivity-to-your-deployment" >}}) using your favorite web browser.

## What's next

[Manage your NGINXaaS users]({{< ref "/nginxaas-google/getting-started/manage-users-organizations.md" >}})
