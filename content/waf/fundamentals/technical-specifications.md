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

This page outlines the technical specifications for F5 WAF for NGINX, which includes the minimum requirements and supported platforms.

## Resource limitations

- F5 WAF for NGINX supports a **maximum** of **127** CPU cores.

## Supported deployment environments

You can deploy F5 WAF for NGINX in the following environments:

- [**Virtual machine or bare metal**]({{< ref "/waf/install/virtual-environment.md" >}})
- [**Docker**]({{< ref "/waf/install/docker.md" >}})
- [**Kubernetes**]({{< ref "/waf/install/kubernetes.md" >}})

## Supported operating systems

| Distribution       | Version      |
| ------------------ | ------------ |
| Alpine Linux       | 3.19         |
| Amazon Linux       | 2023         |
| Debian             | 11, 12       |
| Oracle Linux       | 8.1          |
| RHEL / Rocky Linux | 8, 9         |
| Ubuntu             | 22.04, 24.04 |

For release-specific packages, view the [Changelog]({{< ref "/waf/changelog.md" >}}).

### Package dependencies

The F5 WAF for NGINX package has the following dependencies:

| Module name                                | Description |
| ------------------------------------------ | ----------- |
| app-protect-attack-signatures              | The F5 WAF for NGINX attack signatures update package |
| app-protect-bot-signatures                 | The F5 WAF for NGINX bot signatures update package |
| app-protect-common                         | The F5 WAF for NGINX shared libraries package |
| app-protect-compiler                       | The F5 WAF for NGINX enforcement engine compiler agent |
| app-protect-engine                         | The F5 WAF for NGINX enforcement engine |
| app-protect-geoip                          | The F5 WAF for NGINX geolocation update package |
| app-protect-graphql                        | The F5 WAF for NGINX shared library package for GraphQL protection |
| app-protect-ip-intelligence (**1**, **2**) | Necessary for the IP intelligence feature |
| app-protect-plugin                         | The F5 WAF for NGINX connector API between the engine and the NGINX Plus dynamic module |
| app-protect-selinux (**1**)                | The prebuilt SELinux policy module for F5 WAF for NGINX |
| app-protect-threat-campaigns               | The F5 WAF for NGINX threat campaigns update package |
| nginx-plus-module-appprotect               | NGINX Plus dynamic module for F5 WAF for NGINX |

1. _Optional dependencies_
1. _This module needs to be installed separately, and includes a client for downloading and updating the feature's database_

## Supported security policy features

The following security policy features are available with F5 WAF for NGINX.

The names link to additional information in the [Policies]({{< ref "/waf/policies/configuration.md" >}}) section.

{{< include "waf/table-policy-features.md" >}}
