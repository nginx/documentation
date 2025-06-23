---
title: "Lab 5: Upgrade NGINX Plus to the latest version"
weight: 500
toc: true
nd-content-type: tutorial
nd-product: 
- nginx-one
- nginx-plus
---

## Overview

In this lab, you upgrade NGINX Plus from R32 (or earlier) to the latest version in two ways:

- **Docker**: Deploy a new container running the latest NGINX Plus image, add it to your Config Sync Group, then shift traffic and retire older containers.  
- **VM**: Push your JWT license to an existing VM instance, install the new NGINX Plus package, and restart the service.

Pick the scenario that matches your setup.

## What you’ll learn

By the end of this lab, you’ll know how to:

- Deploy a Docker container running the latest NGINX Plus with NGINX Agent installed
- Add a VM to a Config Sync Group and push your JWT license  
- Install or upgrade to the latest NGINX Plus on a VM  
- Check version and sync status in the NGINX One Console  
- Clean up unavailable instances in the NGINX One Console  

## Before you begin

Make sure you have:

- Completed [Lab 4: Config Sync Groups]({{< ref "nginx-one/workshops/lab4/config-sync-groups.md" >}})  
- Docker and Docker Compose installed and running (for Docker scenario)  
- A VM with NGINX Plus R32 (or earlier), SSH access, and the NGINX Agent installed (for VM scenario)  
- {{< include "workshops/nginx-one-env-variables.md" >}}
- Basic familiarity with Linux command line and NGINX concepts

## Scenario A: Upgrade NGINX Plus in Docker

### Exercise A1: Pull and run the latest NGINX Plus image

1. In your shell, log in to the private registry:  

   ```shell
   echo "$JWT" | docker login private-registry.nginx.com \
     --username "$JWT" --password-stdin
   ```

2. Open `docker-compose.yaml` in a text editor and uncomment the **plus4** service block (lines 74–95). This block pulls the latest Debian NGINX Plus image with the latest NGINX Agent installed, and sets your data plane key, JWT, and config sync group.

   ```yaml
   plus4: # Debian latest NGINX Plus Web / Load Balancer
       environment:
         NGINX_AGENT_SERVER_HOST: 'agent.connect.nginx.com'
         NGINX_AGENT_SERVER_GRPCPORT: '443'
         NGINX_AGENT_TLS_ENABLE: 'true'
         NGINX_AGENT_SERVER_TOKEN: $TOKEN # Data plane key from NGINX One Console
         NGINX_LICENSE_JWT: $JWT
         NGINX_AGENT_INSTANCE_GROUP: $NAME-sync-group
       hostname: $NAME-plus4
       container_name: $NAME-plus4
       image: private-registry.nginx.com/nginx-plus/agent:debian # From NGINX Private Registry
       volumes: # Sync these folders to container
         - ./nginx-plus/etc/nginx/nginx.conf:/etc/nginx/nginx.conf
         - ./nginx-plus/etc/nginx/conf.d:/etc/nginx/conf.d
         - ./nginx-plus/etc/nginx/includes:/etc/nginx/includes
         - ./nginx-plus/usr/share/nginx/html:/usr/share/nginx/html
       ports:
         - '80' # Open for HTTP
         - '443' # Open for HTTPS
         - '9000' # Open for API / Dashboard page
         - '9113' # Open for Prometheus Scraper page
       restart: always
   ```

   {{< call-out "note" "Tip" "" >}} If you use VS Code, highlight lines 74–95 and press `Ctrl` + `/` to uncomment them. {{< /call-out >}}

3. Restart your containers:

   ```shell
   docker compose down && docker compose up --force-recreate -d
   ```

4. In the NGINX One Console, go to **Instances**.
5. You should see your new instance (`$NAME-plus4`) in the list (for example, `s.jobs-plus4`).
6. Select that instance and verify it runs the latest versions of NGINX Plus and NGINX Agent.
7. The `$NAME-plus4` container was added to the `$NAME-sync-group` config sync group and inherited the shared config.  

   {{< call-out "note" "Tip" "" >}} Because new containers in a sync group automatically pick up the shared config, you get a consistent, tested setup across versions. You can shift traffic to the new container one at a time for a safer, zero-downtime upgrade, and avoid any manual copy-and-paste steps. {{< /call-out >}}

### Exercise A2: Delete unavailable containers

When you recreate containers, they re-register in the NGINX One Console. Use the filter to clean up old entries:

1. In the NGINX One Console, go **Instances**.
2. Select **Add filter > Availability > Unavailable**.
3. Check the boxes next to the unavailable hosts.
4. Select **Delete selected**, then confirm.
5. Remove the filter: Hover over the **Availability is Unavailable** filter tag, then select **X** to clear it and show all instances again.

<span style="display: inline-block;">
{{< img src="nginx-one/images/unavailable-instances.png"
    alt="Table of three NGINX One Console instances filtered to ‘Availability = Unavailable.’ Shows hostnames (s.jobs-plus1, s.jobs-plus2, s.jobs-plus3), NGINX versions, grey ‘Unavailable’ circles, CVE and recommendation indicators, certificate status, operating system, and last reported times. The ‘Delete selected’ button appears at top right." >}}
</span>