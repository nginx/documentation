---
title: "Troubleshooting"
date: 2023-05-17T15:05:59-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "This topic describes possible issues users might encounter when using API Connectivity Manager. When possible, suggested workarounds are provided."
# Assign weights in increments of 100
weight: 1000
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1222"
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

## System returns `403 Forbidden` error for authorized resources

#### Description

Users are unable to access API Connectivity Manager features that they've been granted permission for.

The system returns errors similar to the following examples:

- Web interface error: "ACM license not found."

- API error: "Error accessing resource: forbidden. Please contact the system administrator. User has not been granted `READ` permission."

#### Resolution

New roles require a minimum of `READ` access for the **Licensing** feature. Without `READ` access for **Licensing**, users will be unable to access pages for which they have been granted permission; instead, the system will return `403 Forbidden` errors as licensing errors.

---

## API Connectivity Manager module doesn't show up in the web interface

#### Description

After installing the API Connectivity Manager module, the module doesn't appear in the NGINX Management Suite web interface.

#### Resolution

- Force refresh the web page.
- Restart the API Connectivity Manager service:

  ```bash
  sudo systemctl restart nms-acm
  ```

---

## Can't delete API Connectivity Manager objects after upgrading NGINX instances

#### Description

After upgrading NGINX Plus instances to R27, you may not be able to delete Environments, Proxies, or Dev Portals in the API Connectivity Manager module.

#### Resolution

Try restarting the NGINX Agent after upgrading NGINX. 

- To restart the NGINX Agent, run the following command:

  ``` bash
  sudo systemctl restart nginx-agent
  ```

---

## How to Get Support

{{< include "support/how-to-get-support.md" >}}

