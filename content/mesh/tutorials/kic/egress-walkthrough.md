---
title: Configure a Secure Egress Route with NGINX Ingress Controller
description: This topic provides a walkthrough of how to securely route egress traffic
  through F5 NGINX Ingress Controller for Kubernetes with NGINX Service Mesh.
weight: 210
toc: true
nd-docs: DOCS-722
type:
- tutorial
---

## Overview

Learn how to create internal routes in F5 NGINX Ingress Controller to securely route egress traffic to non-meshed services.
{{< call-out "note" >}}
NGINX Ingress Controller can be used for free with NGINX Open Source. Paying customers have access to NGINX Ingress Controller with NGINX Plus.
To complete this tutorial, you must use either:

- Open Source NGINX Ingress Controller version 3.0+
- NGINX Plus version of NGINX Ingress Controller

{{< /call-out >}}

## Objectives

Follow this tutorial to deploy the NGINX Ingress Controller with egress enabled, and securely route egress traffic from a meshed service
to a non-meshed service.

## Before You Begin

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
1. Download the example files:

    - {{< icon "download" >}} {{< link "/examples/traffic-split/target-v1.0.yaml" "target-v1.0.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/egress-driver.yaml" "egress-driver.yaml" >}}

## Install NGINX Service Mesh

{{< call-out "note" >}}
If you want to view metrics for NGINX Ingress Controller, ensure that you have deployed Prometheus and Grafana and then configure NGINX Service Mesh to integrate with them when installing. Refer to the [Monitoring and Tracing]( {{< ref "/mesh/guides/monitoring-and-tracing.md" >}} ) guide for instructions.
{{< /call-out >}}

1. Follow the installation [instructions]( {{< ref "/mesh/get-started/install/install.md" >}} ) to install NGINX Service Mesh on your Kubernetes cluster.

    - When deploying the mesh set the [mTLS mode]( {{< ref "/mesh/guides/secure-traffic-mtls.md" >}} ) to `strict`.
    - Your deploy command should contain the following flags:

      ```bash
      nginx-meshctl deploy ... --mtls-mode=strict
      ```

1. Get the config of the mesh and verify that `mtls.mode` is `strict`:

    ```bash
    nginx-meshctl config
    ```

## Create an Application Outside of the Mesh

The `target` application is a basic NGINX server listening on port 80. It returns a "target version" value, which is `v1.0`.

1. Create a namespace, `legacy`, that will not be managed by the mesh:

    ```bash
    kubectl create namespace legacy
    ```

1. Create the `target` application in the `legacy` namespace:

    ```bash
    kubectl -n legacy apply -f target-v1.0.yaml
    ```

1. Verify that the target application is running and the target pod is not injected with the sidecar proxy:

    ```bash
    kubectl -n legacy get pods,svc

    NAME                               READY   STATUS    RESTARTS   AGE
    pod/target-v1-0-5985d8544d-sgkxg   1/1     Running   0          12s

    NAME                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
    service/target-v1-0   ClusterIP   10.0.0.0       <none>        80/TCP    11s
    ```

### Send traffic to the target application

1. Enable [automatic sidecar injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) for the `default` namespace.
1. Create the `sender` application in the `default` namespace:

    ```bash
    kubectl apply -f egress-driver.yaml
    ```

1. Verify that the `egress-driver` pod is injected with the sidecar proxy.

    ```bash
    kubectl get pods -o wide

    NAME                             READY   STATUS    RESTARTS   AGE    IP           NODE        NOMINATED NODE   READINESS GATES
    egress-driver-5587fbdf78-hm4w6   2/2     Running   0          5s     10.1.1.1     node-name   <none>           <none>
    ```

    The `egress-driver` Pod will automatically send requests to the `target-v1-0.legacy` Service. Once started, the script will delay for 10 seconds and then begin to send requests.

1. Check the Pod logs to verify that the requests are being sent:

    ```bash
    kubectl logs -f -c egress-driver <EGRESS_DRIVER_POD>
    ```

    **Expectation:**

    You should see the `egress-driver` is not able to reach `target`. The script employs a verbose curl command that also displays connection and HTTP information. For example:

    ```bash
    *   Trying 10.16.14.126:80...
    * Connected to target-v1-0.legacy (10.16.14.126) port 80 (#0)
    > GET / HTTP/1.1
    > Host: target-v1-0.legacy
    > User-Agent: curl/7.72.0-DEV
    > Accept: */*
    >
    * Received HTTP/0.9 when not allowed

    * Closing connection 0
    ```

1. Use the top command to check traffic metrics:

    ```bash
    nginx-meshctl top deploy/egress-driver
    ```

    **Expectation:** No traffic metrics are populated!

    ```bash
    Cannot build traffic statistics.
    Error: no metrics populated - make sure traffic is flowing
    exit status 1
    ```

The `egress-driver` application is unable to reach the `target` Service because it is not injected with the sidecar proxy. We are running with `--mtls-mode=strict` which restricts the `egress-driver` to communicating using mTLS with other injected pods. As a result we cannot build traffic statistics for these requests.

Now, let's use NGINX Ingress Controller to create a secure internal route from the `egress-driver` application to the `target` Service.

### Install NGINX Ingress Controller

1. [Install the NGINX Ingress Controller]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#install-nginx-ingress-controller-with-mtls-enabled">}} ). This tutorial will demonstrate installation as a Deployment.
    - Follow the instructions to [enable egress]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#enable-egress" >}} )

1. Verify the NGINX Ingress Controller is running:

    ```bash
    kubectl -n nginx-ingress get pods,svc -o wide

    NAME                                READY   STATUS    RESTARTS   AGE    IP           NODE          NOMINATED NODE   READINESS GATES
    pod/nginx-ingress-c6f9fb95f-fqklz   1/1     Running   0          5s     10.2.2.2     node-name     <none>           <none>
    ```

Notice that we do not have a Service fronting NGINX Ingress Controller. This is because we are using NGINX Ingress Controller for egress only, which means we don't need an external IP address.
The sidecar proxy will route egress traffic to the NGINX Ingress Controller's Pod IP.

### Create an internal route to the legacy target service

To create an internal route from the NGINX Ingress Controller to the legacy `target` Service, we need to create either:

- an Ingress resource with the annotation `nsm.nginx.com/internal-route: "true"`.
- a VirtualServer resource with the following field added to the custom resource definition:

   ```yaml
   spec:
     internalRoute: true
   ```

{{< call-out "tip" >}}
For this tutorial, the legacy Service is deployed in Kubernetes so the host name of the Ingress/VirtualServer resource is the Kubernetes
DNS name.

To create internal routes to services outside of the cluster, refer to [creating internal routes]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#create-internal-routes-for-non-meshed-services" >}} ).
{{< /call-out >}}

Either copy and apply the Ingress or VirtualServer resource shown below, or download and apply the linked file.

Ingress:

{{< call-out "important" >}}
If using Kubernetes v1.18.0 or greater you must use `ingressClassName` in your Ingress resources. Uncomment line 9 in the resource below or the downloaded file, `target-internal-route.yaml`.
{{< /call-out >}}

- {{< icon "download" >}} {{< link "/examples/nginx-ingress-controller/target-internal-route.yaml" "nginx-ingress-controller/target-internal-route.yaml" >}}

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: target-internal-route
  namespace: legacy
  annotations:
    nsm.nginx.com/internal-route: "true"
spec:
  # ingressClassName: nginx # use only with k8s version >= 1.18.0
  tls:
  rules:
  - host: target-v1-0.legacy
    http:
      paths:
      - path: /
        pathType: Exact
        backend:
          service:
            name: target-v1-0
            port:
              number: 80
```

VirtualServer:

- {{< icon "download" >}} {{< link "/examples/nginx-ingress-controller/target-vs-internal-route.yaml" "nginx-ingress-controller/target-vs-internal-route.yaml" >}}

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
   name: target-vs-internal-route
   namespace: legacy
spec:
   internalRoute: true
   ingressClassName: nginx
   host: target-v1-0.legacy
   upstreams:
      - name: legacy
        tls:
           enable: false
        service: target-v1-0
        port: 80
   routes:
      - path: /
        action:
           pass: legacy
```

Verify the Ingress or VirtualServer resource has been created:

```bash
kubectl -n legacy describe ingress target-internal-route
```

```bash
kubectl -n legacy describe virtualserver target-vs-internal-route
```

### Allow the egress-driver application to route egress traffic to NGINX Ingress Controller

To enable the `egress-driver` application to send egress requests to NGINX Ingress Controller, edit the `egress-driver` Pod and add the following annotation:
 `config.nsm.nginx.com/default-egress-allowed: "true"`

To verify that the default egress route is configured look at the logs of the proxy container:

```bash
 kubectl logs -f <EGRESS_DRIVER_POD> -c nginx-mesh-sidecar | grep "Enabling default egress route"
```

### Test the internal route

The `egress-driver` should have been continually sending traffic, which will now be routed through NGINX Ingress Controller.

```bash
kubectl logs -f -c egress-driver <EGRESS_DRIVER_POD>
```

**Expectation:** You should see the target service respond with the text `target v1.0` and a successful response code. The script employs a verbose curl command that also displays connection and HTTP information. For example:

```bash
*   Trying 10.100.9.60:80...
* Connected to target-v1-0.legacy (10.100.9.60) port 80 (#0)
> GET / HTTP/1.1
> Host: target-v1-0.legacy
> User-Agent: curl/7.72.0-DEV
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.19.2
< Date: Wed, 23 Sep 2020 22:24:29 GMT
< Content-Type: text/plain
< Content-Length: 12
< Connection: keep-alive
<
{ [12 bytes data]
target v1.0
* Connection #0 to host target-v1-0.legacy left intact
```

Use the top command to check traffic metrics:

```bash
nginx-meshctl top deploy/egress-driver
```

**Expectation:** The `nginx-ingress` deployment will show 100% incoming success rate and the `egress-driver` deployment will show 100% outgoing success rate. Keep in mind that the `top` command only shows traffic from the last 30s.

```terminal
Deployment     Direction  Resource       Success Rate  P99  P90  P50  NumRequests
egress-driver
               To         nginx-ingress  100.00%       3ms  3ms  2ms  15
```

This request from the `egress-driver` application to `target-v1-0.legacy` was securely routed through the NGINX Ingress Controller, and we now have visibility into the outgoing traffic from the `egress-driver` application!

### Cleaning up

1. Delete the `legacy` namespace and `egress-driver` application

    ```bash
    kubectl delete ns legacy
    kubectl delete deploy egress-driver
    ```

1. Follow instructions to [uninstall NGINX Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/#uninstall-the-ingress-controller).

1. Follow instructions to [uninstall NGINX Service Mesh]( {{< ref "/mesh/get-started/install/install.md#uninstall" >}} ).
