---
description: Create a highly available active-active deployment of F5 NGINX Plus on
  Microsoft Azure in combination with the Azure Standard Load Balancer.
nd-docs: DOCS-457
title: Active-Active HA for NGINX Plus on Microsoft Azure Using the Azure Standard
  Load Balancer
toc: true
weight: 100
type:
- how-to
---

This guide explains how to use F5 NGINX Plus to complement the native load‑balancing options in the Microsoft Azure cloud. We show how to implement our recommended solution, which combines Azure's Standard Load Balancer for fast and efficient handling of Layer 4 traffic and NGINX Plus for advanced, Layer 7 features such as load balancing, caching, and content‑based routing. The combined Standard Load Balancer and NGINX Plus solution is fast, powerful, reliable, and likely to be relatively low‑cost.

This guide explains how to set up Standard Load Balancer in front of a specific number of NGINX Plus load balancers.

The [Appendix](#appendix) provides instructions for creating Azure virtual machines (VMs) with the names used in this guide, and installing and configuring the NGINX software on them.

<span id="about-slb"></span>
## About Standard Load Balancer

[Azure Standard Load Balancer](https://azure.microsoft.com/en-us/services/load-balancer/) works at Layer 4 (the connection level), quickly and efficiently handling both inbound and outbound traffic. Its developers say that it provides low latency, high throughput, and the ability to scale up to millions of TCP and UDP flows. (Because TCP is the transport protocol for HTTP, this translates to efficient handling of HTTP traffic, but without the processing of HTTP‑related data that NGINX Plus does.)

The purpose, design, and operation of Standard Load Balancer are similar to the native Layer 4 load balancers in other cloud environments, such as [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) (NLB) in Amazon Web Services (AWS) and [Network Load Balancing](https://cloud.google.com/load-balancing/docs/network/) on the Google Cloud Platform (GCP). Like the solution described in this guide, we have solutions for highly availability of NGINX Plus in [AWS]({{< relref "../amazon-web-services/high-availability-network-load-balancer.md" >}}) and the [GCP]({{< relref "../google-cloud-platform/high-availability-all-active.md" >}}). If you have previously implemented one of them, you'll find the process similar for Standard Load Balancer.

<span id="about-traffic-manager"></span>
## About Traffic Manager

Azure Traffic Manager is a DNS‑based traffic load balancer that optimally distributes traffic to services across global Azure regions. It uses DNS to direct client requests to the most appropriate service endpoint based on a traffic‑routing method and the health of the endpoints. An endpoint is any Internet‑facing service hosted inside or outside of Azure – in our case, the endpoints are the Standard Load Balancers that front NGINX Plus instances in the regions. Traffic Manager is resilient to failure, including the failure of an entire Azure region.

<span id="about-nginx"></span>
## About NGINX Plus

NGINX Plus is complementary to Standard Load Balancer. Operating at Layer 7 (the application layer), it uses more advanced load‑balancing criteria, including schemes that rely on the content of requests and the results of NGINX Plus's [active health checks]({{< ref "nginx/admin-guide/load-balancer/http-health-check.md" >}}).

[NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) is the commercially supported version of [NGINX Open Source](https://nginx.org/en). NGINX Plus is a complete application delivery platform, extending the power of NGINX with a host of enterprise‑ready capabilities that enhance an AWS web application deployment and are instrumental to building web applications at scale.

NGINX Plus provides both reverse‑proxy features and load‑balancing features, including:

- Full‑featured [HTTP]({{< ref "nginx/admin-guide/load-balancer/http-load-balancer.md" >}}), [TCP, and UDP]({{< ref "nginx/admin-guide/load-balancer/tcp-udp-load-balancer.md" >}}) load balancing
- [Intelligent session persistence]({{< ref "nginx/admin-guide/load-balancer/http-load-balancer.md#session-persistence" >}})
- [High‑performance reverse proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})
- [Caching and offload of dynamic and static content]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}})
- Adaptive streaming to deliver audio and video to any device
- [Application-aware health checks]({{< ref "nginx/admin-guide/load-balancer/http-health-check.md" >}}) and [high availability]({{< ref "nginx/admin-guide/high-availability/ha-keepalived.md" >}})
- Advanced activity monitoring available via a [Dashboard]({{< ref "nginx/admin-guide/monitoring/live-activity-monitoring.md#using-the-dashboard" >}}) or [REST API]({{< ref "nginx/admin-guide/monitoring/live-activity-monitoring.md#using-the-rest-api" >}})
- [Management and real‑time configuration changes with DevOps‑friendly tools](https://www.nginx.com/products/nginx/load-balancing/#load-balancing-api)

<span id="overview"></span>
## Solution Overview

This guide covers how to set up Azure’s Standard Load Balancer and Traffic Manager to provide a highly available, cross‑region, active‑active deployment of NGINX Plus as the load balancer for NGINX Open Source web servers.

The complete configuration of a Standard Load Balancer consists of a front‑end public IP address, a pool of backend addresses, a health probe, and one or more load‑balancing rules.

Standard Load Balancer uses a purpose‑built source network address translation (SNAT) algorithm to load balance TCP connections. By default, when you create a Standard Load Balancer, you must also allocate a public IP address for it.

To distribute traffic to the Azure virtual machines (VMs) hosting your application, you create a backend address pool and specify the pool from within each VM’s NIC resource.

Standard Load Balancer uses health probes to determine whether a backend instance (in this case, NGINX Plus) can accept new flows. Health probes work much the same as NGINX Plus health checks. For details, see the [Azure documentation](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview).

You also create a load‑balancing rule to define how traffic is distributed to the VMs, specifying the IP address and port of the front end that listens for incoming traffic and the name of the back‑end pool of application instances, along with the port number on which the instances listen.

<img src="/nginx/images/azure-ha-load-balancer-topology.png" alt="Topology diagram for high availability deployment of NGINX Plus in Azure" width="1025" height="1000" class="aligncenter size-full wp-image-64981" style="border:2px solid #666666; padding:2px; margin:2px;" />

In this guide, the back‑end pool for Standard Load Balancer consists of two NGINX Plus instances, which reverse proxy and load balance traffic to two sets of backend applications, which in turn are also highly available. This setup is then replicated in a different region to create a region failover. You can also use this guide to deploy a greater number of NGINX Plus or NGINX instances in as many regions as you wish.

<span id="prereqs"></span>
## Prerequisites
These instructions assume you have the following:

- An Azure [account](https://azure.microsoft.com/en-us/free/).
- An Azure [subscription](https://docs.microsoft.com/en-us/azure/azure-glossary-cloud-terminology?toc=/azure/virtual-network/toc.json#subscription).
- An Azure [resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups), preferably dedicated to the HA solution. In this guide, it is called {{<nb>}}**NGINX-Plus-HA**{{</nb>}}.
- An Azure [virtual network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview).
- Six Azure VMs, four running NGINX Open Source and two running NGINX Plus (in each region where you deploy the solution). You need a paid or trial subscription for each NGINX Plus instance.

   The [Appendix](#appendix) provides instructions for creating instances with the expected names, and installing and configuring the NGINX software.
- Familiarity with NGINX and NGINX Plus configuration syntax. Complete configuration snippets are provided, but not described in detail.

<span id="slb-set-up"></span>
## Setting Up a Standard Load Balancer

With NGINX Open Source and NGINX Plus installed and configured on the Azure VMs (see the [Appendix](#appendix)) in two different regions (or more if you wish), we’re ready to configure a Standard Load Balancer in each region for a highly available, active‑active NGINX Plus setup.

- [Creating a Standard Load Balancer](#slb-create)
- [Configuring the Standard Load Balancer](#slb-configure)
- [Verifying Correct Operation](#slb-verify-operation)

<span id="slb-create"></span>
### Creating a Standard Load Balancer

1. Access the [Microsoft Azure portal](https://portal.azure.com/) (**<https://portal.azure.com/>**) and sign in.

2. Navigate to the **Load balancers** page. (One way is to click the menu icon at the left end of the Microsoft Azure title bar and select **Load balancers** from the menu.)

   <img src="/nginx/images/azure-create-lb-navigate.png" alt="Screenshot of navigating to the 'Load Balancers' page in Azure" width="1024" height="491" class="aligncenter size-full wp-image-64980" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. On the **Load balancers** page that opens, click the <span style="background-color:#137ad1; color:white; white-space: nowrap;"> Create load balancer </span> button (or **<span style="color:#4d9bdc;">+</span> Add** in the upper left corner of the page).

4. On the **Create load balancer** page that opens (to the **Basics** tab), enter the following values:

   - **Subscription** – Name of your subscription ({{<nb>}}**NGINX-Plus-HA-subscription**{{</nb>}} in this guide)
   - **Resource group** – Name of your resource group ({{<nb>}}**NGINX-Plus-HA**{{</nb>}} in this guide)
   - **Name** – Name of your Standard Load Balancer (**lb** in this guide)
   - **Region** – Name selected from the drop‑down menu ({{<nb>}}**(US) West US 2**{{</nb>}} in this guide)
   - **Type** – **Public**
   - **SKU** – **Standard**
   - **Public IP address** – **Create new**
   - **Public IP address name** – Name for the address (**public\_ip\_lb** in this guide)
   - **Public IP address SKU** – **Standard**
   - **Availability zone** – **Zone‑redundant**
   - **Add a public IPv6 address** – **No**

   <a href="/nginx/images/azure-create-lb-basics.png"><img src="/nginx/images/azure-create-lb-basics.png" alt="Screenshot of the 'Basics' tab for creating an Azure Standard Load Balancer" width="1024" height="902" class="aligncenter size-full wp-image-64979" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. If you want to apply one or more tags to the load balancer, click the <span style="font-weight: bold; white-space: nowrap;">Next : Tags ></span> button. Otherwise, click the <span style="background-color:#137ad1; color:white; white-space: nowrap;"> Review + create </span> button.

5. Review your settings (return to the **Basic** tab if corrections are necessary). Click the <span style="background-color:#137ad1; color:white;"> Create </span> button.

   <a href="/nginx/images/azure-create-lb-validation-passed.png"><img src="/nginx/images/azure-create-lb-validation-passed.png" alt="Screenshot of Azure 'Validation passed' page for creating a Standard Load Balancer" width="1024" height="627" class="aligncenter size-full wp-image-64978" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   A page like the following appears when deployment is complete.

   <a href="/nginx/images/azure-create-lb-deployment-complete.png"><img src="/nginx/images/azure-create-lb-deployment-complete.png" alt="Screenshot of Azure 'Deployment complete' page for creating a Standard Load Balancer" width="1024" height="582" class="aligncenter size-full wp-image-64977" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>


<span id="slb-configure"></span>
### Configuring the Standard Load Balancer

1. If you are not already on the **Load balancers** page, click **Load balancers** in the left navigation column.

2. Click the name of the load balancer in the **Name** column of the table (**lb** in this guide).

   <a href="/nginx/images/azure-create-lb-load-balancers.png"><img src="/nginx/images/azure-create-lb-load-balancers.png" alt="Screenshot of Azure 'Load Balancers' page" width="1024" height="393" class="aligncenter size-full wp-image-64976https://www.nginx.com/wp-content/uploads/2020/09/Azure-create-lb-select-Backend-pools.png" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   <span id="slb-configure-lb-overview"></span>
3. The page that opens has the load balancer name in the upper left corner (**lb** in this guide). Click **Backend pools** in the left navigation column.

   <a href="/nginx/images/azure-create-lb-select-backend-pools.png"><img src="/nginx/images/azure-create-lb-select-backend-pools.png" alt="Screenshot of selecting 'Backend pools' on details page for an Azure Standard Load Balancer" width="1024" height="543" class="aligncenter size-full wp-image-64975" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

4. On the {{<nb>}}**lb | Backend Pools**{{</nb>}} page that opens, click **<span style="color:#4d9bdc;">+</span> Add** in the upper left corner of the main pane.

5. On the {{<nb>}}**Add backend pool**{{</nb>}} page that opens, enter the following values, then click the <span style="background-color:#137ad1; color:white;"> Add </span> button:

   - **Name** – Name of the new backend pool (**lb\_backend_pool** in this guide)
   - **IP version** – **IPv4**
   - **Virtual machines** – {{<nb>}}**ngx-plus-1**{{</nb>}} and {{<nb>}}**ngx-plus-2**{{</nb>}}

   <a href="/nginx/images/azure-create-lb-add-backend-pool.png"><img src="/nginx/images/azure-create-lb-add-backend-pool.png" alt="Screenshot of Azure 'Add backend pool' page for Standard Load Balancer" width="1024" height="891" class="aligncenter size-full wp-image-64974" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   After a few moments the virtual machines appear in the new backend pool.

6. Click **Health probes** in the left navigation column, and then **<span style="color:#4d9bdc;">+</span> Add** in the upper left corner of the main pane on the {{<nb>}}**lb | Health probes**{{</nb>}} page that opens.

7. On the {{<nb>}}**Add health probe**{{</nb>}} page that opens, enter the following values, then click the <span style="background-color:#137ad1; color:white; white-space: nowrap;"> OK </span> button.

   - **Name** – Name of the new backend pool (**lb\_probe** in this guide)
   - **Protocol** – **HTTP** or **HTTPS**
   - **Port** – **80** or **443**
   - **Path** – **/**
   - **Interval** – **5**
   - **Unhealthy threshold** – **2**

   <a href="/nginx/images/azure-create-lb-add-health-probe.png"><img src="/nginx/images/azure-create-lb-add-health-probe.png" alt="Screenshot of Azure 'Add health probe' page for Standard Load Balancer" width="1024" height="650" class="aligncenter size-full wp-image-64973" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   After a few moments the new probe appears in the table on the {{<nb>}}**lb | Health probes**{{</nb>}} page. This probe queries the NGINX Plus landing page every five seconds to check whether NGINX Plus is running.

8. Click {{<nb>}}**Load balancing rules**{{</nb>}} in the left navigation column, and then **<span style="color:#4d9bdc;">+</span> Add** in the upper left corner of the main pane on the {{<nb>}}**lb | Load balancing rules**{{</nb>}} page that opens.

9. On the {{<nb>}}**Add load balancing rule**{{</nb>}} page that opens, enter or select the following values, then click the <span style="background-color:#137ad1; color:white;"> OK </span> button.

   - **Name** – Name of the rule (**lb\_rule** in this guide)
   - **IP version** – **IPv4**
   - **Frontend IP address** – The Standard Load Balancer's public IP address, as reported in the {{<nb>}}**Public IP address**{{</nb>}} field on the **Overview** tag of the Standard Load Balancer's page (for an example, see [Step 3](#slb-configure-lb-overview) above); in this guide it is {{<nb>}}**51.143.107.x (LoadBalancerFrontEnd)**{{</nb>}}
   - **Protocol** – **TCP**
   - **Port** – **80**
   - **Backend port** – **80**
   - **Backend pool** – **lb_backend**
   - **Health probe** – {{<nb>}}**lb_probe (HTTP:80)**{{</nb>}}
   - **Session persistence** – **None**
   - **Idle timeout (minutes)** – **4**
   - **TCP reset** – **Disabled**
   - **Floating IP (direct server return)** – **Disabled**
   - **Create implicit outbound rules** – **Yes**

   <a href="/nginx/images/azure-create-lb-add-load-balancing-rule.png"><img src="/nginx/images/azure-create-lb-add-load-balancing-rule.png" alt="Screenshot of Azure 'Add load balancing rule' page for Standard Load Balancer" width="1024" height="1032" class="aligncenter size-full wp-image-64972" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   After a few moments the new rule appears in the table on the {{<nb>}}**lb | Load balancing rules**{{</nb>}} page.

<span id="slb-verify-operation"></span>
### Verifying Correct Operation

1. To verify that Standard Load Balancer is working correctly, open a new browser window and navigate to the IP address for the Standard Load Balancer front end, which appears in the {{<nb>}}**Public IP address**{{</nb>}} field on the **Overview** tab of the load balancer's page on the dashboard (for an example, see [Step 3](#slb-configure-lb-overview) of _Configuring the Standard Load Balancer_).

2. The default {{<nb>}}**Welcome to nginx!**{{</nb>}} page indicates that the Standard Load Balancer has successfully forwarded a request to one of the two NGINX Plus instances.

   <img src="/nginx/images/azure-create-lb-welcome-to-nginx.png" alt="Screenshot of 'Welcome to nginx!' page that verifies correct configuration of an Azure Standard Load Balancer" width="1024" height="328" class="aligncenter size-full wp-image-64971" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. To verify that the NGINX Plus load balancer is working correctly, add **/application1** and then **/application2** to the public IP address. Pages like the following indicate that you have reached NGINX Open Source instances serving the two backend applications, **App 1** and **App 2**.

   <a href="/nginx/images/aws-nlb-app1.png"><img src="/nginx/images/aws-nlb-app1.png" alt="Screenshot of standard NGINX web server demo page from App 1" width="1024" height="491" class="aligncenter size-full wp-image-54839" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

   <a href="/nginx/images/aws-nlb-app2-v2.png"><img src="/nginx/images/aws-nlb-app2-v2.png" alt="Screenshot of standard NGINX web server demo page from App 2" width="1024" height="491" class="aligncenter size-full wp-image-54839" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

<span id="traffic-manager"></span>
## Setting Up Azure Traffic Manager

Once you’ve tested that the Standard Load Balancer has been correctly deployed, you can provide even better availability and resilience by provisioning the complete setup (Standard Load Balancer, NGINX Plus load balancers, and NGINX Open Source web servers) in additional Azure regions.

In this case, you need to set up Azure Traffic Manager for DNS‑based global server load balancing (GSLB) among the regions. The involves creating a DNS name for the Standard Load Balancer and registering it as an endpoint in Traffic Manager.

1. Navigate to the {{<nb>}}**Public IP addresses**{{</nb>}} page. (One way is to enter {{<nb>}}**Public IP addresses**{{</nb>}} in the search field of the Azure title bar and select that value in the **Services** section of the resulting drop‑down menu.)

2. Click the name of the Standard Load Balancer's public IP address in the **Name** column of the table (here it is **public\_ip_lb**).

   <a href="/nginx/images/azure-create-lb-public-ip-addresses.png"><img src="/nginx/images/azure-create-lb-public-ip-addresses.png" alt="Screenshot of Azure 'Public IP addresses' page" width="1024" height="600" class="aligncenter size-full wp-image-64970" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

3. On the **public\_ip_lb** page that opens, click **Configuration** in the left navigation column.

4. Enter the DNS name for the Standard Load Balancer in the {{<nb>}}**DNS name label**{{</nb>}} field. In this guide, we're accepting the default, {{<nb>}}**public-ip-dns**{{</nb>}}.

   <a href="/nginx/images/azure-create-lb-public-ip-lb.png"><img src="/nginx/images/azure-create-lb-public-ip-lb.png" alt="Screenshot of Azure page for public IP address of a Standard Load Balancer" width="1024" height="465" class="aligncenter size-full wp-image-64969" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

5. Navigate to the {{<nb>}}**Traffic Manager profiles**{{</nb>}} tab. (One way is to enter {{<nb>}}**Traffic Manager profiles**{{</nb>}} in the search field of the Azure title bar and select that value in the **Services** section of the resulting drop‑down menu.)

6. Click **<span style="color:#4d9bdc;">+</span> Add** in the upper left corner of the page.

7. On the {{<nb>}}**Create Traffic Manager profile**{{</nb>}} page that opens, enter or select the following values and click the <span style="background-color:#137ad1; color:white; white-space: nowrap;"> Create </span> button.

   - **Name** – Name of the profile (**ngx** in this guide)
   - **Routing method** – **Performance**
   - **Subscription** – {{<nb>}}**NGINX-Plus-HA-subscription**{{</nb>}} in this guide
   - **Resource group** – {{<nb>}}**NGINX-Plus-HA**{{</nb>}} in this guide

   _Azure-create-lb-create-Traffic-Manager-profile_
   <a href="/nginx/images/azure-create-trafficmgr-create-tm-profile.png"><img src="/nginx/images/azure-create-trafficmgr-create-tm-profile.png" alt="Screenshot of Azure 'Create Traffic Manager profile' page" width="1024" height="581" class="aligncenter size-full wp-image-64968" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

8. It takes a few moments to create the profile. When it appears in the table on the {{<nb>}}**Traffic Manager profiles**{{</nb>}} page, click its name in the **Name** column.

9. On the **ngx** page that opens, click **Endpoints** in the left navigation column, then **<span style="color:#4d9bdc;">+</span> Add** in the main part of the page.

10. On the **Add endpoint** window that opens, enter or select the following values and click the <span style="background-color:#137ad1; color:white;"> Add </span> button.

    - **Type** – {{<nb>}}**Azure endpoint**{{</nb>}}
    - **Name** – Endpoint name ({{<nb>}}**ep-lb-west-us**{{</nb>}} in this guide)
    - **Target resource type** – {{<nb>}}**Public IP address**{{</nb>}}
    - **Public IP address** – Name of the Standard Load Balancer's public IP address (**public\_ip_lb (51.143.107.x)** in this guide)
    - **Custom Header settings** – None in this guide

    <a href="/nginx/images/azure-create-trafficmgr-add-endpoint.png"><img src="/nginx/images/azure-create-trafficmgr-add-endpoint.png" alt="Screenshot of Azure 'Add endpoint' page" width="1024" height="578" class="aligncenter size-full wp-image-64967" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

11. For each additional region, repeat the steps in [Setting Up a Standard Load Balancer](#slb-set-up), and then the steps in this section.

<span id="appendix"></span>
## Appendix

This Appendix provides links to instructions for creating Azure VMs with the names used in this guide, and then installing and configuring NGINX Open Source and NGINX Plus on them:

- [Creating Azure VMs and Installing the NGINX Software](#create-vm-install-nginx)
- [Configuring NGINX Open Source on the Web Servers](#configure-web-servers)
- [Configuring NGINX Plus on the Load Balancers](#configure-load-balancers)

After completing the instructions, you have completed the prerequisites for this guide and can continue to [Setting Up a Standard Load Balancer](#slb-set-up).

<span id="create-vm-install-nginx"></span>
### Creating Azure VMs and Installing the NGINX Software

The deployment in this guide uses six VMs: two VMs running NGINX Plus that load balance traffic to four VMs running NGINX Open Source as a web server. The four NGINX Open Source VMs are deployed in two pairs, each pair running a different app.

<span style="white-space: nowrap;">Step-by-step</span> instructions for creating VMs and installing NGINX Open Source and NGINX Plus are provided in our deployment guide, [Creating Microsoft Azure Virtual Machines for NGINX Open Source and NGINX Plus]({{< ref "virtual-machines-for-nginx.md" >}}).

**Note:** When installing NGINX Open Source or NGINX Plus, you connect to each instance over SSH. To save time, leave the SSH connection to each instance open after installing the software, for reuse when you configure it using the instructions referenced in the sections below.

Assign the following names to the VMs, and then install the indicated NGINX software.

- Four NGINX Open Source VMs:
  - **App 1**:
    - **ngx-oss-app1-1**
    - **ngx-oss-app1-2**
  - **App 2**:
    - **ngx-oss-app2-1**
    - **ngx-oss-app2-2**

- Two NGINX Plus VMs:
  - **ngx-plus-1**
  - **ngx-plus-2**

**Note:** The two NGINX Plus VMs must have a public IP address with same SKU type as the Standard Load Balancer you are creating (in this guide, **Standard**).  Instructions are included in our deployment guide, [Creating Microsoft Azure Virtual Machines for NGINX Open Source and NGINX Plus]({{< ref "virtual-machines-for-nginx.md" >}}).

<span id="configure-web-servers"></span>
### Configuring NGINX Open Source on the Web Servers

For the purposes of this guide, you configure the NGINX Open Source VMs as web servers that return a page specifying the server name, address, and other information. As an example, here’s the page returned by **App 1**:

<a href="/nginx/images/aws-nlb-app1.png"><img src="/nginx/images/aws-nlb-app1.png" alt="Screenshot of standard NGINX web server demo page from App 1" width="1024" height="491" class="aligncenter size-full wp-image-54839" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

<span style="white-space: nowrap;">Step-by-step</span> instructions are provided in our deployment guide, <a href="../../setting-up-nginx-demo-environment#nginx-oss">Setting Up an NGINX Demo Environment</a>.

Complete the instructions on all four web servers:

- Running **App 1**:
  - **ngx-oss-app1-1**
  - **ngx-oss-app1-2**
- Running **App 2**:
  - **ngx-oss-app2-1**
  - **ngx-oss-app2-2**

<span id="configure-load-balancers"></span>
### Configuring NGINX Plus on the Load Balancers

For the purposes of this guide, you configure the NGINX Plus VMs as load balancers to distribute requests to the NGINX Open Source web servers you set up in [Configuring NGINX Open Source on the Web Servers](#configure-web-servers).

<span style="white-space: nowrap;">Step-by-step</span> instructions are provided in our deployment guide, <a href="../../setting-up-nginx-demo-environment#nginx-plus">Setting Up an NGINX Demo Environment</a>.

Complete the instructions on both **ngx-plus-1** and **ngx-plus-2**.

### Revision History

- Version 1 (September 2020) – Initial version (NGINX Plus Release 22)
