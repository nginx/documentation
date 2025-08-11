---
description: Learn how to configure a high-availability data plane for your apps in
  on-premises deployments using F5 NGINX Controller, NGINX Plus, and keepalived.
nd-docs: DOCS-774
title: Set Up Data Plane High Availability
toc: true
weight: 40
type:
- tutorial
---

## Overview

This topic explains how to configure a high-availability data plane for your apps in on-premises deployments using F5 NGINX Controller, NGINX Plus, and keepalived. High-availability data planes help to ensure your apps operate continuously without service interruptions.

Support for High Availability (HA) mode is limited to **two NGINX Plus instances**. You can set up data plane HA in environments where IP addresses can be controlled through standard operating system calls.

### Implementation Considerations

- Data plane HA does **not** support [Zone Synchronization](https://docs.nginx.com/nginx/admin-guide/high-availability/zone_sync_details/).
- Data plane HA is **not** supported in public clouds such as Amazon Web Services, Microsoft Azure, or Google Cloud Platform.

## Prepare the High-Availability Instances

### Install NGINX Keepalived

1. NGINX distributes keepalived and some utilities in the `nginx-ha-keepalived` package. Follow the instructions in [Configuring High Availability](https://docs.nginx.com/nginx/admin-guide/high-availability/ha-keepalived/) in the NGINX Plus admin guide to install this version of NGINX `keepalived`.

   {{< call-out "caution"  >}}Other versions or packages of `keepalived` have not been tested and functionality is not guaranteed.{{< /call-out >}}

1. To ensure that `keepalived` starts automatically when the instance restarts, you must enable the service:

    ```bash
    sudo systemctl enable keepalived.service
    ```

### Configure the Data Plane Instances

After you've installed `keepalived`, there are a few manual steps to take to ready each data plane instance:

1. Set up support for non-local IP address bindings:

    ``` bash
    echo "net.ipv4.ip_nonlocal_bind=1" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    ```

1. Disable the default web server in the `default.conf` configuration file:

    ``` bash
    sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
    sudo systemctl restart nginx.service
    ```

1. Open the the `keepalived.conf` for editing and add the markers `#NGINX_CONTROLLER_HA_BEGIN` and `#NGINX_CONTROLLER_HA_END` to the `virtual_ipaddress` configuration section, then reload the configuration. This is required to avoid conflicts with the configurations that NGINX Controller Agent applies to keepalived.

    {{< call-out "note" >}}
Any IP addresses that are manually added between these markers will be removed during a Gateway configuration operation.
    {{< /call-out >}}

    {{< call-out "note" >}}
Managing the `keepalived.conf` file through third-party configuration management software is not supported.
    {{< /call-out >}}

    The following is a sample Ubuntu configuration:

    ```plaintext
    global_defs {
            vrrp_version 3
    }

    vrrp_script chk_manual_failover {
            script "/usr/lib/keepalived/nginx-ha-manual-failover"
            interval 10
            weight 50
    }

    vrrp_script chk_nginx_service {
            script "/usr/lib/keepalived/nginx-ha-check"
            interval 3
            weight 50
    }

    vrrp_instance VI_1 {
            interface ens32
            priority 101
            virtual_router_id 51
            advert_int 1
            accept
            garp_master_refresh 5
            garp_master_refresh_repeat 1
            unicast_src_ip 192.168.100.100
            unicast_peer {
                    192.168.100.101
            }
            virtual_ipaddress {
    #NGINX_CONTROLLER_HA_BEGIN
    #NGINX_CONTROLLER_HA_END
            }
            track_script {
                    chk_nginx_service
                    chk_manual_failover
            }
            notify "/usr/lib/keepalived/nginx-ha-notify"
    }
    ```

1. (Optional) To test that the `keepalived` service is up:

    1. Add an IP address between the `#NGINX_CONTROLLER_HA_BEGIN` and `#NGINX_CONTROLLER_HA_END` sections, then start `keepalived`:

        ``` bash
        sudo systemctl start keepalived
        ```

    1. Check that the IP address is configured on the primary node that you designated when setting up `keepalived`.
    1. On the backup node, check that the `keepalived` service is running and that the test IP is assigned:

        ```bash
        sudo systemctl status keepalived
        ip addr show dev <device in keepalived>
        ```

    1. After you've verified that `keepalived` works as expected, stop the service. The NGINX Controller Agent will modify the `virtual_ipaddress` contents and start the service when a Gateway configuration is pushed.

        ```bash
        sudo systemctl stop keepalived
        ```

## Create a High-Availability Gateway

Follow the instructions to [Create a Gateway]({{< ref "/controller/services/manage-gateways.md#create-a-gateway" >}}).

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Services** > **Gateways**.
1. Select **Create Gateway**.
1. Complete each of the configuration sections:

    - [General Configuration]({{< ref "#general-configuration" >}})
    - [Add Placements]({{< ref "#add-placements" >}})
    - [Set Hostnames]({{< ref "#set-hostnames" >}})
    - [Additional Settings]({{< ref "#additional-settings" >}})

1. When ready, review the API Spec and then select **Submit** to create the Gateway.

In particular, on the **Gateways > Create Gateways > Placements** page, take the steps below:

[Gateways]({{< ref "/controller/services/manage-gateways.md#overview" >}}) include placements that reference NGINX instances or instance groups. Gateway placements can be for multiple instances or instance groups, allowing a gateway to deliver services in multiple data centers and/or clouds. Placements define the physical machines that are used to manifest a particular path associated with an [application component]({{< ref "/controller/app-delivery/about-app-delivery.md#components" >}}).

On the **Gateways > Create Gateway > Placements** page:

1. Select the **Placement Type**:

    - `Instances`
    - `Instance Groups`

1. In the **Instance Refs/Instance Groups Refs** box, select the NGINX instance(s) or instance group(s) on which you want to deploy the gateway.

   {{< call-out "note" >}}
   If you're enabling **High Availability Mode**, select the [high-availability instances that you prepared]({{< ref "/controller/infrastructure/instances/ha-data-plane.md#prepare-the-high-availability-instances" >}}). NGINX Controller supports up to two high-availability instances.
   {{< /call-out >}}

1. In the **Listen IPs** box, add the IP address(es) on which the server listens for and accepts requests. If you're creating a placement for a BIG-IP Integration, add the virtual IP (VIP) address for the BIG-IP cluster.

   You can add multiple placements with different Listen IPs. When multiple placements are defined within a gateway, each placement represents a resilient path for any app component that references that gateway.

   {{< call-out "note" >}}
   - To use non-local **Listen IPs**, you must enable `net.ipv4.ip_nonlocal_bind` on the instance.
   - When **High Availability Mode** is enabled, Virtual Router Redundancy Protocol ([VRRP](https://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol#:~:text=The%20Virtual%20Router%20Redundancy%20Protocol,selections%20on%20an%20IP%20subnetwork.)) is configured for the Listen IP address(es).
   {{< /call-out >}}

1. To enable high-availability mode for your data paths, select **Use High Availability Mode**.

## Performing Maintenance on High-Availability Pairs

{{< call-out "caution"  >}}
Configuration pushes made during the maintenance window will fail.
{{< /call-out >}}

To perform maintenance updates on the high-availability pair, take the following steps:

1. Determine which instance is the primary and which is the backup node. A node's current state is recorded in the local `/var/run/nginx-ha-keepalived.state` file. You can use the `cat` command to display it:

    ```bash
    node-1 $ cat /var/run/nginx-ha-keepalived.state
    STATE=MASTER
    node-2 $ cat /var/run/nginx-ha-keepalived.state
    STATE=BACKUP
    ```

    In the example output, **node-2** is the backup node.

1. Stop `keepalived` on the backup node:

    ```bash
    sudo systemctl stop keepalived
    ```

1. Perform any maintenance or updates to the backup node.
1. Bring the backup node back online and ensure that `keepalived` is running:

    ```bash
    sudo systemctl start keepalived
    sudo systemctl status keepalived
    ```

1. Stop `keepalived` on the primary node:

    ```bash
    sudo systemctl stop keepalived
    ```

1. Test that the application still functions properly.

    If you notice any problems, re-enable the primary node and check that NGINX Plus and `keepalived` are running on the backup node:

    ```bash
    sudo systemctl status nginx
    sudo systemctl status keepalived
    ```

1. Perform any maintenance or updates on the primary node.
1. Bring the primary node back online.
1. Check the state of `keepalived` on the primary node:

    ```bash
    journalctl -u keepalived.service -f
    ip addr show
    ```

    The output should show the state transition:

    ``` bash
    Nov 23 12:44:52 testenv-d206eaca-data-1 Keepalived_vrrp[798]: (VI_1) Entering MASTER STATE                                 │Nov 23 12:36:53 testenv-d206eaca-data-2 Keepalived_vrrp[1098]: WARNING - default user 'keepalived_script' for script execu
    Nov 23 12:44:52 testenv-d206eaca-data-1 Keepalived_vrrp[798]: (VI_1) using locally configured advertisement interval (1000 │tion does not exist - please create.
    milli-sec)                                                                                                                 │Nov 23 12:36:53 testenv-d206eaca-data-2 Keepalived_vrrp[1098]: SECURITY VIOLATION - scripts are being executed but script_
    Nov 23 12:44:52 testenv-d206eaca-data-1 nginx-ha-keepalived[1338]: Transition to state 'MASTER' on VRRP instance 'VI_1'.
    ```

{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
