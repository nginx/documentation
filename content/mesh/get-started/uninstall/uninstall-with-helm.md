---
title: Uninstall with Helm
draft: false
toc: true
description: This topic explains how to uninstall F5 NGINX Service Mesh using Helm.
weight: 300
nd-docs: DOCS-699
type:
- how-to
---

## Uninstalling the Chart

{{< important >}}
OpenShift users: Before uninstalling, read through the [OpenShift considerations]({{< ref "/mesh/get-started/platform-setup/openshift.md#remove" >}}) guide to make sure you understand the implications.
{{< /important >}}

To uninstall the `nsm` release in the `nginx-mesh` namespace, run:

```bash
helm uninstall nsm --namespace nginx-mesh
```

This command removes most of the Kubernetes components associated with the F5 NGINX Service Mesh release.
Helm does **not** remove the following components:

- CRDs
- `nginx-mesh` namespace
- Spire PersistentVolumeClaim in the `nginx-mesh` namespace

Run this command to remove the CRDS:

```bash
kubectl delete crd -l app.kubernetes.io/part-of==nginx-service-mesh
```

Deleting the namespace will also delete the PersistentVolumeClaim:

```bash
kubectl delete namespace nginx-mesh
```

After uninstalling, re-roll your injected Deployments, DaemonSets, and StatefulSets to remove the sidecar proxy from Pods.

```bash
kubectl rollout restart <resource type>/<resource name>
```

Example:

```bash
kubectl rollout restart deployment/frontend
```

## Troubleshooting

In some cases, the mesh may fail to uninstall for unexpected reasons due to environmental, network, or timeout errors. If the mesh fails to uninstall continually, manual intervention may be necessary.

Run this command to see all resources associated with the mesh currently present in your cluster:

```bash
kubectl api-resources --verbs=list -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -l app.kubernetes.io/part-of=nginx-service-mesh -A
```

### `nginx-mesh` Namespace Stuck "Terminating"

Use the following script to list and patch all Spiffeid resources:

```bash
for ns in $(kubectl get ns | awk '{print $1}' | tail -n +2)
do
if [ $(kubectl get spiffeids -n $ns 2>/dev/null | wc -l) -ne 0 ]
then
    kubectl patch spiffeid $(kubectl get spiffeids -n $ns | awk '{print $1}' | tail -n +2) --type='merge' -p '{"metadata":{"finalizers":null}}' -n $ns
fi
done
```

After patching the Spiffeids the namespace should be removed.

If you are unable to resolve the issues, please reach out to the appropriate [support channel]({{< ref "/mesh/support/contact-support.md" >}}).
