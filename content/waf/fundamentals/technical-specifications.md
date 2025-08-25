---
# We use sentence case and present imperative tone
title: "Technical specifications"
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The design intention for this page is to act as a single source of truth for supported operating systems and version compatibility.

It follows a design pattern set by other NGINX product sets, showing various compatibility matrices:

- [NGINX Plus]({{< ref "/nginx/technical-specs.md" >}})
- [NGINX Instance Manager]({{< ref "/nim/fundamentals/tech-specs.md" >}})
- [NGINX Ingress Controller]({{< ref "/nic/technical-specifications.md" >}})

It is also where information about the [Supported Security Policy Features]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#supported-security-policy-features" >}}) could be referenced, though most of that detail will instead be kept in the new top-level "Policies" section.

{{</ call-out>}}

This page outlines the technical specifications for F5 WAF for NGINX, which includes the minimum requirements and supported platforms.

## Supported deployment environments

You can deploy F5 WAF for NGINX in the following environments:

- **Virtual environment** (or bare metal)
- **Container** (Docker)
- **Kubernetes**

View the [Install section]({{< ref "/waf/install/" >}}) for information on deploying F5 WAF for NGINX.

## Supported operating systems

| Distribution       | Version      |
| ------------------ | ------------ |
| Alpine Linux       | 3.19         |
| Amazon Linux       | 2023         |
| Debian             | 11, 12       |
| Oracle Linux       | 8.1          |
| Ubuntu             | 22.04, 24.04 |
| RHEL / Rocky Linux | 8, 9         |

For release-specific packages, view the [Changelog]({{< ref "/waf/changelog.md" >}}).


### Package dependencies

The F5 WAF for NGINX package has the following dependencies:

| Module name                                | Description |
| ------------------------------------------ | ----------- |
| nginx-plus-module-appprotect               | NGINX Plus dynamic module for F5 WAF for NGINX |
| app-protect-engine                         | The F5 WAF for NGINX enforcement engine        |
| app-protect-plugin                         | The F5 WAF for NGINX connector API between the engine and the NGINX Plus dynamic module |
| app-protect-compiler                       | The F5 WAF for NGINX enforcement engine compiler agent |
| app-protect-common                         | The F5 WAF for NGINX shared libraries package | 
| app-protect-geoip                          | The F5 WAF for NGINX geolocation update package |
| app-protect-graphql                        | The F5 WAF for NGINX shared library package for GraphQL protection |
| app-protect-attack-signatures              | The F5 WAF for NGINX attack signatures update package |
| app-protect-threat-campaigns               | The F5 WAF for NGINX threat campaigns update package |
| app-protect-bot-signatures                 | The F5 WAF for NGINX bot signatures update package |
| app-protect-selinux (**1**)                | The prebuilt SELinux policy module for F5 WAF for NGINX |
| app-protect-ip-intelligence (**1**, **2**) | Necessary for the IP intelligence feature |

1. _Optional dependencies_
2. _This package needs to be installed separately, and includes a client for downloading and updating the feature's database_

## Supported security policy features

The following security policy features are available with F5 WAF for NGINX.

The names link to additional information in the [Configure policies]({{< ref "/waf/policies/configuration.md" >}}) topic.

{{< include "waf/supported-policy-features.md" >}}