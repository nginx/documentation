---
title: Scaling control plane and data plane
weight: 700
toc: true
type: how-to
product: NGF
docs: DOCS-0000
---

Users can scale both the NGINX Gateway Fabric control plane and data planes separately. This guide walks you through how to scale each component effectively and helps you decide when to scale the data plane versus creating a new gateway, based on your traffic patterns.

---

### Scaling the data plane

Data plane constitutes of a single container running both agent and nginx processes. Agent recieves configuration from control plane over a streaming RPC. 
Every Gateway object that gets created results in a new NGINX deployment being provisioned with its own configuration. There are a couple of options on how to scale data plane deployments. You can do so either by increasing the number of replicas for the data plane deployment or by creating a new Gateway to provision a new data plane. 

#### When to create a new gateway vs Scale Data plane replicas

When using NGINX Gateway Fabric, understanding when to scale the data plane vs when to create a new gateway is key to managing traffic effectively.

Scaling data plane replicas is ideal when you need to handle more traffic without changing the configuration. For example, if you're routing traffic to `api.example.com` and notice an increase in load, you can scale the replicas from 1 to 5 to better distribute the traffic and reduce latency. All replicas will share the same configuration from the Gateway used to set up the data plane, making configuration management easy.

You can increase the number of replicas for an NGINX deployment by modifying the field `nginx.replicas` in the `values.yaml` or add the `--set nginx.replicas=` flag to the `helm install` command. Below is an example to do so:

  ```text
  helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway --set nginx.replicas=5
  ```

The other way to scale data planes is by creating a new Gateway. This is is beneficial when you need distinct configurations, isolation, or separate policies. For example, if you're routing traffic to a new domain `admin.example.com` and require a different TLS certificate, stricter rate limits, or separate authentication policies, creating a new Gateway could be a good approach. It allows safe experimentation with isolated configurations and makes it easier to enforce security boundaries and apply specific routing rules.

---

### Scaling the control plane

The control plane builds configuration based on defined Gateway API resources and sends that configuration to the NGINX data planes. With leader election enabled by default, the control plane can be scaled horizontally by running multiple replicas, although only the pod with leader lease can actively manage configuration status updates. 

Scaling the control plane can be beneficial in the following scenarios:

  1. *Higher Availability* - When a control plane pod crashes, runs out of memory, or goes down during an upgrade, it can interrupt configuration delivery. By scaling to multiple replicas, another pod can quickly step in and take over, keeping things running smoothly with minimal downtime.
  2. *Faster Configuration Distribution* - As the number of connected NGINX instances grows, a single control plane pod may become a bottleneck in handling connections or streaming configuration updates. Scaling the control plane improves concurrency and responsiveness when delivering configuration over gRPC.
  3. *Improved Resilience* - Running multiple control plane replicas provides fault tolerance. Even if the leader fails, another replica can quickly take over the leader lease, preventing disruptions in config management and status updates.

To scale the control plane, use the `kubectl scale` command on the control plane deployment to increase or decrease the number of replicas. For example, the following command scales the control plane deployment to 3 replicas:

  ```text
  kubectl scale deployment -n nginx-gateway ngf-nginx-gateway-fabric --replicas 3
  ```

#### Known risks around scaling control plane

When scaling the control plane, it's important to understand how status updates are handled for Gateway API resources.
All control plane pods can send NGINX configuration to the data planes. However, only the leader control plane pod is allowed to write status updates to Gateway API resources. This means that if an NGINX instance connects to a non-leader pod, and an error occurs when applying the config, that error status will not be written to the Gateway object status. To help mitigate the potential for this issue, ensure that the number of NGINX data plane pods equals or exceeds the number of control plane pods. This increases the likelihood that at least one of the data planes is connected to the leader control plane pod. This way if an applied configuration has an error, the leader pod will be aware of it and status can still be written.

There is still a chance (however unlikely) that one of the data planes connected to a non-leader has an issue applying its configuration, while the rest of the data planes are successful, which could lead to that error status not being written.

To identify which control plane pod currently holds the leader election lease, retrieve the leases in the same namespace as the control plane pods. For example:

  ```text
  kubectl get leases -n nginx-gateway
  ```

The current leader lease is held by the pod `ngf-nginx-gateway-fabric-b45ffc8d6-d9z2g_2ef81ced-f19d-41a0-9fcd-a68d89380d10`:

  ```text
  NAME                                       HOLDER                                                                          AGE
  ngf-nginx-gateway-fabric-leader-election   ngf-nginx-gateway-fabric-b45ffc8d6-d9z2g_2ef81ced-f19d-41a0-9fcd-a68d89380d10   16d
  ```

---