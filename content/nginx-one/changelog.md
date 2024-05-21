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

## May 22, 2024 - v0.20240506.1280775334

### Enhanced Data Plane Key and NGINX Instance Navigation

We updated the Instance and Data Plane Key pages to make navigation between keys and registered instances easier.

- The Instance page now provides a link to its data plane key in the Instance Details pane.  Click the Data Plane Key link to view details like: **Status**, **Expiration Date**, and other **Registered Instances**.
- The Data Plane Keys page now provides a list of links to get more details about each data plane key.


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
