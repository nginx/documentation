---
title: Release Notes 1.4.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -1400
docs: DOCS-1488
type:
- reference
---

## NGINX Service Mesh Version 1.4.0

23 February 2022

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 1.4.0, in the following categories:

- [NGINX Service Mesh Version 1.4.0](#nginx-service-mesh-version-140)
  - [Updates](#updates)
  - [Vulnerabilites](#vulnerabilities)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions](#supported-versions)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-1.4.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< relref "oss-dependencies/index.md" >}})

<br/>
<br/>
<span id="140-updates"></a>

### **Updates**

NGINX Service Mesh 1.4.0 includes the following updates:
<br/>

- NGINX Service Mesh has changed its API to follow Kubernetes convention enabling granular controls of the NGINX Service Mesh API using Kubernetes native RBAC.
  - [Use the NGINX Service Mesh API]({{< relref "mesh/reference/api-usage.md" >}})
- Support for service-to-service UDP traffic proxying
- The addition of OpenTelemetry tracing along side the existing OpenTracing support to provide rich telemetry options
- Coupling with the cert-manager project to instantly drop into your existing Certificate Authority issuer workflow

#### **Deprecation**

- Starting in v1.5.0 release, NGINX Service Mesh will no longer bundle Prometheus, Grafana, or tracing pods.
  - The --disable-tracing and --deploy-grafana flags are deprecated and will be removed in v1.5.0
  - The tracing.disable and deployGrafana helm values are deprecated and will be removed in v1.5.0
  - The config.nsm.nginx.com/tracing-enabled pod annotation is deprecated and will be removed in v1.5.0

#### **Features**

- [Support for UDP traffic proxying]({{< relref "mesh/about/architecture.md/#udp-and-ebpf" >}})
- [Support for OpenTelemetry tracing using the OTLP gRPC Exporter]({{< relref "mesh/guides/monitoring-and-tracing.md/#opentelemetry" >}})
- [Support for cert-manager as an upstream authority]({{< relref "mesh/guides/secure-traffic-mtls.md/#deploy-using-an-upstream-root-ca" >}})
- [How to access the NGINX Service Mesh API using Kubernetes native RBAC]({{< relref "mesh/reference/api-usage.md" >}})

#### **Improvements**

- Updated to Spire 1.2.0
- Tightened API access

#### **Fixes**

- Openshift CSI Driver is automatically cleaned up after mesh removal once all workloads have been re-rolled or deleted

<span id="140-resolved"></a>

### **Vulnerabilities**


#### **Fixes**

This release includes vulnerability fixes for the following issues.
<br/>

- None

<br/>

<span id="140-cvefixes"></a>

#### **Third Party Updates**

This release includes third party updates for the following issues.
<br/><br/>

- github.com/apache/thrift CVE-2020-13949 HIGH (22)

- busybox CVE-2021-42374, CVE-2021-42375, CVE-2021-42378, CVE-2021-42379, CVE-2021-42380, CVE-2021-42381, CVE-2021-42382, CVE-2021-42383, CVE-2021-42384 HIGH CVE-2021-42385, CVE-2021-42386 MEDIUM (677)

- github.com/containerd/containerd CVE-2021-41103 HIGH  (678)

- golang.org/x/crypto/ssh CVE-2020-29652 HIGH (734)

- golang.org/x/text CVE-2021-38561 HIGH (735)

- github.com/containerd/containerd CVE-2021-43816 CRITICAL (776)

<br/>

<span id="140-thirdparty"></a>

### **Resolved Issues**

This release includes fixes for the following issues.
<br/><br/>


- NGINX Service Mesh cannot be deployed or removed (428)

- Invalid rate limit configurations are allowed (449)

- Optional, default visualization dependencies may cause excessive disk usage (498)

<br/>

<span id="140-issues"></a>

### **Known Issues**

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/>


<br/>**Spire Server crashes after reaching ~1500 certificate rotations (375)**:
  <br/>

After reaching approximately 1500 certificate rorations, the Spire Server crashes. This condition can be reached by either setting your certificate authority TTL to a low number, for example, {{--mtls-ca-ttl 1m --mtls-svid-ttl 1m}} – or leaving the mesh running for extended periods of time.
  <br/>
  <br/>
  Workaround:
  <br/>

Use the default TTL, which would produce the conditions that cause the crash after about 100 years of continuous operation. If you must use a lower TTL that will result in a significant number of certificate rotations, redeploy NGINX Service Mesh to refresh its state _before_ the crash conditions can be reached.


<br/>**Pods can't be created if nginx-mesh-api is unreachable (384)**:
  <br/>

If the nginx-mesh-api Pod cannot be reached by the "sidecar-injector-webhook-cfg.internal.builtin.nsm.nginx" MutatingWebhookConfiguration, then all Pod creations will fail.
  <br/>
  <br/>
  Workaround:
  <br/>

If attempting to create Pods that are not going to be injected by NGINX Service Mesh, then the simplest solution is to remove NGINX Service Mesh.

Otherwise, if the nginx-mesh-api Pod is crashing, then the user should verify that their configuration when deploying NGINX Service Mesh is valid. Reinstalling the mesh may also fix connectivity issues.


<br/>**Deploying a TrafficSplit with an invalid weight value fails but does not return any errors (426)**:
  <br/>

When deploying a TrafficSplit, it is possible to set the weight value as a negative integer. NGINX Service Mesh does not support negative-integer weights, so the TrafficSplit will appear to deploy successfully but will not take effect. No error or log message is returned to indicate that the TrafficSplit deployment has failed.
  <br/>
  <br/>
  Workaround:
  <br/>

Be sure to use positive integers when assigning weight values to TrafficSplits.


<br/>**Tracer address reported by nginx-meshctl config when no tracer is deployed (440)**:
  <br/>

If NGINX Service Mesh is deployed without a tracing backend, `nginx-meshctl config` reports the default tracing backend (jaeger) and the default tracing backend address ("jaeger.<mesh-namespace>.svc.cluster.local:6831"). This has no impact on the functionality of the mesh as tracing is disabled.
  <br/>
  <br/>
  Workaround:
  <br/>

No workaround necessary.


<br/>**NGINX Service Mesh DNS Suffix support (519)**:
  <br/>

NGINX Service Mesh only supports the `cluster.local` DNS suffix. Services such as Grafana and Prometheus will not work in clusters with a custom DNS suffix.
  <br/>
  <br/>
  Workaround:
  <br/>

Ensure your cluster is setup with the default `cluster.local` DNS suffix.


<br/>**Duplicate targetPorts in a Service are disregarded (532)**:
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


<br/>**Pods fail to deploy if invalid Jaeger tracing address is set (540)**:
  <br/>

If `--tracing-address` is set to an invalid Jaeger address when deploying NGINX Service Mesh, all pods will fail to start.
  <br/>
  <br/>
  Workaround:
  <br/>

If you use your own Zipkin or Jaeger instance with NGINX Service Mesh, make sure to correctly set `--tracing-address` when deploying the mesh.


<br/>**Inject command errors are ambiguous (789)**:
  <br/>

Inject command may return ambiguous error messages:

{noformat}./build/nginx-meshctl inject < example.yaml
Cannot inject NGINX Service Mesh sidecar.
Error: error formatting response string: invalid syntax{noformat}

This error can be returned due to invalid encoding, if the control plane is down, if NGINX Service Mesh is not installed, or if it is installed in an unexpected namespace.
  <br/>
  <br/>
  Workaround:
  <br/>

When encountering an error from Inject do the following checks:

  1. Verify you have valid YAML.
  2. Check the status of your install: {{nginx-meshctl status}}
  3. Check the status of you Pods: {{kubectl -n nginx-mesh get pods}}

If steps 2 or 3 show failures, or Pods that are not in the Running state, NGINX Service Mesh will need further troubleshooting. Pods may be restarted through {{kubectl}} by using {{rollout restart}} on the Deployments, or by deleting the Pod resources. If the issue persists contact your support agent.


<br/>

<span id="140-supported"></a>


### **Supported Versions**
<br/>

NGINX Service Mesh supports the following versions:

Kubernetes:

- 1.18-1.22

OpenShift

- 4.8

Helm:

- 3.2+

Rancher:

- 2.5, 2.6

NGINX Plus Ingress Controller:

- 1.12, 2.0, 2.1

Note: The minimum supported version of Kubernetes is 1.19 if you are running NGINX Plus Ingress Controller 2.0. For older Kubernetes versions, use the NGINX Plus Ingress Controller 1.12 version.

SMI Specification:

- Traffic Access: v1alpha2
- Traffic Metrics: v1alpha1 (in progress, supported resources: StatefulSets, Namespaces, Deployments, Pods, DaemonSets)
- Traffic Specs: v1alpha3
- Traffic Split: v1alpha3

NSM SMI Extensions:

- Traffic Specs:

  - RateLimit: v1alpha1,v1alpha2
  - CircuitBreaker: v1alpha1


