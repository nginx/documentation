---
description: Create Microsoft Azure virtual machines for running NGINX Open Source
  and F5 NGINX Plus.
docs: DOCS-458
title: Creating Microsoft Azure Virtual Machines for NGINX Open Source and F5 NGINX
  Plus
toc: true
weight: 100
type:
- how-to
---

Follow this guide to install and run NGINX Open Source or NGINX Plus on a Microsoft Azure virtual machine.

This guide’s settings support [Active-Active HA for NGINX Plus on Microsoft Azure Using the Azure Standard Load Balancer]( https://docs.nginx.com/nginx/deployment-guides/microsoft-azure/high-availability-standard-load-balancer/). But you can repurpose your VMs for other tasks.

To speed up NGINX Plus deployment, get a prebuilt VM from [Microsoft Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps?search=NGINX%20Plus).There are various operating systems available. See [Installing NGINX Plus on Microsoft Azure]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus-microsoft-azure.md" >}}) for more details. 

<span id="prereqs"></span>
## Prerequisites

Azure Setup:

- Active Azure [account](https://azure.microsoft.com/en-us/free/).
- Azure [subscription](https://docs.microsoft.com/en-us/azure/azure-glossary-cloud-terminology?toc=/azure/virtual-network/toc.json#subscription).
- Azure [resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groups). In this guide, it is called <span style="color:#666666; font-weight:bolder; white-space: nowrap;">NGINX-Plus-HA</span>.
- Azure [virtual network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview).

For [Ansible Installation](#automate-ansible):
- Basic Linux system administration skills, including installation of Linux software from vendor‑supplied packages, and file creation and editing.

For NGINX installation:

- NGINX Plus subscription (paid or trial).
- `root` access or `sudo` privilege on your preferred host for NGINX Open Source and NGINX Plus. If appropriate for your environment, prefix commands with the `sudo` command.

<span id="create-vm"></span>
## Creating a Microsoft Azure Virtual Machine

1. Sign into the [Microsoft Azure portal](https://portal.azure.com/) (**<https://portal.azure.com/>**).

2. Click the Virtual machines icon. Or click the stacked lines icon (☰) in the top-left corner and select Virtual machines from the menu.
   <img src="/nginx/images/azure-portal.png" alt="screenshot of top navigation bar at Microsoft Azure portal" width="1024" height="226" class="aligncenter size-full image-64310" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. On the Virtual machines page that opens, click **<span style="color:#4d9bdc;">+</span> Add** in the upper left corner.

   <img src="/nginx/images/azure-create-vm-add-button.png" alt="screenshot of Azure 'Virtual machines' page" width="1024" height="195" class="aligncenter size-full image-64309" style="border:2px solid #666666; padding:2px; margin:2px;" />

   <span id="create-vm_Basics"></span>
4. In the **Create a virtual machine** window that opens, enter the requested information on the **Basics** tab. For this guide, enter the following values:

   - **Subscription** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">NGINX-Plus-HA-subscription</span>
   - **Resource group** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">NGINX-Plus-HA</span>
   - **Virtual machine name** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">ngx-plus-1</span> ngx-plus-1
For Active-Active HA for NGINX Plus on Microsoft Azure Using the Azure Standard Load Balancer, you’ll need six VMs. 

     The value <span style="color:#666666; font-weight:bolder; white-space: nowrap;">ngx-plus-1</span> is one of the six machines. See <a href="#create-vm_list">Step 7</a> below for the other values.

   - **Region** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">(US) West US 2</span>
   - **Availability options** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">No infrastructure redundancy required</span>

     This option is best for a demo like the one in this guide. For production deployments, deploy a copy of each VM in a different Availability Zone. For more information, see the [Azure documentation](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview).
   - **Image** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">Ubuntu Server 18.04 LTS</span>
   - **Azure Spot instance** – <span style="color:#666666; font-weight:bolder;">No</span>
   - **Size** – <span style="color:#666666; font-weight:bolder;">B1s</span> (click <span style="color:#2d89d6; white-space: nowrap;">Select size</span> to access the <span style="font-weight:bold; white-space: nowrap;">Select a VM size</span> window, click the **B1s** row, and click the <span style="background-color:#137ad1; color:white;"> Select </span> button to return to the **Basics** tab)
   - **Authentication type** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">SSH public key</span>
   - **Username** – <span style="color:#666666; font-weight:bolder;">nginx_azure</span>
   - **SSH public key source** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">Generate new key pair</span> (If you don’t want to generate a new key pair, use the existing key stored in your Azure account or an existing public key)
   - **Key pair name** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">nginx_key</span>
   - **Public inbound ports** – <span style="color:#666666; font-weight:bolder; white-space: nowrap;">Allow selected ports</span>
   - **Select inbound ports** – Select from the drop-down menu: <span style="color:#666666; font-weight:bolder; white-space: nowrap;">SSH (22)</span> and <span style="color:#666666; font-weight:bolder; white-space: nowrap;">HTTP (80)</span>, plus <span style="color:#666666; font-weight:bolder; white-space: nowrap;">HTTPS (443)</span> if you plan to configure NGINX and NGINX Plus for SSL/TLS

   <a href="/nginx/images/azure-create-vm-basics.png"><img src="/nginx/images/azure-create-vm-basics.png" alt="screenshot of 'Basics' tab on Azure 'Create a virtual machine' page" width="1024" height="1168" class="aligncenter size-full wp-image-64995" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   <span id="create-vm_Networking"></span>
5. For Active-Active HA for NGINX Plus on Microsoft Azure:

 Two VMs run NGINX Plus behind an Azure Load Balancer. And both VMs require **Standard** SKU public IP addresses. By default, Azure assigns **Basic** SKU IPs. So, you must manually change this during VM setup.

To avoid errors, allocate **Standard** public IP addresses to the six VMs you’ll use in the deployment. 
Follow these steps to allocate:
  - Open the **Networking** tab on the **Create a virtual machine** window.
  - Click <span style="color:#2d89d6; white-space: nowrap;"> Create new </span> below the **Public IP** field.
  - In the **Create public IP address column** that opens, click the **Standard Radio button** under **SKU**. 
  - In the **Name** field, accept the default created by Azure, ngx-plus-1-ip. 
  - Click the <span style="background-color:#137ad1; color:white;">Ok</span>  button.

When this guide was first published, the hourly cost for the six VMs was only $0.008. And this costlier than VMs with basic IP addresses. For current pricing, see the Microsoft documentation.

   <a href="/nginx/images/azure-create-vm-networking.png"><img src="/nginx/images/azure-create-vm-networking.png" alt="screenshot of 'Networking' tab on Azure 'Create a virtual machine' page" width="1024" height="718" class="aligncenter size-full wp-image-64994" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

6. Here, you can select non-default values on the **Disks**, **Networking**, **Management**, **Advanced**, and **Tags** tabs. In our demo, for example, Premium SS Standard HDD for OS disk type on the **Disks** tab is more affordable than the default, Premium SSD. You can also create or apply tags to your VM via the **Tags** tab.

   After you've completed your changes, click the <span style="background-color:#137ad1; color:white; white-space: nowrap;"> Review + create </span> button at the bottom of the **Create a virtual machine** page.

   You’ll find a summary of your setting under the **Validation passed** banner. Ensure they’re suitable. Then, click on <span style="background-color:#137ad1; color:white;"> Create </span> 

   If you generated a new key pair in [Step 4](#create-vm_Basics), a <span style="white-space: nowrap; font-weight:bold;">Generate new key pair</span> window pops up. Click on <span style="background-color:#137ad1; color:white; white-space: nowrap;"> Download key and create private resource </span> button.

   <a href="/nginx/images/azure-create-vm-validation-passed.png"><img src="/nginx/images/azure-create-vm-validation-passed.png" alt="screenshot of validation message on Azure 'Create a virtual machine' page" width="1024" height="954" class="aligncenter size-full image-64993" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   VM deployment only takes a few minutes. After that, you’ll get a summary of your resources. Just like in the following screenshot. 

   <a href="/nginx/images/azure-create-vm-deployment-complete.png"><img src="/nginx/images/azure-create-vm-deployment-complete.png" alt="screenshot of Azure 'CreateVM-Canonical' page" width="1024" height="634" class="aligncenter size-full image-64992" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   <span id="create-vm_list"></span>
7. If you’re creating 6 VMs for [Active-Active HA for NGINX Plus on Microsoft Azure Using the Azure Standard Load Balancer]({{< ref "high-availability-standard-load-balancer.md" >}}), use the following names:

   - <span style="color:#666666; font-weight:bolder;">ngx-plus-1</span>
   - <span style="color:#666666; font-weight:bolder;">ngx-plus-2</span>
   - <span style="color:#666666; font-weight:bolder;">ngx-oss-app1-1</span>
   - <span style="color:#666666; font-weight:bolder;">ngx-oss-app1-2</span>
   - <span style="color:#666666; font-weight:bolder;">ngx-oss-app2-1</span>
   - <span style="color:#666666; font-weight:bolder;">ngx-oss-app2-2</span>

   For <span style="color:#666666; font-weight:bolder;">ngx-plus-2</span> (2nd NGINX Plus VM), repeat Steps 2 to 6 above or purchase a pre built VM from the [Microsoft Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps?search=NGINX%20Plus)).

  NGINX Open Source VMs gives you two options: Create each VM manually by following steps 2 to 6.Or, make one template VM (named  <span style="color:#666666; font-weight:bolder; white-space: nowrap;">nginx-oss</span>), [install the NGINX Open Source software](#install-nginx) on it, and clone that VM into three more copies using Azure image. For that, follow the instructions in [Optional: Creating an NGINX Open Source Image](#create-nginx-oss-image).

<span id="connect-vm"></span>
## Connecting to a Virtual Machine

To install and configure NGINX Open Source or NGINX Plus on a VM, open a terminal window and connect to the VM over SSH. Do like so: 

1. Navigate to the **Virtual machines** page on the Azure dashboard and click the VM's name in the **Name** column of the table.

   <a href="/nginx/images/azure-create-vm-virtual-machines.png"><img src="/nginx/images/azure-create-vm-virtual-machines.png" alt="screenshot of Azure 'Virtual machines' page with list of VMs" width="1024" height="396" class="aligncenter size-full wp-image-64991" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

2. On the page that opens (<span style="white-space: nowrap; font-weight:bold;">ngx-plus-1</span> in this guide), note or write down the VM's public IP address (in the <span style="white-space: nowrap; font-weight:bold;">Public IP address</span> field in the right column).

   <a href="/nginx/images/azure-create-vm-ngx-plus-1.png"><img src="/nginx/images/azure-create-vm-ngx-plus-1.png" alt="screenshot of details page for 'ngx-plus-1' VM in Azure" width="1024" height="363" class="aligncenter size-full wp-image-64990" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. Run this command to confirm an SSH connection to the VM:

   ```shell
   ssh -i <private-key-file> <username>@<public-IP-address>
   ```

   Note:

   - `<private-key-file>` contains the private key paired with the public key you entered in the <span style="white-space: nowrap; font-weight:bold;">SSH public key</span> field in <a href="#create-vm_Basics">Step 4</a> of _Creating a Microsoft Azure Virtual Machine_.
   - `<username>` is the name you entered in the **Username** field in <a href="#create-vm_Basics">Step 4</a> of _Creating a Microsoft Azure Virtual Machine_. In this guide, it is <span style="color:#666666; font-weight:bolder;">nginx_azure</span>).
   - `<public-IP-address>` is the address you looked up in the previous step.

<span id="install-nginx"></span>
## Installing NGINX Software

Once you have established a connection with an instance, you can install the NGINX software on it. Follow the instructions in the NGINX Plus Admin Guide for <a href="../../../admin-guide/installing-nginx/installing-nginx-open-source/index.html#prebuilt">NGINX Open Source</a> and [NGINX Plus]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). The [Admin Guide]({{< ref "/nginx/admin-guide/" >}}) also provides instructions for many maintenance tasks.

<span id="automate"></span>
### Automating Installation with a Configuration Manager

You can automate the installation of NGINX Open Source and NGINX Plus. Instructions for Ansible are provided below. For Chef and Puppet, see these articles on the NGINX blog:

- [Installing NGINX and NGINX Plus with Chef](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/)
- [Deploying NGINX Plus for High Availability with Chef](https://www.nginx.com/blog/nginx-plus-high-availability-chef/)
- [Installing NGINX and NGINX Plus with Puppet](https://www.nginx.com/blog/installing-nginx-nginx-plus-puppet/)

<span id="automate-ansible"></span>
#### Automating Installation with Ansible

NGINX publishes a unified Ansible role for NGINX Open Source and NGINX Plus on [Ansible Galaxy](https://galaxy.ansible.com/nginxinc/nginx/) and [GitHub](https://github.com/nginxinc/ansible-role-nginx). Perform these steps to install and run it.

1. [Connect to the VM](#connect-vm).

2. Install Ansible. These commands are appropriate for Debian and Ubuntu systems:

   ```shell
   apt update
   apt install python-pip -y
   pip install ansible
   ```

3. Install the official Ansible role from NGINX:

   ```shell
   ansible-galaxy install nginxinc.nginx
   ```

4. (NGINX Plus only) Copy the <span style="white-space: nowrap; font-weight:bold;">nginx-repo.key</span> and <span style="white-space: nowrap; font-weight:bold;">nginx-repo.crt</span> files provided by NGINX to <span style="white-space: nowrap; font-weight:bold;">~/.ssh/ngx-certs/</span>.

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

<span id="create-nginx-oss-image"></span>
## Optional: Creating an NGINX Open Source Image

To streamline the process of installing NGINX Open Source on multiple VMs, you can create a Microsoft Azure image from an existing NGINX Open Source VM, and spin up additional instances of the image when needed.

1. [Install NGINX Open Source](#install-nginx) on the source VM, if you haven't already.

2. Navigate to the **Virtual machines** page, if you are not already there.

2. In the list of VMs, click the name of the one to use as a source image (in this guide, we have called it <span style="color:#666666; font-weight:bolder; white-space: nowrap;">ngx-oss</span>). Remember that NGINX Open Source needs to be installed on it already.

3. On the page than opens, click the **Capture** icon in the top navigation bar.

   <a href="/nginx/images/azure-create-image-ngx-oss.png"><img src="/nginx/images/azure-create-image-ngx-oss.png" alt="screenshot of details page for 'nginx-oss' VM in Azure" width="1024" height="363" class="aligncenter size-full wp-image-64989" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. On the **Create image** page that opens, take note of the informational and warning banners and take any necessary action. Note in particular that if you use one of the VMs you created in [Creating a Microsoft Azure Virtual Machine](#create-vm) as the source for the image, you will need to re‑create a VM with that name.

   Then select the following values:

   - **Name** – Keep the current value.
   - **Resource group** – Select the appropriate resource group from the drop‑down menu. Here it is <span style="color:#666666; font-weight:bolder; white-space: nowrap;">NGINX-Plus-HA</span>.
   - **Automatically delete this virtual machine after creating the image** – We recommend checking the box, since you can't do anything more with the image anyway.
   - **Zone resiliency** – <span style="color:#666666; font-weight:bolder;">On</span>.
   - **Type the virtual machine name** – Name of the source VM (<span style="color:#666666; font-weight:bolder; white-space: nowrap;">ngx-oss</span> in this guide).

   Click the <span style="background-color:#137ad1; color:white;"> Create </span> button.

   <a href="/nginx/images/azure-create-image-create-image.png"><img src="/nginx/images/azure-create-image-create-image.png" alt="screenshot of Azure 'Create Image' page" width="1024" height="722" class="aligncenter size-full wp-image-64988" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

### Creating a VM from the Image

It takes a few moments for the image to be created. When it's ready, you can create VMs from it with NGINX Open Source already installed.

1. Navigate to the **Images** page. (One method is to type <span style="color:#666666; font-weight:bolder;">images</span> in the search box in the Microsoft Azure header bar and select that value in the **Services** section of the resulting drop‑down menu.)

   <a href="/nginx/images/azure-create-image-images.png"><img src="/nginx/images/azure-create-image-images.png" alt="screenshot of Azure 'Images' page" width="1024" height="349" class="aligncenter size-full wp-image-64987" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

2. Click the image name in the table. On the page that opens, click **<span style="color:#4d9bdc;">+</span> Create VM** in the top navigation bar.

   <a href="/nginx/images/azure-create-image-create-vm.png"><img src="/nginx/images/azure-create-image-create-vm.png" alt="screenshot of details page for Azure 'ngx-plus-1-image' image" width="1024" height="426" class="aligncenter size-full wp-image-64986" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

The **Create a virtual machine** page that opens is the same as in Step 4 of Creating a Microsoft Azure Virtual Machine, except that some fields have hardcoded values derived from the image and the **Image** field has the name of the image instead of an operating system. Return to that [step](#create-vm_Basics) to complete the VM creation.

### Revision History

- Version 1 (September 2020) – Initial version (NGINX Plus Release 22)
