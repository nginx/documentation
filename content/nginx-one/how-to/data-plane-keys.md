---
title: "Working with Data Plane Keys"
date: 2024-01-10T13:44:04-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 10
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["reference"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

## Data Plane keys in NGINX One

Adding nodes to NGINX One requires a Data Plane key.  The NGINX One administrator can create one key to be used for all nodes or create unique keys for each node or any variation of nodes groups sizes or individual nodes. When a key is generated the value is only displayed once, at the time of creation.  If this value is lost a new key will have to be generated.  There is no automated download of the key in this process. The key should be stored in a secure location and access to the key should be limited to those that will be managing instances connected to NGINX One.

## When to use a data plane key

When adding a new or existing NGINX instances to the NGINX One console you will have to provide a data plane key.  It is possible to use the same key value for all instances or you can create unique keys for groups of instances in your environment. A data plane key can be generated while adding a new instance or as a stand alone action. When adding a new instance the NGINX One console will provide the preferred curl command syntax for adding the NGINX instance to your NGINX One console on the XC distributed platform.  

### How to generate a new Data Plane key in NGINX One

1. Expand the **Manage** menu in the left side navigation menu and then select **Data Plane Keys**. 
1. Ensure **Active Keys** has been selected from towards the top of the main menu.
1. Select **Add Data Plane Key** listed just under **Active Keys**.  
1. In the **Name** field enter your desired data plane key name and set your expiration date.  
   1. The expiration date defaults to one year from the creation date, one year is the maximum duration period.
1. Select **Generate**.
1. A new pop up will display with your Data Plane key value. Be sure to copy this value and store it in a secure location.
1. Select **Close** when complete.

## How to add a new Instance and generate a new Data Plane key

1. Expand the **Manage** menu in the left side navigation menu and then select **Instances**. 
1. Select **Add Instance**.
1. Enable the radio button for **Generate new key** and select **Generate Data Plane Key**.
   1. Copy and save the new data plane key to a secure location
   2. Copy the sample curl command which will contain the newly created data plane key value.
   3. Select Done when ready to continue.
The newly created data plane key name will begin with data-plan-key and include the creation date. It is possible to rename the data plane key and also to change the expiration date.

Example curl command for reference.

```shell
curl agent.connect.nginx.com/nginx-agent/install | DATAPLANE_KEY="<data-plane-key>" sh -s -- -y
```

## How to add a new Instance and use and existing Data Plane key

1. Expand the **Manage** menu in the left side navigation menu and then select **Instances**. 
1. Select **Add Instance**.
2. Enable the radio button for **Use existing Key** and enter the existing key value into the **Data Plane Key** field. 
   1. As you enter the key value a sample curl command will be provided.
      1. The data plane key value is not validated in this process.
   3. Copy the sample curl command which will contain your existing data plane key value.
   4. Select Done when ready to continue.

Example curl command for reference.

```shell
curl agent.connect.nginx.com/nginx-agent/install | DATAPLANE_KEY="<data-plane-key>" sh -s -- -y
```

## How to revoke a Data Plane key

You can you revoke a key before it expires.  Revoking a key will disconnect any associated NGINX instances from the NGINX One console.

## How to delete a Data Plane key

Prior to deleting a key it must be revoked.


