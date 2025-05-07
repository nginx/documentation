---
title: Troubleshooting guide
weight: 1100
toc: true
url: /nginxaas/azure/troubleshooting-guide/
type:
- how-to
---

Many users encounter difficulties getting started with NGINXaaS for Azure, or have difficulty debugging performance or run-time problems. Here is some guidance about how to resolve common problems.

## Certificate health on Azure Key Vault ##

Certificates referenced from Azure Key Vault are a common source of confusion and errors. It is important to understand that certificates are integral to your deployment's health. Once you have added an Azure Key Vault certificate as a resource to your deployment, our service will always attempt to fetch that certificate when applying your NGINX configuration. It doesn't matter whether the certificate is referenced by the NGINX configuration or not: we will always try to fetch it as long as it is added to the deployment.

- Ensure that all certificate resources are needed by the deployment and that they are not about to expire.
- If a certificate on the deployment expires in your Azure Key Vault, we will not be able to fetch it and your deployment will enter a degraded state and may not be able to serve traffic.

It is easier to [renew a certificate](https://learn.microsoft.com/en-us/azure/key-vault/certificates/overview-renew-certificate?tabs=azure-portal) than it is to begin again with a brand new certificate which needs to be added to the NGINXaaS deployment. Our service always attempts to pull the latest version of your certificates, so automatically renewing certificates is a convenient way of avoiding problems with expiration.

## Azure Key Vault configuration ##

Many users struggle to get their first certificates added to the deployment. Please ensure the following:

- Check that you have a [managed identity](https://docs.nginx.com/nginxaas/azure/getting-started/managed-identity-portal/) added to your NGINXaaS deployment.
- Ensure that the managed identity has the correct role assignments to your Azure Key Vault.

Our service uses the managed identity delegated to the deployment when fetching your certificates from your Azure Key Vault, so it is important that the managed identity has the role assignments that it needs over the key vault.

If you wish to reference certificates in a **private Azure Key Vault**, you will need to configure a [Network Security Perimeter](https://docs.nginx.com/nginxaas/azure/quickstart/security-controls/certificates/#configure-network-security-perimeter-nsp) so that our service  has the necessary permissions to fetch the certificates.

## Connectivity problems ##

When performing an end-to-end test on your NGINXaaS deployment, if you are unable to access one of the locations defined in your NGINX configuration, it may appear that traffic is not flowing through the system properly.

In this situation:

- Check that your deployment's **Network Security Group settings** are not causing inbound traffic on certain ports to be blocked.

Please see the [Azure Network Security Group documentation](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) for guidance.

## Upstream connectivity ##

Another reason why traffic may not flow through the system as expected is that the upstreams referenced in your NGINX configuration are either not accessible to our service or are not in a healthy state.

Check that the upstream is accessible to our service.

1. Create an Azure Virtual Machine within the same subnet as your deployment.
1. SSH into the VM and then `ping` or `curl` the upstream.
1. You should be successful. If not, this indicates that the upstream is not accessible to our service.

If there are other problems routing traffic to your upstreams, check the logs of your upstream servers to gain further insights into the problem.

## Upstream health ##

Once your upstream servers are accessible to our service, NGINX gives you various tools to [manage the health of your upstreams](https://www.f5.com/company/blog/nginx/active-or-passive-health-checks-which-is-right-for-you).

- We recommend that users enable both passive and active health checks on their deployments.
- Active health checks proactively monitor the responsiveness of your upstreams and allows your NGINXaaS deployment to stop routing traffic to unhealthy backend servers.

See [this document](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/) for steps to configure active and passive health checks through your NGINX configuration.

## Monitoring your deployment ##

NGINXaaS gives users two main tools to monitor the performance of their deployments.

1. Enable NGINX logs

   NGINX access logs give you information about the requests received by your NGINXaaS deployment, and the error logs tell you about errors encountered by NGINX when handling incoming requests. This information is extremely important when debugging problems with your NGINX configuration. Many problems that arise when handling traffic can be fixed by modifying your NGINX configuration.
   See the [NGINXaaS logging documentation](https://docs.nginx.com/nginxaas/azure/monitoring/enable-logging/) for more information about how to enable and configure NGINX logs.
2. Enable monitoring

   The metrics published by NGINXaaS to Azure Monitor offer a powerful tool for evaluating system performance. [Our metrics catalog](https://docs.nginx.com/nginxaas/azure/monitoring/metrics-catalog/) provides a description of each metric. Taken together, these metrics provide insights into every aspect of your deployment’s performance. If you add the `memory_zone` directive to your upstreams in your NGINX configuration, we will be able to provide metrics on upstream health.
   See the [NGINXaaS monitoring documentation](https://docs.nginx.com/nginxaas/azure/monitoring/enable-monitoring/) for more information about how to enable and configure monitoring.

## System load ##

The `nginxaas.capacity.percentage` metric indicates how much capacity your deployment is consuming (expressed as a percentage of the total). We recommend [configuring an alert](https://docs.nginx.com/nginxaas/azure/monitoring/configure-alerts/) on this metric, so that if it exceeds a certain threshold, you get notified to manually scale out your deployment to meet the demand. If you have [autoscaling](https://docs.nginx.com/nginxaas/azure/quickstart/scaling/#autoscaling) enabled, our service will scale your deployment automatically.

## Performance tuning ##

There are a variety of ways to boost the performance of your NGINXaaS deployment. [This blog post](https://www.f5.com/company/blog/nginx/10-tips-for-10x-application-performance) offers a roundup of the top ten tips to get the most out of NGINX.

[Enabling http keepalives](https://www.f5.com/company/blog/nginx/http-keepalives-and-web-performance) is a tip that deserves added emphasis. Keepalive settings allow for efficient reuse of connections between client and server and can significantly increase the speed of your system.
