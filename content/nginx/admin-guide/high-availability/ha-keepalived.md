---
description: Enable high availability of F5 NGINX Plus instances in on-premises deployments,
  configuring an active-passive pair in a solution based on keepalived and VRRP.
nd-docs: DOCS-406
title: High Availability Support for NGINX Plus in On-Premises Deployments
toc: true
weight: 100
type:
- how-to
---

This article explains how to configure high availability of NGINX Plus instances in on‑premises deployment with a solution based on [keepalived](https://www.keepalived.org/).

> **Note:** This solution is designed to work in environments where IP addresses can be controlled through standard operating system calls, and often does not work in cloud environments where IP addresses are controlled through interfacing with the cloud infrastructure. For information about making NGINX Plus highly available in cloud environments, see the [Deployment Guides]({{< ref "/nginx/deployment-guides/_index.md" >}}).

<span id="ha_support"></span>
## High Availability Support Based on keepalived

NGINX Plus [Release 6]({{< ref "nginx/releases.md#r6" >}}) and later supports a solution for fast and easy configuration of NGINX Plus in an active‑passive high‑availability (HA) setup, based on [keepalived](https://www.keepalived.org/).

The [keepalived open source project](http://www.keepalived.org/) includes three components:

- The `keepalived` daemon for Linux servers.
- An implementation of the [Virtual Router Redundancy Protocol](https://tools.ietf.org/html/rfc5798) (VRRP) to manage virtual routers (virtual IP addresses, or _VIPs_).

   VRRP ensures that there is a primary node at all times. The backup node listens for VRRP advertisement packets from the primary node. If it does not receive an advertisement packet for a period longer than three times the configured advertisement interval, the backup node takes over as primary and assigns the configured VIPs to itself.
- A health‑check facility to determine whether a service (for example, a web server, PHP backend, or database server) is up and operational.

   If a service on the primary node fails the configured number of health checks, `keepalived` reassigns the virtual IP address from the primary node to the backup (passive) node.


<span id="ha_configure"></span>
## Configuring High Availability

Run the <span style="white-space: nowrap;">`nginx-ha-setup`</span> script on both nodes as the `root` user (the script is distributed in the <span style="white-space: nowrap;">**nginx-ha-keepalived**</span> package, which must be installed in addition to the base NGINX Plus package). The script configures a highly available NGINX Plus environment with an active‑passive pair of nodes acting as primary and backup. It prompts for the following data:

- IP address of the local and remote nodes (one of which will be configured as the primary, the other as the backup)
- One additional free IP address to be used as the cluster endpoint’s (floating) VIP

The configuration of the `keepalived` daemon is recorded in <span style="white-space: nowrap;">**/etc/keepalived/keepalived.conf**</span>. The configuration blocks in the file control notification settings, the VIPs to manage, and the health checks to use to test the services that rely on VIPs. Following is the configuration file created by the <span style="white-space: nowrap;">`nginx-ha-setup`</span> script on a CentOS 7 machine. Note that this is not an NGINX Plus configuration file, so the syntax is different (semicolons are not used to delimit directives, for example).

```none
global_defs {
    vrrp_version 3
}

vrrp_script chk_manual_failover {
    script   "/usr/libexec/keepalived/nginx-ha-manual-failover"
    interval 10
    weight   50
}

vrrp_script chk_nginx_service {
    script   "/usr/libexec/keepalived/nginx-ha-check"
    interval 3
    weight   50
}

vrrp_instance VI_1 {
    interface                  eth0
    priority                   101
    virtual_router_id          51
    advert_int                 1
    accept
    garp_master_refresh        5
    garp_master_refresh_repeat 1
    unicast_src_ip             192.168.100.100

    unicast_peer {
        192.168.100.101
    }

    virtual_ipaddress {
        192.168.100.150
    }

    track_script {
        chk_nginx_service
        chk_manual_failover
    }

    notify "/usr/libexec/keepalived/nginx-ha-notify"
}

```

Describing the entire configuration is beyond the scope of this article, but a few items are worth noting:

- Each node in the HA setup needs its own copy of the configuration file, with values for the `priority`, `unicast_src_ip`, and `unicast_peer` directives that are appropriate to the node’s role (primary or backup).
- The `priority` directive controls which host becomes the primary, as explained in the [next section](#ha_scripts).
- The `notify` directive names the notification script included in the distribution, which can be used to generate syslog messages (or other notifications) when a state transition or fault occurs.
- The value `51` for the `virtual_router_id` directive in the `vrrp_instance VI_1` block is a sample value; change it as necessary to be unique in your environment.
- If you have multiple pairs of `keepalived` instances (or other VRRP instances) running in your local network, create a `vrrp_instance` block for each one, with a unique name (like `VI_1` in the example) and `virtual_router_id` number.

See [keepalived manpage](https://www.keepalived.org/manpage.html) for more information about `keepalived` directives.


<span id="ha_scripts"></span>
## Using a Health-Check Script to Control Which Server Is Primary

There is no fencing mechanism in `keepalived`. If the two nodes in a pair are not aware of each other, each assumes it is the primary and assigns the VIP to itself. To prevent this situation, the configuration file defines a script‑execution mechanism called `chk_nginx_service` that runs a script regularly to check whether NGINX Plus is operational, and adjusts the local node’s priority based on the script’s return code. Code `0` (zero) indicates correct operation, and code `1` (or any nonzero code) indicates an error.

In the sample configuration of the script, the `weight` directive is set to `50`, which means that when the check script succeeds (and by implication returns code `0`):

- The priority of the first node (which has a base priority of `101`) is set to `151`.
- The priority of the second node (which has a base priority of `100`) is set to `150`.

The first node has higher priority (`151` in this case) and becomes primary.

The `interval` directive specifies how often the check script executes, in seconds (3 seconds in the sample configuration file). Note that the check fails if the timeout is reached (by default, the timeout is the same as the check interval).

The `rise` and `fall` directives (not used in the sample configuration file) specify how many times the script must succeed or fail before action is taken.

The <span style="white-space: nowrap;">`nginx-ha-check`</span> script provided with the <span style="white-space: nowrap;">**nginx-ha-keepalive**</span> package checks if NGINX Plus is up. We recommend creating additional scripts as appropriate for your local setup.


<span id="ha_status"></span>
## Displaying Node State

To see which node is currently the primary for a given VIP, run the `ip addr show` command for the interface on which the VRRP instance is defined (in the following commands, interface **eth0** on nodes **centos7-1** and **centos7-2**):

```shell
centos7-1 $ ip addr show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state
     UP qlen 1000
    link/ether 52:54:00:33:a5:a5 brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.100/24 brd 192.168.122.255 scope global dynamic eth0
       valid_lft 3071sec preferred_lft 3071sec
    inet 192.168.100.150/32 scope global eth0
       valid_lft forever preferred_lft forever
```

```shell
centos7-2 $ ip addr show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state
     UP qlen 1000
    link/ether 52:54:00:33:a5:87 brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.101/24 brd 192.168.122.255 scope global eth0
       valid_lft forever preferred_lft forever
```

In this output, the second `inet` line for **centos7-1** indicates that it is primary – the defined VIP (192.168.100.150) is assigned to it. The other `inet` lines show the primary node's real IP address (192.168.100.100) and the backup node’s IP address (192.168.100.101).

A node’s current state is recorded in the local <span style="white-space: nowrap;">**/var/run/nginx-ha-keepalived.state**</span> file. You can use the `cat` command to display it:

```shell
centos7-1 $ cat /var/run/nginx-ha-keepalived.state
STATE=MASTER
centos7-2 $ cat /var/run/nginx-ha-keepalived.state
STATE=BACKUP
```

In version 1.1 and later of the <span style="white-space: nowrap;">**nginx-ha-keepalived**</span> package, it is possible to dump VRRP extended statistics and data to the filesystem with the following command:

```shell
centos7-1 $ service keepalived dump
```

This command sends signals to the running `keepalived` proccess to write the current state to **/tmp/keepalived.stats** and **/tmp/keepalived.data**.


<span id="ha_state"></span>
## Forcing a State Change

To force the primary node to become the backup, run the following command on it:

```shell
service keepalived stop
```

As it shuts down, `keepalived` sends a VRRP packet with priority `0` to the backup node, which causes the backup node to take over the VIP.

If your cluster is using version 1.1 of the <span style="white-space: nowrap;">**nginx-ha-keepalived**</span> package, this is a simpler way to force the state change:

```shell
touch /var/run/keepalived-manual-failover
```

This command creates a file checked by the script defined in a `vrrp_script
chk_manual_failover` block. If the file exists, `keepalived` lowers the priority of the primary node, which causes the backup node to take over the VIP.


<span id="ha_addresses"></span>
## Adding More Virtual IP Addresses

The configuration created by the <span style="white-space: nowrap;">`nginx-ha-setup`</span> script is very basic, and makes a single IP address highly available.

To make more than one IP address highly available:

1. Add each new IP address to the `virtual_ipaddress` block in the <span style="white-space: nowrap;">**/etc/keepalived/keepalived.conf**</span> file on both nodes:

    ```none
    virtual_ipaddress {
        192.168.100.150
        192.168.100.200
    }
    ```

    The syntax in the `virtual_ipaddress` block replicates the syntax of the `ip` utility.

2. Run the `service keepalived reload` command on both nodes to reload the keepalived service:

    ```shell
    centos7-1 $ service keepalived reload
    centos7-2 $ service keepalived reload
    ```


<span id="ha_addresses_ipv6"></span>
## Dual-Stack Configuration of IPv4 and IPv6

In `keepalived` version 1.2.20 and later (and version 1.1 and later of the <span style="white-space: nowrap;">**nginx-ha-keepalived**</span> package), `keepalived` no longer supports mixing IPv4 and IPv6 addresses in one VRRP instance (`virtual_ipaddress` block), because that violates the [VRRP standard](https://tools.ietf.org/html/rfc5798#section-7.4).

There are two ways to configure dual‑stack HA with VRRP:

- Add the `virtual_ipaddress_excluded` block with the addresses of one family.

    ```none
    vrrp_instance VI_1 {
        ...
        unicast_src_ip 192.168.100.100

        unicast_peer {
            192.168.100.101
        }

        virtual_ipaddress {
            192.168.100.150
        }
        ...

        virtual_ipaddress_excluded {
            1234:5678:9abc:def::1
        }
        ...
    }
    ```

    The addresses are excluded from VRRP advertisements, but are still managed by `keepalived` and added or removed when there is a state change.

- Add another VRRP instance for IPv6 addresses.

    The VRRP configuration for IPv6 addresses on the primary node is:

    ```none
    vrrp_instance VI_2 {
        interface         eth0
        priority          101
        virtual_router_id 51
        advert_int        1
        accept
        unicast_src_ip    1234:5678:9abc:def::3

        unicast_peer {
            1234:5678:9abc:def::2
        }

        virtual_ipaddress {
            1234:5678:9abc:def::1
        }

        track_script {
            chk_nginx_service
            chk_manual_failover
        }

        notify "/usr/libexec/keepalived/nginx-ha-notify"
    }
    ```

    Note that VRRP instances can both use the same `virtual_router_id` since the VRRP IPv4 and IPv6 instances are completely independent of each other.

<span id="ha_troubleshoot"></span>
## Troubleshooting keepalived and VRRP

The `keepalived` daemon uses the `syslog` utility for logging. On CentOS, RHEL, and SLES‑based systems, the output is typically written to **/var/log/messages**, whereas on Ubuntu and Debian‑based systems it is written to **/var/log/syslog**. Log entries record events such as startup of the `keepalived` daemon and state transitions.

Here are a few sample entries that show the `keepalived` daemon starting up and the node transitioning a VRRP instance to the primary state (for easier reading, the **centos7-1** hostname has been removed from each line after the first):

```none
Feb 27 14:42:04 centos7-1 systemd: Starting LVS and VRRP High Availability Monitor...
Feb 27 14:42:04 Keepalived [19242]: Starting Keepalived v1.2.15 (02/26,2015)
Feb 27 14:42:04 Keepalived [19243]: Starting VRRP child process, pid=19244
Feb 27 14:42:04 Keepalived_vrrp [19244]: Registering Kernel netlink reflector
Feb 27 14:42:04 Keepalived_vrrp [19244]: Registering Kernel netlink command channel
Feb 27 14:42:04 Keepalived_vrrp [19244]: Registering gratuitous ARP shared channel
Feb 27 14:42:05 systemd: Started LVS and VRRP High Availability Monitor.
Feb 27 14:42:05 Keepalived_vrrp [19244]: Opening file '/etc/keepalived/keepalived.conf '.
Feb 27 14:42:05 Keepalived_vrrp [19244]: Truncating auth_pass to 8 characters
Feb 27 14:42:05 Keepalived_vrrp [19244]: Configuration is using: 64631 Bytes
Feb 27 14:42:05 Keepalived_vrrp [19244]: Using LinkWatch kernel netlink reflector...
Feb 27 14:42:05 Keepalived_vrrp [19244]: VRRP_Instance(VI_1) Entering BACKUP STATE
Feb 27 14:42:05 Keepalived_vrrp [19244]: VRRP sockpool: [ifindex(2), proto(112), unicast(1), fd(14,15)]
Feb 27 14:42:05 nginx-ha-keepalived: Transition to state 'BACKUP ' on VRRP instance 'VI_1 '.
Feb 27 14:42:05 Keepalived_vrrp [19244]: VRRP_Script(chk_nginx_service) succeeded
Feb 27 14:42:06 Keepalived_vrrp [19244]: VRRP_Instance(VI_1) forcing a new MASTER election
Feb 27 14:42:06 Keepalived_vrrp [19244]: VRRP_Instance(VI_1) forcing a new MASTER election
Feb 27 14:42:07 Keepalived_vrrp [19244]: VRRP_Instance(VI_1) Transition to MASTER STATE
Feb 27 14:42:08 Keepalived_vrrp [19244]: VRRP_Instance(VI_1) Entering MASTER STATE
Feb 27 14:42:08 Keepalived_vrrp [19244]: VRRP_Instance(VI_1) setting protocol VIPs.
Feb 27 14:42:08 Keepalived_vrrp [19244]: VRRP_Instance(VI_1) Sending gratuitous ARPs on eth0 for 192.168.100.150
Feb 27 14:42:08 nginx-ha-keepalived: Transition to state 'MASTER ' on VRRP instance 'VI_1 '.
Feb 27 14:42:13 Keepalived_vrrp [19244]: VRRP_Instance(VI_1) Sending gratuitous ARPs on eth0 for 192.168.100.150
```

If the system log does not explain the source of a problem, run the `tcpdump` command with the following parameters to display the VRRP advertisements that are sent on the local network:

```shell
tcpdump -vvv -ni eth0 proto vrrp
```

If you have multiple VRRP instances on the local network and want to filter the output to include only traffic between the node and its peer for a given service, include the `host` parameter and specify the peer’s IP address as defined by the `unicast_peer` block in the **keepalived.conf** file, as in the following example:

```shell
centos7-1 $ tcpdump -vvv -ni eth0 proto vrrp and host 192.168.100.101
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 65535 bytes
14:48:27.188100 IP (tos 0xc0, ttl 255, id 382, offset 0, flags [none],
    proto VRRP (112), length 40)
    192.168.100.100 > 192.168.100.101: vrrp 192.168.100.100 >
        192.168.100.101: VRRPv2 , Advertisement , vrid 51, prio 151,
        authtype simple , intvl 1s, length 20, addrs: 192.168.100.150 auth
        "f8f0e511"
```

Several fields in the output are useful for debugging:


- `vrid` – Virtual router ID (set by the `virtual_router_id` directive)
- `prio` – Node’s priority (set by the `priority` directive)
- `authtype` – Type of authentication in use (set by the `authentication` directive)
- `intvl` – Frequency at which advertisements are sent (set by the `advert_int` directive)
- `auth` – Authentication token sent (set by the `auth_pass` directive)


<span id="ha_misc"></span>
## Keeping F5 NGINX Plus Configuration Files in Sync

The NGINX Plus configuration files on the nodes must both define the services that are being made highly available. For information about synchronizing NGINX Plus configuration, see [Synchronizing NGINX Configuration in a Cluster]({{< ref "configuration-sharing.md" >}}).


<span id="ha_examples"></span>
## Additional Configuration Examples

The <span style="white-space: nowrap;">**nginx-ha-keepalived**</span> package includes more configuration examples in the <span style="white-space: nowrap;">**/usr/share/doc/nginx-ha-keepalived**</span> directory.
