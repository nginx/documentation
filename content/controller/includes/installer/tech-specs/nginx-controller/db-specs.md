When installing NGINX Controller, you can choose the type of volume to use for the analytics and config databases. The types of volumes that are supported are:

- [Local Storage](#local-storage)
- [NFS](#nfs)
- [AWS EBS](#aws-ebs)

We recommend using a local volume for the analytics and config databases for trial deployments, for simplicity's sake so you can get started using NGINX Controller right away. For production environments, we recommend using an external volume for the databases for resiliency.

&nbsp;

#### Local Storage

When using local storage for the analytics and/or config database, we recommend the following specs:

- 100 IOPS
- 155–255 GB free disk space. 255 GB of free space is recommended if NGINX Controller App Security is enabled. See the [Storage Requirements]({{< relref "admin-guides/install/nginx-controller-tech-specs.md#storage-requirements" >}}) section for a categorized list of the storage requirements.

{{< tip >}}
To conserve IO and/or disk space, you can use a separate disk for the local storage directory `/opt/nginx-controller/clickhouse_data`.
{{< /tip >}}

&nbsp;

#### NFS

To use NFS for external storage for the analytics and/or config database, consider the following:

- Make certain that the NFS version used by the server is supported by the client system where you're installing NGINX Controller.
- If you're using NFS v4 file locking or Network Lock Manager (NLM) on the NFS server, make sure that the client system that's running your NGINX Controller has access to the mount point.
- Install the `nfs-common` (on Ubuntu/Debian) or `nfs-utils` (on CentOS/RedHat) package on all hosts on which NGINX Controller will be installed.
- The `no_root_squash` option must be set for the mount point on the NFS server. If this is not allowed, the owner of the path used for the analytics database must be set to `101:101` and owner of the path for config database must be set to `70:70`.
- The config database should support a throughput of 2 MiB/s or greater.

&nbsp;

#### AWS EBS

{{< important >}}
If you plan to run NGINX Controller on AWS EC2 instances, we recommend using NFS shares for the external volumes. Using EBS shares for multi-node clusters is not recommended because of the [EBS Availability Zone limitations](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volumes-multi.html#considerations); for example, the requirement to have EC2 instances and EBS volumes in the same Availability Zone.
{{< /important >}}

If you are installing NGINX Controller on [AWS EC2 instances](https://aws.amazon.com/ec2/getting-started/) and plan to use EBS volumes for the analytics and/or config database, consider the following:

You will need add an IAM role like that shown below.

- IAM Role for [Single-Node Installation]({{< relref "admin-guides/install/install-nginx-controller.md" >}})

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

- IAM Role for [Multi-Node Installation]({{< relref "admin-guides/install/resilient-cluster-aws.md" >}})

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

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-316 -->