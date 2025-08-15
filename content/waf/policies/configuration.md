---
# We use sentence case and present imperative tone
title: "Configuring Policies"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The design intention for this page is to as a single source of truth to replace the two [Configuration]({{< ref "/nap-waf/v4/configuration-guide/configuration.md" >}}) [Guides]({{< ref "/nap-waf/v4/configuration-guide/configuration.md" >}}) (two separate links).

Outside of the overlapping information for Policy configuration, the existing pages also include general configuration information, such as for NGINX App Protect WAF itself. This detail can be added to a separate page, ensuring that each document acts as a solution for exactly one problem at a time.

{{</ call-out>}}

This page describes the security features available with F5 WAF for NGINX and how to enable them.

## Supported Security Policy features