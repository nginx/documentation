---
title: Release Notes 1.2.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -1200
nd-docs: DOCS-714
type:
- reference
---

## NGINX Service Mesh Version 1.2.0

14 September 2021

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 1.2.0, in the following categories:

- [NGINX Service Mesh Version 1.2.0](#nginx-service-mesh-version-120)
  - [Updates](#updates)
  - [Vulnerabilites](#vulnerabilities)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions](#supported-versions)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-1.2.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< ref "oss-dependencies/index.md" >}})

<br/>
<br/>
<span id="120-updates"></a>

### **Updates**

NGINX Service Mesh 1.2.0 includes the following updates:
<br/><br/>

- Support for Rancher and availability in the Rancher Catalog
- Support for running NSM on Red Hat OpenShift clusters
- Extended HTTP URI and Method-based routing and security policy support
- New supportpkg tool for enterprise customers
- Upgrade to Spire 1.0.2
- Deprecation
  - The following NGINX Service Mesh API endpoints are deprecated and are targeted to be removed in the v1.3.0 release:
    - /api/traffic-splits
    - /api/rate-limits
    - /api/traffic-targets
    - /api/http-route-groups
    - /api/tcp-routes
    - /api/circuit-breakers

<span id="120-resolved"></a>

### **Vulnerabilities**


#### **Fixes**

This release includes vulnerability fixes for the following issues.
<br/>

- None

<br/>

<span id="120-cvefixes"></a>

#### **Third Party Updates**

This release includes third party updates for the following issues.
<br/><br/>

- apk-tools CVE-2021-36159 CRITICAL (27973)

- apk-tools CVE-2021-30139 HIGH (27974)

- busybox CVE-2021-28831 HIGH (28092)

- libcrypto1.1 CVE-2021-23840 HIGH (28093)

- libcrypto1.1 CVE-2021-3450 HIGH (28094)

- libcrypto1.1 CVE-2021-3711 HIGH (28095)

- musl CVE-2019-14697 CRITICAL (28096)

- libcrypto1.1 CVE-2019-1543 HIGH (28097)

- libcrypto1.1 CVE-2020-1967 HIGH (28099)

- libssl1.1 CVE-2021-3450 HIGH (28100)

- libssl1.1 CVE-2021-3711 HIGH (28101)

- libssl1.1 CVE-2019-1543 HIGH (28102)

- libssl1.1 CVE-2020-1967 HIGH (28103)

- ssl_client CVE-2021-28831 HIGH (28104)

- krb5-libs CVE-2021-36222 HIGH (28105)

- openssl CVE-2021-3711 HIGH (28107)

- golang.org/x/crypto CVE-2020-29652 HIGH (28110)

- libcrypto1.1 CVE-2021-23841 MEDIUM (28111)

- libcrypto1.1 CVE-2021-3449 MEDIUM (28115)

- libcrypto1.1 CVE-2020-1971 MEDIUM (28118)

- libcrypto1.1 CVE-2019-1547 MEDIUM (28119)

- libcrypto1.1 CVE-2019-1549 MEDIUM (28121)

- libcrypto1.1 CVE-2019-1551 MEDIUM (28148)

- libssl1.1 CVE-2021-23841 MEDIUM (28149)

- libssl1.1 CVE-2021-3449 MEDIUM (28150)

- libssl1.1 CVE-2020-1971 MEDIUM (28152)

- libssl1.1 CVE-2019-1547 MEDIUM (28153)

- libssl1.1 CVE-2019-1549 MEDIUM (28154)

- libssl1.1 CVE-2019-1551 MEDIUM (28157)

- musl CVE-2020-28928 MEDIUM (28165)

- musl-utils CVE-2020-28928 MEDIUM (28166)

- libcrypto1.1 CVE-2021-23839 LOW (28171)

- libssl1.1 CVE-2021-23839 LOW (28172)

- libcrypto1.1 CVE-2019-1563 LOW (28173)

- libssl1.1 CVE-2019-1563 LOW (28174)

<br/>

<span id="120-thirdparty"></a>

### **Resolved Issues**

This release includes fixes for the following issues.
<br/><br/>


- "Could not start API server" error is logged when Mesh API is shut down normally (17670)

- NGINX Service Mesh deployment may fail with TLS errors (20902)

- Circuit Breaker functionality is incompatible with load balancing algorithm "random" (22718)

- Deployments enter a `CrashLoopBackoff` status after removing NGINX Service Mesh (25421)

- Spire fails to bind persistent volume claim when using deprecated NFS client (28468)

<br/>

<span id="120-issues"></a>

### **Known Issues**

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/>


<br/>**Non-injected pods and services mishandled as fallback services (14731)**:
  <br/>

We do not recommend using non-injected pods with a fallback service. Unless the non-injected fallback service is created following the proper order of operations, the service may not be recognized and updated in the circuit breaker flow.

Instead, we recommend using injected pods and services for service mesh injected workloads.
  <br/>
  <br/>
  Workaround:
  <br/>

If you must use non-injected workloads, you need to configure the fallback service and pods before the Circuit Breaker CRD references them.

Non-injected fallback servers are incompatible with mTLS mode strict.


<br/>**Rejected configurations return generic HTTP status codes (18101)**:
  <br/>

**The NGINX Service Mesh APIs are a beta feature.** Beta features are provided for you to try out before they are released. You shouldn't use beta features for production purposes.

The NGINX Service Mesh APIs validate input for configured resources. These validations may reject the configuration for various reasons, including non-sanitized input, duplicates, conflicts, and so on When these configurations are rejected, a 500 Internal Server error is generated and returned to the client.
  <br/>
  <br/>
  Workaround:
  <br/>

When configuring NGINX Service Mesh resources, do not use the NGINX Service Mesh APIs for production-grade releases if fine-grained error notifications are required. Each feature has Kubernetes API correlates that work according to the Kubernetes API Server semantics and constraints. All features are supported via Kubernetes.


<br/>**Pods fail to deploy if invalid Jaeger tracing address is set (19469)**:
  <br/>

If `--tracing-address` is set to an invalid Jaeger address when deploying NGINX Service Mesh, all pods will fail to start.
  <br/>
  <br/>
  Workaround:
  <br/>

If you use your own Zipkin or Jaeger instance with NGINX Service Mesh, make sure to correctly set `--tracing-address` when deploying the mesh.


<br/>**Duplicate targetPorts in a Service are disregarded (20566)**:
  <br/>

NGINX Service Mesh supports a variety of Service `.spec.ports[]` configurations and honors each port list item with one exception.

If the Service lists multiple port configurations that duplicate `.spec.ports[].targetPort`, the duplicates are disregarded. Only one port configuration is honored for traffic forwarding, authentication, and encryption.

Example invalid configuration:

``` plaintext
apiVersion: v1
kind: Service
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 55555
  - port: 9090
    protocol: TCP
    targetPort: 55555
```

  <br/>
  <br/>
  Workaround:
  <br/>

No workaround exists outside of reconfiguring the Service and application. The Service must use unique `.spec.ports[].targetPort` values (open up multiple ports on the application workload) or route all traffic to the application workload through the same Service port.


<br/>**NGINX Service Mesh DNS Suffix support (21951)**:
  <br/>

NGINX Service Mesh only supports the `cluster.local` DNS suffix. Services such as Grafana and Prometheus will not work in clusters with a custom DNS suffix.
  <br/>
  <br/>
  Workaround:
  <br/>

Ensure your cluster is setup with the default `cluster.local` DNS suffix.


<br/>**Optional, default visualization dependencies may cause excessive disk usage (23886)**:
  <br/>

NGINX Service Mesh deploys optional metrics, tracing, and visualization services by default. These services are deployed as a convenience for evaluation and demonstration purposes only; these optional deployments should not be used in production.

NGINX Service Mesh supports a "Bring Your Own" model where individual organizations can manage and tailor third-party dependencies. The optional dependencies -- Prometheus for metrics, Jaeger or Zipkin for tracing, and Grafana for visualization -- should be managed separately for production environments. The default deployments may cause excessive disk usage as their backing stores may be written to Node local storage. In high traffic environments, this may cause DiskPressure warnings and evictions.
  <br/>
  <br/>
  Workaround:
  <br/>

To mitigate disk usage issues related to visualization dependencies in high traffic environments, we recommend the following:

- Do not run high capacity applications with default visualization software.
- Use the `--disable-tracing` option at deployment or provide your own service with `--tracing-backend`
- Use the `--deploy-grafana=false` option at deployment and provide your service to query Prometheus
- Use the `--prometheus-address` option at deployment and provide your own service

Refer to the [NGINX Service Mesh: Monitoring and Tracing](https://docs.nginx.com/nginx-service-mesh/guides/monitoring-and-tracing/) guide for additional guidance.


<br/>**`ImagePullError` for `nginx-mesh-api` may not be obvious (24182)**:
  <br/>

When deploying NGINX Service Mesh, if the `nginx-mesh-api` image cannot be pulled, and as a result `nginx-meshctl` cannot connect to the mesh API, the error that's shown simply says to "check the logs" without further  instruction on what to check for.
  <br/>
  <br/>
  Workaround:
  <br/>

If `nginx-meshctl` fails to connect to the mesh API when deploying, you should check to see if an `ImagePullError` exists for the `nginx-mesh-api` Pod. If you find an `ImagePullError`, you should confirm that your registry server is correct when deploying the mesh.


<br/>**Use of an invalid container image does not report an immediate error (24899)**:
  <br/>

If you pass an invalid value for `--registry-server` and/or `--image-tag` (for example, an unreachable host, an invalid or non-existent path-component or an invalid or non-existent tag), the `nginx-meshctl` command will only notify of an error when it verifies the installation. The verification stage of deployment may take over 2 minutes before running.

An image name constructed from `--registry-server` and `--image-tag`, when invalid, will only notify of an error once the `nginx-meshctl` command begins verifying the deployment. The following message will be displayed after a few minutes of running:

```plaintext
All resources created. Testing the connection to the Service Mesh API Server...
Connection to NGINX Service Mesh API Server failed.
	Check the logs of the nginx-mesh-api container in namespace nginx-mesh for more details.
Error: failed to connect to Mesh API Server, ensure you are authorized and can access services in your Kubernetes cluster
```

Running `kubectl -n nginx-mesh get pods` will show containers in an `ErrImagePull` or `ImagePullBackOff` status.

For example:

```plaintext
NAME                                  READY   STATUS                  RESTARTS   AGE
grafana-5647fdf464-hx9s4              1/1     Running                 0          64s
jaeger-6fcf7cd97b-cgrt9               1/1     Running                 0          64s
nats-server-6bc4f9bbc8-jxzct          0/2     Init:ImagePullBackOff   0          2m9s
nginx-mesh-api-84898cbc67-tdwdw       0/1     ImagePullBackOff        0          68s
nginx-mesh-metrics-55fd89954c-mbb25   0/1     ErrImagePull            0          66s
prometheus-8d5fb5879-fgdbh            1/1     Running                 0          65s
spire-agent-47t2w                     1/1     Running                 1          2m49s
spire-agent-8pnch                     1/1     Running                 1          2m49s
spire-agent-qtntx                     1/1     Running                 0          2m49s
spire-server-0                        2/2     Running                 0          2m50s
```

  <br/>
  <br/>
  Workaround:
  <br/>

You must correct your `--registry-server` and/or `--image-tag` arguments to be valid values.

In a non-air gapped deployment, be sure to use `docker-registry.nginx.com/nsm` and a valid version tag appropriate to your requirements. See <https://docs.nginx.com/nginx-service-mesh/get-started/install/> for more details.

In an air gapped deployment, be sure to use the correct private registry domain and path for your environment and the correct tag used when loading images.


<br/>**Invalid rate limit configurations are allowed (28043)**:
  <br/>

Invalid rate limit configurations, for example a rate limit that references the same destination and source(s) as an existing rate limit, can be created in Kubernetes without error.
  <br/>
  <br/>
  Workaround:
  <br/>

Check if your rate limit configuration is valid by describing your rate limit after creation: `kubectl describe ratelimit <rate-limit-name>`


<br/>**Tracer address reported by nginx-meshctl config when no tracer is deployed (28256)**:
  <br/>

If NGINX Service Mesh is deployed without a tracing backend, `nginx-meshctl config` reports the default tracing backend (jaeger) and the default tracing backend address ("jaeger.<mesh-namespace>.svc.cluster.local:6831"). This has no impact on the functionality of the mesh as tracing is disabled.
  <br/>
  <br/>
  Workaround:
  <br/>

No workaround necessary.


<br/>

<span id="120-supported"></a>


### **Supported Versions**
<br/>

NGINX Service Mesh supports the following versions:

Kubernetes:

- 1.16-1.21

OpenShift

- 4.8

Helm:

- 3.5, 3.6

Rancher:

- 2.6

NGINX Plus Ingress Controller:

- 1.12.0

SMI Specification:

- Traffic Access: v1alpha2
- Traffic Metrics: v1alpha1 (in progress, supported resources: StatefulSets, Namespaces, Deployments, Pods, DaemonSets)
- Traffic Specs: v1alpha3
- Traffic Split: v1alpha3

NSM SMI Extensions:

- Traffic Specs:

  - RateLimit: v1alpha1,v1alpha2
  - CircuitBreaker: v1alpha1
