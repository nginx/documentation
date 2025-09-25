---
# We use sentence case and present imperative tone
title: "Learn more about related topics"
# Weights are assigned in increments of 100: determines sorting order
weight: i00
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product:
---

## NGINX Plus

### NGINX Plus installation guide

For detailed instructions on installing or upgrading NGINX Plus, visit the [NGINX Plus installation guide]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

### `mgmt` module and directives

For full details about the `mgmt` module and its directives, visit the [Module ngx_mgmt_module reference guide](https://nginx.org/en/docs/ngx_mgmt_module.html).

## NGINX Instance Manager

The instructions below use the terms "internet-connected" and "network-restricted" to describe how NGINX Instance Manager accesses the internet.

### License NGINX Instance Manager

- **Internet-connected**: Follow the steps in [Add license]({{< ref "nim/admin-guide/add-license.md" >}}).
- **Network-restricted**: Follow the steps in [Add a license in a disconnected environment]({{< ref "nim/disconnected/add-license-disconnected-deployment.md" >}}).

### Submit usage reports to F5 from NGINX Instance Manager {#submit-usage-reports-from-nim}

- **Internet-connected**: Follow the steps in [Report usage to F5]({{< ref "nim/admin-guide/report-usage-connected-deployment.md" >}}).
- **Network-restricted**: Follow the steps in [Report usage to F5 in a disconnected environment]({{< ref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).

## NGINX App Protect WAF

For details on installing or upgrading NGINX App Protect WAF, visit the guide for the respective version:

- [NGINX App Protect WAF v4 installation guide]({{< ref "/nap-waf/v4/admin-guide/install.md" >}})
- [NGINX App Protect WAF v5 installation guide]({{< ref "/nap-waf/v5/admin-guide/install.md" >}})

## NGINX App Protect DoS

For detailed instructions on installing or upgrading NGINX App Protect DoS, visit the [NGINX App Protect DoS installation guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}).
