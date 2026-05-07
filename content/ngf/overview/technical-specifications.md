---
title: Technical specifications
description: NGINX Gateway Fabric technical specifications.
toc: true
weight: 300
f5-content-type: reference
f5-product: FABRIC
f5-docs: DOCS-1842
---

This page describes the technical specifications for NGINX Gateway Fabric.

The information included covers version compatibility between NGINX Gateway Fabric and the Gateway API, as well as other NGINX products.

## NGINX Gateway Fabric versions

The following table lists the software versions NGINX Gateway Fabric supports. Only the latest patch release for each minor version is shown.

| NGINX Gateway Fabric | Gateway API | Kubernetes | NGINX OSS | NGINX Plus | NGINX Agent | F5 WAF for NGINX |
|----------------------|-------------|------------|-----------|------------|-------------|------------------|
| Edge                 | 1.5.1       | 1.31+      | 1.30.0    | R36        | v3.9.1      | 5.12.1           |
| 2.6.0                | 1.5.1       | 1.31+      | 1.30.0    | R36        | v3.9.1      | 5.12.1           |
| 2.5.1                | 1.5.1       | 1.31+      | 1.29.7    | R36        | v3.8.0      | ---              |
| 2.5.0                | 1.5.1       | 1.31+      | 1.29.7    | R36        | v3.8.0      | ---              |
| 2.4.2                | 1.4.1       | 1.25+      | 1.29.5    | R36        | v3.7.1      | ---              |
| 2.4.1                | 1.4.1       | 1.25+      | 1.29.5    | R36        | v3.7.0      | ---              |
| 2.4.0                | 1.4.1       | 1.25+      | 1.29.4    | R36        | v3.6.2      | ---              |
| 2.3.0                | 1.4.1       | 1.25+      | 1.29.3    | R36        | v3.6.0      | ---              |
| 2.2.2                | 1.3.0       | 1.25+      | 1.29.2    | R35        | v3.6.0      | ---              |
| 2.2.1                | 1.3.0       | 1.25+      | 1.29.2    | R35        | v3.5.0      | ---              |
| 2.2.0                | 1.3.0       | 1.25+      | 1.29.2    | R35        | v3.3.2      | ---              |
| 2.1.4                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.3.1      | ---              |
| 2.1.3                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.3.1      | ---              |
| 2.1.2                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.3.1      | ---              |
| 2.1.1                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.2.1      | ---              |
| 2.1.0                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.2.1      | ---              |
| 2.0.2                | 1.3.0       | 1.25+      | 1.28.0    | R34        | v3.0.1      | ---              |
| 2.0.1                | 1.3.0       | 1.25+      | 1.28.0    | R34        | v3.0.1      | ---              |
| 2.0.0                | 1.3.0       | 1.25+      | 1.28.0    | R34        | v3.0.0      | ---              |
| 1.6.2                | 1.2.1       | 1.25+      | 1.27.4    | R33        | ---         | ---              |
| 1.6.1                | 1.2.1       | 1.25+      | 1.27.4    | R33        | ---         | ---              |
| 1.6.0                | 1.2.1       | 1.25+      | 1.27.3    | R33        | ---         | ---              |
| 1.5.1                | 1.2.0       | 1.25+      | 1.27.2    | R33        | ---         | ---              |
| 1.5.0                | 1.2.0       | 1.25+      | 1.27.2    | R33        | ---         | ---              |
| 1.4.0                | 1.1.0       | 1.25+      | 1.27.1    | R32        | ---         | ---              |
| 1.3.0                | 1.1.0       | 1.25+      | 1.27.0    | R32        | ---         | ---              |
| 1.2.0                | 1.0.0       | 1.23+      | 1.25.4    | R31        | ---         | ---              |

### OpenShift Compatibility

The following table lists the OpenShift versions and Operator versions compatible with NGINX Gateway Fabric.

| NGINX Gateway Fabric | Operator | Preferred Gateway API | Compatible Gateway API | OCP with Preferred GWAPI | Supported OCP Versions |
|----------------------|----------|-----------------------|------------------------|--------------------------|------------------------|
| 2.6.0                | v1.4.x   | v1.5.x                | v1.2.1-v1.5.x          | ---                      | 4.19 - 4.21            |
| 2.5.x                | v1.3.x   | v1.5.x                | v1.2.1-v1.5.x          | ---                      | 4.19 - 4.21            |
| 2.4.x                | v1.2.x   | v1.4.x                | v1.2.1-v1.4.x          | 4.20 & 4.21              | 4.19 - 4.21            |
| 2.2.x                | v1.0.x   | v1.3.0                | v1.2.1                 | ---                      | 4.19                   |

NGINX Gateway Fabric is conformant with the Gateway API version installed on supported OCP versions. The "OCP with Preferred GWAPI" column shows which OCP versions ship with the preferred Gateway API version. On OCP versions with an older Gateway API installed, NGF remains fully conformant with that installed version, but features from newer Gateway API versions that NGF supports will be unavailable.

## Gateway API compatibility

The following tables summarizes which Gateway API resources NGINX Gateway Fabric supports and to which level.

You can read more information by viewing the [Gateway API compatibility]({{< ref "/ngf/overview/gateway-api-compatibility.md" >}}) topic, or by selecting the resource name to go directly to the full details.

{{< include "ngf/gateway-api-compat-table.md" >}}