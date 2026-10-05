---
title: Set up topology-aware routing
description: "Turn on topology-aware routing so that NGINX Ingress Controller prefers endpoints in its own node or zone when a Service sets trafficDistribution."
weight: 875
toc: true
f5-product: F5 NGINX Ingress Controller
f5-content-type: how-to
f5-keywords: "topology-aware routing, enable-topology-aware-routing, enableTopologyAwareRouting, trafficDistribution, PreferSameZone, PreferSameNode, PreferClose, EndpointSlice hints, topology hints, zone-aware routing, same-zone routing, availability zone, cross-zone traffic, use-cluster-ip, NGINX Ingress Controller"
f5-summary: >
  Turn on the -enable-topology-aware-routing command-line argument, then set the spec.trafficDistribution field on a Kubernetes Service, to make NGINX Ingress Controller send traffic to endpoints on its own node or in its own zone.
  Same-zone routing keeps requests inside one zone, which can lower latency and the cost of cross-zone data transfer.
  Topology-aware routing is off by default and applies to Ingress, VirtualServer, VirtualServerRoute, and TransportServer upstreams, but not to use-cluster-ip upstreams or ExternalName Services.
f5-audience: operator
---

## Overview

F5 NGINX Ingress Controller can follow the `spec.trafficDistribution` field of a Kubernetes Service. With topology-aware routing turned on, each NGINX Ingress Controller pod sends traffic to nearby endpoints of the Service. Nearby endpoints run on the same node or in the same zone as the pod. Same-zone routing keeps requests inside one zone. Keeping requests in one zone can lower latency and the cost of cross-zone data transfer.

Topology-aware routing is off by default. It needs two settings:

- **On NGINX Ingress Controller**: The `-enable-topology-aware-routing` command-line argument. With Helm, set `controller.enableTopologyAwareRouting` to `true`.
- **On each Service**: The `spec.trafficDistribution` field. kube-proxy reads the same field for traffic to the cluster IP of the Service.

The argument applies to the whole controller because the safe use of topology-aware routing depends on where the NGINX Ingress Controller pods run. For example, if all pods run in one zone, all ingress traffic goes to the endpoints in that zone. For more information, see [Spread NGINX Ingress Controller pods across zones](#spread-nginx-ingress-controller-pods-across-zones).

While the argument is off, NGINX Ingress Controller ignores topology hints and uses all ready endpoints.

### Supported upstreams

Topology-aware routing works with NGINX Open Source and F5 NGINX Plus. It applies to the upstreams of these resources:

- Ingress resources
- VirtualServer and VirtualServerRoute resources, including upstreams with a `subselector`
- TransportServer resources

Topology-aware routing doesn't apply to these upstreams:

- Upstreams that use `use-cluster-ip` or the `nginx.org/use-cluster-ip` annotation. kube-proxy already applies the traffic distribution preference to traffic sent to the cluster IP.
- Services of type `ExternalName`. These Services have no EndpointSlices.

### Endpoint selection rules

When a Service sets `spec.trafficDistribution`, the Kubernetes EndpointSlice controller adds topology hints to each endpoint. The `PreferSameNode` value produces node hints. The `PreferSameZone` value and its older alias `PreferClose` produce zone hints. The older `service.kubernetes.io/topology-mode: Auto` annotation also produces zone hints, and NGINX Ingress Controller reads them the same way.

Each NGINX Ingress Controller pod reads the hints when it builds its list of upstream servers. The pod applies the same rules as kube-proxy, in this order:

1. **Node hints**: If every ready endpoint has a node hint, the pod checks for hints that name its own node. If at least one endpoint has such a hint, the pod uses only those endpoints.
1. **Zone hints**: If every ready endpoint has a zone hint, the pod checks for hints that name its own zone. If at least one endpoint has such a hint, the pod uses only those endpoints.
1. **Fallback**: In all other cases, the pod uses all ready endpoints. A Service without `spec.trafficDistribution` gets the same result.

NGINX Ingress Controller filters endpoints only when every ready endpoint has a hint. The EndpointSlice controller writes hints asynchronously, so an EndpointSlice can have hints on only some endpoints during a rollout or a scale event. If NGINX Ingress Controller filtered on a partial set, all traffic would go to the endpoints that got their hints first.

For a VirtualServer upstream with a `subselector`, NGINX Ingress Controller first selects the pods that match the `subselector`. Then it applies the rules to the endpoints of those pods. For example, if the only matching pod runs in another zone, the upstream uses that pod.

---

## Before you begin

Before you begin, make sure you have:

- **Kubernetes 1.34 or later**: These versions accept `PreferSameZone` and `PreferSameNode` by default. On earlier versions, use `PreferClose`.
- **Zone labels on your nodes**: Same-zone routing needs the `topology.kubernetes.io/zone` label on each node. In most cloud clusters, Kubernetes sets this label for you.
- **Permission to list nodes**: NGINX Ingress Controller reads the zone of its own node at startup. The ClusterRole in the Helm chart and in the manifests already grants `list` on nodes.

---

## Turn on topology-aware routing

{{< call-out "important" >}}
Before you turn on topology-aware routing, find the Services that already request topology hints. These Services set `spec.trafficDistribution` or the `service.kubernetes.io/topology-mode: Auto` annotation. After the restart, NGINX Ingress Controller routes these Services by node or by zone.
{{< /call-out >}}

Use the steps for your installation method.

### Turn on topology-aware routing with Helm

1. Set `controller.enableTopologyAwareRouting` to `true` in your release:

    ```shell
    helm upgrade <RELEASE_NAME> oci://ghcr.io/nginx/charts/nginx-ingress --reuse-values --set controller.enableTopologyAwareRouting=true
    ```

    Replace `<RELEASE_NAME>` with the name of your Helm release. Kubernetes then restarts the NGINX Ingress Controller pods with the `-enable-topology-aware-routing` argument.

### Turn on topology-aware routing with manifests

1. Add the argument to the `args` list of the NGINX Ingress Controller container in your Deployment or DaemonSet manifest:

    ```yaml
    args:
      - -enable-topology-aware-routing
    ```

1. Apply the manifest:

    ```shell
    kubectl apply -f <MANIFEST_FILE>
    ```

    Replace `<MANIFEST_FILE>` with the path to your Deployment or DaemonSet manifest. Kubernetes then restarts the NGINX Ingress Controller pods with the argument.

---

## Set traffic distribution on a Service

Set `spec.trafficDistribution` on each Service that you want NGINX Ingress Controller to route by node or by zone.

1. Add the `trafficDistribution` field to the Service manifest:

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: tea-svc
    spec:
      selector:
        app: tea
      ports:
      - port: 80
        targetPort: 8080
      trafficDistribution: PreferSameZone
    ```

    To prefer endpoints on the same node instead, set the value to `PreferSameNode`.

1. Apply the manifest:

    ```shell
    kubectl apply -f tea-svc.yaml
    ```

    The EndpointSlice controller adds hints to the endpoints of the Service. Then NGINX Ingress Controller updates the upstream servers for that Service.

---

## Verify the endpoints that NGINX Ingress Controller uses

1. Check that every endpoint of the Service has a hint:

    ```shell
    kubectl get endpointslices -n <SERVICE_NAMESPACE> -l kubernetes.io/service-name=<SERVICE_NAME> -o yaml
    ```

    Replace `<SERVICE_NAMESPACE>` and `<SERVICE_NAME>` with the namespace and name of your Service. With `PreferSameZone`, each endpoint has a `hints.forZones` entry:

    ```yaml
    hints:
      forZones:
      - name: zone-a
    ```

    With `PreferSameNode`, each endpoint also has a `hints.forNodes` entry.

1. Check the zone that NGINX Ingress Controller detected at startup:

    ```shell
    kubectl logs -n nginx-ingress <NIC_POD_NAME> | grep "Controller node"
    ```

    Replace `<NIC_POD_NAME>` with the name of an NGINX Ingress Controller pod. The output names the node and the zone of the pod:

    ```text
    Controller node: node-1, zone: zone-a
    ```

    If the output is empty, see [Troubleshooting](#troubleshooting).

1. Check the upstream servers in the NGINX configuration:

    ```shell
    kubectl exec -n nginx-ingress <NIC_POD_NAME> -- nginx -T
    ```

    The upstream for the Service lists only the endpoints on the node or in the zone of the pod.

---

## Spread NGINX Ingress Controller pods across zones

Each NGINX Ingress Controller pod filters endpoints for its own node or zone. As a result, pods in different zones have different lists of upstream servers. The backends in a zone get the traffic that the NGINX Ingress Controller pods in that zone receive.

To keep the load even, spread the NGINX Ingress Controller pods across zones in proportion to client traffic. With Helm, use the `controller.topologySpreadConstraints` parameter. With `PreferSameNode`, run NGINX Ingress Controller as a DaemonSet by setting `controller.kind` to `daemonset`. Then each node that runs backends also runs an NGINX Ingress Controller pod.

{{< call-out "important" >}}
NGINX Ingress Controller uses endpoint readiness as the only health signal for topology-aware routing. If same-zone endpoints are ready but fail requests, traffic stays in the zone. Passive health checks (`max-fails`) and NGINX Plus active health checks choose only among the same-zone endpoints. Traffic moves to other zones only after the failed endpoints are no longer ready.
{{< /call-out >}}

NGINX Ingress Controller reads the zone of its node once, at startup. If the `topology.kubernetes.io/zone` label of a node changes, restart the NGINX Ingress Controller pods on that node.

---

## Return to cluster-wide distribution

To make NGINX Ingress Controller send traffic to all ready endpoints again, use one of these options:

- **Turn off topology-aware routing**: Set `controller.enableTopologyAwareRouting` to `false`, or remove the `-enable-topology-aware-routing` argument from your manifest. NGINX Ingress Controller then ignores topology hints for all Services. kube-proxy still applies `spec.trafficDistribution` to traffic sent to the cluster IP.
- **Remove the field**: Remove `trafficDistribution` from the Service manifest, and apply the manifest again. NGINX Ingress Controller then uses all ready endpoints of that Service. kube-proxy also stops preferring nearby endpoints for traffic to the cluster IP.
- **Use a second Service**: To keep the preference for kube-proxy traffic only, create a second Service without `trafficDistribution`. Then point your Ingress, VirtualServer, or TransportServer resources at the second Service.

---

## Troubleshooting

### Traffic goes to endpoints in all zones

**Symptom**: The upstream for a Service lists endpoints from every zone, even though the Service sets `spec.trafficDistribution`.

**Cause**: NGINX Ingress Controller uses all ready endpoints in these cases:

- NGINX Ingress Controller runs without the `-enable-topology-aware-routing` argument.
- At least one ready endpoint has no hint. This state is temporary during a rollout or a scale event.
- No hint names the zone or the node of the NGINX Ingress Controller pod.
- NGINX Ingress Controller couldn't detect its zone at startup.
- The upstream uses `use-cluster-ip`, or the Service is of type `ExternalName`.

**Fix**: Make sure that NGINX Ingress Controller runs with the argument, as described in [Turn on topology-aware routing](#turn-on-topology-aware-routing). Then check the hints and the detected zone with the steps in [Verify the endpoints that NGINX Ingress Controller uses](#verify-the-endpoints-that-nginx-ingress-controller-uses). For missing hints, wait for the EndpointSlice controller to finish. For a failed zone detection, see the next entry.

To see the mode that NGINX Ingress Controller chooses for each upstream, set the log level to `debug`. Use the `-log-level` argument or the `controller.logLevel` Helm parameter. For each Service whose endpoints have hints, the log contains a line with `topology mode`. The line names `PreferSameNode`, `PreferSameZone`, or `none, hints ignored`, and the number of ready endpoints in use.

### Zone detection fails at startup

**Symptom**: The log of an NGINX Ingress Controller pod contains one of these warnings:

```text
Pod has no spec.nodeName; topology-aware routing using EndpointSlice hints is unavailable
Failed to list node <NODE_NAME> for zone detection: <ERROR>; same-zone routing using EndpointSlice hints is unavailable
Node <NODE_NAME> has no topology.kubernetes.io/zone label; same-zone routing using EndpointSlice hints is unavailable
Node <NODE_NAME> not found for zone detection; same-zone routing using EndpointSlice hints is unavailable
```

**Cause**: NGINX Ingress Controller couldn't read the zone of its node. NGINX Ingress Controller keeps running, but same-zone routing is off. Same-node routing still works, except when the pod has no `spec.nodeName`.

**Fix**: Check the cause that the warning names:

- For a failed node lookup, make sure the ClusterRole of NGINX Ingress Controller grants `list` on nodes.
- For a missing label, add the `topology.kubernetes.io/zone` label to the node.
- For a node that isn't found, check that the node of the pod still exists.

After the fix, restart the NGINX Ingress Controller pod.

---

## References

For more information, see:

- [Command-line arguments]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md" >}})
- [VirtualServer and VirtualServerRoute resources]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources.md" >}})
- [TransportServer resource]({{< ref "/nic/configuration/transportserver-resource.md" >}})
- [Helm installation parameters]({{< ref "/nic/install/helm/parameters.md" >}})
- [Traffic distribution in the Kubernetes documentation](https://kubernetes.io/docs/reference/networking/virtual-ips/#traffic-distribution)
