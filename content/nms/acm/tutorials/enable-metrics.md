---
description: Learn how to enable and use metrics for F5 NGINX Management Suite API
  Connectivity Manager.
docs: DOCS-1055
title: Enable Metrics
toc: true
weight: 100
---

{{< shortversions "1.3.0" "latest" "acmvers" >}}

## Overview

This guide walks through setting up and using metrics in API Connectivity Manager.

{{<important>}}The configuration presented in this guide is for demonstration purposes only. Securely configuring environments and proxies in API Connectivity Manager is not in scope for this tutorial but should be given full attention when planning for production use.{{</important>}}

Currently, only the following metric is available:

- [Count of proxies in an environment](#count-proxies-in-env)

As we add new metrics, we'll let you know in the [API Connectivity Manager release notes]({{< relref "/nms/acm/releases/release-notes.md" >}}) and update this topic accordingly.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- Access to a virtual environment
- Four virtual hosts with Linux installed — this guide uses [Ubuntu 20.04 LTS](https://releases.ubuntu.com/focal/).

   <details close>
   <summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

   {{< include "nim/tech-specs/supported-distros.md" >}}

   </details>

 {{<comment>}}It looks like you have to install both Go and Echo Server. Are there minimum requirements for these? Do we need to explain why these extra apps are needed? Customers installing in Prod might wonder, and they might even need to get approval to install them.{{</comment>}}

---

## Host Setup

This section configures the hosts used in this tutorial. In the following table, you'll find the details of the test environment used in this tutorial's examples. The options presented are the minimum host requirements for running a fully functional test environment. Remember that production environments may need more resources and incur greater costs.

{{<bootstrap-table "table table-striped table-bordered">}}

| Hosts                       | Virtual Cores | Memory | Storage | IP Address  | Hostname    |
|-----------------------------|---------------|--------|---------|-------------|-------------|
| F5 NGINX Management Suite Host | 2 vCPUs       | 4GB    | 100GB   | `192.0.2.2` | `acm-ctrl`  |
| Data Plane Host             | 1 vCPU        | 1GB    | 10GB    | `192.0.2.3` | `data-host` |
| Echo Server                 | 1 vCPU        | 1GB    | 10GB    | `192.0.2.4` | `echo-host` |

{{</bootstrap-table>}}

<br>

### Install NGINX Management Suite & API Connectivity Manager {#install-nsm-acm}

Follow the steps in the [Installation Guide]({{< relref "/nim/deploy/_index.md" >}}) to set up NGINX Management Suite and API Connectivity Manager. You do not need to configure a Developer Portal for this tutorial.

### Enable Metrics for API Connectivity Manager

In `/etc/nms/acm.conf`, uncomment and set the `enable_metrics` property to `true`.

``` bash
# set to true to enable metrics markers from the acm code
enable_metrics = true
```

Run the following command to restart the API Connectivity Manager service:

```bash
sudo systemctl restart nms-acm
```

### Install NGINX Agent on Data Plane Host {#install-agent}

Run the following commands to install the NGINX Agent on the data plane host, create a new Instance Group called `test-ig`, and add the host to it:

``` shell
curl --insecure https://192.0.2.2/install/nginx-agent > install.sh \
&& sudo sh install.sh -g test-ig \
&& sudo systemctl start nginx-agent
```

To ensure that the advanced metrics modules are installed across all data plane hosts, please follow the steps in the [Install NGINX Plus Metrics Module]({{< relref "/nms/nginx-agent/install-nginx-plus-advanced-metrics.md" >}}) guide.

---

### Install Echo Server {#install-echo-server}

{{< note >}} The server is designed for testing HTTP proxies and clients. It echoes information about HTTP request headers and bodies back to the client. {{</ note >}}

1. [Download and install the latest version of Go](https://go.dev/doc/install) by following the instructions on the official Go website.
2. Run the following commands to install and start [Echo Server](https://github.com/jmalloc/echo-server):

   ```shell
   go env -w GO111MODULE=off
   go get -u github.com/jmalloc/echo-server/...
   PORT=10000 LOG_HTTP_BODY=true LOG_HTTP_HEADERS=true echo-server
   ```

---

## Configure API Connectivity Manager {#amc-config}

In this section, we use the API Connectivity Manager REST API to set up a proxy in API Connectivity Manager. You need to pass the NGINX Management Suite user credentials in the Basic Authentication header for each REST request.

### Create Workspaces & Environment {#create-workspace-environment}

1. To create an Infrastructure Workspace with a minimum configuration, send the following JSON request to the `/infrastructure/workspaces` endpoint:

   ```bash
   POST https://192.0.2.2/api/acm/v1/infrastructure/workspaces
   ```

   <br>

   **JSON Request**

   ```json
   {
      "name": "infra-ws"
   }
   ```

1. To create an environment with a minimum configuration, send the following JSON request to the `/infrastructure/workspaces/infra-ws/environments` endpoint. The `proxyClusterName`: `test-ig` is the name of the Instance Group that the data plane host was added to when you [installed the NGINX Agent](#install-agent) above. The `hostnames` array should contain the hostname of the data plane host.

   ```bash
   POST https://192.0.2.2/api/acm/v1/infrastructure/workspaces/infra-ws/environments
   ```

   <br>

   **JSON Request**

   ```json
   {
      "name": "demo-env",
      "proxies": [
         {
            "proxyClusterName": "test-ig",
            "hostnames": [
               "data-host"
            ]
         }
      ]
   }
   ```

2. To create a Service Workspace with a minimum configuration, send the following JSON request to the `/services/workspaces` endpoint.

   ```bash
   POST https://192.0.2.2/api/acm/v1/services/workspaces
   ```

   <br>

   **JSON Request**

   ```json
   {
      "name": "service-ws"
   }
   ```

### Create a Basic API Proxy {#create-basic-api-proxy}

1. To create an API proxy with a minimum configuration and the default policies, send the following JSON request to the `/services/workspaces/service-ws/proxies` endpoint. The Proxy service target is our Echo Server.

   ```bash
   POST https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies
   ```

   **JSON Request**

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ]
      }
   }
   ```

2. To test whether the API Proxy and backend Echo Server are working correctly, send a custom header and dummy JSON body to show these proxied values in the Echo Server response:

   ```bash
   POST https://192.0.2.4/my/test/api
   HEADERS:
      X-NGINX-Test: true
   ```

   <br>

   **JSON Request**

   ```json
   {
      "testKey": "testValue"
   }
   ```

   <br>

   **Verification**

   If everything is configured correctly in API Connectivity Manager and the Echo Server, the response should be similar to the following example:

   ```bash
   Request served by echo-host

   HTTP/1.0 POST /my/test/api

   Host: 192.0.2.4
   Accept: */*
   Cache-Control: no-cache
   Content-Length: 30
   Content-Type: application/json
   X-Correlation-Id: c241b72519e71cf7bce9262910ffbe40
   X-Real-Ip: 192.0.2.1
   X-NGINX-Test: true

   {"testKey": "testValue"}
   ```

---

## Get Count of Proxies in an Environment {#count-proxies-in-env}

To get the count of active proxies, send the following REST request to the `/infrastructure/workspaces/infra-ws/environments/demo-env/api-count` endpoint:

```bash
GET https://192.0.2.2/api/acm/v1/infrastructure/workspaces/infra-ws/environments/demo-env/api-count
```

If you've successfully configured a proxy the following count is returned.

Response:

```json
    1
```

---

## View Environment Metrics {#view-env-metrics}

1. On the left menu, select **Infrastructure**.
2. Select a workspace from the table.
3. Select the Actions menu (represented by an ellipsis, `...`) next to your environment on the **Actions** column.
4. Select **Metrics**.
5. Update the start and end time of the metrics with the **time range selection** on the dashboard overview.
6. To view metrics broken down by cluster in the environment, select the **API Gateway Clusters** tab.

---

## View Proxy Metrics {#view-proxy-metrics}

1. On the left menu, select **Services**.
2. Select a workspace from the table.
3. Select the Actions menu (represented by an ellipsis, `...`) next to your environment on the **Actions** column.
4. Select **Metrics**.
5. Update the start and end time of the metrics with the **time range selection** on the dashboard overview.
6. Filter by advanced routes with the **advanced route selection** on the dashboard overview.
7. To view metrics broken down by status code in the proxy, select the **API Gateway Clusters** tab.
