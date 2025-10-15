---
title: Scale your deployment
weight: 400
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/getting-started/manual-scaling/
type:
- how-to
---

F5 NGINXaaS for Google Cloud (NGINXaaS) supports manual scaling of your deployment, allowing you to adapt to application traffic demands while controlling cost.

An NGINXaaS deployment can be scaled out to increase the capacity or scaled in to decrease the capacity. Capacity is measured in [NGINX Capacity Units (NCU)](#nginx-capacity-unit-ncu).

In this document you will learn:

- What an NGINX Capacity Unit (NCU) is
- How to manually scale your deployment
- What capacity restrictions apply for your plan
- How to monitor capacity usage
- How to estimate the amount of capacity to provision

## NGINX Capacity Unit (NCU)

An NGINX Capacity Unit (NCU) quantifies the capacity of an NGINX instance based on the underlying compute resources. This abstraction allows you to specify the desired capacity in NCUs without having to consider the regional hardware differences.

## Manual scaling

To update the capacity of your deployment using the console,

In the NGINXaaS Console,

1. On the left menu, select **Deployments**.
2. Select the deployment you wish to edit the NCU capacity for.
3. On the **Details** tab, select the **Edit** button on the right to open the Edit Deployment Metadata pane
   - Enter the desired value for the **NCU Capacity** under **Scale**.
   - Select **Update** to begin the scaling process.

The status of the deployment will be "Pending" while the deployment's capacity is being changed. Once the requested capacity provisioning is complete, the status will change to "Ready".

  {{< call-out "note" >}}There's no downtime while an NGINXaaS deployment changes capacity.{{< /call-out >}}

## Capacity restrictions

The following table outlines constraints on the specified capacity based on the chosen Marketplace plan, including the minimum capacity required for a deployment to be highly available, and the maximum capacity. By default, an NGINXaaS for Google Cloud deployment will be created with a capacity of 20 NCUs.

{{<bootstrap-table "table table-striped table-bordered">}}

| **Marketplace Plan**         | **Minimum Capacity (NCUs)** | **Maximum Capacity (NCUs)** |
|------------------------------|-----------------------------|-----------------------------|
| Enterprise plan(s)             | 10                          | 100                         |

{{</bootstrap-table>}}

{{< call-out "note" >}}If you have higher capacity needs than the maximum capacity, please [open a request](https://my.f5.com/manage/s/) and specify the Resource ID of your NGINXaaS deployment, the region, and the desired maximum capacity you wish to scale to.{{< /call-out >}}
