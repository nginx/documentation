---
title: Get started
toc: true
weight: 100
type: how-to
product: NGINX One
docs: DOCS-1393
---

This guide provides step-by-step instructions on how to activate and start using the F5 NGINX One Console. NGINX One is a management console for monitoring and managing NGINX data plane instances.

## Enable the NGINX One service {#enable-nginx-one}

To get started using NGINX One, enable the service on F5 Distributed Cloud.

1. Log in to the [F5 Distributed Console](https://www.f5.com/cloud/products/distributed-cloud-console).
1. Select **NGINX One** from the list of services.
1. Select **Enable Service**.
1. After the service has been enabled, select **Visit Service** to load the NGINX One console.

## Add your NGINX instances to NGINX One

Next, add your NGINX instances to NGINX One. You'll need to create a data plane key and then install the NGINX Agent on each instance you want to monitor.

### Add an instance

Depending on whether this is your first time using the NGINX One console or you've used it before, follow the appropriate steps to add an instance:

- **For first-time users:** On the welcome screen, select **Add Instance**.
- **For returning users:** If you've added instances previously and want to add more, select **Instances** on the left menu, then select **Add Instance**.

### Generate a data plane key {#generate-data-plane-key}

A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One.

To generate a data plane key:

- **For a new key:** In the **Add Instance** pane, select **Generate Data Plane Key**.
- **To reuse an existing key:** If you already have a data plane key and want to use it again, select **Use existing key**. Then, enter the key's value in the **Data Plane Key** box.

{{<call-out "caution" "Data plane key guidelines" "fas fa-key" >}}
Data plane keys are displayed only once and cannot be retrieved later. Be sure to copy and store this key securely.

Data plane keys expire after one year. You can change this expiration date later by [editing the key]({{< relref "nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys.md#change-expiration-date" >}}).

[Revoking a data plane key]({{< relref "nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys.md#revoke-data-plane-key" >}}) disconnects all instances that were registered with that key.
{{</call-out>}}


### Install NGINX Agent

After entering your data plane key, you'll see a `curl` command similar to the one below. Copy and run this command on each NGINX instance to install the NGINX Agent. Once installed, the NGINX Agent typically registers with NGINX One within a few seconds.

{{<call-out "important" "Connecting to NGINX One" >}}
The NGINX Agent must be able to establish a connection to the NGINX One Console's Agent endpoint (`agent.connect.nginx.com`). Ensure that any firewall rules you have in place for your NGINX hosts allows network traffic to port `443` for all of the following IPs:

- `3.135.72.139`
- `3.133.232.50`
- `52.14.85.249`
{{</call-out>}}

To install the NGINX Agent on an NGINX instance:

1. **Check if NGINX is running and start it if it's not:**

    First, see if NGINX is running:

    ```shell
    sudo systemctl status nginx
    ```

    If the status isn't `Active`, go ahead and start NGINX:

    ```shell
    sudo systemctl start nginx
    ```

2. **Install NGINX Agent:**

    Next, use the `curl` command provided to you to install the NGINX Agent:

    ``` shell
    curl https://agent.connect.nginx.com/nginx-agent/install | DATA_PLANE_KEY="YOUR_DATA_PLANE_KEY" sh -s -- -y
    ```

   - Replace `YOUR_DATA_PLANE_KEY` with your actual data plane key.
   - The `-y` option automatically confirms any prompts during installation.

The `install` script writes an `nginx-agent.conf` file to the `/etc/nginx-agent/` directory, with the [data plane key](#generate-data-plane-key) that you generated. You can find this information in the `nginx-agent.conf` file:

```yaml
server:
  token: "<YOUR_DATA_PLANE_KEY>"
  host: agent.connect.nginx.com
  grpcPort: 443

tls:
  enable: True
  skip_verify: False
```

If you followed the [Installation and upgrade](https://docs.nginx.com/nginx-agent/installation-upgrade/) guides for installing NGINX Agent, you may need to add this information manually to `nginx-agent.conf`.

<span style="display: inline-block; margin-top: 20px;" >

{{<call-out "note" "Note: NGINX Agent poll interval" >}} We recommend keeping `dataplane.status.poll_interval` between `30s` and `60s` in the NGINX Agent config (`/etc/nginx-agent/nginx-agent.conf`). If the interval is set above `60s`, the NGINX One Console may report incorrect instance statuses.{{</call-out>}}

<br>

<i class="fa fa-check-circle" aria-hidden="true"></i> Make sure your Linux operating system is listed below. The installation script for the NGINX Agent is compatible with these distributions and versions.

#### NGINX Agent installation script: supported distributions

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution                 | Version              | Architecture    |
|------------------------------|----------------------|-----------------|
| AlmaLinux                    | 8, 9                 | x86_64, aarch64 |
| Alpine Linux                 | 3.16 - 3.18          | x86_64, aarch64 |
| Amazon Linux                 | 2023                 | x86_64, aarch64 |
| Amazon Linux 2               | LTS                  | x86_64, aarch64 |
| CentOS                       | 7.4+                 | x86_64, aarch64 |
| Debian                       | 11, 12               | x86_64, aarch64 |
| Oracle Linux                 | 7.4+, 8.1+, 9        | x86_64          |
| Red Hat Enterprise Linux     | 7.4+, 8.1+, 9        | x86_64, aarch64 |
| Rocky Linux                  | 8, 9                 | x86_64, aarch64 |
| Ubuntu                       | 20.04 LTS, 22.04 LTS | x86_64, aarch64 |

{{</bootstrap-table>}}

</span>

## View instance metrics with the NGINX One dashboard

After connecting your NGINX instances to NGINX One, you can monitor their performance and health. The NGINX One dashboard is designed for this purpose, offering an easy-to-use interface.

### Log in to NGINX One

1. Log in to the [F5 Distributed Console](https://www.f5.com/cloud/products/distributed-cloud-console).
1. Select **NGINX One > Visit Service**.

### Overview of the NGINX One dashboard

Navigating the dashboard:

- **Drill down into specifics**: For in-depth information on a specific metric, like expiring certificates, click on the relevant link in the metric's card to go to a detailed overview page.
- **Refine metric timeframe**: Metrics show the last hour's data by default. To view data from a different period, select the time interval you want from the drop-down menu.

<span style="display: inline-block; margin-top: 20px; margin-bottom: 50px;">
{{< img src="nginx-one/images/nginx-one-dashboard.png">}}
</span>

{{<bootstrap-table "table table-striped table-bordered">}}
**NGINX One dashboard metrics**
| Metric | Description | Details |
|---|---|---|
| <i class="fas fa-heartbeat"></i> **Instance availability** | Understand the operational status of your NGINX instances. | - **Online**: The NGINX instance is actively connected and functioning properly. <br> - **Offline**: The NGINX Agent is connected but the NGINX instance isn't running, isn't installed, or can't communicate with the NGINX Agent. <br> - **Unavailable**: The connection between the NGINX Agent and NGINX One has been lost or the instance has been decommissioned. <br> - **Unknown**: The current state can't be determined at the moment. |
| <i class="fas fa-code-branch"></i> **NGINX versions by instance** | See which NGINX versions are in use across your instances. | |
| <i class="fas fa-desktop"></i> **Operating systems** | Find out which operating systems your instances are running on. | |
| <i class="fas fa-certificate"></i> **Certificates** | Monitor the status of your SSL certificates to know which are expiring soon and which are still valid. | |
| <i class="fas fa-cogs"></i> **Config recommendations** | Get configuration recommendations to optimize your instances' settings. | |
| <i class="fas fa-shield-alt"></i> **CVEs (Common Vulnerabilities and Exposures)** | Evaluate the severity and number of potential security threats in your instances. | - **Major**: Indicates a high-severity threat that needs immediate attention. <br> - **Medium**: Implies a moderate threat level. <br> - **Minor** and **Low**: Represent less critical issues that still require monitoring. <br> - **Other**: Encompasses any threats that don't fit the standard categories. |
| <i class="fas fa-microchip"></i> **CPU utilization** | Track CPU usage trends and pinpoint instances with high CPU demand. | |
| <i class="fas fa-memory"></i> **Memory utilization** | Watch memory usage patterns to identify instances using significant memory. | |
| <i class="fas fa-hdd"></i> **Disk space utilization** | Monitor how much disk space your instances are using and identify those nearing capacity. | |
| <i class="fas fa-exclamation-triangle"></i> **Unsuccessful response codes** | Look for instances with a high number of HTTP server errors and investigate their error codes. | |
| <i class="fas fa-tachometer-alt"></i> **Top network usage** | Review the network usage and bandwidth consumption of your instances. | |

{{</bootstrap-table>}}











