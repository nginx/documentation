---
title: "Optimize NGINX Proxy Gateway for Large Data Planes"
date: 2023-02-15T12:00:04-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO.
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to fine-tune the NGINX proxy gateway for NGINX Management Suite to support large data planes running numerous NGINX Agents."
# Assign weights in increments of 100
weight: 400
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1131"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{<custom-styles>}}

## Overview

If the NGINX proxy gateway for NGINX Management Suite alerts you that there are not enough worker connections, you may need to modify the NGINX configuration (`/etc/nginx/nginx.conf` on the NGINX Management Suite host) to allow more worker connections and increase the number of file descriptors for worker processes.

## Configure Worker Connections

By default, the NGINX Management Suite's NGINX configuration (`/etc/nginx/nginx.conf`) allows 1024 worker connections (`worker_connections`). However, this default may be insufficient if you have a large data plane with numerous NGINX Agents. To ensure optimal performance, we suggest allowing **twice as many worker connections as the number of NGINX Agents** you want to support. This is because each NGINX Agent requires two persistent gRPC connections to the NGINX Management Suite. If you have 1,000 NGINX Agents, for example, you should allow around 2,000 worker connections.

You may also want to adjust the maximum number of file descriptors (`worker_rlimit_nofile`) that a process can open to align with the number of worker connections. Note that `rlimit_nofile` is a system setting, so make sure to check the user limits for your Linux distribution, as these may be more restrictive.

To update the number of worker connections and file descriptors, edit the NGINX configuration file (`/etc/nginx/nginx.conf`) on the NGINX Management Suite host. For more information on the NGINX worker connection and file descriptor settings, refer to the following NGINX Core topics:

- [NGINX worker_connections](http://nginx.org/en/docs/ngx_core_module.html#worker_connections)
- [NGINX worker_rlimit_nofile](http://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_nofile)
