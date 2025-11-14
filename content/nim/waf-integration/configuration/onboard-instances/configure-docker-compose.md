---
title: Configure Docker Compose
description: Update your Docker Compose file to run F5 WAF for NGINX.
toc: true
weight: 400
nd-content-type: how-to
nd-product: NIM
nd-docs: 
---

## Before you begin

Before setting up Docker Compose, make sure you’ve done the following:

- Install F5 WAF for NGINX by following the [installation guide]({{< ref "/waf/install/docker.md#hybrid-configuration" >}}).  
- Create a `docker-compose.yaml` file as part of the installation process.  

In this section, you’ll update the file so F5 WAF for NGINX can integrate with NGINX Instance Manager.

## Edit the Docker Compose file

1. Edit the `docker-compose.yaml` file created during installation.

   To give F5 WAF for NGINX access to the policy and log profile bundles written by NGINX Instance Manager, make the following changes:

   - Add the line `user: 101:<group-id>` to each service. The group ID should match the NGINX Agent group on your system. You can find the group ID by running:

        ```shell
        cat /etc/group
        ```

   - Add `/etc/nms` to the volume maps for both services.

        **Example:**

        ```yaml
        version: "3.9"

        services:
          waf-enforcer:
            container_name: waf-enforcer
            image: private-registry.nginx.com/nap/waf-enforcer:5.2.0
            user: 101:1002
            environment:
              - ENFORCER_PORT=50000
            ports:
              - "50000:50000"
            volumes:
              - /opt/app_protect/bd_config:/opt/app_protect/bd_config
              - /etc/nms:/etc/nms
            networks:
              - waf_network
            restart: always

          waf-config-mgr:
            container_name: waf-config-mgr
            image: private-registry.nginx.com/nap/waf-config-mgr:5.2.0
            user: 101:1002
            volumes:
              - /opt/app_protect/bd_config:/opt/app_protect/bd_config
              - /opt/app_protect/config:/opt/app_protect/config
              - /etc/app_protect/conf:/etc/app_protect/conf
              - /etc/nms:/etc/nms
            restart: always
            network_mode: none
            depends_on:
              waf-enforcer:
                condition: service_started

        networks:
          waf_network:
            driver: bridge
        ```

2. Restart the containers:

    ```shell
    docker compose restart
    ```