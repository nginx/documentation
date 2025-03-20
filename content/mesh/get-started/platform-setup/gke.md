---
title: Google Kubernetes Engine
description: Learn how to set up Google Kubernetes Engine (GKE) for use with F5 NGINX
  Service Mesh.
toc: true
docs: DOCS-683
type:
- how-to
---

Google Kubernetes Engine (GKE) is a hosted Kubernetes solution created by Google. To use GKE with F5 NGINX Service Mesh, your Kubernetes user account has to have the `ClusterAdmin` role.

{{< warning >}}
These resources give NGINX Service Mesh administrator access to your cluster. This allows NGINX Service Mesh to access resources across all namespaces in your Kubernetes cluster.
{{< /warning >}}

To create a ClusterRole and ClusterRoleBinding for NGINX Service Mesh, run the `kubectl` command shown below:

```bash
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config  get-value core/account)
```

Regardless of which Kubernetes version you are using, if you are installing NGINX Service Mesh v1.6 or greater, you'll also need to install the  [gke-gcloud-auth-plugin](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke). This is because `nginx-meshctl` uses Kubernetes v1.25+ libraries internally.

You can now deploy NGINX Service Mesh on your GKE cluster.
