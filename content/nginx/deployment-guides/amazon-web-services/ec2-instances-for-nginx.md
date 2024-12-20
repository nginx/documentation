---
description: Create Amazon Elastic Compute Cloud (EC2) instances for running NGINX
  Open Source and F5 NGINX Plus.
docs: DOCS-444
doctypes:
- task
title: Creating Amazon EC2 Instances for NGINX Open Source and NGINX Plus
toc: true
weight: 600
---

These instructions explain how to create instances in the Amazon Elastic Compute Cloud (EC2) environment suitable for running NGINX Open Source and F5 NGINX Plus.

For NGINX Plus, a faster alternative is to purchase a prebuilt Amazon Machine Image (AMI) in the AWS Marketplace. Several operating systems are available, including Amazon Linux, Red Hat Enterprise Linux, and Ubuntu. For instructions, see [Installing NGINX Plus AMIs on Amazon EC2]({{< relref "../../admin-guide/installing-nginx/installing-nginx-plus-amazon-web-services.md" >}}).

<span id="prereqs"></span>
## Prerequisites

These instructions assume you have:

- An [AWS account](http://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/AboutAWSAccounts.html).
- If using the instructions in [Automating Installation with Ansible](#automate-ansible), basic Linux system administration skills, including installation of Linux software from vendor‑supplied packages, and file creation and editing.

In addition, to install NGINX software by following the linked instructions, you need:

- An NGINX Plus subscription, either paid or a [30‑day free trial](https://www.nginx.com/free-trial-request), if you plan to install that product.
- `root` privilege on the hosts where NGINX Open Source and NGINX Plus are to be installed. If appropriate for your environment, prefix commands with the `sudo` command.

<span id="create-ec2-instance"></span>
## Creating an Amazon EC2 Instance

1. Log into the [EC2 dashboard](https://console.aws.amazon.com/ec2/) in the AWS Management Console (**<https://console.aws.amazon.com/ec2/>**).

2. In the left navigation bar, select **Instances**, then click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Launch Instance </span> button.

   <a href="/nginx/images/aws-generic-instance-launch.png"><img src="/nginx/images/aws-generic-instance-launch.png" alt="" width="1024" height="266" class="aligncenter size-full image-56336" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. In the **Step 1: Choose an Amazon Machine Image (AMI)** window, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Select </span> button for the Linux distribution of your choice.

   <a href="/nginx/images/aws-nlb-instance-choose-ami.png"><img src="/nginx/images/aws-nlb-instance-choose-ami.png" alt="" width="1024" height="539" class="aligncenter size-full wp-image-54836" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. In the **Step 2: Choose an Instance Type** window, click the radio button for the appropriate instance type. In the screenshot, we are selecting a <span style="color:#666666; font-weight:bolder; white-space: nowrap;">t2.micro</span> instance, which is normally selected by default and is sufficient for demo purposes.

   **Note:** At the time of publication of this guide, AWS gives you 750 hours of free usage per month with this instance type during the first year of your AWS account. Keep in mind, however, that if they run 24 hours a day, the sets of instances specified in the NGINX deployment guides use up the 750 hours in just a few days (just over 5 days for 6 instances, and just under 4 days for 8 instances).

   Click the <span style="background-color:#cccccc; font-weight:bold;"> Next: Configure Instance Details </span> button to continue to the next step.

   <a href="/nginx/images/aws-nlb-instance-choose-type.png"><img src="/nginx/images/aws-nlb-instance-choose-type.png" alt="" width="1024" height="360" class="aligncenter size-full wp-image-54835" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

5. In the **Step 3: Configure Instance Details** window, select the default subnet for your VPC in the **Subnet** field, then click the <span style="background-color:#cccccc; font-weight:bold;"> Next: Add Storage </span> button.

   <a href="/nginx/images/aws-generic-instance-details.png"><img src="/nginx/images/aws-generic-instance-details.png" alt="" width="1024" height="793" class="aligncenter size-full image-56335" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

6. In the **Step 4: Add Storage** window, leave the defaults unchanged. Click the <span style="background-color:#cccccc; font-weight:bold;"> Next: Add Tags </span> button.

   <a href="/nginx/images/aws-nlb-instance-add-storage.png"><img src="/nginx/images/aws-nlb-instance-add-storage.png" alt="" width="1024" height="428" class="aligncenter size-full wp-image-54833" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

7. In the **Step 5: Add Tags** window, click the <span style="background-color:#cccccc; font-weight:bold;"> Add Tag </span> button. Type <span style="color:#666666; font-weight:bolder;">Name</span> in the **Key** field, and in the **Value** field type the instance name (the screenshot shows the result). This name is what will appear in the **Name** column of the summary table on the **Instances** tab of the EC2 dashboard (see the screenshot in Step 12, which shows one instance).

   If you are following these instructions as directed by an NGINX deployment guide, the **Creating EC2 Instances and Installing the NGINX Software** section of the deployment guide specifies the instance names to use.

   Click the <span style="background-color:#cccccc; font-weight:bold;"> Next: Configure Security Group </span> button to continue to the next step.

   <a href="/nginx/images/aws-instance-add-tags-name.png"><img src="/nginx/images/aws-instance-add-tags-name.png" alt="" width="1024" height="483" class="aligncenter size-full wp-image-56334" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

8. In the **Step 6: Configure Security Group** window, select or enter the following values in the indicated fields:

   - **Assign a security group** –
     - If you are setting up a deployment with multiple instances (one in an NGINX deployment guide, for instance), and this is the first instance you are creating, select <span style="color:#666666; font-weight:bolder;">Create a</span> **new** <span style="color:#666666; font-weight:bolder;">security group</span>.
     - For subsequent instances, select <span style="color:#666666; font-weight:bolder;">Select an</span> **existing** <span style="color:#666666; font-weight:bolder;">security group</span> instead (it makes sense for all instances in a deployment to use the same security group).
   - **Security group name** – Name of the group. If you are following these instructions as directed by an NGINX deployment guide, the **Prerequisites and Required AWS Configuration** section of the deployment guide specifies the group name to use.
   - **Description** – Description of the group; the group name is often used.

   <a href="/nginx/images/aws-generic-instance-security-group.png"><img alt="/nginx/images/aws-generic-instance-security-group.png" src="/nginx/images/aws-generic-instance-security-group.png" width="1024" height="653" class="aligncenter size-full wp-image-56333" style="border:2px solid #666666; padding:2px; margin:2px;" / /></a>

9. In the table, modify the default rule for SSH connections, if necessary, by selecting or setting the following values. They allow inbound SSH connections from all sources (any IP address):

   - **Type** – <span style="color:#666666; font-weight:bolder;">SSH</span>
   - **Protocol** – <span style="color:#666666; font-weight:bolder;">TCP</span>
   - **Port Range** – <span style="color:#666666; font-weight:bolder;">22</span>
   - **Source** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">Custom 0.0.0.0/0</span>
   - **Description** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">Accept SSH connections from all sources</span>

10. Create a rule that allows inbound HTTP connections from all sources, by clicking the <span style="background-color:#cccccc; font-weight:bold;"> Add Rule </span> button and selecting or setting the following values in the new row:

    - **Type** – <span style="color:#666666; font-weight:bolder;">HTTP</span>
    - **Protocol** – <span style="color:#666666; font-weight:bolder;">TCP</span>
    - **Port Range** – <span style="color:#666666; font-weight:bolder;">80</span>
    - **Source** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">Custom 0.0.0.0/0</span>
    - **Description** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">Accept unencrypted HTTP connections from all sources</span>

    If appropriate, repeat this step to create a rule for HTTPS traffic.

    When you've created all desired rules, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Review and Launch </span> button.

11. In the **Step 7: Review Instance Launch** window, verify the settings are correct. If so, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Launch </span> button in the lower‑right corner of the window. To change settings, click the <span style="background-color:#cccccc; font-weight:bold;"> Previous </span> button to go back to earlier windows.

    <a href="/nginx/images/aws-generic-instance-review-launch.png"><img alt="" src="/nginx/images/aws-generic-instance-review-launch.png" width="1024" height="802" class="aligncenter size-full wp-image-56332" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

12. When you click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Launch </span> button, a window pops up asking you to select an existing key pair or create a new key pair. Take the appropriate action for your use case, then click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Launch Instances </span> button.

    **Note:** It's a best practice – and essential in a production environment – to create a separate key for each EC2 instance, so that if a key is compromised only the single associated instance becomes vulnerable.

    ![Screen of 'Select an existing key pair or create a new key pair' window during creation of Amazon EC2 instance](/nginx/images/aws-nlb-instance-key-pair.png)

    A **Launch Status** window pops up to confirm that your launch is underway. To confirm the details of your instance when the launch completes, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> View Instances </span> button on that page.

    The instances you have created so far are listed on the **Instances** dashboard. The following screenshot shows a single instance.

    <a href="/nginx/images/aws-generic-instance-display-first.png"><img src="/nginx/images/aws-generic-instance-display-first.png" alt="" width="1024" height="422" class="aligncenter size-full wp-image-56331" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

13. Finalize your security group rules. You need to do this only for the first instance in a given set, because all instances in a set can use the same security group.

    - In the left navigation bar, select **Security Groups**.
    - Select the security group by clicking its radio button in the leftmost column of the table. A panel opens in the lower part of the window displaying details about the group.
    - Open the **Inbound** tab and verify that the rules you created in Steps 9 and 10 are listed.

      <a href="/nginx/images/aws-generic-instance-security-inbound.png"><img src="/nginx/images/aws-generic-instance-security-inbound.png" alt="" width="1024" height="467" class="aligncenter size-full wp-image-56329" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

    - Open the **Outbound** tab and click the <span style="background-color:#cccccc; font-weight:bold;"> Edit </span> button to create a rule for outbound traffic. The set of rules depends on which ports you have used for traffic handled by the NGINX Plus instances:

        - If, for example, you have used port 80 both for client traffic and for health checks from a load balancer (for example, [AWS Network Load Balancer]({{< relref "high-availability-network-load-balancer.md" >}})), you need only one rule.
        - If you have configured separate ports for different purposes, or ports other than 80 (such as 443 for HTTPS), make the appropriate adjustments.

      In the **Destination** field, type the security group's ID, which appears in the **Group ID** column in the upper table (here it's <span style="color:#666666; font-weight:bolder;">sg-3bdbf55d</span>).

     <a href="/nginx/images/aws-generic-instance-security-outbound.png"><img src="/nginx/images/aws-generic-instance-security-outbound.png" alt="" width="1024" height="459" class="aligncenter size-full wp-image-56330" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

14. To install NGINX software on the instance, [connect](#connect-to-instance) to it, and follow the instructions in the NGINX Plus Admin Guide for [NGINX Open Source]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source#prebuilt" >}} and [NGINX Plus]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

<span id="connect-to-instance"></span>
## Connecting to an EC2 Instance
To install and configure NGINX Open Source or NGINX Plus on an instance, you need to open a terminal window and connect to the instance over SSH.

1. Navigate to the **Instances** tab on the EC2 Dashboard if you are not there already.

2. Click the row for an instance to select it. In the screenshot **instance2** is selected.

   <a href="/nginx/images/aws-generic-instance-select-one.png"><img src="/nginx/images/aws-generic-instance-select-one.png" alt="" width="1024" height="263" class="aligncenter size-full wp-image-56328" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. Click the <span style="background-color:#cccccc; font-weight:bold;"> Connect </span> button above the list of instances. The **Connect To Your Instance** window pops up.
4. Follow the instructions in the pop‑up window, which are customized for the selected instance (here **instance2**) to provide the name of the key file in the steps and in the sample `ssh` command.

   ![Screenshot of 'Connect To Your Instance' pop-up window for Amazon EC2 instance](/nginx/images/aws-nlb-instance-connect.png)

<span id="install-nginx"></span>
## Installing NGINX Software

Once you have established a connection with an instance, you can install the NGINX software on it. Follow the instructions in the NGINX Plus Admin Guide for <a href="../../../admin-guide/installing-nginx/installing-nginx-open-source/index.html#prebuilt">NGINX Open Source</a> and [NGINX Plus]({{< relref "../../admin-guide/installing-nginx/installing-nginx-plus.md" >}}). The [Admin Guide]({{< relref "/nginx/admin-guide/_index.md" >}}) also provides instructions for many maintenance tasks.

<span id="automate"></span>
### Automating Installation with a Configuration Manager

You can automate the installation of NGINX Open Source and NGINX Plus. Instructions for Ansible are provided below. For Chef and Puppet, see these articles on the NGINX, Inc. blog:

- [Installing NGINX and NGINX Plus with Chef](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/)
- [Deploying NGINX Plus for High Availability with Chef](https://www.nginx.com/blog/nginx-plus-high-availability-chef/)
- [Installing NGINX and NGINX Plus with Puppet](https://www.nginx.com/blog/installing-nginx-nginx-plus-puppet/)

<span id="automate-ansible"></span>
#### Automating Installation with Ansible

NGINX, Inc. publishes a unified Ansible role for NGINX Open Source and NGINX Plus on [Ansible Galaxy](https://galaxy.ansible.com/nginxinc/nginx/) and [GitHub](https://github.com/nginxinc/ansible-role-nginx). Perform these steps to install and run it.

1. [Connect to the EC2 instance](#connect-instance).

2. Install Ansible. These commands are appropriate for Debian and Ubuntu systems:

   ```shell
   apt update
   apt install python-pip -y
   pip install ansible
   ```

3. Install the official Ansible role from NGINX, Inc.:

   ```shell
   ansible-galaxy install nginxinc.nginx
   ```

4. (NGINX Plus only) Copy the <span style="white-space: nowrap; font-weight:bold;">nginx-repo.key</span> and <span style="white-space: nowrap; font-weight:bold;">nginx-repo.crt</span> files provided by NGINX, Inc. to <span style="white-space: nowrap; font-weight:bold;">~/.ssh/ngx-certs/</span>.

5. Create a file called **playbook.yml** with the following contents:

   ```none
   ---
   - hosts: localhost
     become: true
     roles:
       - role: nginxinc.nginx
   ```

5. Run the playbook:

   ```shell
   ansible-playbook playbook.yml
   ```

<span id="create-nginx-oss-ami"></span>
## Optional: Creating an NGINX Open Source AMI

To streamline the process of installing NGINX Open Source on multiple instances, you can create an AMI from an existing NGINX Open Source instance, and spin up additional instances of the AMI when needed.

1. Follow the instructions in [Creating Amazon EC2 Instances](#create-ec2-instances) and the <a href="../../../admin-guide/installing-nginx/installing-nginx-open-source/index.html#prebuilt">NGINX Plus Admin Guide</a> to create an instance and install NGINX Open Source on it, if you have not already.

2. Navigate to the **Instances** tab on the Amazon EC2 Dashboard.

3. Select the base instance by clicking its row in the table. In the screenshot, **instance2** is selected.

   <a href="/nginx/images/aws-generic-instance-select-one.png"><img alt="" src="/nginx/images/aws-generic-instance-select-one.png" width="1024" height="263" class="aligncenter size-full wp-image-56328" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. Click the <span style="background-color:#cccccc; font-weight:bold;"> Actions </span> button and select <span style="white-space: nowrap; font-weight:bold;">Image > Create Image</span>.

   <a href="/nginx/images/aws-generic-create-image-menu.png"><img src="/nginx/images/aws-generic-create-image-menu.png" alt="" width="1024" height="263" class="aligncenter size-full wp-image-56327" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

5. In the window that pops up, fill in the **Image name** and (optionally) **Image description** fields, then click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create image </span>  button.

   <a href="/nginx/images/aws-generic-create-image-popup.png"><img src="/nginx/images/aws-generic-create-image-popup.png" alt="screenshot of 'Create Image' pop-up window for creating base AMI in Amazon EC2" width="1024" height="525" class="aligncenter size-full wp-image-56326" /></a>

   A **Create Image** window pops up to confirm that the image‑creation request was received. To verify that the image was created, navigate to the **AMIs** tab.

### Revision History

- Version 2 (July 2018) – Substitute links to NGINX Plus Admin Guide for sample installation instructions.
- Version 1 (April 2018) – Initial version (NGINX Plus Release 14)
