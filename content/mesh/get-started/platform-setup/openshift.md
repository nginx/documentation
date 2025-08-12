---
title: OpenShift
description: Learn what is different in OpenShift, and the considerations a user must
  make.
toc: true
nd-docs: DOCS-689
type:
- how-to
---

## Introduction

OpenShift is a security-first platform, locking down privileges and capabilities to ensure that workloads are running securely. OpenShift creates additional security mechanisms in the form of [security context constraints](https://docs.openshift.com/container-platform/4.8/authentication/managing-security-context-constraints.html). These constraints restrict the default permissions a workload is able to operate with. It also needs a user or workload management tool (such as a service mesh) to iteratively build out the specific permissions.

To provide an increased level of security, F5 NGINX Service Mesh provides the security context constraints needed to run its control plane components as well as the sidecar attached to every workload under its management. Additionally, a mechanism (Container Storage Interface (CSI) Driver) to more securely mount workloads into these sidecars was developed. More information about the CSI Driver can be found [here](https://kubernetes-csi.github.io/docs/introduction.html). This document serves as a small introduction to CSI Drivers, and the considerations for use with NGINX Service Mesh.

## Installation and Removal

Using a CSI Driver comes with some considerations for the user on installation and removal.

### Install

The NGINX Service Mesh deployment experience is the exact same as in other environments. Simply add the `--environment openshift` flag when deploying the mesh, and the CSI Driver and security context constraints will be set up for you.

```bash
nginx-meshctl deploy ... --environment openshift"
```

When injecting sidecars into your workloads, OpenShift's default security policies do not allow the necessary permissions. To enable the proper permissions for sidecar injection, you can attach your workloads to the `nginx-mesh-sidecar-permissions` SecurityContextConstraint (SCC) by running:

```bash
oc adm policy add-scc-to-group nginx-mesh-sidecar-permissions system:serviceaccounts:<workload-namespace>
```

### Remove

When removing NGINX Service Mesh, the CSI Driver should be running until all injected Pods are either re-rolled to remove the sidecar proxy, or terminated. This is because the CSI Driver must unmount and service any injected Pods when they are terminated.

NGINX Service Mesh makes it easy by detecting whether any of the injected Pods are still running. If no injected Pods are found, the whole mesh is cleanly removed. If it does find any remaining injected Pods, some components are left after the rest of the mesh is removed in order to service them. A Job called `csi-driver-sentinel` is created in the NGINX Service Mesh namespace to watch for all injected Pods to be cleaned up. Once all of the injected Pods are either re-rolled or deleted, the `csi-driver-sentinel` Job will remove all of the remaining NGINX Service Mesh components.

If any errors occur, removal of the remaining NGINX Service Mesh resources may require manual intervention. In this case, you can run the following commands to ensure all of the mesh components are removed:

```bash
kubectl delete ns <mesh-namespace>
kubectl delete clusterrole system:openshift:scc:nginx-mesh-spire-agent-permissions
kubectl delete scc nginx-mesh-spire-agent-permissions
kubectl delete clusterrolebinding csi-driver-sentinel.builtin.nsm.nginx
```

{{< call-out "note" >}}
To re-install NGINX Service Mesh, it is not necessary to re-roll or delete injected Pods before removing the CSI Driver. Simply run the removal commands listed in the snippet above and deploy NGINX Service Mesh as usual. The new CSI Driver that is deployed will be able to handle any injected Pods leftover from the previous deployment.
{{< /call-out >}}

## How The CSI Driver Works

A CSI Driver is powerful as it allows fine-grained volume control within your cluster. In NGINX Service Mesh, we needed a more secure way to publish the Spire Agent workload API socket to the sidecars in the mesh. For more information on the Spire architecture, and how the Spire Agent distributes certificates, see the [Spire]({{< ref "/mesh/about/architecture.md#spire" >}}) section of our architecture doc. Existing techniques involve mounting the socket to the host via a hostPath volume mount. While this works well functionally, it presents some security concerns as it allows workload access to the node.

For OpenShift -- where container security is paramount -- using a hostPath volume mount on every injected Pod is not reasonable. A CSI Driver provides the ability to control exactly how information is shared between resources in your cluster, without every workload needing to use a hostPath.

Under a CSI approach, there is only one Pod that needs to run a hostPath volume -- the Spire Agent. The agent requires a hostPath to register itself securely with `kubelet` running on that node. A hostPath is also used to share the directory hosting the workload API socket between the CSI Driver and the Spire Agent.

Once registered with `kubelet`, every time an injected Pod spins up requesting a spire agent socket, the CSI Driver mounts the socket to the Pod's CSI volume. In addition to this, it registers itself with `kubelet` as being required for the unmounting step on injected Pod termination. Without a CSI Driver to service termination events, `kubelet` would have no way of knowing how to handle unmounting the CSI data.
