---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  set up policies.
docs: DOCS-925
toc: true
weight: 100
title: How to Set Up Policies
type:
- how-to
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

{{< include "acm/how-to/policies-intro.md" >}}

---

### Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with [API Gateways]({{< relref "/nms/acm/getting-started/add-api-gateway" >}}) or [Developer Portals]({{< relref "/nms/acm/getting-started/add-devportal" >}}).

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

---

## Set Up Global Policies

Global Policies are configured at the environment level and apply to all clusters and proxies within the environment.

{{< include "acm/about/global-policies.md" >}}

<br>

To manage Global Policies, take the steps below:

1. In the API Connectivity Manager user interface, go to **Infrastructure > Workspaces > Environments**.
2. Select the Environment that holds the cluster that you want to configure, then select the **Cluster** name.
3. Select the **Manage** icon for the cluster that you want to configure.
4. Select the **Global Policies** tab.
5. [**Add**](#add-cluster-policy), [**Edit**](#edit-cluster-policy), or [**Remove**](#remove-cluster-policy) as desired.
6. **Save and Submit** your changes.

### Add a Policy {#add-cluster-policy}

Take the steps in this section to add a new policy to a cluster.

1. Go to **Manage > Global Policies** for the cluster.
1. Select **Add Policy** from the policy's **Actions** menu.
1. Complete the form provided to configure the policy, then select **Add**.
1. **Save and Submit** your changes.

### Edit a Policy {#edit-cluster-policy}

To edit a policy, take the steps below.

1. Go to **Manage > Global Policies** for the cluster.
1. Select **Edit Policy** from the policy's **Actions** menu.
1. Edit the policy as needed.
1. Select **Save** and **Save and Submit**.

### Remove a Policy {#remove-cluster-policy}

To remove a policy, take the steps below.

1. Go to the **Global Policies** tab for the cluster.
1. Select **Remove Policy** from the policy's **Actions** menu.

---

## Set Up API Proxy Policies

{{< include "acm/about/api-proxy-policies.md" >}}

<br>

Any Global Policies will automatically be applied when you add an API Proxy.
You can also configure any of the optional policies at the proxy level.

To manage Proxy Policies, take the steps below.

1. In the API Connectivity Manager user interface, go to **Services > Workspaces > Proxies**.
1. Select **Edit Proxy** from the **Actions** menu for the Proxy that you want to configure.
1. Select the **Policies** tab.
1. [**Add**](#add-proxy-policy), [**Edit**](#edit-proxy-policy), or [**Remove**](#remove-proxy-policy) as desired.
1. **Save and Publish** your changes.

### Add a Policy {#add-proxy-policy}

Take the steps in this section to add a new policy to a cluster.

1. Go to **Edit Proxy > Policies**.
1. Select **Add Policy** from the policy's Actions menu.
1. Complete the form to configure the policy, then select the **Add** button.
1. **Save and Submit** your changes.

### Edit a Policy {#edit-proxy-policy}

Take the steps below to edit a policy.

1. Go to **Edit Proxy > Policies**.
1. Select **Edit Policy** from the policy's Actions menu.
1. Edit the policy as needed.
1. Select **Save**, then **Save and Publish**.

### Remove a Policy {#remove-proxy-policy}

To remove a policy, take the steps below.

1. Go to **Edit Proxy > Policies**.
1. Select **Remove Policy** from the policy's Actions menu.

---

## Set Up Cluster Policies

Cluster Policies are applied to all the proxies belongnig to the desired cluster. In another words, these policies are applied to a cluster of F5 NGINX Plus instances which can have one or more API Gateways and Developer Portals deployed on them.

The following table shows the available Cluster Policies you can use when creating a new cluster.

<br>

**Legend:**

- <i class="fa-solid fa-check"></i> = Supported
- <i class="fa-solid fa-circle-check center"></i> = Applied by default

{{<bootstrap-table "table table-striped table-bordered">}}

| Policy&nbsp;Name                                                  | HTTP Environment                                | gRPC Environment                                | Applied&nbsp;On | Description                                                                                                                                                                                                                                                                                                                                                                                        |
|-------------------------------------------------------------------|-------------------------------------------------|-------------------------------------------------|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Cluster Wide Config Setting]({{< relref "/nms/acm/how-to/policies/cluster-wide-config.md" >}})                                             | <i class="fa-solid fa-circle-check center"></i> | <i class="fa-solid fa-circle-check center"></i> | inbound        | Fine tune the settings to speed up data processing and improve the performance of the API proxy for large number of connections. When applied, the settings are applicable to all the instances in a proxy cluster. If the proxy cluster is shared between environments, the changes made in any environment will be reflected in all the other environments.                                                                                                                                                                                                                                                                                               |
| [Cluster Zone Sync]({{< relref "/nms/acm/how-to/policies/cluster-zone-sync.md" >}})  | <i class="fa-solid fa-check"></i> | <i class="fa-solid fa-check"></i> | inbound        | Enables runtime state sharing between the instances belonging to a proxy cluster. Options configured through this policy affect other policies such as rate limit and OIDC. This policy is applied to all the instances in a proxy cluster. If the proxy cluster is shared between environments, any changes made to this policy will affect all the other environments.                                                                                                          |

{{</bootstrap-table>}}

<br>

To manage Cluster Policies, take the steps below:

1. In the API Connectivity Manager user interface, go to **Infrastructure > Workspaces > Environments**.
2. Select the Environment that holds the cluster that you want to configure, then select the **Cluster** name.
3. Select the **Manage** icon for the cluster that you want to configure.
4. Select the **Cluster Policies** tab.
5. [**Add**](#add-cluster-policy), [**Edit**](#edit-cluster-policy), or [**Remove**](#remove-cluster-policy) as desired.
6. **Save and Submit** your changes.

### Add a Policy {#add-cluster-policy}

Take the steps in this section to add a new policy to a cluster.

1. Go to **Manage > Cluster Policies** for the cluster.
1. Select **Add Policy** from the policy's **Actions** menu.
1. Complete the form provided to configure the policy, then select **Add**.
1. **Save and Submit** your changes.

### Edit a Policy {#edit-cluster-policy}

To edit a policy, take the steps below.

1. Go to **Manage > Cluster Policies** for the cluster.
1. Select **Edit Policy** from the policy's **Actions** menu.
1. Edit the policy as needed.
1. Select **Save** and **Save and Submit**.

### Remove a Policy {#remove-cluster-policy}

To remove a policy, take the steps below.

1. Go to the **Cluster Policies** tab for the cluster.
1. Select **Remove Policy** from the policy's **Actions** menu.

---
