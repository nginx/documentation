---
title: Uninstall with nginx-meshctl
draft: false
toc: true
weight: 200
docs: DOCS-1481
type:
- how-to
---

## Overview

This topic explains how to uninstall F5 NGINX Service Mesh using nginx-meshctl.

## Uninstall

{{< important >}}
OpenShift users: Before uninstalling, read through the [OpenShift considerations]({{< ref "/mesh/get-started/platform-setup/openshift.md#remove" >}}) guide to make sure you understand the implications.
{{< /important >}}

Uninstalling does the following:

1. Removes the control plane and its contents from Kubernetes.
2. Deletes all NGINX Service Mesh traffic policies.

The `nginx-meshctl` command-line utility prints a list of resources that contain the sidecar proxies when the uninstall completes. You must re-roll the Deployments in Kubernetes to remove the sidecars. Until you re-roll the resources, the sidecar proxies still exist, but they don't apply any rules to the traffic.

### Uninstall the Control Plane

To uninstall the Service Mesh control plane using the `nginx-meshctl` command-line utility, run the command shown below.

```bash
nginx-meshctl remove
```

When prompted for confirmation, specify `y` or `n`.
If you want to skip the confirmation prompt, add the `-y` flag as shown in the example below.

```bash
nginx-meshctl remove -y
```

### Remove the Sidecar Proxy from Deployments

If your resources support Rolling Updates (Deployments, DaemonSets, and StatefulSets), run the following `kubectl` command for each resource to complete the uninstall.

```bash
kubectl rollout restart <resource type>/<resource name>
```

For example:

```bash
kubectl rollout restart deployment/frontend
```

{{< note >}}
If you want to redeploy NGINX Service Mesh after removing it, you need to re-roll the resources after the new NGINX Service Mesh is installed. Sidecars from an earlier NGINX Service Mesh installation won't work with a new installation.
{{< /note >}}

## Troubleshooting

In some cases, the `remove` command may fail for unexpected reasons due to environmental, network, or timeout errors. If the `remove` command fails continually, manual intervention may be necessary.

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
