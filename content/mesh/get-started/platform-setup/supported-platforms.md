---
title: Supported Platforms
description: Find out which platforms are supported for use with F5 NGINX Service
  Mesh.
weight: 100
toc: true
docs: DOCS-688
---

## Kubernetes

The Kubernetes platforms listed below will work with F5 NGINX Service Mesh using the Kubernetes versions listed in the [Technical Specifications]({{< ref "/mesh/about/mesh-tech-specs.md#supported-versions" >}}). Additional Kubernetes platforms may work, although they have not been validated.

- Azure Kubernetes Service (AKS)
- Elastic Kubernetes Service (EKS) -- [Additional setup required]( {{< ref "persistent-storage.md" >}} )
- Google Kubernetes Engine (GKE) -- [Additional setup required]( {{< ref "gke.md" >}} )
- Rancher Kubernetes Engine (RKE) -- [Additional setup required]( {{< ref "rke.md" >}} )
- Kubeadm -- [Additional setup required]( {{< ref "kubeadm.md" >}} )
- Kubespray -- [Additional setup required]( {{< ref "kubespray.md" >}} )

## OpenShift

Any self-managed RedHat OpenShift environment running with the versions listed in the [Technical Specifications]({{< ref "/mesh/about/mesh-tech-specs.md#supported-versions" >}}) can be used with NGINX Service Mesh. Externally managed environments such as Azure Red Hat OpenShift and Red Hat OpenShift Service on AWS may work, although they have not been validated.

Before deploying NGINX Service Mesh in OpenShift, see the [OpenShift]({{< ref "/mesh/get-started/platform-setup/openshift.md" >}}) page, which highlights runtime and deployment considerations when using NGINX Service Mesh in OpenShift.
