---
title: Scaling guidance
weight: 100
toc: true
docs: DOCS-989
url: /nginxaas/azure/quickstart/scaling/
type:
- how-to
---

F5 NGINX as a Service for Azure (NGINXaaS) supports manual and automatic scaling of your deployment, allowing you to adapt to application traffic demands while controlling cost.

{{<note>}}This feature is only available for Standard plan(s).{{</note>}}

An NGINXaaS deployment can be scaled out to increase the capacity (increasing the cost) or scaled in to decrease the capacity (reducing the cost). Capacity is measured in [NGINX Capacity Units (NCU)](#nginx-capacity-unit-ncu).

In this document you will learn:

- What an NGINX Capacity Unit (NCU) is
- How to manually scale your deployment
- How to enable autoscaling on your deployment
- What capacity restrictions apply for your Marketplace plan
- How to monitor capacity usage
- How to estimate the amount of capacity to provision

## NGINX Capacity Unit (NCU)

{{< include "/nginxaas-azure/ncu-description.md" >}}

## Manual scaling

To update the capacity of your deploymentv using the Azure Portal,

 1. Select **NGINXaaS scaling** in the left menu.
 1. Select `Manual`.
 1. Set the desired number of NCUs.
 1. Click **Submit** to update your deployment.

## Autoscaling

With autoscaling enabled, the size of your NGINXaaS deployment will automatically adjust based on traffic requirements without the need to guess how many NCUs to provision. You must specify a minimum and maximum NCU count. NGINXaaS will maintain the size of the deployment ensuring the number of provisioned NCUs does not fall below the set minimum NCUs and does not grow beyond the maximum NCUs. Refer to the [Capacity Restrictions](#capacity-restrictions) when setting the minimum and maximum capacity.

When creating a new NGINXaaS deployment with autoscaling enabled, the initial size of the deployment will match the minimum NCU count.

To enable autoscaling using the Azure Portal,

 1. Select **NGINXaaS scaling** in the left menu.
 1. Select `Autoscale`.
 1. Specify the minimum and maximum NCU count.
 1. Click **Submit** to enable NGINXaaS deployment autoscaling.

### Scaling rules

NGINXaaS automatically adjusts the number of NCUs based on "scaling rules." A scaling rule defines when to scale, what direction to scale, and how much to scale. NGINXaaS will evaluate the following scaling rules, in order, based on the percentage capacity consumed metric and the provisioned NCU metric.

- *Moderate Increase Rule*: Over the last 5 minutes, if the average capacity consumed is greater than or equal to 70% of the average provisioned NCUs, increase capacity by 20%.
- *Urgent Increase Rule*: Over the last minute, if the capacity consumed is greater than or equal to 85% of the number of provisioned NCUs, increase capacity by 20%.
- *Decrease Rule*: Over the last 10 minutes, if the average capacity consumed is less than or equal to 60% of the average provisioned NCUs, decrease capacity by 10%.

To avoid creating a loop between scaling rules, NGINXaaS will not apply a scaling rule if it predicts that doing so would immediately trigger an opposing rule. For example, if the the "Urgent Increase Rule" is triggered due to a sudden spike in traffic, but the new capacity will cause the "Decrease Rule" to trigger immediately after, the autoscaler will not increase capacity. This prevents the deployment's capacity from increasing and decreasing erratically.

## Capacity restrictions

The following table outlines constraints on the specified capacity based on the chosen Marketplace plan, including the minimum capacity required for a deployment to be highly available, the maximum capacity, and what value the capacity must be a multiple of. By default, an NGINXaaS for Azure deployment will be created with the corresponding minimum capacity.

{{<bootstrap-table "table table-striped table-bordered">}}

| **Marketplace Plan**         | **Minimum Capacity (NCUs)** | **Maximum Capacity (NCUs)** | **Multiple of**            |
|------------------------------|-----------------------------|-----------------------------|----------------------------|
| Standard plan(s)                  | 10                          | 500                         | 10                         |
{{</bootstrap-table>}}

{{< note >}}If you need a higher maximum capacity, please [open a request](https://my.f5.com/manage/s/) and specify the Resource ID of your NGINXaaS deployment, the region, and the desired maximum capacity you wish to scale to.{{< /note >}}

## Connection processing methods restrictions

- NGINXaaS only supports the `epoll` connection processing method when using the `use` directive, as NGINXaaS is based on Linux.

## Metrics

NGINXaaS provides metrics for visibility of the current and historical capacity values. These metrics, in the `NGINXaaS Statistics` namespace, include:

- NCUs Requested: `ncu.requested` -- how many NCUs have been requested using the API. This is the goal state of the system at that point in time.
- NCUs Provisioned: `ncu.provisioned` -- how many NCUs have been successfully provisioned by the service.
  - This is the basis for [billing]({{< ref "/nginxaas-azure/billing/overview.md" >}}).
  - This may differ from `ncu.requested` temporarily during scale-out/scale-in events or during automatic remediation for a hardware failure.
- Capacity Percentage: `nginxaas.capacity.percentage` -- the percentage of the current workload's total capacity that is being used.
  - If this is over 70%, consider scaling out; otherwise, requests may fail or take longer than expected. Alternatively, enable autoscaling, so your deployment can automatically scale based on the amount of capacity consumed.

See the [Metrics Catalog]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md" >}}) for a reference of all metrics.

{{< note >}}These metrics aren't visible unless enabled, see how to [Enable Monitoring]({{< ref "/nginxaas-azure/monitoring/enable-monitoring.md" >}}) for details.{{< /note >}}
{{< warning >}}The `ncu.consumed` metric is now deprecated and is on the path to retirement. Please change any alerting on this metric to use the new Capacity Percentage metric.{{< /warning >}}

## Estimating how many NCUs to provision

To calculate how many NCUs to provision, take the highest value across the parameters that make up an NCU:

- CPU
- Bandwidth
- Concurrent connections

Example 1: "I need to support 2,000 concurrent connections but only 4 Mbps of traffic. I need 52 ACUs." You would need `Max(52/20, 4/60, 2000/400)` = `Max(2.6, 0.07, 5)` = At least 5 NCUs.

Example 2: "I don't know any of these yet!" Either start with the minimum and [adjust capacity](#adjusting-capacity) with the [iterative approach](#iterative-approach) described below, or [enable autoscaling](#autoscaling).

In addition to the maximum capacity needed, we recommend adding a 10% to 20% buffer of additional capacity to account for unexpected spikes in traffic. Monitor the [Percentage Capacity Metric](#metrics) over time to determine your peak usage levels and adjust your requested capacity accordingly.

### Iterative approach

1. Make an estimate by either:
    - using the [Usage and Cost Estimator]({{< ref "/nginxaas-azure/billing/usage-and-cost-estimator.md" >}})
    - compare to a [reference workload](#reference-workloads)
2. Observe the `nginxaas.capacity.percentage` [metric](#metrics) in Azure Monitor of your workload
3. Decide what headroom factor you wish to have
4. Multiply the headroom factor by the provisioned NCUs to get the target NCUs.
5. [Adjust capacity](#adjusting-capacity)  to the target NCUs
6. repeat from step 2 -- it is always good to check back after making a change

*Example*:

1. I am really unsure what size I needed so I just specified the default capacity,  `20NCUs`.
2. I observe that my `nginxaas.capacity.percentage` is currently at `90%`.
3. This is early morning, traffic. I think midday traffic could be 3x what it is now.
4. `90% * 3 = 270%. 2.7 * 20 NCUs = 54 NCUs` 54 NCUs is my target capacity.
5. I can see that I need to scale by multiples of 10 so I'm going to scale out to `60NCUs`.
6. At midday I can see that I overestimated the traffic I would be getting and it was still a busy day. We peaked at `68%` of capacity, let me scale in to `50NCUs` to match the workload.

### Reference workloads

These reference workloads were all measured with a simplistic NGINX config proxying requests to an upstream. Keepalive between NGINX and upstream is enabled. Minimal request matching or manipulation is done.

| **TLS?** | **Conn/s** | **Req/s** | **Response Size** | **Throughput** | **NCU** |
|:--------:|-----------:|----------:|------------------:|---------------:|--------:|
| no       |      12830 |     13430 |               0KB |         23Mbps |    18.8 |
| no       |      12080 |     13046 |               1KB |        125Mbps |      19 |
| no       |      12215 |     12215 |              10KB |        953Mbps |      21 |
| no       |       1960 |      1690 |             100KB |       1295Mbps |    23.6 |
