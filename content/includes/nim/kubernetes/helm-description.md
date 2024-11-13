---
docs: "DOCS-1665"
---

Helm charts are pre-configured packages of Kubernetes resources deployed with a single command, which allow you to to define, install, and upgrade Kubernetes applications. 

They are composed of a set of files that describe a related group of Kubernetes resources, including deployments, services, and ingress. Helm charts can define and manage dependencies between various applications, allowing for the development of complex, multi-tier applications.

{{< warning >}} NGINX Instance Manager does not support [OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift). 

For best compatibility, use [NGINX Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/). {{< /warning >}}