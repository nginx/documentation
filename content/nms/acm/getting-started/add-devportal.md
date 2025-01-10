---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to configure
  a Developer Portal.
docs: DOCS-922
tags:
- docs
title: Set Up a Developer Portal Environment
toc: true
weight: 200
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

In API Connectivity Manager, a Developer Portal (or, "Dev Portal") is a cluster of F5 NGINX Plus data plane instances.
These clusters are managed under **Infrastructure Workspaces** and are part of **Environments**.

### Before You Begin

You should complete the following Quick Start Guide(s) before proceeding with the steps in this guide:

- [Configure an API Gateway]({{< relref "add-api-gateway" >}})

## Add a Developer Portal

Complete the steps in this guide to add a Developer Portal to the Environment you created in the [previous guide]({{< relref "add-api-gateway" >}}).

When a Developer Portal environment is created, the API Connectivity Manager configures
a virtual server through which the developer portal service and API Connectivity Manager communicate. By default, the hostname for this server is the
hostname that you provided for the Developer Portal cluster, prefixed with `acm.`. For example: `acm.dev-portal.io`. This virtual server listens on port 81.

You will need to update your DNS resolver settings to ensure this hostname is resolvable.
The hostname and port for this server can be updated by selecting the **Edit Portal <-> API Connectivity Manager Connectivity** from the **Actions** menu for your desired developer portal.

{{<important>}}

- Be sure to provide the IP address or FQDN of the host where you installed the Dev Portal packages as the `{{portalClusterHostname}}`.
- The Dev Portal must run on a dedicated host with the [`njs`](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) module installed.
{{</important>}}

Use the appropriate example below to deploy an HTTP or HTTPS Developer Portal.

### HTTP

> {{< fa "lightbulb" >}} Use this example to get up and running quickly in a demo environment.


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/infrastructure/workspaces/{{infraWorkspaceName}}/environments`|

{{</bootstrap-table>}}


```json
{
    "name": "{{environmentName}}",
    "functions": [
        "DEVPORTAL"
    ],
    "proxies": [
        {
            "proxyClusterName": "{{portalInstanceGroupName}}",
            "hostnames": [
                "{{portalClusterHostname}}"
            ],
            "runtime": "PORTAL-PROXY"
        }
    ]
}
```

### HTTPS

To deploy a cluster that uses HTTPS for secure inbound communication, you'll add the **TLS Inbound** policy.
Because this is done at the Infrastructure level, this is considered a "Global Policy".

> {{< fa "lightbulb" >}} You need to provide your TLS server certificate and key as base64-encoded strings in this API call.


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/infrastructure/workspaces/{{infraWorkspaceName}}/environments`|

{{</bootstrap-table>}}


```json
{
    "name": "{{environmentName}}",
    "functions": [
        "DEVPORTAL"
    ],
    "proxies": [
        {
            "proxyClusterName": "{{portalInstanceGroupName}}",
            "hostnames": [
                "{{portalClusterHostname}}"
            ],
            "runtime": "PORTAL-PROXY",
            "policies": {
                "tls-inbound": [
                    {
                        "data": {
                            "serverCerts": [
                                {
                                    "key": "{{tls key}}",
                                    "cert": "{{tls cert}}"
                                }
                            ]
                        }
                    }
                ]
            }
        }
    ]
}
```

## Onboard an NGINX Plus Instance into the Cluster

Take the steps in this section to install the NGINX Agent on the data plane instance where you installed the Developer Portal packages.
This onboards the host into the proxy cluster that you created in the [previous step](#add-an-environment).

To do so, you'll need to interact directly with the host.
SSH access to the host and `sudo` permissions are required.

### Install NGINX Agent on the Data Plane Host

1. Use SSH to connect and log in to the Dev Portal host.
1. Run the onboarding command as root to download, install, configure, and start the NGINX Agent package.

   - Replace `{{nms-fqdn}}` in the example command with the FQDN or IP address of your Dev Portal host.
   - Replace `{{clusterName}}` in the example command with the name of your Developer Portal cluster.

   ```bash
   curl --insecure https://{{nms-fqdn}}/install/nginx-agent > install.sh && \
   sudo sh install.sh -g {{clusterName}} && sudo systemctl start nginx-agent
   ```

### Update the DNS Record

The NGINX Management Suite management plane host uses the Developer Portal's hostname to communicate with the Dev Portal.
You’ll need to update your DNS resolver settings with the Developer Portal's internal hostname.

> {{< fa "lightbulb" >}} The internal hostname is the hostname that you provided for the Developer Portal, prefixed with `acm.`.
> For example: `acm.dev-portal.io`

Next, open the Developer Portal in a browser window and make sure the portal loads.

## Customize the Developer Portal

In this step, you'll apply a set of customizations to the Developer Portal.
Because these settings are applied at the Infrastructure level, they are considered "global", meaning they apply to each Dev Portal Proxy that you associate with the cluster.

{{<see-also>}}Refer to [Customize the Developer Portal]({{< relref "/nms/acm/how-to/infrastructure/customize-devportal.md" >}}) to learn more about the available customization options and how to customize a Dev Portal via the API Connectivity Manager user interface.{{</see-also>}}


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| PUT | `/infrastructure/workspaces/{{infraWorkspaceName}}/devportals/{{devPortalName}}`|

{{</bootstrap-table>}}


Note that many fields in the example JSON payload -- including the logo image and Markdown documents -- are base64-encoded.

**Example JSON payload**: {{< fa "download" >}} {{< link "/acm/customize-devportal.json" "customize-devportal.json" >}}

Before you move on to the next guide, open the Dev Portal in your browser to view the changes.
You should see the default Dev Portal replaced by the custom settings.
