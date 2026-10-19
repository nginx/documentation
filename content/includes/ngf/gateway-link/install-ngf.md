---
f5-docs: DOCS-93
f5-product: F5 NGINX Gateway Fabric
f5-files:
- content/ngf/external-loadbalancers/BIG-IP/multicluster.md
- content/ngf/external-loadbalancers/BIG-IP/quickstart.md
---

[Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with external load balancer support enabled.

Using Helm, set the `nginxGateway.externalLoadBalancer.enable=true` value. Using Kubernetes manifests, add the `--external-load-balancer` flag to the `nginx-gateway` container arguments.
