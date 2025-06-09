---
title: Configure Request Mirroring
toc: true
weight: 700
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-000
---

Learn how to mirror your HTTP or gRPC traffic using NGINX Gateway Fabric.

## Overview

[HTTPRoute](https://gateway-api.sigs.k8s.io/api-types/httproute/) and [GRPCRoute](https://gateway-api.sigs.k8s.io/api-types/grpcroute/) filters can be used to configure request mirroring. Mirroring copies a request to another backend.

In this guide, we will set up two applications, **coffee** and **tea**, and mirror requests between them. All requests
sent to the **coffee** application will also be sent to the **tea** application automatically.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Set up

Create the **coffee** and **tea** applications in Kubernetes by copying and pasting the following block into your terminal:

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
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: tea
EOF
```

Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

Your output should include the pods and services for **coffee** and **tea**:

```text
NAME                          READY   STATUS              RESTARTS   AGE
pod/coffee-676c9f8944-dxvkt   0/1     ContainerCreating   0          3s
pod/tea-6fbfdcb95d-xl22n      0/1     ContainerCreating   0          3s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/coffee       ClusterIP   10.96.151.184   <none>        80/TCP    3s
service/tea          ClusterIP   10.96.185.235   <none>        80/TCP    3s
```

---

## Configure request mirroring

First, create the **cafe** Gateway resource:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: cafe
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
EOF
```

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic.

Save the public IP address and port of the NGINX Service into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

{{< note >}}

In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.

{{< /note >}}

Now create an HTTPRoute that defines a RequestMirror filter that copies all requests sent to `/coffee` to be sent to the **coffee** backend and mirrored to the **tea** backend. Use the following command:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: mirror
spec:
  parentRefs:
  - name: cafe
    sectionName: http
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /coffee
    filters:
    - type: RequestMirror
      requestMirror:
        backendRef:
          name: tea
          port: 80
    backendRefs:
    - name: coffee
      port: 80
EOF
```

Test the configuration:

You can send traffic using the external IP address and port saved earlier:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

This request should receive a response from the `coffee` Pod:

```text
Server address: 10.244.0.13:8080
Server name: coffee-676c9f8944-dxvkt
```

Now, check the logs of the **tea** application:

```shell
kubectl logs deployments/tea
```

You should see a log that looks similar to the following:

```text
10.244.0.12 - - [17/Apr/2025:18:44:21 +0000] "GET /coffee HTTP/1.1" 200 158 "-" "curl/8.7.1" "127.0.0.1"
```

This shows that the request to `/coffee` was mirrored to the **tea** application.

## See also

To learn more about request mirroring using the Gateway API, see the following resource:

- [Gateway API request mirroring](https://gateway-api.sigs.k8s.io/guides/http-request-mirroring/)
