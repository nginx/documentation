---
title: Scaling the control plane and data plane
weight: 700
toc: true
type: how-to
product: NGF
docs: DOCS-0000
---

This document describes how you can separately scale the NGINX Gateway Fabric control plane and data plane.

It provides guidance on how to scale each plane effectively, and when you should do so based on your traffic patterns.


### Scaling the data plane

The data plane is the NGINX deployment that handles user traffic to backend applications. Every Gateway object created provisions its own NGINX deployment and configuration. 

You have two options for scaling the data plane:

- Increasing the number of replicas for an existing deployment
- Creating a new Gateway for a new data plane

#### When to increase replicas or create a new Gateway

Understanding when to increase replicas or create a new Gateway is key to managing traffic effectively.

Increasing data plane replicas is ideal when you need to handle more traffic without changing the configuration. 

For example, if you're routing traffic to `api.example.com` and notice an increase in load, you can scale the replicas from 1 to 5 to better distribute the traffic and reduce latency. 

All replicas will share the same configuration from the Gateway used to set up the data plane, simplifying configuration management.

There are two ways to modify the number of replicas for an NGINX deployment:

First, at the time of installation you can modify the field `nginx.replicas` in the `values.yaml` or add the `--set nginx.replicas=` flag to the `helm install` command:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway --set nginx.replicas=5
```

Secondly, you can update the `NginxProxy` resource while NGINX is running to modify the `kubernetes.deployment.replicas` field and scale the data plane deployment dynamically:

```shell
kubectl edit nginxproxies.gateway.nginx.org ngf-proxy-config -n nginx-gateway
```

The alternate way to scale the data plane is by creating a new Gateway.  This is beneficial when you need distinct configurations, isolation, or separate policies. 

For example, if you're routing traffic to a new domain `admin.example.com` and require a different TLS certificate, stricter rate limits, or separate authentication policies, creating a new Gateway could be a good approach. 

It allows for safe experimentation with isolated configurations and makes it easier to enforce security boundaries and specific routing rules.

### Scaling the control plane

The control plane builds configuration based on defined Gateway API resources and sends that configuration to the NGINX data planes. With leader election enabled by default, the control plane can be scaled horizontally by running multiple replicas, although only the pod with leader lease can actively manage configuration status updates. 

Scaling the control plane can be beneficial in the following scenarios:

1. _Higher availability_ - When a control plane pod crashes, runs out of memory, or goes down during an upgrade, it can interrupt configuration delivery. By scaling to multiple replicas, another pod can quickly step in and take over, keeping things running smoothly with minimal downtime.
1. _Faster configuration distribution_ - As the number of connected NGINX instances grows, a single control plane pod may become a bottleneck in handling connections or streaming configuration updates. Scaling the control plane improves concurrency and responsiveness when delivering configuration over gRPC.

To scale the control plane, use the `kubectl scale` command on the control plane deployment to increase or decrease the number of replicas. For example, the following command scales the control plane deployment to 3 replicas:

  ```shell
  kubectl scale deployment -n nginx-gateway ngf-nginx-gateway-fabric --replicas 3
  ```

#### Known risks when scaling the control plane

When scaling the control plane, it's important to understand how status updates are handled for Gateway API resources.

All control plane pods can send NGINX configuration to the data planes. However, only the leader control plane pod is allowed to write status updates to Gateway API resources. 

If an NGINX instance connects to a non-leader pod, and an error occurs when applying the config, that error status will not be written to the Gateway object status. 

To mitigate the potential for this issue, ensure that the number of NGINX data plane pods equals or exceeds the number of control plane pods. 

This increases the likelihood that at least one of the data planes is connected to the leader control plane pod. If an applied configuration has an error, the leader pod will be aware of it and status can still be written.

There is still a chance (however unlikely) that one of the data planes connected to a non-leader has an issue applying its configuration, while the rest of the data planes are successful, which could lead to that error status not being written.

To identify which control plane pod currently holds the leader election lease, retrieve the leases in the same namespace as the control plane pods. For example:

```shell
kubectl get leases -n nginx-gateway
```

The current leader lease is held by the pod `ngf-nginx-gateway-fabric-b45ffc8d6-d9z2g`:

```shell
NAME                                       HOLDER                                                                          AGE
ngf-nginx-gateway-fabric-leader-election   ngf-nginx-gateway-fabric-b45ffc8d6-d9z2g_2ef81ced-f19d-41a0-9fcd-a68d89380d10   16d
```

---