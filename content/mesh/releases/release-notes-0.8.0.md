---
title: Release Notes 0.8.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -800
nd-docs: DOCS-708
type:
- reference
---

## NGINX Service Mesh Version 0.8.0

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 0.8.0, in the following categories:

- [NGINX Service Mesh Version 0.8.0](#nginx-service-mesh-version-080)
  - [Updates](#updates)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions](#supported-versions)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-0.8.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< ref "oss-dependencies/index.md" >}})

<span id="080-updates"></a>

### Updates

NGINX Service Mesh 0.8.0 includes the following updates:

- Bug fixes and improvements
- Updated NGINX Service Mesh sidecars to NGINX Plus R23
- Tested and documented support for the following platforms/tools:
  - minikube
  - kind
  - kubespray
- Support for new load balancing methods:
  - least_time
  - random two least_time
- NGINX Plus KIC daemon set support for ingress

<span id="080-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues. You can search by the issue ID to locate the details for an issue.



- *Command line tool may timeout connecting to control plane (10685)*



- *Namespaces stuck deleting after removing NGINX Service Mesh (17313)*



<span id="080-issues"></a>

### Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/><br/>


**Non-injected pods and services mishandled as fallback services (14731)**:
  <br/>

  We do not recommend using non-injected pods with a fallback service. Unless the non-injected fallback service is created following the proper order of operations, the service may not be recognized and updated in the circuit breaker flow.

Instead, we recommend using injected pods and services for service mesh injected workloads.

  <br/>
  Workaround:
  <br/><br/>

  If you must use non-injected workloads, you need to configure the fallback service and pods before the Circuit Breaker CRD references them.
  <br/><br/>


**Warning messages emitted when traffic access policies applied (17117)**:
  <br/>

  After successfully configuring traffic access polices (TrafficTarget, HTTPRouteGroup, TCPRoute), warning messages may be emitted to the `nginx-mesh-sidecar` logs.

For example:

```plaintext
2020/09/24 01:03:14 could not parse syslog message: nginx could not connect to upstream
```

This warning message is harmless and can safely be ignored. The message does not indicate an operational problem.
  <br/><br/>


**"Could not start API server" error is logged when Mesh API is shut down normally (17670)**:
  <br/>

  When the nginx-mesh-api Pod exits normally, the system may log the error "Could not start API server" and an error string. If the process is signaled, the signal value is lost and isn't printed correctly.

If the error shows "http: Server closed," the nginx-mesh-api Pod has properly exited, and this message can be disregarded.

Other legitimate error cases correctly show the error encountered, but this may be well after startup and proper operation.
  <br/><br/>


**Rejected configurations return generic HTTP status codes (18101)**:
  <br/>

  **The NGINX Service Mesh APIs are a beta feature.** Beta features are provided for you to try out before they are released. You shouldn't use beta features for production purposes.

The NGINX Service Mesh APIs validate input for configured resources. These validations may reject the configuration for various reasons, including non-sanitized input, duplicates, conflicts, and so on When these configurations are rejected, a 500 Internal Server error is generated and returned to the client.

  <br/>
  Workaround:
  <br/><br/>

  When configuring NGINX Service Mesh resources, do not use the NGINX Service Mesh APIs for production-grade releases if fine-grained error notifications are required. Each feature has Kubernetes API correlates that work according to the Kubernetes API Server semantics and constraints. All features are supported via Kubernetes.
  <br/><br/>


**Deployment may fail if NGINX Service Mesh is already installed (19351)**:
  <br/>

  If NGINX Service Mesh is installed in a namespace other than the default (nginx-mesh) and the deploy command is run without specifying the different namespace, the deployment may fail to clean up all of the NGINX Service Mesh resources.

  <br/>
  Workaround:
  <br/><br/>

  Always provide the `-n <namespace>` or `--namespace <namespace>` flag with every CLI command. Additionally, we recommend that you remove NGINX Service Mesh using the `nginx-meshctl remove` command before running `deploy`.
  <br/><br/>

**Cannot disable Prometheus scraping of the NGINX Ingress Controller (19375)**:
  <br/>

  The Prometheus server deployed by NGINX Service Mesh scrapes metrics from all containers with the name `nginx-plus-ingress`. Omitting the `prometheus.io/scrape` annotation or explicitly setting the annotation to `false` does not change this behavior.

  <br/>
  Workaround:
  <br/><br/>

  If you do not want Prometheus to scrape metrics from your NGINX Ingress Controller pods, you can change the container name to something other than `nginx-plus-ingress`.
  <br/><br/>


**Pods fail to deploy if invalid Jaeger tracing address is set (19469)**:
  <br/>
  If `--tracing-address` is set to an invalid Jaeger address when deploying NGINX Service Mesh, all pods will fail to start.

  <br/>
  Workaround:
  <br/><br/>

  If you use your own Zipkin or Jaeger instance with NGINX Service Mesh, make sure to correctly set `--tracing-address` when deploying the mesh.
  <br/><br/>


**Duplicate targetPorts in a Service are disregarded (20566)**:
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
  Workaround:
  <br/><br/>

  No workaround exists outside of reconfiguring the Service and application. The Service must use unique `.spec.ports[].targetPort` values (open up multiple ports on the application workload) or route all traffic to the application workload through the same Service port.
  <br/><br/>


**NGINX Service Mesh deployment may fail with TLS errors (20902)**:
  <br/>

  After deploying NGINX Service Mesh, the logs may show repeated TLS errors similar to the following:

From the smi-metrics Pod logs:

```bash
echo: http: TLS handshake error from :: remote error: tls: bad certificate
```

From the Kubernetes api-server log:

```bash
E0105 10:03:45.159812 1 controller.go:116] loading OpenAPI spec for "v1alpha1.metrics.smi-spec.io" failed with: failed to retrieve openAPI spec, http error: ResponseCode: 503, Body: error trying to reach service: x509: certificate signed by unknown authority (possibly because of "x509: ECDSA verification failure" while trying to verify candidate authority certificate "NGINX")
```

A race condition may occur during deployment where the Spire server fails to communicate its certificate authority (CA) to dependent resources. Without the CA, these subsystems cannot operate correctly: metrics aggregation layer, injection, and validation.

  <br/>
  Workaround:
  <br/><br/>

  You must [re-deploy NGINX Service Mesh](https://docs.nginx.com/nginx-service-mesh/reference/nginx-meshctl/):

```bash
nginx-meshctl remove
nginx-meshctl deploy ...
```

  <br/><br/>


<span id="080-supported"></a>

### Supported Versions

SMI Specification:

- Traffic Access: v1alpha2
- Traffic Metrics: v1alpha1 (in progress, supported resources: StatefulSets, Namespaces, Deployments, Pods, DaemonSets)
- Traffic Specs: v1alpha3
- Traffic Split: v1alpha3

NGINX Service Mesh SMI Extensions:

- Traffic Specs: v1alpha1



