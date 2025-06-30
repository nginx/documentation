---
description: F5 NGINX Management Suite installed on Kubernetes provides control plane
  resilience through fault tolerance and automated recovery.
nd-docs: DOCS-1161
title: NGINX Management Suite Resiliency
toc: true
weight: 30
type:
- concept
---

## Overview

The F5 NGINX Management Suite platform includes four services (described below) that work together to monitor NGINX data plane instances. These platform services feature self-monitoring capabilities, allowing them to detect unresolvable issues and shut down automatically. When you [install NGINX Management Suite on Kubernetes]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md">}}), you get the benefits of fault tolerance and automated recovery: when a platform service fails, Kubernetes will create new pods and restart the affected services without disruption to the data plane.

---

## What is Resilience?

Resilience refers to a system's ability to bounce back from failures or disruptions through fault tolerance and automated recovery. High-availability, on the other hand, refers to a system's ability to sustain uninterrupted operation despite any failures by means of redundancy, failover, and replication.

---

## How is NGINX Management Suite Resilient?

As the control plane for NGINX Open Source and NGINX Plus instances, the NGINX Management Suite is designed for resilience. Although NGINX Management Suite does not provide the same [high-availability guarantees as the data plane](https://docs.nginx.com/nginx/admin-guide/high-availability/), it is capable of quickly recovering from problems if they arise.

### Platform Services

NGINX Management Suite includes the following four platform services that work together to monitor and manage NGINX data plane instances through APIs and web dashboards. When you [install NGINX Management Suite on Kubernetes]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}}), these platform services are deployed as [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and are monitored by the [Kubernetes control plane](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components) to ensure consistent and reliable operation.

{{< include "nms/services/platform-services.md" >}}

### Databases

NGINX Management Suite uses [Dqlite](https://dqlite.io/) and [ClickHouse](https://clickhouse.com/) databases, along with [NATS streaming](https://nats.io), for process coordination and event propagation. Each of these components requires persistent data storage to operate effectively.

#### Dqlite

The Core, DPM, and Integration platform services include an embedded [Dqlite](https://dqlite.io) database. When NGINX Management Suite is deployed on Kubernetes, [Kubernetes Persistent Volumes (PVs)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) are used for pods running the platform services. If a service needs to be restarted, the state and data of its Dqlite database can be restored.

#### ClickHouse

NGINX Management Suite also uses a [ClickHouse](https://clickhouse.com) database, which can be installed from the Helm chart as a pod in the NGINX Management Suite namespace, or managed separately as a standalone cluster.

It's also possible to run ClickHouse as a pod alongside the NGINX Management Suite pods, using a persistent volume for storage. Additionally, if preferred, NGINX Management Suite can be configured to connect to an externally-managed [ClickHouse cluster](https://aws.amazon.com/solutions/implementations/clickhouse-cluster/) hosted on Amazon Web Services (AWS). This allows you to take advantage of custom high-availability architectures to meet your specific needs.

## Architecture

The following diagram shows the architecture of NGINX Management Suite deployed on Kubernetes.

{{< img src="nim/k8s-hybrid.png" caption="Figure 1. NGINX Management Suite Kubernetes deployment" alt="A diagram showing the architecture of the NGINX Management Suite's deployed on Kubernetes.">}}

---

## Process Recovery Times

If an NGINX Management Suite platform service fails or the node hosting the pod becomes unhealthy, Kubernetes will reschedule the pod to run on another node. The Kubernetes scheduler is subject to resource availability and node health in the cluster but will match pods to nodes as close to immediately as possible.

In an environment with the following specifications, we observed the following recovery times:

### Environment

- AWS EC2 Kubernetes v1.24 cluster

- 4 worker nodes (t3a.medium instances)

- Low scheduler contention

- Low CPU and memory pressure

- Zero NGINX data plane proxies managed by NGINX Management Suite

- NGINX Management Suite 2.9.0

- ClickHouse pod as defined in the [NGINX Management Suite helm chart]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md">}})

### Recovery Times

The time it took for the [Pod condition](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-conditions)
to transition from `PodScheduled` to `Ready`:

{{<bootstrap-table "table table-striped table-bordered">}}

| Pod          | Transition from `PodScheduled` to `Ready` |
|--------------|-------------------------------------------|
| apigw        | 2.2 seconds                               |
| core         | 3.1 seconds                               |
| dpm          | 3.95 seconds                              |
| integrations | 2.2 seconds                               |
| ingestion    | 1.6 seconds                               |
| clickhouse   | 17.75 seconds                             |

{{</bootstrap-table>}}

<br>

The recovery time for the DPM (Data Plane Manager) pod depends the number of NGINX data plane instances managed by NGINX Management Suite.

{{<bootstrap-table "table table-striped table-bordered">}}

| Managed data plane instances | Average DPM recovery time |
|------------------------------|---------------------------|
| 0 managed instances          | 3.95 seconds              |
| 250 managed instances        | 4.1 seconds               |
| 500 managed instances        | 5.45 seconds              |

{{</bootstrap-table>}}

---

## Business Continuity and Disaster Recovery

{{<important>}}
When integrating NGINX Management Suite into your existing Business Continuity and Disaster Recovery (BC/DR) strategy, consider the following:

- NGINX data plane instances managed by NGINX Management Suite can serve traffic independently of the NGINX Management Suite control plane. Data plane instances will continue to operate seamlessly with their last published configurations as long as they remain healthy.

- Use the replication or snapshot capabilities provided by your hosting solution to back up the persistent volumes used by NGINX Management Suite. Ensure that your organization's backup and restore plan includes regular backups of NGINX Management Suite configuration files, Dqlite, and ClickHouse databases.

- Establish specific metrics for your disaster recovery plan, such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO), for the NGINX Management Suite control plane independently of the data plane. Regularly review and update these metrics to consider the impact of data plane size on NGINX Management Suite services and storage requirements.

{{</important>}}

---

## What's Next

### Install NGINX Management Suite on Kubernetes

For resilient deployments, we recommend [installing NGINX Management Suite on Kubernetes]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}}). With Kubernetes, you'll get the benefits of persistent volumes and automated recovery for a reliable control plane.
