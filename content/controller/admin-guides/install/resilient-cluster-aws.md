---
authors: []
categories:
- installation
date: "2020-10-21T14:43:55-07:00"
description: This guide explains how to deploy NGINX Controller as a multi-node resilient
  cluster on AWS.
docs: DOCS-257
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
title: Deploy NGINX Controller as a Resilient Cluster on AWS
toc: true
weight: 310
---

## Overview

Complete the steps in this guide to deploy NGINX Controller as a resilient, three-node cluster on AWS. A multi-node cluster ensures that NGINX Controller stays up even if one of the control-plane hosts becomes unavailable.

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

Before installing or configuring NGINX Controller as a multi-node cluster, review the following list of considerations to assist with planning:

- Configuring NGINX Controller as a multi-node cluster on AWS requires **NGINX Controller 3.14 or later**. To upgrade from an earlier version, refer to the [Update NGINX Controller]({{< relref "admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}) steps for instructions.
- Data migration is not supported, so it's not possible to implement a multi-node cluster with local volumes without reinstalling NGINX Controller.
- If you plan to run NGINX Controller on AWS EC2 instances, we recommend using NFS shares for the external volumes. Using EBS shares for multi-node clusters is not recommended because of the [EBS Availability Zone limitations](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volumes-multi.html#considerations); for example, the requirement to have EC2 instances and EBS volumes in the same Availability Zone.
- Cluster config changes are orchestrated by a primary control plane node that writes to the external config database. Each NGINX Controller control plane node hosts a set of services (pods) that read and write data. Only the node that hosts the pod that manages the config data writes to the external config database.




&nbsp;

---

### Prerequisites

{{< important >}}If you plan to run NGINX Controller on AWS EC2 instances, we recommend you use NFS shares for the external volumes. Using EBS shares for multi-node clusters is not recommended because of the [EBS Availability Zone limitations](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volumes-multi.html#considerations).{{< /important >}}

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

## Configure IAM Roles

{{< important >}}If you plan to run NGINX Controller on AWS EC2 instances, we recommend using NFS shares for the external volumes. Using EBS shares for multi-node clusters is not recommended because of the [EBS Availability Zone limitations](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volumes-multi.html#considerations); for example, the requirement to have EC2 instances and EBS volumes in the same Availability Zone.{{< /important >}}

If you are installing NGINX Controller on [AWS EC2 instances](https://aws.amazon.com/ec2/getting-started/) and plan to use EBS volumes for the analytics and/or config database, you will need to add an IAM role like the one shown below. This will also allow the automatic creation of Elastic Load Balancers (ELBs). Additionally, for successful automatic creation of ELBs, all the EC2 instances that are or will be part of the cluster must be tagged with the following key-value pair:
  `kubernetes.io/cluster/NGINX-CONTROLLER : owned`

{{< include "installer/tech-specs/nginx-controller/aws-iam-policy-multi-node.md" >}}

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

## Add Load Balancer Alias to FQDN

{{< include "installer/multi-node/aws-add-lb-alias-to-fqdn.md" >}}

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

{{< versions "3.14" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}