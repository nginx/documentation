---
title: Frequently Asked Questions
weight: 800
toc: true
docs: DOCS-881
url: /nginxaas/azure/faq/
type:
- concept
---

Table of contents

- [Billing](#billing)
- [Billing/Overview](#billingoverview)
- [Deployment](#deployment)
- [Getting Started/Create Deployment](#getting-startedcreate-deployment)
- [Getting Started/Nginx Configuration/Nginx Configuration Portal](#getting-startednginx-configurationnginx-configuration-portal)
- [Getting Started/SSL TLS Certificates](#getting-startedssl-tls-certificates)
- [Getting Started/SSL TLS Certificates/Overview](#getting-startedssl-tls-certificatesoverview)
- [Getting Started/SSL TLS Certificates/SSL TLS Certificates Portal](#getting-startedssl-tls-certificatesssl-tls-certificates-portal)
- [Monitoring](#monitoring)
- [Monitoring/Enable Alerts](#monitoringenable-alerts)
- [Monitoring/Enable Logging](#monitoringenable-logging)
- [Monitoring/Enable Monitoring](#monitoringenable-monitoring)
- [New Quickstart](#new-quickstart)
- [Overview](#overview)
- [Overview/Enable Logging](#overviewenable-logging)
- [Overview/Feature Comparison](#overviewfeature-comparison)
- [Overview/Overview](#overviewoverview)
- [Quickstart/Scaling](#quickstartscaling)
- [Quickstart/Scaling/#Manual Scaling](#quickstartscalingmanual-scaling)
- [Quickstart/Security Controls](#quickstartsecurity-controls)
- [Quickstart/Security Controls/Securing Upstream Traffic](#quickstartsecurity-controlssupporting-upstream-traffic)
- [Quickstart/Upgrade Channels](#quickstartupgrade-channels)



## Deployment


### Can I migrate from on-prem NGINX+ to NGINXaaS on Azure?

- Yes, you can bring your own configurations or create a new configuration in the cloud. See the [NGINXaaS Deployment]({{< ref "/nginxaas-azure/getting-started/create-deployment/">}}) documentation for more details.



## Getting Started/Nginx Configuration/Nginx Configuration Portal


### Will updates to my virtual network’s DNS settings automatically apply to my NGINXaaS deployment?

- No,

### Does changing the worker_connections in the NGINX config have any effect?

- No. While changing the value of the directive in the config is allowed, the change is not applied to the underlying NGINX resource of your deployment.

### What ports can my deployment listen on?

- Due to port restrictions on Azure Load Balancer health probes, ports `19`, `21`, `70`, and `119` are not allowed. The NGINXaaS deployment can listen on all other ports. We limit the maximum listen ports in the NGINX configuration to 5 on the Basic and current Standard (v1) plan. Configurations that specify over 5 unique ports are rejected. With the Standard V2 plan, we allow users to listen on more than 5 ports. The first five ports under this plan come at no extra cost and there are charges for each additional port utilized.

## Getting Started/SSL TLS Certificates

### What types and formats of certificates are supported in NGINXaaS?

- NGINXaaS supports self-signed certificates, Domain Validated (DV) certificates, Organization Validated (OV) certificates, and Extended Validation (EV) certificates.

- Currently, NGINXaaS supports PEM and PKCS12 format certificates.

- See the [SSL/TLS Certificates documentation]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}}) to learn how to change certificates.

### Can I configure the TLS policy to control TLS protocol versions?

- Yes. You can overwrite the NGINX default protocol to configure the desired TLS/SSL policy. Read more about the procedure in the [Module ngx_http_ssl_module](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) documentation.

### Can I associate multiple certificates for the same domain?

- Yes, the "ssl_certificate" directive can be specified multiple times to load certificates of different types. To learn more, see the [Module ngx_http_ssl_module](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) documentation.

### Will my deployment detect a new version of my certificate and apply it?

- NGINXaaS supports certificate rotation. See the [Certificate Rotation documentation]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/overview.md#certificate-rotation" >}}) to learn more.

## Getting Started/SSL TLS Certificates/Overview

### How many TLS/SSL certificates does NGINXaaS support?

- NGINXaaS supports up to 100 TLS/SSL certificates.

## Getting Started/SSL TLS Certificates/SSL TLS Certificates Portal

### Does NGINXaaS natively integrate with Azure Key Vault?

- Yes, NGINXaaS natively integrates with Azure Key Vault, so you can bring your own certificates and manage them in a centralized location. You can learn more about adding certificates in Azure Key Vault in the [SSL/TLS Certificates documentation]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}}).

## Monitoring

### How do I analyze traffic statistics for NGINXaaS?

- NGINXaaS is integrated with [Azure monitoring](https://learn.microsoft.com/en-us/azure/azure-monitor/overview). NGINXaaS publishes [traffic statistics]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md" >}}) in Azure monitoring. Customers can analyze the traffic statistics by following the steps mentioned in the [NGINXaaS Monitoring]({{< ref "/nginxaas-azure/monitoring/enable-monitoring.md" >}}) documentation.

## Monitoring/Enable Alerts

### Can I set up an alert with NGINXaaS?

- You can set up an alert with NGINXaaS by following the steps outlined in the [Configure Alerts]({{< ref "/nginxaas-azure/monitoring/configure-alerts.md">}}) documentation.

## Monitoring/Enable Logging

### What types of logs does NGINXaaS provide?

- NGINXaaS supports the following [two types of logs]({{< ref "/nginxaas-azure/monitoring/enable-logging/">}}).

### What is the retention policy for the above logs? How long are the logs stored? Where are they stored?

- NGINXaaS logs are stored in customer’s storage. Customers can custom define the retention policy. Customers can configure the storage by following the steps outlined in the [NGINXaaS Logging]({{< ref "/nginxaas-azure/monitoring/enable-logging/">}}) documentation.

## Monitoring/Enable Monitoring

### Why do the metrics show more connections and requests than I was expecting?

- NGINX Agent periodically gathers connection and request statistics using an internal HTTP request. An Azure service health probe checks for status using a TCP connection for each listen port in the NGINX configuration, incrementing the connection count for each port. This contributes to minimal traffic and should not affect these metrics significantly.

### Why are some of my deployment’s metrics intermittently missing in Azure monitor?

- This may indicate that the deployment's underlying compute resources are being exhausted. Monitor the `system.cpu` metric to see the deployment's CPU utilization. If it's nearing 100%, consider increasing the deployment's NCU capacity. See the [Scaling Guidance]({{< ref "/nginxaas-azure/quickstart/scaling.md" >}}) documentation for more information.

## New Quickstart

### I am an NGINX Plus customer; how can I switch to NGINXaaS?

- In NGINX Plus, customers SSH into the NGINX Plus system, store their certificates in some kind of storage and configure the network and subnet to connect to NGINX Plus.

- For NGINXaaS, customers store their certificates in the Azure key vault and configure NGINXaaS in the same VNet or peer to the VNet in which NGINXaaS is deployed.

## Overview

### Is NGINXaaS active-active? What is the architecture of NGINXaaS?

- NGINXaaS is deployed as an active-active pattern for high availability. To learn more, see the [user guide]({{< ref "/nginxaas-azure/overview/overview.md#architecture" >}}).

### In which Azure regions is NGINXaaS currently supported?

- We are constantly adding support for new regions. You can find the updated list of supported regions in the [NGINXaaS documentation]({{< ref "/nginxaas-azure/overview/overview.md" >}}).

### My servers are located in different geographies, can NGINXaaS load balance for these upstream servers?

- Yes, NGINXaaS can load balance even if upstream servers are located in different geography as long as no networking limitations are mentioned in the [Known Issues]({{< ref "known-issues.md" >}}).

## Overview/Enable Logging

### Is request tracing supported in NGINXaaS?

- Yes, see the [Application Performance Management with NGINX Variables](https://www.nginx.com/blog/application-tracing-nginx-plus/) documentation to learn more about tracing.

## Overview/Feature Comparison

### Does NGINXaaS support layer 4 load balancing?

- Yes, NGINXaaS currently supports layer 4 TCP and HTTP layer 7 load balancing.


## Overview/Overview

### Does NGINXaaS support IP v6?

- No, NGINXaaS does not support IPv6 yet.

### What protocols do NGINXaaS support?

- At this time, we support the following protocols:

  - HTTPS
  - HTTP
  - HTTP/2
  - HTTP/3
  - TCP
  - QUIC
  - IMAP
  - POP3
  - SMTP

### Does NGINXaaS support multiple public IPs, a mix of public and private IPs?

- NGINXaaS supports one public or private IP per deployment. NGINXaaS doesn't support a mix of public and private IPs at this time.

### Can I change the IP address used for an NGINXaaS deployment to be public or private?

- You cannot change the IP address associated with an NGINXaaS deployment from public to private, or from private to public.

### How is my application safe at the time of disaster? Any method for disaster recovery?

- In any Azure region with more than one availability zone, NGINXaaS provides cross-zone replication for disaster recovery. See [Architecture]({{< ref "/nginxaas-azure/overview/overview.md#architecture" >}}) for more details.

### What are the supported networking services of NGINXaaS?

- NGINX currently supports VNet, and VPN gateway if they do not have limitations. Known limitations can be found in the [Known Issues]({{< ref "known-issues.md" >}}).

### What types of redirects does the NGINXaaS support?

- In addition to HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP, NGINXaaS provides the ability to create new rules for redirecting. See [How to Create NGINX Rewrite Rules | NGINX](https://www.nginx.com/blog/creating-nginx-rewrite-rules/) for more details.

### What content types does NGINXaaS support for the message body for upstream/NGINXaaS error status code responses?

- Customers can use any type of response message, including the following:

  - text/plain
  - text/css
  - text/html
  - application/javascript
  - application/json

## Quickstart/Scaling

### When should I scale my deployment?

- Consider requesting additional NCUs if the number of consumed NCUs is over 70% of the number of provisioned NCUs. Consider reducing the number of requested NCUs when the number of consumed NCUs is under 60% of the number of provisioned NCUs. For more information on observing the consumed and provisioned NCUs in your deployment, see the [Scaling documentation]({{< ref "/nginxaas-azure/quickstart/scaling.md#metrics" >}}).

### How does NGINXaaS react to a workload/traffic spike?

- You can monitor the NCUs consumed by looking at the metrics tab of NGINXaaS. To learn about the NCUs consumed, choose NGINXaaS statistics and select "NCU consumed." If the NCU consumed is close to the requested NCUs, we encourage you to scale your system and increase the NCU units. You can manually scale from your base NCUs (For example, 10) to up to 500 NCUs by selecting the NGINXaaS scaling tab.

- Currently, we support scaling in 10 NCU intervals (10, 20, 30, and so on).

- Alternatively, you can enable autoscaling, and NGINXaaS will automatically scale your deployment based on the consumption of NCUs.

- See the [Scaling Guidance]({{< ref "/nginxaas-azure/quickstart/scaling.md" >}}) documentation for more information.

### Does NGINXaaS support autoscaling?

- Yes; NGINXaaS supports autoscaling as well as manual scaling. Refer to the [Scaling Guidance]({{< ref "/nginxaas-azure/quickstart/scaling.md#autoscaling" >}}) for more information.

## Quickstart/Scaling/#Manual Scaling

### Does changing the capacity of NGINXaaS result in any downtime?

- No, there's no downtime while an NGINXaaS deployment changes capacity.

## Quickstart/Security Controls

### Are NSG (Network Security Group) supported on the NGINXaaS?

- Yes, an NSG is required in the subnet where NGINXaaS will be deployed to ensure that the deployment is secured and inbound connections are allowed to the ports the NGINX service listens to.

### Can I restrict access to NGINXaaS based on various criteria, such as IP addresses, domain names, and HTTP headers?

- Yes, you can restrict access to NGINXaaS by defining restriction rules at the Network Security Group level or using NGINX's access control list. To learn more, see the [NGINX module ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html) documentation.

## Quickstart/Security Controls/Securing Upstream Traffic

### Does NGINXaaS support end-to-end encryption from client to the upstream server?

- Yes, NGINXaaS supports end-to-end encryption from client to upstream server.

## Quickstart/Upgrade Channels

### Any downtime in the periodic updates?

- There's no downtime during updates to NGINXaaS.