---
title: Connectivity test tool
weight: 200
toc: true
url: /nginxaas/azure/get-help/connectivity
type:
- how-to
---

Use the connectivity test tool to determine whether a specific IP address is accessible from your deployment's dataplane. The connectivity test tool accepts an IP address and a port number. It uses [`netcat`](https://nc110.sourceforge.io/) to open a TCP connection with the given address, without sending any data to the address. The tool returns `netcat`'s output to the user. This is useful for debugging connectivity issues and determining if a problem is in NGINX configuration or Azure network configuration.

To use the tool:

- Retrieve your [data plane API endpoint]({{< ref "/nginxaas-azure/loadbalancer-kubernetes.md#nginxaas-data-plane-api-endpoint" >}}).

- Create an [API key]({{< ref "/nginxaas-azure/loadbalancer-kubernetes.md#create-an-nginxaas-data-plane-api-key" >}}) if you do not already have one.

- Append the `/connectivity` suffix to your deployment's data plane API endpoint, e.g. https://my-deployment.my-region.nginxaas.net/connectivity. Use a browser to navigate to this URL.

- The browser will prompt you for a username and password. The username is optional. Please enter your API key in the password field.

- You will then be able to use the connectivity tool through the browser.

{{< call-out "note" >}}
The connectivity test tool will not accept loopback or multicast IP addresses.
{{< /call-out >}}
