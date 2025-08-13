---
description: Guidelines and recommendations for configuring F5 NGINX Controller.
nd-docs: DOCS-256
title: NGINX Controller Tech Specs
toc: true
weight: 100
type:
- reference
---

## Overview

This guide lists the technical recommendations for F5 NGINX Controller v3 and NGINX Controller Agent. Review this guide before installing or updating NGINX Controller or NGINX Controller Agent.

## Supported Distributions

NGINX Controller, the NGINX Controller Agent, and the NGINX Controller Application Security Add-on support the following distributions and architectures.

{{< call-out "note" >}}Refer to the [NGINX Plus Technical Specifications](https://docs.nginx.com/nginx/technical-specs/) guide for the distributions that NGINX Plus supports.{{< /call-out>}}

{{< bootstrap-table "table table-striped table-bordered" >}}

|Distribution<br>and Version|NGINX Controller <br> (Control Plane)|Agent <br> (Data Plane)|ADC App. Sec.<br>(Data Plane)|APIM Adv. Sec.<br>(Data Plane)|Notes|
|--- |--- |--- |--- |--- |--- |
|Amazon Linux<br>2<br>(x86_64)| Not supported|v3.0+ |Not supported|Not supported| |
|Amazon Linux<br>2017.09+<br>(x86_64)| Not supported |v3.0+|Not supported |Not supported| |
|CentOS<br>6.5+<br>(x86_64)| Not supported |v3.0+| Not supported |Not supported| &#8226; CentOS 6.5 and later versions in the CentOS 6 family are partially supported. <br> &#8226; This distribution does not support <a href="#avrd">AVRD</a>.|
|CentOS<br>7.4+<br>(x86_64)|v3.0+|v3.0+ | v3.12+ |v3.19+| &#8226; CentOS 7.4 and later versions in the CentOS 7 family are supported.|
|Debian<br>8<br>(x86_64)| Not supported |v3.0–3.21|Not supported|Not supported|&#8226; This distribution does not support <a href="#avrd">AVRD</a>.|
|Debian<br>9<br>(x86_64)|v3.0+|v3.0–3.21 | v3.12+ |v3.19+ | |
|Debian<br>10<br>(x86_64)| Not supported |v3.17+ | v3.17+ |v3.19+| See the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/) for requirements for Debian 10. |
|Red Hat Enterprise Linux<br>6.5+| Not supported |v3.0+| Not supported | Not supported| &#8226; RHEL 6.5 and later versions in the RHEL 6 family are partially supported.|
|Red Hat Enterprise Linux<br>7.4+<br>(x86_64)|v3.5+|v3.5+ | v3.12+|v3.19+| &#8226; RHEL 7.4 and later versions in the RHEL 7 family are supported.<br>&#8226; SELinux may interfere with NGINX Controller installation and operation. If you do enable SELinux, it must use permissive mode. Use of enforcing mode is not supported. |
|Red Hat Enterprise Linux<br>8.0+<br>(x86_64)|v3.22+|v3.22+ | v3.22+| Not supported | &#8226; RHEL 8.0 and later versions in the RHEL 8 family are supported. <br>&#8226; SELinux may interfere with NGINX Controller installation and operation. If you do enable SELinux, it must use permissive mode. Use of enforcing mode is not supported. |
|Ubuntu<br>18.04 LTS<br>(x86_64)|v3.0+|v3.0+ |v3.13+|v3.19+| |
|Ubuntu<br>20.04 LTS<br>(x86_64)|v3.20+|v3.12+|v3.16.1+|v3.19+| |

{{< /bootstrap-table >}}


<a name="avrd"></a>

#### Analytics, Visibility, and Reporting Daemon (AVRD)

NGINX Controller v3.1 and later use an Analytics, Visibility, and Reporting daemon (AVRD) to aggregate and report app-centric metrics, which you can use to track and check the health of your apps. To learn more about these metrics, see the [NGINX Metrics Catalog]({{< ref "/controller/analytics/catalogs/metrics.md" >}}) topic.


&nbsp;

---

## Storage Requirements

The following table shows the minimum storage requirements we recommend for NGINX Controller. Your final storage requirements may differ depending on your environment, configuration, and the number of instances, apps, and APIs you're managing. Production deployments, for example, will require more storage than trial deployments. Contact your NGINX Controller sales associate if you have questions about sizing for your particular environment.

We recommend using a local volume for the analytics and config databases for trial deployments, for simplicity's sake so you can get started using NGINX Controller right away. For production environments, we recommend using an external volume for the databases for resiliency.

{{< bootstrap-table "table table-striped table-bordered" >}}

| Resource | Path(s) | Minimum Storage |
|-|-|-|
| NGINX&nbsp;Controller | <code style="white-space:nowrap;">/opt/nginx-controller</code> | 80&nbsp;GB |
| Analytics database |  <code style="white-space:nowrap;">/opt/nginx-controller/clickhouse_data</code>  | &#8226;&nbsp;50&nbsp;GB <br> &#8226;&nbsp;150&nbsp;GB if App Security is enabled |
| Config database | <code style="white-space:nowrap;">/opt/nginx-controller/postgres_data</code> | 10&nbsp;GB |
| Logs  | &#8226;&nbsp;<code style="white-space:nowrap;">/var/log/nginx-controller</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/log/journal</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/log/pods</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/lib/docker/containers</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/lib/kubelet</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/lib/kubernetes</code>| 15&nbsp;GB cumulative |

{{< /bootstrap-table >}}


&nbsp;

---

## Supported Deployment Environments

You can deploy NGINX Controller v3 into the following environments:

- Bare metal
- Public cloud: Amazon Web Services, Google Cloud Platform, Microsoft Azure
- Virtual Machine

&nbsp;

---

## NGINX Plus Instances

NGINX Controller, using the Controller Agent, can monitor and manage up to 100 [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) instances. When using Controller App Security, NGINX Controller can monitor and manage up to 30 NGINX Plus instances with NGINX App Protect installed.


NGINX Controller supports the following [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) versions:

{{< bootstrap-table "table table-striped table-bordered" >}}

| NGINX Plus | NGINX Controller | NGINX Controller ADC | NGINX Controller APIM |
|------------|------------------|----------------------|-----------------------|
| R30        | Not supported    | 3.22.9+              | Not supported         |
| R29        | Not supported    | 3.22.9+              | 3.19.6+               |
| R28        | Not supported    | 3.22.6+              | 3.19.6+               |
| R27        | Not supported    | 3.22.4+              | 3.19.6+               |
| R26        | Not supported    | 3.22.2+              | 3.19.6+               |
| R25        | Not supported    | 3.20.1+              | 3.19.2+               |
| R24        | 3.17+            | 3.20+                | 3.18+                 |
| R23        | 3.12+            | 3.20.0 - 3.22.2      | 3.18+                 |
| R22        | 3.5+             | 3.20.0 - 3.22.1      | 3.18+                 |
| R21        | 3.5 - 3.12       | Not supported        | Not supported         |
| R20        | 3.0 - 3.12       | Not supported        | Not supported         |
| R19        | 2.6 - 3.5        | Not supported        | Not supported         |

{{< /bootstrap-table >}}


&nbsp;

---

## NGINX App Protect Compatibility Matrix

The App Security add-on for the NGINX Controller Application Delivery module is compatible with the versions of NGINX Plus and NGINX App Protect shown in the table below. New releases of NGINX Controller ADC support the last four versions of NGINX Plus at release time.

{{< call-out "note" >}}
Refer to [Using NGINX App Protect with NGINX Controller]({{< ref "controller/admin-guides/install/install-for-controller.md" >}}) for installation instructions and additional information.
{{< /call-out>}}

{{< bootstrap-table "table table-striped table-bordered" >}}

| NGINX Controller version            | NGINX App Protect version(s)                                                                    | NGINX Plus version(s)          |
|-------------------------------------|-------------------------------------------------------------------------------------------------|--------------------------------|
| NGINX Controller ADC v3.22.9        | v4.5 <hr> v4.3, v4.4 <hr> v4.0, v4.1, v4.2 <hr> v3.12, v3.11 | R30 <hr> R29 <hr> R28 <hr> R27 |
| NGINX Controller ADC v3.22.8        | v4.0, v4.1 <hr> v3.12, v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6                 | R28 <hr> R27 <hr> R26 <hr> R25 |
| NGINX Controller ADC v3.22.7        | v4.0, v4.1 <hr> v3.12, v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6                 | R28 <hr> R27 <hr> R26 <hr> R25 |
| NGINX Controller ADC v3.22.6        | v4.0, v4.1 <hr> v3.12, v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6                 | R28 <hr> R27 <hr> R26 <hr> R25 |
| NGINX Controller ADC v3.22.5        | v3.12, v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2     | R27 <hr> R26 <hr> R25 <hr> R24 |
| NGINX Controller ADC v3.22.4        | v3.11 <hr> v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2            | R27 <hr> R26 <hr> R25 <hr> R24 |
| NGINX Controller ADC v3.22.3        | v3.10.0, v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 | R26 <hr> R25 <hr> R24 <hr> R23 |
| NGINX Controller ADC v3.22.2        | v3.9.1, v3.9.0 <hr> v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3          | R26 <hr> R25 <hr> R24 <hr> R23 |
| NGINX Controller ADC v3.22, v3.22.1 | v3.8, v3.7, v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                  | R25 <hr> R24 <hr> R23 <hr> R22 |
| NGINX Controller ADC v3.21          | v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                              | R25 <hr> R24 <hr> R23 <hr> R22 |
| NGINX Controller ADC v3.20.1        | v3.6 <hr> v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                              | R25 <hr> R24 <hr> R23 <hr> R22 |
| NGINX Controller ADC v3.20          | v3.5, v3.4, v3.3, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                                        | R24 <hr> R23 <hr> R22          |
| NGINX Controller APIM v3.19.2       | v3.6 <hr> v3.5, v3.4                                                                            | R25 <hr> R24                   |
| NGINX Controller APIM v3.19         | v3.5, v3.4                                                                                      | R24                            |
| NGINX Controller v3.18              | v3.5, v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                                                    | R24 <hr> R23 <hr> R22          |
| NGINX Controller v3.17              | v3.2 <hr> v3.1, v3.0, v2.3 <hr> v2.1.1                                                          | R24 <hr> R23 <hr> R22          |
| NGINX Controller v3.16              | v3.1, v3.0, v2.3 <hr> v2.1.1                                                                    | R23 <hr> R22                   |
| NGINX Controller v3.14, v3.15       | v3.0, v2.3 <hr> v2.1.1                                                                          | R23 <hr> R22                   |
| NGINX Controller v3.13              | v2.3 <hr> v2.1.1                                                                                | R23 <hr> R22                   |
| NGINX Controller v3.12              | v2.1.1                                                                                          | R22                            |

{{< /bootstrap-table >}}

---

## Supported Browsers

NGINX Controller works best with the newest and the last prior version of these browsers with JavaScript, cookies, and SSL enabled:

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Internet Explorer](https://support.microsoft.com/en-us/help/17621/internet-explorer-downloads) and [Microsoft Edge](https://www.microsoft.com/en-us/edge)

{{< call-out "important" >}}
You may need to turn off any ad blockers while using the NGINX Controller user interface.

In some cases, the NGINX Controller user interface may not display analytics or security events if an ad blocker is enabled. Refer to the AskF5 KB article [K48603454](https://support.f5.com/csp/article/K48903454) to learn more about this issue and how to resolve it.
{{< /call-out >}}


&nbsp;

---

## Hardware Specifications

The following minimum hardware specifications are required for each node running NGINX Controller:

- RAM: 8 GB RAM
- CPU: 8-Core CPU @ 2.40 GHz or similar
- Disk space: 155–255 GB free disk space. 255 GB of free space is recommended if NGINX Controller App Security is enabled. See the [Storage Requirements]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#storage-requirements" >}}) section for a categorized list of the storage requirements.

The NGINX Controller Agent consumes as little memory and CPU as possible. CPU usage should be under 10%, and RSS memory consumption should be just a few dozen MBs. If you notice the NGINX Controller Agent consuming resources at a higher rate, you should [contact NGINX Support]({{< ref "/controller/support/contact-support.md" >}}) for assistance.

&nbsp;

---

## NGINX Controller Database Requirements

When installing NGINX Controller, you can choose the type of volume to use for the analytics and config databases. The types of volumes that are supported are:

- [Local Storage](#local-storage)
- [NFS](#nfs)
- [AWS EBS](#aws-ebs)

We recommend using a local volume for the analytics and config databases for trial deployments, for simplicity's sake so you can get started using NGINX Controller right away. For production environments, we recommend using an external volume for the databases for resiliency.

&nbsp;

### Local Storage

When using local storage for the analytics and/or config database, we recommend the following specs:

- 100 IOPS
- 155–255 GB free disk space. 255 GB of free space is recommended if NGINX Controller App Security is enabled. See the [Storage Requirements]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#storage-requirements" >}}) section for a categorized list of the storage requirements.

{{< call-out "tip" >}}
To conserve IO and/or disk space, you can use a separate disk for the local storage directory `/opt/nginx-controller/clickhouse_data`.
{{< /call-out >}}

&nbsp;

### NFS

To use NFS for external storage for the analytics and/or config database, consider the following:

- Make certain that the NFS version used by the server is supported by the client system where you're installing NGINX Controller.
- If you're using NFS v4 file locking or Network Lock Manager (NLM) on the NFS server, make sure that the client system that's running your NGINX Controller has access to the mount point.
- Install the `nfs-common` (on Ubuntu/Debian) or `nfs-utils` (on CentOS/RedHat) package on all hosts on which NGINX Controller will be installed.
- The `no_root_squash` option must be set for the mount point on the NFS server. If this is not allowed, the owner of the path used for the analytics database must be set to `101:101` and owner of the path for config database must be set to `70:70`.
- The config database should support a throughput of 2 MiB/s or greater.

&nbsp;

### AWS EBS

{{< call-out "important" >}}
If you plan to run NGINX Controller on AWS EC2 instances, we recommend using NFS shares for the external volumes. Using EBS shares for multi-node clusters is not recommended because of the [EBS Availability Zone limitations](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volumes-multi.html#considerations); for example, the requirement to have EC2 instances and EBS volumes in the same Availability Zone.
{{< /call-out >}}

If you are installing NGINX Controller on [AWS EC2 instances](https://aws.amazon.com/ec2/getting-started/) and plan to use EBS volumes for the analytics and/or config database, consider the following:

You will need add an IAM role like that shown below.

- IAM Role for [Single-Node Installation]({{< ref "/controller/admin-guides/install/install-nginx-controller.md" >}})

  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DescribeVpcs",
          "iam:CreateServiceLinkedRole",
          "kms:DescribeKey"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  }
  ```

- IAM Role for [Multi-Node Installation]({{< ref "/controller/admin-guides/install/resilient-cluster-aws.md" >}})

  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DescribeVpcs",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:AttachLoadBalancerToSubnets",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancerListeners",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DetachLoadBalancerFromSubnets",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
          "iam:CreateServiceLinkedRole",
          "kms:DescribeKey"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  }
  ```

&nbsp;

---

## Supported PostgreSQL Versions

NGINX Controller supports the following versions of PostgreSQL:

- PostgreSQL 12.x -- works with NGINX Controller 3.9 and later.
- PostgreSQL 9.5 -- works with NGINX Controller 3.0 and later.

For a system monitoring **100 NGINX Plus instances**, we recommend at least **32 GB of database storage**. Database storage requirements can vary, depending on the number of NGINX Plus instances, components, published API specs, and the churn rate for configuration changes. For monitor-only implementations, the database storage needs are small; for API Management (APIM) and/or App Delivery Controller (ADC) implementations in production, the storage needs are greater.

{{< call-out "important" >}}
If you use PostgreSQL 12, we recommend disabling [Just-in-Time (JIT)](https://www.postgresql.org/docs/12/jit.html) compilation to improve NGINX Controller's performance. To disable JIT, edit the `postgresql.conf` file and set `jit=off`.
{{< /call-out >}}


&nbsp;

---

## Firewall/IP Settings

Configure NGINX Controller with the following firewall settings:

{{< bootstrap-table "table table-striped table-bordered" >}}

|Port| Used by | Used for|
|---|---|---|
| 5432 TCP | NGINX Controller database | Incoming connections to the NGINX Controller database from the NGINX Controller host. This is the default PostgreSQL port. |
| 443 TCP | &bull; NGINX Controller <br/> &bull; NGINX Controller licensing | &bull; Incoming connections to NGINX Controller from a browser; for example, from an internal network and NGINX Plus instances <br/> &bull; Incoming and outgoing connections used to used to validate the entitlements for your NGINX Controller license |
| 8443 TCP | NGINX Controller | Incoming connections from NGINX Plus instances <br>You need to **open** port 8443 TCP if you're running **NGINX Controller v3.18.2 or earlier**|
| 8883 TCP | NGINX Controller licensing | Incoming and outgoing connections used to validate the entitlements for your NGINX Controller license <br> Port 8883 TCP needs to be **opened** only if you're running **NGINX Controller v3.15 or earlier**|

{{< /bootstrap-table >}}

If you have a firewall running on the NGINX Controller host, enable NAT (masquerade) and open the following ports. These ports are used for **internal traffic** only and don't need to be open to the outside:

{{< bootstrap-table "table table-striped table-bordered" >}}

|Port| Used by | Used for|
|---|---|---|
|2379 TCP</br>2380 TCP<br/>6443 TCP|NGINX Controller|Incoming requests to the Kubernetes control plane; used for the Kubernetes API server and etcd|
|10250 TCP|NGINX Controller|Incoming requests to the Kubernetes worker node; used for the Kubelet API|
|10251 TCP|NGINX Controller|Incoming requests to the Kubernetes kube-scheduler; used for the pod scheduling|
|10252 TCP|NGINX Controller|Incoming requests to the Kubernetes kube-controller-manager; used for regulating the state of the system|
|8472 UDP|NGINX Controller|Used for pod-to-pod communication in multi-node resilient clusters|

{{< /bootstrap-table >}}

For more information about these ports, see the Kubernetes guide [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports).


&nbsp;

---

## Supported Python Versions

NGINX Controller and the NGINX Controller Agent versions 3.6 and earlier require Python 2.6 or 2.7. Python is not needed for NGINX Controller or the NGINX Controller Agent versions 3.7 and later.

&nbsp;

---

## Open-Source Licenses

The list of open-source packages and their licenses used by NGINX Controller can be found in the downloaded file that is part of the NGINX Controller package. On your NGINX Controller host, see `controller-installer/files/license-controller.md`.

In addition, see the AskF5 KB article [Third-party software for NGINX Controller controller-datacollection-components](https://support.f5.com/csp/article/K30028643) for third-party software packages that may be used by or distributed with controller-datacollection-components. This information is not included in the `license-controller.md` that's mentioned above.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
