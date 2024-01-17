---
title: "Getting Started with NGINX One"
date: 2024-01-17T10:18:02-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{< custom-styles >}}

Welcome to the *Getting Started Guide for NGINX One*. This guide provides step-by-step instructions on how to activate and use NGINX One, a management console designed to monitor and manage NGINX data plane deployments effectively. Follow these steps to begin.

## Step 1: Enable the NGINX One Service on F5 Distributed Cloud

1. Log in to the [F5 Distributed Cloud Console](https://www.f5.com/cloud/products/distributed-cloud-console).
2. Find and select the **NGINX One** service on the dashboard.
3. Select **Enable Service**.
4. After the service has been enabled, select **Visit Service** to load the NGINX One console.

## Step 2: Add NGINX Instances

Once you've enabled NGINX One, the first thing to do is to add the NGINX instances you want to track.

1. If this is your first time accessing the NGINX console, select **Add Instance** on the welcome screen. If you've added instances before and now you want to add more, select **Instances** on the console's left menu, then select **Add Instance**.
2. **Generate a new data plane key**: A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One. To generate a data plane key, select **Generate Data Plane Key**.

   Alternatively, if you've already created a data plane key that you want to reuse, select **Use existing key**, then paste the key's value in the **Data Plane Key** box.

   {{<note>}}
   Data plane keys automatically expire after one year. However, you can extend this expiration date if needed.

   Revoking a data plane key will disconnect the associated NGINX instances from NGINX One.

   **IMPORTANT**: Data plane keys are not saved and are displayed only once when you generate them. You should save this key in a secure location for future reference.
   {{</note>}}
3. **Install NGINX Agent on the NGINX instances you want to track**: After you create or use an existing data plane key, a curl command will appear. Copy this command and run it on each NGINX instance you want to register with NGINX One.

## Step 2: Create a Data Plane Key

1. **Access Key Management:** In NGINX One, navigate to the key management section.
2. **Generate Key:** Select the option to create a new data plane key.
3. **Save Key:** Store the generated key securely. You will need this key for registering NGINX data plane instances.

## Step 3: Add NGINX Data Plane Instances to NGINX One

1. **Install NGINX Agent:** On each NGINX data plane instance, manually install the NGINX Agent.
   - Download the NGINX Agent installer from the NGINX One portal.
   - Run the installer on each data plane instance.
2. **Register Instances:** Use the previously generated data plane key to register each instance with NGINX One.
3. **Verify Connection:** Check in the NGINX One console to ensure all instances are listed and connected.

## After Setup: Monitoring and Managing Your NGINX Data Plane Fleet

Once you have added your NGINX instances to NGINX One, several management and monitoring features become available:

- **View CVEs:** Easily monitor and view Common Vulnerabilities and Exposures (CVEs) related to your NGINX data plane fleet.
- **Configuration Issues and Recommendations:** Access insights into configuration issues and receive recommendations for optimization.
- **Performance Metrics:** Review and analyze performance metrics for your NGINX data plane fleet to ensure optimal functioning.

## Conclusion

You have now successfully set up NGINX One and can begin monitoring and managing your NGINX data plane deployments. For any further assistance or detailed procedures, refer to the NGINX One documentation or contact support.

---

This guide is designed to provide clear and straightforward instructions for a global audience, avoiding technical jargon and complex language to ensure accessibility for all users.