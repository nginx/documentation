---
authors: []
categories:
- installation
date: "2020-10-21T14:43:55-07:00"
description: This guide explains how to deploy NGINX Controller as a multi-node resilient
  cluster on a private cloud.
docs: DOCS-258
doctypes:
- tutorial
draft: false
journeys:
- getting started
personas:
- devops
- netops
- secops
roles:
- admin
tags:
- docs
title: Deploy NGINX Controller as a Resilient Cluster on a Private Cloud
toc: true
weight: 300
---

## Overview

Complete the steps in this guide to deploy NGINX Controller as a resilient, three-node cluster on your private cloud. A multi-node cluster ensures that NGINX Controller stays up even if one of the control-plane hosts becomes unavailable.

The diagram below shows how the different objects in a multi-node NGINX Controller cluster relate to each other. The control nodes communicate with an embedded, self-hosted database that is stored on an external volume. The NGINX Controller Agent -- and NGINX Controller users -- can access the cluster via a load balancer or floating IP address that is associated with NGINX Controller's FQDN. If a node in the cluster becomes unavailable for any reason, traffic is re-routed automatically to an available node.

{{< img src="/ctlr/img/multi-node-diagram.png" alt="Diagram showing the relationship of objects in a multi-node cluster." width="639" height="689" >}}


### Failure Tolerance

To be resilient, a cluster requires three working nodes. That's two nodes for a quorum and one node for failure tolerance.

If a node fails in a resilient cluster, NGINX Controller automatically redirects traffic to the other working nodes. A multi-node cluster is operational with only two nodes; however, a two-node cluster isn't resilient to further failures. If one of the nodes in a multi-node cluster becomes degraded or fails, you must take action **as soon as possible** to recover or replace the failed node or risk losing resiliency.

{{< important >}}The failover time can take **up to 5 minutes** when a node fails. During this time, NGINX Controller may be unavailable while services are migrated and restarted. Resiliency will be restored once there are **three working nodes** in the cluster.
{{< /important >}}

The following table shows how many nodes are needed for a cluster to have a quorum and what the failure tolerance is:

<style type="text/css">
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
table {
  width: 400px;
}
th {
  text-align: left;
}
</style>

| Cluster Size | Quorum | Failure Tolerance |
|--------------|--------|-------------------|
| 1            | 1      | 0                 |
| 2            | 2      | 0                 |
| 3            | 2      | 1                 |

Larger clusters aren't supported.

&nbsp;

---

## Before You Begin

### Implementation Considerations

{{< include "installer/multi-node/implementation-considerations-private-cloud.md" >}}

### Prerequisites

Things you'll need before installing NGINX Controller as a resilient cluster:

- Three hosts on which you can install NGINX Controller to create a cluster
- The `controller-installer-<version>.tar.gz` package, which you can get from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads). You need to upload and extract this tarball **on each host**.
- A license file for NGINX Controller
- A tool to send API requests, such as Postman or curl
- An external volume for the config database

  When installing NGINX Controller, you can choose to have NGINX Controller install and manage a self-hosted -- also known as "embedded" -- [PostgreSQL](https://www.postgresql.org/) database for you; this is the recommended implementation. Alternatively, you can [install your own PostgreSQL database for the config database]({{< relref "/admin-guides/install/install-nginx-controller.md#postgresql-optional" >}}), which you manage; this is sometimes referred to as an "external config database" because it is externally managed by you. Regardless of whether you use an embedded or an externally managed config database, the config database must be on an external volume for resilient clusters.

- An external volume for the analytics database

&nbsp;

---

## Install NGINX Controller

- Complete the steps in the [NGINX Controller Installation Guide]({{< relref "/admin-guides/install/install-nginx-controller.md" >}}) to install NGINX Controller on the first node.

&nbsp;

---

## License NGINX Controller

- Follow the steps to [license NGINX Controller]({{< relref "/platform/licensing-controller.md" >}}).

&nbsp;

---

## Add Nodes to the Cluster

{{< include "installer/multi-node/add-node.md" >}}

&nbsp;

---

## Set the Floating IP

{{< include "installer/multi-node/add-floating-ip.md" >}}

&nbsp;

---

## Update the FQDN

{{< include "cluster/update-fqdn-overview.md" >}}

&nbsp;

### Update the FQDN for NGINX Controller

{{< include "installer/multi-node/change-fqdn-controller.md" >}}

&nbsp;

### Update the FQDN for Controller Agents

{{< include "installer/multi-node/change-fqdn-agents.md" >}}

&nbsp;

---

## Update the API Gateway SSL Certificate

{{< include "installer/multi-node/update-apigw-cert.md" >}}

&nbsp;

---

## View Node Status

{{< include "installer/multi-node/view-node-status.md" >}}

&nbsp;

---

## Delete a Node

{{< include "installer/multi-node/delete-node.md" >}}

&nbsp;

---

## Replace a Failed Node

{{< include "installer/multi-node/replace-failed-node.md" >}}

&nbsp;

---

## Updating a Cluster

{{< include "installer/multi-node/update-cluster.md">}}

&nbsp;

{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}