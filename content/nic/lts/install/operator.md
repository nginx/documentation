---
title: Install NGINX Ingress Controller LTS with NGINX Ingress Operator
toc: true
weight: 600
f5-content-type: how-to
f5-product: INGRESS
---

This document explains how to install F5 NGINX Ingress Controller LTS using NGINX Ingress Operator.

## Before you begin

If you're using NGINX Plus, get the NGINX Ingress Controller LTS JWT and [create a license secret]({{< ref "/nic/lts/install/license-secret.md" >}}).

{{< call-out "note" >}} We recommend installing the latest LTS patch release of NGINX Ingress Controller LTS, available on the GitHub repository's [releases page](https://github.com/nginx/kubernetes-ingress/releases). {{< /call-out >}}

 Make sure you have access to the NGINX Ingress Controller LTS image:

- View the [Download NGINX Ingress Controller LTS from the F5 Registry]({{< ref "/nic/lts/install/images/registry-download" >}}) topic for details on how to pull the image from the F5 Docker registry.
- The [Add an NGINX Ingress Controller LTS image to your cluster]({{< ref "/nic/lts/install/images/add-image-to-cluster.md" >}}) topic describes how to use your subscription JWT token to get the image.
- The [Build NGINX Ingress Controller LTS]({{< ref "/nic/lts/install/build.md" >}}) topic explains how to push an image to a private Docker registry.

Install the NGINX Ingress Operator following the [instructions](https://github.com/nginx/nginx-ingress-helm-operator/blob/main/docs/installation.md).

Create the SecurityContextConstraint as outlined in the ["Getting Started" instructions](https://github.com/nginx/nginx-ingress-helm-operator/blob/main/README.md#getting-started).

{{< call-out "note" >}} If you're upgrading your operator installation to a later release, navigate [here](https://github.com/nginx/nginx-ingress-helm-operator/blob/main/helm-charts/nginx-ingress) and run `kubectl apply -f crds/` or `oc apply -f crds/` as a prerequisite {{< /call-out >}}

## Create the NGINX Ingress Controller LTS manifest

Create a manifest `nginx-ingress-controller.yaml` with the following content:

```yaml
apiVersion: charts.nginx.org/v1alpha1
kind: NginxIngress
metadata:
  name: nginxingress-sample
  namespace: nginx-ingress
spec:
  controller:
    image:
      pullPolicy: IfNotPresent
      repository: private-registry.nginx.com/nginx-ic/nginx-plus-ingress
      tag: 2026-lts-r1
    ingressClass:
      name: nginx
    kind: deployment
    nginxplus: true
    replicaCount: 1
    serviceAccount:
      imagePullSecretName: regcred
```

## Deploy NGINX Ingress Controller LTS

```shell
kubectl apply -f nginx-ingress-controller.yaml
```

A new instance of NGINX Ingress Controller LTS will be deployed by the NGINX Ingress Operator in the `default` namespace with default parameters.

To configure other parameters of the NginxIngressController resource, check the [documentation](https://github.com/nginx/nginx-ingress-helm-operator/blob/main/docs/nginx-ingress-controller.md).

## Troubleshooting

If you experience an `OOMkilled` error when deploying the NGINX Ingress Operator in a large cluster, it's likely because the Helm operator is caching all Kubernetes objects and using up too much memory. If you encounter this issue, try the following solutions:

- Set the operator to only watch one namespace.
- If monitoring multiple namespaces is required, consider manually increasing the memory limit for the operator. Keep in mind that this value might be overwritten after a release update.

We are working with the OpenShift team to resolve this issue.
