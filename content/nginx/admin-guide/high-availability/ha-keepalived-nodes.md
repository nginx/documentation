---
description: Enable high availability of F5 NGINX Plus instances in on-premises deployments,
  with active-active pairs and multiple passive instances.
docs: DOCS-405
title: Configuring Active-Active High Availability and Additional Passive Nodes with
  keepalived
toc: true
weight: 200
type:
- how-to
---

<span id="intro"></span>
## Introduction

F5 NGINX Plus utilizes [keepalived](http://www.keepalived.org/) to provide high availability (HA) in a standard active‑passive fashion. This provides failover redundancy in the event of a problem on the primary NGINX Plus node. We can extend this functionality with additional nodes and changes to the `keepalived` configuration, providing additional redundancy and scalability options. This guide assumes that you have already configured NGINX Plus in an active‑passive implementation with [the NGINX HA solution]({{< relref "ha-keepalived.md" >}}).

**NOTE:** In a public cloud deployment we recommend using a Layer 4 or TCP load‑balancing service offered by the cloud provider to distribute traffic to NGINX Plus for active‑active functionality.

<span id="why_passive"></span>
## Why Add a Passive Node?

Many organizations have strict requirements on levels of redundancy and a two node active‑passive system may not meet these requirements. Adding a third node configured to take over in the event that both other nodes are down, provides further redundancy while keeping the configuration simple. This also allows for maintenance on a node without losing redundancy.

<span id="why_active"></span>
## Why Configure Active-Active HA?

You can run NGINX Plus in an “active‑active” fashion, where two or more nodes handle traffic at the same time. This is achieved using multiple active IP addresses. Each IP address is hosted on a single NGINX instance, and the Keepalived configuration ensures that these IP addresses are spread across two or more active nodes.

- When hosting multiple services, each service’s DNS name should resolve to one of the IP addresses. Share the IP addresses between the services.
- Use round‑robin DNS to map a single DNS name to multiple IP addresses.
- Use a L3 load‑balancing device such as a datacenter edge load balancer to distribute L3 traffic between the IP addresses.

Active‑active may be used to increase the capacity of your load‑balanced cluster, but be aware that if a single node in an active‑active pair were to fail, the capacity would be reduced by half. You can use active‑Active as a form of safety, to provide sufficient resource to absorb unexpected spikes of traffic when both nodes are active, and you can use active‑active in larger clusters to provide more redundancy.

Note that NGINX instances in a load‑balanced cluster do not share configuration or state. For best performance in an active‑active scenario, ensure that connections from the same client are routed to the same active IP address, and use session persistence methods such as [`sticky cookie`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_cookie) that do not rely on server‑side state.

<span id="conf_passive"></span>
## Configuring keepalived for an Additional Passive Node

To configure an additional passive node for your existing NGINX Plus active‑passive HA pair, perform the following steps:

1. Install the **nginx-plus** and **nginx-ha-keepalived** packages on the new node.
2. Copy **/etc/keepalived/keepalived.conf** from the secondary node to the same location on the new node.
3. Edit **keepalived.conf** on the new node:
    - Lower the `priority` on any `vrrp_instance` blocks so that it is lower than the other nodes.
    - Change `unicast_src_ip` to match new node's host IP address.
    - Add the IP address of the secondary node to the `unicast_peer` section so that all other nodes are listed.

    Below is a sample **keepalived.conf** on an additional passive node with IP address 192.168.10.12. The IP addresses of the other two nodes are 192.168.10.10 and 192.168.10.11. The virtual IP address (VIP) is 192.168.10.100.

    ```yaml
    vrrp_script chk_nginx_service {
        script  "/usr/lib/keepalived/nginx-ha-check"
        interval 3
        weight   50
    }

    vrrp_instance VI_1 {
        interface         eth0
        state             BACKUP
        priority          99
        virtual_router_id 51
        advert_int        1
        accept
        unicast_src_ip    192.168.10.12

        unicast_peer {
            192.168.10.10
            192.168.10.11
        }

        virtual_ipaddress {
            192.168.10.100
        }

        track_script {
            chk_nginx_service
        }

        notify "/usr/lib/keepalived/nginx-ha-notify"
    }
    ```

4. Edit **keepalived.conf** on the other nodes, adding the IP address of the new passive node to the `unicast_peer` section so that all other nodes are listed:

   ```yaml
   unicast_peer {
       192.168.10.11
       192.168.10.12
   }
   ```

4. Restart `keepalived` on all nodes.
5. Test by stopping NGINX Plus on the first two nodes.

All NGINX Plus nodes must have the identical configuration and SSL certificates. For information about synchronizing NGINX Plus configuration, see [Synchronizing NGINX Configuration in a Cluster]({{< relref "configuration-sharing.md" >}}).

<span id="conf_active"></span>
## Configuring keepalived for Active-Active HA

In order to direct traffic to both nodes at the same time, an additional VIP must be used. This new VIP will be active on the previously passive node, so that each node is active with its own VIP. To configure an existing NGINX Plus HA pair as active‑active, perform the following steps:

1. Edit **keepalived.conf** on the secondary node:
    - Copy the entire `vrrp_instance block VI_1` section and paste it below the existing block
    - In the copied `vrrp_instance` section:
        - Rename the new `vrrp_instance to VI_2` or another unique name
        - Change the `virtual_router_id` to `61` or another unique value
        - Change the `virtual_ipaddress` to an available IP address on the same subnet (in this example 192.168.10.101)
        - Change the `priority` value to `100`

            ```none
            vrrp_script chk_nginx_service {
                script  "/usr/lib/keepalived/nginx-ha-check"
                interval 3
                weight   50
            }

            vrrp_instance VI_1 {
                interface         eth0
                state             BACKUP
                priority          101
                virtual_router_id 51
                advert_int        1
                accept
                unicast_src_ip    192.168.10.10

                unicast_peer {
                    192.168.10.11
                }

                virtual_ipaddress {
                    192.168.10.100
                }

                track_script {
                    chk_nginx_service
                }

                notify "/usr/lib/keepalived/nginx-ha-notify"
            }

            vrrp_instance VI_2 {
                interface         eth0
                state             BACKUP
                priority          100
                virtual_router_id 61
                advert_int        1
                accept
                unicast_src_ip    192.168.10.10

                unicast_peer {
                    192.168.10.11
                }

                virtual_ipaddress {
                    192.168.10.101
                }

                track_script {
                    chk_nginx_service
                }

                notify "/usr/lib/keepalived/nginx-ha-notify"
            }
            ```

2. Edit **keepalived.conf** on the primary node:
    - Repeat the edits performed on the secondary node.
    - Set the `priority` within the new `vrrp_instance` to `99` or a value lower than on the secondary node.
3. Restart `keepalived` on all nodes.

Configuration file and SSL certificate file synchronization is out of scope for this document but make sure all nodes have identical NGINX Plus configuration.

<span id="nginx_for_active"></span>
## Configuring NGINX Plus for Active-Active HA

Now that the two NGINX Plus nodes are active with their own VIPs, NGINX Plus itself must be configured. There are two options for distributing traffic to the active nodes. Option 1 has all nodes active, with each node handling at least one application. Option 2 has all applications active on all nodes.

**NOTE:** If the application being load balanced requires session persistence, we recommend that you use [sticky cookie](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_cookie), [sticky route](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_route) or [IP hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash) method, as they   function correctly with multiple active nodes. [Sticky learn](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_learn) creates a session table in memory that is not shared between active nodes.


### Configuring NGINX Plus for Different Applications on Each Node

In this configuration, each NGINX Plus node only processes requests to `server` blocks for which it has an active VIP. In the event of a failover, the active node is primary for additional VIPs and processes requests for the associated `server` blocks.

Each `server` block includes the [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive to specify which VIP it is listening on.

Building on the active‑active `keepalived` configuration from the [previous section](#conf_active), we're using the same two VIPs here. In this example application 1 is active on NGINX Plus node 1 and application 2 is active on NGINX node 2:

```nginx
server {
    listen 192.168.10.100:80;

    location / {
        root /application1;
    }
}

server {
    listen 192.168.10.101:80;

    location / {
        root /application2;
    }
}
```

### Configuring NGINX Plus for All Applications on All Nodes

In this configuration, NGINX Plus is able to process the traffic for any application on any VIP. In the event of a failure on a node, the VIP for that node moves to the node with the next highest priority. This way the DNS load balancing configuration does not need to change.

Each NGINX Plus node listens for all requests. DNS load balancing is used to distribute requests to NGINX Plus nodes. Simple round-robin DNS is sufficient and can be configured according to the documentation for your DNS server. Ensure that there is an `A` for each VIP with the same fully qualified domain name (FQDN). Each time the name is resolved, the DNS server's response includes all VIPs, but in a different order.

```nginx
server {
    listen *:80;

    location /app1 {
        root /application1;
    }

    location /app2 {
        root /application2;
    }
}
```

<span id="combine_methods"></span>
## Combining and Expanding Methods

Both of the methods in [Configuring NGINX Plus for Active-Active HA](#nginx_for_active) can be combined for an <span style="white-space: nowrap;">active-active-passive</span> configuration, or can even be extended to a configuration with any number of active nodes.

### Configuring All-Active HA on Three or More Nodes

The following `keepalived` configuration is for an <span style="white-space: nowrap;">active-active-active</span> configuration. Here the [steps for adding an active node](#conf_active) are just repeated for the third one. Notice that this node is active for one VIP, secondary for one VIP, and tertiary for one VIP.

```yaml
vrrp_script chk_nginx_service {
    script   "/usr/lib/keepalived/nginx-ha-check"
    interval 3
    weight   50
}

vrrp_instance VI_1 {
    interface         eth0
    state             BACKUP
    priority          101
    virtual_router_id 51
    advert_int        1
    accept
    unicast_src_ip    192.168.10.10

    unicast_peer {
        192.168.10.11
        192.168.10.12
        192.168.10.13
    }

    virtual_ipaddress {
        192.168.10.100
    }

    track_script {
        chk_nginx_service
    }

    notify "/usr/lib/keepalived/nginx-ha-notify"
}

vrrp_instance VI_2 {
    interface         eth0
    state             BACKUP
    priority          100
    virtual_router_id 61
    advert_int        1
    accept
    unicast_src_ip    192.168.10.10

    unicast_peer {
        192.168.10.11
        192.168.10.12
        192.168.10.13
    }

    virtual_ipaddress {
        192.168.10.101
    }

    track_script {
        chk_nginx_service
    }

    notify "/usr/lib/keepalived/nginx-ha-notify"
}

vrrp_instance VI_3 {
    interface         eth0
    state             BACKUP
    priority          99
    virtual_router_id 71
    advert_int        1
    accept
    unicast_src_ip    192.168.10.10

    unicast_peer {
        192.168.10.11
        192.168.10.12
        192.168.10.13
    }

    virtual_ipaddress {
        192.168.10.102
    }

    track_script {
        chk_nginx_service
    }

    notify "/usr/lib/keepalived/nginx-ha-notify"
}
```

### Configuring Active-Active-Passive HA

This example `keepalived` configuration is for the passive node in an <span style="white-space: nowrap;">active-active-passive</span> configuration. It combines the steps in [Configuring keepalived for an Additional Passive Node](#conf_passive) and [Configuring keepalived for Active-Active HA](#conf_active).

```none
vrrp_script chk_nginx_service {
    script   "/usr/lib/keepalived/nginx-ha-check"
    interval 3
    weight   50
}

vrrp_instance VI_1 {
    interface         eth0
    state             BACKUP
    priority          99
    virtual_router_id 51
    advert_int        1
    accept
    unicast_src_ip    192.168.10.12

    unicast_peer {
        192.168.10.10
        192.168.10.11
    }

    virtual_ipaddress {
        192.168.10.100
    }

    track_script {
        chk_nginx_service
    }

    notify "/usr/lib/keepalived/nginx-ha-notify"
}

vrrp_instance VI_2 {
    interface         eth0
    state             BACKUP
    priority          99
    virtual_router_id 61
    advert_int        1
    accept
    unicast_src_ip    192.168.10.12

    unicast_peer {
        192.168.10.10
        192.168.10.11
    }

    virtual_ipaddress {
        192.168.10.101
    }

    track_script {
        chk_nginx_service
    }

    notify "/usr/lib/keepalived/nginx-ha-notify"
}
```
