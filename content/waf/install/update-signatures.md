---
# We use sentence case and present imperative tone
title: "Update F5 WAF for NGINX signatures"
# Weights are assigned in increments of 100: determines sorting order
weight: 600
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This topic describes how to update F5 WAF for NGINX signatures in a [virtual machine or bare-metal environment]({{< ref "/waf/install/virtual-environment.md" >}}).

For other deployment methods, you should read [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}).

Signatures are divided into three groups:

- [Attack signatures]({{< ref "/waf/policies/attack-signatures.md" >}})
- [Threat campaigns]({{< ref "/waf/policies/threat-campaigns.md" >}})
- Bot signatures

F5 WAF for NGINX signature updates are released at a higher frequency than F5 WAF for NGINX itself, and are subsequently available in their own packages.

A new installation will have the latest signatures available, but F5 WAF for NGINX and the signature packages can be updated independently afterwards.

## Identify and update packages

During installation, the [Platform-specific instructions]({{< ref "/waf/install/virtual-environment.md#platform-specific-instructions" >}}) were used to add the F5 WAF for NGINX repositories to your chosen operating system.

Installing these packages also installed their dependencies, which includes the signature packages. You can use your environment's package manager to update these packages.

They will be named something in the following list:

- `app-protect-attack-signatures`
- `app-protect-threat-campaigns`
- `app-protect-bot-signatures`

You can update these packages independently of the core F5 WAF for NGINX packages, ensuring you always have the latest signatures.