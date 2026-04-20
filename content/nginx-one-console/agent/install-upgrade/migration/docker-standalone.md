---
title: Migrate in a Docker container
toc: true
weight: 130
nd-content-type: how-to
nd-product: NAGENT
---

## Before you begin
- Ensure you have:
   - Registry access for agent v3 images.
   - NGINX_LICENSE_JWT and the NGINX Agent command auth token (data plane key).
   
- Registry access for agent v3 images.
- NGINX_LICENSE_JWT and the NGINX Agent command auth token (data plane key).
- Plan a maintenance window and test this procedure in a non‑production environment first.

{{< call-out class="caution" title="Do not run v2 and v3 concurrently" >}}
Do not run NGINX Agent v2 and v3 concurrently in the same container or on the same host.
{{< /call-out >}}

## Migrate

1. Pull the v3 image:
   ```shell
   docker pull <registry>/nginx-plus/agentv3:debian
   ```

2. Run the container:
   ```shell
   docker run -d \
     --restart=always \
     -e NGINX_LICENSE_JWT="<jwt>" \
     -e NGINX_AGENT_COMMAND_SERVER_HOST=agent.connect.nginx.com \
     -e NGINX_AGENT_COMMAND_SERVER_PORT=443 \
     -e NGINX_AGENT_COMMAND_AUTH_TOKEN="<data-plane-key>" \
     -e NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY=false \
     <registry>/nginx-plus/agentv3:debian
   ```

3. (Optional) Convert a mounted v2 config file to v3:
   ```shell
   wget https://raw.githubusercontent.com/nginx/agent/v3/scripts/packages/upgrade-agent-config.sh
   chmod +x upgrade-agent-config.sh
   ./upgrade-agent-config.sh --v2-config-file=./nginx-agent-v2.conf --v3-config-file=./nginx-agent-v3.conf
   ```
   - If you used Config Sync Groups in v2, add to the v3 config:
     - NGINX_AGENT_LABELS=config-sync-group=<config-sync-group-name>

## Validate

- Check logs for a successful connection message:
  ```shell
  docker logs <container>
  ```
  - Look for: msg="Agent connected"
- Verify the instance is Online in the NGINX One Console.

## Rollback

- Stop/remove the v3 container and run the previous v2 image.

## References

- [Agent v3 environment variables:]({{< ref "/nginx-one-console/agent/configure-instances/configuration-overview/" >}})
- [Docker images:]({{< ref "https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/" >}})
- Config conversion script: https://raw.githubusercontent.com/nginx/agent/v3/scripts/packages/upgrade-agent-config.sh