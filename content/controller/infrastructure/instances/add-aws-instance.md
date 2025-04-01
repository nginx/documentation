---
description: Learn how to deploy an AWS F5 NGINX instance using NGINX Controller.
docs: DOCS-768
title: Add an AWS NGINX Instance
toc: true
weight: 30
type:
- tutorial
---

## Overview



You can use F5 NGINX Controller to deploy and manage NGINX instances on Amazon Web Services (AWS).

This tutorial explains how to deploy NGINX Plus on AWS by defining an AWS Integration, a Location, and an Instance Template in NGINX Controller.

{{< important >}}

You are responsible for applying software and security updates on your data plane Instances. NGINX Controller does not manage these updates for you.

{{< /important >}}

&nbsp;


---

## Create an AWS Integration



Integrations give NGINX Controller permission to deploy and manage NGINX instances on external systems, such as cloud providers like AWS.

### Prerequisites

To create an Integration for AWS, you need to [configure an AWS IAM user](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#iam-user-name-and-password) with the following roles:

```json
"ec2:*Instance*",
"ec2:*Tags*"
```

In addition, you'll need to copy and save the following [AWS security credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) to use when creating an AWS Integration:

- access key ID
- secret access key ID

### Steps

To create an AWS Integration, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Integrations**.
1. On the **Integrations** menu, select the **Create Integration** quick action.
1. Add a name.
1. (Optional) Add a display name.
1. (Optional) Add a description.
1. (Optional) Add tags.
1. In the **Integration Type** list, select `AWS_INTEGRATION`.
1. (Optional) Add the service endpoint URI.
1. In the **Credential Type** list, select `AWS_ACCESS_KEY`.
1. Add the [access key ID](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html).
1. Add the [secret access key ID](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html).
1. Select **Submit**.

&nbsp;


---

## Create a Location

After you've [created an Integration for AWS](#create-an-aws-integration), the next step is to create a Location. Locations are a way to logically group your NGINX Plus instances by their physical locations.

To create a Location, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure Menu**, select **Locations**.
1. Select **Create**.
1. Add a name for the Location.
1. (Optional) Add a display name.
1. In the **Type** list, select `AWS_LOCATION`.
1. In the **Integration References** list, select the AWS Integration(s) to associate with the Location.
1. Add the [AWS VPC ID](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html).
1. Add the [AWS region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html).
1. (Optional) Add a description.
1. (Optional) Add tags.
1. (Optional) Add a description.
1. (Optional) Add tags.
1. Select **Submit**.

&nbsp;


---

## Create an Instance Template for AWS NGINX Instances

An [Instance Template]({{< ref "/controller/infrastructure/instances/manage-instance-templates.md" >}}) defines the parameters to use when creating an NGINX instance. Instance templates are ideal for cloud orchestration and make managing your cloud resources easy and quick.

### Prerequisites

To create an Instance Template for AWS NGINX instances, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure** > **Instance Templates**.
1. Select **Create Instance Template**.
1. Add a name.
1. (Optional) Add a display name.
1. (Optional) Add a description.
1. (Optional) Add tags.
1. Select a Location in the list, or select **Create New** to [create a Location]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}}).
1. In the Type list, select `AWS_INSTANCE_TEMPLATE`.
1. Add the [Amazon Machine Image ID](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html).
1. Add the [EC2 Instance Type](https://aws.amazon.com/ec2/instance-types/).
1. Add the [Subnet ID](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html).
1. (Optional) Add the [Security Group IDs](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).
1. (Optional) Add the [AWS Public Key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).
1. Specify whether a public IP address should be assigned to the instance.
1. Select **Submit**.

{{< note >}}
Enabling WAF via the App Security add-on is not supported when deploying Instances with an Instance Template.
{{< /note >}}

### Steps

To create an Instance Template for AWS NGINX instances, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure** > **Instance Templates**.
1. Select **Create Instance Template**.
1. Add a name.
1. (Optional) Add a display name.
1. (Optional) Add a description.
1. (Optional) Add tags.
1. Select a Location in the list, or select **Create New** to [create a Location]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}}).
1. In the Type list, select `AWS_INSTANCE_TEMPLATE`.
1. Add the [Amazon Machine Image ID](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html).
1. Add the [EC2 Instance Type](https://aws.amazon.com/ec2/instance-types/).
1. Add the [Subnet ID](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html).
1. (Optional) Add the [Security Group IDs](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).
1. (Optional) Add the [AWS Public Key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).
1. Specify whether a public IP address should be assigned to the instance.
1. Select **Submit**.

{{< note >}}

Enabling WAF via the App Security add-on is not supported when deploying Instances with an Instance Template.

{{< /note >}}

&nbsp;


---

## Add an AWS NGINX Instance to NGINX Controller

Now that you've [defined a Location](#create-a-location) and [made an Instance Template](#create-an-instance-template-for-aws-nginx-instances) for an  NGINX instance on AWS, you're ready to add the instance to  NGINX Controller.

To add an AWS Instance to NGINX Controller, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances**.
1. On the **Instances** overview page, select **Create**.
1. Select **Create a new instance using a template**.
1. Add a name.
1. Select a **Location**.
1. Select an **Instance Template**.
1. Select **Submit**.

&nbsp;


---

## Troubleshooting

When deploying an NGINX Plus instance, the deployment may fail because the Controller Agent install script doesn't download. When this happens, an error similar to the following is logged to `/var/log/agent_install.log`: "Failed to download the install script for the agent."

Take the following steps to troubleshoot the issue:

- Ensure that ports 443 and 8443 are open between NGINX Controller and the network where the NGINX Plus instance is being deployed.
- Verify that you can communicate with NGINX Controller from the NGINX Plus instance using the NGINX Controller FQDN that you provided when you installed NGINX Controller.
- If you're [deploying an NGINX Plus instance on Amazon Web Services]({{< ref "/controller/infrastructure/instances/add-aws-instance.md" >}}) using a template, ensure that the Amazon Machine Image (AMI) referenced in the `instance_template` has a cURL version of 7.32 or newer.

&nbsp;


---

## What's Next

- [Manage Your NGINX Instances]({{< ref "/controller/infrastructure/instances/manage-instances.md#add-an-existing-instance" >}})
- [Add, Edit, and Update Locations]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}})
- [View Performance Reports for Your Instances]({{< ref "/controller/infrastructure/instances/analyzer.md" >}})
- [Deploy an App]({{< ref "/controller/app-delivery/deploy-simple-app.md" >}})

{{< versions "3.6" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
