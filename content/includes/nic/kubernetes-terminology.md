---
nd-product: INGRESS
nd-files:
- content/glossary/_index.md
---

{{< table >}}

| Term        | Definition |
| ---- | ---------- |
| **Ingress** | Refers to an *Ingress Resource*, a Kubernetes API object which allows access to [Services](https://kubernetes.io/docs/concepts/services-networking/service/) within a cluster. They are managed by an [Ingress Controller]({{< ref "/glossary/#ingress-controller">}}). *Ingress* resources enable the following functionality:<br>* **Load balancing**, extended through the use of Services<br>* **Content-based routing**, using hosts and paths<br>* **TLS/SSL termination**, based on hostnames<br><br>For additional information, please read the official [Kubernetes Ingress Documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| **Ingress Controller** | Ingress Controllers are applications within a Kubernetes cluster that enable [Ingress]({{< ref "/glossary/#ingress">}}) resources to function. They are not automatically deployed with a Kubernetes cluster, and can vary in implementation based on intended use, such as load balancing algorithms for Ingress resources. [The design of NGINX Ingress Controller]({{< ref "/nic/overview/design.md">}}) explains the technical details of NGINX Ingress Controller. |

{{< /table >}}
