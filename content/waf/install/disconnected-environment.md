---
# We use sentence case and present imperative tone
title: "Deploy F5 WAF for NGINX in a disconnected environment"
# Weights are assigned in increments of 100: determines sorting order
weight: 400
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The term _disconnected environment_ has become the more commmon synonym for an air-gapped or offline installation. It follows the precedent set by NGINX Instance Manager: [Deploy in a disconnected environment -> Install the latest NGINX Instance Manager with a script (disconnected)]({{< ref "/nim/disconnected/offline-install-guide.md" >}}).

The design intention for this page is as a standalone page for the operating system specific installation use cases:

- [v4]({{< ref "/nap-waf/v4/admin-guide/install.md#offline-installation" >}})
- [v5]({{< ref "/nap-waf/v5/admin-guide/install.md#air-gap-install-secure-offline-installation" >}})

Instead of having separate top level folders, differences between v4 and v5 will be denoted with whole page sections, tabs, or other unique signifiers.

{{</ call-out>}}