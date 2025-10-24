---
title: Install NGINX Gateway Fabric on OpenShift
description: Deploy F5 NGINX Gateway Fabric on Red Hat OpenShift through OperatorHub and configure it using the NginxGatewayFabric custom resource.
weight: 400
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1851
---

## Overview

This guide details how to install F5 NGINX Gateway Fabric on Red Hat OpenShift through OperatorHub. You can then configure it with the `NginxGatewayFabric` custom resource.

## Before you begin

Before starting, we recommend you have the following:

- A running Red Hat OpenShift cluster with cluster administrator privileges.
- Ability to pull images from `ghcr.io` (or a mirrored registry if required by your environment).

- Optional integrations
  - F5 NGINX One dataplane API key if you plan to integrate with [F5 NGINX One Console](https://docs.nginx.com/nginx-one/).
  - F5 NGINX Plus entitlements if you plan to run NGINX Gateway Fabric with F5 NGINX Plus.

NGINX Gateway Fabric provides first-class OpenShift support with Universal Base Image (UBI)-based images. Use the `-ubi` tags shown in the custom resource definition (CRD) examples. Defaults are compatible with OpenShift Security Context Constraints (SCCs) for non-root operation. If your cluster enforces custom SCCs or policies, bind the appropriate SCC to NGINX Gateway Fabric service accounts.

## Steps

### Install NGINX Gateway Fabric Operator from OperatorHub

  1. Navigate to the Red Hat Catalog: https://catalog.redhat.com/en  
  2. Search for "NGINX Gateway Fabric Operator" in the searchbar at the top
  3. Select NGINX Gateway Fabric Operator
  4. Select **Deploy & use**. 
  5. Choose the appropriate architecture and release tag
  6. Complete the installation. Wait until the Operator status shows Installed

### Create a project

In your cluster, create a dedicated project (namespace) for NGINX Gateway Fabric components.

```shell
oc new-project nginx-gateway-fabric
```

### Create TLS secrets for internal communication (optional)

If you want NGINX Gateway Fabric to auto-generate internal certificates, skip this step. To provide your own TLS secrets, create the following:

Agent TLS (used by internal agent)

```shell
oc create secret tls agent-tls \
  --cert=agent.crt \
  --key=agent.key \
  -n nginx-gateway-fabric
```

Server TLS (used by internal server)

```shell
oc create secret tls server-tls \
  --cert=server.crt \
  --key=server.key \
  -n nginx-gateway-fabric
```

### Integrate with NGINX One Console (optional)

If you want to use NGINX One Console to monitor NGINX Gateway Fabric, create a secret for the dataplane key (replace VALUE with your key).

```shell
oc create secret generic nginxone-dataplane-key \
  --from-literal=key=VALUE \
  -n nginx-gateway-fabric
```

Reference this secret in `spec.nginx.nginxOneConsole.dataplaneKeySecretName`.

### Configure NGINX Plus licensing (optional)

If you plan to use NGINX Plus, set `spec.nginx.plus: true`, add image pull credentials, and create a license secret if needed.

Example license secret name referenced by `usage.secretName`

```shell
oc create secret generic nplus-license \
  --from-file=nginx-repo.crt=/path/to/nginx-repo.crt \
  --from-file=nginx-repo.key=/path/to/nginx-repo.key \
  -n nginx-gateway-fabric
```

### Create the NginxGatewayFabric custom resource

Create a minimal `NginxGatewayFabric` custom resource for OpenShift. Include this code in a file named `nginx-gateway-fabric.yaml`.

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

Result: The Operator reconciles the custom resource and provisions the NGINX Gateway Fabric controller and data plane.

### Configure exposure options for OpenShift (optional)

Choose one exposure option:

If a LoadBalancer is available, set `spec.nginx.service.type: LoadBalancer`. Optionally set:

- `externalTrafficPolicy: Local` to preserve client source IPs.
- `loadBalancerClass`, `loadBalancerIP`, and `loadBalancerSourceRanges` per your environment.

If a LoadBalancer is not available, set `spec.nginx.service.type: NodePort`, then create an OpenShift Route to the NGINX Gateway Fabric front-end Service (for HTTP/HTTPS traffic):

```shell
oc create route edge ngf \
  --service=nginx-gateway-fabric-nginx \
  --port=http \
  -n nginx-gateway-fabric
```

For TLS passthrough, add `--passthrough` and target the appropriate Service port.

### Validate the installation

Verify that deployments and services are running, and confirm the GatewayClass:

```shell
oc get pods -n nginx-gateway-fabric
oc get svc -n nginx-gateway-fabric
oc get gatewayclass
```

If troubleshooting is required, review logs

Controller logs

```shell
oc logs deploy/ngf-nginx-gateway -n nginx-gateway-fabric
```

Data plane logs

```shell
oc logs deploy/ngf-nginx -n nginx-gateway-fabric
```

### Perform a functional check (optional)

Create a Gateway and HTTPRoute to validate routing:

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

## See also

- Install NGINX Gateway Fabric with Helm: /ngf/install/helm/
- Secure certificates for NGINX Gateway Fabric: /ngf/install/secure-certificates/
- Red Hat Catalog (https://catalog.redhat.com/en)
- NGINX Gateway Fabric custom resource sample (https://github.com/nginx/nginx-gateway-fabric/blob/{{< version-ngf >}}/operators/config/samples/gateway_v1alpha1_nginxgatewayfabric.yaml)
