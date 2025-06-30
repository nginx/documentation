---
title: Release Notes 1.2.1
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs). Lists of new features and known issues are provided.
weight: -1201
nd-docs: DOCS-715
type:
- reference
---

## NGINX Service Mesh Version 1.2.1

11 October 2021

<!-- vale off -->

This hotfix release resolves an issue affecting version 1.2.0 described below.

**Update packaged version of Grafana to v8.1.7 to address CVE-2021-39226 (29195)**:

Updates the packaged version of Grafana to v8.1.7. This update incorporates the fix for [CVE-2021-39226](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-39226), which affects Grafana's snapshot feature in versions 2.0.1 to 8.1.5.  See the [upgrade guide]({{< ref "/mesh/get-started/upgrade/upgrade.md#nginx-service-mesh-101" >}}) for instructions on upgrading.
