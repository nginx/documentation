---
f5-product: FABRIC
f5-docs: DOCS-1427
f5-files:
- content/ngf/install/helm.md
- content/ngf/install/manifests.md
---

When NGINX Gateway Fabric is installed, it provisions a ClusterIP Service used only for internal communication between the control plane and data planes. 

To deploy NGINX itself and get a LoadBalancer Service, you should follow the [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}}) instructions.
