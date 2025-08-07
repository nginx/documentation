---
title: Release Notes 0.7.0
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -700
nd-docs: DOCS-707
type:
- reference
---

## NGINX Service Mesh Version 0.7.0

<!-- vale off -->

These release notes provide general information and describe known issues for NGINX Service Mesh version 0.7.0, in the following categories:

- [NGINX Service Mesh Version 0.7.0](#nginx-service-mesh-version-070)
  - [Updates](#updates)
  - [Resolved Issues](#resolved-issues)
  - [Known Issues](#known-issues)
  - [Supported Versions](#supported-versions)
  - {{< link "nginx-service-mesh/licenses/license-servicemesh-0.7.0.html" "Open Source Licenses" >}}
  - [Open Source Licenses Addendum]({{< ref "oss-dependencies/index.md" >}})

<span id="070-updates"></a>

### Updates

NGINX Service Mesh 0.7.0 includes the following updates:

- Bug fixes and improvements.



- Changes the behavior of `nginx-meshctl deploy` command. The `--registry-server` argument will now be used for image domain and path-components in conjunction with the `--image-tag` command. If not provided, PodSpecs are configured for local images.



- CircuitBreaker and RateLimit CRDs are moved to the `smi.specs.nginx.com` API group.


<span id="070-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues. You can search by the issue ID to locate the details for an issue.



- *NGINX Service Mesh may drop metrics (12282)*



- *Kubernetes Liveness and Readiness HTTP Requests fail when mtls-mode is strict (17038)*



- *HTTPRouteGroups are not validated for proper input (17153)*



- *Traffic sent to backend service if root service and destination backend services don't match (17156)*



- *Improper destination and source namespace defaults for TrafficTarget (17234)*



- *Removing Mesh could delete clusterrole/binding for custom Prometheus (17302)*



- *TrafficSplits cannot route traffic based on the value of the  host header (17304)*



- *nginx-meshctl erroneously shows out of namespace resources (17381)*



<span id="070-issues"></a>

### Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Service Mesh release notes.
<br/><br/>


**NGINX Service Mesh remove command may fail (17160)**:
  <br/>

  In some cases, the NGINX Service Mesh `remove` command may fail for unexpected reasons due to environmental, network, or timeout errors. If the `remove` command fails continually, manual intervention may be necessary.

{{< call-out "note" >}}
If deploying NGINX Service Mesh failed or you pressed ctrl-C during deployment, make sure to first remove the service mesh using the `remove` command before attempting the below steps
{{< /call-out >}}

  <br/>
  Workaround:
  <br/><br/>

  When troubleshooting, first verify that the command is run correctly with the correct arguments and that the target namespace exists.

  If you are running the command correctly and the target namespace exists and is not empty -- that is to say, the NGINX Service Mesh Deployments, Pods, Services, and so on, have been deployed -- you may need to remove the NGINX Service Mesh namespace and start over:

  To remove the NGINX Service Mesh namespace and start over:

  1. Run the following command to delete the NGINX Service Mesh namespace:

      ```bash
      kubectl delete namespace <namespace>
      ```

      > **Note**: This command should appear to stall. You can run `kubectl get namespaces` in a separate terminal to view the status, which should display as "Terminating."

  1. In a separate terminal, list and patch all Spiffeid resources (use following script):

      ```bash
      for ns in $(kubectl get ns | awk '{print $1}' | tail -n +2)
      do
        if [ $(kubectl get spiffeids -n $ns 2>/dev/null | wc -l) -ne 0 ]
        then
          kubectl patch spiffeid $(kubectl get spiffeids -n $ns | awk '{print $1}' | tail -n +2) --type='merge' -p '{"metadata":{"finalizers":null}}' -n $ns
        fi
      done
      ```

      After step 2 completes, the command from step 1 should also complete, and the namespace should be removed.

  1. Run `nginx-meshctl deploy` and allow the operation to finish.
  <br/><br/>


**Warning messages may print while deploying the NGINX Service Mesh on EKS (17390)**:
  <br/>

  The warning message "Unable to cancel request for \*exec.roundTripper" may print when deploying NGINX Service Mesh on EKS. This warning message does not prevent the mesh from deploying successfully.
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


<span id="070-supported"></a>

### Supported Versions

SMI Specification:

- Traffic Access: v1alpha2
- Traffic Metrics: v1alpha1 (in progress, supported resources: StatefulSets, Namespaces, Deployments, Pods, DaemonSets)
- Traffic Specs: v1alpha3
- Traffic Split: v1alpha3

NGINX Service Mesh SMI Extensions:

- Traffic Specs: v1alpha1
