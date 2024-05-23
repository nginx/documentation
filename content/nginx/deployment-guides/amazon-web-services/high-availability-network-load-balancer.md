---
description: Create a highly available active-active deployment of NGINX Plus on AWS
  in combination with AWS Network Load Balancer (NLB).
docs: DOCS-446
doctypes:
- task
title: Active-Active HA for NGINX Plus on AWS Using AWS Network Load Balancer
toc: true
weight: 100
---

This guide explains how to create our recommended solution for a highly available, active‑active deployment of NGINX Plus in the Amazon Web Services (AWS) cloud. The solution combines the AWS Network Load Balancer (NLB) for fast and efficient handling of Layer 4 traffic with NGINX Plus for advanced, Layer 7 features such as load balancing, caching, and content‑based routing. The combined solution is fast, powerful, reliable, and likely to be relatively low‑cost.

This guide explains how to set up an AWS NLB in front of one pair of NGINX Plus load balancers. (You can increase resiliency as needed by following the same steps for additional NGINX Plus instances.)

The [Appendix](#appendix) provides instructions for creating EC2 instances with the names used in this guide, and installing and configuring the NGINX software on them.

<span id="about-nlb"></span>
## About AWS NLB

AWS NLB is optimized for fast, efficient load balancing at the connection level (Layer 4). AWS NLB uses a [flow hash routing algorithm](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html#routing-algorithm).

AWS NLB is ideal for fast load balancing of TCP traffic, as it's able to handle millions of requests per second while maintaining ultra‑low latencies. This enables AWS NLB to more easily handle volatile traffic patterns – patterns with sudden and dramatic changes in the amount of traffic.

Unlike previous AWS solutions, AWS NLB supports both static IP addresses and [Elastic IP addresses](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html).

<span id="about-nginx"></span>
## About NGINX Plus

NGINX Plus is complementary to NLB. Operating at Layer 7 (the application layer), it uses more advanced load‑balancing criteria, including schemes that rely on the content of requests and the results of NGINX Plus' [active health checks]({{< relref "../../admin-guide/load-balancer/http-health-check.md" >}}).

[NGINX Plus](http://www.nginx.com/products/nginx) is the commercially supported version of the [NGINX Open Source](http://nginx.org/en) software. NGINX Plus is a complete application delivery platform, extending the power of NGINX with a host of enterprise‑ready capabilities that enhance an AWS web application deployment and are instrumental to building web applications at scale.

NGINX Plus provides both reverse‑proxy features and load‑balancing features, including:

- [Full‑featured HTTP, TCP, and UDP load balancing](https://www.nginx.com/products/nginx/load-balancing/)
- [Intelligent session persistence](https://www.nginx.com/products/nginx/load-balancing/#session-persistence)
- [High‑performance reverse proxy]({{< relref "../../admin-guide/web-server/reverse-proxy.md" >}})
- [Caching and offload of dynamic and static content]({{< relref "../../admin-guide/content-cache/content-caching.md" >}})
- [Adaptive streaming to deliver audio and video to any device](https://www.nginx.com/products/nginx/streaming-media/)
- [Application-aware health checks](https://www.nginx.com/products/nginx/load-balancing/#health-checks) and [high availability](https://www.nginx.com/products/nginx/high-availability/)
- [Advanced activity monitoring available via a dashboard or API](https://www.nginx.com/products/nginx/live-activity-monitoring/)
- [Management and real‑time configuration changes with DevOps‑friendly tools](https://www.nginx.com/products/nginx/load-balancing/#load-balancing-api)

<span id="overview"></span>
## Solution Overview

The setup in this guide combines AWS NLB, AWS target groups, Amazon Elastic Compute Cloud (EC2) instances running NGINX Plus, and EC2 instances running NGINX Open Source, which together provide a highly available, all‑active NGINX and NGINX Plus solution.

<img src="/nginx/images/nginx-plus-ha-aws-nlb.png" alt="" width="1024" height="577" class="aligncenter size-full wp-image-54857" style="border:2px solid #666666; padding:2px; margin:2px;" />

AWS NLB handles Layer 4 TCP connections and balances traffic using a flow hash routing algorithm. By default, an AWS NLB has a DNS name to which an IP address is assigned dynamically, but you can optionally attach an Elastic IP address to the AWS NLB to ensure that it will always be reachable at the same IP address.

The AWS NLB listens for incoming connections as defined by its listeners. Each listener forwards a new connection to one of the available instances in a target group, chosen using the flow hash routing algorithm.

In this guide, the target group consists of two NGINX Plus load balancer instances. However, you can register an unlimited number of instances in the target group, or use an [AWS Auto Scaling group](https://aws.amazon.com/autoscaling/) to dynamically adjust the number of NGINX Plus instances.

<span id="prereqs"></span>
## Prerequisites

These instructions assume you have the following:

- [An AWS account](http://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/AboutAWSAccounts.html).
- Six EC2 instances, four running NGINX Open Source and two running NGINX Plus. You need a subscription for each NGINX Plus instance, either paid or a [30‑day free trial](https://www.nginx.com/free-trial-request).

  The [Appendix](#appendix) provides instructions for creating instances with the expected names, and installing and configuring the NGINX software.

- Familiarity with NGINX and NGINX Plus configuration syntax. Complete configuration snippets are provided, but not analyzed in detail.


<span id="nlb-configure"></span>
## Configuring an AWS Network Load Balancer

With NGINX Open Source and NGINX Plus installed and configured on the EC2 instances (see the [Appendix](#appendix)), we’re ready to configure an AWS NLB for a highly available, all‑active NGINX Plus setup.

- [Allocating an Elastic IP Address](#nlb-eip)
- [Creating an AWS NLB](#nlb-create)
- [Configuring the AWS NLB Routing Options](#nlb-routing-options)
- [Registering Instances in the Target Group](#nlb-register-instances)
- [Launching the AWS NLB](#nlb-launch)

<span id="nlb-eip"></span>
### Allocating an Elastic IP Address

The first step is to allocate an Elastic IP address, which becomes the fixed IP address for your AWS NLB. (While using an Elastic IP address is optional, we strongly recommend that you do so. With a dynamic IP address, the AWS NLB might not remain reachable if you reconfigure or restart it.)

1. Log in to the [AWS Management Console](https://console.aws.amazon.com/ec2/) for EC2 (**<https://console.aws.amazon.com/ec2/>**).

2. In the left navigation bar, select **Elastic IPs**, then click either of the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Allocate new address </span> buttons.

    <a href="/nginx/images/aws-nlb-eip-open.png"><img src="/nginx/images/aws-nlb-eip-open.png" alt="" width="1024" height="466" class="aligncenter size-full wp-image-54932" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. In the **Allocate new address** window that opens, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Allocate </span> button.

   <a href="/nginx/images/aws-nlb-eip-allocate-new.png"><img src="/nginx/images/aws-nlb-eip-allocate-new.png" alt="" width="1024" height="285" class="aligncenter size-full wp-image-54853" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. When the message appears indicating that the request for an Elastic IP address succeeded, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Close </span> button.

   <a href="/nginx/images/aws-nlb-eip-new-success.png"><img src="/nginx/images/aws-nlb-eip-new-success.png" alt="" width="1024" height="406" class="aligncenter size-full wp-image-54852" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

The new Elastic IP address appears on the **Elastic IPs** dashboard.

<a href="/nginx/images/aws-nlb-eip-new-display.png"><img src="/nginx/images/aws-nlb-eip-new-display.png" alt="" width="1019" height="450" class="aligncenter size-full wp-image-54851" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

<span id="nlb-create"></span>
### Creating the AWS NLB

1. In the left navigation bar, select **Load Balancers**, then click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create Load Balancer </span> button.

   <a href="/nginx/images/aws-nlb-load-balancer-open.png"><img src="/nginx/images/aws-nlb-load-balancer-open.png" alt="" width="1025" height="438" class="aligncenter size-full wp-image-54850" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

2. In the **Select load balancer type** window that opens, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create </span> button in the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Network Load Balancer </span> panel (the center one).

   <a href="/nginx/images/aws-nlb-load-balancer-types.png"><img src="/nginx/images/aws-nlb-load-balancer-types.png" alt="" width="1024" height="330" class="aligncenter size-full wp-image-54849" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. In the **Step 1: Configure Load Balancer** window that opens, enter the following values:
   - In the **Basic Configuration** section:
        - **Name** – Name of your AWS NLB (<span style="color:#666666; font-weight:bolder">aws-nlb-lb</span> in this guide).
        - **Scheme** – <span style="color:#666666; font-weight:bolder">internet-facing</span>.
   - In the **Listeners** section:
        - **Load Balancer Protocol** – <span style="color:#666666; font-weight:bolder">TCP</span> (the only available option).
        - **Load Balancer Port** – Port on which your AWS NLB listens for incoming connections. In this guide, and for most web applications, it is port <span style="color:#666666; font-weight:bolder">80</span>.
   - In the **Availability Zones** section, the zones that host the EC2 instances to which your AWS NLB routes traffic. Click the radio button in the leftmost column of the appropriate row:
        - If you set up your instances with the instructions in [Creating Amazon EC2 Instances for NGINX Open Source and NGINX Plus]({{< relref "ec2-instances-for-nginx.md" >}}), select the default subnet within the default [Amazon Virtual Private Cloud](https://aws.amazon.com/vpc/) (VPC) to target a single availability zone.
        - If you set up your instances using our scripts for [Packer and Terraform](#create-instances-automated), use the <span style="white-space: nowrap; font-weight:bold;">aws-nlb-subnet</span> within the <span style="white-space: nowrap; font-weight:bold;">aws-nlb-vpc</span> VPC to target a single availability zone.

   <a href="/nginx/images/aws-nlb-load-balancer-configure.png"><img src="/nginx/images/aws-nlb-load-balancer-configure.png" alt="" width="1024" height="921" class="aligncenter size-full wp-image-54848" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. When you select an availability zone in the table, a drop‑down menu appears in the **Elastic IP** column. Select the address you allocated in [Allocating an Elastic IP Address](#nlb-eip).

5. Click the <span style="background-color:#cccccc; font-weight:bolder; white-space: nowrap;"> Next: Configure Routing </span> button in the lower‑right corner of the window.

<span id="nlb-routing-options"></span>
### Configuring the AWS NLB Routing Options

In the **Step 2: Configure Routing** window that opens, you create a _target group_, which contains the set of EC2 instances across which your AWS NLB load balances traffic (you'll specify those instances in [Registering Instances in the Target Group](#nlb-register-instances)).

1. In the **Target group** section, select or enter the following values:

    - **Target group** – <span style="color:#666666; font-weight:bolder">New target group</span>
    - **Name** – Name of the target group (for this guide, <span style="color:#666666; font-weight:bolder">aws-nlb-tg</span>)
    - **Protocol** – <span style="color:#666666; font-weight:bolder">TCP</span> (the only available option)
    - **Port** – The port you specified for the **Load Balancer Port** field in Step 3 of the [previous section](#nlb-create) (<span style="color:#666666; font-weight:bolder">80</span> in this guide)
    - **Target type** – <span style="color:#666666; font-weight:bolder">instance</span>

2. In the **Health checks** section, open the **Advanced health check settings** subsection and enter the following values:

    - **Protocol** – Protocol the AWS NLB uses when sending health checks. This guide uses <span style="color:#666666; font-weight:bolder">TCP</span>, which means the AWS NLB makes a health check by attempting to open a TCP connection on the port specified in the next field.
    - **Port** – Port on the target instances to which the AWS NLB sends health checks. In this guide, we're selecting <span style="color:#666666; font-weight:bolder">traffic port</span> to send health checks to the same port as regular traffic.
    - **Healthy threshold** – Number of consecutive health checks an unhealthy instance must pass to be considered healthy.
    - **Unhealthy threshold** – Number of consecutive health checks a healthy instance must fail to be considered unhealthy.
    - **Timeout** – Number of seconds the AWS NLB waits for a response to the health check before considering the instance unhealthy.
    - **Interval** – Number of seconds between health checks.

   <a href="/nginx/images/aws-nlb-load-balancer-routing.png"><img src="/nginx/images/aws-nlb-load-balancer-routing.png" alt="" width="1024" height="840" class="aligncenter size-full wp-image-54847" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   If you want to use HTTP‑based health checks, select <span style="color:#666666; font-weight:bolder">HTTP</span> or <span style="color:#666666; font-weight:bolder">HTTPS</span> in the **Protocol** field instead of <span style="color:#666666; font-weight:bolder">TCP</span>. Two additional fields open (not shown in the screenshot):

    - **Path** – The path to which the AWS NLB sends a `GET` request as the health check.

    - **Success codes** – Range of HTTP response codes the AWS NLB accepts as indicating a successful health check.

3. Click the <span style="background-color:#cccccc; font-weight:bolder; white-space: nowrap;"> Next: Register Targets </span> button in the lower‑right corner of the window.

<span id="nlb-register-instances"></span>
### Registering Instances in the Target Group

In the **Step 3: Register Targets** window that opens, you add instances to the empty target group you created in the previous section. For this guide, we add both of our NGINX Plus load balancer instances.

1. In the **Instances** table, click the radio button in the left‑most column for the two NGINX Plus load balancer instances, <span style="color:#666666; font-weight:bolder">ngx-plus-1</span> and <span style="color:#666666; font-weight:bolder">nginx-plus-2</span>.

   <a href="/nginx/images/aws-nlb-load-balancer-register-targets.png"><img src="/nginx/images/aws-nlb-load-balancer-register-targets.png" alt="" width="1024" height="847" class="aligncenter size-full wp-image-54846" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

2. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Add to registered </span> button above the table. The instances are added to the **Registered targets** table.

   <a href="/nginx/images/aws-nlb-load-balancer-targets-display.png"><img src="/nginx/images/aws-nlb-load-balancer-targets-display.png" alt="" width="1024" height="874" class="aligncenter size-full wp-image-54845" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. Click the <span style="background-color:#cccccc; font-weight:bolder; white-space: nowrap;"> Next: Review </span> button in the lower‑right corner of the window.

<span id="nlb-launch"></span>
### Launching the AWS NLB

In the **Step 4: Review** window that opens:

1. Verify that the settings are correct. If so, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create </span> button in the lower‑right corner of the window. To change settings, click the <span style="background-color:#cccccc; font-weight:bolder; white-space: nowrap;"> Previous </span> button to go back to previous screens.

   <a href="/nginx/images/aws-nlb-load-balancer-review.png"><img src="/nginx/images/aws-nlb-load-balancer-review.png" alt="" width="1023" height="789" class="aligncenter size-full wp-image-54843" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

2. The AWS NLB is provisioned. When the success message appears, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Close </span> button to return to the **Load Balancers** dashboard.

   <a href="/nginx/images/aws-nlb-load-balancer-success.png"><img src="/nginx/images/aws-nlb-load-balancer-success.png" alt="" width="1024" height="345" class="aligncenter size-full wp-image-54842" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. The **Load Balancers** dashboard opens. As noted in the previous **Load Balancer Creation Status** window, it can take a few minutes to provision the AWS NLB. When the value in the **State** column of the table changes to <span style="color:#666666; font-weight:bolder">active</span>, click the radio button in the left‑most column to display details about the AWS NLB.

   <a href="/nginx/images/aws-nlb-load-balancer-active-state.png"><img src="/nginx/images/aws-nlb-load-balancer-active-state.png" alt="" width="1024" height="634" class="aligncenter size-full wp-image-54841" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. To verify that the AWS NLB is working correctly, open a new browser window and navigate to the AWS NLB's public DNS name, which appears in the **DNS name** field in the **Basic Configuration** section of the dashboard. [If you copy and paste the DNS name, be sure not to include the parenthesized words at the end, <span style="color:#666666; font-weight:bolder">(A Record)</span>.]

   The default **Welcome to nginx!** page indicates that the AWS NLB has successfully forwarded a request to one of the two NGINX Plus instances.

   <a href="/nginx/images/aws-nlb-welcome-to-nginx.png"><img src="/nginx/images/aws-nlb-welcome-to-nginx.png" alt="" width="1023" height="328" class="aligncenter size-full wp-image-54840" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

5. To verify that the NGINX Plus load balancer is working correctly, add <span style="white-space: nowrap; font-weight:bold;">/backend-one</span> and then <span style="white-space: nowrap; font-weight:bold;">/backend-two</span> to the public DNS name. The pages indicate that you have reached NGINX instances serving the two backend applications, <span style="color:#666666; font-weight:bolder">App 1</span> and <span style="color:#666666; font-weight:bolder">App 2</span>.

   <a href="/nginx/images/aws-nlb-app1.png"><img src="/nginx/images/aws-nlb-app1.png" alt="" width="1024" height="491" class="aligncenter size-full wp-image-54839" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   <a href="/nginx/images/aws-nlb-app2-v2.png"><img src="/nginx/images/aws-nlb-app2-v2.png" alt="" width="1024" height="491" class="aligncenter size-full wp-image-54937" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

<span id="appendix"></span>
## Appendix

This Appendix provides links to instructions for creating EC2 instances with the names used in this guide, and then installing and configuring NGINX Open Source and NGINX Plus on them:

- [Creating EC2 Instances and Installing the NGINX Software](#create-instance-install-nginx)
- [Configuring NGINX Open Source on the Web Servers](#configure-web-servers)
- [Configuring NGINX Plus on the Load Balancers](#configure-load-balancers)

As an alternative to creating and configuring instances individually, you can use our Packer and Terraform scripts to completely automate the process:

- [Automating Instance Setup with Packer and Terraform](#create-instances-automated)

After completing the instructions, you have completed the prerequisites for this guide and can continue to [Configuring an AWS Network Load Balancer](#nlb-configure).

<span id="create-instance-install-nginx"></span>
### Creating EC2 Instances and Installing the NGINX Software

The deployment in this guide uses six EC2 instances: two instances running NGINX Plus that load balance traffic to four instances running NGINX Open Source as a web server. The four NGINX Open Source instances are deployed in two pairs, each pair running a different app.

<span style="white-space: nowrap;">Step‑by‑step</span> instructions for creating EC2 instances and installing NGINX Open Source and NGINX Plus are provided in our deployment guide, [Creating Amazon EC2 Instances for NGINX Open Source and NGINX Plus]({{< relref "ec2-instances-for-nginx.md" >}}).

**Note:** When installing NGINX Open Source or NGINX Plus, you connect to each instance over SSH. To save time, leave the SSH connection to each instance open after installing the software, for reuse when you configure it with the instructions in the sections below.

Assign the following names to the instances, and then install the indicated NGINX software. The screenshot below shows the resulting **Instances** table.

- Four NGINX Open Source instances:
  - App 1:
    - <span style="color:#666666; font-weight:bolder">ngx-oss-app1-1</span>
    - <span style="color:#666666; font-weight:bolder">ngx-oss-app1-2</span>
  - App 2:
    - <span style="color:#666666; font-weight:bolder">ngx-oss-app2-1</span>
    - <span style="color:#666666; font-weight:bolder">ngx-oss-app2-2</span>

- Two NGINX Plus instances:
  - <span style="color:#666666; font-weight:bolder">ngx-plus-1</span>
  - <span style="color:#666666; font-weight:bolder">ngx-plus-2</span>

<a href="/nginx/images/aws-nlb-instances-summary.png"><img src="/nginx/images/aws-nlb-instances-summary.png" alt="" width="1024" height="263" class="aligncenter size-full wp-image-54856" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

<span id="configure-web-servers"></span>
### Configuring NGINX Open Source on the Web Servers

For the purposes of this guide, you configure the NGINX Open Source instances as web servers that return a page specifying the server name, address, and other information. As an example, here's the page returned by <span style="color:#666666; font-weight:bolder; white-space: nowrap;">App 1</span>:

   <a href="/nginx/images/aws-nlb-app1.png"><img src="/nginx/images/aws-nlb-app1.png" alt="" width="1024" height="491" class="aligncenter size-full wp-image-54839" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

<span style="white-space: nowrap;">Step‑by‑step</span> instructions are provided in our deployment guide, <a href="../../setting-up-nginx-demo-environment#nginx-oss">Setting Up an NGINX Demo Environment</a>.

Repeat the instructions on all four web servers:

- Running App 1:
  - <span style="color:#666666; font-weight:bolder">ngx-oss-app1-1</span>
  - <span style="color:#666666; font-weight:bolder">ngx-oss-app1-2</span>
- Running App 2:
  - <span style="color:#666666; font-weight:bolder">ngx-oss-app2-1</span>
  - <span style="color:#666666; font-weight:bolder">ngx-oss-app2-2</span>

<span id="configure-load-balancers"></span>
### Configuring NGINX Plus on the Load Balancers

For the purposes of this guide, you configure the NGINX Plus instances as load balancers to distribute requests to the NGINX Open Source web servers set up in [Configuring NGINX Open Source on the Web Servers](#configure-web-servers).

<span style="white-space: nowrap;">Step‑by‑step</span> instructions are provided in our deployment guide, <a href="../../setting-up-nginx-demo-environment#nginx-plus">Setting Up an NGINX Demo Environment</a>.

Repeat the instructions on both <span style="color:#666666; font-weight:bolder; white-space: nowrap;">ngx-plus-1</span> and <span style="color:#666666; font-weight:bolder; white-space: nowrap;">ngx-plus-2</span>.

<span id="create-instances-automated"></span>
## Automating Instance Setup with Packer and Terraform

As an alternative to individual creation and configuration of the six instances used in this guide, you can use the Packer and Terraform scripts from our [GitHub repository](https://github.com/nginxinc/NGINX-Demos/tree/master/aws-nlb-ha-asg). They generate the complete setup for this guide, with two load balancer instances running NGINX Plus and four web server instances running NGINX Open Source.

After executing the scripts, you can jump directly into the [instructions for creating an AWS NLB](#nlb-configure) without any further setup. Additionally, the scripts create a new set of networking rules and security group settings to avoid conflicts with any pre‑existing network settings.

**Note:** Instead of using the default VPC like the [instructions in our Deployment Guide]({{< relref "ec2-instances-for-nginx.md" >}}), the scripts create a new VPC.

To run the scripts, follow these instructions:

1. Install [Packer](https://www.packer.io/intro/getting-started/install.html) and [Terraform](https://learn.hashicorp.com/terraform).

2. Clone or download the scripts from our [GitHub repository](https://github.com/nginxinc/NGINX-Demos/tree/master/aws-nlb-ha-asg):

   - The scripts in <span style="white-space: nowrap; font-weight:bold;">packer/ngx-oss</span> are for creating an Ubuntu AMI running open source NGINX.
   - The scripts in <span style="white-space: nowrap; font-weight:bold;">packer/ngx-plus</span> are for creating an AWS Linux AMI running NGINX Plus.
   - The scripts in **terraform** are for launching and configuring the two NGINX Plus load balancer instances and the four NGINX Open Source web server instances.

3. Set your AWS credentials in the Packer and Terraform scripts:

   - For Packer, set your credentials in the `variables` block in <span style="text-decoration: underline;">both</span> <span style="white-space: nowrap; font-weight:bold;">packer/ngx-oss/packer.json</span> and <span style="white-space: nowrap; font-weight:bold;">packer/ngx-plus/packer.json</span>:

     ```none
     "variables": {
         "home": "{{env `HOME`}}",
         "aws_access_key": "",
         "aws_secret_key": ""
     }
     ```

   - For Terraform, set your credentials in **terraform/provider.tf**:

     ```none
     provider "aws" {
       region = "us-west-1"
       access_key = ""
       secret_key = ""
     }
     ```

4. Copy your NGINX Plus certificate and key to **~/.ssh/certs**.

5. Run the `setup.sh` script:

   ```shell
   chmod +x setup.sh
   ./setup.sh
   ```

The script launches two NGINX Plus load balancer instances and four NGINX web server instances and configures the appropriate settings on each instance to run the guide.

If you want to delete the infrastructure created by Terraform, run the `cleanup.sh` script.

```shell
chmod +x cleanup.sh
./cleanup.sh
```

### Revision History

- Version 5 (March 2020) – Fix link missed in Version 4
- Version 4 (November 2019) – Change link to GitHub repo for automated setup
- Version 3 (April 2019) – Modularization of Appendix
- Version 2 (April 2018) – Revisions to Appendix
- Version 1 (November 2017) – Initial version (NGINX Plus Release 13)

