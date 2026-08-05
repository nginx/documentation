---
f5-product: FABRIC
---

[Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with external load balancer support enabled.

Using Helm, set the `nginxGateway.externalLoadBalancer.enable=true` value. Using Kubernetes manifests, add the `--external-load-balancer` flag to the `nginx-gateway` container arguments.
