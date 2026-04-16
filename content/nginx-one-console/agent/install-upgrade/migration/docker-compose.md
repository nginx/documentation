---
title: Migrate NGINX Agent v2 to v3 with Docker Compose
toc: true
weight: 120
nd-content-type: how-to
nd-product: NAGENT
---

## Before you begin

- Ensure you have:
  - docker compose installed
  - Registry credentials (if required)
  - `NGINX_LICENSE_JWT` and the NGINX Agent command auth token (data plane key)
- Back up your existing docker-compose.yaml.
- Plan a maintenance window and test this procedure in a non‑production environment first.

{{< call-out class="caution" title="Do not run v2 and v3 concurrently" >}}
Do not run NGINX Agent v2 and v3 concurrently in the same container or on the same host.
{{< /call-out >}}

## Steps

1. Update your compose file to use the v3 image and environment variables. Example:
   ```yaml
   version: "3.8"
   services:
     nginx-agent:
       image: <registry>/nginx-plus/agent/debian:<v3-tag>
       environment:
         NGINX_AGENT_COMMAND_SERVER_HOST: agent.connect.nginx.com
         NGINX_AGENT_COMMAND_SERVER_PORT: "443"
         NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY: "false"
         NGINX_AGENT_COMMAND_AUTH_TOKEN: ${NGINX_AGENT_COMMAND_AUTH_TOKEN}
         NGINX_LICENSE_JWT: ${NGINX_LICENSE_JWT}
         # Optional: If using Config Sync Groups
         # NGINX_AGENT_LABELS: config-sync-group=<config-sync-group-name>
   ```

2. Restart the service:
   ```shell
   docker compose down
   docker compose up -d
   ```

3. Validate the migration:
   ```shell
   docker logs <nginx-agent-container-name>
   ```
   - Look for: msg="Agent connected"
   - Verify the instance is Online in the NGINX One Console.

## Rollback

- Restore the previous docker-compose.yaml and run:
  ```shell
  docker compose down && docker compose up -d
  ```

## References

- [Agent v3 environment variables:]({{< ref "/nginx-one-console/agent/configure-instances/configuration-overview/" >}})
- [Docker images:]({{< ref "https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/" >}})
- Config conversion script: https://raw.githubusercontent.com/nginx/agent/v3/scripts/packages/upgrade-agent-config.sh