---
title: Manually update the WAF compiler
description: Download and install the WAF compiler manually from MyF5 when your system can’t access the public NGINX repository.
toc: true
weight: 400
nd-content-type: how-to
nd-product: NIMNGR
---

If your NGINX Instance Manager host doesn’t have access to the public NGINX repository, you can manually download and install the WAF compiler from [MyF5](https://my.f5.com/).

---

## Install the WAF compiler manually

1. Log in to [MyF5](https://my.f5.com).  
1. Go to **Resources > Downloads**.  
1. Select the following options:
   - **Group/Product Family:** **NGINX**
   - **Product Line:** **F5 WAF**
   - Choose the **Product version** that matches your environment.
   - Select the appropriate **Linux distribution**, **version**, and **architecture**.
1. Download the `.deb` or `.rpm` file for the WAF compiler.  
1. Transfer the file to your NGINX Instance Manager host.  
1. Install the WAF compiler:

   - **Debian or Ubuntu**

     ```shell
     sudo apt-get install -f /path/to/nms-nap-compiler-<version>_focal_amd64.deb
     ```

     To install multiple compiler versions on the same system, use:

     ```shell
     sudo apt-get install -f \
       /path/to/nms-nap-compiler-<version>_focal_amd64.deb \
       -o Dpkg::Options::="--force-overwrite"
     ```

   - **RHEL, CentOS, or Oracle Linux**

     ```shell
     sudo yum install -f /path/to/nms-nap-compiler-<version>_el8.ngx.x86_64.rpm
     ```

1. {{< include "nim/waf/restart-nms-integrations.md" >}}