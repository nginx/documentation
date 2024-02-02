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

<style>
h2 {
  margin-top: 20px;
  padding-top: 20px;
}
</style>

## About data plane keys

### Overview

Data plane keys are required for registering NGINX instances with NGINX One. These keys serve as secure tokens, ensuring that only authorized NGINX instances can connect to and communicate with  NGINX One. You have the flexibility to create a single key for multiple instances, or to create a unique key for each instance.

{{<call-out "caution" "Data plane key guidelines">}}
Data plane keys are displayed only once and cannot be retrieved later. Be sure to copy and store this key securely.

Data plane keys expire after one year. You can change this expiration date later by editing the key.

Revoking a data plane key disconnects all instances that were registered with that key.
{{</call-out>}}

## Create a new data plane key

To create a new key for connecting your NGINX instances to NGINX One, follow these steps:

1. On the left menu, select **Data Plane Keys**.
2. Select **Add Data Plane Key**.
3. Enter a name for your new key. Optionally, you can set an expiration date for the key. If you don't set a date, the key will automatically expire one year from today. The longest duration for a key is one year. You can change this expiration date later by editing the key.
4. Select **Generate**.
5. A confirmation screen will show your new data plane key. Be sure to copy and store this key securely. It is displayed *only once* and cannot be retrieved later.
6. Select **Close** to complete the process.

## Update the expiration date

To extend the expiration date of a data plane key, follow these steps before the key expires. You cannot update the expiration date after the key has expired.

1. On the left menu, select **Data Plane Keys**.
2. Find the key you want to edit in the list.
3. Next to the key name, in the **Actions** column, select the ellipsis (three dots) and then select **Edit Key**.
4. Set a new expiration date for the key. The longest duration for a key is one year.
5. Select **Save**.

## Revoke a data plane key

If you need to deactivate a data plane key before its expiration date, follow these steps. Once revoked, the key will no longer connect any NGINX instances to NGINX One. The key will still be visible in the console until you delete it.

1. On the left menu, select **Data Plane Keys**.
2. Find the key you want to revoke in the list.
3. Next to the key name, in the **Actions** column, select the ellipsis (three dots) and then select **Revoke**.
4. A confirmation dialog will appear. Select **Revoke** to confirm.


## Delete a data plane key (API only)

In this Early Access release, you need to use the NGINX One REST API to delete a data plane key. However, before you can delete a key, it must be revoked. You can revoke a key either through the NGINX One console, as explained above, or by using the REST API.

To delete a data plane key using the NGINX One REST API, see these guides:

- [Authenticate with the NGINX One REST API]({{< relref "nginx-one/reference/api/nginx-one-api-authentication.md" >}})
- [Delete a data plane key: NGINX One API Reference]({{< relref "nginx-one/reference/api/nginx-one-api-reference.md#operation/deleteDataPlaneKey" >}})



