---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  configure an API Gateway.
nd-docs: DOCS-921
title: Set Up an API Gateway Environment
toc: true
weight: 100
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

In API Connectivity Manager, an API Gateway is a proxy cluster that contains one or more NGINX data plane instances.
These clusters are managed under **Infrastructure Workspaces** and are part of **Environments**.

### Before You Begin

Before proceeding with this guide, you should familiarize yourself with the [API Overview]({{< ref "/nms/acm/about/api-overview" >}}) and the [Get Started]({{< ref "/nms/acm/getting-started/overview" >}}) section of this series.

## Add an Infrastructure Workspace

First, you'll need to create an Infrastructure Workspace.
This is a logical grouping that allows for separation between business units or teams.


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/infrastructure/workspaces`|

{{</bootstrap-table>}}


```json
{
    "name": "{{infraWorkspaceName}}",
    "metadata": {
        "description": "App Development Workspace"
    },
    "contactDetails": {
        "adminEmail": "I.M.Devs@example.com",
        "adminName": "I.M. Devs",
        "adminPhone": "555 321 1234"
    }
}
```

## Add an Environment

Next, add an Environment.

Environments contain **API Gateways** and **Develper Portals**.
Use the appropriate example below to deploy an API Gateway with either HTTP, HTTP2, or HTTPS.

### HTTP

> {{< icon "lightbulb" >}} Use this example to get up and running quickly in a demo environment.


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/infrastructure/workspaces/{{infraWorkspaceName}}/environments`|

{{</bootstrap-table>}}


```json
{
    "name": "{{environmentName}}",
    "functions": [
        "API-GATEWAY"
    ],
    "proxies": [
        {
            "proxyClusterName": "{{instanceGroupName}}",
            "hostnames": [
                "{{environmentHostname}}"
            ],
            "runtime": "GATEWAY-PROXY"
        }
    ]
}
```

### HTTPS

To deploy a cluster that uses HTTPS for secure inbound communication, you'll add the **TLS Inbound** policy.
Because this is done at the Infrastructure level, this is considered a "Global Policy".

> {{< icon "lightbulb" >}} You need to provide a valid TLS server certificate and key in this API call.

{{<comment>}}
Need to add requirements for sending this info? Base64 encoding required?
{{</comment>}}


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/infrastructure/workspaces/{{infraWorkspaceName}}/environments`|

{{</bootstrap-table>}}


```json
{
    "name": "{{environmentName}}",
    "proxies": [
        {
            "proxyClusterName": "{{instanceGroupName}}",
            "hostnames": [
                "{{environmentHostname}}"
            ],
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

### HTTP2

To deploy a cluster that uses HTTP2 for secure inbound communication, you'll add the **TLS Inbound** policy.
Because this is done at the Infrastructure level, this is considered a "Global Policy".

> {{< icon "lightbulb" >}} You need to provide a valid TLS server certificate and key in this API call.


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| POST| `/infrastructure/workspaces/{{infraWorkspaceName}}/environments`|

{{</bootstrap-table>}}


```json
{
   "name": "{{environmentname}}",
   "proxies": [
      {
         "proxyClusterName": "{{instanceGroupName}}",
         "listeners": [
            {
               "transportProtocol": "HTTP2",
               "port": 443,
               "tlsEnabled": true
            }
         ],
         "hostnames": [
            "{{environmentHostname}}"
         ],
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

## Onboard F5 NGINX Plus Instances into the Cluster

Take the steps in this section to install the NGINX Agent on the data plane instances to onboard them into the proxy cluster that you created in the [previous step](#add-an-environment).

To do so, you need to interact directly with the NGINX Plus data plane hosts.

- SSH access to the hosts and `sudo` permissions are required.
- You can add up to three NGINX Plus data plane instances to the cluster.

### Install NGINX Agent on the Data Plane Hosts {#onboard-nginx-plus}

1. Use SSH to connect and log in to each of the NGINX Plus data plane hosts that you want to add to the API Gateway cluster.
1. Run the onboarding command as root using cURL to download, install, configure, and start the NGINX Agent package.

   - Replace `{{nms-fqdn}}` in the example command with the FQDN or IP address of your API Connectivity Manager management plane host.
   - Make sure `-g {{clusterName}}` uses the name of your API Gateway cluster.

   ```bash
   curl --insecure https://{{nms-fqdn}}/install/nginx-agent > install.sh && \
   sudo sh install.sh -g {{clusterName}} && sudo systemctl start nginx-agent
   ```

### Verify the Settings

Try sending traffic to the hostname you configured for the API Gateway. Send a PUT request to the endpoint shown below to update the Environment.

1. Send a GET request to the endpoint shown below to verify that the instances were added to the Clusters.


{{<bootstrap-table "table">}}

| Method      | Endpoint |
|-------------|----------|
| PUT | `/infrastructure/workspaces/{{infraWorkspaceName}}/environments/{{environmentName}}`|
| GET | `/infrastructure/workspaces/{{infraWorkspaceName}}/environments/{{environmentName}}?includes=instances&includes=status`|

{{</bootstrap-table>}}
