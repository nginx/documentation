---
title: Release Notes 1.5.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -1500
docs: DOCS-1487
type:
- reference
---

## NGINX Service Mesh Version 1.5.0

26 July 2022

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 1.5.0, in the following categories:

- [NGINX Service Mesh Version 1.5.0](#nginx-service-mesh-version-150)
  - [Updates](#updates)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions]({{< relref "mesh/about/mesh-tech-specs.md" >}})
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-1.5.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< relref "oss-dependencies/index.md" >}})

<span id="150-updates"></a>

### **Updates**

NGINX Service Mesh 1.5.0 includes the following updates:

- For a reduced footprint, default sidecar memory usage has been optimized.
- To reduce the size and stay true to having a small and easy to manage Service Mesh, the observability stack has been removed from the default installation.  See the [Observability Tutorial]( {{< ref "/mesh/tutorials/observability.md" >}} ) for an example on deploying your own.
- For improved scale support and optimization, sidecar proxy memory usage is dynamically managed.
- For improved performance, the configuration changes that require a reload of NGINX has been reduced in the sidecar proxies.
- client-max-body-size support has been added to support tuning for large request body sizes.
- For latest features and patches, SPIRE has been updated to 1.3.
- To complete deprecation, mtlsMode API field has been removed (please use mtls.mode instead).
- Maintaining consistency with SMI, the HTTPRouteGroup headers field changed from a list to an object.

#### **Deprecation**

- OpenTracing has been deprecated in favor of OpenTelemetry

<br/>
<span id="150-resolved"></a>

### **Resolved Issues**

This release includes fixes for the following issues.
<br/><br/>


- Deploying a TrafficSplit with an invalid weight value fails but does not return any errors (426)

- Tracer address reported by nginx-meshctl config when no tracer is deployed (440)

- DNS fails over TCP when mTLS mode is set to "strict" (695)

- Request bodies large than 1MB are rejected (1971)

<br/>
<span id="150-issues"></a>

### **Known Issues**

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/>


<br/>**TrafficSplits do not work for headless Services (2324)**:
  <br/>

TrafficSplits are not applied properly for headless Services. This results in traffic distribution that is not weighted.

  <br/>
  Workaround:
  <br/>

Services need a cluster IP address for Traffic Splitting to work properly.


<br/>**Remove can't always clean up. (1566)**:
  <br/>

While deploying NGINX Service Mesh, if the `label-namespace` job fails, lingering resources can be left around. This prevents the mesh from being fully removed or re-deployed.

  <br/>
  Workaround:
  <br/>

Remove lingering resources (Clusterroles, clusterrolebindings, etc.) manually. These resources have the `app.kubernetes.io/part-of: nginx-service-mesh` label.


<br/>**Deploy hangs forever if helm job can't run. (1565)**:
  <br/>

Deploying NGINX Service Mesh in an air-gapped environment (using `--disable-public-images` flag) with an invalid registry can result in the deploy command hanging for a long time without any error messages.

  <br/>
  Workaround:
  <br/>

Ensure your private registry is valid and accessible if you are deploying in an air-gapped environment.


<br/>**Inject command errors are ambiguous (789)**:
  <br/>

Inject command may return ambiguous error messages:

```bash
./build/nginx-meshctl inject < example.yaml
Cannot inject NGINX Service Mesh sidecar.
Error: error formatting response string: invalid syntax
```

This error can be returned due to invalid encoding, if the control plane is down, if NGINX Service Mesh is not installed, or if it is installed in an unexpected namespace.

  <br/>
  Workaround:
  <br/>

When encountering an error from Inject do the following checks:

 1. Verify you have valid YAML.
 2. Check the status of your install: nginx-meshctl status
 3. Check the status of you Pods: kubectl -n nginx-mesh get pods

If steps 2 or 3 show failures, or Pods that are not in the Running state, NGINX Service Mesh will need further troubleshooting. Pods may be restarted through `kubectl` by using `rollout restart` on the Deployments, or by deleting the Pod resources. If the issue persists contact your support agent.


<br/>**Injecting through API returns unformatted text (744)**:
  <br/>

Injecting (sending a POST request) a Kubernetes resource through NSM API returns unformatted text that cannot be applied directly with `kubectl apply`.

  <br/>
  Workaround:
  <br/>

Use either one of the following two options:

- Inject your Kubernetes resources with the NSM sidecar through the CLI with the following command:

    ```bash
    ./nginx-meshctl inject -f <your-resource-definition-file>
    ```

- Enable [automatic injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) in your cluster or namespace.


<br/>**Lingering invalid RateLimits can cause restart inconsistencies with the NGINX Service Mesh control plane. (658)**:
  <br/>

The NGINX Service Mesh control plane has a validating webhook that will reject the majority of RateLimits that conflict with an existing RateLimit. However, there are some cases where the validating webhook is unable to determine a conflict. In these cases, the NGINX Service Mesh control plane process will catch the conflict and prevent configuration of the offending RateLimit, but the RateLimit will still be stored in Kubernetes. These RateLimit resources are invalid and can be found by looking for a `Warning` event on the RateLimit object. If invalid RateLimits exist and the NGINX Service Mesh control plane restarts, the invalid RateLimits may be configured over the previous valid RateLimits.

  <br/>
  Workaround:
  <br/>

When you create a RateLimit resource in Kubernetes, run `kubectl describe ratelimit <ratelimit-name>` and check for any `Warning` events. If a `Warning` event exists, either fix the conflict described in the `Warning` event message, or delete the RateLimit by running: `kubectl delete ratelimit <ratelimit-name>`.


<br/>**Pods fail to deploy if invalid Jaeger tracing address is set (540)**:
  <br/>

If `--tracing-address` is set to an invalid Jaeger address when deploying NGINX Service Mesh, all pods will fail to start.

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
  Workaround:
  <br/>

No workaround exists outside of reconfiguring the Service and application. The Service must use unique `.spec.ports[].targetPort` values (open up multiple ports on the application workload) or route all traffic to the application workload through the same Service port.


<br/>**NGINX Service Mesh DNS Suffix support (519)**:
  <br/>

NGINX Service Mesh only supports the `cluster.local` DNS suffix. Services such as Grafana and Prometheus will not work in clusters with a custom DNS suffix.

  <br/>
  Workaround:
  <br/>

Ensure your cluster is setup with the default `cluster.local` DNS suffix.


<br/>**Pods can't be created if nginx-mesh-api is unreachable (384)**:
  <br/>

If the nginx-mesh-api Pod cannot be reached by the "sidecar-injector-webhook-cfg.internal.builtin.nsm.nginx" MutatingWebhookConfiguration, then all Pod creations will fail.

  <br/>
  Workaround:
  <br/>

If attempting to create Pods that are not going to be injected by NGINX Service Mesh, then the simplest solution is to remove NGINX Service Mesh.

Otherwise, if the nginx-mesh-api Pod is crashing, then the user should verify that their configuration when deploying NGINX Service Mesh is valid. Reinstalling the mesh may also fix connectivity issues.


<br/>**Spire Server crashes after reaching ~1500 certificate rotations (375)**:
  <br/>

After reaching approximately 1500 certificate rorations, the Spire Server crashes. This condition can be reached by either setting your certificate authority TTL to a low number, for example, `--mtls-ca-ttl 1m --mtls-svid-ttl 1m` – or leaving the mesh running for extended periods of time.

  <br/>
  Workaround:
  <br/>

Use the default TTL, which would produce the conditions that cause the crash after about 100 years of continuous operation. If you must use a lower TTL that will result in a significant number of certificate rotations, redeploy NGINX Service Mesh to refresh its state _before_ the crash conditions can be reached.
