---
title: Release Notes 0.6.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -600
docs: DOCS-706
type:
- reference
---

## NGINX Service Mesh Version 0.6.0

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 0.6.0, in the following categories:

- [NGINX Service Mesh Version 0.6.0](#nginx-service-mesh-version-060)
  - [Updates](#updates)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions](#supported-versions)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-0.6.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< ref "oss-dependencies/index.md" >}})

<span id="060-updates"></a>

### Updates

NGINX Service Mesh 0.6.0 includes the following updates:


- None
<span id="060-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues.



- *Maximum number of pods and services (10492)*



- *Mixed resource types metrics limitation (11168)*



- *Terminating `nginx-meshctl` prematurely during `deploy` can prevent proper cleanup (16916)*



<span id="060-issues"></a>

### Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/><br/>


**NGINX Service Mesh does not support apps/v1beta1 (10258)**:
  <br/>

  When injecting configurations -- `nginx-meshctl inject` -- using `apiVersion: apps/v1beta1`, the sidecar injection fails silently, and no new configuration is written.

  <br/>
  Workaround:
  <br/><br/>

  The `apps/v1beta1` API version is not supported. Retry the injection using the proper version: `apps/v1`.
  <br/><br/>


**Command line tool may timeout connecting to control plane (10685)**:
  <br/>

  The `nginx-meshctl` tool requires the NGINX Service Mesh control plane to be available and ready for operations to succeed. During startup or network outages, connections may time out and fail.

  <br/>
  Workaround:
  <br/><br/>

  Wait until all services report that they're ready and you can connect to the cluster, then retry the command.
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


**Kubernetes Liveness and Readiness HTTP Requests fail when mtls-mode is strict (17038)**:
  <br/>

  Kubernetes Liveness and Readiness HTTP Requests fail when `mtls-mode` is `strict`.

  <br/>
  Workaround:
  <br/><br/>

  1. Use commands instead of HTTP requests when defining liveness and readiness probes.
  1. Deploy NGINX Service Mesh with a permissive mtls mode. A permissive mode allows the liveness and readiness HTTP requests to be proxied to the application over plaintext.
  1. Create dedicated ports for the liveness and readiness probes in your application and add these ports to the `ignore-incoming-ports` during injection. Dedicated ports allow the HTTP requests to hit the application directly without being proxied.
  <br/><br/>


**Warning messages emitted when traffic access policies applied (17117)**:
  <br/>

  After successfully configuring traffic access polices (TrafficTarget, HTTPRouteGroup, TCPRoute), warning messages may be emitted to the `nginx-mesh-sidecar` logs.

  For example:

  ```console
  2020/09/24 01:03:14 could not parse syslog message: nginx could not connect to upstream
  ```

  This warning message is harmless and can safely be ignored. The message does not indicate an operational problem.
  <br/><br/>


**HTTPRouteGroups are not validated for proper input (17153)**:
  <br/>

  HTTPRouteGroups are not validated for proper input.

  1. You can have multiple `matches` with the same name, leading to undefined behavior.
  1. You can specify multiple `pathRegex` statements, also leading to undefined behavior.

  <br/>
  Workaround:
  <br/><br/>

  When creating `HTTPRouteGroups`, ensure there are no duplicate `matches` with the same name or duplicate `pathRegex` statements.
  <br/><br/>


**Traffic sent to backend service if root service and destination backend services don't match (17156)**:
  <br/>

  When configuring Traffic Splitting, the port on the root service and the port on every destination backend service must match. Backend services with a mismatching port should not be sent traffic. With this release, the mismatch case is not caught, and traffic is sent to that backend service.

  <br/>
  Workaround:
  <br/><br/>

  Ensure ports on the root service and destination backend service match.



**NGINX Service Mesh remove command may fail (17160)**:
  <br/>

  In some cases, the NGINX Service Mesh `remove` command may fail for unexpected reasons due to environmental, network, or timeout errors. If the `remove` command fails continually, manual intervention may be necessary.

  <br/>
  Workaround:
  <br/><br/>

  When troubleshooting, first verify that the command is run correctly with the correct arguments and that the target namespace exists.

  If you are running the command correctly and the target namespace exists and is not empty -- that is to say, the NGINX Service Mesh Deployments, Pods, Services, and so on, have been deployed -- you may need to remove the NGINX Service Mesh namespace and start over:

  To remove the NGINX Service mesh namespace and start over:

  1. Run the following command to delete the nginx-mesh namespace:

      ```bash
      kubectl delete namespace nginx-mesh
      ```

      > **Note**: This command should appear to stall. You can run `kubectl get namespaces` in a separate terminal to view the status, which should display as "Terminating."

  1. In a separate terminal, list and set a variable for all `spiffeid` resources:

      ```bash
      SPIFFEIDS=$(kubectl -n <namespace> get spiffeids | grep -v NAME | awk '{print $1}')
      ```

  1. Remove `finalizers` from each `spiffeid` resource:

      ```bash
      kubectl patch spiffeid $SPIFFEIDS --type='merge' -p '{"metadata":{"finalizers":null}}' -n <namespace>
      ```

      After step 3 completes, the command from step 1 should also complete, and the namespace should be removed.

  1. Run `nginx-meshctl deploy` and allow the operation to finish.
  <br/><br/>


**Improper destination and source namespace defaults for TrafficTarget (17234)**:
  <br/>

  If the TrafficTarget `.spec` does not explicitly set namespaces, access control may be applied to unexpected resources. The TrafficTarget `.spec.destination.namespace` and `.spec.sources[*].namespace` will default to the `default` namespace regardless of the namespace of the TrafficTarget resource.

  <br/>
  Workaround:
  <br/><br/>

  When defining TrafficTarget resources, always explicitly set the destination and source namespaces.

  For example:

  ```yaml
  kind: TrafficTarget
  metadata:
    name: example-traffictarget
    namespace: example-namespace
  spec:
    destination:
      kind: ServiceAccount
      name: example-destination-sa
      namespace: example-namespace
    sources:
    - kind: ServiceAccount
      name: example-source-sa
      namespace: example-namespace
  ```

  <br/><br/>


**Removing Mesh could delete clusterrole/binding for custom Prometheus (17302)**:
  <br/>

  When removing Mesh, if a custom Prometheus deployment has a clusterrole/binding named "prometheus", the clusterrole/binding is deleted.

  <br/>
  Workaround:
  <br/><br/>

  Avoid using "prometheus" as a name for the clusterrole/binding for custom Prometheus deployments.
  <br/><br/>


**TrafficSplits cannot route traffic based on the value of the  host header (17304)**:
  <br/>

  A TrafficSplit can list an HTTPRouteGroup in `spec.Matches`. If this HTTPRouteGroup contains a host header in the header filters, the TrafficSplit will not work. The root service of the TrafficSplit will handle the traffic.
  <br/><br/>


**Namespaces stuck deleting after removing NGINX Service Mesh (17313)**:
  <br/>

  After attempting to removing the NGINX Service Mesh, namespaces may get stuck deleting. Resource `finalizers` can deadlock a namespace when the owning controller is unavailable. Spire, and in turn NGINX Service Mesh, use `finalizers` in the `spiffe.spire.io` custom resource definitions. If your namespace cannot be deleted or is stuck in the "Terminating" state for a long time, you may need to remove the problematic `finalizers`.

  <br/>
  Workaround:
  <br/><br/>

  To clear the deadlock by removing `finalizers`, run the following command:

  ```bash
  SPIFFEIDS=$(kubectl -n <namespace> get spiffeids | grep -v NAME | awk '{print $1}')
  ```

  Remove `finalizers` from each `spiffeid` resource:

  ```bash
  kubectl patch spiffeid $SPIFFEIDS --type='merge' -p '{"metadata":{"finalizers":null}}' -n <namespace>
  ```

  <br/><br/>


**nginx-meshctl erroneously shows out of namespace resources (17381)**:
  <br/>

  When running `nginx-mestctl top namespace/[namespace]`, resources from outside the requested namespace may appear. This may happen whether or not cross-namespace traffic is occurring.

  <br/>
  Workaround:
  <br/><br/>

  There is no direct workaround for specific namespace filtering; however, running `nginx-meshctl` and filtering on other supported resources--such as Deployments, Pods, StatefulSets, and DaemonSets--will show proper traffic edges. Cross-referencing between Namespace output and another resource type will demonstrate the correct activity.



**Warning messages may print while deploying the NGINX Service Mesh on EKS (17390)**:
  <br/>

  The warning message "Unable to cancel request for \*exec.roundTripper" may print when deploying NGINX Service Mesh on EKS. This warning message does not prevent the mesh from deploying successfully.
  <br/><br/>


<span id="060-supported"></a>

### Supported Versions

SMI Specification:

- Traffic Access: v1alpha2
- Traffic Metrics: v1alpha1 (in progress, supported resources: StatefulSets, Namespaces, Deployments, Pods, DaemonSets)
- Traffic Specs: v1alpha3
- Traffic Split: v1alpha3

NGINX Service Mesh SMI Extensions:

- Traffic Specs: v1alpha1
