---
title: Create Microsoft Azure virtual machines for NGINX Open Source and F5 NGINX Plus
toc: true
weight: 100
nd-content-type: how-to
nd-product: NGPLUS
nd-docs: DOCS-458
---

This topic describes how to create Microsoft Azure virtual machines (VMs) to run NGINX Open Source or NGINX Plus.

The names and settings in this document are consistent with [Active-Active HA for NGINX Plus on Microsoft Azure Using the Azure Standard Load Balancer]({{< ref "/nginx/deployment-guides/microsoft-azure/high-availability-standard-load-balancer.md" >}}), but these VMs can be used for any purpose.

For faster NGINX Plus deployments, you can get a prebuilt VM from the [Microsoft Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps?search=NGINX%20Plus).

View the [Installing NGINX Plus on Microsoft Azure]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus-microsoft-azure.md" >}}) topic for more details. 

## Before you begin

To complete this guide, you will need the following prerequisites:

- An Azure [account](https://azure.microsoft.com/en-us/free/).
- An Azure [subscription](https://docs.microsoft.com/en-us/azure/azure-glossary-cloud-terminology?toc=/azure/virtual-network/toc.json#subscription).
- An Azure [resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groups): in this topic, it is called **NGINX-Plus-HA**.
- An Azure [virtual network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview).
- `root` access or `sudo` privilege on your preferred host

If you wish to use NGINX Plus, you will need an NGINX Plus subscription (Paid or trial).

## Create a Microsoft Azure virtual machine

To begin, log in to the [Microsoft Azure portal](https://portal.azure.com/).

Then select **Virtual machines** from the landing page of the Microsoft Azure portal, or the menu in the top-left corner of the page.

{{< img src="/nginx/images/azure-portal.png" alt="The top of the Microsoft Azure portal, showing a row of available services. The second item in the row is Virtual machines option and icon" >}}

On the Virtual machines page, select **+ Add** in the upper left corner.

{{< img src="/nginx/images/azure-create-vm-add-button.png" alt="The top of the Virtual machines page, which has a menu of interactive items starting with an Add button" >}}

In the **Create a virtual machine** window that opens, enter the following information on the **Basics** tab:

{{< table >}}

| Name | Value |
| ---- | ----- |
| Subscription | NGINX-Plus-HA-subscription |
| Resource group | NGINX-Plus-HA |
| Virtual machine name | ngx-plus-1 **(1)** |
| Region | (US) West US 2 |
| Availability options | No infrastructure redundancy required **(2)** |
| Image | Ubuntu Server 18.04 LTS |
| Azure Spot instance | No |
| Size | B1s **(3)** |
| Authentication type | SSH public key |
| Username | nginx_azure |
| SSH public key source | Generate new key pair |
| Key pair name | nginx_key |
| Public inbound ports | Allow selected ports |
| Select inbound ports | **(4)** |

{{< /table >}}

1. The value **ngx-plus-1** is one of the six used for VMs in [Active-Active HA for NGINX Plus on Microsoft Azure Using the Azure Standard Load Balancer]({{< ref "high-availability-standard-load-balancer.md" >}}).
1. This option is suitable for testing. For production deployments we recommend deploying a copy of each VM in a different Availability Zone.
1. Select _Select size_ to access the _Select a VM size_ window, choose the _B1s_ row, and press the _Select_ button to return to the _Basics_ tab.
1. Select **SSH (22)** and **HTTP (80)** from the drop-down menu. You should also select **HTTPS (443)** if you plan to configure NGINX and NGINX Plus for SSL/TLS.

{{< img src="/nginx/images/azure-create-vm-basics.png" alt="The 'Basics' tab of the 'Create a virtual machine' page, showing the form of parameters to fill" >}}

Once you have filled out the information of the _Basics_ tab, select the _Networking_ tab underneath the page heading.

Select  _Create new_ below the **Public IP** field, then select the **Standard Radio button** under **SKU** inn the **Create public IP address column** that opens.

In the **Name** field, accept the default created by Azure, _ngx-plus-1-ip_, and confirm it by selecting **Ok**.

{{< call-out "note" "Active-Active HA requirements" >}}

If you are creating VMs to use with [Active-Active HA for NGINX Plus]({{< ref "/nginx/deployment-guides/microsoft-azure/high-availability-standard-load-balancer.md" >}}), the two VMs must have public IP addresses with SKU type **Standard** instead of the default **Basic**.

If you’re creating 6 VMs for [Active-Active HA for NGINX Plus]({{< ref "high-availability-standard-load-balancer.md" >}}), use the following names:

- **ngx-plus-1**
- **ngx-plus-2**
- **ngx-oss-app1-1**
- **ngx-oss-app1-2**
- **ngx-oss-app2-1**
- **ngx-oss-app2-2**

For _ngx-plus-2_, repeat the previous steps or get a pre built VM from the [Microsoft Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps?search=NGINX%20Plus)).

For the _ngx-oss-*_, you can create each VM manually or follow the [Create an NGINX Open Source image](#create-an-an-nginx-open-source-image) steps to clone additional copies.

{{< /call-out >}}

{{< img src="nginx/images/azure-create-vm-networking.png" alt="The 'Networking' tab of Azure's 'Create a virtual machine' page" >}}

Before continuing, there are some values you may wish to change from the default under the  **Disks**, **Networking**, **Management**, **Advanced**, and **Tags** tabs. 

By default, Azure assigns **Premium SSD** for the OS disk on the disk tab, but you can choose a cheaper option like **Standard HDD**.

After you've completed your changes, select _Review + create_ at the bottom of the **Create a virtual machine** page.

Your settings will be summarized under the **Validation passed** banner. Ensure they’re correct, then select **Create**. 

Based on the setting in the _Basics_ tab, a _Generate new key pair_ window will appear. Select _Download key and create private resource_.

{{< img src="/nginx/images/azure-create-vm-validation-passed.png" alt="The 'Review + create' tab of the 'Create a virtual machine' page page" >}}

The VM deployment will take a few minutes, after which you will see a summary of your resources.

{{< img src="/nginx/images/azure-create-vm-deployment-complete.png" alt="The overview screen of a deployment, showing the resources created during the process" >}}

## Connect to the virtual machine

To install and configure NGINX Open Source or NGINX Plus on a VM, you will need to connect to the VM with SSH. 

Go to the **Virtual machines** page on the Azure dashboard and click the VM's name in the **Name** column of the table.

{{< img src="/nginx/images/azure-create-vm-virtual-machines.png" alt="The 'Virtual machines' page, showing a single item named 'nginx-plus-1'" >}}

On the page that opens (**ngx-plus-1** in this example), note the VM's public IP address (In the **Public IP address** field in the right column).

{{< img src="/nginx/images/azure-create-vm-ngx-plus-1.png" alt="The page for the 'nginx-plus-1' virtual machine, showing its details" >}}

Run this command to confirm an SSH connection to the VM:

```shell
ssh -i <private-key-file> <username>@<public-IP-address>
```

- `<private-key-file>` contains the private key paired with the public key you entered in the _SSH public key_ field during _Create a Microsoft Azure virtual Machine_
- `<username>` is the name you entered in the **Username** field during _Create a Microsoft Azure virtual Machine_. In this example, it is _nginx_azure_.
- `<public-IP-address>` is the address you found during the previous step.

## Install NGINX Open Source or NGINX Plus

After you’ve successfully connected to your Azure VM, you can install NGINX Open Source or NGINX Plus on it.

- [Installing NGINX Open Source]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source.md" >}})
- [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}})

## Install NGINX Open Source or NGINX Plus with Ansible

{{< call-out "note" >}}

For Chef and Puppet, see the following articles on the NGINX blog:

- [Installing NGINX and NGINX Plus with Chef](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/)
- [Deploying NGINX Plus for High Availability with Chef](https://www.nginx.com/blog/nginx-plus-high-availability-chef/)
- [Installing NGINX and NGINX Plus with Puppet](https://www.nginx.com/blog/installing-nginx-nginx-plus-puppet/)

{{< /call-out >}}

NGINX provides automatic setup files for Open Source and Plus versions on [Ansible Galaxy](https://galaxy.ansible.com/nginxinc/nginx/) and [GitHub](https://github.com/nginxinc/ansible-role-nginx). 

The following instructions use the _apt_ package manager, and should be adapted to your operating system.

You should first [connect to the virtual machine](#connect-to-the-virtual-machine), then install Ansible:

```shell
apt update
apt install python-pip -y
pip install ansible
```

Once Ansible is installed, you can use `ansible-galaxy` to install the official Ansible role from NGINX:

```shell
ansible-galaxy install nginxinc.nginx
```

{{< call-out "note" "NGINX Plus" >}}

If you are using NGINX Plus, at this stage you should copy the **nginx-repo.key** and **nginx-repo.crt** files from [MyF5](https://my.f5.com/manage/s/) to **~/.ssh/ngx-certs/**.

{{< /call-out >}}

Create a file called **playbook.yml** with the following contents:

```yaml
---
- hosts: localhost
   become: true
   roles:
      - role: nginxinc.nginx
```

Then use `ansible-playbook` to run it:

```shell
ansible-playbook playbook.yml
```

## Create an an NGINX Open Source image

If you've [Installed NGINX Open Source]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source.md" >}}) correctly on one VM, you can save it as an Azure template to make additional copies, avoiding the need to follow the full installation process.

Navigate to the **Virtual machines** page, then select the name of the VM to use as a source image in the list (Named **ngx-oss** in this example).

On the details page that opens, select the **Capture** icon in the top navigation bar.

{{< img src="/nginx/images/azure-create-image-ngx-oss.png" alt="The details page for the 'nginx-oss' VM in Azure" >}}

If you use one of the VMs you created in [Create a Microsoft Azure virtual machine](#create-a-microsoft-azure-virtual-machine) as the source for the image, you will need to re‑create a VM with that name.

Then edit the following values:

- **Name** – Keep the current value.
- **Resource group** – Select the appropriate resource group from the drop‑down menu (**NGINX-Plus-HA**)
- **Automatically delete this virtual machine after creating the image** – Yes
- **Zone resiliency** – **On**
- **Type the virtual machine name** – Name of the source VM (**ngx-oss** in this guide)

After reviewing the changed values, select the **Create** button.

{{< img src="/nginx/images/azure-create-image-create-image.png" alt="The 'Create image' page for the 'nginx-oss' VM" >}}

### Create a virtual machine from an NGINX Open Source image

Once the Azure image has been deployed, you can use it to create VMs with NGINX Open Source pre-installed.

Navigate to the **Images** page of the Microsoft Azure portal.

{{< img src="/nginx/images/azure-create-image-images.png" alt="The 'Images' page of the Microsoft Azure portal" >}}

Select the image name in the table, then select **+ Create VM** at the top of the main screen of the next page.

{{< img src="/nginx/images/azure-create-image-create-vm.png" alt="The 'Details' page of the 'nginx-oss-image'" >}}

The **Create a VM** page is identical to the one from [Create a Microsoft Azure virtual machine](#create-a-microsoft-azure-virtual-machine), but will have some pre-filled fields from your image.

For example, the **Image** field now shows the image name instead of an operating system. 

You can continue finishing the VM creation process as normal from here, re-using the image whenever necessary.