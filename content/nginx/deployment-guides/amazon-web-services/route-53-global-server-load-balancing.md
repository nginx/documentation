---
description: Deploy global server load balancing (GSLB) for domains hosted in multiple
  AWS regions, with Amazon Route 53 and F5 NGINX Plus in an HA configuration.
nd-docs: DOCS-448
title: Global Server Load Balancing with Amazon Route 53 and NGINX Plus
toc: true
weight: 300
draft: true
noindex: true
type:
- how-to
---

This deployment guide explains how to configure global server load balancing (GSLB) of traffic for web domains hosted in Amazon [Elastic Compute Cloud](https://aws.amazon.com/ec2/) (EC2). For high availability and improved performance, you set up multiple backend servers (web servers, application servers, or both) for a domain in two or more AWS regions. Within each region, NGINX Plus load balances traffic across the backend servers.

The AWS Domain Name System (DNS) service, [Amazon Route 53](https://aws.amazon.com/route53/), performs global server load balancing by responding to a DNS query from a client with the DNS record for the region that is closest to the client and hosts the domain. For best performance and predictable failover between regions, "closeness" is measured in terms of network latency rather than the actual geographic location of the client.

The [Appendix](#appendix) provides instructions for creating EC2 instances with the names used in this guide, and installing and configuring the F5 NGINX software on them.

<span id="about-nginx"></span>
## About NGINX Plus

[NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) is the commercially supported version of the [NGINX Open Source](https://nginx.org/en) software. NGINX Plus is a complete application delivery platform, extending the power of NGINX with a host of enterprise‑ready capabilities that enhance an AWS application server deployment and are instrumental to building web applications at scale:

- [Full‑featured HTTP, TCP, and UDP load balancing](https://www.nginx.com/products/nginx/load-balancing/)
- [Intelligent session persistence](https://www.nginx.com/products/nginx/load-balancing/#session-persistence)
- [High‑performance reverse proxy]({{< ref "nginx/admin-guide/web-server/reverse-proxy.md" >}})
- [Caching and offload of dynamic and static content]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}})
- [Adaptive streaming to deliver audio and video to any device](https://www.nginx.com/products/nginx/streaming-media/)
- [Application-aware health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/) and [high availability](https://docs.nginx.com/nginx/admin-guide/high-availability/)
- [Advanced activity monitoring available via a dashboard or API](https://www.nginx.com/products/nginx/live-activity-monitoring/)
- [Management and real‑time configuration changes with DevOps‑friendly tools](https://www.nginx.com/products/nginx/load-balancing/#load-balancing-api)

<span id="topology"></span>
## Topology for Global Load Balancing with Amazon Route 53 and NGINX Plus

The setup for global server load balancing (GSLB) in this guide combines Amazon Elastic Compute Cloud (EC2) instances, <span style="white-space: nowrap;">Amazon Route 53</span>, NGINX Plus instances, and NGINX Open Source instances.

**Note:** [Global server load balancing](https://www.nginx.com/resources/glossary/global-server-load-balancing/) is also sometimes called _global load balancing_ (GLB). The terms are used interchangeably in this guide.

<img src="/nginx/images/aws-route-53-topology.png" alt="Diagram showing a topology for global server load balancing (GSLB). Eight backend servers, four in each of two regions, host the content for a domain. Two NGINX Plus load balancers in each region route traffic to the backend servers. For each client requesting DNS information for the domain, Amazon Route 53 provides the DNS record for the region closest to the client." style="border:2px solid #666666; padding:2px; margin:2px;" />

Route 53 is a Domain Name System (DNS) service that performs global server load balancing by routing each request to the AWS region closest to the requester's location. This guide uses two regions: {{<nb>}}**US West (Oregon)**{{</nb>}} and {{<nb>}}**US East (N. Virginia)**{{</nb>}}.

In each region, two or more NGINX Plus load balancers are deployed in a high‑availability (HA) configuration. In this guide, there are two NGINX Plus load balancer instances per region. You can also use NGINX Open Source for this purpose, but it lacks the [application health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/) that make for more precise error detection. For simplicity, we'll refer to NGINX Plus load balancers throughout this guide, noting when features specific to NGINX Plus are used.

The NGINX Plus instances load balance traffic across web or app servers in their region. The diagram shows four backend servers, but you can deploy as many as needed. In this guide, there are two NGINX Open Source web servers in each region (four total); each one serves a customized static page identifying the server so you can track how load balancing is working.

Health checks are an integral feature of the configuration. Route 53 monitors the health of each NGINX Plus load balancer, marking it as down if a connection attempt times out or the HTTP response code is not <span style="white-space: nowrap;">`200 OK`</span>. Similarly, the NGINX Plus load balancer monitors the health of the upstream web servers and propagates those errors to Route 53. If both web servers or both NGINX Plus instances in a region are down, Route 53 fails over to the other region.

<span id="prereqs"></span>
## Prerequisites

The instructions assume you have the following:

- [An AWS account](http://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/AboutAWSAccounts.html).
- An NGINX Plus subscription, either [purchased](https://www.nginx.com/products/pricing/#nginx-plus) or a <span style="white-space: nowrap;">[free 30-day trial](https://www.nginx.com/free-trial-request/)</span>.
- Familiarity with NGINX and NGINX Plus configuration syntax. Complete configuration snippets are provided, but not analyzed in detail.
- Eight EC2 instances, four in each of two regions.  The [Appendix](#appendix) provides instructions for creating instances with the expected names, and installing and configuring NGINX Plus and NGINX Open Source as appropriate.

<span id="gslb"></span>
## Configuring Global Server Load Balancing

With the [required AWS configuration](#prereqs) in place, we're ready to configure Route 53 for global server load balancing.

Complete step‑by‑step instructions are provided in the following sections:

- [Creating a Hosted Zone](#hosted-zone)
- [Linking the Domain to EC2 Instances](#link-instances)
- [Configuring Health Checks for Route 53 Failover](#route-53-health-checks)
- [Configuring NGINX Plus Application Health Checks](#nginx-plus-health-checks)

<span id="hosted-zone"></span>
### Creating a Hosted Zone

Create a _hosted zone_, which basically involves designating a domain name to be managed by Route 53. As covered in the instructions, you can either use (transfer) an existing domain name or purchase a new one from Amazon.

**Note**: When you transfer an existing domain, it can take up to 48 hours for the updated DNS record to propagate. The propagation time is usually much shorter for a new domain.

1. Log in to the [AWS Management Console](https://console.aws.amazon.com/) (**console.aws.amazon.com/**).

2. Access the Route 53 dashboard page by clicking **Services** in the top AWS navigation bar, mousing over **Networking** in the {{<nb>}}**All AWS Services**{{</nb>}} column and then clicking **Route 53**.

    <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-dashboard-open.png" alt="Screenshot showing how to access the Amazon Route 53 dashboard to configure global load balancing (GLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. Depending on your history working with Route 53 instances, you might see the **Route 53 Dashboard**. Navigate to the **Registered domains** tab, shown here:

    <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-registered-domains-tab.png" alt="Screenshot showing the Route 53 Registered domains tab during configuration of NGINX GSLB (global server load balancing)" style="border:2px solid #666666; padding:2px; margin:2px;" />

    If you see the Route 53 home page instead, access the **Registered domains** tab by clicking the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Get started now </span> button under {{<nb>}}**Domain registration**{{</nb>}}.

    <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-homepage.png" alt="Screenshot showing the Amazon Route 53 homepage for a first-time Route 53 user during configuration of AWS GSLB (global server load balancing) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

4. On the **Registered domains** tab (the first figure in the Step 3), click either the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Register Domain </span> or <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Transfer Domain </span> button as appropriate and follow the instructions.
5. When you register or transfer a domain, AWS by default creates a hosted zone for it. To verify that there is a hosted zone for your domain, navigate to the **Hosted Zones** tab on the Route 53 dashboard. This example shows the domain we registered for this guide, <span style="color:#3366cc;">nginxroute53.com</span>.

    <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-hosted-zones-tab.png" alt="Screenshot showing a newly registered hosted zone during configuration of Route 53 global load balancing (GLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

    (If no domain is listed, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create Hosted Zone </span> button. The <span style="font-weight: bold; white-space: nowrap;">Create Hosted Zone</span> column opens on the right side of the tab. Type the domain name in the **Domain Name** field and click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create </span> button at the bottom of the column.)

<span id="link-instances"></span>
### Linking the Domain to EC2 Instances

Now we link the domain to our EC2 instances so that content for the domain can be served from them. We do this by creating Route 53 _record sets_ for the domain. To implement GSLB, in the record sets we specify **Latency** as the _routing policy_. This means that in response to a client query for DNS information about a domain, Route 53 sends the DNS records for the region hosting that domain in which servers are responding most quickly to addresses in the client's IP range.

You can also select **Geolocation** as the routing policy, but failover might not work as expected. With the **Geolocation** routing policy, only clients from a specific a continent or country can access the content on a server. If you specify the United States, you also have the option of specifying a state as the "sublocation", limiting access to users from only that state. In this case, you can also create a generic US location to catch all requests that aren't sent from a listed sublocation.

We recommend that you choose **Geolocation** as the routing policy only for particular use cases, for example when you want to customize content for users in different countries – written in the country's official language with prices in its currency, say. If your goal is to deliver content as quickly as possible, **Latency** remains the best routing policy.

Create records sets for your domain:

1. If you're not already on the **Hosted Zones** tab of the Route 53 dashboard, navigate to it.

2. Click on the domain name in the **Domain Name** row for your hosted zone.

    <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-hosted-zones-tab-click-domain-name.png" alt="Screenshot showing how to access the Create Record Set interface for Route 53 hosted zone during configuration of AWS global load balancing (GLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

    The tab changes to display the record sets for the domain.

3. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create Record Set </span> button. The <span style="font-weight: bolder; white-space: nowrap;">Create Record Set</span> column opens on the right side of the tab, as shown here:

    <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-create-record-set-empty.png" alt="Screenshot showing Create Record Set interface in Route 53 during configuration of global load balancing (GLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

4. Fill in the fields in the **Create Record Set** column:

    - **Name** – You can leave this field blank, but for this guide we are setting the name to **www.nginxroute53.com**.
    - **Type** – **A {{<nb>}}– IPv4 address**{{</nb>}}.
    - **Alias** – **No**.
    - **TTL (Seconds)** – **60**.

        **Note**: Reducing TTL from the default of **300** in this way can decrease the time that it takes for Route 53 to fail over when both NGINX Plus load balancers in the region are down, but there is always a delay of about two minutes regardless of the TTL setting. This is a built‑in limitation of Route 53.

    - **Value** – [Elastic IP addresses](#elastic-ip) of the NGINX Plus load balancers in the first region [in this guide, {{<nb>}}**US West (Oregon)**]{{</nb>}}.
    - **Routing Policy** – **Latency**.

5. A new area opens when you select **Latency**. Fill in the fields as indicated (see the figure below):

    - **Region** – Region to which the load balancers belong (in this guide, {{<nb>}}**us-west-2**{{</nb>}}).
    - **Set ID** – Identifier for this group of load balancers (in this guide, {{<nb>}}**US West LBs**{{</nb>}}).
    - **Associate with Health Check** – **No**.

    When you complete all fields, the tab looks like this:

    <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-create-record-set-completed.png" alt="Screenshot showing a completed Route 53 record set during configuration of global server load balancing (GSLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

6. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create </span> button.

7. Repeat Steps 3 through 6 for the load balancers in the other region [in this guide, {{<nb>}}**US East (N. Virginia)**]{{</nb>}}.

You can now test your website. Insert your domain name into a browser and see that your request is being load balanced between servers based on your location.

<span id="route-53-health-checks"></span>
### Configuring Health Checks for Route 53 Failover

To trigger failover between AWS regions, we next configure health checks in Route 53. Route 53 monitors the NGINX Plus load balancers and fails over to the next closest region if both NGINX Plus load balancers are timing out or returning HTTP status codes other than <span style="white-space: nowrap;">`200 OK`</span>. (In this guide, failover is to the other region, since there are only two.)

**Note:** It can take up to **three minutes** for Route 53 to begin routing traffic to another region. Although the TTL you specify in the record set for a region can slightly affect the amount of time, failover is never instantaneous because of the processing Route 53 must perform.

<img src="/nginx/images/aws-route-53-topology-failover.png" alt="Diagram showing failover between AWS regions when Amazon Route 53 is configured for global server load balancing (GSLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

We create health checks both for each NGINX Plus load balancer individually and for the load balancers in each region as a pair. Then we update the record sets created in the previous section to refer to the health checks.


- [Configuring Route 53 Health Checks for Individual Load Balancers](#route-53-health-checks-individual)
- [Configuring Route 53 Health Checks for the Paired Load Balancers in Each Region](#route-53-health-checks-pair)
- [Modifying Record Sets to Associate Them with the Newly Defined Health Checks](#route-53-health-checks-record-sets)

<span id="route-53-health-checks-individual"></span>
#### Configuring Route 53 Health Checks for Individual Load Balancers

1. Navigate to the **Health checks** tab on the Route 53 dashboard.

    <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-health-checks-tab-welcome.png" alt="Screenshot of Amazon Route 53 welcome screen seen by first-time user of Route 53 during configuration of global server load balancing (GSLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

2. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create health check </span> button. In the {{<nb>}}**Configure health check**{{</nb>}} form that opens, specify the following values, then click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Next </span> button.

   - **Name** – Identifier for an NGINX Plus load balancer instance, for example {{<nb>}}**US West LB 1**{{</nb>}}.
   - **What to monitor** – **Endpoint**.
   - **Specify endpoint by** – {{<nb>}}**IP address**{{</nb>}}.
   - **IP address** – The [elastic IP address](#elastic-ip) of the NGINX Plus load balancer.
   - **Port** – The port advertised to clients for your domain or web service (the default is **80**).

   <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-configure-health-check.png" alt="Screenshot of Amazon Route 53 interface for configuring health checks, during configuration of AWS global load balancing (GLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. On the {{<nb>}}**Get notified when health check fails**{{</nb>}} screen that opens, set the **Create alarm** radio button to **Yes** or **No** as appropriate, then click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create health check </span> button.

   <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-get-notified-health-check.png" alt="Screenshot of Route 53 configuration screen for enabling notifications of failed health checks, during configuration of Route 53 global load balancing (GLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

4. Repeat Steps 2 and 3 for your other NGINX Plus load balancers (in this guide, {{<nb>}}**US West LB 2**{{</nb>}}, {{<nb>}}**US East LB 1**{{</nb>}}, and {{<nb>}}**US East LB 2**{{</nb>}}).

5. Proceed to the next section to configure health checks for the load balancer pairs.

<span id="route-53-health-checks-pair"></span>
#### Configuring Route 53 Health Checks for the Paired Load Balancers in Each Region

1. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create health check </span> button.

2. In the {{<nb>}}**Configure health check**{{</nb>}} form that opens, specify the following values, then click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Next </span> button.

   - **Name** – Identifier for the pair of NGINX Plus load balancers in the first region, for example {{<nb>}}**US West LBs**{{</nb>}}.
   - **What to monitor** – {{<nb>}}**Status of other health checks{{</nb>}} **.
   - **Health checks to monitor** – The health checks of the two US West load balancers (add them one after the other by clicking in the box and choosing them from the drop‑down menu as shown).
   - **Report healthy when** – **at least 1 of 2 selected health checks are healthy** (the choices in this field are obscured in the screenshot by the drop‑down menu).

   <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-configure-health-check-status-others.png" alt="Screenshot of Amazon Route 53 interface for configuring a health check of combined other health checks, during configuration of global server load balancing (GSLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

3. On the {{<nb>}}**Get notified when health check fails**{{</nb>}} screen that opens, set the **Create alarm** radio button as appropriate (see Step 5 in the <a href="#route-53-health-checks-individual">previous section</a>), then click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Create health check </span> button.

4. Repeat Steps 1 through 3 for the paired load balancers in the other region [in this guide, {{<nb>}}**US East (N. Virginia)**]{{</nb>}}.

When you have finished configuring all six health checks, the **Health checks** tab looks like this:

<img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-health-checks-tab-completed.png" alt="Screenshot showing six successfully configured health checks in Amazon Route 53, during configuration of NGINX Plus for GSLB (global server load balancing)" style="border:2px solid #666666; padding:2px; margin:2px;" />

<span id="route-53-health-checks-record-sets"></span>
#### Modifying Record Sets to Associate Them with the Newly Defined Health Checks

1. Navigate to the **Hosted Zones** tab.

2. Click on the domain name in the **Domain Name** row for your hosted zone.

   <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-hosted-zones-tab-click-domain-name.png" alt="Screenshot showing how to access the Create Record Set interface for Route 53 hosted zone during configuration of AWS global load balancing (GLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

   The tab changes to display the record sets for the domain.

3. In the list of record sets that opens, click the row for the record set belonging to your first region [in this guide, {{<nb>}}**US West (Oregon)**]{{</nb>}}. The <span style="font-weight: bolder; white-space: nowrap;">Edit Record Set</span> column opens on the right side of the tab.

   <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-route53-edit-record-set.png" alt="Screenshot of interface for editing Route 53 record sets during configuration of global server load balancing (GSLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

4. Change the **Associate with Health Check** radio button to **Yes**.

5. In the **Health Check to Associate** field, select the paired health check for your first region (in this guide, {{<nb>}}**US West LBs**{{</nb>}}).

6. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Save Record Set </span> button.

<span id="nginx-plus-health-checks"></span>
### Configuring NGINX Plus Application Health Checks

When you are using the NGINX Plus load balancer, we recommend that you to configure [application health checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/) of your backend servers. You can configure NGINX Plus to check more than simply whether a server is responding or returning `5_xx_` – for example, checking whether the content returned by the server is correct. When a server fails a health check, NGINX Plus removes it from the load‑balancing rotation until it passes a configured number of consecutive health checks. If all backend servers are down, NGINX Plus sends a `5_xx_` error to Route 53, which triggers a failover to another region.

These instructions assume that you have configured NGINX Plus on two EC2 instances in each region, as instructed in [Configuring NGINX Plus on the Load Balancers](#configure-load-balancers).

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Connect to the {{<nb>}}**US West LB 1**{{</nb>}} instance. For instructions, see <a href="../ec2-instances-for-nginx/#connect-to-instance">Connecting to an EC2 Instance</a>.

2. Change directory to **/etc/nginx/conf.d**.

   ```shell
   cd /etc/nginx/conf.d
   ```

3. Edit the {{<nb>}}**west-lb1.conf**{{</nb>}} file and add the **@healthcheck** location to set up health checks.

   ```nginx
   upstream backend-servers {
       server <public DNS name of Backend 1>; # Backend 1
       server <public DNS name of Backend 2>; # Backend 2
       zone backend-servers 64k;
   }

   server {
       location / {
           proxy_pass http://backend-servers;
       }

       location @healthcheck {
           proxy_pass http://backend-servers;
           proxy_connect_timeout 1s;
           proxy_read_timeout 1s;
           health_check uri=/ interval=1s;
       }
   }
   ```

   Directive documentation: [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_connect_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_connect_timeout), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [proxy_read_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout), [server virtual](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [server upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream), [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)

4. Verify the validity of the NGINX configuration and load it.

   ```shell
   nginx -t
   nginx -s reload
   ```

5. Repeat Steps 1 through 4 for the other three load balancers ({{<nb>}}**US West LB 2**{{</nb>}}, {{<nb>}}**US East LB 1**{{</nb>}}, and {{<nb>}}**US East LB2**{{</nb>}}).

   In Step 3, change the filename as appropriate ({{<nb>}}**west-lb2.conf**{{</nb>}}, {{<nb>}}**east-lb1.conf**{{</nb>}}, and {{<nb>}}**east-lb2.conf**{{</nb>}}). In the {{<nb>}}**east-lb1.conf**{{</nb>}} and {{<nb>}}**east-lb2.conf**{{</nb>}} files, the `server` directives specify the public DNS names of Backup 3 and Backup 4.

<span id="appendix"></span>
## Appendix

The instructions in this Appendix explain how to create EC2 instances with the names used in this guide, and then install and configure NGINX Open Source and NGINX Plus on them:

- [Creating EC2 Instances and Installing the NGINX Software](#create-instance-install-nginx)
- [Configuring Elastic IP Addresses](#elastic-ip)
- [Configuring NGINX Open Source on the Backend Servers](#configure-backend-servers)
- [Configuring NGINX Plus on the Load Balancers](#configure-load-balancers)

<span id="create-instance-install-nginx"></span>
### Creating EC2 Instances and Installing the NGINX Software

The deployment in this guide uses eight EC2 instances, four in each of two AWS regions. In each region, two instances run NGINX Plus to load balance traffic to the backend (NGINX Open Source) web servers running on the other two instances.

Step‑by‑step instructions for creating EC2 instances and installing NGINX software are provided in our deployment guide, [Creating Amazon EC2 Instances for NGINX Open Source and NGINX Plus]({{< ref "ec2-instances-for-nginx.md" >}}).

**Note:** When installing NGINX Open Source or NGINX Plus, you connect to each instance over SSH. To save time, leave the SSH connection to each instance open after installing the software, for reuse when you configure it with the instructions in the sections below.

Assign the following names to the instances, and then install the indicated NGINX software.

- In the first region, which is {{<nb>}}**US West (Oregon)**{{</nb>}} in this guide:

  - Two load balancer instances running NGINX Plus:

    - {{<nb>}}**US West LB 1**{{</nb>}}
    - {{<nb>}}**US West LB 2**{{</nb>}}

  - Two backend instances running NGINX Open Source:

         * {{<nb>}}**Backend 1**{{</nb>}}
    - {{<nb>}}**Backend 2**{{</nb>}}

- In the second region, which is {{<nb>}}**US East (N. Virginia)**{{</nb>}} in this guide:

  - Two load balancer instances running NGINX Plus:

    - {{<nb>}}**US East LB 1**{{</nb>}}
    - {{<nb>}}**US East LB 2**{{</nb>}}

  - Two backend instances running NGINX Open Source:

         * {{<nb>}}**Backend 3**{{</nb>}}
    - {{<nb>}}**Backend 4**{{</nb>}}

Here's the **Instances** tab after we create the four instances in the {{<nb>}}**N. Virginia**{{</nb>}} region.

<img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-ec2-useast-instances.png" alt="Screenshot showing newly created EC2 instances in one of two regions, which is a prerequisite to configuring AWS GSLB (global server load balancing) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

<span id="elastic-ip"></span>
### Configuring Elastic IP Addresses

For some EC2 instance types (for example, on‑demand instances), AWS by default assigns a different IP address to an instance each time you shut it down and spin it back up. A load balancer must know the IP addresses of the servers to which it is forwarding traffic, so the default AWS behavior requires you either to set up a service‑discovery mechanism or to modify the NGINX Plus configuration every time you shut down or restart a backend instance. (A similar requirement applies to Route 53 when we shut down or restart an NGINX Plus instance.) To get around this inconvenience, assign an _elastic IP address_ to each of the eight instances.

**Note:** AWS does not charge for elastic IP addresses as long as the associated instance is running. But when you shut down an instance, AWS charges a small amount to maintain the association to an elastic IP address. For details, see the Amazon EC2 Pricing page for your pricing model (for example, the **Elastic IP Addresses** section of the [On‑Demand Pricing](https://aws.amazon.com/ec2/pricing/on-demand/) page).

Perform these steps on all eight instances.

1. Navigate to the **Elastic IPs** tab on the EC2 Dashboard.

   <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2018/03/aws-ec2-elastic-ips-tab.png" alt="Screenshot of the Elastic IPs tab used during configuration of a new AWS EC2 instance, which is a prerequisite to configuring NGINX GSLB (global server load balancing)" style="border:2px solid #666666; padding:2px; margin:2px;" />

2. Click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Allocate New Address </span> button. In the window that pops up, click the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Yes, Allocate </span> button and then the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Close </span> button.

3. Associate the elastic IP address with an EC2 instance:

   - Right‑click in the IP address' row and select <span style="background-color:#666666; color:white; white-space: nowrap;"> Associate Address </span> from the drop‑down menu that appears.
   - In the window that pops up, click in the **Instance** field and select an instance from the drop‑down menu.

   Confirm your selection by clicking the <span style="background-color:#3366cc; color:white; white-space: nowrap;"> Associate </span> button.

   <img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2016/10/aws-ec2-associate-address-popup.png" alt="Screenshot of the interface for associating an AWS EC2 instance with an elastic IP address, which is a prerequisite to configuring AWS global load balancing (GLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

After you complete the instructions on all instances, the list for a region (here, **Oregon**) looks like this:

<img src="https://cdn-1.wp.nginx.com/wp-content/uploads/2018/03/aws-ec2-elastic-ip-address-list.png" alt="Screenshot showing the elastic IP addresses assigned to four AWS EC2 instances during configuration of global server load balancing (GSLB) with NGINX Plus" style="border:2px solid #666666; padding:2px; margin:2px;" />

<span id="configure-backend-servers"></span>
### Configuring NGINX Open Source on the Backend Servers

Perform these steps on all four backend servers: {{<nb>}}**Backend 1**{{</nb>}}, {{<nb>}}**Backend 2**{{</nb>}}, {{<nb>}}**Backend 3**{{</nb>}}, and {{<nb>}}**Backend 4**{{</nb>}}. In Step 3, substitute the appropriate name for `Backend X` in the **index.html** file.

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Connect over SSH to the instance (or return to the terminal you left open after installing NGINX Open Source) and change directory to and change directory to your root directory. For the instance in this guide, it is **/home/ubuntu**.

   ```shell
   cd /home/ubuntu
   ```

2. Create a directory called **public_html** and change directory to it.

   ```shell
   mkdir public_html
   cd public_html
   ```

3. Using your preferred text editor, create a new file called **index.html** and add this text to it:

   ```none
   This is Backend X
   ```

4. Change directory to **/etc/nginx/conf.d**.

   ```shell
   cd /etc/nginx/conf.d
   ```

5. Rename **default.conf** to **default.conf.bak** so that NGINX Plus does not load it.

   ```shell
   mv default.conf default.conf.bak
   ```

6. Create a new file called **backend.conf** and add this text, which defines the docroot for this web server:

   ```nginx
   server {
       root /home/ubuntu/public_html;
   }
   ```

   Directive documentation: [root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root), [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)

7. Verify the validity of the NGINX configuration and load it.

   ```shell
   nginx -t
   nginx -s reload
   ```

<span id="configure-load-balancers"></span>
### Configuring NGINX Plus on the Load Balancers

Perform these steps on all four backend servers: {{<nb>}}**US West LB 1**{{</nb>}}, {{<nb>}}**US West LB 2**{{</nb>}}, {{<nb>}}**US East LB 1**{{</nb>}}, and {{<nb>}}**US West LB 2**{{</nb>}}.

**Note:** Some commands require `root` privilege. If appropriate for your environment, prefix commands with the `sudo` command.

1. Connect over SSH to the instance (or return to the terminal you left open after installing NGINX Plus) and change directory to **/etc/nginx/conf.d**.

   ```shell
   cd /etc/nginx/conf.d
   ```

3. Rename **default.conf** to **default.conf.bak** so that NGINX Plus does not load it.

   ```shell
   mv default.conf default.conf.bak
   ```

4. Create a new file containing the following text, which configures load balancing of the two backend servers in the relevant region. The filename on each instance is:

   - For {{<nb>}}**US West LB 1**{{</nb>}} – {{<nb>}}**west-lb1.conf**{{</nb>}}
   - For {{<nb>}}**US West LB 2**{{</nb>}} – {{<nb>}}**west-lb2.conf**{{</nb>}}
   - For {{<nb>}}**US East LB 1**{{</nb>}} – {{<nb>}}**east-lb1.conf**{{</nb>}}
   - For {{<nb>}}**US West LB 2**{{</nb>}} – {{<nb>}}**east-lb2.conf**{{</nb>}}

   In the `server` directives in the `upstream` block, substitute the public DNS names of the backend instances in the region; to learn them, see the **Instances** tab in the EC2 Dashboard.

   ```nginx
   upstream backend-servers {
       server <public DNS name of Backend 1>; # Backend 1
       server <public DNS name of Backend 2>; # Backend 2
   }
   server {
       location / {
           proxy_pass http://backend-servers;
       }
   }
   ```

   Directive documentation: [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location), [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass), [server virtual](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [server upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server), [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)

5. Verify the validity of the NGINX configuration and load it.

   ```shell
   nginx -t
   nginx -s reload
   ```

8. To test that the configuration is working correctly, for each load balancer enter its public DNS name in the address field of your web browser. As you access the load balancer repeatedly, the content of the page alternates between "This is Backend 1" and "This is Backend 2" in your first region, and "This is Backend 3" and "This is Backend 4" in the second region.

Now that all eight EC2 instances are configured and local load balancing is working correctly, we can set up global server load balancing with Route 53 to route traffic based on the IP address of the requesting client.

Return to main instructions, [Configuring Global Server Load Balancing](#gslb)

### Revision History

- Version 3 (April 2018) – Reorganization of Appendix
- Version 2 (January 2017) – Clarified information about root permissions; miscellaneous fixes (NGINX Plus Release 11)
- Version 1 (October 2016) – Initial version (NGINX Plus Release 10)

