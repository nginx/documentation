---
title: "Kubernetes Policy Lifecycle Management"
description: "Use Policy Lifecycle Management (PLM) to automate F5 WAF policy compilation and signature updates in Kubernetes."
weight: 300
toc: false
f5-product: F5 WAF for NGINX
f5-content-type: concept
f5-docs: DOCS-000
f5-keywords: "F5 WAF for NGINX, Policy Lifecycle Management, PLM, Kubernetes, NGINX Ingress Controller, NGINX Gateway Fabric"
f5-summary: >
  This page introduces Policy Lifecycle Management (PLM) for F5 WAF for NGINX in Kubernetes.
  PLM automates WAF policy compilation and signature updates using Kubernetes custom resources.
  Select your Kubernetes ingress implementation to deploy PLM.
f5-audience: operator
---

Policy Lifecycle Management (PLM) provides a declarative way to manage F5 WAF for NGINX security policies in Kubernetes.

## How Policy Lifecycle Management works

PLM uses the Kubernetes operator pattern to automate the lifecycle of F5 WAF security artifacts. You do not need to compile policies manually with the [F5 WAF compiler tool]({{< ref "/waf/configure/compiler.md" >}}). Instead, you define policies as Kubernetes custom resources (`APPolicy`, `APLogConf`, and `APUserSig`).

The PLM Policy Controller compiles the custom resources automatically and publishes the compiled bundles to an in-cluster storage service. The data plane then downloads the bundles from storage and enforces them at request time. PLM also delivers automated attack signature updates.

{{< call-out class="note" title="Early access transition" >}}
PLM supersedes the early access preview previously known as Kubernetes operations improvements. If you deployed the early access preview, migrate your configuration using the [Deployment options](#deployment-options).
{{< /call-out >}}

## Deployment options

To use PLM in your cluster, deploy it with your chosen Kubernetes traffic management solution:

- **F5 NGINX Ingress Controller**: For environments that use standard Kubernetes Ingress or NGINX `VirtualServer` resources, see [Install NGINX Ingress Controller with F5 WAF for NGINX using PLM]({{< ref "/nic/install/plm-installation.md" >}}).
- **F5 NGINX Gateway Fabric**: For environments that use the Kubernetes Gateway API (`Gateway` and `HTTPRoute` resources), see [Get started with F5 WAF for NGINX (PLM)]({{< ref "/ngf/waf-integration/get-started-plm.md" >}}).
