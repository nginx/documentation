---
title: Configuring HA Gateways
weight: 100
toc: true
draft: false
tags: ["docs"]
docs: "DOCS-000"
---

{{< custom-styles >}}

## Overview
ADM Gateways are entry points for application traffic and create NGINX server blocks. These `server` blocks bind to the specified IP:port and accept incoming connections on them. We can make these IP addresses(virtual IP addresses) highly available using `keepalived`. `server` blocks can be made highly available by binding to these IP addresses. This document describes how to configure HA on a Gateway using `keepalived`. 

## Prerequisites.

### System configuration
- Setup two VMs or physical machines.
- Ensure that the two VMs are on the same subnet and are reachable.
- Ensure that some free IPs are available on the subnet for use as virtual IPs. These IPs must not be used for DHCP allocation or statically configured on any of the machines on the same subnet.  

### NGINX
- Install NGINX+ on both systems.
- Install NGINX agent on both systems as described [here](https://docs.nginx.com/nginx-management-suite/nginx-agent/install-nginx-agent/).
- Add both instances to the same instance group as described [here](https://docs.nginx.com/nginx-management-suite/nim/how-to/nginx/manage-instance-groups/).

### NGINX HA keepalived package installation and configuration
{{<tabs name="install-nginx-ha-keepalived">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To install keepalived and scripts needed for HA configuration, run the following commands.
    ```bash
    sudo yum install -y nginx-ha-keepalived
    sudo systemctl unmask keepalived
    sudo systemctl enable keepalived
    ```
2. To configure keepalived run the following command and follow the prompts.
    ```bash
    sudo nginx-ha-setup
    ```
 Refer to [High Availability Support for NGINX Plus in On-Premises Deployments](https://docs.nginx.com/nginx/admin-guide/high-availability/ha-keepalived/) document for full details.

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install keepalived and scripts needed for HA configuration, run the following commands.
    ```bash
    sudo apt-get install -y nginx-ha-keepalived
    sudo systemctl unmask keepalived
    sudo systemctl enable keepalived
    ```
2. To configure keepalived run the following command and follow the prompts.
    ```bash
    sudo nginx-ha-setup
    ```
 Refer to [High Availability Support for NGINX Plus in On-Premises Deployments](https://docs.nginx.com/nginx/admin-guide/high-availability/ha-keepalived/) document for full details.
{{%/tab%}}

{{</tabs>}}

{{< warning >}}
- `nginx-ha-keepalived` has the `keepalived` binary bundled in the install package.
- An existing keepalived binary is overwritten by the `nginx-ha-keepalived` installation. 
- Running the `nginx-ha-setup` script will overwrite existing `keepalived` configuration.

If the above is not desired, then scripts in `nginx-ha-keepalived` can be used as a reference to create a custom NGINX+ keepalived setup. 
{{< /warning >}}

## Validate NGINX and keepalived configuration.
Before proceeding further we need to check if `keepalived` is configured and working properly. Follow the steps below to verify.

### 1. keepalived is running.
Ensure that keepalived is up and running on both systems using the command below.
```bash
systemctl status keepalived
```
### 2. Check the one instance of keepalived is in active state and the other in standby state.
There are multiple ways to check the state of keepalived.

#### Option-1: Check the IP address assignment on the interface configured with keepalived.
In the keepalived configuration note down the `virtual_ipaddress`. This IP address must be configured on the active system. 
```bash
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
When both systems are up on the active system, the IP in `virtual_ipaddress` must be assigned to the configured interface on the active system. IP`10.10.10.150/32` on interface `ens192` in the example below.
##### Active system
```bash
# ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128
ens160           UP             10.145.68.144/18 2620:128:e008:4004:f816:3eff:fe7c:c63/64 fe80::f816:3eff:fe7c:c63/64
ens192           UP             10.10.10.123/24 10.10.10.150/32 fe80::f816:3eff:fe14:460a/64
```
##### Standby system
```bash
# ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128
ens160           UP             10.145.79.66/18 2620:128:e008:4004:f816:3eff:fe01:e4df/64 fe80::f816:3eff:fe01:e4df/64
ens192           UP             10.10.10.118/24 fe80::f816:3eff:fe63:d94f/64
docker0          DOWN           172.17.0.1/16 fe80::42:39ff:fe87:b458/64
```

#### Option-2: Use `nginx-ha-keepalived` state file
`keepalived` invokes the `/usr/lib/keepalived/nginx-ha-notify` script on state changes. This script stores the current state in the `/var/run/nginx-ha-keepalived.state` file.
##### Active system
```bash
# cat /var/run/nginx-ha-keepalived.state
STATE=MASTER
```
##### Standby system
```bash
# cat /var/run/nginx-ha-keepalived.state
STATE=BACKUP
```

### 3. Test failover
Test failover works by stopping NGINX on the active system or by rebooting the active system. Doing so will move the virtual IP address to the backup system.

## ADM configuration
To configure HA on a Gateway, the `server` blocks must bind to the `keepalived` floating/virtual IP addresses. On a Gateway this can be done via `listenIps` configuration when adding an instance group to the Gateway as shown below. The `listenIps` configuration is per instance group and must be specified on all instance groups for correct HA configuration.

### API
```bash
 "placement": {
      "instanceGroupRefs": [
        {
          "ref": "08a35e5d-7bdd-4b26-971c-0ce0e43271b9",
          "listenIps": [
            "10.10.10.150"
          ]
        }
      ]
    }
  }
```

### UI
{{< img src="adm/tutorials/gateway-listen-ip-configuration.png" alt="Gateway Listen IP configuration" width="80%">}}

## Validate ADM configuration
- Create a Gateway with `listenIps` set to `keepalived` virtual IPs.
- Create a web component that references the HA Gateway.
- Access the web component using the virtual IP. For e.g. `curl --header 'Host: foo.com' http://10.10.10.150/foo1`
- Stop the NGINX service on the active system.
- Access the web component again. After a brief down time the curl command should start working again.

