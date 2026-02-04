---
title: Technical specifications
description: NGINX Gateway Fabric technical specifications.
toc: true
weight: 300
nd-content-type: reference
nd-product: FABRIC
nd-docs: DOCS-1842
---

This page describes the technical specifications for NGINX Gateway Fabric.

The information included covers version compatibility between NGINX Gateway Fabric and the Gateway API, as well as other NGINX products.

## NGINX Gateway Fabric versions

The following table lists the software versions NGINX Gateway Fabric supports.

| NGINX Gateway Fabric | Gateway API | Kubernetes | NGINX OSS | NGINX Plus | NGINX Agent |
|----------------------|-------------|------------|-----------|------------|-------------|
| Edge                 | 1.4.1       | 1.25+      | 1.29.4    | R36        | v3.6.2      |
| 2.4.0                | 1.4.1       | 1.25+      | 1.29.4    | R36        | v3.6.2      |
| 2.3.0                | 1.4.1       | 1.25+      | 1.29.3    | R36        | v3.6.0      |
| 2.2.2                | 1.3.0       | 1.25+      | 1.29.2    | R35        | v3.6.0      |
| 2.2.1                | 1.3.0       | 1.25+      | 1.29.2    | R35        | v3.5.0      |
| 2.2.0                | 1.3.0       | 1.25+      | 1.29.2    | R35        | v3.3.2      |
| 2.1.4                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.3.1      |
| 2.1.3                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.3.1      |
| 2.1.2                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.3.1      |
| 2.1.1                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.2.1      |
| 2.1.0                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.2.1      |
| 2.0.2                | 1.3.0       | 1.25+      | 1.28.0    | R34        | v3.0.1      |
| 2.0.1                | 1.3.0       | 1.25+      | 1.28.0    | R34        | v3.0.1      |
| 2.0.0                | 1.3.0       | 1.25+      | 1.28.0    | R34        | v3.0.0      |
| 1.6.2                | 1.2.1       | 1.25+      | 1.27.4    | R33        | ---         |
| 1.6.1                | 1.2.1       | 1.25+      | 1.27.4    | R33        | ---         |
| 1.6.0                | 1.2.1       | 1.25+      | 1.27.3    | R33        | ---         |
| 1.5.1                | 1.2.0       | 1.25+      | 1.27.2    | R33        | ---         |
| 1.5.0                | 1.2.0       | 1.25+      | 1.27.2    | R33        | ---         |
| 1.4.0                | 1.1.0       | 1.25+      | 1.27.1    | R32        | ---         |
| 1.3.0                | 1.1.0       | 1.25+      | 1.27.0    | R32        | ---         |
| 1.2.0                | 1.0.0       | 1.23+      | 1.25.4    | R31        | ---         |
| 1.1.0                | 1.0.0       | 1.23+      | 1.25.3    | n/a        | ---         |
| 1.0.0                | 0.8.1       | 1.23+      | 1.25.2    | n/a        | ---         |

## Gateway API compatibility

The following tables summarizes which Gateway API resources NGINX Gateway Fabric supports and to which level.

You can read more information by viewing the [Gateway API compatibility]({{< ref "/ngf/overview/gateway-api-compatibility.md" >}}) topic, or by selecting the resource name to go directly to the full details.

{{< include "ngf/gateway-api-compat-table.md" >}}