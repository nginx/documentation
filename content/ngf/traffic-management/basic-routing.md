---
title: Routing traffic to applications
weight: 100
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1426
---

Learn how to route external traffic to your Kubernetes applications using NGINX Gateway Fabric.

## Overview

You can route traffic to your Kubernetes applications using the Gateway API and NGINX Gateway Fabric. Whether you're managing a web application or a REST backend API, you can use NGINX Gateway Fabric to expose your application outside the cluster.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Example application

The application we are going to use in this guide is a simple **coffee** application comprised of one service and two pods:

{{<img src="ngf/img/route-all-traffic-app.png" alt="This image shows a single 'coffee' Service connecting to two 'coffee' Pods.">}}

Using this architecture, the **coffee** application is not accessible outside the cluster. We want to expose this application on the hostname "cafe.example.com" so that clients outside the cluster can access it.

Install NGINX Gateway Fabric and create two Gateway API resources: a [gateway](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1.Gateway) and an [HTTPRoute](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1.HTTPRoute).

Using these resources we will configure a simple routing rule to match all HTTP traffic with the hostname "cafe.example.com" and route it to the **coffee** service.

---

## Set up

Create the **coffee** application in Kubernetes by copying and pasting the following block into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
spec:
  replicas: 2
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

This will create the **coffee** service and a deployment with two pods. Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

Your output should include two **coffee** pods and the **coffee** service:

```text
NAME                          READY   STATUS      RESTARTS   AGE
pod/coffee-7dd75bc79b-cqvb7   1/1     Running     0          77s
pod/coffee-7dd75bc79b-dett3   1/1     Running     0          77s


NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/coffee       ClusterIP   198.51.100.1     <none>        80/TCP    77s
```

---

## Application architecture with NGINX Gateway Fabric

To route traffic to the **coffee** application, we will create a Gateway and HTTPRoute. The following diagram shows the configuration we are creating in the next step:

{{<img src="ngf/img/route-all-traffic-config.png" alt="">}}

We need a Gateway to create an entry point for HTTP traffic coming into the cluster. The **cafe** Gateway we are going to create will open an entry point to the cluster on port 80 for HTTP traffic.

To route HTTP traffic from the Gateway to the **coffee** service, we need to create an HTTPRoute named **coffee** and attach it to the Gateway. This HTTPRoute will have a single routing rule that routes all traffic to the hostname "cafe.example.com" from the Gateway to the **coffee** service.

Once NGINX Gateway Fabric processes the **cafe** Gateway and **coffee** HTTPRoute, it will configure a data plane (NGINX) to route all HTTP requests sent to "cafe.example.com" to the pods that the **coffee** service targets:

{{<img src="ngf/img/route-all-traffic-flow.png" alt="Traffic Flow">}}

The **coffee** service is omitted from the diagram above because the NGINX Pod routes directly to the pods that the **coffee** service targets.

{{< note >}}In the diagrams above, all resources that are the responsibility of the cluster operator are shown in blue. The orange resources are the responsibility of the application developers.

See the [roles and personas](https://gateway-api.sigs.k8s.io/concepts/roles-and-personas/#roles-and-personas_1) Gateway API document for more information on these roles.{{< /note >}}

---

## Create the Gateway API resources

To create the **cafe** gateway, copy and paste the following into your terminal:

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

This Gateway is associated with NGINX Gateway Fabric through the **gatewayClassName** field. The default installation of NGINX Gateway Fabric creates a GatewayClass with the name **nginx**. NGINX Gateway Fabric will only configure Gateways with a **gatewayClassName** of **nginx** unless you change the name via the `--gatewayclass` [command-line flag]({{< ref "/ngf/reference/cli-help.md#controller" >}}).

We specify a [listener](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1.Listener) on the Gateway to open an entry point on the cluster. In this case, since the coffee application accepts HTTP requests, we create an HTTP listener, named **http**, that listens on port 80.

By default, Gateways only allow routes (such as HTTPRoutes) to attach if they are in the same namespace as the Gateway. If you want to change this behavior, you can set
the [**allowedRoutes**](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1.AllowedRoutes) field.

Next you will create the HTTPRoute by copying and pasting the following into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: coffee
spec:
  parentRefs:
  - name: cafe
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: coffee
      port: 80
EOF
```

To attach the **coffee** HTTPRoute to the **cafe** Gateway, we specify the Gateway name in the [**parentRefs**](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1.CommonRouteSpec) field. The attachment will succeed if the hostnames and protocol in the HTTPRoute are allowed by at least one of the Gateway's listeners.

The [**hostnames**](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1.HTTPRouteSpec) field allows you to list the hostnames that the HTTPRoute matches. In this case, incoming requests handled by the **http** listener with the HTTP host header "cafe.example.com" will match this HTTPRoute and will be routed according to the rules in the spec.

The [**rules**](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1.HTTPRouteRule) field defines routing rules for the HTTPRoute. A rule is selected if the request satisfies one of the rule's **matches**. To forward traffic for all paths to the coffee service we specify a match with the PathPrefix "/" and target the coffee service using the **backendRef** field.

---

## Test the configuration

To test the configuration, we will send a request to the public IP and port of the NGINX Service that you saved earlier after creating the Gateway resource and verify that the response comes from one of the **coffee** pods.

{{< note >}}Your clients should be able to resolve the domain name "cafe.example.com" to the public IP of the NGINX Service. In this guide we will simulate that using curl's `--resolve` option. {{< /note >}}


First, let's send a request to the path "/":

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/
```

We should get a response from one of the **coffee** pods:

```text
Server address: 10.12.0.18:8080
Server name: coffee-7dd75bc79b-cqvb7
```

Since the **cafe** HTTPRoute routes all traffic on any path to the **coffee** application, the following requests should also be handled by the **coffee** pods:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/some-path
```

```text
Server address: 10.12.0.18:8080
Server name: coffee-7dd75bc79b-cqvb7
```

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/some/path
```

```text
Server address: 10.12.0.19:8080
Server name: coffee-7dd75bc79b-dett3
```

Requests to hostnames other than "cafe.example.com" should _not_ be routed to the coffee application, since the **cafe** HTTPRoute only matches requests with the "cafe.example.com"need  hostname. To verify this, send a request to the hostname "pub.example.com":

```shell
curl --resolve pub.example.com:$GW_PORT:$GW_IP http://pub.example.com:$GW_PORT/
```

You should receive a 404 Not Found error:

```text
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.25.2</center>
</body>
</html>
```

---

## Troubleshooting

If you have any issues while testing the configuration, try the following to debug your configuration and setup:

- Make sure you set the shell variables $GW_IP and $GW_PORT to the public IP and port of the NGINX Service. Refer to the [Installation]({{< ref "/ngf/install/" >}}) guides for more information.

- Check the status of the gateway:

  ```shell
  kubectl describe gateway cafe
  ```

  The gateway status should look similar to this:

  ```text
  Status:
  Addresses:
    Type:   IPAddress
    Value:  10.244.0.85
  Conditions:
    Last Transition Time:  2023-08-15T20:57:21Z
    Message:               Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2023-08-15T20:57:21Z
    Message:               Gateway is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
  Listeners:
    Attached Routes:  1
    Conditions:
      Last Transition Time:  2023-08-15T20:57:21Z
      Message:               Listener is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2023-08-15T20:57:21Z
      Message:               Listener is programmed
      Observed Generation:   1
      Reason:                Programmed
      Status:                True
      Type:                  Programmed
      Last Transition Time:  2023-08-15T20:57:21Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
      Last Transition Time:  2023-08-15T20:57:21Z
      Message:               No conflicts
      Observed Generation:   1
      Reason:                NoConflicts
      Status:                False
      Type:                  Conflicted
    Name:                    http
  ```

  Check that the conditions match and that the attached routes for the **http** listener equals 1. If it is 0, there may be an issue with the HTTPRoute.

- Check the status of the HTTPRoute:

  ```shell
  kubectl describe httproute coffee
  ```

  The HTTPRoute status should look similar to this:

  ```text
  Status:
    Parents:
      Conditions:
        Last Transition Time:  2023-08-15T20:57:21Z
        Message:               The route is accepted
        Observed Generation:   1
        Reason:                Accepted
        Status:                True
        Type:                  Accepted
        Last Transition Time:  2023-08-15T20:57:21Z
        Message:               All references are resolved
        Observed Generation:   1
        Reason:                ResolvedRefs
        Status:                True
        Type:                  ResolvedRefs
      Controller Name:         gateway.nginx.org/nginx-gateway-controller
      Parent Ref:
        Group:      gateway.networking.k8s.io
        Kind:       Gateway
        Name:       cafe
        Namespace:  default
  ```

  Check for any error messages in the conditions.

- Check the generated nginx config:

  ```shell
  kubectl exec -it -n <nginx-pod-namespace> <nginx-pod-name> -- nginx -T
  ```

  The config should contain a server block with the server name "cafe.example.com" that listens on port 80. This server block should have a single location `/` that proxy passes to the coffee upstream:

  ```nginx configuration
  server {
    listen 80;

    server_name cafe.example.com;

    location / {
        ...
        proxy_pass http://default_coffee_80$request_uri; # the upstream is named default_coffee_80
        ...
    }
  }
  ```

  There should also be an upstream block with a name that matches the upstream in the **proxy_pass** directive. This upstream block should contain the pod IPs of the **coffee** pods:

  ```nginx configuration
  upstream default_coffee_80 {
    ...
    server 10.12.0.18:8080; # these should be the pod IPs of the coffee pods
    server 10.12.0.19:8080;
    ...
  }
  ```

{{< note >}} The entire configuration is not shown because it is subject to change. Ellipses indicate that there's configuration not shown. {{< /note >}}

If your issue persists, [contact us](https://github.com/nginx/nginx-gateway-fabric#contacts).

---

## See also

To learn more about the Gateway API and the resources we created in this guide, check out the following resources:

- [Gateway API Overview](https://gateway-api.sigs.k8s.io/concepts/api-overview/)
- [Deploying a simple Gateway](https://gateway-api.sigs.k8s.io/guides/simple-gateway/)
- [HTTP Routing](https://gateway-api.sigs.k8s.io/guides/http-routing/)
