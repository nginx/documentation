---
f5-product: NGINX Gateway Fabric
---

[Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with external load balancer support enabled.

Using Helm, set the `nginxGateway.externalLoadBalancer.enable=true` value. Using Kubernetes manifests, add the `--external-load-balancer` flag to the `nginx-gateway` container arguments.
