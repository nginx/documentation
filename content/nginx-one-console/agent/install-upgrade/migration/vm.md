---
title: Migrate NGINX Agent v2 to v3 on VMs (RPM/DEB)
toc: true
weight: 100
nd-content-type: how-to
nd-product: NAGENT
---

## Before you begin

- Ensure you have the following:
  - NGINX_LICENSE_JWT
  - NGINX Agent command auth token (data plane key)
  - Repository access and package manager permissions for your distribution
- Back up configuration:
  - /etc/nginx-agent
  - Every configuration directory specified as a `config_dirs` value in /etc/nginx-agent/nginx-agent.conf
- Plan a maintenance window and test this procedure in a non‑production environment first.

{{< call-out class="caution" title="Do not run v2 and v3 concurrently" >}}
Do not run NGINX Agent v2 and v3 concurrently on the same host.
{{< /call-out >}}

## Steps

1. If you are using a version older than NGINX Agent v2.31.0, stop the agent before upgrading and start it again after the upgrade.
   - sudo systemctl stop nginx-agent

2. Upgrade the package to v3.
   - CentOS, RHEL (RPM‑based):
     ```shell
     sudo yum -y makecache
     sudo yum update -y nginx-agent
     ```
   - Debian, Ubuntu (DEB‑based):
     ```shell
     sudo apt-get update
     sudo apt-get install -y --only-upgrade nginx-agent -o Dpkg::Options::="--force-confold"
     ```

3. If using a config file, ensure required values are present. If you used Config Sync Groups in v2, add the following label in v3:
   - NGINX_AGENT_LABELS: config-sync-group=<config-sync-group-name>

## Validate

- Check service status and logs for a successful connection, for example: msg="Agent connected".
- Verify the instance appears Online in the NGINX One Console.

## Troubleshoot

- Review the nginx-agent service status and logs for authentication or configuration errors.
  - View logs by running: `sudo journalctl -u nginx-agent -xe`
- Confirm that credentials (NGINX_LICENSE_JWT, data plane key) are valid.

## Rollback

- Reinstall the previous v2 package and restore your configuration backup if required.

## References

- [Agent v3 environment variables:]({{< ref "/nginx-one-console/agent/configure-instances/configuration-overview/" >}})
- [Docker images:]({{< ref "https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/" >}})
- Config conversion script: https://raw.githubusercontent.com/nginx/agent/v3/scripts/packages/upgrade-agent-config.sh
