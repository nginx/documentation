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

Adding nodes to NGINX One requires a Data Plane key.  The NGINX One administrator can create one key to be used for all nodes or create unique keys for each node or any variation of nodes groups sizes or individual nodes. When a key is generated the value is only displayed once at the time of creation.  If this value is lost a new key will have to be generated.  There is no automated download of the key or key value in this process. The key should be stored in a secure location and access to the key should be limited to those that will be managing instances connected to NGINX One.

## When to use a data plane key

When adding a new or existing NGINX instances to the NGINX One console you will have to provide a data plane key.  It is possible to use the same key value for all instances or you can create unique keys for groups of instances in your environment.

The NGINX One console will provide the preferred curl command syntax for adding an NGINX instance to your NGINX One console on the XC distributed platform.  

1. Expand the **Manage** menu and click on Data Plane Keys. 
1. In the name field enter your desired data plane key name and set your expiration date.  
   1. The expiration date defaults to one year from the creation date, one year is the maximum duration period.
1. Click **Generate**.
2. A new pop up will display with your Data Plane key value. Be sure to copy this value and store it in a secure location.
3. Click close when complete.

## How to generate a new Data Plane key in NGINX One

To generate a new Data Plane key login to the NGINX One console and 

## How to add a new Instance and generate a new Data Plane key

You are able to add a new instance to the NGINX console and generate a new key at the same time.

```shell
curl agent.connect.nginx.com/nginx-agent/install | DATAPLANE_KEY="<data-plane-key>" sh -s -- -y
```

## How to add a new Instance and use and existing Data Plane key

You can use an existing Data Plane key when adding a new instance to the NGINX console. 

```shell
curl agent.connect.nginx.com/nginx-agent/install | DATAPLANE_KEY="<data-plane-key>" sh -s -- -y
```

## How to revoke a Data Plane key

You can you revoke a key before it expires.  Revoking a key will disconnect any associated NGINX instances from the NGINX One console.

## How to delete a Data Plane key

Prior to deleting a key it must be revoked.


