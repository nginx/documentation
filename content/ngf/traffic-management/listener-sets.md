---
title: ListenerSet API
toc: true
weight: 1500
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-0000
---

Learn how to use the `ListenerSet` API.

## Overview

A `ListenerSet` is a Gateway API type for specifying additional listeners for a Gateway. It decouples network listener configurations—such as ports, hostnames, and TLS termination—from the central Gateway resource and provides a mechanism to merge multiple listeners into a single Gateway. This enables multiple application developer teams who manage their own Services and Routes to configure their own listeners on a Gateway without needing to modify the Gateway itself (which may be owned by a different team).

Additionally, by using ListenerSets, users are able to scale beyond the 64-listener limit of a single Gateway resource.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Set up

Create the `coffee` application in Kubernetes by copying and pasting the following block into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
spec:
  replicas: 1
  selector:
    matchLabels:
      app: coffee
  template:
    metadata:
      labels:
        app: coffee
    spec:
      containers:
      - name: coffee
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: coffee
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: coffee
EOF
```

This will create the `coffee` service and deployment. Run the following command to verify the resources were created:

```shell
kubectl get deployments,svc
```

Your output should include a `coffee` pod and service:

```text
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/coffee   1/1     1            1           7s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/coffee       ClusterIP   10.96.188.209   <none>        80/TCP    7s
```

Create a Gateway:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  listeners:
    - name: http-example
      port: 80
      protocol: HTTP
      hostname: "gateway.example.com"
  allowedListeners:
    namespaces:
      from: Same
EOF
```

By default, Gateways will not allow `ListenerSets` to attach to them, only when `spec.allowedListeners.namespaces.from` is configured to something other than `None` (default), will the Gateway allow `ListenerSets` to attach to it. Additionally, Gateways must have at least one listener specified to be valid, so a Gateway with zero listeners specified with all of its listeners coming from ListenerSets is not a valid scenario.

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic. Verify the gateway is created:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

Verify the status is `Accepted`:

```text
Status:
  Addresses:
    Type:                  IPAddress
    Value:                 10.96.163.87
  Attached Listener Sets:  0
  Conditions:
    Last Transition Time:  2026-05-04T23:36:50Z
    Message:               The Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2026-05-04T23:36:50Z
    Message:               The Gateway is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
```

Save the public IP address and port(s) of the Gateway into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

{{< call-out "note" >}}In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.{{< /call-out >}}

## Configure a ListenerSet

For those that are familiar with the Gateway resource, ListenerSet `spec.listeners` is a direct copy of the Gateway's `spec.listeners`. For more information, view the [API Reference](https://gateway-api.sigs.k8s.io/reference/spec/#listenerset).

Create a ListenerSet:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: ListenerSet
metadata:
  name: listenerset
spec:
  parentRef:
    name: gateway
    kind: Gateway
    group: gateway.networking.k8s.io
  listeners:
  - name: listenerset-http
    port: 80
    protocol: HTTP
    hostname: "coffee.example.com"
    allowedRoutes:
      namespaces:
        from: All
EOF
```

This will create a `ListenerSet` named `listenerset`, attached to the Gateway we created previously, and with a single listener named `listenerset-http`. 

Verify the `ListenerSet` has been configured:

```shell
kubectl describe listenersets.gateway.networking.k8s.io listenerset
```

```text
Status:
  Conditions:
    Last Transition Time:  2026-05-04T23:37:51Z
    Message:               The ListenerSet is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
    Last Transition Time:  2026-05-04T23:37:51Z
    Message:               The ListenerSet is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
```

Verify the Gateway's status has been updated:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

```text
Status:
  Addresses:
    Type:                  IPAddress
    Value:                 10.96.163.87
  Attached Listener Sets:  1
  Conditions:
    Last Transition Time:  2026-05-04T23:37:51Z
    Message:               The Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2026-05-04T23:37:51Z
    Message:               The Gateway is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
```

The `Attached Listener Sets` field should now report `1` as the ListenerSet has attached to it successfully.

## Attach a Route to a ListenerSet

Create an HTTPRoute attached to the ListenerSet:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: listenerset-http-route
spec:
  parentRefs:
  - kind: ListenerSet
    group: gateway.networking.k8s.io
    name: listenerset
    sectionName: listenerset-http
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /coffee
    backendRefs:
    - name: coffee
      port: 80
EOF
```

Verify the HTTPRoute is configured:

```shell
kubectl describe httproutes.gateway.networking.k8s.io listenerset-http-route
```

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-05-04T23:39:36Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-05-04T23:39:36Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          ListenerSet
      Name:          listenerset
      Namespace:     default
      Section Name:  listenerset-http
```

Verify the ListenerSet listener's status has been updated:

```shell
kubectl describe listenersets.gateway.networking.k8s.io listenerset
```

```text
Status:
  Conditions:
    Last Transition Time:  2026-05-04T23:38:36Z
    Message:               The ListenerSet is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
    Last Transition Time:  2026-05-04T23:38:36Z
    Message:               The ListenerSet is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
  Listeners:
    Attached Routes:  1
    Conditions:
      Last Transition Time:  2026-05-04T23:38:36Z
      Message:               The Listener is programmed
      Observed Generation:   1
      Reason:                Programmed
      Status:                True
      Type:                  Programmed
      Last Transition Time:  2026-05-04T23:38:36Z
      Message:               The Listener is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-05-04T23:38:36Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
      Last Transition Time:  2026-05-04T23:38:36Z
      Message:               No conflicts
      Observed Generation:   1
      Reason:                NoConflicts
      Status:                False
      Type:                  Conflicted
    Name:                    listenerset-http
    Supported Kinds:
      Group:  gateway.networking.k8s.io
      Kind:   HTTPRoute
      Group:  gateway.networking.k8s.io
      Kind:   GRPCRoute
```

The `Attached Routes` field should now report `1` as the HTTPRoute has attached to it successfully.

## Send traffic

Send a request to the `coffee` service with this command:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee 
```

```text
Server address: 10.244.0.7:8080
Server name: coffee-654ddf664b-4xdrr
Date: 04/May/2026:23:45:57 +0000
URI: /coffee
Request ID: 7dbd29ec0c783475d50ed3b563b0a8a6
```

## See Also

To set up HTTPS Termination or TLS passthrough on a listener from a `ListenerSet`, the configuration for the listener on the `ListenerSet` should be the same as it is on a Gateway. Follow our [HTTPS Termination]({{< ref "ngf/traffic-management/https-termination.md" >}}) and [TLS passthrough]({{<ref "ngf/traffic-management/tls-passthrough.md" >}}) guides and copy the Gateway listener's configuration onto a `ListenerSet` to mimic the behavior. 

To learn more about the `ListenerSet` Gateway API, see the following resources:

- [ListenerSet Gateway API Description](https://gateway-api.sigs.k8s.io/api-types/listenerset/)
- [ListenerSet Gateway API Guide](https://gateway-api.sigs.k8s.io/guides/listener-set/)
- [ListenerSet API Reference](https://gateway-api.sigs.k8s.io/reference/spec/#listenerset)
- [ListenerSet GEP](https://gateway-api.sigs.k8s.io/geps/gep-1713/)