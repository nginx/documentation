---
title: TCPRoute
weight: 1100
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-0000
---

Learn how to configure a TCPRoute to establish a TCP connection between NGINX Gateway Fabric and the backend applications.

## Overview

TCPRoute is a Gateway API resource that is used to configure routing for TCP connections. When attached to a Gateway listener, it forwards connections arriving on the listener’s port to one or more backend Services. In this guide, you will configure two TCPRoutes for **coffee** and **tea** applications, and see how listeners are attached to backends to route TCP traffic.

## Note on Gateway API Experimental Features

{{< call-out "important" >}} TCPRoute is a Gateway API resource from the experimental release channel. {{< /call-out >}}

{{< include "/ngf/installation/install-gateway-api-experimental-features.md" >}}

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with experimental features enabled.

## Setup

Create two simple applications `coffee` and `tea` by copying and pasting the following block into your terminal:

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
  - port: 8081
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: coffee
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tea
  template:
    metadata:
      labels:
        app: tea
    spec:
      containers:
      - name: tea
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: tea
spec:
  ports:
  - port: 8082
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: tea
EOF
```

This creates two Services and Deployments for `coffee` and `tea` applications. Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

```text
NAME                                 READY   STATUS    RESTARTS   AGE
pod/coffee-64f4877d66-22hhn          1/1     Running   0          3m1s
pod/tea-8cf894c7c-d2sfm              1/1     Running   0          3m1s

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
service/coffee          ClusterIP   10.96.168.222   <none>        81/TCP          3m1s
service/tea             ClusterIP   10.96.16.136    <none>        82/TCP          3m1s
```

Create a Gateway with two TCP listeners:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: coffee
    protocol: TCP
    port: 81
    allowedRoutes:
      kinds:
      - kind: TCPRoute
  - name: tea
    protocol: TCP
    port: 82
    allowedRoutes:
      kinds:
      - kind: TCPRoute
EOF
```

This Gateway defines two TCP listeners on ports 81 (coffee) and 82 (tea), and allows only TCPRoute resources to attach to them. After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic. Verify the gateway is created:

```shell
kubectl get gateways.gateway.networking.k8s.io gateway
```

```text
NAME      CLASS   ADDRESS        PROGRAMMED   AGE
gateway   nginx   10.96.83.165   True         17m
```

Save the public IP address and port(s) of the NGINX Service into shell variables. To get the Service, run the following command:

```shell
kubectl get service -n <GATEWAY_NAMESPACE> ${GATEWAY_NAME}
```

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT_1=<port number 1>
GW_PORT_2=<port number 2>
```

{{< call-out "note" >}}In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.{{< /call-out >}}

Create TCPRoutes for routing to `coffee` and `tea` applications:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: tcp-coffee
spec:
  parentRefs:
  - name: gateway
    sectionName: coffee
  rules:
  - backendRefs:
    - name: coffee
      port: 8081
---
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: tcp-tea
spec:
  parentRefs:
  - name: gateway
    sectionName: tea
  rules:
  - backendRefs:
    - name: tea
      port: 8082
EOF
```

This configuration creates two TCPRoutes:
- `tcp-coffee` attaches to the Gateway listener named coffee on port 81 and forwards TCP connections to the **coffee** application.
- `tcp-tea` attaches to the Gateway listener named tea on port 82 and forwards TCP connections to the **tea** application.

Verify the status of the TCPRoutes and they have the `Accepted` condition:

```shell
kubectl describe tcproutes.gateway.networking.k8s.io
```

You should see a similar status for both TCPRoutes `tcp-coffee` and `tcp-tea`:

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-01-09T05:04:15Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-01-09T05:04:15Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          gateway
      Namespace:     default
```

Next, verify that the TCPRoutes are configured by inspecting the NGINX configuration:

```shell
kubectl exec -it -n default deployments/gateway-nginx -- nginx -T
```

The NGINX configuration should look something like:

```text
server {
    listen 81;
    listen [::]:81;
    proxy_pass default_coffee_8081;
}
server {
    listen 82;
    listen [::]:82;
    proxy_pass default_tea_8082;
}
```

## Send traffic

Using the external IP address and ports for the NGINX Service, we can send traffic to our coffee and tea applications.

{{< call-out "note" >}}If you have a DNS record allocated for `cafe.example.com`, you can send the request directly to that hostname, without needing to resolve.{{< /call-out >}}

Send requests to Gateway on different ports and observe which server the response comes from:

```shell
curl -i http://${GW_IP}:${GW_PORT_1}
```

```text
Server address: 10.244.0.81:8080
Server name: coffee-5b9c74f9d9-brlsx
```

```shell
curl -i http://${GW_IP}:${GW_PORT_2}
```

```text
Server address: 10.244.0.82:8080
Server name: tea-859766c68c-scndk
```

Requests sent to port `${GW_PORT_1}` (listener `coffee`) are served by the coffee Service, and requests sent to port `${GW_PORT_2}` (listener `tea`) are served by the tea Service.

## Further Readings

- [TCPRoute](https://gateway-api.sigs.k8s.io/reference/spec/?h=tcproute#tcproute)
