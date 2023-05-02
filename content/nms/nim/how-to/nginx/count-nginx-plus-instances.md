---
title: "View Count of NGINX Plus Instances"
date: 2022-06-09T15:27:20-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to track your NGINX Plus inventory and report on usage. Flexible Consumption Program customers may be asked to provide this information."

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

To view a count of your NGINX Plus inventory, you need to:

- Install Instance Manager on a dedicated host.
- Install the NGINX Agent on each NGINX Plus instance.

---

## Prerequisites

- This topic assumes you've installed one or more NGINX Plus instances.

---

## Install Instance Manager {#install-nim}

Instance Manager is part of the NGINX Management Suite.

To view the count of your NGINX Plus inventory, you'll need to install Instance Manager.

- Follow the instructions to [install Instance Manager]({{< relref "/admin-guides/installation/on-prem/install-guide.md" >}}) on a dedicated host. You do not need a license for Instance Manager to view the count of your NGINX Plus instances.

     <details>
     <summary><i class="fa-solid fa-circle-info"></i> Supported NGINX versions</summary>

     {{< include "tech-specs/supported-nginx-versions.md" >}}
     </details>

     <details>
     <summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

     {{< include "tech-specs/nms-supported-distros.md" >}}

     </details>

     <details>
     <summary><i class="fa-solid fa-circle-info"></i> Sizing recommendations</summary>

     {{< include "tech-specs/nim-sizing-standard-deployment.md" >}}

     <br>

     {{<see-also>}}Refer to the [Technical Specifications]({{< relref "tech-specs.md">}}) guide for sizing requirements for larger deployments and other recommended specs.{{</see-also>}}

     </details>

---

## Install the NGINX Agent {#install-nginx-agent}

For your NGINX Plus instances to communicate with Instance Manager, you need to install the NGINX Agent on each instance.

- Follow the instructions to [install the NGINX Agent]({{< relref "/nginx-agent/install-nginx-agent.md" >}}) on each NGINX Plus instance that needs to be counted.

     <details>
     <summary><i class="fa-solid fa-circle-info"></i> Sizing recommendations</summary>

     Ensure enough disk space is available to install the NGINX Agent on each NGINX Plus instance.

     {{< include "tech-specs/agent-sizing-recommendations.md" >}}
     </details>

---

## View Count of NGINX Plus Instances {#view-count}

The current count of NGINX Plus instances is shown on the **NGINX Plus Inventory** page.

1. Open the NGINX Management Suite web interface and log in.
2. In the **Modules** list, select **Instance Manager**.
3. On the sidebar, select **NGINX Plus**.
4. (Optional) To export the list of NGINX Plus instances to a `.csv` file, select **Export**. The exported list of instances is bounded by the page count.

---

## Special Considerations

### Upgrading NGINX Plus {#upgrading-nginx-plus}

- Before upgrading NGINX on the Instance Manager host, verify the newer version is a compatible version of NGINX.
  
    <details>
    <summary><i class="fa-solid fa-circle-info"></i> Supported NGINX versions</summary>

    {{< include "tech-specs/supported-nginx-versions.md" >}}
    </details>

- The NGINX Agent is designed to work with all versions of NGINX Open Source and NGINX Plus. Updating NGINX will not affect the functionality of the NGINX Agent.

### Upgrading Instance Manager

- After [upgrading Instance Manager]({{< relref "admin-guides/installation/upgrade-guide.md#upgrade-instance-manager" >}}), make sure to [upgrade the NGINX Agent](#upgarde-nginx-agent) on each NGINX instance.

### Upgrading the NGINX Agent {#upgrading-nginx-agent}

- Follow the instructions to [upgrade the NGINX Agent on each NGINX instance]({{< relref "/admin-guides/installation/upgrade-guide.md#upgrade-nginx-agent" >}}). We recommend updating to the latest version to ensure an accurate count of your NGINX Plus inventory.

### Counting Instances without the NGINX Agent {#counting-without-nginx-agent}

- The easiest and recommended way to count your NGINX Plus instances is by installing the NGINX Agent on each NGINX Plus instance to be counted.

    If, for some reason, you cannot install the NGINX Agent on each NGINX Plus instance, you can track active NGINX Plus instances in Instance Manager using the [Scan]({{< relref "/nim/how-to/nginx/scan-instances" >}}) feature. However, this method may underreport the number of inactive NGINX Plus instances.

---

## Troubleshooting

- If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nginx-agent/configure-nginx-agent-group.md" >}}).
