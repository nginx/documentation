---
title: "Learn more about related topics"
weight: 900
toc: false
nd-content-type: how-to
nd-product: Solutions
---

When you set up [NGINX Plus subscription licensing]({{< ref "/solutions/about-subscription-licenses/getting-started.md" >}}), you may also need details from other products. This page links to installation guides, module references, and reporting instructions that support licensing and related features.

## NGINX Plus

- [NGINX Plus installation guide]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) – Instructions for installing or upgrading NGINX Plus.  
- [Module ngx_mgmt_module reference](https://nginx.org/en/docs/ngx_mgmt_module.html) – Details about the `mgmt` module and its directives, including license and reporting configuration.  

## NGINX Instance Manager

NGINX Instance Manager is required for usage reporting in network-restricted environments.  
In this setup, NGINX Plus instances send usage data to Instance Manager, which then forwards the reports to F5.  

- **Internet-connected environments**  
  - [Add a license]({{< ref "nim/admin-guide/add-license.md" >}})  
  - [Report usage to F5]({{< ref "nim/admin-guide/report-usage-connected-deployment.md" >}})  

- **Network-restricted environments**  
  - [Add a license in a disconnected environment]({{< ref "nim/disconnected/add-license-disconnected-deployment.md" >}})  
  - [Report usage to F5 in a disconnected environment]({{< ref "nim/disconnected/report-usage-disconnected-deployment.md" >}})  

## NGINX App Protect WAF

- [NGINX App Protect WAF v4 installation guide]({{< ref "/nap-waf/v4/admin-guide/install.md" >}})  
- [NGINX App Protect WAF v5 installation guide]({{< ref "/nap-waf/v5/admin-guide/install.md" >}})  

## NGINX App Protect DoS

- [NGINX App Protect DoS installation guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}})  