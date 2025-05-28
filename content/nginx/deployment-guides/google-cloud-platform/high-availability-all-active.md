---
description: Configure highly available F5 NGINX Plus load balancing of application
  instances, in an all-active deployment on the Google Cloud Platform.
docs: DOCS-450
title: All-Active HA for NGINX Plus on the Google Cloud Platform
toc: true
weight: 100
type:
- how-to
---

This guide explains how to deploy F5 NGINX Plus in a high-availability configuration on Google Compute Engine (GCE). GCE is the Google Cloud Platform (GCP) service for running workloads on virtual machines. In this setup, multiple NGINX Plus instances work together, in active pairs. They load balance incoming connections across your app environments.


**Notes:**

- The GCE environment changes constantly. This could include names and arrangements of GUI elements. This guide was accurate when published. But, some GCE GUI elements might have changed over time. Use this guide as a reference and adapt to the current GCE working environment.
- The configuration described in this guide allows anyone from a public IP address to access the NGINX Plus instances. While this works in common scenarios in a test environment, we do not recommend it in production. Block external HTTP/HTTPS access to **app&#8209;1** and **app&#8209;2** instances to external IP address before production deployment. Alternatively, remove the external IP addresses for all application instances, so they're accessible only on the internal GCE network.



<span id="design"></span>
## Design and Topology

The deployment combines the following technologies:

- [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) – Load balances HTTP connections across multiple instances of two applications. We provide instructions for manual installation on a GCE VM image and setting up the prebuilt NGINX Plus VM image. Both are available in the Google Marketplace.
- PHP-FPM – Supports the two sample applications.
- [GCE network load balancer](https://cloud.google.com/compute/docs/load-balancing/network) – Enables TCP connectivity between clients and NGINX Plus load-balancing (LB) instances in a GCP region. It also maintains session persistence for each NGINX Plus instance.
- [GCE instance groups](https://cloud.google.com/compute/docs/instance-groups) – Provide a mechanism for managing a group of VM instances as a unit.
- [GCE health checks](https://cloud.google.com/compute/docs/load-balancing/health-checks) – Maintain high availability of the NGINX Plus LB instances by controlling when GCE creates a new LB instance in the instance group.

<img src="/nginx/images/gce-all-active-load-balancing-topology.png" alt="Topology of the all‑active deployment of NGINX Plus as the Google Cloud Platform load balancer." width="1024" height="1000" class="aligncenter size-full wp-image-47509" style="border:2px solid #666666; padding:2px; margin:2px;" />

[Session persistence](https://www.nginx.com/products/nginx/load-balancing/#session-persistence) is managed at the network layer by the GCE network load balancer (based on client IP address). The NGINX Plus LB instance also manages it at the application layer (with a session cookie).

The GCE network LB assigns each new client to a specific NGINX Plus LB. This association persists as long as the LB instance is up and functional.

NGINX Plus LB uses the round-robin algorithm to forward requests to specific app instances. It also adds a session cookie. It keeps future requests from the same client on the same app instance as long as it's running.

This deployment guide uses two groups of app instances: – **app&#8209;1** and **app&#8209;2**. It demonstrates [load balancing](https://www.nginx.com/products/nginx/load-balancing/) between different app types. But both groups have the same app configurations.

You can adapt the deployment to distribute unique connections to different groups of app instances. This can be done by creating discrete upstream blocks and routing content based on the URI.

Please see the reference docs for details on configuring multiple [upstream server groups](https://nginx.org/en/docs/http/ngx_http_upstream_module.html).

<span id="prereqs"></span>
## Prerequisites

This guide assumes that you:

- Have a [Google account](https://accounts.google.com/SignUp) (a separate GCP or GCE account is unnecessary).
- Have enrolled in a [free trial](https://cloud.google.com/free-trial) available credit or have a GCP payment account.
- Have a basic working knowledge of GCE and its GUI control panel:
  - Navigation
  - Creating instances
  - Managing IAM policies
- Understand basic networking.
- Have an NGINX Plus subscription. You can start a [free 30‑day trial](https://www.nginx.com/free-trial-request/) if you don't already have a paid subscription.
- Know how to install NGINX Plus. Have a basic understanding of performance in load balancing and application delivery modes. Be familiar with its configuration syntax.
- Are familiar with GitHub and know how to [clone a repository](https://help.github.com/en/articles/cloning-a-repository/).

All component names, like projects and instances, are examples only. You can change them to suit your needs.

<span id="project-firewall"></span>
## Task 1: Creating a Project and Firewall Rules

Create a new GCE project to host the all‑active NGINX Plus deployment.

1. Log into the [GCP Console](http://console.cloud.google.com) at **console.cloud.google.com**.

2. The GCP **Home&nbsp;>&nbsp;Dashboard** tab opens. Its contents depend on whether you have any existing projects.

   - If there are no existing projects, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create a project </span> button.

     <img src="/nginx/images/gce-dashboard-no-project.png" alt="Screenshot of the Google Cloud Platform dashboard that appears when there are no existing projects (creating a project is the first step in configuring NGINX Plus as the Google Cloud load balancer)" width="1024" height="422" class="aligncenter size-full wp-image-47475" style="border:2px solid #666666; padding:2px; margin:2px;" />

   - If there are existing projects, the name of one of them appears in the upper left of the blue header bar (in the screenshot, it's <span style="background-color:#3366cc; color:white; white-space: nowrap;"> My Test Project </span>). Click the project name and select **Create&nbsp;project** from the menu that opens.

     <img src="/nginx/images/gce-dashboard-existing-project.png" alt="Screenshot of the Google Cloud Platform page that appears when other projects already exist (creating a project is the first step in configuring NGINX Plus as the Google Cloud load balancer)" width="1024" height="533" class="aligncenter size-full wp-image-47474" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. Type your project name in the **New&nbsp;Project** window that pops up, then click <span style="color:#3366cc;">CREATE</span>. We're naming the project **NGINX Plus&nbsp;All&#8209;Active&#8209;LB**.

    <img src="/nginx/images/gce-new-project-popup.png" alt="Screenshot of the New Project pop-up window for naming a new project on the Google Cloud Platform, which is the first step in configuring NGINX Plus as the Google load balancer" width="512" height="249" class="aligncenter size-full wp-image-47514" style="border:2px solid #666666; padding:2px; margin:2px;" />

### Creating Firewall Rules

Create firewall rules that allow access to the HTTP and HTTPS ports on your GCE instances. You'll attach the rules to all the instances you create for the deployment.

1. Navigate to the **Networking&nbsp;>&nbsp;Firewall&nbsp;rules** tab and click <span style="background-color:#3366cc; color:white;"> + </span> <span style="color:#3366cc;">CREATE FIREWALL RULE</span>. (The screenshot shows the default rules provided by GCE.)

   <img src="/nginx/images/gce-firewall-rules-tab.png" alt="Screenshot of the Google Cloud Platform page for defining new firewall rules; when configuring NGINX Plus as the Google Cloud load balancer, we open ports 80, 443, and 8080 for it." width="1024" height="413" class="aligncenter size-full wp-image-47476" style="border:2px solid #666666; padding:2px; margin:2px;" />

2. Fill in the fields on the **Create&nbsp;a&nbsp;firewall&nbsp;rule** screen that opens:<!-- Tony notes Feb 2018: I have purposely broken the "rule" that if any bullet in a list ends in a period (here, bullet 3), they all must. I think the appropriate values in bullets 1, 2, and 4 are clearer without a final period -->

   - **Name** – **nginx&#8209;plus&#8209;http&#8209;fw&#8209;rule**
   - **Description** – **Allow access to ports 80, 8080, and 443 on all NGINX Plus instances**
   - **Source&nbsp;filter** – On the drop-down menu, select either **Allow from any source (0.0.0.0/0)**, or **IP&nbsp;range** if you want to restrict access to users on your private network. In the second case, fill in the **Source&nbsp;IP&nbsp;ranges** field that opens. In the screenshot, we are allowing unrestricted access.
   - **Allowed&nbsp;protocols&nbsp;and&nbsp;ports** – **tcp:80;&nbsp;tcp:8080;&nbsp;tcp:443**

     **Note:** As noted in the introduction, allowing access from any public IP address is appropriate only in a test environment. Before deploying the architecture in production, create a firewall rule. Use this rule to block access to the external IP address for your application instances. Alternatively, you can disable external IP addresses for the instances. This limits access only to the internal GCE network.

   - **Target&nbsp;tags** – **nginx&#8209;plus&#8209;http&#8209;fw&#8209;rule**

   <img src="/nginx/images/gce-create-firewall-rule.png" alt="Screenshot of the interface for creating a Google Compute Engine (GCE) firewall rule, used during deployment of NGINX Plus as the Google load balancer." width="1024" height="619" class="aligncenter size-full wp-image-47470" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. Click the <span style="background-color:#3366cc; color:white;"> Create </span> button. The new rule is added to the table on the **Firewall&nbsp;rules** tab.

<span id="source"></span>
## Task 2: Creating Source Instances

Create three GCE source instances. Use them as templates for later instance groups. One for the NGINX Plus load balancer and two for NGINX Plus PHP app servers.

You can create source instances in either of two ways:

- [Based on a standard GCE VM image](#source-vm), you install NGINX Plus manually. This guide uses the latest Ubuntu LTS image at publication (<span style="white-space: nowrap;">Ubuntu 24.04 LTS</span>). You can use any Unix or Linux OS that [NGINX Plus supports]({{< ref "nginx/technical-specs.md" >}}).
- [Based on the prebuilt NGINX Plus image](#source-prebuilt) in the Google Marketplace, which at the time of publication runs on <span style="white-space: nowrap;">Ubuntu 14.04 LTS</span>.

The methods to create a source instance are different. Once you've created the source instances, all later instructions are the same.

<span id="source-vm"></span>
### Creating Source Instances from VM Images

Create three source VM instances based on a GCE VM image. We're basing our instances on the <span style="white-space: nowrap;">Ubuntu 16.04 LTS</span> image.

1. Verify that the **NGINX Plus&nbsp;All&#8209;Active&#8209;LB** project is still selected in the Google Cloud Platform header bar.

2. Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** tab.

3. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create instance </span> button. The **Create&nbsp;an&nbsp;instance** page opens.

<span id="source-vm-app-1"></span>
#### Creating the First Application Instance from a VM Image

1. On the **Create&nbsp;an&nbsp;instance** page, modify or verify the fields and checkboxes as indicated (a screenshot of the completed page appears in the next step):

   - **Name** – **nginx&#8209;plus&#8209;app&#8209;1**
   - **Zone** – The GCP zone that makes sense for your location. We're using **us&#8209;west1&#8209;a**.
   - **Machine&nbsp;type** – The appropriate size for the level of traffic you anticipate. We're selecting **micro**, which is ideal for testing purposes.
   - **Boot&nbsp;disk** – Click **Change**. The **Boot&nbsp;disk** page opens to the <span style="color:#3366cc; white-space: nowrap;">OS images</span> subtab. Perform the following steps:

      - Click the radio button for the Unix or Linux image of your choice (here, **Ubuntu&nbsp;16.04&nbsp;LTS**).
      - Accept the default values in the **Boot&nbsp;disk&nbsp;type** and **Size&nbsp;(GB)** fields (**Standard&nbsp;persistent&nbsp;disk** and **10** respectively).
      - Click the <span style="background-color:#3366cc; color:white;"> Select </span> button.

      <img src="/nginx/images/gce-ubuntu-instance-boot-disk.png" alt="Screenshot of the 'Boot disk' page in Google Cloud Platform for selecting the OS on which a VM runs. In the deployment of NGINX Plus as the Google load balancer, we select Ubuntu 16.04 LTS." width="512" height="577" class="aligncenter size-full wp-image-47484" style="border:2px solid #666666; padding:2px; margin:2px;" />

   - **Identity&nbsp;and&nbsp;API&nbsp;access** – Keep the defaults for the **Service&nbsp;account&nbsp;** field and **Access&nbsp;scopes** radio button. Unless you need more granular control.
   - **Firewall** – Verify that neither check box is checked (the default). The firewall rule invoked in the **Tags** field on the **Management** subtab (see Step 3 below) controls this type of access.

2. Click <span style="color:#3366cc; white-space: nowrap;">Management, disk, networking, SSH keys</span> to open that set of subtabs. (The screenshot shows the values entered in the previous step.)

   <img src="/nginx/images/gce-ubuntu-instance-create.png" alt="Screen shot of the 'Create an instance' page for an application server in the deployment of NGINX Plus as the Google Cloud Platform load balancer." width="487" height="839" class="aligncenter size-full wp-image-47516" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. On the **Management** subtab, modify or verify the fields as indicated:

   - **Description** – **NGINX Plus&nbsp;app&#8209;1&nbsp;Image**
   - **Tags** – **nginx&#8209;plus&#8209;http&#8209;fw&#8209;rule**
   - **Preemptibility** – **Off&nbsp;(recommended)** (the default)
   - **Automatic&nbsp;restart** – **On&nbsp;(recommended)** (the default)
   - **On&nbsp;host&nbsp;maintenance** – **Migrate&nbsp;VM&nbsp;instance&nbsp;(recommended)** (the default)

   <img src="/nginx/images/gce-ubuntu-instance-management.png" alt="Screenshot of the Management subtab used during creation of a new VM instance, part of deploying NGINX Plus as the Google load balancer." width="487" height="551" class="aligncenter size-full wp-image-47486" style="border:2px solid #666666; padding:2px; margin:2px;" />

4. On the **Disks** subtab, uncheck the checkbox labeled **Delete boot disk when instance is deleted**.

   <img src="/nginx/images/gce-ubuntu-instance-disks.png" alt="Screenshot of the Disks subtab used during creation of a new VM instance, part of deploying NGINX Plus as the Google Cloud load balancer." width="487" height="224" class="aligncenter size-full wp-image-47485" style="border:2px solid #666666; padding:2px; margin:2px;" />

5. On the **Networking** subtab, verify the default settings, in particular **Ephemeral** for **External&nbsp;IP** and **Off** for **IP&nbsp;Forwarding**.

   <img src="/nginx/images/gce-ubuntu-instance-networking.png" alt="Screenshot of the Networking subtab used during creation of a new VM instance, part of deploying NGINX Plus as the Google Cloud load balancer." width="488" height="279" class="aligncenter size-full wp-image-47487" style="border:2px solid #666666; padding:2px; margin:2px;" />

6. If you're using your own SSH public key instead of your default GCE keys, paste the hexadecimal key string on the **SSH&nbsp;Keys** subtab. Right into the box that reads **Enter&nbsp;entire&nbsp;key&nbsp;data**.

   <img src="/nginx/images/gce-ubuntu-instance-ssh-keys.png" alt="Screenshot of the SSH Keys subtab used during creation of a new VM instance, part of deploying NGINX Plus as the Google Cloud Platform load balancer." width="488" height="205" class="aligncenter size-full wp-image-47488" style="border:2px solid #666666; padding:2px; margin:2px;" />

7. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create </span> button at the bottom of the **Create&nbsp;an&nbsp;instance** page.

    The **VM&nbsp;instances** summary page opens. It can take several minutes for the instance to be created. Wait to continue until the green check mark appears.

    <img src="/nginx/images/gce-ubuntu-instance-summary.png" alt="Screenshot of the summary page that verifies the creation of a new VM instance, part of deploying NGINX Plus as the load balancer for Google Cloud." width="1024" height="192" class="aligncenter size-full wp-image-47490" style="border:2px solid #666666; padding:2px; margin:2px;" />

<span id="source-vm-app-2"></span>
#### Creating the Second Application Instance from a VM Image

1. On the **VM&nbsp;instances** summary page, click <span style="color:#3366cc; white-space: nowrap;">CREATE INSTANCE</span>.

2. Repeat the steps in <a href="#source-vm-app-1">Creating the First Application Instance</a> to create the second application instance. Specify the same values as for the first application instance, except:

   - In Step 1, **Name** – **nginx&#8209;plus&#8209;app&#8209;2**
   - In Step 3, **Description** – **NGINX Plus&nbsp;app&#8209;2&nbsp;Image**

<span id="source-vm-lb"></span>
#### Creating the Load-Balancing Instance from a VM Image

1. On the **VM&nbsp;instances** summary page, click <span style="color:#3366cc; white-space: nowrap;">CREATE INSTANCE</span>.

2. Repeat the steps in <a href="#source-vm-app-1">Creating the First Application Instance</a> to create the load‑balancing instance. Specify the same values as for the first application instance, except:

   - In Step 1, **Name** – **nginx&#8209;plus&#8209;lb**
   - In Step 3, **Description** – **NGINX Plus Load Balancing Image**

<span id="source-vm-php"></span>
#### Configuring PHP and FastCGI on the VM-Based Instances

Install and configure PHP and FastCGI on the instances.

<span style="text-decoration: underline; white-space: nowrap;">Repeat these instructions</span> for all three source instances (**nginx&#8209;plus&#8209;app&#8209;1**, **nginx&#8209;plus&#8209;app&#8209;2**, and **nginx&#8209;plus&#8209;lb**).

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Connect to the instance over SSH using the method of your choice. GCE provides a built-in mechanism:

   - Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** tab.
   - In the instance's row in the table, click the triangle icon in the **Connect** column at the far right and select a method (for example, **Open&nbsp;in&nbsp;browser&nbsp;window**).

   <img src="/nginx/images/gce-ubuntu-instance-ssh.png" alt="Screenshot showing how to connect via SSH to a VM instance, part of deploying NGINX Plus as the Google load balancer." width="1024" height="284" class="aligncenter size-full wp-image-47489" style="border:2px solid #666666; padding:2px; margin:2px;" />

2. Working in the SSH terminal, install PHP 7 (the default PHP version for <span style="white-space: nowrap;">Ubuntu 16.04 LTS</span>) and FastCGI.

   ```shell
   apt-get install php7.0-fpm
   ```

3. Edit the PHP 7 configuration to bind to a local network port instead of a Unix socket. Using your preferred text editor, remove the following line from **/etc/php/7.0/fpm/pool.d**:

   ```none
   listen = /run/php/php7.0-fpm.sock
   ```

   and replace it with these two lines:

   ```none
   listen = 127.0.0.1:9000
   listen.allowed_clients = 127.0.0.1
   ```

4. Restart PHP:

   ```shell
   service php7.0-fpm restart
   ```

5. Leave the SSH connection open for reuse in the next section.

<span id="source-vm-nginx-plus"></span>
#### Installing and Configuring NGINX Plus on the VM-Based Instances

Now install NGINX Plus and download files that are specific to the all‑active deployment:

- An NGINX Plus configuration file customized for the function performed by the instance
- A set of content files (HTML, images, and so on) served by the application servers in the deployment

Both the configuration and content files are available at the [NGINX GitHub repository](https://github.com/nginxinc/NGINX-Demos/tree/master/gce-nginx-plus-deployment-guide-files).

<span style="text-decoration: underline; white-space: nowrap;">Repeat these instructions</span> for all three source instances (**nginx&#8209;plus&#8209;app&#8209;1**, **nginx&#8209;plus&#8209;app&#8209;2**, and **nginx&#8209;plus&#8209;lb**).

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Install NGINX Plus. For instructions, see the [NGINX Plus Admin Guide]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

2. Clone the GitHub repository for the [all‑active load balancing deployment](https://github.com/nginxinc/NGINX-Demos/tree/master/gce-nginx-plus-deployment-guide-files). (Instructions for downloading the files directly from the GitHub repository are provided below, in case you prefer not to clone it.)

3. Copy the contents of the **usr\_share\_nginx** subdirectory from the cloned repository to the local **/usr/share/nginx** directory. Create the local directory if needed. (If you choose not to clone the repository, you need to download each file from the GitHub repository individually.)

4. Copy the right configuration file from the **etc\_nginx\_conf.d** subdirectory of the cloned repository to **/etc/nginx/conf.d**:

   - On <span style="text-decoration: underline;">both</span> **nginx&#8209;plus&#8209;app&#8209;1** and **nginx&#8209;plus&#8209;app&#8209;2**, copy **gce&#8209;all&#8209;active&#8209;app.conf**.

      You can also run the following commands to download the configuration file directly from the GitHub repository:

      ```none
      cd /etc/nginx/conf.d/
      curl -o gce-all-active-app.conf https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/gce-all-active-app.conf
       ```

      or

      ```none
      cd /etc/nginx/conf.d/
      wget https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/gce-all-active-app.conf
      ```

   - On **nginx&#8209;plus&#8209;lb**, copy **gce&#8209;all&#8209;active&#8209;lb.conf**.

     You can also run the following commands to download the configuration file directly from the GitHub repository:

      ```none
      $ cd /etc/nginx/conf.d/
      $ curl -o gce-all-active-lb.conf https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/gce-all-active-lb.conf
      ```

     or

      ```none
      cd /etc/nginx/conf.d/
      wget https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/gce-all-active-lb.conf
      ```

5. On the LB instance (**nginx&#8209;plus&#8209;lb**), use a text editor to open **gce&#8209;all&#8209;active&#8209;lb.conf**. Change the `server` directives in the `upstream` block to reference the internal IP addresses of the **nginx&#8209;plus&#8209;app&#8209;1** and **nginx&#8209;plus&#8209;app&#8209;2** instances (substitute the address for the expression in angle brackets). You do not need to modify the two application instances.

   You can look up internal IP addresses in the **Internal&nbsp;IP** column of the table on the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** summary page.

   ```nginx
   upstream upstream_app_pool {
       server <internal IP address of nginx-plus-app-1>;
       server <internal IP address of nginx-plus-app-2>;
       zone upstream-apps 64k;
       sticky cookie GCPPersist expires=300;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky cookie`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

6. Rename **default.conf** to **default.conf.bak** so that NGINX Plus does not load it. The configuration files provided for the all‑active deployment include equivalent instructions plus additional function‑specific directives.

   ```shell
   mv default.conf default.conf.bak
   ```

7. Enable the NGINX Plus [live activity monitoring](https://www.nginx.com/products/nginx/live-activity-monitoring/) dashboard for the instance. Copy **status.html** from the **etc\_nginx\_conf.d** subdirectory of the cloned repository to **/etc/nginx/conf.d**.

   You can also run the following commands to download the configuration file directly from the GitHub repository:

   ```shell
   cd /etc/nginx/conf.d/
   curl -o status.conf https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/status.conf
    ```

    or

   ```shell
   cd /etc/nginx/conf.d/
   wget https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/status.conf
   ```

8. Validate the NGINX Plus configuration and restart NGINX Plus:

   ```shell
   nginx -t
   nginx -s reload
   ```

9. Verify the instance is working by accessing it at its external IP address. (As previously noted, we recommend blocking access to the external IP addresses of the application instances in a production environment.) The external IP address for the instance appears on the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** summary page, in the **External&nbsp;IP** column of the table.

    - Access the **index.html** page either in a browser or by running this `curl` command.

      ```shell
      curl http://<external-IP-address>
      ```

    - Access its NGINX Plus live activity monitoring dashboard in a browser, at:

        **https://_external&#8209;IP&#8209;address_:8080/status.html**

10. Proceed to [Task 3: Creating "Gold" Images](#gold).

<span id="source-prebuilt"></span>
### Creating Source Instances from Prebuilt NGINX Plus Images

Create three source instances based on a prebuilt NGINX Plus image running on <span style="white-space: nowrap;">Ubuntu 14.04 LTS</span>, available in the Google Marketplace. Google requires that you provision the first instance in the GCP Marketplace. Then you can clone the additional two instances from the first one.

<span id="source-prebuilt-app-1"></span>
#### Creating the First Application Instance from a Prebuilt Image

1. Verify that the **NGINX Plus&nbsp;All&#8209;Active&#8209;LB** project is still selected in the Google Cloud Platform header bar.

2. Navigate to the GCP Marketplace and search for **nginx plus**.

3. Click the **NGINX Plus** box in the results area.

   <img src="/nginx/images/nginx-plus-in-gcp-marketplace.png" alt="Screenshot of NGINX Plus in the Google Cloud Platform Marketplace; from here, you can create a prebuilt NGINX Plus VM instance when deploying NGINX Plus as the load balancer for Google Cloud." width="1024" height="604" class="aligncenter size-full wp-image-47469" style="border:2px solid #666666; padding:2px; margin:2px;" />

4. On the **NGINX Plus** page that opens, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Launch on Compute Engine </span> button.

5. Fill in the fields on the **New&nbsp;NGINX Plus&nbsp;deployment** page as indicated.

   - **Deployment&nbsp;name** – **nginx&#8209;plus&#8209;app&#8209;1**
   - **Zone** – The GCP zone that makes sense for your location. We're using **us&#8209;west1&#8209;a**.
   - **Machine&nbsp;type** – The appropriate size for the level of traffic you anticipate. We're selecting **micro**, which is ideal for testing purposes.
   - **Disk&nbsp;type** – **Standard&nbsp;Persistent&nbsp;Disk** (the default)
   - **Disk&nbsp;size&nbsp;in&nbsp;GB** – **10** (the default and minimum allowed)
   - **Network&nbsp;name** – **default**
   - **Subnetwork&nbsp;name** – **default**
   - **Firewall** – Verify that the **Allow&nbsp;HTTP&nbsp;traffic** checkbox is checked.

   <a href="/nginx/images/gce-marketplace-new-deployment.png"><img src="/nginx/images/gce-marketplace-new-deployment.png" alt="Screenshot of the page for creating a prebuilt NGINX Plus VM instance when deploying NGINX Plus as the Google Cloud Platform load balancer." width="1054" height="973" class="aligncenter size-full wp-image-47468" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

6. Click the <span style="background-color:#3366cc; color:white;"> Deploy </span> button.

   It can take several minutes for the instance to deploy. Wait until the green check mark and confirmation message appear before continuing.

   <img src="/nginx/images/gce-marketplace-instance-deployed.png" alt="Screenshot of the page that confirms the creation of a prebuilt NGINX Plus VM instance when deploying NGINX Plus as the Google load balancer." width="1024" height="399" class="aligncenter size-full wp-image-47467" style="border:2px solid #666666; padding:2px; margin:2px;" />

7. Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** tab and click **nginx&#8209;plus&#8209;app&#8209;1&#8209;vm** in the <span style="color:#3366cc;">Name</span> column in the table. (The **&#8209;vm** suffix is added automatically to the name of the newly created instance.)

   <img src="/nginx/images/gce-app-1-vm-select.png" alt="Screenshot showing how to access the page where configuration details for a VM instance can be modified during deployment of NGINX Plus as the Google Cloud load balancer." width="1023" height="194" class="aligncenter size-full wp-image-47465" style="border:2px solid #666666; padding:2px; margin:2px;" />

8. On the **VM&nbsp;instances** page that opens, click <span style="color:#3366cc;">EDIT</span> at the top of the page. In fields that can be edited, the value changes from static text to text boxes, drop‑down menus, and checkboxes.

9. Modify or verify the indicated editable fields (non‑editable fields are not listed):

   - **Tags** – If a default tag appears (for example, **nginx&#8209;plus&#8209;app&#8209;1&#8209;tcp&#8209;80**), click the **X** after its name to remove it. Then, type in **nginx&#8209;plus&#8209;http&#8209;fw&#8209;rule**.
   - **External&nbsp;IP** – **Ephemeral** (the default)
   - **Boot&nbsp;disk&nbsp;and&nbsp;local&nbsp;disks** – Uncheck the checkbox labeled **Delete boot disk when instance is deleted**.
   - **Additional&nbsp;disks** – No changes
   - **Network** – If you must change the defaults, for example, when configuring a production environment, select <span style="color:#3366cc;">default</span> Then, select <span style="color:#3366cc;">EDIT</span> on the opened **Network&nbsp;details** page. After making your changes select the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Save </span> button.
   - **Firewall** – Verify that neither check box is checked (the default). The firewall rule named in the **Tags** field that's above on the current page (see the first bullet in this list) controls this type of access.
   - **Automatic&nbsp;restart** – **On&nbsp;(recommended)** (the default)
   - **On&nbsp;host&nbsp;maintenance** – **Migrate&nbsp;VM&nbsp;instance&nbsp;(recommended)** (the default)
   - **Custom&nbsp;metadata** – No changes
   - **SSH&nbsp;Keys** – If you're using your own SSH public key instead of your default GCE keys, paste the hexadecimal key string into the box labeled **Enter&nbsp;entire&nbsp;key&nbsp;data**.
   - **Serial&nbsp;port** – Verify that the check box labeled **Enable&nbsp;connecting&nbsp;to&nbsp;serial&nbsp;ports** is not checked (the default).

   The screenshot shows the results of your changes. It omits some fields that can't be edited or for which we recommend keeping the defaults.

   <img src="/nginx/images/gce-app-1-vm-edited.png" alt="Screenshot showing the configuration modifications for a VM instance being deployed as part of setting up NGINX Plus as the Google load balancer." width="1027" height="1368" class="aligncenter size-full wp-image-47464" style="border:2px solid #666666; padding:2px; margin:2px;" />

10. Click the <span style="background-color:#3366cc; color:white;"> Save </span> button.

<span id="source-prebuilt-app-2"></span>
#### Creating the Second Application Instance from a Prebuilt Image

Create the second application instance by cloning the first one.

1. Navigate back to the summary page on the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** tab (click the arrow that is circled in the following figure).

   <img src="/nginx/images/gce-vm-instances-back-arrow.png" alt="Screenshot showing how to return to the VM instance summary page during deployment of NGINX Plus as the Google Cloud Platform load balancer." width="1024" height="110" class="aligncenter size-full wp-image-47492" style="border:2px solid #666666; padding:2px; margin:2px;" />

2. Click **nginx&#8209;plus&#8209;app&#8209;1&#8209;vm** in the <span style="color:#3366cc;">Name</span> column of the table (shown in the screenshot in Step 7 of <a href="#source-prebuilt-app-1">Creating the First Application Instance</a>).

3. On the **VM&nbsp;instances** page that opens, click <span style="color:#3366cc;">CLONE</span> at the top of the page.

4. On the **Create&nbsp;an&nbsp;instance** page that opens, modify or verify the fields and checkboxes as indicated:

   - **Name** – **nginx&#8209;plus&#8209;app&#8209;2&#8209;vm**. Here we're adding the **&#8209;vm** suffix to make the name consistent with the first instance; GCE does not add it automatically when you clone an instance.
   - **Zone** – The GCP zone that makes sense for your location. We're using **us&#8209;west1&#8209;a**.
   - **Machine&nbsp;type** – The appropriate size for the level of traffic you anticipate. We're selecting **f1&#8209;micro**, which is ideal for testing purposes.
   - **Boot&nbsp;disk&nbsp;type** – **New&nbsp;10&nbsp;GB&nbsp;standard&nbsp;persistent&nbsp;disk** (the value inherited from **nginx&#8209;plus&#8209;app&#8209;1&#8209;vm**)
   - **Identity&nbsp;and&nbsp;API&nbsp;access** – Set the **Access&nbsp;scopes** radio button to **Allow&nbsp;default&nbsp;access** and accept the default values in all other fields. If you want more granular control over access than is provided by these settings, modify the fields in this section as appropriate.
   - **Firewall** – Verify that neither check box is checked (the default).

5. Click <span style="color:#3366cc; white-space: nowrap;">Management, disk, networking, SSH keys</span> to open that set of subtabs.

6. Verify the following settings on the subtabs, modifying them as necessary:

   - **Management** – In the **Tags** field: **nginx&#8209;plus&#8209;http&#8209;fw&#8209;rule**
   - **Disks** – The **Deletion&nbsp;rule** checkbox (labeled **Delete boot disk when instance is deleted**) is <span style="text-decoration: underline;">not</span> checked

7. Select the <span style="background-color:#3366cc; color:white;"> Create </span> button.

<span id="source-prebuilt-lb"></span>
#### Creating the Load-Balancing Instance from a Prebuilt Image

Create the source load‑balancing instance by cloning the first instance again.

Repeat Steps 2 through 7 of <a href="#source-prebuilt-app-2">Creating the Second Application Instance</a>. In Step 4, specify **nginx&#8209;plus&#8209;lb&#8209;vm** as the name.

<span id="source-prebuilt-php"></span>
#### Configuring PHP and FastCGI on the Prebuilt-Based Instances

Install and configure PHP and FastCGI on the instances.

<span style="text-decoration: underline; white-space: nowrap;">Repeat these instructions</span> for all three source instances (**nginx&#8209;plus&#8209;app&#8209;1&#8209;vm**, **nginx&#8209;plus&#8209;app&#8209;2&#8209;vm**, and **nginx&#8209;plus&#8209;lb&#8209;vm**).

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Connect to the instance over SSH using the method of your choice. GCE provides a built‑in mechanism:

   - Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** tab.
   - In the table, find the row for the instance. Select the triangle icon in the **Connect** column at the far right. Then, select a method (for example, **Open&nbsp;in&nbsp;browser&nbsp;window**).

   The screenshot shows instances based on the prebuilt NGINX Plus images.

   <img src="/nginx/images/gce-prebuilt-instance-ssh.png" alt="Screenshot showing how to connect via SSH to a VM instance, part of deploying NGINX Plus as the Google load balancer." width="1024" height="284" class="aligncenter size-full wp-image-47495" style="border:2px solid #666666; padding:2px; margin:2px;" />

2. Working in the SSH terminal, install PHP 5 (the default PHP version for Ubuntu 14.04 LTS) and FastCGI.

   ```shell
   apt-get install php5-fpm
   ```

3. Edit the PHP 5 configuration to bind to a local network port instead of a Unix socket. Using your preferred text editor, remove the following line from **/etc/php5/fpm/pool.d**:

   ```none
   Listen = /run/php/php5-fpm.sock
   ```

    and replace it with these two lines:

   ```none
   Listen = 127.0.0.1:9000
   Listen.allowed_clients = 127.0.0.1
   ```

4. Restart PHP:

   ```shell
   service php5-fpm restart
   ```

5. Leave the SSH connection open for reuse in the next section.

<span id="source-prebuilt-nginx-plus"></span>
#### Configuring NGINX Plus on the Prebuilt-Based Instances

Now download files that are specific to the all‑active deployment:

- An NGINX Plus configuration file customized for the function the instance performs (application server or load balancer)
- A set of content files (HTML, images, and so on) served by the application servers in the deployment

Both the configuration and content files are available at the [NGINX GitHub repository](https://github.com/nginxinc/NGINX-Demos/tree/master/gce-nginx-plus-deployment-guide-files).

<span style="text-decoration: underline; white-space: nowrap;">Repeat these instructions</span> for all three source instances (**nginx&#8209;plus&#8209;app&#8209;1&#8209;vm**, **nginx&#8209;plus&#8209;app&#8209;2&#8209;vm**, and **nginx&#8209;plus&#8209;lb&#8209;vm**).

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Clone the GitHub repository for the [all‑active load balancing deployment](https://github.com/nginxinc/NGINX-Demos/tree/master/gce-nginx-plus-deployment-guide-files). (See the instructions below for downloading the files from GitHub if you choose not to clone it.)

2. Copy the contents of the **usr\_share\_nginx** subdirectory from the cloned repo to the local **/usr/share/nginx** directory. Create the local directory if necessary. (If you choose not to clone the repository, you need to download each file from the GitHub repository one at a time.)


3. Copy the right configuration file from the **etc\_nginx\_conf.d** subdirectory of the cloned repository to **/etc/nginx/conf.d**:

   - On <span style="text-decoration: underline;">both</span> **nginx&#8209;plus&#8209;app&#8209;1&#8209;vm** and **nginx&#8209;plus&#8209;app&#8209;2&#8209;vm**, copy **gce&#8209;all&#8209;active&#8209;app.conf**.

     You can also run these commands to download the configuration file from GitHub:

      ```shell
     cd /etc/nginx/conf.d/
     curl -o gce-all-active-app.conf https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/gce-all-active-app.conf
      ```

      or

      ```none
      cd /etc/nginx/conf.d/
      wget https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/gce-all-active-app.conf
      ```

   - On **nginx&#8209;plus&#8209;lb&#8209;vm**, copy **gce&#8209;all&#8209;active&#8209;lb.conf**.

      You can also run the following commands to download the configuration file directly from the GitHub repository:

      ```none
      cd /etc/nginx/conf.d/
      curl -o gce-all-active-lb.conf https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/gce-all-active-lb.conf
      ```

      or

      ```none
      cd /etc/nginx/conf.d/
      wget https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/gce-all-active-lb.conf
      ```

4. On the LB instance (**nginx&#8209;plus&#8209;lb&#8209;vm**), use a text editor to open **gce&#8209;all&#8209;active&#8209;lb.conf**. Change the `server` directives in the `upstream` block to reference the internal IP addresses of the **nginx&#8209;plus&#8209;app&#8209;1&#8209;vm** and **nginx&#8209;plus&#8209;app&#8209;2&#8209;vm** instances. (No action is required on the two application instances themselves.)

   You can look up internal IP addresses in the **Internal&nbsp;IP** column of the table on the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** summary page.

   ```nginx
   upstream upstream_app_pool {
       server <internal IP address of nginx-plus-app-1-vm>;
       server <internal IP address of nginx-plus-app-2-vm>;
       zone upstream-apps 64k;
       sticky cookie GCPPersist expires=300;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky cookie`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

5. Rename **default.conf** to **default.conf.bak** so that NGINX Plus does not load it. The configuration files for the all-active deployment include equivalent instructions. They also have extra, function-specific directives.

   ```shell
   mv default.conf default.conf.bak
   ```

6. Enable the NGINX Plus [live activity monitoring](https://www.nginx.com/products/nginx/live-activity-monitoring/) dashboard for the instance. To do this, copy **status.html** from the **etc\_nginx\_conf.d** subdirectory of the cloned repository to **/etc/nginx/conf.d**.

   You can also run the following commands to download the configuration file directly from the GitHub repository:

   ```shell
   cd /etc/nginx/conf.d/
   curl -o status.conf https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/status.conf
   ```

    or

   ```shell
   cd /etc/nginx/conf.d/
   wget https://github.com/nginxinc/NGINX-Demos/blob/master/gce-nginx-plus-deployment-guide-files/etc_nginx_conf.d/status.conf
   ```

7. Validate the NGINX Plus configuration and restart NGINX Plus:

   ```shell
   nginx -t
   nginx -s reload
   ```

8. Verify the instance is working by accessing it at its external IP address. (As noted, we recommend blocking access, in production, to the external IPs of the app.) The external IP address for the instance appears on the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** summary page, in the **External&nbsp;IP** column of the table.

   - Access the **index.html** page either in a browser or by running this `curl` command.

      ```shell
     curl http://<external-IP-address-of-NGINX-Plus-server>
     ```

   - Access the NGINX Plus live activity monitoring dashboard in a browser, at:

     **https://_external&#8209;IP&#8209;address&#8209;of&#8209;NGINX&#8209;Plus&#8209;server_:8080/dashboard.html**

9. Proceed to [Task 3: Creating "Gold" Images](#gold).

<span id="gold"></span>
## Task 3: Creating "Gold" Images

Create _gold images_, which are base images that GCE clones automatically when it needs to scale up the number of instances. They are derived from the instances you created in [Creating Source Instances](#source). Before creating the images, delete the source instances. This breaks the attachment between them and the disk. (you can't create an image from a disk attached to a VM instance).

1. Verify that the **NGINX Plus&nbsp;All&#8209;Active&#8209;LB** project is still selected in the Google Cloud Platform header bar.

2. Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** tab.

3. In the table, select all three instances:

   - If you created source instances from [VM (Ubuntu) images](#source-vm): **nginx&#8209;plus&#8209;app&#8209;1**, **nginx&#8209;plus&#8209;app&#8209;2**, and **nginx&#8209;plus&#8209;lb**
   - If you created source instances from [prebuilt NGINX Plus images](#source-prebuilt): **nginx&#8209;plus&#8209;app&#8209;1&#8209;vm**, **nginx&#8209;plus&#8209;app&#8209;2&#8209;vm**, and **nginx&#8209;plus&#8209;lb&#8209;vm**

4. Click <span style="color:#3366cc;">STOP</span> in the top toolbar to stop the instances.

   <img src="/nginx/images/gce-vm-instances-toolbar.png" alt="Screenshot of the toolbar on the Google Compute Engine page that lists VM instances, used when deploying NGINX Plus as the Google Cloud load balancer." width="1024" height="63" class="aligncenter size-full wp-image-47493" style="border:2px solid #666666; padding:2px; margin:2px;" />

5. Click <span style="color:#3366cc;">DELETE</span> in the top toolbar to delete the instances.

   **Note:** If the pop-up warns that it will delete the boot disk for any instance, cancel the deletion. Then, perform the steps below <span style="text-decoration: underline;">for each affected instance</span>:

   - Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** tab and click the instance in the <span style="color:#3366cc;">Name</span> column in the table. (The screenshot shows **nginx&#8209;plus&#8209;app&#8209;1&#8209;vm**.)

     <img src="/nginx/images/gce-app-1-vm-select.png" alt="Screenshot showing how to access the page where configuration details for a VM instance can be modified during deployment of NGINX Plus as the Google Cloud load balancer." width="1023" height="194" class="aligncenter size-full wp-image-47465" style="border:2px solid #666666; padding:2px; margin:2px;" />

   - On the **VM&nbsp;instances** page that opens, click <span style="color:#3366cc;">EDIT</span> at the top of the page. In fields that can be edited, the value changes from static text to text boxes, drop‑down menus, and checkboxes.
   - In the **Boot&nbsp;disk&nbsp;and&nbsp;local&nbsp;disks** field, uncheck the checkbox labeled **Delete boot disk when instance is deleted**.
   - Click the <span style="background-color:#3366cc; color:white;"> Save </span> button.
   - On the **VM&nbsp;instances** summary page, select the instance in the table and click <span style="color:#3366cc;">DELETE</span> in the top toolbar to delete it.

6. Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;Images** tab.

7. Click <span style="color:#3366cc; white-space: nowrap;">[+] CREATE IMAGE</span>.

8. On the **Create&nbsp;an&nbsp;image** page that opens, modify or verify the fields as indicated:

   - **Name** – **nginx&#8209;plus&#8209;app&#8209;1&#8209;image**
   - **Family** – Leave the field empty
   - **Description** – **NGINX Plus Application 1 Gold Image**
   - **Encryption** – **Automatic&nbsp;(recommended)** (the default)
   - **Source** – **Disk** (the default)
   - **Source&nbsp;disk** – **nginx&#8209;plus&#8209;app&#8209;1** or **nginx&#8209;plus&#8209;app&#8209;1&#8209;vm**, depending on the method you used to create source instances (select the source instance from the drop‑down menu)

9. Click the <span style="background-color:#3366cc; color:white;"> Create </span> button.

10. Repeat Steps 7 through 9 to create a second image with the following values (retain the default values in all other fields):

    - **Name** – **nginx&#8209;plus&#8209;app&#8209;2&#8209;image**
    - **Description** – **NGINX Plus&nbsp;Application&nbsp;2&nbsp;Gold&nbsp;Image**
    - **Source&nbsp;disk** – **nginx&#8209;plus&#8209;app&#8209;2** or **nginx&#8209;plus&#8209;app&#8209;2&#8209;vm**, depending on the method you used to create source instances (select the source instance from the drop‑down menu)

11. Repeat Steps 7 through 9 to create a third image with the following values (retain the default values in all other fields):

    - **Name** – **nginx&#8209;plus&#8209;lb&#8209;image**
    - **Description** – **NGINX Plus LB Gold Image**
    - **Source&nbsp;disk** – **nginx&#8209;plus&#8209;lb** or **nginx&#8209;plus&#8209;lb&#8209;vm**, depending on the method you used to create source instances (select the source instance from the drop‑down menu)

12. Verify that the three images appear at the top of the table on the **Compute&nbsp;Engine&nbsp;>&nbsp;Images** tab.

<span id="templates"></span>
## Task 4: Creating Instance Templates

Create _instance templates_. They are the compute workloads in instance groups. These are created manually or automatically when GCE detects a failure.


<span id="templates-app-1"></span>
### Creating the First Application Instance Template

1. Verify that the **NGINX Plus&nbsp;All&#8209;Active&#8209;LB** project is still selected in the Google Cloud Platform header bar.

2. Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;Instance&nbsp;templates** tab.

3. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create instance template </span> button.

4. On the **Create&nbsp;an&nbsp;instance&nbsp;template** page that opens, modify or verify the fields as indicated:

   - **Name** – **nginx&#8209;plus&#8209;app&#8209;1&#8209;instance&#8209;template**
   - **Machine&nbsp;type** – The appropriate size for the level of traffic you anticipate. We're selecting **micro**, which is ideal for testing purposes.
   - **Boot&nbsp;disk** – Click **Change**. The **Boot&nbsp;disk** page opens. Perform the following steps:

     - Open the **Custom&nbsp;Images** subtab.

         <img src="/nginx/images/gce-instance-template-boot-disk.png" alt="Screenshot of the 'Boot disk' page in Google Cloud Platform for selecting the source instance of a new instance template, part of deploying NGINX Plus as the Google load balancer." width="491" height="517" class="aligncenter size-full wp-image-47478" style="border:2px solid #666666; padding:2px; margin:2px;" />

     - Select **NGINX Plus&nbsp;All&#8209;Active&#8209;LB** from the drop-down menu labeled **Show&nbsp;images&nbsp;from**.

     - Click the **nginx&#8209;plus&#8209;app&#8209;1&#8209;image** radio button.

     - Accept the default values in the **Boot&nbsp;disk&nbsp;type** and **Size&nbsp;(GB)** fields (**Standard&nbsp;persistent&nbsp;disk** and **10** respectively).

     - Click the <span style="background-color:#3366cc; color:white;"> Select </span> button.

   - **Identity&nbsp;and&nbsp;API&nbsp;access** – Unless you want more granular control over access, keep the defaults in the **Service&nbsp;account** field (**Compute Engine default service account**) and **Access&nbsp;scopes** field (**Allow&nbsp;default&nbsp;access**).
   - **Firewall** – Verify that neither check box is checked (the default). The firewall rule invoked in the **Tags** field on the **Management** subtab (see Step 6 below) controls this type of access.

5. Select <span style="color:#3366cc; white-space: nowrap;">Management, disk, networking, SSH keys</span> (indicated with a red arrow in the following screenshot) to open that set of subtabs.

   <img src="/nginx/images/gce-create-instance-template.png" alt="Screenshot of the interface for creating a Google Compute Engine (GCE) instance template, used during deployment of NGINX Plus as the Google load balancer." width="498" height="798" class="aligncenter size-full wp-image-47473" style="border:2px solid #666666; padding:2px; margin:2px;" />

6. On the **Management** subtab, modify or verify the fields as indicated:

   - **Description** – **NGINX Plus&nbsp;app&#8209;1&nbsp;Instance&nbsp;Template**
   - **Tags** – **nginx&#8209;plus&#8209;http&#8209;fw&#8209;rule**
   - **Preemptibility** – **Off&nbsp;(recommended)** (the default)
   - **Automatic&nbsp;restart** – **On&nbsp;(recommended)** (the default)
   - **On&nbsp;host&nbsp;maintenance** – **Migrate&nbsp;VM&nbsp;instance&nbsp;(recommended)** (the default)

   <img src="/nginx/images/gce-instance-template-management.png" alt="Screenshot of the Management subtab used during creation of a new VM instance template, part of deploying NGINX Plus as the Google load balancer." width="487" height="551" class="aligncenter size-full wp-image-47480" style="border:2px solid #666666; padding:2px; margin:2px;" />

7. On the **Disks** subtab, verify that the checkbox labeled **Delete boot disk when instance is deleted** is checked.

   Instances from this template are ephemeral instantiations of the gold image. So, we want GCE to reclaim the disk when the instance is terminated. New instances are always based on the gold image. So, there is no reason to keep the instantiations on disk when the instance is deleted.

   <img src="/nginx/images/gce-instance-template-disks.png" alt="Screenshot of the Disks subtab used during creation of a new VM instance template, part of deploying NGINX Plus as the Google Cloud load balancer." width="488" height="184" class="aligncenter size-full wp-image-47479" style="border:2px solid #666666; padding:2px; margin:2px;" />

8. On the **Networking** subtab, verify the default settings of **Ephemeral** for **External&nbsp;IP** and **Off** for **IP&nbsp;Forwarding**.

   <img src="/nginx/images/gce-instance-template-networking.png" alt="Screenshot of the Networking subtab used during creation of a new VM instance template, part of deploying NGINX Plus as the Google load balancer." width="488" height="174" class="aligncenter size-full wp-image-47481" style="border:2px solid #666666; padding:2px; margin:2px;" />

9. If you're using your own SSH public key instead of your default keys, paste the hexadecimal key string on the **SSH&nbsp;Keys** subtab. Right into the box that reads **Enter&nbsp;entire&nbsp;key&nbsp;data**.

    <img src="/nginx/images/gce-ubuntu-instance-ssh-keys.png" alt="Screenshot of the SSH Keys subtab used during creation of a new VM instance, part of deploying NGINX Plus as the Google Cloud Platform load balancer." width="488" height="205" class="aligncenter size-full wp-image-47488" style="border:2px solid #666666; padding:2px; margin:2px;" />

10. Click the <span style="background-color:#3366cc; color:white;"> Create </span> button.

<span id="templates-app-2"></span>
### Creating the Second Application Instance Template

1. On the **Instance&nbsp;templates** summary page, click <span style="color:#3366cc; white-space: nowrap;">CREATE INSTANCE TEMPLATE</span>.

2. Repeat Steps 4 through 10 of <a href="#templates-app-1">Creating the First Application Instance Template</a> to create a second application instance template. Use the same values as for the first instance template, except as noted:

   - In Step 4:
     - **Name** – **nginx&#8209;plus&#8209;app&#8209;2&#8209;instance&#8209;template**
     - **Boot&nbsp;disk** – Click the **nginx&#8209;plus&#8209;app&#8209;2&#8209;image** radio button
   - In Step 6, **Description** – **NGINX Plus&nbsp;app&#8209;2&nbsp;Instance&nbsp;Template**

<span id="templates-lb"></span>
### Creating the Load-Balancing Instance Template

1. On the **Instance&nbsp;templates** summary page, click <span style="color:#3366cc; white-space: nowrap;">CREATE INSTANCE TEMPLATE</span>.

2. Repeat Steps 4 through 10 of <a href="#templates-app-1">Creating the First Application Instance Template</a> to create the load‑balancing instance template. Use the same values as for the first instance template, except as noted:

   - In Step 4:
      - **Name** – **nginx&#8209;plus&#8209;lb&#8209;instance&#8209;template**.
      - **Boot&nbsp;disk** – Click the **nginx&#8209;plus&#8209;lb&#8209;image** radio button

   - In Step 6, **Description** – **NGINX Plus Load‑Balancing Instance Template**

<span id="health-checks"></span>
## Task 5: Creating Image Health Checks

Define the simple HTTP health check that GCE uses. This verifies that each NGINX Plus LB image is running (and to re-create any LB instance that isn't running).

1. Verify that the **NGINX Plus&nbsp;All&#8209;Active&#8209;LB** project is still selected in the Google Cloud Platform header bar.

2. Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;Health&nbsp;checks** tab.

3. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create a health check </span> button.

4. On the **Create&nbsp;a&nbsp;health&nbsp;check** page that opens, modify or verify the fields as indicated:

   - **Name** – **nginx&#8209;plus&#8209;http&#8209;health&#8209;check**
   - **Description** – **Basic HTTP health check to monitor NGINX Plus instances**
   - **Protocol** – **HTTP** (the default)
   - **Port** – **80** (the default)
   - **Request&nbsp;path** – **/status&#8209;old.html**

5. If the **Health&nbsp;criteria** section is not already open, click <span style="color:#3366cc;">More</span>.

6. Modify or verify the fields as indicated:

   - **Check&nbsp;interval** – **10&nbsp;seconds**
   - **Timeout** – **10&nbsp;seconds**
   - **Healthy&nbsp;threshold** – **2&nbsp;consecutive&nbsp;successes** (the default)
   - **Unhealthy&nbsp;threshold** – **10&nbsp;consecutive&nbsp;failures**

7. Click the <span style="background-color:#3366cc; color:white;"> Create </span> button.

   <img src="/nginx/images/gce-create-health-check.png" alt="Screenshot of the interface for creating a health check in Google Compute Engine (GCE), which Google network load balancer uses to monitor NGINX Plus as the Google cloud load balancer." width="487" height="706" class="aligncenter size-full wp-image-47471" style="border:2px solid #666666; padding:2px; margin:2px;" />

<span id="groups"></span>
## Task 6: Creating Instance Groups

Create three independent instance groups, one for each type of function-specific instance.

1. Verify that the **NGINX Plus&nbsp;All&#8209;Active&#8209;LB** project is still selected in the Google Cloud Platform header bar.

2. Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;Instance&nbsp;groups** tab.

3. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create instance group </span> button.

<span id="groups-app-1"></span>
### Creating the First Application Instance Group

1. On the **Create&nbsp;a&nbsp;new&nbsp;instance&nbsp;group** page that opens, modify or verify the fields as indicated. Ignore fields that are not mentioned:

   - **Name** – **nginx&#8209;plus&#8209;app&#8209;1&#8209;instance&#8209;group**
   - **Description** – **Instance group to host NGINX Plus app-1 instances**
   - **Location** –
     - Click the **Single&#8209;zone** radio button (the default).
     - **Zone** – The GCP zone you specified when you created source instances (Step 1 of [Creating the First Application Instance from a VM Image](#source-vm-app-1) or Step 5 of [Creating the First Application Instance from a Prebuilt Image](#source-prebuilt)). We're using **us&#8209;west1&#8209;a**.
   - **Creation&nbsp;method** – **Use&nbsp;instance&nbsp;template** radio button (the default)
   - **Instance&nbsp;template** – **nginx&#8209;plus&#8209;app&#8209;1&#8209;instance&#8209;template** (select from the drop-down menu)
   - **Autoscaling** – **Off** (the default)
   - **Number&nbsp;of&nbsp;instances** – **2**
   - **Health&nbsp;check** – **nginx&#8209;plus&#8209;http&#8209;health&#8209;check** (select from the drop-down menu)
   - **Initial&nbsp;delay** – **300&nbsp;seconds** (the default)

3. Click the <span style="background-color:#3366cc; color:white;"> Create </span> button.

   <img src="/nginx/images/gce-create-instance-group.png" alt="Screenshot of the interface for creating a Google Compute Engine (GCE) instance group, used during deployment of NGINX Plus as the load balancer for Google Cloud." width="488" height="1045" class="aligncenter size-full wp-image-47472" style="border:2px solid #666666; padding:2px; margin:2px;" />

<span id="groups-app-2"></span>
### Creating the Second Application Instance Group

1. On the Instance groups summary page, click <span style="color:#3366cc; white-space: nowrap;">CREATE INSTANCE GROUP</span>.

2. Repeat the steps in [Creating the First Application Instance Group](#groups-app-1) to create a second application instance group. Specify the same values as for the first instance template, except for these fields:

   - **Name** – **nginx&#8209;plus&#8209;app&#8209;2&#8209;instance&#8209;group**
   - **Description** – **Instance group to host NGINX Plus app-2 instances**
   - **Instance&nbsp;template** – **nginx&#8209;plus&#8209;app&#8209;2&#8209;instance&#8209;template** (select from the drop-down menu)

<span id="groups-lb"></span>
### Creating the Load-Balancing Instance Group

1. On the **Instance&nbsp;groups** summary page, click <span style="color:#3366cc; white-space: nowrap;">CREATE INSTANCE GROUP</span>.

2. Repeat the steps in [Creating the First Application Instance Group](#groups-app-1) to create the load‑balancing instance group. Specify the same values as for the first instance template, except for these fields:

   - **Name** – **nginx&#8209;plus&#8209;lb&#8209;instance&#8209;group**
   - **Description** – **Instance group to host NGINX Plus load balancing instances**
   - **Instance&nbsp;template** – **nginx&#8209;plus&#8209;lb&#8209;instance&#8209;template** (select from the drop-down menu)

<span id="update-test"></span>
### Updating and Testing the NGINX Plus Configuration

Update the NGINX Plus configuration on the two LB instances (**nginx&#8209;plus&#8209;lb&#8209;instance&#8209;group&#8209;[a...z]**). It should list the internal IP addresses of the four application servers (two instances each of **nginx&#8209;plus&#8209;app&#8209;1&#8209;instance&#8209;group&#8209;[a...z]** and **nginx&#8209;plus&#8209;app&#8209;2&#8209;instance&#8209;group&#8209;[a...z]**).

<span style="text-decoration: underline; white-space: nowrap;">Repeat these instructions</span> for both LB instances.

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Connect to the LB instance over SSH using the method of your choice. GCE provides a built-in mechanism:

   - Navigate to the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** tab.
   - In the table, find the row for the instance. Click the triangle icon in the **Connect** column at the far right. Then, select a method (for example, **Open&nbsp;in&nbsp;browser&nbsp;window**).

2. In the SSH terminal, use your preferred text editor to edit **gce&#8209;all&#8209;active&#8209;lb.conf**. Change the `server` directives in the `upstream` block to  reference the internal IPs of the two **nginx&#8209;plus&#8209;app&#8209;1&#8209;instance&#8209;group&#8209;[a...z]** instances and the two **nginx&#8209;plus&#8209;app&#8209;2&#8209;instance&#8209;group&#8209;[a...z]** instances. You can check the addresses in the **Internal&nbsp;IP** column of the table on the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** summary page. For example:

   ```nginx
   upstream upstream_app_pool {
       zone upstream-apps 64k;

       server 10.10.10.1;
       server 10.10.10.2;
       server 10.10.10.3;
       server 10.10.10.4;

       sticky cookie GCPPersist expires=300;
   }
   ```

   Directive documentation: [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [`sticky cookie`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

3. Validate the NGINX Plus configuration and restart NGINX Plus:

   ```shell
   nginx -t
   nginx -s reload
   ```

4. Verify that the four application instances are receiving traffic and responding. To do this, access the NGINX Plus live activity monitoring dashboard on the load-balancing instance (**nginx&#8209;plus&#8209;lb&#8209;instance&#8209;group&#8209;[a...z]**). You can see the instance's external IP address on the **Compute&nbsp;Engine&nbsp;>&nbsp;VM&nbsp;instances** summary page in the **External&nbsp;IP** column of the table.

   **https://_LB&#8209;external&#8209;IP&#8209;address_:8080/status.html**

5. Verify that NGINX Plus is load balancing traffic among the four application instance groups. Do this by running this command on a separate client machine:

   ```shell
   while true; do curl -s <LB-external-IP-address> | grep Server: ;done
   ```

   If load balancing is working properly, the unique **Server** field from the index page for each application instance appears in turn.

<span id="static-ip"></span>
## Task 7: Configuring GCE Network Load Balancer

Set up a GCE network load balancer. It will distribute incoming client traffic to the NGINX Plus LB instances. First, reserve the static IP address the GCE network load balancer advertises to clients.

1. Verify that the **NGINX Plus&nbsp;All&#8209;Active&#8209;LB** project is still selected in the Google Cloud Platform header bar.

2. Navigate to the **Networking&nbsp;>&nbsp;External&nbsp;IP&nbsp;addresses** tab.

3. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Reserve static address </span> button.

4. On the **Reserve&nbsp;a&nbsp;static&nbsp;address** page that opens, modify or verify the fields as indicated:

   - **Name** – **nginx&#8209;plus&#8209;network&#8209;lb&#8209;static&#8209;ip**
   - **Description** – **Static IP address for Network LB frontend to NGINX Plus LB instances**
   - **Type** – Click the **Regional** radio button (the default)
   - **Region** – The GCP zone you specified when you created source instances (Step 1 of [Creating the First Application Instance from a VM Image](#source-vm-app-1) or Step 5 of [Creating the First Application Instance from a Prebuilt Image](#source-prebuilt)). We're using **us&#8209;west1**.
   - **Attached&nbsp;to** – **None** (the default)

5. Click the <span style="background-color:#3366cc; color:white;"> Reserve </span> button.

   <img src="/nginx/images/gce-reserve-static-address.png" alt="Screenshot of the interface for reserving a static IP address for Google Compute Engine network load balancer." width="488" height="496" class="aligncenter size-full wp-image-47483" style="border:2px solid #666666; padding:2px; margin:2px;" />

6. Navigate to the **Networking&nbsp;>&nbsp;Load&nbsp;balancing** tab.

7. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create load balancer </span> button.

8. On the **Load&nbsp;balancing** page that opens, click **Start&nbsp;configuration** in the **TCP&nbsp;Load&nbsp;Balancing** box.

9. On the page that opens, click the **From&nbsp;Internet&nbsp;to&nbsp;my&nbsp;VMs** and **No&nbsp;(TCP)** radio buttons (the defaults).

10. Click the <span style="background-color:#3366cc; color:white;"> Continue </span> button. The **New&nbsp;TCP&nbsp;load&nbsp;balancer** page opens.

11. In the **Name** field, type **nginx&#8209;plus&#8209;network&#8209;lb&#8209;frontend**.

12. Click **Backend&nbsp;configuration** in the left column to open the **Backend&nbsp;configuration** interface in the right column. Fill in the fields as indicated:

    - **Region** – The GCP region you specified in Step 4. We're using **us&#8209;west1**.
    - **Backends** – With **Select&nbsp;existing&nbsp;instance&nbsp;groups** selected, select **nginx&#8209;plus&#8209;lb&#8209;instance&#8209;group** from the drop-down menu
    - **Backup&nbsp;pool** – **None** (the default)
    - **Failover&nbsp;ratio** – **10** (the default)
    - **Health&nbsp;check** – **nginx&#8209;plus&#8209;http&#8209;health&#8209;check**
    - **Session&nbsp;affinity** – **Client&nbsp;IP**

    <img src="/nginx/images/gce-backend-configuration.png" alt="Screenshot of the interface for backend configuration of GCE network load balancer, used during deployment of NGINX Plus as the Google Cloud Platform load balancer." width="862" height="584" class="aligncenter size-full wp-image-47466" style="border:2px solid #666666; padding:2px; margin:2px;" />

13. Select **Frontend&nbsp;configuration** in the left column. This opens up the **Frontend&nbsp;configuration** interface on the right column.

14. Create three **Protocol&#8209;IP&#8209;Port** tuples, each with:

    - **Protocol** – **TCP**
    - **IP** – The address you reserved in Step 5, selected from the drop-down menu (if there is more than one address, select the one labeled in parentheses with the name you specified in Step 5)
    - **Port** – **80**, **8080**, and **443** in the three tuples respectively

15. Click the <span style="background-color:#3366cc; color:white;"> Create </span> button.

    <img src="/nginx/images/gce-frontend-configuration.png" alt="Screenshot of the interface for frontend configuration of GCE network load balancer, used during deployment of NGINX Plus as the Google Cloud load balancer." width="1067" height="437" class="aligncenter size-full wp-image-47477" style="border:2px solid #666666; padding:2px; margin:2px;" />

<span id="testing"></span>
## Task 8: Testing the All-Active Load Balancing Deployment

Verify that GCE network load balancer is properly routing traffic to both NGINX Plus LB instances.

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

Working on a separate client machine, run this command, using the static IP address you set in the previous section for GCE network load balancer:

```shell
while true; do curl -s <GCE-Network-LB-external-static-IP-address> | grep Server: ;done
```

Alternatively, you can use a web browser to access this URL:

   **http://**_GCE-Network-LB-external-static-IP-address_

If load balancing is working properly, the unique **Server** field from the index page for each application instance appears in turn.

To verify that high availability is working:

1. Connect to one of the instances in the **nginx&#8209;plus&#8209;lb&#8209;instance&#8209;group** over SSH and run this command to force it offline:

   ```shell
   iptables -A INPUT -p tcp --destination-port 80 -j DROP
   ```

2. Verify that with one LB instance offline, the other LB instance still forwards traffic to the application instances (there might be a delay before GCE network load balancer detects that the first instance is offline). Continue monitoring and verify that GCE network load balancer then re-creates the first LB instance and brings it online.

3. When the LB instance is back online, run this command to return it to its working state:

   ```shell
   iptables -F
   ```

### Revision History

- Version 3 (July 2018) – Updates for Google Cloud Platform Marketplace
- Version 2 (April 2018) – Standardized information about root privilege and links to directive documentation
- Version 1 (November 2016) – Initial version (<span style="white-space: nowrap;">NGINX Plus R11</span>)
