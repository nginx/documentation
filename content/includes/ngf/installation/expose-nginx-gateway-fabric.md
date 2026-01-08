---
nd-product: FABRIC
nd-docs: DOCS-1427
nd-files:
- content/ngf/install/helm.md
- content/ngf/install/manifests.md
---

The Service that is provisioned when NGINX Gateway Fabric is first installed is a ClusterIP Service used only for internal communication between the control plane and data planes. To deploy NGINX itself and get a LoadBalancer Service, you now need to [create a Gateway]({{< ref "/ngf/install/deploy-data-plane.md" >}}).
