---
title: Release Notes 1.6.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -1600
docs: DOCS-1486
type:
- reference
---

## NGINX Service Mesh Version 1.6.0

01 November 2022

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 1.6.0, in the following categories:

- [NGINX Service Mesh Version 1.6.0](#nginx-service-mesh-version-160)
  - [Updates](#updates)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions]({{< relref "mesh/about/mesh-tech-specs.md" >}})
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-1.6.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< relref "oss-dependencies/index.md" >}})

<br/>
<br/>
<span id="160-updates"></a>

### **Updates**

NGINX Service Mesh 1.6.0 includes the following updates:

- For more control over automatic sidecar injection, namespaces can opt in or out using the `injector.nsm.nginx.com/auto-inject` label.
- To avoid crashing due to frequent rotations, SPIRE's `caTTL` field has a minimum value of `24h`.

#### **Deprecation**

- `disabledNamespaces` configuration field has been deprecated and will be removed in a future release.
- Other `autoInjection` configuration fields have been deprecated in favor of using top-level fields.
- `injector.nsm.nginx.com/auto-inject` Pod annotation has been deprecated in favor of using a label.

<span id="160-resolved"></a>

### **Resolved Issues**

This release includes fixes for the following issues.
<br/><br/>


- Spire Server crashes after reaching ~1500 certificate rotations (375)

- Injecting a resource through API returns unformatted text (744)

- Inject command errors are ambiguous (789)

- Deploy command for NGINX Service Mesh leads to unresponsive stage if helm job cannot execute. (1565)

- Removing NGINX Service Mesh can't always clean up lingering resources. (1566)

<br/>

<span id="160-issues"></a>

### **Known Issues**

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/>


<br/>**Lingering invalid RateLimits can cause restart inconsistencies with the NGINX Service Mesh control plane. (658)**:
  <br/>

The NGINX Service Mesh control plane has a validating webhook that will reject the majority of RateLimits that conflict with an existing RateLimit. However, there are some cases where the validating webhook is unable to determine a conflict. In these cases, the NGINX Service Mesh control plane process will catch the conflict and prevent configuration of the offending RateLimit, but the RateLimit will still be stored in Kubernetes. These RateLimit resources are invalid and can be found by looking for a `Warning` event on the RateLimit object. If invalid RateLimits exist and the NGINX Service Mesh control plane restarts, the invalid RateLimits may be configured over the previous valid RateLimits.
  <br/>
  <br/>
  Workaround:
  <br/>

When you create a RateLimit resource in Kubernetes, run `kubectl describe ratelimit <ratelimit-name>` and check for any `Warning` events. If a `Warning` event exists, either fix the conflict described in the `Warning` event message, or delete the RateLimit by running: `kubectl delete ratelimit <ratelimit-name>`.


<br/>**Pods fail to deploy if invalid Jaeger tracing address is set (540)**:
  <br/>

If `--tracing-address` is set to an invalid Jaeger address when deploying NGINX Service Mesh, all pods will fail to start.
  <br/>
  <br/>
  Workaround:
  <br/>

If you use your own Zipkin or Jaeger instance with NGINX Service Mesh, make sure to correctly set `--tracing-address` when deploying the mesh.


<br/>**Duplicate targetPorts in a Service are disregarded (532)**:
  <br/>

NGINX Service Mesh supports a variety of Service `.spec.ports\[]` configurations and honors each port list item with one exception.

If the Service lists multiple port configurations that duplicate `.spec.ports\[].targetPort`, the duplicates are disregarded. Only one port configuration is honored for traffic forwarding, authentication, and encryption.

Example invalid configuration:


```yaml
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


<br/>**NGINX Service Mesh DNS Suffix support (519)**:
  <br/>

NGINX Service Mesh only supports the `cluster.local` DNS suffix. Services such as Grafana and Prometheus will not work in clusters with a custom DNS suffix.
  <br/>
  <br/>
  Workaround:
  <br/>

Ensure your cluster is setup with the default `cluster.local` DNS suffix.


<br/>**Pods can't be created if nginx-mesh-api is unreachable (384)**:
  <br/>

If the nginx-mesh-api Pod cannot be reached by the `sidecar-injector-webhook-cfg.internal.builtin.nsm.nginx` MutatingWebhookConfiguration, then all Pod creations will fail.
  <br/>
  <br/>
  Workaround:
  <br/>

If attempting to create Pods that are not going to be injected by NGINX Service Mesh, then the simplest solution is to remove NGINX Service Mesh.

Otherwise, if the nginx-mesh-api Pod is crashing, then the user should verify that their configuration when deploying NGINX Service Mesh is valid. Reinstalling the mesh may also fix connectivity issues.

