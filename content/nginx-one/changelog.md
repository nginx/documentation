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

Stay up-to-date with what's new and improved in NGINX One.

## May 29, 2024 - v0.20240529.1310498676

### Edit NGINX configurations

You can now make configuration changes to your NGINX instances. For more details, see [View and edit NGINX configurations]({{< relref "/nginx-one/how-to/nginx-config-edit.md" >}}).

## May 23, 2024 - v0.20240506.1280775334

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

### Getting Started

To help you get started, take a look at the [Getting Started Guide]({{< relref "/nginx-one/getting-started.md" >}}). This guide will walk you through the initial setup and key features so you can start using NGINX One right away.
