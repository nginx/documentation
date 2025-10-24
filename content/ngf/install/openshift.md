---
title: Install NGINX Gateway Fabric on OpenShift using OperatorHub
description: Deploy F5 NGINX Gateway Fabric on Red Hat OpenShift through OperatorHub and configure it using the NginxGatewayFabric custom resource.
weight: 500
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1851
---

## Overview

This guide explains how to install F5 NGINX Gateway Fabric (NGF) on Red Hat OpenShift through OperatorHub and configure it with the `NginxGatewayFabric` custom resource. 

On this page

- Prerequisites for OpenShift
- Install NGINX Gateway Fabric Operator from OperatorHub
- Create the NginxGatewayFabric custom resource
- Review OpenShift considerations (images, service exposure, SCC)
- Configure operator options in the custom resource
- Validate the installation and troubleshoot issues

## Prerequisites

- A running Red Hat OpenShift cluster with cluster administrator privileges.
- Access to OperatorHub in the OpenShift Web Console.
- The oc command-line tool is installed, and you are logged in to your cluster.
- Ability to pull images from `ghcr.io` (or a mirrored registry if required by your environment).
- Optional:
  - F5 NGINX One dataplane API key if you plan to integrate with NGINX One.
  - F5 NGINX Plus entitlements if you plan to run NGF with NGINX Plus.
- Network exposure model decided:
  - LoadBalancer Services (recommended where available)
  - Or OpenShift Routes/NodePorts (if LoadBalancer is not available)

### Review OpenShift support and images

NGF provides first-class OpenShift support with Universal Base Image (UBI)-based images. Use the `-ubi` tags shown in the custom resource definition (CRD) examples below. Security constraints, such as running as non-root, are handled by defaults compatible with OpenShift Security Context Constraints (SCCs) in most environments. If your cluster enforces custom SCCs or policies, see the "Pod scheduling and security" options under operator-specific configuration.

## Install NGINX Gateway Fabric Operator from OperatorHub

1. Go to the Red Hat Catalog: https://catalog.redhat.com/en
2. Search for "NGINX Gateway Fabric Operator".
3. Select NGINX Gateway Fabric Operator (provider: F5, Inc.).
4. Select **Deploy & use**.
5. Choose the appropriate architecture and release tag.
6. Complete the installation. Wait until the Operator status shows Installed.

If you prefer CLI-based installation (Subscription/OperatorGroup), consult OpenShift documentation for creating `OperatorGroup` and `Subscription` resources in your chosen namespace. The Web Console path above is recommended.

## Create a project and required secrets

Create a dedicated project (namespace) for NGF components, for example:

```shell
oc new-project nginx-gateway-fabric
```

## TLS secrets for internal communication

NGF can generate internal certificates for agent/server by default, or you can provide your own secrets.

Option A: Let NGF generate the certificates
- Use the default `certGenerator` settings from the sample custom resource (no additional steps needed).
- `certGenerator.overwrite: false` means NGF will not overwrite existing secrets if present.

Option B: Provide your own secrets (example)
```shell
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

```shell
oc create secret generic nginxone-dataplane-key \
  --from-literal=key=VALUE \
  -n nginx-gateway-fabric
```

You will reference this secret in the `spec.nginx.nginxOneConsole.dataplaneKeySecretName` field.

## Optional: NGINX Plus licensing

If you plan to use NGINX Plus, you will need to:
- Set `spec.nginx.plus: true`
- Provide appropriate image repository/registry credentials in `imagePullSecret(s)`
- Optionally create a secret for license and entitlement artifacts (name by convention below):

```shell
# Example license secret name referenced by usage.secretName
oc create secret generic nplus-license \
  --from-file=nginx-repo.crt=/path/to/nginx-repo.crt \
  --from-file=nginx-repo.key=/path/to/nginx-repo.key \
  -n nginx-gateway-fabric
```

Consult your subscription details for the exact files/registry access used for NGINX Plus images in your environment.

## Create the NginxGatewayFabric custom resource

Minimal example for OpenShift:

```yaml
apiVersion: gateway.nginx.org/v1alpha1
kind: NginxGatewayFabric
metadata:
  name: ngf
  namespace: nginx-gateway-fabric
spec:
  # Data plane (NGINX)
  nginx:
    replicas: 2
    image:
      repository: ghcr.io/nginx/nginx-gateway-fabric/nginx
      tag: 2.2.0-ubi
      pullPolicy: IfNotPresent

  # Controller
  nginxGateway:
    gatewayClassName: nginx
    gatewayControllerName: gateway.nginx.org/nginx-gateway-controller
    image:
      repository: ghcr.io/nginx/nginx-gateway-fabric
      tag: 2.2.0-ubi
      pullPolicy: IfNotPresent
    replicas: 1
```

Apply the custom resource:

```shell
oc apply -f nginx-gateway-fabric.yaml
```

Wait for the Operator to reconcile. It will provision the NGF controller and data plane deployments, services, and related resources.

## Configure exposure options for OpenShift

- LoadBalancer Service (preferred where available): Use `spec.nginx.service.type: LoadBalancer`. You can also configure:
  - `externalTrafficPolicy: Local` to preserve source IPs (useful for client IP-based policies).
  - `loadBalancerClass`, `loadBalancerIP`, and `loadBalancerSourceRanges` per your environment.

- Routes/NodePort (if a LoadBalancer is not available):
  - Set `spec.nginx.service.type: NodePort` and create an OpenShift Route to the NGF front-end service (for HTTP/HTTPS traffic).
  - Example (edge termination route; replace service name and ports appropriately):
    ```shell
    oc create route edge ngf \
      --service=nginx-gateway-fabric-nginx \
      --port=http \
      -n nginx-gateway-fabric
    ```
  - For TLS passthrough, use `--passthrough` and target the appropriate service port.

## Operator-specific configuration options (NginxGatewayFabric spec)

To view all Operator-specific configurations avaialbe, run this command

```shell
oc explain NginxGatewayFabric
```

Example output:

```shell

```

## Pod scheduling and security (OpenShift)

- Use `nodeSelector`, `tolerations`, and `topologySpreadConstraints` to adhere to your cluster’s workload placement policies.
- OpenShift Security Context Constraints (SCCs) typically require running as non-root. NGF UBI images are compatible; avoid setting hostPorts unless you have an SCC that permits them.
- If your environment enforces custom SCCs, bind the appropriate SCC to the NGF service accounts and use `pod`/`serviceAccount` fields to reference them.

## Validate the installation

After applying the custom resource, verify that deployments and services are running:

```shell
oc get pods -n nginx-gateway-fabric
oc get svc -n nginx-gateway-fabric
```

Check the installed GatewayClass:

```shell
oc get gatewayclass
```

Logs for troubleshooting:

```shell
# Controller logs
oc logs deploy/ngf-nginx-gateway -n nginx-gateway-fabric

# Data plane logs
oc logs deploy/ngf-nginx -n nginx-gateway-fabric
```

## Perform a functional check (optional)

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

Ensure you have a Service and Deployment named `echo` that expose port 8080. If you are using a LoadBalancer Service, send a request to the load balancer IP address. Otherwise, use an OpenShift Route as configured.

## References

- Red Hat Catalog (https://catalog.redhat.com/en)
- NGINX Gateway Fabric custom resource sample (https://github.com/nginx/nginx-gateway-fabric/blob/{{< version-ngf >}}/operators/config/samples/gateway_v1alpha1_nginxgatewayfabric.yaml)
