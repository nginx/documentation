---
title: Expose a UDP Application with NGINX Ingress Controller
description: This topic describes the steps to deploy F5 NGINX Ingress Controller
  for Kubernetes, to expose a UDP application within NGINX Service Mesh.
weight: 230
toc: true
nd-docs: DOCS-841
type:
- tutorial
---

## Overview

Follow this tutorial to deploy the NGINX Ingress Controller with NGINX Service Mesh and an example UDP application.

Objectives:

- Deploy NGINX Service Mesh.
- Install NGINX Ingress Controller.
- Deploy the example `udp-listener` app.
- Create a Kubernetes GlobalConfiguration resource to establish a NGINX Ingress Controller UDP listener.
- Create a Kubernetes TransportServer resource for the udp-listener application.

{{< call-out "note" >}}
NGINX Ingress Controller can be used for free with NGINX Open Source. Paying customers have access to NGINX Ingress Controller with NGINX Plus.
To complete this tutorial, you must use either:

- Open Source NGINX Ingress Controller version 3.0+
- NGINX Plus version of NGINX Ingress Controller

{{< /call-out >}}

### Install NGINX Service Mesh

Follow the installation [instructions]( {{< ref "/mesh/get-started/install/install.md" >}} ) to install NGINX Service Mesh on your Kubernetes cluster. UDP traffic proxying is disabled by default, so you will need to enable it using the `--enable-udp` flag when deploying. Linux kernel 4.18 or greater is required.

{{< call-out "caution"  >}}
Before proceeding, verify that the mesh is running (Step 2 of the installation [instructions]( {{< ref "/mesh/get-started/install/install.md" >}} )).
NGINX Ingress Controller will try to fetch certs from the Spire agent that gets deployed by NGINX Service Mesh on startup. If the mesh is not running, NGINX Ingress controller will fail to start.
{{< /call-out >}}

### Install NGINX Ingress Controller

1. [Install NGINX Ingress Controller]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#install-nginx-ingress-controller-with-mtls-enabled">}} ) with the option to allow UDP ingress traffic. This tutorial will demonstrate installation as a Deployment.
    - Follow the instructions to [enable UDP]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md#enable-udp-traffic" >}} )

    {{< call-out "important" >}}
    mTLS does not affect UDP communication, as mTLS in NGINX Service Mesh applies only to TCP traffic at this time.
    {{< /call-out >}}
2. Get access to the NGINX Ingress Controller by applying the `udp-nodeport.yaml` NodePort resource.
   - {{< icon "download" >}} {{< link "/examples/nginx-ingress-controller/udp/udp-nodeport.yaml" "udp-nodeport.yaml" >}}
3. Check the exposed port from the NodePort service just defined:

    ```bash
    $ kubectl get svc -n nginx-ingress
    NAME                    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
    nginx-ingress           NodePort   10.120.10.134   <none>        80:32705/TCP,443:30181/TCP   57m
    udp-listener-nodeport   NodePort   10.120.4.106    <none>        8900:31839/UDP               6m35s
    ```

    As you can see, our exposed port is `31839`. We'll use this for the remaining steps.
4. Get the IP of one of your worker nodes:

    ```bash
    $ kubectl get node -o wide
    NAME                                     ... INTERNAL-IP     EXTERNAL-IP ...
    gke-aidan-dev-default-pool-f507f772-qiun ... 10.128.15.210   12.115.30.1  ...
    gke-aidan-dev-default-pool-f507f772-tjpo ... 10.128.15.211   12.200.3.8  ...
    ```

    We'll use `12.115.30.1`.


 At this point, you should have the NGINX Ingress Controller running in your cluster; you can deploy the udp-listener example app to test out the mesh integration, or use NGINX Ingress controller to expose one of your own apps.

### Deploy the udp-listener App

1. Enable [automatic sidecar injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) for the `default` namespace.
1. Download the manifest for the `udp-listener` app.
    - {{< icon "download" >}} {{< link "/examples/nginx-ingress-controller/udp/udp-listener.yaml" "udp-listener.yaml" >}}
1. Use `kubectl` to deploy the example `udp-listener` app.

    ```bash
    kubectl apply -f udp-listener.yaml
    ```

1. Verify that all of the Pods are ready and in "Running" status:

    ```bash
    kubectl get pod
    NAME                            READY   STATUS    RESTARTS   AGE
    udp-listener-59665d7ffc-drzh2   2/2     Running   0          4s
    ```

### Expose the udp-listener App

To route UDP requests to an application in the mesh through the NGINX Ingress Controller, you will need both a GlobalConfiguration and TransportServer Resource.

- {{< icon "download" >}} {{< link "/examples/nginx-ingress-controller/udp/nic-global-configuration.yaml" "nic-global-configuration.yaml" >}}
- {{< icon "download" >}} {{< link "/examples/nginx-ingress-controller/udp/udp-transportserver.yaml" "udp-transportserver.yaml" >}}

1. Deploy a GlobalConfiguration to configure what port to listen for UDP requests on:

    ```bash
    kubectl apply -f nic-global-configuration.yaml
    ```

    The GlobalConfiguration configures a listener to listen for UDP datagrams on a specified port.

    ```yaml
    apiVersion: k8s.nginx.org/v1alpha1
    kind: GlobalConfiguration
    metadata:
    name: nginx-configuration
    namespace: nginx-ingress
    spec:
    listeners:
    - name: accept-udp
      port: 8900
      protocol: UDP
    ```

2. Apply the TransportServer to configure UDP traffic to route from the GlobalConfiguration listener your udp-listener app.

    ```bash
    kubectl apply -f udp-transportserver.yaml
    ```

    This TransportServer will route requests from the listener supplied in the GlobalConfiguration to a named upstream -- in this case `udp-listener-upstream`. Our upstream is configured to pass traffic to our `udp-listener` service at port 5005, where our udp-listener application lives.

    ```yaml
    apiVersion: k8s.nginx.org/v1alpha1
    kind: TransportServer
    metadata:
    name: udp-listener
    spec:
    listener:
      name: accept-udp
      protocol: UDP
    upstreams:
    - name: udp-listener-upstream
      service: udp-listener
      port: 5005
    upstreamParameters:
      udpRequests: 1
    action:
      pass: udp-listener-upstream
    ```

### Send Datagrams to the udp-listener App

Now that everything for the NGINX Ingress Controller is deployed, we can now send datagrams to the udp-listener application.

1. Use the IP and port defined in the [Install NGINX Ingress Controller](#install-nginx-ingress-controller) section to send a netcat UDP message:

    ```bash
    echo "UDP Datagram Message" | nc -u 12.115.30.1 31839
    ```

2. Check that that the "UDP Datagram Message" text was correctly sent to the udp-listener server:

    ```bash
    $ kubectl logs udp-listener-59665d7ffc-drzh2 -c udp-listener
    Listening on UDP port 5005
    UDP Datagram Message
    ```

3. Check that the UDP message is present in the udp-listener sidecar logs:

    ```bash
    kubectl logs udp-listener-59665d7ffc-drzh2 -c nginx-mesh-sidecar
    ...
    2022/01/22 00:09:31 SVID updated for spiffeID: "spiffe://example.org/ns/default/sa/default"
    2022/01/22 00:09:31 Enqueueing event: SPIRE, key: 0xc00007ac00
    2022/01/22 00:09:31 Dequeueing event: SPIRE, key: 0xc00007ac00
    2022/01/22 00:09:31 Reloading nginx with configVersion: 2
    2022/01/22 00:09:31 executing nginx -s reload
    2022/01/22 00:09:32 success, version 2 ensured. iterations: 4. took: 100ms
    [08/Feb/2022:19:49:02 +0000] 10.116.0.26:41802 UDP 200 0 49 0.000 "127.0.0.1:5005" "21" "0" "0.000"
    ```

    We're looking for the `[08/Feb/2022:19:49:02 +0000] 10.116.0.26:41802 UDP 200 0 49 0.000 "127.0.0.1:5005" "21" "0" "0.000"` line, which includes the `UDP` protocol and the correct size of the UDP packet we sent.

    Notice the `49` bytes representing the incoming packet size. This correlates to the `28` bytes of headroom added to the packet to maintain original destination information. See the [UDP and eBPF architecture]( {{< ref "/mesh/about/architecture.md#udp-and-ebpf" >}} ) section for more information on why this is necessary.
