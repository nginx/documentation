---
description: Learn how to set up the base infrastructure required to deploy NGINX
  Management Suite API Connectivity Manager in Amazon Web Services (AWS).
nd-docs: DOCS-896
title: Amazon Web Services Deployment Guide
toc: true
weight: 300
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

This guide walks you through the steps needed to set up the necessary infrastructure in Amazon Web Services (AWS) for a proof of concept environment for API Connectivity Manager. The options presented in this guide for creating AWS Instances keep cost in mind and prefer the minimum requirements for running a fully functional API Connectivity Manager environment.
Keep in mind that production environments may require larger instance sizes and incur greater costs.

### Before You Begin

- Make sure you have an AWS account.

{{< important >}}Because the [minimum requirement for the F5 NGINX Management Suite host]({{< ref "/nim/fundamentals/tech-specs#system-sizing" >}}) requires 2 CPU and 4GB RAM (NOT a free tier size), completing this deployment guide will incur charges from AWS according to their price plan.{{< /important >}}

### Hosts Specs

The AWS instance types and storage capacity used in this guide are based on the [NGINX Management Suite Technical Specs]({{< ref "/nim/fundamentals/tech-specs#system-sizing" >}}).

{{<bootstrap-table "table table-striped table-bordered">}}

| Hosts                           | AWS Instance Type | AWS Storage  |
|---------------------------------|-------------------|--------------|
| NGINX Management Suite Host     | t3.medium         |     100GB    |
| Data Plane Host                 | t2.micro          |     10GB     |
| Developer Portal Host           | t2.micro          |     10GB     |

{{</bootstrap-table>}}
Table 1.1 Host Sizing

## Provision AWS Instances

Complete the tasks in this section to set up the following resources in AWS:

1. [Virtual Private Cloud](https://docs.aws.amazon.com/vpc/)
1. [EC2 Instances](https://docs.aws.amazon.com/ec2/)

The instances you create by the end of this guide are:

1. NGINX Management Suite Host
1. Data Plane Host
1. Developer Portal Host

### Configure VPC

This section creates and configures the AWS Virtual Private Cloud (VPC) as described below. If your existing VPC is able to allow the following types of traffic, skip this section.

1. Be able to access the internet (for install)
1. Be able to establish an SSH connection from your workstation to the EC2 Instances
1. Have HTTPS traffic enabled
    - To allow NGINX Management Suite user interface and/or API access
    - Communication between Data Plane or Developer Portal host and NGINX Management Suite host
1. Have HTTP traffic enabled
    - To allow access to the Developer Portal from a workstation
    - To allow traffic for gateway proxy from a workstation

#### Create a New VPC

Take the steps below to create a new VPC:

1. Go to to the **VPC** Service.
1. Select **Create VPC**.
1. In the **VPC setting** section, provide the **Name** (optional) and **IPv4 CIDR**.
1. Select **Create VPC**.

#### Create a New Subnet

Take the steps below to create a new subnet:

1. On the left menu, select **Virtual private cloud > Subnets**.
1. Select **Create subnet**.
1. In the **VPC** section, select the newly created VPC from above.
1. In the **Subnet settings**, provide the **Subnet name** (optional) and **IPv4 CIDR block**.
1. Select **Create subnet**.

#### Create a New Internet Gateway

Take the steps below to create a new internet gateway:

1. On the left menu, select **Virtual private cloud > Internet Gateways**.
1. Select **Create internet gateway**.
1. On the main window of the newly created internet gateway, select **Actions > Attach to VPC**.
1. Select the VPC created from above.
1. Select **Attach internet gateway**.

{{< note >}}The Internet Gateway is what provides a public subnet internet access.{{< /note >}}

#### Create a New Route Table

Take the steps below to create a route table, add a route entry that defaults to the internet gateway created above, and associate a subnet with this route table:

1. On the left menu, select **Virtual private cloud > Route tables**.
1. Select **Create route table**.
1. Associate this route table to the VPC created from above.
1. Select **Create route table**.
1. Scroll down on the main window of the newly created route table then select **Edit routes**.
1. Select **Add route**.
    1. Provide `0.0.0.0/0` for the **Destination**.
    1. Select the **Internet Gateway** created from above.
    1. Select **Save changes**.
1. Scroll down on the main window on the same route table then select the **Subnet associations** tab.
1. Select **Edit subnet associations**.
1. Select the subnet created from above.
1. Select **Save changes**.

### Create EC2 Instances

At this point, the VPC created above is available when creating EC2 Instances.

Before creating the EC2 instances, create your **Key Pair** and **Security Groups** if they do not already exist. The reason why they are required is described below.
{{<bootstrap-table "table table-striped table-bordered">}}

| AWS Object           | Reason                                                                                     |
|----------------------|--------------------------------------------------------------------------------------------|
| Key Pair             | This is used to allow SSH connections in to EC2 Instances.                                 |
| Security Groups      | The security group needs to enable HTTP/S traffic and allow SSH traffic from your IP.      |

{{</bootstrap-table>}}
Table 1.2 Key Pair and Security Groups Reasoning

#### Create a Key Pair

Take the steps below to create a **Key Pair**.

1. Go to the **EC2** Service.
1. On the left menu, select **Network & Security > Key Pairs**.
1. You can either create a new Key Pair or import your own.
    - To create a new Key Pair:
        1. Select **Create key pair**.
        1. Provide the **Name**. **Key pair type**, and **Private key file format**.
    - To import your existing Key Pair:
        1. Select **Actions > Import key pair**.
        1. Provide the key pair **Name** and your public key content.

#### Create a Security Group

The table below summarizes the two security groups that you should create.

{{<bootstrap-table "table table-striped table-bordered">}}

| Security Group Name          | HTTP          | HTTPS          | SSH         |
|------------------------------|---------------|----------------|-------------|
| sg-controller                | NA            | Anywhere-IPv4  | My IP       |
| sg-data                      | Anywhere-IPv4 | Anywhere-IPv4  | My IP       |

{{</bootstrap-table>}}
Table 1.3 AWS Inbound Security Group Source

{{< warning >}}Selecting **Anywhere-IPv4** as the _Source_ for **HTTP** and **HTTPS** will cause the instances placed inside your Security Group to be publicly accessible. If this is not suitable for you or your organization, please ensure that appropriate restrictions are in place. {{< /warning >}}

{{< note >}}Select **My IP** as the _Source_ for **SSH** to prevent SSH connection attempts by anyone other than yourself.

If you are not allowed to do this, refer to the [Terminal Access Using Session Manager](#session-manager) section below.{{< /note >}}

<br>

Each host needs to be associated to a security group. The mapping of each host to the correct security group is shown below.
{{<bootstrap-table "table table-striped table-bordered">}}

| Host                         | Security Group |
|------------------------------|----------------|
| NGINX Management Suite Host  | sg-controller  |
| Data Plane Host              | sg-data        |
| Developer Portal Host        | sg-data        |

{{</bootstrap-table>}}
Table 1.4 Host to Security Group Mapping

<br>

Take the steps below to create a security group for access. Repeat these steps twice, once for **sg-controller** and once for **sg-data**.

1. Go to the **EC2** Service.
1. On the left menu, select **Network & Security > Security Groups**.
1. Select **Create security group**.
1. In the **Basic details** section, provide the **Security group name**, **Description**, and select the **VPC** created from above.
1. In the **Inbound rules** section, refer to each traffic **Type** that corresponds to the security group being created from Table 1.2 above.
1. The **Outbound rules** should already allow all traffic by default. If it isn't, modify the rules so that it allows all traffic.
1. Select **Create security group**.

#### Create EC2 Instance

Take the steps below to create an EC2 Instance. Repeat these steps three times, once for each host shown in [Table 1.1]({{< relref "./aws-deploy.md#hosts-specs" >}}).

1. Go to the **EC2** Service.
1. On the left menu, select **Instances > Instances**.
1. Select **Launch Instances**.
1. Provide the **Name** of your instance.
1. In the **Application and OS Images** section, select your [supported OS of choice]({{< ref "/nim/fundamentals/tech-specs#distributions" >}}).
1. Select your instance size in the **Instance Type** section. Refer to [Table 1.1]({{< relref "./aws-deploy.md#hosts-specs" >}}) for the suggested size of your host. Refer to [Technical Specifications]({{< ref "/nim/fundamentals/tech-specs#system-sizing" >}}) for additional information.
1. In the **Key pair (login)** section, select the key pair that was created above.
1. In the **Network settings** section, select the **Edit** button.
    - Provide your **VPC** and **Subnet** information.
    - Select **Enable** for **Auto-assign public IP**.
    - Select **Select existing security group**.
    - Provide the security group created above shown in Table 1.4 that corresponds to your host for **Common security groups**.
1. In the **Configure Storage** section, select the storage amount required by your host. Refer to [Table 1.1]({{< relref "./aws-deploy.md#hosts-specs" >}}) for guidance to determine the suggested size. GP2 storage is suitable. Refer to [Technical Specifications]({{< ref "/nim/fundamentals/tech-specs#system-sizing" >}}) for additional information.

#### Access EC2 Instance

Take the steps below to obtain the public IP so you can access the instance through an SSH connection.

1. Select **Instances > Instances** on the left menu.
1. Select your instance.
1. Select the **Details** tab.
1. The public IP address is shown in the **Public IPv4 address** section. This is the IP that allows external access (such as from your workstation) to the selected EC2 Instance.
   {{< note >}}It takes about a minute for the instance to become available for SSH connections.{{< /note >}}

## NGINX Management Suite Host Installation

Follow the [NGINX Management Suite Installation Guide]({{< ref "/nim/deploy/_index.md" >}}) to install both the **Instance Manager Module** and the **API Connectivity Manager Module**. The **Security Module** is not required for this demo.

## NGINX Data Plane host

Follow the steps in the [Set Up an API Gateway Environment]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}) guide to create an API Gateway and deploy it to your NGINX data plane host.

## NGINX Developer Portal host

Follow the steps in the [Set Up a Developer Portal Environment]({{< ref "/nms/acm/getting-started/add-devportal" >}}) guide to create a Developer Portal and deploy it to your NGINX Dev Portal host.

## Terminal Access Using Session Manager (Optional) {#session-manager}

AWS allows you to enable SSH traffic to a specific Source IP Address which is much safer than exposing it to everyone on the internet. Even though exposing it to one IP may be good enough, it might not be sufficient for your company policy. It is possible to completely disable SSH traffic yet still have terminal access to your EC2 Instances. There are different ways of doing this, and one way covered here is using [AWS System Manager Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html).

There are two methods of gaining terminal access via Session Manager:

1. AWS Management Console
2. AWS Command Line Interface Tool

Whichever method you decide, you need to take the following steps to properly configure your instances to allow connections from AWS Session Manager. Before continuing, ensure the [Session Manager Prerequisites](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-prerequisites.html) are met.

### IAM Role

You must create a new IAM Role that grants Session Manager access to EC2 Instances. This will be associated with the EC2 Instances needing terminal access. Take the instructions below to create an IAM Role for Session Manager.

1. Log in to your AWS Account on your web browser.
1. Go to the **IAM** service.
1. On the left menu, select **Access management > Roles**.
1. Select **Create role**.
1. In the **Trusted entity type** section, select **AWS service**.
1. In the **Use case** section, select **EC2**.
1. Select **Next**.
1. In the **Permissions policies** section, select **AmazonSSMManagedInstanceCore**. You can filter for this name in the filter box.
1. Select **Next**.
1. Provide the **Role name** and **Tag** (optional) for this IAM Role specifically allowing Session Manager access to EC2 Instances.
1. Select **Create role**.

{{< note >}}Creating an IAM Role from the AWS Management Console and choosing EC2 as the AWS Service also creates an AWS Instance Profile associated with EC2 Instances. Additional details can be found in [the AWS knowledge article](https://aws.amazon.com/premiumsupport/knowledge-center/attach-replace-ec2-instance-profile/).{{< /note >}}

### Associating IAM Instance Profile to EC2 Instance

When you associate an _IAM Role_ created from the IAM service to an EC2 Instance, you are really associating an _IAM Instance Profile_. Again, when you create an _IAM Role_ from AWS Management Console and choose EC2 as the AWS Service, it also creates an _IAM Instance Profile_. Take the steps in this section to associate an _IAM Instance Profile_ to an _EC2 Instance_.

There are two situations that can happen here:

1. Associating IAM Instance Profile to an existing instance
1. Associating an IAM Instance Profile to a new instance

#### Associating IAM Instance Profile to Existing Instance

Take the steps below to associate an IAM Instance Profile to an existing EC2 Instance:

1. Go to the **EC2** Service.
1. On the left menu, select **Instances > Instances**.
1. Right-click on the instance of interest.
1. Select **Security > Modify IAM role**.
1. Select the **IAM Instance Profile** from the list.

#### Associating IAM Instance Profile on New Instance

Associating an IAM Instance Profile to a new instance happens before the instance is created. The steps below assume you know how to get to the page where you provide information for the new instance you are about to create. You see this page after selecting **Launch instances** from **Instances > Instances** on the **EC2** Service.

1. In the **Advanced details** section, expand the entire section.
1. Select your IAM Instance Profile for **IAM instance profile**.

### Accessing EC2 Instance Terminal

You can access the terminal of your instance by either:

- AWS Management Console
- AWS Command Line Interface Tool

#### AWS Management Console

Take the steps below to get terminal access using **Session Manager**.

1. Go to the **System Manager** Service.
1. On the left menu, select **Node Management > Session Manager**.
1. Verify you are on the **Sessions** tab.
1. Select **Create session**.
1. In the **Target Instances** section, select the instance of interest.
1. Select **Start session**. This takes you to the terminal where you are logged in as `ssm-user`.
1. When you are done, select **Terminate** at the top.

{{< note >}} If you do not see your instance in the **Target Instances** section:

- Verify the IAM Instance Profile is associated to your instance.
- Verify the IAM Role has SSM permissions properly configured.
- The instance allows outbound HTTPS traffic to the endpoints shown in the **Connectivity to endpoints** row from the [Session Manager Prerequisites](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-prerequisites.html) page.
- Wait about 15 minutes if you attached the IAM Instance Profile to an existing instance.
{{< /note >}}

### AWS Command Line Interface Tool

Another way to get terminal access to instances is through AWS's CLI Tool.

Take the steps below to fulfill prerequisites for using Session Manager on the command line interface:

1. Install [AWS CLI Tool](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
1. You must also install the [Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html).
1. You need **AWS Access Key ID** and **AWS Secret Access Key**, which you can set up by referring to the [AWS CLI Prerequisite](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-prereqs.html) page.

Take the steps below to get terminal access on an instance:

1. Run `aws configure` to set up access to your AWS account.

    ```shell
    $ aws configure
    AWS Access Key ID []: ****************DLVT
    AWS Secret Access Key []: ****************666r
    Default region name []: <yourRegionName>
    Default output format []: json
    ```

    {{< note >}} If your AWS account is configured to use temporary credentials, you need to provide the `aws_session_token` by running the command below:

    aws configure set aws_session_token <sessionToken>{{< /note >}}

1. Run `aws ssm start-session --target "<instanceId>"` to start a session which provides terminal access.

    ```shell
    $ aws ssm start-session --target "<instanceId>"

    Starting session with SessionId: aaaaaaaa-0538f063ab275aeed
    $
    ```

1. To exit out of the session, type `exit` as if you were going to close a normal terminal screen.
