---
description: Create a highly available active-active deployment of F5 NGINX Plus on
  AWS in combination with AWS Network Load Balancer (NLB).
docs: DOCS-446
title: Active-Active HA for NGINX Plus on AWS Using AWS Network Load Balancer
toc: true
weight: 100
type:
- how-to
---

These instructions explain how to deploy F5 NGINX Plus in the Amazon Web Services (AWS) cloud. Use these instructions to create a highly available, active-active deployment with load balancing.

This solution combines the AWS Network Load Balancer (NLB) with NGINX Plus. In this solution, AWS NLB provides fast, efficient handling of Layer 4 traffic. NGINX Plus provides Layer 7 features such as load balancing, caching, and content-based routing. When combined, they form a fast, powerful, reliable, and relatively low-cost solution.

These instructions provide steps to set up an AWS NLB in front of one pair of NGINX Plus load balancers. Repeat these steps to install added NGINX Plus instances to increase resiliency, as needed.

Refer to the [Appendix](#appendix) to create Amazon Elastic Compute Cloud (EC2) instances with names used in these instructions. There you can also find instructions to install and configure NGINX software on EC2.

<span id="about-nlb"></span>
## About AWS NLB

AWS NLB uses a [flow hash routing algorithm](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html#routing-algorithm). It promotes fast, efficient load balancing at the connection level (Layer 4). This means that AWS NLB is ideal for fast load balancing of TCP traffic. It can handle millions of requests per second while maintaining ultra‑low latencies. As a result, AWS NLB easily handles traffic volume patterns that suddenly and dramatically change. AWS NLB supports both static IP addresses and [Elastic IP addresses](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html). This is a change from previous AWS solutions.

<span id="about-nginx"></span>
## About NGINX Plus

[NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) is the commercial version of [NGINX Open Source](http://nginx.org/en) software, which extends the power of NGINX with enterprise-ready capabilities.

NGINX Plus complements AWS NLB. It operates at Layer 7 (the application layer) where it uses advanced criteria when load balancing. These criteria include schemes that rely on content of requests and the results of [active health checks]({{< ref "/nginx/admin-guide/load-balancer/http-health-check.md" >}}).

NGINX Plus also provides reverse‑proxy and load balancing features, including:

- [Full‑featured HTTP, TCP, and UDP load balancing](https://www.nginx.com/products/nginx/load-balancing/)
- [Intelligent session persistence](https://www.nginx.com/products/nginx/load-balancing/#session-persistence)
- [High‑performance reverse proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})
- [Caching and offload of dynamic and static content]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}})
- [Adaptive streaming to deliver audio and video to any device](https://www.nginx.com/products/nginx/streaming-media/)
- [Application-aware health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/) and [high availability](https://docs.nginx.com/nginx/admin-guide/high-availability/)
- [Advanced activity monitoring available via a dashboard or API](https://www.nginx.com/products/nginx/live-activity-monitoring/)
- [Management and real‑time configuration changes with DevOps‑friendly tools](https://www.nginx.com/products/nginx/load-balancing/#load-balancing-api)

<span id="overview"></span>
## Solution overview

The combined solution described further in these instructions consists of:

- AWS NLB
- AWS target groups
- EC2 instances running NGINX Plus
- EC2 instances running NGINX Open Source

Together, these provide an HA, all-active NGINX and NGINX Plus solution.

<img src="/nginx/images/nginx-plus-ha-aws-nlb.png" alt="" width="1024" height="577" class="aligncenter size-full wp-image-54857" style="border:2px solid #666666; padding:2px; margin:2px;" />

AWS NLB uses a flow hash routing algorithm to balance traffic and handle Layer 4 TCP connections. AWS NLB listens for incoming connections as defined by its listeners. Each listener forwards a new connection to one of the available instances in a target group. AWS NLB uses the flow hash routing algorithm to chose an available instance.

{{< note >}} By default, an AWS NLB uses a DNS name with a dynamic IP address. As an option, you can attach an Elastic IP address to the AWS NLB. This ensures that the AWS NLB is always reachable at the same IP address.  {{< /note >}}

These instructions assume a target group consists of two NGINX Plus load balancer instances. You can register an unlimited number of instances in the target group. Or, you can use an [AWS Auto Scaling group](https://aws.amazon.com/autoscaling/) to dynamically adjust the number of NGINX Plus instances.

<span id="prereqs"></span>
## Prerequisites

These instructions assume you have the following:

- Familiarity with NGINX and NGINX Plus configuration syntax.
- [An AWS account](http://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/AboutAWSAccounts.html).
- Six EC2 instances running a version of NGINX:
    - Four running NGINX Open Source
    - Two running NGINX Plus
    - You need a paid or trial subscription for each NGINX Plus instance.

  Refer to the [Appendix](#appendix) to create EC2 instances with names used in these instructions. There you can also find instructions to install and configure NGINX software on EC2.

<span id="nlb-configure"></span>
## Configure an AWS Network Load Balancer

Once you install and configure NGINX Open Source and NGINX Plus on the EC2 instances you are ready to set up AWS NLB. Refer to the [Appendix](#appendix) for more installation and set up instructions.

The steps to set up an AWS NLB for an HA, all‑active NGINX Plus deployment include:

- [Allocate an Elastic IP Address](#nlb-eip)
- [Create an AWS NLB](#nlb-create)
- [Configure the AWS NLB Routing Options](#nlb-routing-options)
- [Register Instances in the Target Group](#nlb-register-instances)
- [Launch the AWS NLB](#nlb-launch)

<span id="nlb-eip"></span>
### Allocate an Elastic IP address

The first step is to allocate an Elastic IP address, which becomes the fixed IP address for your AWS NLB. Using an Elastic IP address is optional, but it is strongly recommended that you do so. With a dynamic IP address, the AWS NLB might not remain reachable if you reconfigure or restart it.

1. Log in to the [AWS Management Console](https://console.aws.amazon.com/ec2/) for EC2 (**<https://console.aws.amazon.com/ec2/>**).

2. In the navigation bar, select **Elastic IPs**. Then, select either of the *Allocate new address* buttons.

    <a href="/nginx/images/aws-nlb-eip-open.png"><img src="/nginx/images/aws-nlb-eip-open.png" alt="" width="1024" height="466" class="aligncenter size-full wp-image-54932" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. The **Allocate new address** window opens. Select the *Allocate* button.

   <a href="/nginx/images/aws-nlb-eip-allocate-new.png"><img src="/nginx/images/aws-nlb-eip-allocate-new.png" alt="" width="1024" height="285" class="aligncenter size-full wp-image-54853" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. A message displays that the request for an Elastic IP address succeeded. Select the *Close* button.

   <a href="/nginx/images/aws-nlb-eip-new-success.png"><img src="/nginx/images/aws-nlb-eip-new-success.png" alt="" width="1024" height="406" class="aligncenter size-full wp-image-54852" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

The new Elastic IP address displays on the **Elastic IPs** dashboard. Make a note of this address, you will use it in the next step.

<a href="/nginx/images/aws-nlb-eip-new-display.png"><img src="/nginx/images/aws-nlb-eip-new-display.png" alt="" width="1019" height="450" class="aligncenter size-full wp-image-54851" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

<span id="nlb-create"></span>
### Create the AWS NLB

1. In the navigation bar, select **Load Balancers**. Then, select the *Create Load Balancer* button.

   <a href="/nginx/images/aws-nlb-load-balancer-open.png"><img src="/nginx/images/aws-nlb-load-balancer-open.png" alt="" width="1025" height="438" class="aligncenter size-full wp-image-54850" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

2. The **Select load balancer type** window opens. Select the *Create* button in the center *Network Load Balancer* panel.

   <a href="/nginx/images/aws-nlb-load-balancer-types.png"><img src="/nginx/images/aws-nlb-load-balancer-types.png" alt="" width="1024" height="330" class="aligncenter size-full wp-image-54849" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. The **Step 1: Configure Load Balancer** window that opens. Use the following values to set up the load balancer:
   - In the **Basic Configuration** section:
        - **Name** – Enter the name of your AWS NLB (*aws-nlb-lb* in these instructions).
        - **Scheme** – Select *internet-facing*.
   - In the **Listeners** section:
        - **Load Balancer Protocol** – Select *TCP* (the only available option).
        - **Load Balancer Port** – Enter *80*. This is the port on which your AWS NLB listens for incoming connections.
   - In the **Availability Zones** section, designate the zones that host EC2 instances where your AWS NLB routes traffic. Both options target a single availability zone. Choose the option that matches the method used to set up EC2 instances. In the table, select the button in the row you want to choose:
        - If you used [Creating Amazon EC2 Instances for NGINX Open Source and NGINX Plus]({{< ref "/nginx/deployment-guides/amazon-web-services/ec2-instances-for-nginx.md" >}}), select the default subnet within the default [Amazon Virtual Private Cloud](https://aws.amazon.com/vpc/) (VPC).
        - If you used our scripts for [Packer and Terraform](#create-instances-automated), select the *aws-nlb-subnet* within the *aws-nlb-vpc* VPC.

   <a href="/nginx/images/aws-nlb-load-balancer-configure.png"><img src="/nginx/images/aws-nlb-load-balancer-configure.png" alt="" width="1024" height="921" class="aligncenter size-full wp-image-54848" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. When you select an availability zone in the table, a drop‑down menu displays in the **Elastic IP** column. Select the address you allocated in [Allocate an Elastic IP Address](#nlb-eip).

5. Select the *Next: Configure Routing* button. The **Step 2: Configure Routing** window opens.

<span id="nlb-routing-options"></span>
### Configure the AWS NLB routing options

In this step, you create a _target group_, using the **Step 2: Configure Routing** window. The target group contains the set of EC2 instances across which your AWS NLB load balances traffic. You specify those EC2 instances later, in the step [Register Instances in the Target Group](#nlb-register-instances)).

1. In the **Target group** section, use the following values to create the target group:

    - **Target group** – Select *New target group*
    - **Name** – Enter the name of the new target group. For these instructions use *aws-nlb-tg*
    - **Protocol** – Select *TCP* (the only available option)
    - **Port** – Enter *80*. This is the same value you specified for the **Load Balancer Port** field in Step 3 of the [previous section](#nlb-create).
    - **Target type** – Enter *instance*

2. In the **Health checks** section, open the **Advanced health check settings** subsection and enter the following values:

    - **Protocol** – Enter either *HTTP*, or *HTTPS*, as described below. This field specifies the protocol the AWS NLB uses when sending health checks.
    - **TCP** - AWS NLB attempts to open a TCP connection to send a health check. The port it uses is specified in the next field. If you select TCP you must also define **Port**.
    - **Port** – Select *traffic port*. This is the port on the target instances to which the AWS NLB sends health checks. These instructions use **traffic port** to send health checks to the same port as regular traffic. This value is required if the value for **Protocol** is **TCP**.
    - **HTTP** or **HTTPS** AWS NLB sends a GET request to send a health check. The path it uses is specified in the next field. If you select **HTTP** or **HTTPS** you must also define **Path** and **Success codes** as follows:
    - **Path** – Enter the path to which the AWS NLB sends a `GET` request as the health check. This value is required if the value for **Protocol** is **HTTP** or **HTTPS**.
    - **Success codes** – Enter the range of HTTP response codes the AWS NLB should accept to show a successful health check. This value is required if the value for **Protocol** is **HTTP** or **HTTPS**.
    - **Healthy threshold** – Enter a whole number. This is the number of consecutive health checks an unhealthy instance must pass to be considered healthy.
    - **Unhealthy threshold** – Enter a whole number. This is the number of consecutive health checks a healthy instance must fail to change its status to unhealthy.
    - **Timeout** – Enter the number of seconds the AWS NLB waits for a response to the health check before considering the instance unhealthy.
    - **Interval** – Enter the number of seconds between health checks.

   <a href="/nginx/images/aws-nlb-load-balancer-routing.png"><img src="/nginx/images/aws-nlb-load-balancer-routing.png" alt="" width="1024" height="840" class="aligncenter size-full wp-image-54847" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. Select the *Next: Register Targets* button. The **Step 3: Register Targets** window opens.

<span id="nlb-register-instances"></span>
### Register instances in the target group

In this step, you add instances to the empty target group you created in the previous section. Use the the **Step 3: Register Targets** window to add both NGINX Plus load balancer instances.

1. In the **Instances** table, select the buttons for both NGINX Plus load balancer instances. Select the instance names *ngx-plus-1* and *nginx-plus-2*.

   <a href="/nginx/images/aws-nlb-load-balancer-register-targets.png"><img src="/nginx/images/aws-nlb-load-balancer-register-targets.png" alt="" width="1024" height="847" class="aligncenter size-full wp-image-54846" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

2. Select the *Add to registered* button above the table. The instances are added to the **Registered targets** table.

   <a href="/nginx/images/aws-nlb-load-balancer-targets-display.png"><img src="/nginx/images/aws-nlb-load-balancer-targets-display.png" alt="" width="1024" height="874" class="aligncenter size-full wp-image-54845" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. Select the *Next: Review* button. The **Step 4: Review** window opens.

<span id="nlb-launch"></span>
### Launch the AWS NLB

In this step you use the **Step 4: Review** window to verify settings and launch AWS NLB.

1. In the **Step 4: Review** window verify that the settings are correct.
     - If so, select the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create </span> button.
     - If the settings are not correct, select the *Previous* button to go back to a previous screen. Make required change(s) on previous screen(s). Then, return to the **Step 4: Review** window to select *Create*.

   <a href="/nginx/images/aws-nlb-load-balancer-review.png"><img src="/nginx/images/aws-nlb-load-balancer-review.png" alt="" width="1023" height="789" class="aligncenter size-full wp-image-54843" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

    The *Create* action provisions the AWS NLB. A success message displays when the provisioning operation finishes. It can take a few minutes to provision the AWS NLB.

2. Select the *Close* button to return to the **Load Balancers** dashboard.

   <a href="/nginx/images/aws-nlb-load-balancer-success.png"><img src="/nginx/images/aws-nlb-load-balancer-success.png" alt="" width="1024" height="345" class="aligncenter size-full wp-image-54842" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. Observe the values in the **State** column of the table. When a value changes to *active*, you can display details about the provisioned AWS NLB. Select the button in an AWS NLB row to display its details.

   <a href="/nginx/images/aws-nlb-load-balancer-active-state.png"><img src="/nginx/images/aws-nlb-load-balancer-active-state.png" alt="" width="1024" height="634" class="aligncenter size-full wp-image-54841" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. Next, verify that the AWS NLB is working. Open a new browser window and navigate to the AWS NLB's public DNS name. You can find the **DNS name** field in the **Basic Configuration** section of the **Load Balancers** dashboard. **Note:** If you copy and paste the DNS name, be sure to exclude the parenthesized words at the end, for example, *(A Record)*.

    If you see the **Welcome to nginx!** page then the AWS NLB successfully forwarded a request to one of the two NGINX Plus instances.

   <a href="/nginx/images/aws-nlb-welcome-to-nginx.png"><img src="/nginx/images/aws-nlb-welcome-to-nginx.png" alt="" width="1023" height="328" class="aligncenter size-full wp-image-54840" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

5. Last, verify that the NGINX Plus load balancer can reach backend applications.

   - Append */backend-one* to the public DNS name in the open browser window. If *App 1* is displayed then you have reached the **App 1** NGINX backend instance.

   <a href="/nginx/images/aws-nlb-app1.png"><img src="/nginx/images/aws-nlb-app1.png" alt="" width="1024" height="491" class="aligncenter size-full wp-image-54839" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

    - Append */backend-two* to the public DNS name in the open browser window. If *App 2* is displayed then you have reached the **App 2** NGINX backend instance.

   <a href="/nginx/images/aws-nlb-app2-v2.png"><img src="/nginx/images/aws-nlb-app2-v2.png" alt="" width="1024" height="491" class="aligncenter size-full wp-image-54937" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

Congratulations! You deployed NGNX Plus in the AWS cloud and created a highly available, active-active deployment with load balancing.

<span id="appendix"></span>
## Appendix

Use links in this appendix to create EC2 instances with names used in the above instructions. Then, use steps below to install and configure NGINX Open Source and NGINX Plus on those instances.

You can either complete these individual steps:

- [Create EC2 Instances and Install the NGINX Software](#create-instance-install-nginx)
- [Configure NGINX Open Source on the Web Servers](#configure-web-servers)
- [Configure NGINX Plus on the Load Balancers](#configure-load-balancers)

OR

Use our Packer and Terraform scripts to completely automate the process:

- [Automate Instance Setup with Packer and Terraform](#create-instances-automated)

Once you have created and configured the EC2 instances, your prerequisites are complete. Continue to [Configure an AWS Network Load Balancer](#nlb-configure).

<span id="create-instance-install-nginx"></span>
#### Create EC2 instances and install the NGINX software

The deployed solution in these instructions uses six EC2 instances. Two instances run NGINX Plus. These load balance traffic to the other four instances, which run NGINX Open Source as a web server. The four NGINX Open Source instances deploy in two pairs; each pair runs a different app.

*Step‑by‑step* instructions for creating EC2 instances and installing NGINX Open Source and NGINX Plus are available. Refer to our deployment guide, [Creating Amazon EC2 Instances for NGINX Open Source and NGINX Plus]({{< ref "/nginx/deployment-guides/amazon-web-services/ec2-instances-for-nginx.md" >}}).

{{< note >}} When installing NGINX Open Source or NGINX Plus, you connect to each instance over SSH. To save time, leave the SSH connection to each instance open after installing the software. This way, you can reuse the connection when configuring the instance. {{< /note >}}

Assign the following names to the instances, then install the indicated NGINX software. The screenshot below shows the resulting **Instances** table.

- Four NGINX Open Source instances:
  - App 1:
    - **ngx-oss-app1-1**
    - **ngx-oss-app1-2**
  - App 2:
    - **ngx-oss-app2-1**
    - **ngx-oss-app2-2**

- Two NGINX Plus instances:
  - **ngx-plus-1**
  - **ngx-plus-2**

<a href="/nginx/images/aws-nlb-instances-summary.png"><img src="/nginx/images/aws-nlb-instances-summary.png" alt="" width="1024" height="263" class="aligncenter size-full wp-image-54856" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

<span id="configure-web-servers"></span>
#### Configure NGINX Open Source on the web servers

Configure NGINX Open Source instances as web servers. These should return a page specifying the server name, address, and other information. As an example, here's the page returned by *App 1*:

   <a href="/nginx/images/aws-nlb-app1.png"><img src="/nginx/images/aws-nlb-app1.png" alt="" width="1024" height="491" class="aligncenter size-full wp-image-54839" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

Use the *Step‑by‑step* instructions in our deployment guide, [Setting Up an NGINX Demo Environment]({{< ref "/nginx/deployment-guides/setting-up-nginx-demo-environment.md" >}}).

Repeat the instructions on all four web servers:

- Running App 1:
  - **ngx-oss-app1-1**
  - **ngx-oss-app1-2**
- Running App 2:
  - **ngx-oss-app2-1**
  - **ngx-oss-app2-2**

<span id="configure-load-balancers"></span>
#### Configure NGINX Plus on the load balancers

Configure NGINX Plus instances as load balancers. These distribute requests to NGINX Open Source web servers set up in [Configure NGINX Open Source on the Web Servers](#configure-web-servers).

Use the *Step‑by‑step* instructions in our deployment guide, [Setting Up an NGINX Demo Environment]({{< ref "/nginx/deployment-guides/setting-up-nginx-demo-environment.md" >}}).

Repeat the instructions on both **ngx&#8209;plus&#8209;1** and **ngx&#8209;plus&#8209;2**.

<span id="create-instances-automated"></span>
### Automate instance setup with Packer and Terraform

You can automate set up of the six instances described in these instructions. Automation is an alternative to creating and configuring each instance one at a time. To automate the set up, use the Packer and Terraform scripts from our [GitHub repository](https://github.com/nginxinc/NGINX-Demos/tree/master/aws-nlb-ha-asg). These scripts will:

- Configure two load balancer instances running NGINX Plus
- Configure four web server instances running NGINX Open Source

These scripts also create a new set of networking rules and security group settings. These rules and settings help avoid conflicts with any pre‑existing network settings. After you run the scripts, continue to the [instructions for creating an AWS NLB](#nlb-configure). No further setup is required.

{{< note >}} These scripts also create a new VPC. They do not use the default VPC described in the [instructions in our Deployment Guide]({{< ref "/nginx/deployment-guides/amazon-web-services/ec2-instances-for-nginx.md" >}}).  {{< /note >}}

To run the scripts, follow these instructions:

1. Install [Packer](https://www.packer.io/intro/getting-started/install.html) and [Terraform](https://learn.hashicorp.com/terraform).

2. Clone or download the scripts from our [GitHub repository](https://github.com/nginxinc/NGINX-Demos/tree/master/aws-nlb-ha-asg):

   - Use the scripts in **packer/ngx-oss** to create an Ubuntu AMI running NGINX Open Source.
   - Use the scripts in **packer/ngx-plus** to create an AWS Linux AMI running NGINX Plus.
   - Use the scripts in **terraform** to launch and configure the two NGINX Plus load balancer instances and the four NGINX Open Source web server instances.

3. Set your AWS credentials in the Packer and Terraform scripts:

   - For Packer, set your credentials in the `variables` block in <span style="text-decoration: underline;">both</span> **packer/ngx&#8209;oss/packer.json** and **packer/ngx&#8209;plus/packer.json**:

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

When run, this script:
- Launches two NGINX Plus load balancer instances and four NGINX web server instances
- Configures the appropriate settings on each instance to run the guide

6. **Optional:** To delete the infrastructure created by Terraform, run the `cleanup.sh` script.

```shell
chmod +x cleanup.sh
./cleanup.sh
```

