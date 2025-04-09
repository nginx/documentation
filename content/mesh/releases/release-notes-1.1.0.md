---
title: Release Notes 1.1.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -1100
docs: DOCS-713
type:
- reference
---

## NGINX Service Mesh Version 1.1.0

29 June 2021

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 1.1.0, in the following categories:

- [NGINX Service Mesh Version 1.1.0](#nginx-service-mesh-version-110)
  - [Updates](#updates)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions](#supported-versions)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-1.1.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< ref "oss-dependencies/index.md" >}})

<span id="110-updates"></a>

### Updates

NGINX Service Mesh 1.1.0 includes the following updates:

**Improvements**
<br/>

- Helm Support for install and removal
- Air-gap installation support for private environments
- In-place upgrades for non-disruptive version updates (control plane, data plane)
- Update to NGINX Plus R24 P1 sidecar images
- Update to SPIRE 0.12.3 images


**Bug fixes**
<br/>

- Better error handling on mesh startup
- Fixed issue where re-roll instructions and service details were incorrectly flagging NGINX Plus Ingress Controller as including a sidecar
- Enhanced error notification when installing in existing namespace

<span id="110-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues. You can search by the issue ID to locate the details for an issue.


**Kubernetes reports warnings on versions >=1.19 (22721)**
<br/>

**Deploying NGINX Service Mesh to an existing namespace fails and returns an inaccurate error (24599)**
<br/>


<span id="110-issues"></a>

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

Non-injected fallback servers are incompatible with mTLS mode strict.
  <br/><br/>


**"Could not start API server" error is logged when Mesh API is shut down normally (17670)**:
  <br/>

When the nginx-mesh-api Pod exits normally, the system may log the error "Could not start API server" and an error string. If the process is signaled, the signal value is lost and isn't printed correctly.

If the error shows "http: Server closed," the nginx-mesh-api Pod has properly exited, and this message can be disregarded.

Other legitimate error cases correctly show the error encountered, but this may be well after startup and proper operation.

  <br/>
  Workaround:
  <br/><br/>

No workaround exists, the exit messages are innocuous.
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


**NGINX Service Mesh DNS Suffix support (21951)**:
  <br/>

NGINX Service Mesh only supports the `cluster.local` DNS suffix. Services such as Grafana and Prometheus will not work in clusters with a custom DNS suffix.

  <br/>
  Workaround:
  <br/><br/>

Ensure your cluster is setup with the default `cluster.local` DNS suffix.
  <br/><br/>


**Circuit Breaker functionality is incompatible with load balancing algorithm "random" (22718)**:
  <br/>

Circuit Breaker functionality is incompatible with the "random" load balancing algorithm. The two configurations interfere with each other and lead to errors. If Circuit Breaker resources exist in your environment, you cannot use the global load balancing algorithm "random" or an annotation for specific Services. The opposite is also true: if using the "random" algorithm, you cannot create Circuit Breaker resources.

  <br/>
  Workaround:
  <br/><br/>

If Circuit Breakers (API Version: specs.smi.nginx.com/v1alpha1 Kind: CircuitBreaker) are configured, the load balancing algorithm "random" cannot be used. Combining Circuit Breaker with "random" load balancing will result in errors and cause the sidecar containers to exit in error. Data flow will be detrimentally affected.

There is no workaround at this time, but the configuration can be changed dynamically. If another load balancing algorithm is set, the sidecars will reset and traffic will return to normal operations.

To fix the issue, take one or more of the following actions:

- All load balancing annotations (config.nsm.nginx.com/lb-method) should be removed or updated to another supported algorithm.
- The global load balancing algorithm should be set to another supported algorithm.
  <br/><br/>


**Optional, default visualization dependencies may cause excessive disk usage (23886)**:
  <br/>

NGINX Service Mesh deploys optional metrics, tracing, and visualization services by default. These services are deployed as a convenience for evaluation and demonstration purposes only; these optional deployments should not be used in production.

NGINX Service Mesh supports a "Bring Your Own" model where individual organizations can manage and tailor third-party dependencies. The optional dependencies -- Prometheus for metrics, Jaeger or Zipkin for tracing, and Grafana for visualization -- should be managed separately for production environments. The default deployments may cause excessive disk usage as their backing stores may be written to Node local storage. In high traffic environments, this may cause DiskPressure warnings and evictions.

  <br/>
  Workaround:
  <br/><br/>

To mitigate disk usage issues related to visualization dependencies in high traffic environments, we recommend the following:

- Do not run high capacity applications with default visualization software.
- Use the `--disable-tracing` option at deployment or provide your own service with `--tracing-backend`
- Use the `--deploy-grafana=false` option at deployment and provide your service to query Prometheus
- Use the `--prometheus-address` option at deployment and provide your own service

Refer to the [NGINX Service Mesh: Monitoring and Tracing](https://docs.nginx.com/nginx-service-mesh/guides/monitoring-and-tracing/) guide for additional guidance.
  <br/><br/>


**`ImagePullError` for `nginx-mesh-api` may not be obvious (24182)**:
  <br/>

When deploying NGINX Service Mesh, if the `nginx-mesh-api` image cannot be pulled, and as a result `nginx-meshctl` cannot connect to the mesh API, the error that's shown simply says to "check the logs" without further  instruction on what to check for.

  <br/>
  Workaround:
  <br/><br/>

If `nginx-meshctl` fails to connect to the mesh API when deploying, you should check to see if an `ImagePullError` exists for the `nginx-mesh-api` Pod. If you find an `ImagePullError`, you should confirm that your registry server is correct when deploying the mesh.
  <br/><br/>


**Use of an invalid container image does not report an immediate error (24899)**:
  <br/>

If you pass an invalid value for `--registry-server` and/or `--image-tag` (for example an unreachable host, an invalid or non-existent path-component or an invalid or non-existent tag), the `nginx-meshctl` command will only notify of an error when it verifies the installation. The verification stage of deployment may take over 2 minutes before running.

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
  Workaround:
  <br/><br/>

You must correct your `--registry-server` and/or `--image-tag` arguments to be valid values.

In a non-air gapped deployment, be sure to use `docker-registry.nginx.com/nsm` and a valid version tag appropriate to your requirements. See <https://docs.nginx.com/nginx-service-mesh/get-started/install/> for more details.

In an air gapped deployment, be sure to use the correct private registry domain and path for your environment and the correct tag used when loading images.
  <br/><br/>


**Deployments enter a `CrashLoopBackoff` status after removing NGINX Service Mesh (25421)**:
  <br/>

If a traffic policy (RateLimit, TrafficSplit, and so on) is still applied when removing NGINX Service Mesh, the sidecar container will crash causing the pod to enter a `CrashLoopBackoff` state.

  <br/>
  Workaround:
  <br/><br/>

Remove all NGINX Service Mesh traffic policies before removing the mesh. Alternatively, you can re-roll all deployments after removing the mesh which will resolve the `CrashLoopBackoff` state.
  <br/><br/>


<span id="110-supported"></a>

### Supported Versions

Supported Kubernetes Versions

NGINX Service Mesh has been verified to run on the following Kubernetes versions:

- Kubernetes 1.16-1.20

NGINX Plus Ingress Controller:

- 1.11

SMI Specification:

- Traffic Access: v1alpha2
- Traffic Metrics: v1alpha1 (in progress, supported resources: StatefulSets, Namespaces, Deployments, Pods, DaemonSets)
- Traffic Specs: v1alpha3
- Traffic Split: v1alpha3

NSM SMI Extensions:

- Traffic Specs: v1alpha1




