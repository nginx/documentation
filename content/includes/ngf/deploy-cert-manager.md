---
f5-product: FABRIC
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
