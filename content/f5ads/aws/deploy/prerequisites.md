---
title: Prerequisites
description: "Subscribe to F5 Application Delivery Service for AWS in the AWS Marketplace and link the subscription to an F5 ADS organization."
weight: 100
toc: false
f5-docs: DOCS-000
f5-content-type: how-to
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 ADS for AWS, prerequisites, AWS Marketplace, subscribe, subscription, F5 ADS Console, account"
f5-summary: >
  Before you deploy F5 Application Delivery Service for AWS, you must subscribe to the offering in the AWS Marketplace.
  This guide covers finding the listing, subscribing, and linking the subscription to a new or existing F5 ADS organization.
f5-audience: operator
---

Before you can deploy F5 Application Delivery Service for AWS, you need to complete some prerequisites.

## Subscribe to the F5 ADS for AWS offering

If it's your first time using F5 ADS for AWS, you need to find the offering in the AWS Marketplace and subscribe to it:

### Get the offering in the AWS Marketplace

1. Find the [F5 ADS for AWS product listing](https://aws.amazon.com/marketplace/pp/prodview-4pollrykhmexa) in the AWS Marketplace.
1. Walk through the Overview section for a quick summary of the product.
1. Select **View purchase options** to see the **Offer summary** and **Pricing details**.
   - You can use the [usage and cost estimator]({{< ref "/f5ads/aws/billing/usage-and-cost-estimator.md" >}}) to calculate the cost of your deployment.
1. Select **Subscribe** to subscribe to the F5 ADS for AWS offering.
   - Your request can take a few minutes to process. Don't refresh or close the page while it's in progress.
1. Once you've subscribed, select **Set up your account**. You will be redirected to the F5 ADS Console.
1. On the **Create Your Account** page, create an account with the F5 ADS service or log in to link your AWS Marketplace subscription.
   - Enter your email address and select **Continue** to create an account with a username and password. If you already have an F5 ADS account, select **Log in** and enter your credentials.
   - Alternatively, select **Continue with Google** or **Continue with Microsoft** to sign up using your existing social credentials.

   Once signed in, your AWS Marketplace subscription is linked to your F5 ADS organization automatically.
1. Once linked, you can manage certificates, configurations, and deployments directly from the F5 ADS Console.

## What's next

[Create a Deployment]({{< ref "/f5ads/aws/deploy/create-deployment/deploy-console.md" >}})
