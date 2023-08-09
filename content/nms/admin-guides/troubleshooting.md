---
title: "Troubleshooting"
date: 2023-05-17T15:05:59-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "This topic describes possible issues users might encounter when using the NGINX Management Suite platform. When possible, suggested workarounds are provided."
# Assign weights in increments of 100
weight: 1000
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1221"
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

{{< custom-styles >}}

## System returns "502 Upstream Unavailable" after installation</summary>

#### Description

After installing NGINX Management Suite, when accessing the web interface, the system returns the error "502 Upstream Unavailable."

#### Resolution

If you have SELinux installed, you need to load the SELinux policy module that's included with NGINX Management Suite. For instructions, refer to the [Configure SELinux]({{< relref "/nms/admin-guides/configuration/configure-selinux.md" >}}) topic.

---

## NGINX proxy gateway warns "1024 worker_connections are not enough"</summary>

#### Description

If the NGINX proxy gateway for NGINX Management Suite alerts you that there are not enough worker connections, you may need to modify the NGINX configuration (`/etc/nginx/nginx.conf` on the NGINX Management Suite host) to allow more worker connections and increase the number of file descriptors for worker processes.

#### Resolution

- For guidance on increasing the number of worker connections and file descriptors for the NGINX proxy gateway for NGINX Management Suite, refer to the guide [Optimize NGINX Proxy Gateway for Large Data Planes]({{< relref "/nms/admin-guides/configuration/configure-gateway.md" >}}).

---

## Unable to retrieve entitlements

If you are using a JWT license, make sure to allow inbound and outbound access on port 443 to the following URLs:

- https://product.apis.f5.com
- https://product-s.apis.f5.com/ee

---

## How to Get Support

{{< include "support/how-to-get-support.md" >}}
