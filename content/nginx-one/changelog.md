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
    margin-bottom: 20px;
  }

  h2::after {
    content: "";
    display: block;
    width: 100%;
    height: 1px;
    background-color: #000; /* Adjust the color as needed */
    margin-top: 5px; /* Space between the heading and the horizontal line */
  }
</style>

Stay up-to-date with what's new and improved in the F5 NGINX One cloud console.

## August 8, 2024

### Instance Object Cleanup

NGINX Instance objects that have been `unavailable` for a set period will be automatically cleaned up (deleted). By default, this period is 24 hours from the time the NGINX Instance object was last updated. An administrator can change or disable the cleanup process in the "Instance Settings" under Settings. Events will be generated for NGINX Instances that have been automatically cleaned up. See "Events" for a list of NGINX Instances that have been deleted automatically. 

## June 11, 2024

### View NGINX security vulnerabilities (CVEs)

You can now view NGINX CVEs on the **Security** page. The listed CVEs affect official releases of NGINX Open Source and NGINX Plus.

Select the link for each CVE to see the details, including the CVE's publish date, severity, description, and the affected NGINX products and instances.

## May 29, 2024 - v0.20240529.1310498676

### Edit NGINX configurations

You can now make configuration changes to your NGINX instances. For more details, see [View and edit NGINX configurations]({{< relref "/nginx-one/how-to/nginx-configs/view-edit-nginx-configurations.md" >}}).

## May 28, 2024 - v0.20240528.1309124087

### Improved Data Plane Key and NGINX Instance Navigation

We've updated the **Instance Details** and **Data Plane Keys** pages to make it easier to go between keys and registered instances.

- On the **Instance Details** page, you can now find a link to the instance's data plane key. Select the "Data Plane Key" link to view important details like status, expiration, and other registered instances.
- The **Data Plane Keys** page now includes links to more information about each data plane key.

## February 28, 2024 - v0.20240228.1194299632

### Breaking Change

- API responses now use "object_id" instead of "uuid". For example, **key_1mp6W5pqRxSZJugJN-yA8g**. We've introduced specific prefixes for different types of objects:
  - Use **key_** for data-plane keys.
  - Use **inst_** for NGINX instances.
  - Use **nc_** for NGINX configurations.
- Likewise, we've updated the JSON key from **uuid** to **object_id** in response objects.

## February 6, 2024

### Welcome to the NGINX One EA preview

We're thrilled to introduce NGINX One, an exciting addition to our suite of NGINX products. Designed with efficiency and ease of use in mind, NGINX One offers an innovative approach to managing your NGINX instances.

To help you get started, take a look at the [Getting Started Guide]({{< relref "/nginx-one/getting-started.md" >}}). This guide will walk you through the initial setup and key features so you can start using NGINX One right away.
