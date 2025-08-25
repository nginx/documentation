---
# We use sentence case and present imperative tone
title: "Kubernetes"
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The design intention for this page is to encapsulate the v5+ deployment methods, currently split between the following two pages:

- [Deploy NGINX App Protect WAF with Helm]({{< ref "/nap-waf/v5/admin-guide/deploy-with-helm.md" >}})
- [Deploy NGINX App Protect WAF with Manifests]({{< ref "/nap-waf/v5/admin-guide/deploy-with-manifests.md" >}})

In execution it will probably remain two separate files: the warning banner on top of the page will explicitly indicate what version of NAP the instructions are intended for.

{{</ call-out>}}