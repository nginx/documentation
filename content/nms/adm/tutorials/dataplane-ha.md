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
ADM Gateways are entry points for application traffic and create NGINX server blocks. These `server` blocks bind to the specified IP:port and accept incoming connections on them. We can make these IP addresses highly available using `keepalived`. `server` blocks can be made highly available by binding to these IP addresses(floating or virtual IP addresses). This document describes how to configure `keepalived` and ADM to configure HA on a Gateway. 

## Prerequisites.

### System configuration
- Setup two VMs or physical machines.
- Ensure the two VMs are on the same subnet and are reachable.
- Ensure that the floating or virtual IP/s are available and are not used by the DHCP server for allocation. 

### NGINX
- Install NGINX+ on both systems.
- Install NGINX agent on both systems as described [here](https://docs.nginx.com/nginx-management-suite/nginx-agent/install-nginx-agent/).
- Add both instances to the same instance group as described [here](https://docs.nginx.com/nginx-management-suite/nim/how-to/nginx/manage-instance-groups/).

### Keepalived configuration
- Install `nginx-ha-keepalived` package and configure it as described [here](https://docs.nginx.com/nginx/admin-guide/high-availability/ha-keepalived/).
- Ensure `keepalived` is operating as desired.

{{< warning >}}
- `nginx-ha-keepalived` has the `keepalived`` binary bundled in the install package.
- An existing keepalived binary is overwritten by the `nginx-ha-keepalived` installation. 
- Running the `nginx-ha-setup` script will overwrite existing `keepalived` configuration.
If the above is not desired, then scripts in `nginx-ha-keepalived` can be used as a reference to create a custom NGINX+ keepalived setup. 
{{< /warning >}}

## ADM configuration
To configure HA on a Gateway, the `server` blocks must bind to the `keepalived` floating/virtual IP addresses. On a Gateway this can be done via `listenIps` configuration when adding an instance group to the Gateway as shown below. The `listenIps` configuration is per instance group and must be specified on all instance groups for correct HA configuration.

### API
```
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
