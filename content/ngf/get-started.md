---
title: Get started
weight: 200
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1834
---

{{< important >}}
This document is for trying out NGINX Gateway Fabric, and not intended for a production environment.

For standard deployments, you should read the [Install NGINX Gateway Fabric]({{< ref "/ngf/install/" >}}) section.
{{< /important >}}

This is a guide for getting started with NGINX Gateway Fabric. It explains how to:

- Set up a [kind (Kubernetes in Docker)](https://kind.sigs.k8s.io/) cluster
- Install [NGINX Gateway Fabric](https://github.com/nginx/nginx-gateway-fabric) with [NGINX](https://nginx.org/)
- Test NGINX Gateway Fabric with an example application

By following the steps in order, you will finish with a functional NGINX Gateway Fabric cluster.

## Before you begin

To complete this guide, you need the following prerequisites installed:

- [Go 1.16](https://go.dev/dl/) or newer, which is used by kind
- [Docker](https://docs.docker.com/get-started/get-docker/), for creating and managing containers
- [kind](https://kind.sigs.k8s.io/#installation-and-usage), which allows for running a local Kubernetes cluster using Docker
- [kubectl](https://kubernetes.io/docs/tasks/tools/), which provides a command line interface (CLI) for interacting with Kubernetes clusters
- [Helm 3.0](https://helm.sh/docs/intro/install/) or newer to install NGINX Gateway Fabric
- [curl](https://curl.se/), to test the example application

## Set up a kind cluster

Create the file _cluster-config.yaml_ with the following contents, noting the highlighted lines:

```yaml {linenos=true, hl_lines=[6, 9]}
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 31437
        hostPort: 8080
        protocol: TCP
```

{{< note >}}
The _containerPort_ value is used to later configure a _NodePort_.
{{< /note >}}

Run the following command:

```shell
kind create cluster --config cluster-config.yaml
```

```text
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.31.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Thanks for using kind! 😊
```

{{< note >}}
If you have cloned [the NGINX Gateway Fabric repository](https://github.com/nginx/nginx-gateway-fabric/tree/main), you can also create a kind cluster from the root folder with the following _make_ command:

```shell
make create-kind-cluster
```

{{< /note >}}

## Install NGINX Gateway Fabric

### Add Gateway API resources

Use `kubectl` to add the API resources for NGINX Gateway Fabric with the following command:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v{{< version-ngf >}}" | kubectl apply -f -
```

```text
customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/grpcroutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/referencegrants.gateway.networking.k8s.io created
```

### Install the Helm chart

Use `helm` to install NGINX Gateway Fabric, specifying the NodePort configuration that will be set on the
NGINX Service when it is provisioned:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway --set nginx.service.type=NodePort --set-json 'nginx.service.nodePorts=[{"port":31437,"listenerPort":80}]'
```

{{< note >}}
The port value should equal the _containerPort_ value from _cluster-config.yaml_ [when you created the kind cluster](#set-up-a-kind-cluster). The _listenerPort_ value will match the port that we expose in the Gateway listener.
{{< /note >}}

```text
NAME: ngf
LAST DEPLOYED: Tue Apr 29 14:45:14 2025
NAMESPACE: nginx-gateway
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

## Create an example application

In the previous section, you deployed NGINX Gateway Fabric to a local cluster. This section shows you how to deploy a simple web application to test that NGINX Gateway Fabric works.

{{< note >}}
The YAML code in the following sections can be found in the [cafe-example folder](https://github.com/nginx/nginx-gateway-fabric/tree/main/examples/cafe-example) of the GitHub repository.
{{< /note >}}

### Create the application resources

Run the following command to create the file _cafe.yaml_, which is then used to deploy the *coffee* application to your cluster:

```yaml
cat <<EOF > cafe.yaml
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
kubectl apply -f cafe.yaml
```

```text
deployment.apps/coffee created
service/coffee created
deployment.apps/tea created
service/tea created
```

Verify that the new pods are in the `default` namespace:

```shell
kubectl -n default get pods
```

```text
NAME                      READY   STATUS    RESTARTS   AGE
coffee-676c9f8944-k2bmd   1/1     Running   0          9s
tea-6fbfdcb95d-9lhbj      1/1     Running   0          9s
```

### Create Gateway and HTTPRoute resources

Run the following command to create the file _gateway.yaml_, which is then used to deploy a Gateway to your cluster:

```yaml
cat <<EOF > gateway.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    hostname: "*.example.com"
EOF
kubectl apply -f gateway.yaml
```

```text
gateway.gateway.networking.k8s.io/gateway created
```

Verify that the NGINX deployment has been provisioned:

```shell
kubectl -n default get pods
```

```text
NAME                             READY   STATUS    RESTARTS   AGE
coffee-676c9f8944-k2bmd          1/1     Running   0          31s
gateway-nginx-66b5d78f8f-4fmtb   1/1     Running   0          13s
tea-6fbfdcb95d-9lhbj             1/1     Running   0          31s
```

Run the following command to create the file _cafe-routes.yaml_. It is then used to deploy two *HTTPRoute* resources in your cluster: one each for _/coffee_ and _/tea_.

```yaml
cat <<EOF > cafe-routes.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: coffee
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /coffee
    backendRefs:
    - name: coffee
      port: 80
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: tea
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: Exact
        value: /tea
    backendRefs:
    - name: tea
      port: 80
EOF
kubectl apply -f cafe-routes.yaml
```

```text
httproute.gateway.networking.k8s.io/coffee created
httproute.gateway.networking.k8s.io/tea created
```

### Verify the configuration

You can check that all of the expected services are available using `kubectl get`:

```shell
kubectl -n default get services
```

```text
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
coffee          ClusterIP   10.96.206.93    <none>        80/TCP         2m2s
gateway-nginx   NodePort    10.96.157.168   <none>        80:31437/TCP   104s
kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        142m
tea             ClusterIP   10.96.43.183    <none>        80/TCP         2m2s
```

You can also use `kubectl describe` on the new resources to check their status:

```shell
kubectl -n default describe httproutes
```

```text
Name:         coffee
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  gateway.networking.k8s.io/v1
Kind:         HTTPRoute
Metadata:
  Creation Timestamp:  2025-04-29T19:06:31Z
  Generation:          1
  Resource Version:    12285
  UID:                 c8055a74-b4c6-442f-b3fb-350fb88b2a7c
Spec:
  Hostnames:
    cafe.example.com
  Parent Refs:
    Group:         gateway.networking.k8s.io
    Kind:          Gateway
    Name:          gateway
    Section Name:  http
  Rules:
    Backend Refs:
      Group:
      Kind:    Service
      Name:    coffee
      Port:    80
      Weight:  1
    Matches:
      Path:
        Type:   PathPrefix
        Value:  /coffee
Status:
  Parents:
    Conditions:
      Last Transition Time:  2025-04-29T19:06:31Z
      Message:               The route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2025-04-29T19:06:31Z
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
      Section Name:  http
Events:              <none>


Name:         tea
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  gateway.networking.k8s.io/v1
Kind:         HTTPRoute
Metadata:
  Creation Timestamp:  2025-04-29T19:06:31Z
  Generation:          1
  Resource Version:    12284
  UID:                 55aa0ab5-9b1c-4028-9bb5-4903f05bb998
Spec:
  Hostnames:
    cafe.example.com
  Parent Refs:
    Group:         gateway.networking.k8s.io
    Kind:          Gateway
    Name:          gateway
    Section Name:  http
  Rules:
    Backend Refs:
      Group:
      Kind:    Service
      Name:    tea
      Port:    80
      Weight:  1
    Matches:
      Path:
        Type:   Exact
        Value:  /tea
Status:
  Parents:
    Conditions:
      Last Transition Time:  2025-04-29T19:06:31Z
      Message:               The route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2025-04-29T19:06:31Z
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
      Section Name:  http
Events:              <none>
```

```shell
kubectl -n default describe gateways
```

```text
Name:         gateway
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  gateway.networking.k8s.io/v1
Kind:         Gateway
Metadata:
  Creation Timestamp:  2025-04-29T19:05:01Z
  Generation:          1
  Resource Version:    12286
  UID:                 0baa6e15-55e0-405a-9e7c-de22472fc3ad
Spec:
  Gateway Class Name:  nginx
  Listeners:
    Allowed Routes:
      Namespaces:
        From:  Same
    Hostname:  *.example.com
    Name:      http
    Port:      80
    Protocol:  HTTP
Status:
  Addresses:
    Type:   IPAddress
    Value:  10.96.157.168
  Conditions:
    Last Transition Time:  2025-04-29T19:06:31Z
    Message:               Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2025-04-29T19:06:31Z
    Message:               Gateway is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
  Listeners:
    Attached Routes:  2
    Conditions:
      Last Transition Time:  2025-04-29T19:06:31Z
      Message:               Listener is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2025-04-29T19:06:31Z
      Message:               Listener is programmed
      Observed Generation:   1
      Reason:                Programmed
      Status:                True
      Type:                  Programmed
      Last Transition Time:  2025-04-29T19:06:31Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
      Last Transition Time:  2025-04-29T19:06:31Z
      Message:               No conflicts
      Observed Generation:   1
      Reason:                NoConflicts
      Status:                False
      Type:                  Conflicted
    Name:                    http
    Supported Kinds:
      Group:  gateway.networking.k8s.io
      Kind:   HTTPRoute
      Group:  gateway.networking.k8s.io
      Kind:   GRPCRoute
Events:       <none>
```

## Test NGINX Gateway Fabric

By configuring the cluster with the port `31437`, there is implicit port forwarding from your local machine to NodePort, allowing for direct communication to the NGINX Gateway Fabric service.

You can use `curl` to test the new services by targeting the hostname (_cafe.example.com_) with the _/coffee_ and _/tea_ paths:

```shell
curl --resolve cafe.example.com:8080:127.0.0.1 http://cafe.example.com:8080/coffee
```

```text
Server address: 10.244.0.16:8080
Server name: coffee-676c9f8944-k2bmd
Date: 29/Apr/2025:19:08:21 +0000
URI: /coffee
Request ID: f34e138922171977a79b1b0d0395b97e
```

```shell
curl --resolve cafe.example.com:8080:127.0.0.1 http://cafe.example.com:8080/tea
```

```text
Server address: 10.244.0.17:8080
Server name: tea-6fbfdcb95d-9lhbj
Date: 29/Apr/2025:19:08:31 +0000
URI: /tea
Request ID: 1b5c8f3a4532ea7d7510cf14ffeb27af
```

## Next steps

- [Install NGINX Gateway Fabric]({{< ref "/ngf/install/" >}}), for additional ways to install NGINX Gateway Fabric
- [Traffic management]({{< ref "/ngf/traffic-management/" >}}), for more in-depth traffic management configuration
- [How-to guides]({{< ref "/ngf/how-to/" >}}), for configuring your cluster