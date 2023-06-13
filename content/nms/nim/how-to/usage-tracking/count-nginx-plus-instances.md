---
title: "View Count of NGINX Plus Instances"
date: 2022-06-09T15:27:20-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to track your NGINX Plus inventory and generate usage reports. This information may be required for customers enrolled in the Flexible Consumption Program."

# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-934"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["Installation"]
doctypes: ["task"]
aliases:
- /nim/how-to/count-nginx-plus-instances/
---

{{< custom-styles >}}

{{< shortversions "2.3.0" "latest" "nimvers" >}}

## Overview

This guide will help you track your NGINX Plus instances and their usage. Get started by installing Instance Manager on a dedicated host and the NGINX Agent on each NGINX Plus instance you want to track. You can then use the Instance Manager web interface to view your NGINX Plus inventory and export the list of your NGINX Plus instances if needed.

---

## Prerequisites

### Install Instance Manager {#install-nim}

{{<note>}}You do not need a license for Instance Manager to view the count of your NGINX Plus instances.{{</note>}}

Instance Manager is part of the NGINX Management Suite.

To view your NGINX Plus inventory count, you’ll need to install Instance Manager on a dedicated host.

1. Begin by following the instructions to [install the NGINX Management Suite prerequisites]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md" >}}).
2. Follow the instructions to [install Instance Manager]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}) on a dedicated host. 

### Install NGINX Agent on Each NGINX Plus Instance {#install-nginx-agent}

For your NGINX Plus instances to communicate with Instance Manager, you need to install the NGINX Agent on each instance.

- Follow the instructions to [install the NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}) on each NGINX Plus instance that needs to be counted.

---

## View Count of NGINX Plus Instances {#view-count}

The current count of NGINX Plus instances is shown on the **NGINX Plus Inventory** page.

1. {{< include "nim/webui-nim-login.md" >}}
1. On the left menu, select **NGINX Plus**.
1. (Optional) To export the list of NGINX Plus instances to a `.csv` file, select **Export**. The exported list of instances is bounded by the page count.

---

## Special Considerations

### Counting Instances without the NGINX Agent {#counting-without-nginx-agent}

The easiest and recommended approach to counting your NGINX Plus instances is to install the NGINX Agent on each instance you want to count.

If, for some reason, you cannot install the NGINX Agent on each NGINX Plus instance, you can use the [Scan]({{< relref "/nms/nim/how-to/nginx/scan-instances" >}}) feature in Instance Manager to track your active NGINX Plus instances; however, this method may underreport the number of inactive NGINX Plus instances.

---

## Troubleshooting

If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nms/nginx-agent/configure-nginx-agent-group.md" >}}).
