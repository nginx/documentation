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

Use this guide to install F5 NGINX Gateway Fabric (NGF) on Red Hat OpenShift through OperatorHub and configure it with the `NginxGatewayFabric` custom resource. Install NGF with OperatorHub when you want lifecycle management integrated into OpenShift and a straightforward, recommended path to deploy NGF components.

## Before you begin

Ensure you have:

- A running Red Hat OpenShift cluster with cluster administrator privileges.
- Ability to pull images from `ghcr.io` (or a mirrored registry if required by your environment).
- A decided network exposure model:
  - LoadBalancer Services (recommended where available), or
  - OpenShift Routes and NodePorts (if a LoadBalancer is not available).

- Optional integrations
  - F5 NGINX One dataplane API key if you plan to integrate with NGINX One.
  - F5 NGINX Plus entitlements if you plan to run NGF with NGINX Plus.

Note: NGF provides first-class OpenShift support with Universal Base Image (UBI)-based images. Use the `-ubi` tags shown in the custom resource definition (CRD) examples. Defaults are compatible with OpenShift Security Context Constraints (SCCs) for non-root operation. If your cluster enforces custom SCCs or policies, bind the appropriate SCC to NGF service accounts.

## Steps

### Install NGINX Gateway Fabric Operator from OperatorHub

1. To install the Operator, do the following:
   1.1. Go to the Red Hat Catalog: https://catalog.redhat.com/en  
   1.2. Search for "NGINX Gateway Fabric Operator".  
   1.3. Select NGINX Gateway Fabric Operator (provider: F5, Inc.).  
   1.4. Select **Deploy & use**.  
   1.5. Choose the appropriate architecture and release tag.  
   1.6. Complete the installation. Wait until the Operator status shows Installed.

   Result: The NGF Operator is installed and available in your cluster.

### Create a project

2. Create a dedicated project (namespace) for NGF components.
   ```bash
   oc new-project nginx-gateway-fabric
   ```

   Result: The `nginx-gateway-fabric` project is created.

### Create TLS secrets for internal communication (optional)

3. If you want NGF to auto-generate internal certificates, skip this step. To provide your own TLS secrets, create the following:
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

   Result: The `agent-tls` and `server-tls` secrets are available in the project.

### Integrate with NGINX One (optional)

4. If you want NGF to connect to NGINX One, create a secret for the dataplane key (replace VALUE with your key).
   ```bash
   oc create secret generic nginxone-dataplane-key \
     --from-literal=key=VALUE \
     -n nginx-gateway-fabric
   ```
   Next, reference this secret in `spec.nginx.nginxOneConsole.dataplaneKeySecretName`.

   Result: NGF can authenticate to NGINX One using the dataplane key.

### Configure NGINX Plus licensing (optional)

5. If you plan to use NGINX Plus, set `spec.nginx.plus: true`, add image pull credentials, and create a license secret if needed.
   ```bash
   # Example license secret name referenced by usage.secretName
   oc create secret generic nplus-license \
     --from-file=nginx-repo.crt=/path/to/nginx-repo.crt \
     --from-file=nginx-repo.key=/path/to/nginx-repo.key \
     -n nginx-gateway-fabric
   ```

   Result: NGF is configured to use NGINX Plus images and license artifacts.

### Create the NginxGatewayFabric custom resource

6. Create a minimal `NginxGatewayFabric` custom resource for OpenShift.
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
   ```bash
   oc apply -f nginx-gateway-fabric.yaml
   ```

   Result: The Operator reconciles the custom resource and provisions the NGF controller and data plane.

### Configure exposure options for OpenShift (optional)

7. Choose one exposure option:

   - If a LoadBalancer is available, set `spec.nginx.service.type: LoadBalancer`. Optionally set:
     - `externalTrafficPolicy: Local` to preserve client source IPs.
     - `loadBalancerClass`, `loadBalancerIP`, and `loadBalancerSourceRanges` per your environment.

   - If a LoadBalancer is not available, set `spec.nginx.service.type: NodePort`, then create an OpenShift Route to the NGF front-end Service (for HTTP/HTTPS traffic):
     ```bash
     oc create route edge ngf \
       --service=nginx-gateway-fabric-nginx \
       --port=http \
       -n nginx-gateway-fabric
     ```
     For TLS passthrough, add `--passthrough` and target the appropriate Service port.

   Result: NGF is reachable according to your cluster’s exposure model.

### Validate the installation

8. Verify that deployments and services are running, and confirm the GatewayClass:
   ```bash
   oc get pods -n nginx-gateway-fabric
   oc get svc -n nginx-gateway-fabric
   oc get gatewayclass
   ```
   If troubleshooting is required, review logs:
   ```bash
   # Controller logs
   oc logs deploy/ngf-nginx-gateway -n nginx-gateway-fabric

   # Data plane logs
   oc logs deploy/ngf-nginx -n nginx-gateway-fabric
   ```

   Result: NGF components are running and reporting readiness.

### Perform a functional check (optional)

9. Create a simple Gateway and HTTPRoute to validate routing:
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

   Result: Requests to `example.com` route to the `echo` backend through NGF.

## See also

- Install NGINX Gateway Fabric with Helm: /ngf/install/helm/
- Secure certificates for NGF: /ngf/install/secure-certificates/
- Red Hat Catalog (https://catalog.redhat.com/en)
- NGINX Gateway Fabric custom resource sample (https://github.com/nginx/nginx-gateway-fabric/blob/{{< version-ngf >}}/operators/config/samples/gateway_v1alpha1_nginxgatewayfabric.yaml)
