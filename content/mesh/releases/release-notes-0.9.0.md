---
title: Release Notes 0.9.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -900
nd-docs: DOCS-709
type:
- reference
---

## NGINX Service Mesh Version 0.9.0

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 0.9.0, in the following categories:

- [NGINX Service Mesh Version 0.9.0](#nginx-service-mesh-version-090)
  - [Updates](#updates)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions](#supported-versions)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-0.9.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< ref "oss-dependencies/index.md" >}})

<span id="090-updates"></a>

### Updates

NGINX Service Mesh 0.9.0 includes the following updates:

- Support for Datadog OpenTracing end-point
- Updates to Grafana dashboard metrics
- Spire support for AWS Private CA
- Greater support and control over pod egress traffic policies
- Access control default behavior can now be set at install
- Support for NGINX Plus Ingress Controller v1.10 for ingress and egress traffic management
- New tutorials and updated docs
- Bug fixes and improvements

<span id="090-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues. You can search by the issue ID to locate the details for an issue.



<span id="090-issues"></a>

### Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
 <br/><br/>

**Non-injected pods and services mishandled as fallback services (14731)**
  <br/>

  We do not recommend using non-injected pods with a fallback service. Unless the non-injected fallback service is created following the proper order of operations, the service may not be recognized and updated in the circuit breaker flow.

Instead, we recommend using injected pods and services for service mesh injected workloads.

  <br/>
  Workaround:
  <br/><br/>
  If you must use non-injected workloads, you need to configure the fallback service and pods before the Circuit Breaker CRD references them.
  <br/><br/>


**Warning messages emitted when traffic access policies applied(17117)**
  <br/>

  After successfully configuring traffic access polices (TrafficTarget, HTTPRouteGroup, TCPRoute), warning messages may be emitted to the `nginx-mesh-sidecar` logs.

For example:

```plaintext
2020/09/24 01:03:14 could not parse syslog message: nginx could not connect to upstream
```

This warning message is harmless and can safely be ignored. The message does not indicate an operational problem.
 <br/><br/>


**"Could not start API server" error is logged when Mesh API is shut down normally (17670)**
  <br/>

  When the nginx-mesh-api Pod exits normally, the system may log the error "Could not start API server" and an error string. If the process is signaled, the signal value is lost and isn't printed correctly.

If the error shows "http: Server closed," the nginx-mesh-api Pod has properly exited, and this message can be disregarded.

Other legitimate error cases correctly show the error encountered, but this may be well after startup and proper operation.
  <br/><br/>


**Rejected configurations return generic HTTP status codes (18101)**
  <br/>

  **The NGINX Service Mesh APIs are a beta feature.** Beta features are provided for you to try out before they are released. You shouldn't use beta features for production purposes.

The NGINX Service Mesh APIs validate input for configured resources. These validations may reject the configuration for various reasons, including non-sanitized input, duplicates, conflicts, and so on When these configurations are rejected, a 500 Internal Server error is generated and returned to the client.

 <br/>
  Workaround:
  <br/><br/>

  When configuring NGINX Service Mesh resources, do not use the NGINX Service Mesh APIs for production-grade releases if fine-grained error notifications are required. Each feature has Kubernetes API correlates that work according to the Kubernetes API Server semantics and constraints. All features are supported via Kubernetes.
  <br/><br/>


**Deployment may fail if NGINX Service Mesh is already installed (19351)**
  <br/>

  If NGINX Service Mesh is installed in a namespace other than the default (nginx-mesh) and the deploy command is run without specifying the different namespace, the deployment may fail to clean up all of the NGINX Service Mesh resources.

  <br/>
  Workaround:
  <br/><br/>

  Always provide the `-n <namespace>` or `--namespace <namespace>` flag with every CLI command. Additionally, we recommend that you remove NGINX Service Mesh using the `nginx-meshctl remove` command before running `deploy`.
  <br/><br/>


**Cannot disable Prometheus scraping of the NGINX Ingress Controller (19375)**
  <br/>

  The Prometheus server deployed by NGINX Service Mesh scrapes metrics from all containers with the name `nginx-plus-ingress`. Omitting the `prometheus.io/scrape` annotation or explicitly setting the annotation to `false` does not change this behavior.

  <br/>
  Workaround:
  <br/><br/>

  If you do not want Prometheus to scrape metrics from your NGINX Ingress Controller pods, you can change the container name to something other than `nginx-plus-ingress`.
  <br/><br/>

**Pods fail to deploy if invalid Jaeger tracing address is set (19469)**
  <br/>

  If `--tracing-address` is set to an invalid Jaeger address when deploying NGINX Service Mesh, all pods will fail to start.

  <br/>
  Workaround:
  <br/><br/>

  If you use your own Zipkin or Jaeger instance with NGINX Service Mesh, make sure to correctly set `--tracing-address` when deploying the mesh.
  <br/><br/>


**Duplicate targetPorts in a Service are disregarded (20566)**
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

**NGINX Service Mesh deployment may fail with TLS errors (20902)**
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


**The `nginx-meshctl remove` command may not list all resources that require a restart (22710)**
  <br/>

  The `nginx-meshctl remove` command may fail to list all the resources that require a restart if there are different resources in the same namespace with the same name (for example, DaemonSets and Deployments). Every resource will not be listed. Only the namespace/name will be listed once.

  <br/>
  Workaround:
  <br/><br/>

  During the NGINX Service Mesh removal process, a list of resources of injected resources is compiled. These resources require a restart to remove the sidecar containers; this task is left for the administrator to complete because traffic flow will be affected.

The compiled list may not be entirely accurate. If resources of different kinds share the same name and namespace, the namespace/name pair will be printed only once. When removing NGINX Service Mesh, be sure to query the Kubernetes API for various supported resource kinds to completely remove the superfluous sidecars.
 <br/><br/>

**Circuit Breaker functionality is incompatible with load balancing algorithm "random" (22718)**
  <br/>

  Circuit Breaker functionality is incompatible with the "random" load balancing algorithm. The two configurations interfere with each other and lead to errors. If Circuit Breaker resources exist in your environment, you cannot use the global load balancing algorithm "random" or an annotation for specific Services. The opposite is also true: if using the "random" algorithm, you cannot create Circuit Breaker resources.

  <br/>
  Workaround:
  <br/><br/>

  If Circuit Breakers (API Version: specs.smi.nginx.com/v1alpha1 Kind: CircuitBreaker) are configured, the load balancing algorithm "random" cannot be used. Combining Circuit Breaker with "random" load balancing will result in errors and cause the sidecar containers to exit in error. Data flow will be detrimentally affected.

There is no workaround at this time, but the configuration can be changed dynamically. If another load balancing algorithm is set, the sidecars will reset and traffic will return to normal operations.

To fix the issue, take one or more of the following actions:

- All load balancing annotations (config.nsm.nginx.com/lb-method) should be removed or updated to another supported algorithm (see [Configuration Options for NGINX Service Mesh]({{< ref "/mesh/get-started/install/configuration.md" >}})).
- The global load balancing algorithm should be set to another supported algorithm (see [Configuration Options for NGINX Service Mesh]({{< ref "/mesh/get-started/install/configuration.md" >}})) .
 <br/><br/>

**Kubernetes reports warnings on versions >=1.19 (22721)**
  <br/>

  NGINX Service Mesh dependencies use older API versions that newer Kubernetes versions issue a deprecation warning for. Until these resource versions are updated, an NGINX Service Mesh installation will issue the following warnings:


```plaintext
W0303 00:12:03.484737 44320 warnings.go:70] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
```

```plaintext
W0303 00:12:04.996104 44320 warnings.go:70] admissionregistration.k8s.io/v1beta1 ValidatingWebhookConfiguration is deprecated in v1.16+, unavailable in v1.22+; use admissionregistration.k8s.io/v1 ValidatingWebhookConfiguration
```

  <br/>
  Workaround:
  <br/><br/>

  These are deprecation warnings. The resources are supported but will not be in an upcoming release. There is nothing that you need to do.
 <br/><br/>


**`nginx-meshctl version` command may display errors (22797)**
  <br/>

  The `nginx-meshctl version` command may display errors due to a variety of connectivity issues. The command always reports its own version while also attempting to gather the version of other mesh assets. If the command cannot contact a running cluster or use a valid kubeconfig, it will print out internal conditions.

  <br/>
  Workaround:
  <br/><br/>

  You can safely ignore these errors. The nginx-meshctl version command should gracefully ignore assets it can't discover. The command displays its version and then conducts a best-effort discovery of other mesh assets.

If you are receiving this message, be sure to:

- verify your kubeconfig location, and if non-default, pass that in with an argument
- verify your kubeconfig context is set to a valid and running cluster
- verify that you have installed NGINX Service Mesh and the Pods are running in your chosen namespace
 <br/><br/>


**Pods with HTTPGet health probes may not start if manually injected (22861)**
  <br/>

  Kubernetes liveness, readiness, and startup HTTP/S health probes are rewritten at injection time. If an HTTP probe does not specify the scheme of the request, and the Pod is manually injected, the probe is rewritten without a scheme, and the Pod will fail to start.

  <br/>
  Workaround:
  <br/><br/>

  Specify a scheme when defining HTTPGet health probes.
 <br/><br/>


<span id="090-supported"></a>

### Supported Versions

Supported Kubernetes Versions

NGINX Service Mesh has been verified to run on the following Kubernetes versions:

- Kubernetes 1.16-1.20

SMI Specification:

- Traffic Access: v1alpha2
- Traffic Metrics: v1alpha1 (in progress, supported resources: StatefulSets, Namespaces, Deployments, Pods, DaemonSets)
- Traffic Specs: v1alpha3
- Traffic Split: v1alpha3

NGINX Service Mesh SMI Extensions:

- Traffic Specs: v1alpha1




