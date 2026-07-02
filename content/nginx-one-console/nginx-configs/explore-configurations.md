---
title: Explore configurations with Config Explorer
description: "Use Config Explorer to browse and search your NGINX configurations as an interactive node graph."
f5-product: NGINX One Console
f5-content-type: howto
f5-docs: DOCS-000
f5-keywords: "Config Explorer, NGINX One Console, staged configurations, instances, config sync groups, node graph"
f5-summary: >
  Use Config Explorer to visualize and navigate any NGINX configuration as an interactive node graph in NGINX One Console.
  Config Explorer lets you browse directive contexts, inspect properties and inline documentation, and search across all directives.
  Config Explorer is available for Staged Configurations, Instances, and Config Sync Groups.
f5-audience: any
toc: true
weight: 450
---

## Overview

Config Explorer is an interactive view for any NGINX configuration in NGINX One Console. Instead of reading raw configuration files, you can navigate your entire NGINX configuration hierarchy as a visual node graph. Each node in the graph represents a directive context — such as `main`, `http`, `upstream`, `server`, or `location` — and you can select any node to inspect its properties and documentation.

Config Explorer is available on the detail page of the following resources:

- Staged Configurations
- Instances
- Config Sync Groups

---

## Before you begin

Before you begin, ensure you have:

- **An NGINX One Console account**: You must have access to NGINX One Console and permission to view the resource you want to explore.

---

## Open Config Explorer

### Open Config Explorer for a Staged Configuration

1. On the left menu, select **Staged Configurations**.
2. Select the Staged Configuration you want to explore.
3. Select the **Explorer** tab.

### Open Config Explorer for an Instance

1. On the left menu, select **Instances**.
2. Select the instance you want to explore.
3. Select the **Explorer** tab.

### Open Config Explorer for a Config Sync Group

1. On the left menu, select **Config Sync Groups**.
2. Select the Config Sync Group you want to explore.
3. Select the **Explorer** tab.

---

## Browse the configuration

When Config Explorer opens, it displays your NGINX configuration as an interactive node graph on the canvas.

1. Use the **view filter** in the toolbar to narrow the graph to a specific directive type, such as Upstreams or HTTP. The directive count next to the filter updates to reflect the current view.

2. Select any node in the graph to open its **Properties** panel on the right. The Properties panel shows:
   - The breadcrumb path of the selected directive within the configuration hierarchy.
   - The source file and line reference.
   - The parsed field values for the directive, such as host, port, and flags.
   - **Children** — an expandable list of child directives.
   - **Docs** — inline NGINX documentation for the selected directive, including its syntax, default value, valid contexts, and a plain-English description.

3. Use the scroll and zoom controls in the lower-left corner of the canvas to pan and zoom the graph.

4. Review the **Directives** bar at the bottom of the canvas for a color-coded breakdown of all directive types and their counts in the current view.

---

## Search for directives

1. Select the **Search** bar in the toolbar.

2. Type any term to search across all directives in the configuration. Config Explorer searches the graph in real time and highlights matching nodes.

3. Matching results appear in a dropdown list showing the full breadcrumb path of each match. The counter in the search bar, for example `7/12`, shows your current position in the result set and the total number of matches.

4. Use the arrow keys or select a result from the dropdown to navigate between matches. Config Explorer moves focus to the matching node in the graph and updates the Properties panel.

5. Select the clear button in the search bar or press **Escape** to close the search results.

---

## References

For more information, see:

- [View and edit a Staged Configuration]({{< ref "/nginx-one-console/nginx-configs/staged-configs/edit-staged-config.md" >}})
- [Manage Config Sync Groups]({{< ref "/nginx-one-console/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}})
- [View and edit an NGINX instance]({{< ref "/nginx-one-console/nginx-configs/one-instance/view-edit-nginx-configurations.md" >}})
