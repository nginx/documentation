---
title: Get started
toc: true
weight: 100
type: how-to
product: NGINX One
---

The F5 NGINX One Console makes it easy to manage NGINX instances across locations and environments. The console lets you monitor and control your NGINX fleet from one place—you can check configurations, track performance metrics, identify security vulnerabilities, manage SSL certificates, and more. 

This guide provides step-by-step instructions to activate and use F5 NGINX One Console. For a list of the latest changes, see our [changelog]({{< ref "/nginx-one/changelog.md" >}})

## Benefits and key features

NGINX One offers the following key benefits:

- **Centralized control**: Manage all your NGINX instances from a single console.
- **Enhanced monitoring and risk detection**: Automatically detect critical vulnerabilities (CVEs), verify SSL certificate statuses, and identify security issues in NGINX configurations.
- **Performance optimization**: Track your NGINX versions and receive recommendations for tuning your configurations for better performance.
- **Graphical Metrics Display**: Access a dashboard that shows key metrics for your NGINX instances, including instance availability, version distribution, system health, and utilization trends.
- **Real-time alerts**: Receive alerts about critical issues.

## Before you begin 

**You need access to F5 Distributed Cloud**.

If you already have accessed F5 Distributed Cloud and have NGINX instances available, you can skip these sections and start to [Add your NGINX instances to NGINX One](#add-your-nginx-instances-to-nginx-one). Otherwise, take these steps to "onboard" yourself to NGINX One Console.

<details>
<summary>If you want to register for a trial</summary>

### Register for a trial subscription

<!-- Make sure to check with sales enablement -->
If you want to register for a trial, navigate to https://account.f5.com/myf5. If needed, select **Sign up** to get an account. Then follow these steps:

1. Navigate to https://account.f5.com/myf5 and log in.
1. Select trials
1. Find **F5 NGINX**. Sign up for the trial. 
1. The trial may require approval. 

</details>

<details>
<summary>Confirm access to the F5 Distributed Cloud</summary>

### Confirm access to the F5 Distributed Cloud

{{< include "/nginx-one/cloud-access.md" >}}

</details>

<details>
<summary>Confirm access to NGINX One Console</summary>

### Confirm access to NGINX One Console

{{< include "/nginx-one/cloud-access-nginx.md" >}}

</details>

<details>
<summary>Install an instance of NGINX</summary>

### Install an instance of NGINX

{{< include "/nginx-one/install-nginx.md" >}}

</details>

<details>
<summary>Make sure you're running a supported Linux distribution</summary>

NGINX Agent sets up communication between your NGINX Instance and NGINX One Console. Make sure your Linux operating system is listed below. The installation script for NGINX Agent is compatible with these distributions and versions.

### NGINX Agent installation script: supported distributions

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

</details>

---

## Add your NGINX instances to NGINX One

Add your NGINX instances to NGINX One. You'll need to create a data plane key and then install NGINX Agent on each instance you want to monitor.

The following instructions include minimal information, sufficient to "get started." See the following links for detailed instructions:

- [Prepare - Create and manage data plane keys]({{< ref "/nginx-one/connect-instances/create-manage-data-plane-keys.md" >}})
- [Add an NGINX instance]({{< ref "/nginx-one/connect-instances/add-instance.md" >}})
- [Connect NGINX Plus container images]({{< ref "/nginx-one/connect-instances/connect-nginx-plus-container-images-to-nginx-one.md" >}})

### Generate a data plane key {#generate-data-plane-key}

A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One.

To generate a data plane key:

- **For a new key:** In the **Add Instance** pane, select **Generate Data Plane Key**.
- **To reuse an existing key:** If you already have a data plane key and want to use it again, select **Use existing key**. Then, enter the key's value in the **Data Plane Key** box.

{{<call-out "caution" "Data plane key guidelines" "fas fa-key" >}}
Data plane keys are displayed only once and cannot be retrieved later. Be sure to copy and store this key securely.

Data plane keys expire after one year. You can change this expiration date later by [editing the key]({{< ref "nginx-one/connect-instances/create-manage-data-plane-keys.md#change-expiration-date" >}}).

[Revoking a data plane key]({{< ref "nginx-one/connect-instances/create-manage-data-plane-keys.md#revoke-data-plane-key" >}}) disconnects all instances that were registered with that key.
{{</call-out>}}

### Add an instance

Depending on whether this is your first time using NGINX One Console or you've used it before, follow the appropriate steps to add an instance:

- **For first-time users:** On the welcome screen, select **Add Instance**.
- **For returning users:** If you've added instances previously and want to add more, select **Instances** on the left menu, then select **Add Instance**.


### Install NGINX Agent

After entering your data plane key, you'll see a `curl` command similar to the one below. Copy and run this command on each NGINX instance to install NGINX Agent. Once installed, NGINX Agent typically registers with NGINX One within a few seconds.

{{<call-out "important" "Connecting to NGINX One" >}}
NGINX Agent must be able to establish a connection to NGINX One Console's Agent endpoint (`agent.connect.nginx.com`). Ensure that any firewall rules you have in place for your NGINX hosts allows network traffic to port `443` for all of the following IPs:

- `3.135.72.139`
- `3.133.232.50`
- `52.14.85.249`
{{</call-out>}}

To install NGINX Agent on an NGINX instance:

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

    Next, use the `curl` command provided to you to install NGINX Agent:

    ``` shell
    curl https://agent.connect.nginx.com/nginx-agent/install | DATA_PLANE_KEY="YOUR_DATA_PLANE_KEY" sh -s -- -y
    ```

   - Replace `YOUR_DATA_PLANE_KEY` with your actual data plane key.
   - The `-y` option automatically confirms any prompts during installation.

The `install` script writes an `nginx-agent.conf` file to the `/etc/nginx-agent/` directory, with the [data plane key](#generate-data-plane-key) that you generated. You can find this information in the `nginx-agent.conf` file:

{{< include "/nginx-one/conf/nginx-agent-conf.md" >}}

<span style="display: inline-block; margin-top: 20px;" >

{{<call-out "note" "Note: NGINX Agent poll interval" >}} We recommend keeping `dataplane.status.poll_interval` between `30s` and `60s` in the NGINX Agent config (`/etc/nginx-agent/nginx-agent.conf`). If the interval is set above `60s`, NGINX One Console may report incorrect instance statuses.{{</call-out>}}

<br>

---

The NGINX One Console dashboard relies on APIs for NGINX Plus and NGINX Open Source Stub Status to report traffic and system metrics. The following sections show you how to enable those metrics.

### Enable NGINX Plus API

{{< include "/use-cases/monitoring/enable-nginx-plus-api.md" >}}

### Enable NGINX Open Source Stub Status API

{{< include "/use-cases/monitoring/enable-nginx-oss-stub-status.md" >}}

---

## View instance metrics with the NGINX One dashboard

After connecting your NGINX instances to NGINX One, you can monitor their performance and health. The NGINX One dashboard is designed for this purpose, offering an easy-to-use interface.

### Log in to NGINX One

1. Log in to [F5 Distributed Console](https://www.f5.com/cloud/products/distributed-cloud-console).
1. Select **NGINX One > Visit Service**.

### Overview of the NGINX One dashboard

{{< include "/use-cases/monitoring/n1c-dashboard-overview.md" >}}







