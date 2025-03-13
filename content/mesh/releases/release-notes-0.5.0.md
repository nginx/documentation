---
title: Release Notes 0.5.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -500
docs: DOCS-705
type:
- reference
---

## NGINX Service Mesh Version 0.5.0

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 0.5.0, in the following categories:

- [NGINX Service Mesh Version 0.5.0](#nginx-service-mesh-version-050)
  - [Updates](#updates)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-0.5.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< relref "oss-dependencies/index.md" >}})

<span id="050-updates"></a>

### Updates

NGINX Service Mesh 0.5.0 includes the following updates:


- Support for stand-alone (kubeadm) clusters, including VSphere VM clusters.

- Auto-detection of Persistent Volumes (PVs) for SPIRE.

- Image names streamlined (affects deployment scripts).

- Support for non-production environments without persistent volume (not recommended outside of testing)

<span id="050-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues.



- *NGINX Service Mesh may exit during network outages (13295)*



- *Inject does not fully support multiple resources in a single JSON file (13531)*



- *NGINX Service Mesh annotations are validated inconsistently (13927)*



- *On using untested mesh tools or environments (15126)*



- *Running nginx-meshctl returns the error "unable to get mesh config" (15416)*



<span id="050-issues"></a>

### Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/><br/>


**NGINX Service Mesh may drop metrics (12282)**:
  <br/>
  Prometheus and Service Mesh Interface (SMI) metrics may fail to return metrics values in rare cases.

  <br/>
  Workaround:
  <br/><br/>

  If you notice that metrics aren't returned, you should retry the request as the system will self-recover.
