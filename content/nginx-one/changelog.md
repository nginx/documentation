---
description: ''
docs: DOCS-1394
doctypes:
- reference
tags:
- docs
title: Changelog
toc: true
weight: 99999
---

<style>
h2 {
  position: relative;
  margin-bottom: 10px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ddd; /* A very light line */
}

/* Adds space above all h2 elements except the first one */
.content h2:not(:first-of-type) {
  margin-top: 50px; /* Adjust this value to create the desired space */
}

.content h3 {
  margin-top: 25px; /* Space before the h3 */
  margin-bottom: 10px; /* Space after the h3 */
}

</style>

Stay up-to-date with what's new and improved in the F5 NGINX One Cloud Console.

## August 22, 2024

### Config sync groups

Config sync groups are now available in the F5 NGINX One Cloud Console. This feature allows you to manage and synchronize NGINX configurations across multiple instances as a single entity, ensuring consistency and simplifying the management of your NGINX environment.

For more information, see the full documentation on [Managing Config Sync Groups]({{< relref "/nginx-one/how-to/nginx-configs/manage-config-sync-groups.md" >}}).

## August 8, 2024

### Instance object cleanup

NGINX Instance objects that have been `unavailable` for a set period will be automatically cleaned up (deleted). By default, this period is 24 hours from the time the NGINX Instance object was last updated. An administrator can change or disable the cleanup process in the "Instance Settings" under Settings. Events will be generated for NGINX Instances that have been automatically cleaned up. See "Events" for a list of NGINX Instances that have been deleted automatically. 

## June 11, 2024

### View NGINX security vulnerabilities (CVEs)

You can now view NGINX CVEs on the **Security** page. The listed CVEs affect official releases of NGINX Open Source and NGINX Plus.

Select the link for each CVE to see the details, including the CVE's publish date, severity, description, and the affected NGINX products and instances.

## May 29, 2024 - v0.20240529.1310498676

### Edit NGINX configurations

You can now make configuration changes to your NGINX instances. For more details, see [View and edit NGINX configurations]({{< relref "/nginx-one/how-to/nginx-configs/view-edit-nginx-configurations.md" >}}).

## May 28, 2024 - v0.20240528.1309124087

### Improved data plane key and NGINX instance navigation

We've updated the **Instance Details** and **Data Plane Keys** pages to make it easier to go between keys and registered instances.

- On the **Instance Details** page, you can now find a link to the instance's data plane key. Select the "Data Plane Key" link to view important details like status, expiration, and other registered instances.
- The **Data Plane Keys** page now includes links to more information about each data plane key.

## February 28, 2024 - v0.20240228.1194299632

### Breaking change

- API responses now use "object_id" instead of "uuid". For example, **key_1mp6W5pqRxSZJugJN-yA8g**. We've introduced specific prefixes for different types of objects:
  - Use **key_** for data-plane keys.
  - Use **inst_** for NGINX instances.
  - Use **nc_** for NGINX configurations.
- Likewise, we've updated the JSON key from **uuid** to **object_id** in response objects.

## February 6, 2024

### Welcome to the NGINX One EA preview

We're thrilled to introduce NGINX One, an exciting addition to our suite of NGINX products. Designed with efficiency and ease of use in mind, NGINX One offers an innovative approach to managing your NGINX instances.

To help you get started, take a look at the [Getting Started Guide]({{< relref "/nginx-one/getting-started.md" >}}). This guide will walk you through the initial setup and key features so you can start using NGINX One right away.
