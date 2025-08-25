---
# We use sentence case and present imperative tone
title: "Docker"
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The design intention for this page is as a standalone page for the operating system specific installation use cases:

- [v4]({{< ref "/nap-waf/v4/admin-guide/install.md#docker-deployments" >}})
- [v5]({{< ref "/nap-waf/v5/admin-guide/install.md#waf-services-configuration" >}})

Instead of having separate top level folders, differences between v4 and v5 will be denoted with whole page sections, tabs, or other unique signifiers.

This reduces the amount of duplicate content, which makes maintainability much simpler and the text more uniform.

With the full context of this section, the page is shorter, being concerned only with one specific method of installation.

This makes it easier to link to specific instructions, and ensures that the customer sees only the critical information they need.

{{</ call-out>}}