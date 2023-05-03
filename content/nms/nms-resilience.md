---
title: "NGINX Management Suite Resiliency"
date: 2023-03-13T08:29:53-07:00
draft: false
description: "NGINX Management Suite installed on Kubernetes provides control plane resilience through fault tolerance and automated recovery."
weight: 30
toc: true
tags: [ "docs" ]
docs: "DOCS-1161"
categories: ["installation", "platform management"]
doctypes: ["concept"]
journeys: ["researching", "getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
---

{{< custom-styles >}}

## Overview

The NGINX Management Suite platform includes four services (described below) that work together to monitor NGINX data plane instances. These platform services feature self-monitoring capabilities, allowing them to detect unresolvable issues and shut down automatically. When you [install NGINX Management Suite on Kubernetes]({{< relref "/nms/admin-guides/installation/kubernetes/nms-helm.md">}}), you get the benefits of fault tolerance and automated recovery: when a platform service fails, Kubernetes will create new pods and restart the affected services without disruption to the data plane.

---

## What is Resilience?

Resilience refers to a system's ability to bounce back from failures or disruptions through fault tolerance and automated recovery. High-availability, on the other hand, refers to a system's ability to sustain uninterrupted operation despite any failures by means of redundancy, failover, and replication.

---

## How is NGINX Management Suite Resilient?

As the control plane for NGINX Open Source and NGINX Plus instances, the NGINX Management Suite is designed for resilience. Although NGINX Management Suite does not provide the same high-availability guarantees as the data plane, it is capable of quickly recovering from problems if they arise.

### Platform Services

NGINX Management Suite includes the following four platform services that work together to monitor and manage NGINX data plane instances through APIs and web dashboards. Within a Kubernetes deployment, the NGINX Management Suite platform services are deployed as [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and are monitored by the [Kubernetes control plane](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components) to ensure their reliable operation.

{{<bootstrap-table "table table-striped table-bordered">}}
| <div style="width:200px">Service</div> | Description                                                                                                                                                                                                                                          |
|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Core                                   | The core service configures and sets up the management plane, as well as performs data analysis for metrics, events, and alerts.                                                                                                                     |
| Data Plane Manager (DPM)               | The data plane manager (DPM) service is responsible for configuring NGINX instances on the data plane, monitoring the state of data plane resources, and generating reports and event messages.                                                      |
| Ingestion                              | The ingestion service collects metrics, security violations, and events not sent to the data plane manager service by the NGINX Agent. This information can be forwarded to external data stores.                                                    |
| Integrations                           | The integrations process includes features for interacting with external components, like configuring [NGINX App Protect WAF policies]({{< relref "/nms/nim/how-to/app-protect/setup-waf-config-management.md" >}}), managing threat campaigns, and more. |
{{< /bootstrap-table >}}

### Databases

NGINX Management Suite utilizes [Dqlite](https://dqlite.io/) and [ClickHouse](https://clickhouse.com/) databases, with [NATS streaming](https://nats.io) for process coordination and event propagation. Each of these components requires persistent data storage.

#### Dqlite

The Core, DPM, and Integration platform services include an embedded Dqlite database. In Kubernetes deployments of NGINX Management Suite, [Kubernetes Persistent Volumes (PVs)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) are used for pods running the platform services. In the event that a service needs to be restarted, the state and data of its Dqlite database can be restored.

#### ClickHouse

NGINX Management Suite also uses a ClickHouse database, which can be installed from the Helm chart as a pod in the NGINX Management Suite namespace, or managed separately as a standalone cluster.

It's also possible to run ClickHouse as a pod alongside the NGINX Management Suite pods, using a persistent volume for storage. Or, if desired, NGINX Management Suite can be configured to connect to an externally-managed [ClickHouse cluster](https://aws.amazon.com/solutions/implementations/clickhouse-cluster/) that can leverage custom high-availability architectures.

## Architecture

The following diagram shows the architecture of NGINX Management Suite deployed on Kubernetes.

{{< img src="nim/k8s-hybrid.png" caption="Figure 1. NGINX Management Suite Kubernetes deployment" alt="A diagram showing the architecture of the NGINX Management Suite's deployed on Kubernetes.">}}

---

## Process Recovery Times

If an NGINX Management Suite platform service fails or the node hosting the pod becomes unhealthy, Kubernetes will reschedule the pod to run on another node. The Kubernetes scheduler is subject to resource availability and node health in the cluster but will match pods to nodes as close to immediately as possible.

Our tests showed the following recovery times:

**Environment**

- AWS EC2 Kubernetes v1.24 cluster

- 4 worker nodes (t3a.medium instances)

- Low scheduler contention

- Low CPU and memory pressure

- Zero NGINX data plane proxies managed by NGINX Management Suite

- NGINX Management Suite 2.9.0

- ClickHouse pod as defined in the [NGINX Management Suite helm chart]({{< relref "/nms/admin-guides/installation/kubernetes/nms-helm.md">}})

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

Recovery time for the DPM pod depends on how many NGINX data plane instances NGINX Management Suite manages.

{{<bootstrap-table "table table-striped table-bordered">}}
| Managed data plane instances | Average DPM recovery time |
|------------------------------|---------------------------|
| 0 instances                  | 3.95 seconds              |
| 250 instances                | 4.1 seconds               |
| 500 instances                | 5.45 seconds              |
{{</bootstrap-table>}}

---

## Business Continuity and Disaster Recovery

{{<important>}}
NGINX Management Suite should be integrated into the customer's established Business Continuity and Disaster Recovery (BC/DR) strategy with the following considerations:

- The NGINX data plane instances managed by NGINX Management Suite don't require the NGINX Management Suite Control Plane to serve traffic. The data plane instances retain their last published configurations and will continue to operate without interruption if they remain in a healthy state.

- Make use of the native replication or snapshot mechanisms provided by the hosting solution to back up the persistent volumes used by NGINX Management Suite. Ensure that your organization's backup and restore plan includes regular backups of the NGINX Management Suite configuration files and Dqlite and ClickHouse databases.

- Ensure that disaster recovery plan metrics, such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO), are established for the NGINX Management Suite control plane independently of the data plane. Periodically update these metrics to take into account how data plane size affects NGINX Management Suite services and storage requirements.

{{</important>}}

---

## What's Next

For resilient deployments, we recommend [installing NGINX Management Suite on Kubernetes using Helm](({{< relref "/nms/admin-guides/installation/kubernetes/nms-helm.md">}})). With Kubernetes, you'll get the benefits of persistent volumes and automated recovery for a reliable control plane.
