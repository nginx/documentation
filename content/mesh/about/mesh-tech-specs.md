---
title: Technical Specifications
weight: 110
description: Cluster requirements and F5 NGINX Service Mesh footprint.
toc: true
docs: DOCS-677
type:
- reference
---

The following document outlines the software versions and overhead F5 NGINX Service Mesh uses while running.

## Software Versions

The following tables list the software versions NGINX Service Mesh supports and uses by default.

### Supported Versions

{{% table %}}
| NGINX Service Mesh | Kubernetes | OpenShift | NGINX Ingress Controller | Helm     | Rancher  |
|--------------------|------------|-----------|--------------------------|----------|----------|
| v1.7.0+            | 1.22+      | 4.9+      | 2.2+                     | 3.2+     | 2.5+     |
| v1.6.0             | 1.22+      | 4.9+      | 2.2+ (NGINX Plus only)   | 3.2+     | 2.5+     |
{{% /table %}}

{{% table %}}
| NGINX Service Mesh | SMI Traffic Access | SMI Traffic Metrics | SMI Traffic Specs | SMI Traffic Split | NSM RateLimit      | NSM CircuitBreaker |
|--------------------|--------------------|---------------------|-------------------|-------------------|--------------------|--------------------|
| v1.2.0+            | v1alpha2           | v1alpha1\*          | v1alpha3          | v1alpha3          | v1alpha1, v1alpha2 | v1alpha1           |
{{% /table %}}

\* - in progress, supported resources: StatefulSets, Namespaces, Deployments, Pods, DaemonSets

### Components
{{% table %}}
| NGINX Service Mesh | NGINX Plus (sidecar) | SPIRE   | NATS                  |
|--------------------|----------------------|---------|-----------------------|
| v2.0.0+            | R28                  | 1.5.6   | nats:2.9-alpine       |
| v1.7.0             | R28                  | 1.5.4   | nats:2.9-alpine       |
| v1.6.0             | R27                  | 1.4.4   | nats:2.9.3-alpine3.16 |
{{% /table %}}

### Images
#### Distributed Images

- `docker-registry.nginx.com/nsm/nginx-mesh-controller`: NGINX Service Mesh Controller.
- `docker-registry.nginx.com/nsm/nginx-mesh-metrics`: Gets Pod (and other Kubernetes resources) metrics. Refer to [SMI Metrics on GitHub](https://github.com/servicemeshinterface/smi-metrics) and `nginx-meshctl help top` for more information.
- `docker-registry.nginx.com/nsm/nginx-mesh-sidecar`: NGINX Service Mesh sidecar.
- `docker-registry.nginx.com/nsm/nginx-mesh-init`: NGINX Service Mesh sidecar init container. Sets up `iptables` for the sidecar.
- `docker-registry.nginx.com/nsm/nginx-mesh-cert-reloader`: NGINX Service Mesh certificate reloader. Loads and rotates certificates for the NATs server.

#### Third Party Images
NGINX Service Mesh also pulls the following publicly-accessible third-party container images into your Kubernetes cluster in order to function:

{{% table %}}
| Component  | Image path(s)                                                          | Version tag |
|------------|------------------------------------------------------------------------|-------------|
| SPIRE      | gcr.io/spiffe-io/spire-server                                          | 1.5.6       |
|            | gcr.io/spiffe-io/k8s-workload-registrar                                | 1.5.6       |
|            | gcr.io/spiffe-io/spire-agent                                           | 1.5.6       |
|            | curlimages/curl                                                        | latest      |
|            | ubuntu (OpenShift only)                                                | 22.04       |
|            | ghcr.io/spiffe/spiffe-csi-driver (OpenShift only)                      | 0.2.1       |
|            | registry.k8s.io/sig-storage/csi-node-driver-registrar (OpenShift only) | v2.7.0      |
| NATS       | nats                                                                   | 2.9-alpine  |
| Helm hooks | bitnami/kubectl                                                        | latest      |
{{% /table %}}

### Libraries
{{% table %}}
| NGINX Service Mesh | OpenTelemetry C++ |
|--------------------|-------------------|
| v1.7.0+            | 1.8.1             |
| v1.6.0             | 1.4.1             |
{{% /table %}}

### UDP
Linux kernel 4.18 is required if enabling UDP traffic proxying (disabled by default). Note that Amazon EKS v1.18 does not work with UDP enabled, due to it using Linux kernel 4.14.

## Recommended Sizing

A series of automated tests are frequently run to ensure mesh stability and reliability. For deployments less than 100 Pods, a minimum cluster environment is recommended:

{{% table %}}
| Environment | Machine Type                    | Number of Nodes      |
|-------------|---------------------------------|----------------------|
| GKE         | n2-standard-4 (4 vCPU, 16GB)    | 3                    |
| AKS         | Standard_D4s_v3 (4 vCPU, 16GiB) | 3                    |
| EKS         | t3.xlarge (4 vCPU, 16GiB)       | 3                    |
| AWS         | t3.xlarge (4 vCPU, 16GiB)       | 1 Control, 3 Workers |
{{% /table %}}

## Overhead

The overhead of NGINX Service Mesh varies depending on the component in the mesh and the type of resources currently deployed. The control plane is responsible for holding the state of all managed resources. Therefore, it scales up linearly with the number of resources being handled - be it Pods, Services, TrafficSplits, or any other resource in NGINX Service Mesh. Spire specifically watches for new workloads, which reside 1:1 in every Pod deployed. As a result, it scales up as more Pods are added to the mesh.

The data plane sidecar must keep track of the other Services in the mesh as well as any traffic policies that are associated with it. Therefore, the resource load will increase as a function of the number of Services and traffic policies in the mesh. In an attempt to balance the stress on the cluster, we run a nightly test which flexes the most critical components of the mesh. Below are the details of this test, so you may get an idea of the overhead each component is responsible for and size your own cluster accordingly.

### Stress Test Overhead

Cluster Information:

- Environment: GKE
- Node Type: n2-standard-4 (4 vCPU, 16GB)
- Number of nodes: 3
- Kubernetes Version: 1.18.16

Metrics were gathered using the Kubernetes Metrics API. CPU is calculated in terms of the number of *cpu* units, where one cpu is equivalent to 1 vCPU/Core. For more information on the metrics API and how the data is recorded, see [The Metrics API](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/#the-metrics-api) documentation.

#### CPU

{{% table %}}
| Num Services   | Control Plane (without metrics and tracing) | Control Plane Total | Average Sidecar |
|----------------|---------------------------------------------|---------------------|-----------------|
| 10 (20 Pods)   | CPU: 0.075 vCPU                             | CPU: 0.095 vCPU     | CPU: 0.033 vCPU |
| 50 (100 Pods)  | CPU: 0.097 vCPU                             | CPU: 0.431 vCPU     | CPU: 0.075 vCPU |
| 100 (200 Pods) | CPU: 0.148 vCPU                             | CPU: 0.233 vCPU     | CPU: 0.050 vCPU |
{{% /table %}}

#### Memory

{{% table %}}
| Num Services   | Control Plane (without metrics and tracing) | Control Plane Total  | Average Sidecar    |
|----------------|---------------------------------------------|----------------------|--------------------|
| 10 (20 Pods)   | Memory: 168.766 MiB                         | Memory: 767.500 MiB  | Memory: 33.380 MiB |
| 50 (100 Pods)  | Memory: 215.289 MiB                         | Memory: 2347.258 MiB | Memory: 38.542 MiB |
| 100 (200 Pods) | Memory: 272.305 MiB                         | Memory: 4973.992 MiB | Memory: 52.946 MiB |
{{% /table %}}

#### Disk Usage

Spire uses a persistent volume to make restarts more seamless. NGINX Service Mesh automatically allocates 1 GB persistent volume in supported environments (see [Persistent Storage]({{< ref "/mesh/get-started/platform-setup/persistent-storage.md" >}}) setup page for environment requirements). Below is the information on the disk usage within that volume. Disk usage scales directly with the number of Pods in the mesh.

{{% table %}}
| Num Pods | Disk Usage |
|----------|------------|
| 20       | 4.2 MB     |
| 100      | 4.3 MB     |
| 200      | 4.6 MB     |
{{% /table %}}

## Ports

The following table lists the ports and IP addresses the NGINX Service Mesh sidecar binds.

{{% table %}}
| Port  | IP Address | Protocol | Direction | Purpose                                     |
|-------|------------|----------|-----------|---------------------------------------------|
| 8900  | 0.0.0.0    | All      | Outgoing  | Redirect to virtual server for traffic type <sup>1</sup> |
| 8901  | 0.0.0.0    | All      | Incoming  | Redirect to virtual server for traffic type <sup>1</sup> |
| 8902  | localhost  | All      | Outgoing  | Redirection error                           |
| 8903  | localhost  | All      | Incoming  | Redirection error                           |
| 8904  | localhost  | TCP      | Incoming  | Main virtual server                         |
| 8905  | localhost  | TCP      | Incoming  | TCP traffic denied by [Access Control policies]( {{< ref "/mesh/guides/smi-traffic-policies.md#access-control" >}}) |
| 8906  | localhost  | TCP      | Outgoing  | Main virtual server                         |
| 8907  | localhost  | TCP      | Incoming  | Permissive virtual server <sup>2</sup>      |
| 8908  | 0.0.0.0    | UDP      | Outgoing  | Main virtual server                         |
| 8909  | 0.0.0.0    | UDP      | Incoming  | Main virtual server                         |
| 8886  | 0.0.0.0    | HTTP     | Control   | NGINX Plus API                              |
| 8887  | 0.0.0.0    | HTTP     | Control   | Prometheus metrics                          |
| 8888  | localhost  | HTTP     | Incoming  | Main virtual server                         |
| 8889  | localhost  | HTTP     | Outgoing  | Main virtual server                         |
| 8890  | localhost  | HTTP     | Incoming  | Permissive virtual server <sup>2</sup>      |
| 8891  | localhost  | GRPC     | Incoming  | Main virtual server                         |
| 8892  | localhost  | GRPC     | Outgoing  | Main virtual server                         |
| 8893  | localhost  | GRPC     | Incoming  | Permissive virtual server <sup>2</sup>      |
| 8894  | localhost  | HTTP     | Outgoing  | [NGINX Ingress Controller egress traffic]( {{< ref "/mesh/tutorials/kic/egress-walkthrough.md" >}} )      |
| 8895  | 0.0.0.0    | HTTP     | Incoming  | Redirect health probes <sup>3</sup>         |
| 8896  | 0.0.0.0    | HTTP     | Incoming  | Redirect HTTPS health probes <sup>3</sup>   |
{{% /table %}}

Notes:

1. All traffic is redirected to these two ports. From there the sidecar determines the traffic type and forwards the traffic to the *Main virtual server* for that traffic type.

2. The *Permissive virtual server* is used when permissive mTLS is configured. It's used to accept non-mTLS traffic, for example from Pods that aren't injected with a sidecar. See the [Secure Mesh Traffic using mTLS]({{< ref "/mesh/guides/secure-traffic-mtls.md" >}}) for more information on permissive mTLS.

3. The Kubernetes `readinessProbe` and `livenessProbe` need dedicated ports as they're not regular in-band mTLS traffic.
