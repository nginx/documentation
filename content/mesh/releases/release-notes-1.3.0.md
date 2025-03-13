---
title: Release Notes 1.3.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -1300
docs: DOCS-716
type:
- reference
---

## NGINX Service Mesh Version 1.3.0

16 November 2021

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 1.3.0, in the following categories:

- [NGINX Service Mesh Version 1.3.0](#nginx-service-mesh-version-130)
  - [Updates](#updates)
  - [Vulnerabilites](#vulnerabilities)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions](#supported-versions)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-1.3.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< relref "oss-dependencies/index.md" >}})

<br/>
<br/>
<span id="130-updates"></a>

### **Updates**

NGINX Service Mesh 1.3.0 includes the following updates:
<br/><br/>

#### **Product Enhancements**

- Ability to configure certificate TTL after deploy
- Configurable certificate size and type
- Support for IAM roles when using AWS PCA as the upstream CA
- Upgrade support for NGINX Service Mesh running in Red Hat OpenShift
- Availability of NGINX Service Mesh in the Rancher Catalog
- Support for Kubernetes 1.22

#### **Functional Enhancements**

- `--registry-server` flag is no longer required when deploying the mesh with nginx-meshctl. Defaults to the value `docker-registry.nginx.com/nsm`.
- API field `mtlsMode` has been deprecated in favor of `mtls.mode`.
- The SPIRE server only issues certificates for Pods that are injected with the NGINX Service Mesh sidecar. If you are upgrading to NGINX Service Mesh 1.3 and are running NGINX Plus Ingress Controller, add following label `spiffe.io/spiffeid: "true"` to the NGINX Plus Ingress Controller Pod spec(s) and re-roll the Pod(s). This ensures that the SPIRE server will issue a certificate for the NGINX Plus Ingress Controller.

### **The following NGINX Service Mesh API endpoints have been removed:**

- /api/traffic-splits
- /api/rate-limits
- /api/traffic-targets
- /api/http-route-groups
- /api/tcp-routes
- /api/circuit-breakers

<span id="130-resolved"></a>

### **Vulnerabilities**


#### **Fixes**

This release includes vulnerability fixes for the following issues.
<br/>

- None

<br/>

<span id="130-cvefixes"></a>

#### **Third Party Updates**

This release includes third party updates for the following issues.
<br/>

- Update to Spire 1.1.0

- github.com/gogo/protobuf CVE-2021-3121 HIGH (28109)

- libcrypto1.1 CVE-2021-3712 MEDIUM (28116)

- libssl1.1 CVE-2021-3712 MEDIUM (28151)

- workload-registrar k8s.io/client-go CVE-2020-8565 MEDIUM (28170)


<br/>

<span id="130-thirdparty"></a>

### **Resolved Issues**

This release includes fixes for the following issues.
<br/><br/>


- Non-injected pods and services mishandled as fallback services (14731)

- Rejected configurations return generic HTTP status codes (18101)

- `ImagePullError` for `nginx-mesh-api` may not be obvious (24182)

- Use of an invalid container image does not report an immediate error (24899)

- NGINX Service Mesh fails to deploy on some OpenShift versions (29905)

- NATS restarts can lead to sidecar failure (30051)

<br/>

<span id="130-issues"></a>

### **Known Issues**

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/>


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


<br/>**Sidecar version not reported after upgrade (25821)**:
  <br/>

After upgrading NGINX Service Mesh to the 1.3 release, the version of the sidecar in the `nginx-meshctl version` command will not be reported until you reroll the sidecar. This is caused by an issue with expired certificates in the sidecar in version 1.2.
  <br/>
  <br/>
  Workaround:
  <br/>

Reroll deployments to restart with the 1.3 version of the sidecar:`kubectl rollout restart <resource>/<name>`.

After rerolling, the 1.3 version of the sidecar will start up and report its version.


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


<br/>**NGINX Service Mesh cannot be deployed or removed after upgrade or removal is interrupted (28585)**:
  <br/>

If the upgrade or removal process for NGINX Service Mesh is interrupted, then the mesh can be left in an incomplete state where some resources still exist. This results in errors such as "Error: namespace 'nginx-mesh' not found." when attempting to run `nginx-meshctl remove`, and "NGINX Service Mesh already exists." when attempting to run `nginx-meshctl deploy`.
  <br/>
  <br/>
  Workaround:
  <br/>

Ensure all CustomResourceDefinitions (CRDs) are removed. The list of CRDs to be deleted are:

- `trafficsplits.split.smi-spec.io`
- `traffictargets.access.smi-spec.io`
- `httproutegroups.specs.smi-spec.io`
- `tcproutes.specs.smi-spec.io`
- `ratelimits.specs.smi.nginx.com`
- `circuitbreakers.specs.smi.nginx.com`

Once these are deleted, another attempt at redeploying NGINX Service Mesh may fail, but should clean up any more lingering resources. At this point the mesh should be fully removed.


<br/>**Deploying a TrafficSplit with an invalid weight value fails but does not return any errors (28602)**:
  <br/>

When deploying a TrafficSplit, it is possible to set the weight value as a negative integer. NGINX Service Mesh does not support negative-integer weights, so the TrafficSplit will appear to deploy successfully but will not take effect. No error or log message is returned to indicate that the TrafficSplit deployment has failed.
  <br/>
  <br/>
  Workaround:
  <br/>

Be sure to use positive integers when assigning weight values to TrafficSplits.


<br/>**Pods can't be created if nginx-mesh-api is unreachable (29560)**:
  <br/>

If the nginx-mesh-api Pod cannot be reached by the "sidecar-injector-webhook-cfg.internal.builtin.nsm.nginx" MutatingWebhookConfiguration, then all Pod creations will fail.
  <br/>
  <br/>
  Workaround:
  <br/>

If attempting to create Pods that are not going to be injected by NGINX Service Mesh, then the simplest solution is to remove NGINX Service Mesh.

Otherwise, if the nginx-mesh-api Pod is crashing, then verify that your configuration is valid before deploying NGINX Service Mesh. Reinstalling the mesh may also fix connectivity issues.


<br/>**Spire Server crashes after reaching ~1500 certificate rotations (30150)**:
  <br/>

After reaching approximately 1500 certificate rorations, the Spire Server crashes. This condition can be reached by either setting your certificate authority TTL to a low number -- for example, `--mtls-ca-ttl 1m --mtls-svid-ttl 1m` -- or leaving the mesh running for extended periods of time.
  <br/>
  <br/>
  Workaround:
  <br/>

Use the default TTL, which would produce the conditions that cause the crash after about 100 years of continuous operation. If you must use a lower TTL that will result in a significant number of certificate rotations, redeploy NGINX Service Mesh to refresh its state *before* the crash conditions can be reached.


<br/>

<span id="130-supported"></a>


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

- 1.12, 2.0

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
