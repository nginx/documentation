---
title: Rancher Kubernetes Engine
description: Learn how to set up Rancher Kubernetes Engine (RKE) for use with F5 NGINX
  Service Mesh.
toc: true
nd-docs: DOCS-687
type:
- how-to
---

Rancher Kubernetes Engine (RKE) is a CNCF-certified Kubernetes distribution that runs entirely within Docker containers. It works on bare-metal and virtualized servers.

{{< important >}}
Before deploying F5 NGINX Service Mesh, ensure that no other service meshes exist in your Kubernetes cluster.
{{< /important >}}

{{< warning >}}
Rancher has the option to deploy the community [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx) when configuring an RKE cluster. While this ingress controller may work, NGINX Service Mesh does not guarantee support. It is recommended to use the [NGINX Plus Ingress Controller]({{< ref "/mesh/tutorials/kic/deploy-with-kic.md" >}}) in conjunction with NGINX Service Mesh.
{{< /warning >}}

## Persistent storage

RKE doesn't set up any persistent storage for you, but it's required to run NGINX Service Mesh in a production environment. See [Persistent Storage]( {{< ref "persistent-storage.md" >}} ) for more information.

## Pod Security Policies

When creating a new cluster with RKE, you can configure it to apply a [PodSecurityPolicy](https://kubernetes.io/docs/concepts/policy/pod-security-policy/). If you choose to do this, NGINX Service Mesh requires a few permissions in order to function properly. The following policy is based on the default `restricted-psp` policy used by RKE, with a few additions and changes to allow the NGINX Service Mesh control plane to work.

{{< important >}}
When running a cluster with a PodSecurityPolicy, all of the following resources need to be created/updated before deploying NGINX Service Mesh.
{{< /important >}}

```yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  annotations:
    serviceaccount.cluster.cattle.io/pod-security: restricted
    serviceaccount.cluster.cattle.io/pod-security-version: "1696"
  labels:
    cattle.io/creator: norman
  name: restricted-psp-nginx-mesh
spec:
  allowPrivilegeEscalation: false
  fsGroup:
    ranges:
    - max: 65535
      min: 1
    rule: MustRunAs
  requiredDropCapabilities:
  - ALL
  runAsUser:
    rule: RunAsAny
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    ranges:
    - max: 65535
      min: 1
    rule: MustRunAs
  hostNetwork: true
  hostPID: true
  volumes:
  - configMap
  - emptyDir
  - projected
  - secret
  - downwardAPI
  - persistentVolumeClaim
  - hostPath
```

In order for the NGINX Service Mesh sidecar init container to be able to configure `iptables` rules and BPF programs needed for UDP communication, it needs `NET_ADMIN`, `NET_RAW`, `SYS_RESOURCE`, and `SYS_ADMIN` capabilities.

If a PodSecurityPolicy is applied to your workloads, then the following additions need to be made in order for the sidecar to work properly:

```yaml
spec:
  allowedCapabilities:
  - NET_ADMIN
  - NET_RAW
  - SYS_RESOURCE
  - SYS_ADMIN
```

{{< important >}}
If you have separate PodSecurityPolicies for the control plane and your workloads, ensure that they are [bound to the proper Service Accounts](#bind-the-policy).
{{< /important >}}

### Bind the Policy

The `restricted-psp-nginx-mesh` policy needs to be bound to the NGINX Service Mesh control plane namespace, using the following resources:

{{< note >}}
The ClusterRoleBinding assumes the default namespace of `nginx-mesh`, but should be changed if you are using a different namespace for the control plane.
{{< /note >}}

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: nginx-mesh-psp-role
rules:
- apiGroups: ['policy']
  resources: ['podsecuritypolicies']
  verbs:     ['use']
  resourceNames:
  - restricted-psp-nginx-mesh
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: nginx-mesh-psp-binding
roleRef:
  kind: ClusterRole
  name: nginx-mesh-psp-role
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: Group
  apiGroup: rbac.authorization.k8s.io
  name: system:serviceaccounts:nginx-mesh
  ```
