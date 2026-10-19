---
f5-docs: DOCS-97
f5-product: F5 NGINX Gateway Fabric
f5-files:
- content/ngf/install/helm.md
- content/ngf/install/manifests/open-source-experimental.md
- content/ngf/install/manifests/open-source.md
- content/ngf/install/manifests/plus-experimental.md
- content/ngf/install/manifests/plus.md
---

When NGINX Gateway Fabric is installed, it provisions a ClusterIP Service used only for internal communication between the control plane and data planes. 

To deploy NGINX itself and get a LoadBalancer Service, you should follow the [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}}) instructions.
