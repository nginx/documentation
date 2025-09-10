---
title: Expose an Application with NGINX Ingress Controller
description: This topic provides a walkthrough of deploying F5 NGINX Ingress Controller
  for Kubernetes to expose an application within NGINX Service Mesh.
weight: 220
toc: true
nd-docs: DOCS-723
type:
- tutorial
---

## Overview

Follow this tutorial to deploy the F5 NGINX Ingress Controller with NGINX Service Mesh and an example application.
All communication between the NGINX Ingress Controller and the example application will occur over mTLS.

Objectives:

- Deploy the NGINX Service Mesh.
- Install NGINX Ingress Controller.
- Deploy the example `bookinfo` app.
- Create a Kubernetes Ingress resource for the Bookinfo application.

{{< call-out "note" >}}
NGINX Ingress Controller can be used for free with NGINX Open Source. Paying customers have access to NGINX Ingress Controller with NGINX Plus.
To complete this tutorial, you must use either:

- Open Source NGINX Ingress Controller version 3.0+
- NGINX Plus version of NGINX Ingress Controller

{{< /call-out >}}

### Install NGINX Service Mesh

If you want to view metrics for NGINX Ingress Controller, ensure that you have deployed Prometheus and Grafana and then configure NGINX Service Mesh to integrate with them when installing. Refer to the [Monitoring and Tracing]( {{< ref "/mesh/guides/monitoring-and-tracing.md" >}} ) guide for instructions.

Follow the installation [instructions]( {{< ref "/mesh/get-started/install/install.md" >}} ) to install NGINX Service Mesh on your Kubernetes cluster.
You can either deploy the Mesh with the default value for [mTLS mode]( {{< ref "/mesh/guides/secure-traffic-mtls.md" >}} ), which is `permissive`, or set it to `strict`.

Before proceeding, verify that the mesh is running (Step 2 of the installation [instructions]( {{< ref "/mesh/get-started/install/install.md" >}} )).
NGINX Ingress Controller will try to fetch certs from the Spire agent that gets deployed by NGINX Service Mesh on startup. If the mesh is not running, NGINX Ingress controller will fail to start.

### Install NGINX Ingress Controller

1. [Install NGINX Ingress Controller with mTLS enabled]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#install-nginx-ingress-controller-with-mtls-enabled">}} ). This tutorial will demonstrate installation as a Deployment.
2. [Get Access to the Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/#4-get-access-to-the-ingress-controller). This tutorial creates a LoadBalancer Service for the NGINX Ingress Controller.
3. Find the public IP address of your NGINX Ingress Controller Service.

    ```bash
    kubectl get svc -n nginx-ingress
    NAME            TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)                      AGE
    nginx-ingress   LoadBalancer   10.76.7.165   34.94.247.235   80:31287/TCP,443:31923/TCP   66s
    ```

 At this point, you should have the NGINX Ingress Controller running in your cluster; you can deploy the Bookinfo example app to test out the mesh integration, or use NGINX Ingress controller to expose one of your own apps.

### Deploy the Bookinfo App

1. Enable [automatic sidecar injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) for the `default` namespace.
1. Download the manifest for the `bookinfo` app.
    - {{< icon "download" >}} {{< link "/examples/bookinfo.yaml" "bookinfo.yaml" >}}
1. Use `kubectl` to deploy the example `bookinfo` app.

    ```bash
    kubectl apply -f bookinfo.yaml
    ```

1. Verify that all of the Pods are ready and in "Running" status:

    ```bash
    kubectl get pods

    NAME                              READY   STATUS    RESTARTS   AGE
    details-v1-74f858558f-khg8t       2/2     Running   0          25s
    productpage-v1-8554d58bff-n4r85   2/2     Running   0          24s
    ratings-v1-7855f5bcb9-zswkm       2/2     Running   0          25s
    reviews-v1-59fd8b965b-kthtq       2/2     Running   0          24s
    reviews-v2-d6cfdb7d6-h62cb        2/2     Running   0          24s
    reviews-v3-75699b5cfb-9jtvq       2/2     Running   0          24s

    ```

(Optional) Verify that the application works:

{{< call-out "note" >}}
The steps in this section only work with `permissive` [mTLS mode]( {{< ref "/mesh/guides/secure-traffic-mtls.md" >}} ). With `strict` mTLS mode, the sidecar will drop all traffic that is not encrypted with a certificate issued by NGINX Service Mesh, so the below steps won't work. For `strict` mTLS mode skip forward to the next section which covers how to [Expose the Bookinfo App](#expose-the-bookinfo-app).
{{< /call-out >}}

1. Port-forward to the `productpage` Service:

    ```bash
    kubectl port-forward svc/productpage 9080
    ```

2. Open the Service URL in a browser: `http://localhost:9080`.
3. Click one of the links to view the app as a general user, then as a test user, and verify that all portions of the page load.

### Expose the Bookinfo App

Create an Ingress Resource to expose the Bookinfo application, using the example `bookinfo-ingress.yaml` file.

{{< call-out "important" >}}
If using Kubernetes v1.18.0 or greater you must use `ingressClassName` in your Ingress resources. Uncomment line 6 in the resource below or the downloaded file, `bookinfo-ingress.yaml`.
{{< /call-out >}}

- {{< icon "download" >}} {{< link "/examples/nginx-ingress-controller/bookinfo-ingress.yaml" "bookinfo-ingress.yaml" >}}

```bash
kubectl apply -f bookinfo-ingress.yaml
```

The Bookinfo Ingress defines a host with domain name `bookinfo.example.com`. It routes all requests for that domain name to the `productpage` Service on port 9080.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: bookinfo-ingress
spec:
  ingressClassName: nginx # use only with k8s version >= 1.18.0
  tls:
  rules:
  - host: bookinfo.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: productpage
            port:
              number: 9080
```

### Access the Bookinfo App

To access the Bookinfo application:

1. Modify `/etc/hosts` so that requests to `bookinfo.example.com` resolve to NGINX Ingress Controller's public IP address.
    Add the following line to your `/etc/hosts` file:

    ```bash
       <INGRESS_CONTROLLER_PUBLIC_IP> bookinfo.example.com
    ```

2. Open `http://bookinfo.example.com` in your browser.
3. Click one of the links to view the app as a general user, then as a test user, and verify that all portions of the page load.

### View Traffic Flow

After sending a few requests as a general or test user, you can view the flow of traffic throughout your application. If you have [configured NGINX Service Mesh]({{< ref "/mesh/guides/monitoring-and-tracing.md#prometheus" >}}) to export metrics to your Prometheus deployment, run the `nginx-meshctl top` command to see traffic in the namespace your bookinfo application is deployed in:

```txt
$ nginx-meshctl top

Deployment      Incoming Success  Outgoing Success  NumRequests
productpage-v1                    100.00%           6
reviews-v2      100.00%           100.00%           4
reviews-v3      100.00%                             2
details-v1      100.00%                             6
ratings-v1      100.00%                             2
reviews-v1      100.00%                             3
```

Or, for a more in-depth look at the bookinfo components, run the `top` command on a deployment:

```txt
$ nginx-meshctl top deployment/productpage-v1

Deployment      Direction  Resource            Success Rate  P99    P90    P50   NumRequests
productpage-v1
                To         reviews-v3          100.00%       50ms   48ms   40ms  2
                To         details-v1          100.00%       20ms   15ms   3ms   6
                To         reviews-v1          100.00%       99ms   90ms   20ms  3
                To         reviews-v2          100.00%       100ms  95ms   75ms  4
                From       nginx-plus-ingress  100.00%       196ms  160ms  75ms  6
```

You can also view the Grafana dashboard, which provides additional statistics on your application, by following the [Monitor your application in Grafana]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#monitor-your-application-in-grafana" >}} ) section of our Expose an Application with NGINX Ingress Controller guide.
