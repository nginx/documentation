---
title: Architecture
weight: 200
description: Learn about F5 NGINX Service Mesh Architecture.
toc: true
docs: DOCS-676
type:
- concept
- reference
---

## Overview

F5 NGINX Service Mesh is an infrastructure layer designed to decouple application business logic from deep networking concerns. A mesh is designed to provide fast, reliable, and low-latency network connections for modern application architectures.

## Architecture and Components

NGINX Service Mesh deploys two primary layers: a **control plane layer** that's responsible for configuration and management, and a **data plane layer** that provides the network functions valuable to distributed applications.

The control plane comprises multiple subsystems, each of which is explained below. Following the sidecar pattern, data plane elements replicate throughout the application in a 1:1 ratio with application workloads. Each data plane element is an identical instance using configuration data to shape its behavior and customize its relative position within the application topology.

{{< img src="img/architecture.png" alt="NGINX Service Mesh Architecture" >}}
*NGINX Service Mesh Architecture*

### NGINX Service Mesh Controllers

Kubernetes resources and container names:

- Container: nginx-mesh-controller
- Deployment: deployment/nginx-mesh-controller
- Service: service/nginx-mesh-controller

NGINX Service Mesh employs the controller pattern to enforce desired states across managed application(s). Controllers are event loops that actuate and enforce configuration inputs. The controllers in the NGINX Service Mesh control plane watch a set of native Kubernetes resources (Services, Endpoints, and Pods). The controllers also watch a collection of custom resources defined by the [Service Mesh Interface specification](https://github.com/servicemeshinterface/smi-spec) and individual resources specific to NGINX Service Mesh (see [Traffic Policies](https://docs.nginx.com/nginx-service-mesh/guides/smi-traffic-policies/)).

NGINX Service Mesh controllers support advanced configurations. The most basic configuration tuple requires a Kubernetes Service and Pod. Higher-order parent resources--such as Deployments, StatefulSets, DaemonSets, or Jobs--can control Pods. However, as the fundamental workload abstraction, NGINX Service Mesh controllers require access to the Pod configuration.

Applying the concept of [Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/), NGINX Service Mesh mutates Pod configurations with additive elements through a process known as *injection*. Injection is the mechanism enabling the container sidecar pattern; the NGINX Service Mesh control plane injects an [init container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) and a sidecar into each managed Pod. Besides automatic injection, NGINX Service Mesh supports manual injection through the `nginx-meshctl inject` command. Be sure to experiment with manual injection to evaluate the changes made to Pod configurations.

When new events occur in Kubernetes that NGINX Service Mesh watches for--such as when new applications or traffic policies are created--the control plane builds an internal configuration based on this data. This configuration is sent over a secure [NATS](#nats-message-bus) channel to all application sidecars. The sidecars are designed to understand the structure of this config.

### NGINX Service Mesh Sidecar

Kubernetes container names:

- nginx-mesh-init
- nginx-mesh-sidecar

Applications that are a part of NGINX Service Mesh are injected with an [init container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) and a sidecar. The sidecar consists of two components: a simple agent and an NGINX Plus instance.

#### Init Container

The init container runs before the application or sidecar. This container sets the networking to redirect inbound and outbound traffic from the application to the NGINX Plus instance. For example, `iptables` rules can be examined from within the Pod's network namespace. NGINX Plus then forwards the traffic to the original destination.

#### Agent

The agent accepts the NGINX Service Mesh control plane configuration and uses this data to configure the NGINX Plus instance. The agent gets certificate information from [SPIRE](#spire). Upstreams, traffic policies, and global mesh configuration settings are retrieved from the NGINX Service Mesh controller via [NATS](#nats-message-bus). The agent manages the entire configuration lifecycle of the NGINX Plus instance.

#### NGINX Plus

NGINX Plus is the "brain" of the data plane. By proxying inbound and outbound traffic to and from your application, NGINX Plus handles mTLS, traffic routing, tracing, and metrics. The upstream servers to NGINX Plus reference all the services in the mesh, ensuring encrypted connections and honoring traffic policies defined in Kubernetes custom resources. Native and custom NGINX modules manage traffic routing and expose tracing and metrics data as requests pass through the proxy. Traffic is redirected by `iptables` rules (defined by the init container) to the NGINX Plus instance before being forwarded to its original destination.

#### Intercepting Traffic

NGINX Service Mesh uses destination NAT (DNAT) to redirect all inbound and outbound application traffic to the NGINX Plus sidecar. DNAT operates like the port forwarding feature on home Wi-Fi routers. DNAT changes the destination IP address to the Pod IP address and the destination port to a static port that the NGINX Plus sidecar listens on. NGINX Service Mesh uses separate ports for inbound and outbound traffic.

NGINX Service Mesh uses an init container to set up iptables `REDIRECT` rules to perform the DNAT redirection. The init container is injected at Pod creation alongside the sidecar. It sets up the iptables rules before starting the application or sidecar to ensure traffic is redirected on startup. The init container must run as root to set up iptables rules. However, the short lifetime of the init container means those root privileges aren't needed for long. As a result, the NGINX Plus sidecar can run as a regular unprivileged user.

#### Proxying Traffic

Once the sidecar receives traffic, it's able to do its work. For example, if mTLS is enabled, the sidecar will decrypt or encrypt traffic for inbound or outbound traffic, respectively. Once the sidecar has processed traffic, it forwards the traffic to the original destination. To do this, the sidecar recovers the original destination IP address and port using the Linux `getsockopt` socket API and requests `SO_ORIGINAL_DST`. Linux returns a struct with the original destination IP address and port. The sidecar then proxies the traffic to the original destination.

#### Packet Flow Examples

This section steps through some packet flow examples using the following diagram.

{{< img src="img/networking.png" alt="NGINX Service Mesh Networking Diagram">}}
*NGINX Service Mesh Network Example*

Key Concepts:

- Each Pod runs within its own [network namespace](https://man7.org/linux/man-pages/man8/ip-netns.8.html). Each Pod has its own networking stack, routes, firewall rules, and network devices. In the preceding diagram, there are three Pods, each with its own networking namespace.
- Each Pod has its own `eth0` network device.
- On each node, there is a `veth` virtual network device for each Pod on the node, used to connect the Pod's namespace to the root network namespace.
- There is a Layer 2 bridge device on each node, labeled `cbr0` in this example, that's used to link network namespaces on the same node. Pods on the same node use this bridge when they want to talk to each other. The bridge name can change across deployments and versions and may not be called `cbr0`. To see what bridges exist on your node, use the `brctl` command.
- Each node has its own `eth0` in the root network namespace that's used for Pods on different nodes to talk to each other.

##### TCP Pod-to-Pod Communication on the Same Node

In this scenario, Pod 1 wants to communicate with Pod 2, and both Pods are on Node 1. Pod 1 sends a packet to its default Ethernet device, `eth0`. The iptables rule in Pod 1's network namespace redirects the packet to the NGINX Plus sidecar. After processing the packet, the NGINX Plus sidecar recovers the original destination IP address and port and then forwards the packet to `eth0`. For Pod 1, `eth0` connects to the root network namespace using `veth1234`. Bridge `cbr0` connects `veth1234` to all of the other virtual devices on the node. Once the packet reaches the bridge, it uses ARP (Address Resolution Protocol) to determine that the correct next hop is `veth4321`. When the packet reaches the virtual device `veth4321`, it's forwarded to `eth0` in Pod 2's network namespace.

##### TCP Pod-to-Pod Communication on Different Nodes

In this scenario, Pod 1 on Node 1 wants to communicate with Pod 3 on Node 2. Pod 1 sends a packet to its default Ethernet device, `eth0`. The iptables rule in Pod 1's network namespace redirects the packet to the NGINX Plus sidecar. After processing the packet, the NGINX Plus sidecar recovers the original destination IP address and port and then forwards the packet to `eth0`. For Pod 1, `eth0` connects to the root network namespace using `veth1234`. ARP fails at the `cbr0` bridge because a device isn't connected with the correct MAC address for the packet. `cbr0` then sends the packet out the default route, which is `eth0` in the root network namespace.

At this point, the packet leaves the node and enters the Host Network. The Host Network routes the packet to Node 2 based on the destination IP address. The packet enters the root network namespace of the destination node, where it's routed through `cbr0` to `veth9876`. When the packet reaches the virtual device `veth9876`, it's forwarded to `eth0` in Pod 3's network namespace.

##### UDP and eBPF

{{< note >}}
UDP traffic proxying is a beta feature that is turned off by default. You can turn it on at [deploy time]({{< ref "nginx-meshctl.md#deploy" >}}) if desired. Linux kernel 4.18 or greater is required.
{{< /note >}}

NGINX Service Mesh has developed an alternate approach to routing datagrams in answer to particular challenges associated with the UDP protocol. Information is routed via an analogous pathway, however, UDP datagrams are redirected with eBPF functions as opposed to iptables with TCP.

eBPF is a powerful and customizable construct that runs within the Linux kernel, inside a register-based virtual machine.

Firstly, the functionality gets outlined using a high-level language such as C, Golang, or Python. Then the code is verified and compiled into BPF bytecode and loaded into the kernel. Verification ensures that the eBPF program is safe to run, and its execution in the virtual machine guarantees it will not cause the kernel to crash.

Use cases for eBPF include tracing, monitoring, and profiling. In NGINX Service Mesh, eBPF is used to redirect UDP traffic to sidecar proxy. This flow is described in the following sections. See [ebpf.io](https://ebpf.io/) for additional information, including use cases.


###### Outgoing eBPF with UDP

See the flow of a packet from generation to delivery to destination.

{{< img src="img/udp-egress.jpeg" alt="NGINX Service Mesh UDP Egress Networking Diagram" width="75%" >}}

Here you can see the flow of a packet from generation by the workload to delivery to the destination workload. This diagram has abstracted away the destination pod networking specifics since that is covered in the above diagram.

The core functionality needed by the TC program is a redirection of the packet's destination to the sidecar container running in the same pod. In order to do this, a number of considerations need to be made:

1. The destination IP address and port must be overridden to that of the sidecar container.
1. In order to maintain the packet's original destination IP address and port, we decided to add additional headroom to the packet's payload section using PROXY protocol V2. This keeps track of the packet's original destination and source.
1. We must not trigger any Linux networking checks that may drop the packet. This includes: updating the source IP such that it is not a martian address, handling IP fragmentation, and updating the modified packet's checksums.

The packet flows through the TC egress filter set up by the init container into the eBPF program loaded into the Linux kernel. Here we add the PROXY protocol V2 header and redirect the packet to the proxy. The PROXY protocol V2 header is then stripped from the payload. Additional processing by NGINX Plus such as load balancing or traffic policy is performed. The packet is then sent to its original destination IP and port through the default Linux networking stack.

###### Incoming eBPF with UDP

This section talks about the specifics of UDP networking for outgoing traffic.

{{< img src="img/udp-ingress.jpeg" alt="NGINX Service Mesh UDP Ingress Networking Diagram" width="75%" >}}

The diagram shows that the source of the packet is coming from an external source workload. Once the packet finds its way into the network namespace of the destination pod, the `XDP` eBPF hook triggers the execution of the custom eBPF program. This redirects the packet to the proxy container, rather than the workload itself while using the same PROXY protocol V2 header to maintain original destination information.

Once received by the destination proxy container, the PROXY protocol V2 header is stripped from the payload, any additional processing by NGINX is performed, and the packet is sent from NGINX Plus to the workload.

### SPIRE

Kubernetes resources and container names:

- Containers: spire-server, k8s-workload-registrar, spire-agent
- Resources: statefulset|deployment/spire-server, daemonset/spire-agent
- Services: service/spire-server, service/k8s-workload-registrar

NGINX Service Mesh uses mutual TLS (mTLS) to encrypt and authenticate data sent between injected Pods. mTLS extends standard TLS by having both the client and server present a certificate and mutually authenticate each other. mTLS is “zero-touch,” meaning developers don't need to retrofit their applications with certificates.

NGINX Service Mesh integrates [SPIRE](https://github.com/spiffe/spire) as its central Certificate Authority (CA). SPIRE handles the entire lifecycle of the certificate: creation, distribution, and rotation. NGINX Plus uses SPIRE-issued certificates to establish mTLS sessions and encrypt traffic.

{{< img src="img/mtls.png" alt="NGINX Service Mesh mTLS Architecture Diagram">}}
*NGINX Service Mesh mTLS Architecture*

The important components in the diagram are:

- **SPIRE Server**: The SPIRE Server runs as a Kubernetes StatefulSet (or Deployment if no [persistent storage]({{< ref "/mesh/get-started/platform-setup/persistent-storage.md" >}}) is available). It has two containers - the actual `spire-server` and the `k8s-workload-registrar`.

  - **spire-server**: The core of the NGINX Service Mesh mTLS architecture, `spire-server` is the certificate authority (CA) that issues certificates for workloads and pushes them to the SPIRE Agent. `spire-server` can be the root CA for all services in the mesh or an intermediate CA in the trust chain.
  - **k8s-workload-registrar**: When new Pods are created, `k8s-workload-registrar` makes API calls to request that `spire-server` generate a new certificate. `k8s-workload-registrar` communicates with `spire-server` through a Unix socket. The `k8s-workload-registrar` is based on a Kubernetes Custom Resource Definition (CRD).

- **SPIRE Agent**: The SPIRE Agent runs as a Kubernetes DaemonSet, meaning one copy runs per node. The SPIRE Agent has two main functions:

  1. Receives certificates from the SPIRE Server and stores them in a cache.

  1. "Attests" each Pod that comes up. The SPIRE Agent asks the Kubernetes system to provide information about the Pod, including its UID, name, and namespace. The SPIRE Agent then uses this information to look up the corresponding certificate.

- **NGINX Plus**: NGINX Plus consumes the certificates generated and distributed by SPIRE and handles the entire mTLS workflow, exchanging and verifying certificates.

#### The Certificate Lifecycle

This section explains how NGINX Service Mesh handles the entire certificate lifecycle, including creation, distribution, usage, and rotation.

##### Creation

The first stage in the mTLS workflow is creating the actual certificate:

1. The Pod is deployed.
1. The NGINX Service Mesh control plane injects the sidecar into the Pod configuration using a mutating webhook.
1. In response to a "Pod Created" event notification, `k8s-workload-registrar` gathers the information needed to create the certificate, such as the `ServiceAccount` name.
1. `k8s-workload-registrar` makes an API call to `spire-server` over a Unix socket to request a certificate for the Pod.
1. `spire-server` mints a certificate for the Pod.

##### Distribution

The new certificate needs to be securely distributed to the correct Pod:

1. The SPIRE Agents fetch the new certificate and store it in their caches. The SPIRE Agents and Server use gRPC to communicate. The communication is secure and encrypted.
1. The injected Pod is scheduled and begins running; this includes the NGINX Plus sidecar.
1. The sidecar connects through a Unix socket to the SPIRE Agent running on the same node.
1. The SPIRE Agent attests the Pod, gathers the correct certificate, and sends it to the sidecar through the Unix socket.

##### Usage

Now, NGINX Plus can use the certificate to perform mTLS. What follows is how NGINX Plus uses the certificate when the Pod tries to connect to a server that has a certificate issued by SPIRE.

1. The application running in the Pod initiates a connection to a service.
1. The NGINX Plus sidecar intercepts the connection using iptables NAT redirect.
1. NGINX Plus initiates a TLS connection to the destination service's sidecar.
1. The server-side NGINX Plus sends its certificate to the client and requests the client's certificate.
1. The client-side NGINX Plus validates the server's certificate up to the trust root and sends its certificate to the server.
1. The server validates the client's certificate up to the trust root.
1. With both sides mutually authenticated, a standard TLS key exchange can occur.

##### Rotation

Certificates must be rotated before their expiration dates to keep traffic flowing. When a certificate is close to expiring, `spire-server` issues a new certificate and triggers the rotation process. The new certificate is pushed to the SPIRE Agent. Then the SPIRE Agent forwards the certificate through the Unix socket to the NGINX Plus sidecar.

#### SPIRE and PKI

You can use SPIRE as the trust root in your NGINX Service Mesh deployment, or SPIRE can plug into your existing Public Key Infrastructure (PKI). For more information, see [Deploy Using an Upstream Root CA]({{< ref "/mesh/guides/secure-traffic-mtls#deploy-using-an-upstream-root-ca" >}})

If you import your own root CA:

- SPIRE creates an intermediate CA signed against its own local imported CA, and then uses that intermediate CA to handle all agent requests.

If SPIRE is using an upstream CA:

- For AWS PCA, the SPIRE server sends a certificate signing request to AWS PCA for signing. It then uses the issued certificate to sign workload certificates.
- For disk, AWS Secrets Manager, and Vault SPIRE Server uses the upstream certificate to create an intermediate certificate for itself. It then signs workload certificates using this intermediate certificate.
- Each upstream CA has a different API for that exchange, and each of those transactional processes are unique to each upstream.
- SPIRE plugins take care of the mechanics of each of those unique upstream CAs. You need to ensure that these plugins are enabled and allowed. You also need to test that it's possible to proxy each one of the auth methods supported by each of the plugins being used.

{{< see-also >}}
Refer to the [Secure Mesh Traffic using mTLS]({{< ref "/mesh/guides/secure-traffic-mtls.md" >}}) guide for more information on configuring mTLS.
{{< /see-also >}}

### NATS Message Bus

Kubernetes resources and container names:

- Containers: nats-server, nginx-mesh-cert-reloader, nginx-mesh-cert-reloader-init
- Deployment: deployment/nats-server
- Service: service/nats-server

NGINX Service Mesh uses the [NATS](https://docs.nats.io/nats-concepts/intro) message bus to communicate between the control plane and data plane. A dedicated connective solution provides reliable performance for highly scalable data planes.

The control plane sends configuration changes to the data plane using NATS. NATS is a popular solution for microservices because of how it handles modern distributed systems. NATS can manage thousands of connections and uses a publisher/subscriber architecture, allowing the NGINX Service Mesh controller to decouple from the data plane sidecars. The controller can dedicate itself to managing configurations rather than managing direct connections to the sidecars.

#### Lifecycle

NATS, a part of the NGINX Service Mesh control plane, is deployed when running `nginx-meshctl deploy`. An init container and sidecar are deployed with the NATS container. The init container loads [SPIRE](#spire) certificates into the NATS container on startup, and the sidecar loads the certificates as they rotate. NATS uses these certificates to deploy a TLS server for sending and receiving secure traffic between publishers and subscribers. NATS verifies the client identities and protects the configuration from bad actors. Since the NGINX Service Mesh controller and sidecars also use SPIRE certificates, they are included in the trust domain.

The NGINX Service Mesh controller connects to NATS on startup, establishing itself as a publisher. When new events occur in Kubernetes that NGINX Service Mesh watches for--for example, when new services or traffic policies are created--the control plane builds an internal configuration from this data. This configuration is then sent over a secure NATS channel to all subscribers.

NGINX Service Mesh sidecars (specifically agents) connect to NATS when they are deployed with an application. These agents establish themselves as subscribers and accept configuration messages sent through the secure NATS channel from the control plane.

### Observability

NGINX Service Mesh lets you observe application behavior using a combination of internal and third-party solutions to expose metrics and tracing data.

{{< see-also >}}
See the [Monitoring and Tracing]({{< ref "/mesh/guides/monitoring-and-tracing.md" >}}) guide for more information on integrating your Prometheus, Grafana, and/or tracing backends with NGINX Service Mesh.
{{< /see-also >}}

#### Metrics

- [Prometheus](https://prometheus.io/docs/introduction/overview/) is a systems monitoring tool that can scrape NGINX Service Mesh sidecars, where metrics are exposed by NGINX Plus, then store this data in memory. You can access this data by querying Prometheus directly, querying the NGINX Service Mesh metrics server, or viewing a Grafana dashboard. Prometheus also scrapes NGINX Ingress Controller metrics if it's been deployed.

- [Grafana](https://grafana.com/grafana/) is a dashboard-based tool that can be used to visualize Prometheus metrics data. NGINX Service Mesh provides a [custom dashboard](https://github.com/nginxinc/nginx-service-mesh/tree/main/examples/grafana) that can be imported into your deployment of Grafana.

- The NGINX Service Mesh metrics server is also a control plane component, extending the Kubernetes API, known as an [aggregation layer](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/). When queried, this server gets metrics data from Prometheus and formats the data adhering to the Service Mesh Interface (SMI) standards. This server provides quick access to the basic metrics data in a standard format defined by SMI.

{{<see-also>}}
See the [Traffic Metrics]({{< ref "/mesh/guides/smi-traffic-metrics.md" >}}) guide for more information on how to visualize metrics data from NGINX Service Mesh.
{{</see-also>}}

#### Tracing

[OpenTelemetry](https://opentelemetry.io/docs/) is a set of APIs, SDKs, tooling, and integrations that are designed for the creation and management of telemetry data such as traces, metrics, and logs. NGINX Service Mesh sidecars use the [OpenTelemetry NGINX module](https://github.com/open-telemetry/opentelemetry-cpp-contrib/tree/main/instrumentation/nginx) to export tracing data to an [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/) using the OpenTelemetry Protocol (OTLP). This module creates new tracing spans and propagates existing ones as requests pass through applications. The OpenTelemetry Collector can then be configured to export the tracing data to an upstream collector like Jaeger, DataDog, LightStep, or many others.

Here is an example of the tracing data flow using both DataDog and LightStep as the final collectors:

{{< img src="img/opentelemetry.png" alt="OpenTelemetry Data Flow" >}}
*Tracing data flow using the OpenTelemetry Collector*

### Ingress and Egress Traffic

You can deploy [NGINX Plus Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/) with NGINX Service Mesh to provide production-grade control over ingress and egress traffic. Like the NGINX Service Mesh sidecar, NGINX Plus Ingress Controller fetches certificates from [SPIRE](#spire) to authenticate with NGINX Service Mesh workloads. This integration with SPIRE allows NGINX Plus Ingress Controller to communicate with NGINX Service Mesh workloads without being injected with a sidecar.

You can use [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) or [VirtualServer and VirtualServerRoute](https://docs.nginx.com/nginx-ingress-controller/configuration/virtualserver-and-virtualserverroute-resources/) resources to expose services in NGINX Service Mesh from outside the Kubernetes cluster.

Ingress resources create an HTTP/HTTPS load balancer for services in Kubernetes and support host- and path-based routing, as well as TLS/SSL termination.

VirtualServers and VirtualServerRoutes are NGINX Plus Ingress Controller custom resources that support the Ingress feature set. These resources enable advanced traffic routing such as traffic splitting, access control, and rate-limiting. When you expose an NGINX Service Mesh service with an Ingress or VirtualServer resource, NGINX Plus Ingress Controller creates an HTTP/HTTPS route from outside the cluster to the service deployed in NGINX Service Mesh. The NGINX Plus Ingress Controller terminates the client's TLS/SSL connection if TLS/SSL termination is configured and then establishes an mTLS session with the NGINX Service Mesh workload.

#### Default Egress Route

NGINX Plus Ingress Controller lets you control the egress traffic from your cluster. You can configure Pods in NGINX Service Mesh to use the default egress route. This default route directs all egress traffic not destined for NGINX Service Mesh services through NGINX Plus Ingress Controller.

The NGINX Plus Ingress Controller terminates the mTLS connection from the NGINX Service Mesh workload and routes the request to the egress service. Egress services can be services deployed outside the cluster, or they can be services deployed within the cluster that are not injected with the NGINX Service Mesh sidecar.

{{< see-also >}}
Refer to the [Deploy with NGINX Plus Ingress Controller]({{< ref "/mesh/tutorials/kic/deploy-with-kic.md" >}}) guide for more information on using NGINX Plus Ingress Controller to route ingress and egress traffic to and from your NGINX Service Mesh workloads.
{{< /see-also >}}
