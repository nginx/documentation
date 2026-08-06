---
f5-product: NGINX Gateway Fabric
f5-files:
- content/ngf/external-loadbalancers/gateway-link/quickstart.md
- content/ngf/external-loadbalancers/gateway-link/multicluster.md
---

[Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with external load balancer support enabled.

Using Helm, set the `nginxGateway.externalLoadBalancer.enable=true` value. Using Kubernetes manifests, add the `--external-load-balancer` flag to the `nginx-gateway` container arguments.
