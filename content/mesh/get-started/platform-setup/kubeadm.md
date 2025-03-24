---
title: Kubeadm
description: Learn how to set up Kubeadm for use with F5 NGINX Service Mesh.
toc: true
docs: DOCS-684
type:
- how-to
---

Kubeadm is a tool that creates Kubernetes clusters by following best practices. To use kubeadm with F5 NGINX Service Mesh, you need to enable some extra flags on the Kubernetes API Server to enable Service Account Token Volume Projection. See [Service Account Token Volume Projection](#service-account-token-volume-projection) section to learn why this is needed.

## New cluster

When creating a new cluster, pass this extra configuration to kubeadm:

```yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
apiServer:
  extraArgs:
    service-account-signing-key-file: /etc/kubernetes/pki/sa.key
    service-account-issuer: api
    service-account-api-audiences: api
```

You can use this configuration as-is and save it to a file, or combine it with any other configuration you need. Pass in the config when initializing the cluster. Assuming you've saved the config as kubeadm.config:

```bash
kubeadm init --config kubeadm.conf
W0817 17:54:27.384011 1526706 configset.go:202] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
[init] Using Kubernetes version: v1.18.8
[preflight] Running pre-flight checks
```

{{< note >}}
You can ignore the warning in the output of `kubeadm init` as we're not providing custom configuration for kubelet or kubeproxy.
{{< /note >}}

## Existing cluster

If you are using an existing kubeadm cluster, add the following configuration to `/etc/kubernetes/manifests/kube-apiserver.yaml`:

{{< note >}}
This will cause the Kubernetes API Server to restart, which may lead to it being unavailable for a short period of time. Be sure to schedule a downtime window before modifying the Kubernetes API Server configuration.
{{< /note >}}

```yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - --service-account-api-audiences=api
    - --service-account-issuer=api
    - --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
```

The configuration will be automatically applied to the kube-api-server.

## Persistent storage

Kubeadm doesn't set up any persistent storage for you, but it's required to run NGINX Service Mesh in a production environment. See [Persistent Storage]( {{< ref "persistent-storage.md" >}} ) for more information.

## Service Account Token Volume Projection

NGINX Service Mesh requires you to enable [Service Account Token Volume Projection](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#service-account-token-volume-projection). With this feature enabled, kubelet will mount a Service Account Token into each pod that is specific to that pod and has an expiration. These Service Account tokens can be used to uniquely identify a specific pod running on a specific node. Without Service Account Token Volume Projection, Service Account tokens are still available but they're shared by all pods under the same service account. There is no way to uniquely identify which pod provided the token.

NGINX Service Mesh uses SPIRE to provide identity and distribute certificates within the mesh. SPIRE works by having a server along with agents that run in a DaemonSet, 1 per node. With Service Account Token Volume Projection we can limit the damage a malicious user can do if they're able to deploy a pod using the SPIRE Agent's Service Account. Since we know the node that pod is deployed on, it only has access to certificates that would be distributed to pods running on that node, as opposed to having access to all certificates cluster-wide.
