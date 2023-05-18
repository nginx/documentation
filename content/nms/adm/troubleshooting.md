---
title: "Troubleshooting"
date: 2023-05-17T15:05:59-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "The topic describes potential issues that platform and app developers may encounter when using the App Delivery Manager module. Suggested workarounds are suggested when possible."
# Assign weights in increments of 100
weight: 
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1138"
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

{{< beta-badge >}}

## Payload Size Exceeds Internal Data Plane Manager (dpm) Max Message Size

For efficiency reasons, NGINX Management Suite uses a 8 MB buffer for inter-service message communication. However, for very large App Delivery Manager deployments, this buffer may not be large enough to accommodate the NGINX configuration for a particular instance group. If this happens, configuration updates will fail with an error message indicating the NATS max buffer size is too small.

#### Workaround

To fix this issue:

1. Edit the `/etc/nms/nms.conf` file and increase the value of the `max_message_bytes`.
2. Restart NGINX Management Suite:

   ```bash
   sudo systemctl restart nms
   ```

#### General Guidance

App Delivery Manager 4.0.0 can handle a maximum of approximately 5,000 App Delivery Manager objects, including Gateways, Web Components, and TCP/UPD Components. This sum is derived from the total number of these objects within a single Instance Group. The specific arrangement of objects, such as having 1 Gateway with 4,999 Web Components or 2,500 Gateways with 1 Web Component each, does not significantly affect the message size. However, the configuration of each object plays a role, depending on the enabled use cases. Other factors influencing the object limit are the average number of workloads and URIs used by each object.

---

## How to Get Support

If you need additional assistance, refer to the following topics for guidance on how to contact Support and create a Support Package:

- [Contact Support]({{< relref "/nms/support/contact-support.md" >}})
- [Create a Support Package]({{< relref "/nms/support/support-package.md" >}})

