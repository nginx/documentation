---
title: Breaking Changes
weight: 590
toc: true
nd-docs: DOCS-1227
nd-content-type: how-to
nd-product: NAGENT
aliases:
  - /nginx-one-console/agent/install-upgrade/upgrade-v2-v3/
---

Use this section to choose the environment‑specific guide for migrating from NGINX Agent v2 to NGINX Agent v3.

{{< call-out class="warning" title="Breaking changes" >}}

- Environment variables renamed (v2 → v3):
  - NGINX_AGENT_SERVER_HOST → NGINX_AGENT_COMMAND_SERVER_HOST
  - NGINX_AGENT_SERVER_GRPCPORT → NGINX_AGENT_COMMAND_SERVER_PORT
  - NGINX_AGENT_SERVER_TOKEN → NGINX_AGENT_COMMAND_AUTH_TOKEN
  - Ensure the new variables are set correctly before deployment.
  - [Complete list of Agent v3 environment variables:]({{< ref "/nginx-one-console/agent/configure-instances/configuration-overview/" >}})


- Config Sync Groups:
  - In v3, apply the label using: NGINX_AGENT_LABELS: config-sync-group=<config-sync-group-name>
{{< /call-out >}}

{{< call-out class="caution" title="Plan and test your migration" >}}
Do not run v2 and v3 concurrently on the same host, pod, or container. Test in a non‑production environment first and schedule a maintenance window for production.
{{< /call-out >}}

