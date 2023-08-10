---
title: "Creating Highly Available Gateways"
date: 2023-08-02T22:09:31-07:00
draft: false
description: "This document describes how to create highly available gateways with App Delivery Manager using the `nginx-ha-keepalived` package."
weight: 100
toc: true
tags: [ "docs" ]
docs: "DOCS-000"
doctype: "tutorial"
---

{{<custom-styles>}}

## Overview
Application Delivery Manager gateways are entry points for applications, and create NGINX server blocks. These blocks are normally used to bind local IPs to ports and accept incoming connections. 

For high availability (HA) connections, you can use the `keepalived` framework to make the server blocks bind to non-local IP addresses instead.

{{<call-out "tip" "High Availability">}}
High availability Gateway: A Gateway which runs continously without failing even after some of the systems it is deployed on fails. 
{{</call-out>}}

## Before You Begin
To complete the instructions in this guide, you need the following:

- Two systems in the same subnet and instance group, both with [NGINX Plus]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-plus" >}}) and [NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}) installed.
- Free IPs on the subnet (For use as virtual IPs) which are not statically configured for other machines or for DHCP allocation.

## Installing and Configuring keepalived

{{< warning >}}
- `nginx-ha-keepalived` has the `keepalived` binary bundled in the install package.
- Any existing `keepalived binary` is overwritten by the `nginx-ha-keepalived` installation. 
- `nginx-ha-setup` will also overwrite an existing `keepalived` configuration.

If the above is not desired, then the scripts in `nginx-ha-keepalived` can be used as reference to create a custom NGINX Plus `keepalived` setup. 
{{< /warning >}}

<br>

{{<tabs name="install-nginx-ha-keepalived">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. Run the following commands to install `keepalived` and the scripts needed for HA configuration:

    ```bash
    sudo yum install -y nginx-ha-keepalived
    sudo systemctl unmask keepalived
    sudo systemctl enable keepalived
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. Run the following commands to install `keepalived` and the scripts needed for HA configuration:

    ```bash
    sudo apt-get install -y nginx-ha-keepalived
    sudo systemctl unmask keepalived
    sudo systemctl enable keepalived
    ```

{{%/tab%}}

{{</tabs>}}

2. Once installed, run the following command to configure `keepalived`, following the prompts.

    ```bash
    sudo nginx-ha-setup
    ```

You can read the NGINX Plus [Admin Guides on High Availability]({{< relref "/nginx/admin-guide/high-availability" >}}) for more details.

---

## Validating NGINX and keepalived
Before continuing, we need to check that `keepalive ` is configured and working properly.

### Checking keepalived status

We can first check that `keepalived` is running on each system and view its status using `systemctl`:

```shell
systemctl status keepalived
```

### Checking the keepalived instance states

Once we have verified that `keepalived` is running on both systems, we can then compare their states - one instance of `keepalived` should be in the active state and the other in standby state. 

We have multiple methods for checking the instances are behaving correctly:

- [Compare the configured IP address assignment](#compare-the-configured-ip-address-assignment)
- [Read the `nginx-ha-keepalived` state file](#read-the-nginx-ha-keepalived-state-file)
- [Manually Trigger a Failover](#manually-trigger-a-failover)

#### Compare the configured IP address assignment

Check the `keepalived` configuration in order to obtain the `virtual_ipaddress`:

```text
vrrp_instance VI_1 {
    interface ens192
    priority 101
    virtual_router_id 51
    advert_int 1
    accept
    garp_master_refresh 5
    garp_master_refresh_repeat 1
    unicast_src_ip 10.10.10.123
    unicast_peer {
        10.10.10.118
    }
    virtual_ipaddress {
        10.10.10.150
    }
    track_script {
        chk_nginx_service
        chk_manual_failover
    }
    notify "/usr/lib/keepalived/nginx-ha-notify"
}
```

The IP in `virtual_ipaddress` should be assigned to the interface of the active instance, which is IP `203.0.113.150/32` on interface `ens192` in the example below.

You can check the IP addresses using `ip`:

```shell
ip -br a
```


**Active Instance Output**

```shell
lo               UNKNOWN        127.0.0.1/8 ::1/128
ens160           UP             192.0.2144/18 2620:128:e008:4004:f816:3eff:fe7c:c63/64 fe80::f816:3eff:fe7c:c63/64
ens192           UP             10.10.10.123/24 203.0.113.150/32 fe80::f816:3eff:fe14:460a/64
```

**Standby Instance Output**

```shell
lo               UNKNOWN        127.0.0.1/8 ::1/128
ens160           UP             192.0.2.66/18 2620:128:e008:4004:f816:3eff:fe01:e4df/64 fe80::f816:3eff:fe01:e4df/64
ens192           UP             203.0.113.150/24 fe80::f816:3eff:fe63:d94f/64
docker0          DOWN           198.51.100.1/16 fe80::42:39ff:fe87:b458/64
```

#### Read the `nginx-ha-keepalived` state file
`keepalived` invokes the `/usr/lib/keepalived/nginx-ha-notify` script on state changes, which stores the current state in the `/var/run/nginx-ha-keepalived.state` file.

You can check the state files of the instances using `cat`:

```shell
cat /var/run/nginx-ha-keepalived.state
```

**Active Instance Output**

```shell
STATE=MASTER
```

**Standby Instance Output**

```shell
STATE=BACKUP
```

#### Manually Trigger a Failover
You can trigger a test failover by stopping NGINX on the active instance or rebooting the system completely. This should move the virtual IP address from the active instance to the standby (backup) instance, verifying that it is working correctly.

---

## Configuring Application Delivery Manager
To enable high availability on a Gateway, the `server` blocks must bind to the `keepalived` floating/virtual IP addresses. This can be by defining listen IPs when adding an instance group to a gateway, which is possible through both the API and the web interface. 

This configuration is per instance group and must be specified on all instance groups for correct high availability configuration.

<br>

{{<tabs name="listenip-configuration">}}

{{%tab name="API"%}}
To add `listenIps` using the REST API, include the IP addresses in a Gateway `POST` or `PUT` request to the following endpoints:

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                           |
|--------|----------------------------------------------------|
| `POST` | `/api/adm/v1/environments/{environment-uuid}/gateways` |
| `PUT` | `/api/adm/v1/environments/{environment-uuid}/gateways/{gateway-uuid}` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

<details open>
<summary>JSON request</summary>

```json
{
  "metadata": {
    "uid": "dcbdf985-ba2c-48e9-9fa2-be8097957197",
    "name": "gw1"
  },
  "ingress": {
    "uris": [
      {
        "uri": "http://example.com"
      }
    ],
    "placement": {
      "instanceGroupRefs": [
        {
          "ref": "08a35e5d-7bdd-4b26-971c-0ce0e43271b9",
          "listenIps": [
            "203.0.113.150"
          ]
        }
      ]
    }
  }
}
```

</details>

{{%/tab%}}
{{%tab name="UI"%}}
To configure this with the web interface, follow the steps below.
1. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then, from the Launchpad menu, select App Delivery Manager.
1. On the left menu, select **Gateways**.
1. In the Gateway edit form select **Placements**.
1. Add or edit the instance group.
1. In the instance group edit form enter the `listenIps`.

{{%/tab%}}
{{</tabs>}}

---

## Validating Application Delivery Manager

Once you have configured a gateway listen IP using a `keepalived` virtual IP, you can then test it for correctness using a [web component]({{<relref "/nms/adm/about/api-overview" >}}).
1. Create a web component that references the high availability gateway.
1. Access the web component using the virtual IP, such as with `curl`:

    ```shell
    curl --header 'Host: example.com' http://203.0.113.150/web1
    ```

1. Stop the NGINX service on the active instance.

    ```shell
    sudo systemctl stop nginx
    ```

1. After briefly waiting, access the web component again, which should demonstrate the changeover.

    ```shell
    curl --header 'Host: example.com' http://203.0.113.150/web1
    ```
