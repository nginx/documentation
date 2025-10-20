---
title: Install NGINX Gateway Fabric on OpenShift using OperatorHub
description: Deploy NGINX Gateway Fabric on Red Hat OpenShift via OperatorHub and configure it using the NginxGatewayFabric custom resource.
weight: 20
toc: true
---

## Overview

This guide explains how to install F5 NGINX Gateway Fabric on Red Hat OpenShift using OperatorHub and configure it with the `NginxGatewayFabric` custom resource. 

On this page

- Prerequisites for OpenShift
- Installing the NGF Operator from OperatorHub
- Creating the NGF instance using the `NginxGatewayFabric` CR
- OpenShift-specific considerations (images, service exposure, SCC)
- Operator-specific configuration options available in the CR
- Validation and troubleshooting

## Prerequisites

- A running Red Hat OpenShift cluster with cluster-admin privileges.
- Access to OperatorHub in the OpenShift Web Console.
- `oc` CLI installed and logged in to your cluster.
- Ability to pull images from `ghcr.io` (or a mirrored registry if required by your environment).
- Optional:
  - NGINX One dataplane API key if you plan to integrate with NGINX One.
  - NGINX Plus entitlements if you plan to run NGF with NGINX Plus.
- Network exposure model decided:
  - LoadBalancer Services (recommended where available)
  - Or OpenShift Routes/NodePorts (if LoadBalancer is not available)

## Note on OpenShift support and images

NGF provides first-class OpenShift support with UBI-based images. Use the `-ubi` tags shown in the CR examples below. Security constraints, such as running as non-root, are handled by defaults compatible with OpenShift SCCs in most environments. If your cluster enforces custom SCCs or policies, see the "Pod scheduling and security" options under operator-specific configuration.

## Install the NGF Operator from OperatorHub

Install via the OpenShift Web Console:

1. Navigate to Operators → OperatorHub.
2. Search for "NGINX Gateway Fabric".
3. Select the NGF Operator (provider: NGINX, Inc) and click Install.
4. Choose an update channel (for example, stable 2.x), installation mode (All namespaces or a specific namespace), and approve automatic updates as desired.
5. Complete the installation. Wait until the Operator shows the "Installed" status.

If you prefer CLI-based installation (Subscription/OperatorGroup), consult OpenShift documentation for creating `OperatorGroup` and `Subscription` resources in your chosen namespace. The Web Console path above is recommended.

## Create a project and required secrets

Create a dedicated project (namespace) for NGF components, for example:

```bash
oc new-project nginx-gateway-fabric
```

## TLS secrets for internal communication

NGF can generate internal certificates for agent/server by default, or you can provide your own secrets.

Option A: Let NGF generate the certificates
- Use the default `certGenerator` settings from the sample CR (no additional steps needed).
- `certGenerator.overwrite: false` means NGF will not overwrite existing secrets if present.

Option B: Provide your own secrets (example)
```bash
# Agent TLS (used by internal agent)
oc create secret tls agent-tls \
  --cert=agent.crt \
  --key=agent.key \
  -n nginx-gateway-fabric

# Server TLS (used by internal server)
oc create secret tls server-tls \
  --cert=server.crt \
  --key=server.key \
  -n nginx-gateway-fabric
```

## Optional: Integrate with NGINX One

If you want NGF to connect to NGINX One, create a secret for the dataplane key (replace VALUE with your key):

```bash
oc create secret generic nginxone-dataplane-key \
  --from-literal=key=VALUE \
  -n nginx-gateway-fabric
```

You will reference this secret in the `spec.nginx.nginxOneConsole.dataplaneKeySecretName` field.

## Optional: NGINX Plus licensing

If you plan to use NGINX Plus, you will need to:
- Set `spec.nginx.nginxOneConsole.plus: true`
- Provide appropriate image repository/registry credentials in `imagePullSecret(s)`
- Optionally create a secret for license/entitlement artifacts (name by convention below):

```bash
# Example license secret name referenced by usage.secretName
oc create secret generic nplus-license \
  --from-file=nginx-repo.crt=/path/to/nginx-repo.crt \
  --from-file=nginx-repo.key=/path/to/nginx-repo.key \
  -n nginx-gateway-fabric
```

Consult your subscription details for the exact files/registry access used for NGINX Plus images in your environment.

## Create the NginxGatewayFabric CR

Minimal example for OpenShift:

```yaml
apiVersion: gateway.nginx.org/v1alpha1
kind: NginxGatewayFabric
metadata:
  name: ngf
  namespace: nginx-gateway-fabric
spec:
  # Cluster-wide defaults
  clusterDomain: cluster.local

  # Optionally provide cert secrets if you do not want NGF to generate them
  certGenerator:
    agentTLSSecretName: agent-tls
    serverTLSSecretName: server-tls
    overwrite: false
    ttlSecondsAfterFinished: 30

  # Data plane (NGINX)
  nginx:
    replicas: 2
    debug: false
    image:
      repository: ghcr.io/nginx/nginx-gateway-fabric/nginx
      tag: 2.2.0-ubi
      pullPolicy: IfNotPresent
    service:
      type: LoadBalancer
      externalTrafficPolicy: Local
    metrics:
      # metrics are configured under nginxGateway, but data plane health can be probed via readinessProbe
      # configure additional metrics/sidecars as needed
    readinessProbe: {}
    autoscaling:
      enable: false
    imagePullSecrets: []
    container:
      hostPorts: []
    # Optional NGINX One console integration
    nginxOneConsole:
      dataplaneKeySecretName: ""       # set to "nginxone-dataplane-key" if you created it
      endpointHost: agent.connect.nginx.com
      endpointPort: 443
      skipVerify: false
      plus: false

  # Controller
  nginxGateway:
    gatewayClassName: nginx
    gatewayControllerName: gateway.nginx.org/nginx-gateway-controller
    image:
      repository: ghcr.io/nginx/nginx-gateway-fabric
      tag: 2.2.0-ubi
      pullPolicy: IfNotPresent
    replicas: 1
    metrics:
      enable: true
      port: 9113
      secure: false
    readinessProbe:
      enable: true
      initialDelaySeconds: 3
      port: 8081
    leaderElection:
      enable: true
      lockName: ""
    productTelemetry:
      enable: true
    gwAPIExperimentalFeatures:
      enable: false
    snippetsFilters:
      enable: false
```

Apply the CR:

```bash
oc apply -f nginx-gateway-fabric.yaml
```

Wait for the Operator to reconcile. It will provision the NGF controller and data plane deployments, services, and related resources.

## OpenShift-specific exposure options

- LoadBalancer Service (preferred where available): Use `spec.nginx.service.type: LoadBalancer`. You can also configure:
  - `externalTrafficPolicy: Local` to preserve source IPs (useful for client IP-based policies).
  - `loadBalancerClass`, `loadBalancerIP`, and `loadBalancerSourceRanges` per your environment.

- Routes / NodePort (if LoadBalancer is not available):
  - Set `spec.nginx.service.type: NodePort` and create an OpenShift Route to the NGF front-end service (for HTTP/HTTPS traffic).
  - Example (edge termination route; replace service name and ports appropriately):
    ```bash
    oc create route edge ngf \
      --service=nginx-gateway-fabric-nginx \
      --port=http \
      -n nginx-gateway-fabric
    ```
  - For TLS passthrough, use `--passthrough` and target the appropriate service port.

## Operator-specific configuration options (NginxGatewayFabric spec)

Below is a summary of key fields exposed by the Operator via the `NginxGatewayFabric` CR. Defaults align with NGF Helm values.

- Global
  - `clusterDomain`: Kubernetes cluster domain (default `cluster.local`).
  - `gateways`: Optional list to seed Gateway resources managed by the Operator (empty by default).

- `certGenerator`
  - `agentTLSSecretName` / `serverTLSSecretName`: Secret names for internal agent/server TLS.
  - `overwrite`: If true, Operator may overwrite existing secrets during generation.
  - `annotations`: Add annotations to generated objects.
  - `nodeSelector`, `tolerations`, `topologySpreadConstraints`, `affinity`: Pod scheduling controls for cert jobs.
  - `ttlSecondsAfterFinished`: TTL for certificate generation jobs (default 30 seconds).

- `nginx` (data plane)
  - `image`: Repository/tag/pullPolicy. Use `ghcr.io/nginx/nginx-gateway-fabric/nginx` with `2.2.0-ubi` for OpenShift.
  - `replicas`: Desired number of data plane replicas.
  - `debug`: Enables verbose NGINX debugging.
  - `container.hostPorts`: Optional host port bindings (normally disabled on OpenShift).
  - `readinessProbe`, `lifecycle`, `resources`, `volumeMounts`: Pod behavior and resources.
  - `imagePullSecret` / `imagePullSecrets`: For private registries or NGINX Plus artifacts.
  - `kind`: Deployment (default) — data plane runs as a Deployment.
  - `service`:
    - `type`: `LoadBalancer` | `NodePort` | `ClusterIP`
    - `externalTrafficPolicy`: `Local` or `Cluster`
    - `loadBalancerClass`, `loadBalancerIP`, `loadBalancerSourceRanges`: Cloud/provider-specific LB tuning.
    - `nodePorts`: Fixed NodePorts if you need deterministic port numbers.
    - `patches`: Strategic merge patches to customize the Service shape beyond the exposed fields.
  - `autoscaling.enable`: If true, enable HPA for the data plane (configure metrics/thresholds according to your policy).
  - `pod`: Raw Pod-level overrides (labels, annotations).
  - `nginxOneConsole`:
    - `dataplaneKeySecretName`: Secret providing the NGINX One dataplane key.
    - `endpointHost` / `endpointPort`: NGINX One agent endpoint.
    - `skipVerify`: Disable TLS verification (not recommended).
    - `patches`: Additional customization patches.
    - `plus`: Set `true` when using NGINX Plus data plane.
  - `usage`:
    - `secretName`: License/usage reporting secret name (e.g., `nplus-license`).
    - `endpoint`, `resolver`, `skipVerify`, `clientSSLSecretName`, `caSecretName`, `enforceInitialReport`: Advanced usage/telemetry controls.

- `nginxGateway` (controller)
  - `gatewayClassName`: Name of the GatewayClass to install (default `nginx`).
  - `gatewayControllerName`: Controller name (`gateway.nginx.org/nginx-gateway-controller`).
  - `image`: Repository/tag/pullPolicy (`ghcr.io/nginx/nginx-gateway-fabric:2.2.0-ubi` recommended for OpenShift).
  - `replicas`: Desired controller replica count.
  - `metrics`:
    - `enable`: Expose controller metrics (default true).
    - `port`: Default `9113`.
    - `secure`: If true, expose metrics over TLS.
  - `readinessProbe`:
    - `enable`: Default true.
    - `initialDelaySeconds`: Default 3 seconds.
    - `port`: Default `8081`.
  - `leaderElection`:
    - `enable`: Default true.
    - `lockName`: Optional. Leave empty for automatic naming.
  - `productTelemetry.enable`: Enable product telemetry (default true).
  - `gwAPIExperimentalFeatures.enable`: Enable Gateway API experimental features (default false).
  - `config.logging.level`: Controller logging verbosity (default `info`).
  - `configAnnotations`: Extra annotations to inject into managed resources.
  - `extraVolumes` / `extraVolumeMounts`: Mount additional volumes into the controller.
  - `gatewayClassAnnotations`: Annotate the installed GatewayClass.
  - `labels`, `podAnnotations`: Customize labels and annotations on controller Pods.
  - `service`: Customize the controller Service (annotations/labels).
  - `serviceAccount`: Customize the controller service account and its annotations.
  - `imagePullSecret` / `imagePullSecrets`: Private registry credentials.
  - `snippetsFilters.enable`: Enable filters around user-provided NGINX config snippets (default false).
  - `terminationGracePeriodSeconds`: Default 30 seconds.
  - `topologySpreadConstraints`, `tolerations`, `nodeSelector`, `affinity`: Pod scheduling controls.

## Pod scheduling and security (OpenShift)

- Use `nodeSelector`, `tolerations`, and `topologySpreadConstraints` to adhere to your cluster’s workload placement policies.
- OpenShift SCCs typically require running as non-root. NGF UBI images are compatible; avoid setting hostPorts unless you have an SCC permitting them.
- If your environment enforces custom SCCs, bind the appropriate SCC to the NGF service accounts and use `pod`/`serviceAccount` fields to reference them.

## Validation

After applying the CR, verify that deployments and services are running:

```bash
oc get pods -n nginx-gateway-fabric
oc get svc -n nginx-gateway-fabric
```

Check the installed GatewayClass:

```bash
oc get gatewayclass
```

Logs for troubleshooting:

```bash
# Controller logs
oc logs deploy/ngf-nginx-gateway -n nginx-gateway-fabric

# Data plane logs
oc logs deploy/ngf-nginx -n nginx-gateway-fabric
```

## Optional: Functional check

Create a simple Gateway and HTTPRoute to validate routing:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: http
  namespace: nginx-gateway-fabric
spec:
  gatewayClassName: nginx
  listeners:
    - name: http
      port: 80
      protocol: HTTP
      hostname: example.com
      allowedRoutes:
        namespaces:
          from: Same
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: echo
  namespace: nginx-gateway-fabric
spec:
  parentRefs:
    - name: http
  hostnames:
    - example.com
  rules:
    - backendRefs:
        - name: echo
          port: 8080
```

Ensure you have a Service/Deployment named `echo` on port 8080. If using a LoadBalancer Service, curl the LB IP (or use an OpenShift Route if you configured one).

## References

- Red Hat OperatorHub (OpenShift Web Console → OperatorHub)
- NGINX Gateway Fabric CRD sample (Operator-managed):
  https://github.com/nginx/nginx-gateway-fabric/blob/main/operators/config/samples/gateway_v1alpha1_nginxgatewayfabric.yaml

- NGF Helm chart defaults (values): See `helm-charts/nginx-gateway-fabric/values.yaml` in the NGF repository.

## Notes

- The Operator-specific options listed above reflect the fields exposed in the `NginxGatewayFabric` CR and their defaults in the referenced sample. Your environment and Operator channel may introduce additional fields or defaults. Always review the installed Operator’s CRD and documentation in your cluster for the authoritative schema.
- If your OpenShift environment does not support external LoadBalancer, prefer Route-based exposure. Configure TLS policies (edge/reencrypt/passthrough) consistent with your application’s needs.
