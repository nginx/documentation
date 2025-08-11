---
title: Scaling the control plane and data plane
weight: 700
toc: true
type: how-to
product: NGF
nd-docs: DOCS-1840
---

This document describes how you can separately scale the NGINX Gateway Fabric control plane and data plane.

It provides guidance on how to scale each plane effectively, and when you should do so based on your traffic patterns.


### Scaling the data plane

The data plane is the NGINX deployment that handles user traffic to backend applications. Every Gateway object created provisions its own NGINX deployment and configuration.

You have multiple options for scaling the data plane:

- Increasing the number of [worker connections](https://nginx.org/en/docs/ngx_core_module.html#worker_connections) for an existing deployment
- Increasing the number of replicas for an existing deployment
- Creating a new Gateway for a new data plane

#### When to increase worker connections, replicas, or create a new Gateway

Understanding when to increase worker connections, replicas, or create a new Gateway is key to managing traffic effectively.

Increasing worker connections or replicas is ideal when you need to handle more traffic without changing the overall routing configuration. Setting the worker connections field allows a single NGINX data plane instance to handle more connections without needing to scale the replicas. However, scaling the replicas can be beneficial to reduce single points of failure.

Scaling replicas can be done manually or automatically using a [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) (HPA).

To update worker connections (default: 1024), replicas, or enable autoscaling, you can edit the `NginxProxy` resource:

```shell
kubectl edit nginxproxies.gateway.nginx.org ngf-proxy-config -n nginx-gateway
```

{{< call-out "note" >}}

The NginxProxy resource in this example lives in the control plane namespace (default: `nginx-gateway`) and applies to the GatewayClass, but you can also define one per Gateway. See the [Data plane configuration]({{< ref "/ngf/how-to/data-plane-configuration.md" >}}) document for more information.

{{< /call-out >}}

- Worker connections is set using the `workerConnections` field:

```yaml
spec:
  workerConnections: 4096
```

- Replicas are set using the `kubernetes.deployment.replicas` field:

```yaml
spec:
  kubernetes:
    deployment:
      replicas: 3
```

- Autoscaling can be enabled using the `kubernetes.deployment.autoscaling` field. The default `replicas` value will be used until the Horizontal Pod Autoscaler is running.

```yaml
spec:
  kubernetes:
    deployment:
      autoscaling:
        enable: true
        maxReplicas: 10
```

See the `NginxProxy` section of the [API reference]({{< ref "/ngf/reference/api.md" >}}) for the full specification.

All of these fields are also available at installation time by setting them in the [helm values](https://github.com/nginx/nginx-gateway-fabric/blob/main/charts/nginx-gateway-fabric/values.yaml).

An alternate way to scale the data plane is by creating a new Gateway.  This is beneficial when you need distinct configurations, isolation, or separate policies. 

For example, if you're routing traffic to a new domain `admin.example.com` and require a different TLS certificate, stricter rate limits, or separate authentication policies, creating a new Gateway could be a good approach.

It allows for safe experimentation with isolated configurations and makes it easier to enforce security boundaries and specific routing rules.

### Scaling the control plane

The control plane builds configuration based on defined Gateway API resources and sends that configuration to the NGINX data planes. With leader election enabled by default, the control plane can be scaled horizontally by running multiple replicas, although only the pod with leader lease can actively manage configuration status updates.

Scaling the control plane can be beneficial in the following scenarios:

1. _Higher availability_ - When a control plane pod crashes, runs out of memory, or goes down during an upgrade, it can interrupt configuration delivery. By scaling to multiple replicas, another pod can quickly step in and take over, keeping things running smoothly with minimal downtime.
1. _Faster configuration distribution_ - As the number of connected NGINX instances grows, a single control plane pod may become a bottleneck in handling connections or streaming configuration updates. Scaling the control plane improves concurrency and responsiveness when delivering configuration over gRPC.

To automatically scale the control plane, you can create a [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) (HPA) in the control plane namespace (default: `nginx-gateway`). At installation time, the [NGINX Gateway Fabric helm chart](https://github.com/nginx/nginx-gateway-fabric/blob/main/charts/nginx-gateway-fabric/values.yaml) allows you to set the HPA configuration in the `nginxGateway.autoscaling` section, which will provision an HPA for you. If NGINX Gateway Fabric is already running, then you can manually define the HPA and deploy it.

To manually scale the control plane, use the `kubectl scale` command on the control plane deployment to increase or decrease the number of replicas. For example, the following command scales the control plane deployment to 3 replicas:

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