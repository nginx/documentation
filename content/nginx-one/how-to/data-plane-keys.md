---
title: "Create and manage data plane keys"
date: 2024-01-10T13:44:04-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 200
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

Adding instances to NGINX One requires a Data Plane key. The NGINX One administrator can create one key to be used for all instances or create unique keys for each instance or any variation of instance groups sizes or individual instances. When a key is generated the value is only displayed once, at the time of creation.  If this value is lost a new key will have to be generated. There is no automated download of the key in this process. The key should be stored in a secure location and access to the key should be limited to those that will be managing instances connected to NGINX One.

## When to use a data plane key

When adding a new or existing NGINX instances to the NGINX One console you will have to provide a data plane key.  It is possible to use the same key value for all instances or you can create unique keys for groups of instances in your environment. A data plane key can be generated while adding a new instance or as a stand alone action. When adding a new instance the NGINX One console will provide the preferred curl command syntax for adding your NGINX instance to the NGINX One console.

## How to create a data plane key

### Log in to NGINX One

{{< include "nginx-one/xc-console/login.md" >}}

### Create a new data plane key

To create a new key for connecting your NGINX instances to NGINX One, follow these steps:

1. On the left menu, select **Data Plane Keys**.
2. Select **Add Data Plane Key**.
3. Enter a name for your new key. Optionally, you can set an expiration date for the key. If you don't set a date, the key will automatically expire one year from today. The longest duration for a key is one year. You can change this expiration date later by editing the key.
4. Select **Generate**.
5. A confirmation screen will show your new data plane key. Be sure to copy and store this key securely. It is displayed *only once* and cannot be retrieved later.
6. Select **Close** to complete the process.

## How to revoke and delete a data plane key

### Log in to NGINX One

{{< include "nginx-one/xc-console/login.md" >}}

### Revoke a Data Plane Key

If you need to deactivate a data plane key before its expiration date, follow these steps. Once revoked, the key will no longer connect any NGINX instances to NGINX One. The key will still be visible in the console until you delete it.

1. On the left menu, select **Data Plane Keys**.
2. Find the key you want to revoke in the list.
3. Next to the key name, in the **Actions** column, select the ellipsis (three dots) and then select **Revoke**.
4. A confirmation dialog will appear. Select **Revoke** to confirm.


### How to delete a Data Plane key

You must use the API in order to delete a key.  Prior to deleting a key it must be revoked which can be completed in the NGINX one console as noted earlier in this article or using the API.




