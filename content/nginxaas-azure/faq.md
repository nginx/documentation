---
title: Frequently Asked Questions
weight: 800
toc: true
docs: DOCS-881
url: /nginxaas/azure/faq/
type:
- concept
---

Common questions about F5 NGINX as a Service for Azure (NGINXaaS).

### Is NGINXaaS available in my subscription or in F5 subscription?
- Your NGINXaaS deployment resource is visible to you under your subscription. The underlying compute resources of your deployment, which are managed by NGINX on your behalf, are not visible in your subscription.

### Is NGINXaaS active-active? What is the architecture of NGINXaaS?
- NGINXaaS is deployed as an active-active pattern for high availability. To learn more, see the [user guide]({{< relref "/nginxaas-azure/overview/overview.md#architecture" >}}).

### In which Azure regions is NGINXaaS currently supported?
- We are constantly adding support for new regions. You can find the updated list of supported regions in the [NGINXaaS documentation]({{< relref "/nginxaas-azure/overview/overview.md" >}}).

### My servers are located in different geographies, can NGINXaaS load balance for these upstream servers?
- Yes, NGINXaaS can load balance even if upstream servers are located in different geography as long as no networking limitations are mentioned in the [Known Issues]({{< relref "known-issues.md" >}}).

### How do I analyze traffic statistics for NGINXaaS?
- NGINXaaS is integrated with [Azure monitoring](https://learn.microsoft.com/en-us/azure/azure-monitor/overview). NGINXaaS publishes [traffic statistics]({{< relref "/nginxaas-azure/monitoring/metrics-catalog.md" >}}) in Azure monitoring. Customers can analyze the traffic statistics by following the steps mentioned in the [NGINXaaS Monitoring]({{< relref "/nginxaas-azure/monitoring/enable-monitoring.md" >}}) documentation.

### When should I scale my deployment?
- Consider requesting additional NCUs if the number of consumed NCUs is over 70% of the number of provisioned NCUs. Consider reducing the number of requested NCUs when the number of consumed NCUs is under 60% of the number of provisioned NCUs. For more information on observing the consumed and provisioned NCUs in your deployment, see the [Scaling documentation]({{< relref "/nginxaas-azure/quickstart/scaling.md#metrics" >}}).

- Alternatively, [enable autoscaling]({{< relref "/nginxaas-azure/quickstart/scaling.md#autoscaling" >}}) to let the system automatically scale your deployment for you.

### I am an NGINX Plus customer; how can I switch to NGINXaaS?
- In NGINX Plus, customers SSH into the NGINX Plus system, store their certificates in some kind of storage and configure the network and subnet to connect to NGINX Plus.

- For NGINXaaS, customers store their certificates in the Azure key vault and configure NGINXaaS in the same VNet or peer to the VNet in which NGINXaaS is deployed.

### How does NGINXaaS react to a workload/traffic spike?
- You can monitor the NCUs consumed by looking at the metrics tab of NGINXaaS. To learn about the NCUs consumed, choose NGINXaaS statistics and select "NCU consumed." If the NCU consumed is close to the requested NCUs, we encourage you to scale your system and increase the NCU units. You can manually scale from your base NCUs (For example, 10) to up to 500 NCUs by selecting the NGINXaaS scaling tab.

- Currently, we support scaling in 10 NCU intervals (10, 20, 30, and so on).

- Alternatively, you can enable autoscaling, and NGINXaaS will automatically scale your deployment based on the consumption of NCUs.

- See the [Scaling Guidance]({{< relref "/nginxaas-azure/quickstart/scaling.md" >}}) documentation for more information.

### What types and formats of certificates are supported in NGINXaaS?
- NGINXaaS supports self-signed certificates, Domain Validated (DV) certificates, Organization Validated (OV) certificates, and Extended Validation (EV) certificates.

- Currently, NGINXaaS supports PEM and PKCS12 format certificates.

- See the [SSL/TLS Certificates documentation]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}}) to learn how to change certificates.

### Does NGINXaaS support layer 4 load balancing?
- Yes, NGINXaaS currently supports layer 4 TCP and HTTP layer 7 load balancing.

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

### How large should I make the subnet for NGINXaaS?

- The minimum subnet size is `/27` and is sufficient for a single NGINXaaS deployment even at large scales. Multiple NGINXaaS deployments can be placed in a single delegated subnet, along with other resources. When doing so, a larger subnet, e.g. a `/24`, is recommended.

### Can I deploy more than one NGINXaaS to a single subnet?
- Yes, however, every deployment in the subnet will share the address space (range of IP addresses that resources can use within the VNet), so ensure the subnet is adequately sized to scale the deployments.

### How long does it take to deploy NGINXaaS?
- Typically you can deploy NGINXaaS in under 5 minutes.

### Any downtime in the periodic updates?
- There's no downtime during updates to NGINXaaS.

### Does changing the capacity of NGINXaaS result in any downtime?
- No, there's no downtime while an NGINXaaS deployment changes capacity.

### How is my application safe at the time of disaster? Any method for disaster recovery?
- In any Azure region with more than one availability zone, NGINXaaS provides cross-zone replication for disaster recovery. See [Architecture]({{< relref "/nginxaas-azure/overview/overview.md#architecture" >}}) for more details.

### Can I configure the TLS policy to control TLS protocol versions?
- Yes. You can overwrite the NGINX default protocol to configure the desired TLS/SSL policy. Read more about the procedure in the [Module ngx_http_ssl_module](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) documentation.

### How many TLS/SSL certificates does NGINXaaS support?
- NGINXaaS supports up to 100 TLS/SSL certificates.

### Does NGINXaaS natively integrate with Azure Key Vault?
- Yes, NGINXaaS natively integrates with Azure Key Vault, so you can bring your own certificates and manage them in a centralized location. You can learn more about adding certificates in Azure Key Vault in the [SSL/TLS Certificates documentation]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}}).

### Can I deploy any other resources in the NGINXaaS subnet?
- Yes, the subnet can contain other resources and is not dedicated to the NGINXaaS for Azure resources; ensure the subnet size is adequate to scale the NGINXaaS deployment.

### Are NSG (Network Security Group) supported on the NGINXaaS?
- Yes, an NSG is required in the subnet where NGINXaaS will be deployed to ensure that the deployment is secured and inbound connections are allowed to the ports the NGINX service listens to.

### Can I restrict access to NGINXaaS based on various criteria, such as IP addresses, domain names, and HTTP headers?
- Yes, you can restrict access to NGINXaaS by defining restriction rules at the Network Security Group level or using NGINX's access control list. To learn more, see the [NGINX module ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html) documentation.

### What are the supported networking services of NGINXaaS?
- NGINX currently supports VNet, and VPN gateway if they do not have limitations. Known limitations can be found in the [Known Issues]({{< relref "known-issues.md" >}}).

### Does NGINXaaS support end-to-end encryption from client to the upstream server?
- Yes, NGINXaaS supports end-to-end encryption from client to upstream server.

### What types of logs does NGINXaaS provide?
- NGINXaaS supports the following [two types of logs]({{< relref "/nginxaas-azure/monitoring/enable-logging/">}}).

- Access Log: To troubleshoot server issues, analyze web traffic patterns and monitor server performance. For more details, please see the [Module ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html?&_ga=2.80762515.545098740.1677716889-256521444.1670450998#access_log) documentation.

- Error Log: To capture, troubleshoot and identify issues that may occur during the server's operations, such as 400 bad requests, 401 unauthorized, 500 internal server errors, etc. For more details, please see the [Core functionality](https://nginx.org/en/docs/ngx_core_module.html?&_ga=2.8347062.545098740.1677716889-256521444.1670450998#error_log) documentation.

### What is the retention policy for the above logs? How long are the logs stored? Where are they stored?
- NGINXaaS logs are stored in customer’s storage. Customers can custom define the retention policy. Customers can configure the storage by following the steps outlined in the [NGINXaaS Logging]({{< relref "/nginxaas-azure/monitoring/enable-logging/">}}) documentation.

### Can I set up an alert with NGINXaaS?
- You can set up an alert with NGINXaaS by following the steps outlined in the [Configure Alerts]({{< relref "/nginxaas-azure/monitoring/configure-alerts.md">}}) documentation.

### Is request tracing supported in NGINXaaS?
- Yes, see the [Application Performance Management with NGINX Variables](https://www.nginx.com/blog/application-tracing-nginx-plus/) documentation to learn more about tracing.

### Can I select my desired instance type for NGINXaaS deployment?
- No; NGINXaaS will deploy the right resources to ensure you get the right price-to-performance ratio.

### Can I migrate from on-prem NGINX+ to NGINXaaS on Azure?
- Yes, you can bring your own configurations or create a new configuration in the cloud. See the [NGINXaaS Deployment]({{< relref "/nginxaas-azure/getting-started/create-deployment/">}}) documentation for more details.

### Can I associate multiple certificates for the same domain?
- Yes, the "ssl_certificate" directive can be specified multiple times to load certificates of different types. To learn more, see the [Module ngx_http_ssl_module](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) documentation.

### What types of redirects does the NGINXaaS support?
- In addition to HTTP to HTTPS, HTTPS to HTTP, and HTTP to HTTP, NGINXaaS provides the ability to create new rules for redirecting. See [How to Create NGINX Rewrite Rules | NGINX](https://www.nginx.com/blog/creating-nginx-rewrite-rules/) for more details.

### What content types does NGINXaaS support for the message body for upstream/NGINXaaS error status code responses?
- Customers can use any type of response message, including the following:

  - text/plain
  - text/css
  - text/html
  - application/javascript
  - application/json

### Where do I find the NGINXaaS IP (Internet Protocol) address?
- Once you successfully deploy NGINXaaS, you can double-click on NGINXaaS in the Azure portal; you can see both public and private IP addresses, as shown in the following screenshot:

{{< img src="nginxaas-azure/faq-ip-location-one.png" alt="IP location one" >}}

{{< img src="nginxaas-azure/faq-ip-location-two.png" alt="IP location two" >}}

### Does my deployment IP change over time?
- The NGINXaaS deployment IP doesn't change over time.

### Does NGINXaaS support autoscaling?
- Yes; NGINXaaS supports autoscaling as well as manual scaling. Refer to the [Scaling Guidance]({{< relref "/nginxaas-azure/quickstart/scaling.md#autoscaling" >}}) for more information.

### How can I manually start/stop NGINXaaS?
- Currently, we can't manually start/stop NGINXaaS. You have the option to delete the deployment and re-deploy at a future date.

### Can I change the virtual network or subnet for an existing NGINXaaS?
- If the existing NGINXaaS deployment is using a public IP address, you can change the backend virtual network or subnet. Please make sure that the subnet is delegated to `NGINX.NGINXPLUS/nginxDeployments` before creating a deployment in it. To delegate a subnet to an Azure service, see [Delegate a subnet to an Azure service](https://learn.microsoft.com/en-us/azure/virtual-network/manage-subnet-delegation?source=recommendations#delegate-a-subnet-to-an-azure-service).

- If the existing NGINXaaS deployment is using a private IP address, you can only change the backend subnet. You cannot change the backend virtual network because the frontend and backend subnets must be in the same virtual network.

### How do I configure HTTPS listeners for .com and .net sites?
- NGINXaaS is a Layer 7 HTTP protocol. To configure .com and .net servers, refer to the server name in the server block within the HTTP context. To learn more, and see examples, follow the instructions in the [NGINX Configuration]({{< relref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#nginx-configuration-validation" >}}) documentation.

### If I remove/delete an NGINXaaS deployment, what will happen to the eNICs that were associated with it?
- When you remove or delete an NGINXaaS deployment, the associated eNICs will automatically be deleted.

### What are the specific permissions that NGINXaaS for Azure needs?

- The specific permissions required to deploy NGINXaaS are:

  - microsoft.network/publicIPAddresses/join/action

  - nginx.nginxplus/nginxDeployments/Write

  - microsoft.network/virtualNetworks/subnets/join/action

  - nginx.nginxplus/nginxDeployments/configurations/Write

  - nginx.nginxplus/nginxDeployments/certificates/Write

- Additionally, if you are creating the Virtual Network or IP address resources that NGINXaaS for Azure will be using, then you probably also want those permissions as well.

- Note that assigning the managed identity permissions normally requires an “Owner” role.

### Can I reference my upstream servers by internal DNS hostname?

- Yes. If your DNS nameservers are configured in the same VNet as your deployment, then you can use those DNS nameservers to resolve the hostname of the upstream servers referenced in your NGINX configuration.

### Will updates to my virtual network's DNS settings automatically apply to my NGINXaaS deployment?

No, changes to a virtual network's DNS settings will not be applied automatically to your NGINXaaS deployment. To ensure DNS settings are applied, you must add any custom DNS servers to the VNET's DNS settings before creating an NGINXaaS deployment. As a workaround for existing deployments, we recommend using the [`resolver` directive](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) to explicitly specify your name server(s) and the [`resolve` parameter](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#resolve) to automatically re-resolve the domain name of the server without restarting NGINX.

For example,

```nginx
resolver 10.0.0.2 valid=10s;
upstream backends {
    zone backends 64k;
    server backends.example.com:8080 resolve;
}

server {
    location / {
        proxy_pass http://backends;
    }
}
```

### Does changing the `worker_connections` in the NGINX config have any effect?
- No. While changing the value of the directive in the config is allowed, the change is not applied to the underlying NGINX resource of your deployment.

### What ports can my deployment listen on?

- Due to port restrictions on Azure Load Balancer health probes, ports `19`, `21`, `70`, and `119` are not allowed. The NGINXaaS deployment can listen on all other ports. We limit the maximum listen ports in the NGINX configuration to 5 on the Basic and current Standard (v1) plan. Configurations that specify over 5 unique ports are rejected. With the Standard V2 plan, we allow users to listen on more than 5 ports. The first five ports under this plan come at no extra cost and there are charges for each additional port utilized.

### How often does my deployment get billed?

- NGINXaaS is [billed monthly]({{< relref "/nginxaas-azure/billing/overview.md" >}}) based on hourly consumption.

### Why do the metrics show more connections and requests than I was expecting?

- The NGINX agent periodically gathers connection and request statistics using an internal HTTP request. An Azure service health probe checks for status using a TCP connection for each listen port in the NGINX configuration, incrementing the connection count for each port. This contributes to minimal traffic and should not affect these metrics significantly.

### Can I use an existing subnet to create my deployment?

- You can use an existing subnet to create a deployment. Please make sure that the subnet is delegated to `NGINX.NGINXPLUS/nginxDeployments` before creating a deployment in it. To delegate a subnet to an Azure service, see [Delegate a subnet to an Azure service](https://learn.microsoft.com/en-us/azure/virtual-network/manage-subnet-delegation?source=recommendations#delegate-a-subnet-to-an-azure-service).

### Will my deployment detect a new version of my certificate and apply it?

- NGINXaaS supports certificate rotation. See the [Certificate Rotation documentation]({{< relref "/nginxaas-azure/getting-started/ssl-tls-certificates/overview.md#certificate-rotation" >}}) to learn more.

### Why are some of my deployment's metrics intermittently missing in Azure monitor?

- This may indicate that the deployment's underlying compute resources are being exhausted. Monitor the `system.cpu` metric to see the deployment's CPU utilization. If it's nearing 100%, consider increasing the deployment's NCU capacity. See the [Scaling Guidance]({{< relref "/nginxaas-azure/quickstart/scaling.md" >}}) documentation for more information.
