---
f5-docs: DOCS-89
f5-product: F5 NGINX Gateway Fabric
f5-files:
- content/ngf/external-loadbalancers/BIG-IP/multicluster.md
- content/ngf/how-to/gateway-api-inference-extension.md
- content/ngf/install/manifests/open-source-experimental.md
- content/ngf/install/manifests/open-source.md
- content/ngf/install/manifests/plus-experimental.md
- content/ngf/install/manifests/plus.md
- content/ngf/traffic-management/https-termination.md
- content/ngf/traffic-management/tlsroute.md
- content/ngf/traffic-security/integrate-cert-manager.md
- content/ngf/traffic-security/jwt-authentication.md
- content/ngf/traffic-security/oidc-authentication.md
- content/ngf/traffic-security/secure-backend.md
---

Install cert-manager onto the cluster using Helm with Gateway API features enabled.

- Add the Helm repository.

  ```shell
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
  ```

- Install cert-manager, and enable the GatewayAPI feature gate:

  ```shell
  helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --set config.apiVersion="controller.config.cert-manager.io/v1alpha1" \
    --set config.kind="ControllerConfiguration" \
    --set config.enableGatewayAPI=true \
    --set crds.enabled=true
  ```
