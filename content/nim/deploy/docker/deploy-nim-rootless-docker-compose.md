---
description: Deploy F5 NGINX Instance Manager using an official, F5-maintained rootless Docker image and Docker Compose.
title: Deploy rootless using Docker Compose
toc: true
weight: 150
f5-docs:
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-summary: >
  Deploy F5 NGINX Instance Manager using an official, F5-maintained rootless Docker image and
  Docker Compose. F5 builds and maintains this image, so you don't need to build it yourself.
---

## Overview

This guide shows you how to deploy F5 NGINX Instance Manager using an official rootless Docker image and Docker Compose. F5 builds and maintains this image, so you don't need to build it yourself. All container processes run as a non-root user (`nms`).

The image includes NGINX Instance Manager, Security Monitoring, and the latest F5 WAF for NGINX compiler.

This deployment has the following key characteristics:

- Rootless by design. All processes run as `nms`. The container needs no elevated privileges at runtime.
- Single persistent volume. NGINX Instance Manager stores its database, certificates, and credentials under one `/data` volume.
- First-boot initialization. On first start, the container seeds certificates and credentials automatically.
- Maintenance mode. Start the container without NGINX Instance Manager services. This lets you back up, restore, or debug safely.
- Built-in watchdog. The watchdog monitors critical NGINX Instance Manager processes. If one fails, the watchdog stops the container cleanly.

---

## What you need

Before you begin, make sure you have the following:

- [Docker Engine](https://docs.docker.com/get-docker/) 20.10 or later on a Linux host.
- [Docker Compose plugin](https://docs.docker.com/compose/install/) v2 or later.
- A JWT from your [MyF5 subscriptions page](https://my.f5.com/manage/s/subscriptions), to authenticate with the F5 image registry.
- {{<icon "download">}} {{<link "/scripts/docker-compose/docker-compose-rootless.yaml" "Download the docker-compose-rootless.yaml file">}}
- ClickHouse. This compose file starts it as a bundled service.
- At least 4 CPU cores and 4 GB of memory.

---

## Before you start

Create the admin password file in the same directory as `docker-compose-rootless.yaml`:

```shell
echo "<password>" > admin_password.txt
```

Don't commit this file to version control.

Log in to the F5 image registry with your JWT:

```shell
docker login private-registry.nginx.com --username=<JWT_CONTENTS> --password=none
```

---

## Deploy NGINX Instance Manager

Start the stack:

```shell
docker compose -f docker-compose-rootless.yaml up -d
```

NGINX Instance Manager is available at `https://localhost:8443`. Log in with the admin credentials you configured.

---

## Supported environment variables

{{<table>}}
| Variable | Required | Description |
|---|---|---|
| `NIM_CLICKHOUSE_ADDRESSPORT` | Yes | ClickHouse address and port, for example `clickhouse:9000`. |
| `NIM_USERNAME` | Yes | Admin username, set on first boot. |
| `NIM_PASSWORD` | Yes | Admin password, set on first boot. |
| `NIM_CLICKHOUSE_USERNAME` | No | ClickHouse username. |
| `NIM_CLICKHOUSE_PASSWORD` | No | ClickHouse password. |
| `NIM_LICENSE` | No | Base64-encoded license. Activates on first boot if set. Otherwise, activate manually in the UI after deployment. |
| `NIM_LOG_LEVEL` | No | Logging verbosity: `INFO`, `DEBUG`, and so on. |
| `NIM_METRICS_TTL` | No | Metrics retention, in days (integer). |
| `NIM_EVENTS_TTL` | No | Events retention, in days (integer). |
| `NIM_SECURITY_TTL` | No | Security events retention, in days (integer). |
| `NIM_WATCHDOG_TIMEOUT` | No | Watchdog timeout, in seconds (integer). |
| `NIM_LICENSE_MODE_OF_OPERATION` | No | `connected` (default) or `disconnected`. |
| `NIM_MAINTENANCE` | No | Set to `true` to start in maintenance mode. No services launch. |
| `ENABLE_METRICS` | No | `true` or `false`. |
| `PROXY_ENABLE` | No | `true` or `false`. Turns on a forward proxy. |
| `PROXY_HOST` | No | Hostname or IP address of the proxy server. |
| `PROXY_PORT` | No | Proxy port. Default is `3128`. |
| `PROXY_PROTOCOL` | No | `http` (default) or `https`. |
| `PROXY_AUTH_REQUIRED` | No | `true` or `false`. |
| `PROXY_AUTH_USERNAME` | No | Proxy username. |
| `PROXY_PASSWORD` | No | Proxy password. Set this in your `.env` file. Don't hardcode it. |
| `PROXY_SSL_VERIFY` | No | `true` (default) or `false`. |
{{</table>}}

---

## Secrets

The admin password is required. Configure it as a Docker secret:

```yaml
secrets:
  nim_admin_password:
    file: admin_password.txt
```

Two secrets are optional:

Custom `.htpasswd` credentials file:

```yaml
secrets:
  nim_credential_file:
    file: nim_creds.txt
```

Custom TLS certificates for the ingress proxy:

```yaml
secrets:
  nim_proxy_cert_file:
    file: ./certs/nim_cert.pem
  nim_proxy_cert_key:
    file: ./certs/nim_key.pem
  nim_proxy_ca_cert:
    file: ./certs/nim_ca.pem
```

---

## License modes

NGINX Instance Manager supports two license operating modes, set with `NIM_LICENSE_MODE_OF_OPERATION`. A license isn't required to deploy. You can activate it later in the UI.

Connected mode: NGINX Instance Manager contacts the NGINX licensing service directly over the internet. When the host has outbound HTTPS access, use this mode.

```shell
NIM_LICENSE_MODE_OF_OPERATION=connected
```

Disconnected mode: NGINX Instance Manager validates the license locally, without outbound internet access. Use this mode for air-gapped or restricted environments.

```shell
NIM_LICENSE_MODE_OF_OPERATION=disconnected
```

---

## Stop or remove services

Stop the stack without removing data:

```shell
docker compose -f docker-compose-rootless.yaml stop
```

Stop and remove containers and networks. Named volumes are preserved:

```shell
docker compose -f docker-compose-rootless.yaml down
```

{{< call-out class="warning" title="Warning: Data loss with docker compose down -v" >}} Never run `docker compose down -v`. This destroys every named volume, including the database, certificates, and credentials. {{< /call-out >}}

---

## Backup and restore

### Back up NGINX Instance Manager

```shell
docker exec nim-nim-1 nim-backup
```

This creates a backup at `/data/backup/nim-backup-<date>.tgz` inside the container. To find it on the host:

```shell
docker inspect volume nim_nim-data | jq '.[0].Mountpoint'
sudo ls -l /var/lib/docker/volumes/nim_nim-data/_data/backup
```

### Restore NGINX Instance Manager

1. In `docker-compose-rootless.yaml`, set `NIM_MAINTENANCE: "true"` and restart the stack.
2. Run the restore command:

```shell
   docker exec nim-nim-1 nim-restore /data/backup/nim-backup-<date>.tgz
```

3. Set `NIM_MAINTENANCE: "false"` and restart the stack again.

---

## Storage

{{<table>}}
| Volume | Purpose |
|---|---|
| `nim-data` | All NGINX Instance Manager persistent state: database, secrets, streaming state, credentials. |
| `nim-logs` | NGINX Instance Manager log files. |
| `nim-certs` | TLS certificates for the ingress proxy. |
| `proxy-certs` | Custom CA certificates for outbound proxy connections. |
| `clickhouse-data` | ClickHouse metrics and events database. |
| `nim-nap-compiler` | F5 WAF for NGINX compiler artifacts, mounted at `/opt/nms-nap-compiler`. |
{{</table>}}

To use NFS-backed volumes, add `driver_opts` to the volumes section in `docker-compose-rootless.yaml`:

```yaml
volumes:
  nim-data:
    driver: local
    driver_opts:
      type: "nfs"
      o: "addr=<NFS_IP>,rw"
      device: ":/mnt/nfs_share/data"
  clickhouse-data:
    driver: local
    driver_opts:
      type: "nfs"
      o: "addr=<NFS_IP>,rw"
      device: ":/mnt/nfs_share/clickhouse"
```

---

## Troubleshooting

### Container exits immediately

Get the logs and check the last line before exit:

```shell
docker compose -f docker-compose-rootless.yaml logs nim
docker compose -f docker-compose-rootless.yaml ps -a
```

{{<table>}}
| Symptom | Fix |
|---|---|
| `admin_password.txt: no such file or directory` | Create the file: `echo "<password>" > admin_password.txt` |
| `Error: Clickhouse TTL value must be an integer` | Set `NIM_METRICS_TTL`, `NIM_EVENTS_TTL`, or `NIM_SECURITY_TTL` to a plain integer, for example `"7"`. |
| `Error: NIM_WATCHDOG_TIMEOUT value must be an integer` | Set it to a plain integer in seconds, for example `"60"`. |
| `Error: ENABLE_METRICS value must be either true or false` | Correct the value in your compose file. |
| `Process nms-<X> has stopped. Stopping container.` | See [NMS service crashes](#nms-service-crashes). |
{{</table>}}

### Permission errors

The image sets ownership on all NGINX Instance Manager paths to `nms:nms` at build time. A host volume owned by root overrides this.

Check ownership:

```shell
docker compose -f docker-compose-rootless.yaml exec nim ls -la /data
```

Every entry must be owned by `nms`. If root owns the entries, someone pre-populated the volume as root before first boot.

- Named volumes (recommended): Don't pre-create the directory as root. Docker assigns ownership to the first writer (`nms`).
- Bind mounts: Run `sudo chown -R 101:101 /path/to/nim-data`. UID 101 is the `nms` user.

### ClickHouse not reachable

If startup loops on `Waiting for ClickHouse...`:

```shell
docker compose -f docker-compose-rootless.yaml ps clickhouse
docker compose -f docker-compose-rootless.yaml logs clickhouse
docker compose -f docker-compose-rootless.yaml exec nim nc -zv clickhouse 9000
```

Both services must share the same Docker network.

### Port binding failure

Symptom: `bind() to 0.0.0.0:443 failed (13: Permission denied)`, or a similar bind error.

<!-- SME REVIEW: Vamshi confirmed (Slack thread, PR #317) this is usually a port conflict, resolved
by the customer, not an F5 Support case. The fix below reflects his answer. The symptom text above
is carried over from the build-your-own doc's cap_net_bind_service scenario, a true permission
error (errno 13). A plain port-in-use conflict normally raises "Address already in use" (errno 98)
instead, so this entry may be combining two different failure modes under one symptom line. Confirm
the exact error text customers actually see with the official image before this ships. -->

Check whether another process on your host already uses the port:

```shell
sudo lsof -i :8443
```

If it does, stop that process, or change the port mapping in `docker-compose-rootless.yaml` to an available port. Restart the stack to apply the change.

### Certificate issues

Symptom: a certificate error in your browser, or NGINX fails with TLS errors, on first access.

Verify the certificates exist:

```shell
docker compose -f docker-compose-rootless.yaml exec nim ls -la /data/certs/
```

You should see `manager-server.pem`, `manager-server.key`, and `ca.pem`. Then verify the symlink:

```shell
docker compose -f docker-compose-rootless.yaml exec nim ls -la /etc/nms/certs
```

The expected output shows `/etc/nms/certs -> /data/certs`. If the symlink is missing, gather the container logs and [contact F5 Support](https://www.f5.com/support).

### NMS service crashes

Symptom: `Process nms-<X> has stopped. Stopping container.`

The watchdog monitors `nms-dpm`, `nms-core`, `nms-integrations`, and `nms-ingestion` every 5 seconds. `nms-sm` (Security Monitor) isn't part of the watchdog. It can crash, and the container keeps running.

Identify the crashing service:

```shell
docker compose -f docker-compose-rootless.yaml logs nim --tail=200 | grep -E "nms-(core|dpm|integrations|ingestion|sm)"
```

- If `nms-ingestion` crashes, ClickHouse is likely unavailable. See [ClickHouse not reachable](#clickhouse-not-reachable).
- If `nms-core`, `nms-dpm`, or `nms-integrations` restarts repeatedly, restore from a recent backup. See [Backup and restore](#backup-and-restore).

### License activation failures

Symptom: the license isn't active, even though you set `NIM_LICENSE`.

Verify the license is valid base64:

```shell
echo "$NIM_LICENSE" | base64 -d | head -5
```

Check for errors in the logs:

```shell
docker compose -f docker-compose-rootless.yaml logs nim | grep -i license
```

If activation fails, activate the license manually from the UI. For connected mode, confirm NGINX Console is reachable. See [Proxy misconfiguration](#proxy-misconfiguration).

### Proxy misconfiguration

Symptom: outbound traffic (telemetry, license) fails when `PROXY_ENABLE` is set to `true`.

Confirm that the container applied the proxy settings:

```shell
docker compose -f docker-compose-rootless.yaml exec nim cat /etc/nms/nms.conf | grep -A 6 proxy_config
```

Test proxy reachability from inside the container. A `200` or `400` response means the proxy is reachable. A `000` response means it isn't.

```shell
docker compose -f docker-compose-rootless.yaml exec nim curl -x http://<PROXY_HOST>:<PROXY_PORT> -sS -o /dev/null -w "%{http_code}" https://product.connect.nginx.com/api/nginx-usage/batch
```

If your proxy uses a corporate CA, mount the PEM certificates into `/usr/local/share/ca-certificates` with the `proxy-certs` volume. For testing only, set `PROXY_SSL_VERIFY=false`.

### Maintenance mode

Use maintenance mode to back up, restore, or debug a container that won't start. In maintenance mode, the container initializes storage but doesn't start NGINX Instance Manager services or NGINX.

To turn it on, set `NIM_MAINTENANCE: "true"` in `docker-compose-rootless.yaml`, then restart:

```shell
docker compose -f docker-compose-rootless.yaml up -d
```

Get shell access:

```shell
docker compose -f docker-compose-rootless.yaml exec nim bash
```

To turn it off, remove `NIM_MAINTENANCE` or set it to `false`, then restart:

```shell
docker compose -f docker-compose-rootless.yaml restart nim
```

### Gather support data

```shell
docker compose -f docker-compose-rootless.yaml logs --since 24h > nim-logs-$(date +%Y-%m-%d).txt
docker exec nim-nim-1 nim-backup
```

---

## See also

- [Deploy using Docker Compose]({{< ref "nim/deploy/docker/deploy-nginx-instance-manager-docker-compose.md" >}}): Standard, non-rootless Docker Compose deployment.