---
title: F5 WAF for NGINX overview
weight: 100
toc: true
f5-content-type: reference
f5-product: FABRIC
f5-description: Architecture, setup, and concepts for F5 WAF for NGINX integration in NGINX Gateway Fabric.
---

F5 NGINX Gateway Fabric integrates with F5 WAF for NGINX to provide enterprise-grade web application firewall protection. WAF policies are compiled externally and deployed to the data plane via the `WAFPolicy` custom resource.

{{< call-out "note" >}} F5 WAF for NGINX requires NGINX Plus and a separate F5 WAF for NGINX subscription. Contact your F5 sales representative for licensing details. {{< /call-out >}}

---

## Architecture

F5 WAF for NGINX uses a multi-container architecture. When WAF is enabled, each NGINX Pod is extended with two sidecar containers:

- **waf-enforcer**: Enforces WAF policies on incoming traffic.
- **waf-config-mgr**: Manages WAF configuration and distributes policy bundles to the enforcer.

Shared ephemeral volumes connect these containers to the main NGINX container.

```mermaid
graph LR
    CP[NGINX Gateway Fabric] -->|gRPC: config + policy bundle| Agent
    subgraph NginxPod["NGINX Pod"]
        Agent[NGINX Agent] -->|writes bundle| Vol[(Shared Volume)]
        NGINX[NGINX + WAF Module] --- Vol
        Enforcer[WAF Enforcer] --- Vol
        ConfigMgr[WAF Config Mgr] --- Vol
    end
    Client[Client] ==> NGINX ==> Backend[Backend Service]
```

---

## Enable WAF on the NginxProxy

WAF is enabled by setting `waf.enable: true` on an `NginxProxy` resource. This instructs NGINX Gateway Fabric to deploy the WAF sidecar containers alongside the NGINX Pod.

You can enable WAF at two levels:

- **All Gateways** — Set WAF on the GatewayClass-level `NginxProxy` so that every Gateway managed by this NGINX Gateway Fabric instance gets WAF sidecars by default. A per-Gateway `NginxProxy` can override this (for example, to disable WAF on a specific Gateway).
- **Per Gateway** — Create an `NginxProxy` and reference it from a Gateway's `spec.infrastructure.parametersRef`. Only that Gateway gets WAF sidecars.

For details on how GatewayClass and Gateway-level NginxProxy settings are merged, see [Data plane configuration]({{< ref "/ngf/how-to/data-plane-configuration.md" >}}).

### Enable WAF for all Gateways

To enable WAF at install time use the **NGINX Plus with WAF** tab in the [Helm install guide]({{< ref "/ngf/install/helm.md" >}}). This sets the WAF-enabled NGINX Plus image (`nginx-plus-f5waf`) and enables WAF on the GatewayClass-level `NginxProxy`, so every Gateway gets WAF sidecars by default.

To disable WAF for a specific Gateway, create a per-Gateway `NginxProxy` with `waf.enable: false` and reference it from that Gateway.

{{< call-out "note" >}} For additional WAF-related NginxProxy settings — including `disableCookieSeed`, `bundleFailOpen`, and custom WAF container images — see [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}}). {{< /call-out >}}

### Enable WAF per Gateway

If you installed with the standard NGINX Plus image and want WAF on a specific Gateway only, create a per-Gateway `NginxProxy`. You must also set the NGINX image to `nginx-plus-f5waf`, since the standard `nginx-plus` image inherited from the GatewayClass does not include the WAF module:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: waf-enabled-proxy
spec:
  waf:
    enable: true
  kubernetes:
    deployment:
      container:
        image:
          repository: private-registry.nginx.com/nginx-gateway-fabric/nginx-plus-f5waf
```

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  infrastructure:
    parametersRef:
      name: waf-enabled-proxy
      group: gateway.nginx.org
      kind: NginxProxy
  listeners:
  - name: http
    port: 80
    protocol: HTTP
```

For the full list of available images, see [Supported container images]({{< ref "/ngf/overview/technical-specifications.md#supported-container-images" >}}).

---

## Policy lifecycle

### Bundles

A WAF bundle is a compiled policy package produced by the [F5 WAF for NGINX compiler]({{< ref "/waf/configure/compiler.md" >}}). It contains the security policy, optional logging profile, [attack signatures]({{< ref "/waf/policies/attack-signatures.md" >}}), [threat campaign]({{< ref "/waf/policies/threat-campaigns.md" >}}) data, [bot signatures]({{< ref "/waf/policies/bot-signatures.md" >}}), and related metadata in a format that the WAF engine can load and enforce at runtime. Pre-compiling policies into bundles enables faster, more reliable WAF startup — policies are resolved and validated at build time rather than on the running data plane.

### Compilation

WAF policies must be compiled before they can be applied. Compilation takes a JSON policy definition (and optionally [global settings]({{< ref "/waf/configure/compiler.md" >}}) such as a cookie seed and [user-defined signatures]({{< ref "/waf/policies/user-signatures.md" >}})) and produces a `.tgz` bundle. NGINX Gateway Fabric does not compile policies — its role begins at fetching a compiled bundle and deploying it to the data plane.

### Source types

The following policy source types are supported, selected via the `spec.type` field on the `WAFPolicy` resource:

| Type   | Description                                                                                       |
|--------|---------------------------------------------------------------------------------------------------|
| `NIM`  | NGINX Instance Manager — fetched by policy name or UID via NGINX Instance Manager API             |
| `N1C`  | NGINX One Console — fetched by policy name or object ID via NGINX One Console API                 |
| `HTTP` | Direct HTTP/HTTPS URL to a compiled bundle file                                                   |
| `PLM`  | Policy Lifecycle Management — `APPolicy`/`APLogConf` CRDs, fetched from in-cluster storage        |

The `NIM`, `N1C`, and `HTTP` source types reference an externally compiled bundle through `policySource` (and `logSource` for log profiles), and detect updates by polling. The `PLM` source type is Kubernetes-native and event-driven: it references `APPolicy` and `APLogConf` custom resources through `policyRef` (and `logRef`), and requires no polling. See [PLM (Policy Lifecycle Management)](#plm-policy-lifecycle-management) below.

For details on configuring each source type, see [Configure policy sources]({{< ref "/ngf/waf-integration/policy-sources.md" >}}).

### PLM (Policy Lifecycle Management)

Policy Lifecycle Management (PLM) is a Kubernetes-native policy source. Instead of pointing NGINX Gateway Fabric at an externally compiled bundle, you define your WAF security posture as `APPolicy` and `APLogConf` custom resources in the cluster. The PLM controller watches these resources, compiles them automatically, and stores the resulting bundles in in-cluster S3-compatible storage. NGINX Gateway Fabric then fetches the bundles from that storage and deploys them to the data plane.

The following table summarizes how PLM differs from the HTTP, NGINX Instance Manager, and NGINX One Console source types:

| Aspect             | HTTP / NIM / N1C                                | PLM                                                     |
|--------------------|-------------------------------------------------|---------------------------------------------------------|
| Policy definition  | Authored externally (file/Git, NIM, or N1C)     | Authored in-cluster as `APPolicy`/`APLogConf` CRDs      |
| Compilation        | External (compiler CLI/CI-CD, NIM, or N1C)      | Automatic, by the PLM controller                        |
| Bundle storage     | HTTP server, NIM, or N1C                        | In-cluster S3-compatible storage                        |
| `WAFPolicy` fields | `policySource` / `logSource`                    | `policyRef.apPolicyRef` / `logRef.apLogConfRef`         |
| Update detection   | Polling (checksum or conditional GET)           | Event-driven Kubernetes watch (no polling)              |
| Authentication     | Per-`WAFPolicy` credentials Secret              | Cluster-wide PLM storage credentials, set at install    |
| Network access     | External egress to the policy source            | Fully in-cluster                                        |

At runtime, the flow is:

```text
Create APPolicy/APLogConf → PLM compiles and sets status.bundle.state: ready →
NGINX Gateway Fabric detects the ready status via watch → fetches the bundle from
in-cluster storage → deploys to the data plane
```

Subsequent changes to an `APPolicy` or `APLogConf` spec trigger recompilation and an automatic re-fetch — no polling and no change to the `WAFPolicy` resource are required.

When a `WAFPolicy` references an `APPolicy` or `APLogConf` in a different namespace, a [ReferenceGrant](https://gateway-api.sigs.k8s.io/api-types/referencegrant/) is required in the target namespace to permit the reference.

{{< call-out "note" >}} PLM requires the PLM system to be installed in the cluster, and requires PLM storage access to be configured on NGINX Gateway Fabric at install time. For authoring `APPolicy`/`APLogConf` resources and installing PLM, see the [F5 WAF PLM documentation]({{< ref "/waf/" >}}). <!-- TODO: confirm PLM docs link --> For NGINX Gateway Fabric configuration, see [Configure PLM storage access]({{< ref "/ngf/waf-integration/configuration.md#configure-plm-storage-access" >}}). {{< /call-out >}}

---

## Policy attachment

`WAFPolicy` uses **inherited policy attachment**, following the [Gateway API policy attachment model](https://gateway-api.sigs.k8s.io/reference/policy-attachment/):

- A **Gateway-level** `WAFPolicy` protects all HTTPRoutes and GRPCRoutes attached to that Gateway automatically. New routes inherit protection without any additional configuration.
- A **Route-level** `WAFPolicy` can be applied to a specific HTTPRoute or GRPCRoute to override the Gateway-level policy for that route.
- More specific (route-level) policies take precedence over less specific (gateway-level) policies. The route-level policy completely replaces the gateway-level policy for that route — there is no merging.
- Only one `WAFPolicy` may target a given resource at a given level. If two policies target the same Gateway or Route, the second is rejected with `Accepted=False` and reason `Conflicted`.

```text
Gateway-level WAFPolicy → HTTPRoute (inherited automatically)

Route-level WAFPolicy   → Overrides Gateway-level for that route only
```

{{< call-out "tip" >}} GRPCRoutes are protected in the same way as HTTPRoutes. To target a GRPCRoute, set `kind: GRPCRoute` in the `targetRefs` field. Built-in gRPC log profiles (`log_grpc_all`, `log_grpc_blocked`, `log_grpc_illegal`) are available for gRPC-specific security logging. {{< /call-out >}}

---

## See also

- [Get started with F5 WAF for NGINX]({{< ref "/ngf/waf-integration/get-started.md" >}})
- [Configure policy sources (NGINX Instance Manager, NGINX One Console, and HTTP)]({{< ref "/ngf/waf-integration/policy-sources.md" >}})
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}})
- [WAFPolicy and NginxProxy API reference]({{< ref "/ngf/reference/api.md" >}})
- [F5 WAF for NGINX documentation]({{< ref "/waf/" >}})
