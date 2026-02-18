---
nd-product: FABRIC
nd-docs: DOCS-1427
nd-files:
- content/ngf/install/helm.md
- content/ngf/install/manifests.md
---

When NGINX Gateway Fabric is installed, it provisions a ClusterIP Service used only for internal communication between the control plane and data planes. 

To deploy NGINX itself and get a LoadBalancer Service, you should follow the [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}}) instructions.
