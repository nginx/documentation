---
description: Install F5 NGINX Plus as a virtual machine image on Microsoft Azure,
  to provide sophisticated Layer 7 load balancing for your apps.
docs: DOCS-413
title: Installing NGINX Plus on Microsoft Azure
toc: true
weight: 500
type:
- how-to
---

[F5 NGINX Plus](https://www.f5.com/products/nginx/nginx-plus), the high-performance application delivery platform, load balancer, and web server, is available at the Microsoft Azure Marketplace as a virtual machine (VM) image.

The VM image contains the latest version of NGINX Plus, optimized for use with Azure.

## Installing the NGINX Plus VM

To quickly set up an NGINX Plus environment on Microsoft Azure:

1. Follow the instructions in <span style="white-space: nowrap;">[Create a Virtual Machine Running Linux](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal)</span> to sign up on Azure and get more information about Azure itself.
2. Search for “NGINX Plus” in the [Azure Marketplace](https://azure.microsoft.com/en-us/marketplace/), open the VM image, and follow the installation instructions.

3. Create an Azure _availability set_ of two or more NGINX Plus virtual machines, which adds redundancy to your NGINX Plus setup by ensuring that at least one virtual machine remains available during a planned or unplanned maintenance event on the Azure platform. For more information, see <span style="white-space: nowrap;">[Manage the availability of Linux virtual machines](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/manage-availability?)</span> in the Azure documentation.

4. Create _endpoints_ to enable clients outside the NGINX Plus virtual machine’s cloud or virtual network to access it. Sign in to the Azure Management Portal and add endpoints manually to handle the inbound network traffic on port 80 (HTTP) and port 443 (HTTPS). For more information, see <span style="white-space: nowrap;">[How to set up endpoints on a Linux classic virtual machine in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/classic/setup-endpoints)</span> in the Azure documentation.

5. As soon as the new virtual machine launches, NGINX Plus starts automatically and serves a default **index.html** page. To verify that NGINX Plus is working properly, use a web browser to access the public DNS name of the new virtual machine and view the page. You can also check the status of the NGINX Plus server by logging into the virtual machine and running this command:

	```none
	/etc/init.d/nginx status
	```

## What If I Need Help?

If you encounter any problems with NGINX Plus configuration, documentation is available at [nginx.org](https://nginx.org/en/docs/) and in the [NGINX Plus Admin Guide]({{< ref "/nginx/admin-guide/installing-nginx/" >}}).

Customers who purchase an NGINX Plus VM image at the Azure Marketplace are eligible for the Azure VM support provided by the NGINX, Inc. engineering team. To activate support, submit the [Azure support activation](https://www.nginx.com/azure-support-activation/) form (you need your Azure subscription ID). When you request support, we’ll ask you to provide the Azure subscription ID that you registered, along with the deployment IDs of your Azure virtual machines in some cases.
