---
title: "Changelog"
date: 2024-01-29T15:13:58-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO.
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 99999
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1394"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation"]
doctypes: ["reference"]
journeys: ["researching", "getting started", "using", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

Stay up-to-date with what's new and improved in NGINX One.

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
