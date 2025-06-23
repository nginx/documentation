---
description: ''
title: Deploy using Docker Compose
toc: true
weight: 100
nd-docs: DOCS-1653
type:
- task
---

## Overview

This guide shows you how to run NGINX Instance Manager using [Docker Compose](https://docs.docker.com/compose/).

You can deploy it in two ways:

- **Standard mode** includes full metrics and dashboards. This setup runs ClickHouse in a separate container.
- **Lightweight mode** (new in 2.20.0) skips ClickHouse entirely. It’s ideal if you don’t need monitoring data or want a simpler setup. This reduces system requirements and avoids the work of managing a metrics database. You can add ClickHouse later if your needs change.

Both modes use a pre-built Docker image that includes NGINX Instance Manager, Security Monitoring, and the latest NGINX App Protect compilers.

If you use the standard setup, ClickHouse runs in its own container. This helps with fault tolerance and keeps data separate. You can also use persistent storage.

---

## What you need

Before you begin, make sure you have the following:

- [Docker](https://docs.docker.com/get-docker/) installed on your system.
- A JSON Web Token (JWT) from your [MyF5 subscriptions page](https://my.f5.com/manage/s/subscriptions). This is the same token used for NGINX Plus.
- The right `docker-compose.yaml` file for your setup:
  - For **standard mode** (with metrics and dashboards):
    {{< icon "download">}} {{<link "/scripts/docker-compose/docker-compose.yaml" "Download the standard docker-compose.yaml file">}}
  - For **lightweight mode** (no ClickHouse, no metrics):
    {{< icon "download">}} {{<link "/scripts/docker-compose/docker-compose-lightweight.yaml" "Download the lightweight docker-compose.yaml file">}}

{{< call-out "note" >}} If you're not sure which one to use, start with lightweight mode. You can always switch later by changing the Compose file and setting `ENABLE_METRICS: "true"`.{{< /call-out >}}

---

## Minimum requirements

Your system needs enough resources to run NGINX Instance Manager based on the mode you choose:

| Deployment mode | CPU cores | Memory | ClickHouse required |
|-----------------|-----------|--------|---------------------|
| Standard        | 4         | 4 GB   | Yes                 |
| Lightweight     | (Lower)   | (Lower)| No                  |

Standard mode requires a minimum of 4 CPU cores and 4 GB of memory. This setup includes ClickHouse, which handles metrics and dashboards. Depending on your NGINX footprint, you may need more resources, especially for environments with many configuration files or NGINX App Protect enabled.

Lightweight mode removes ClickHouse, which lowers memory and CPU usage. While there’s no official minimum, users with basic instance management needs may see success with fewer resources. Test in your environment before committing to a smaller footprint.

{{< call-out "note" >}} If you're not sure which mode to use, start with lightweight mode. It's easier to set up, and you can switch to standard mode later by reintroducing ClickHouse. {{< /call-out >}}

## Before you start

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

### Log in to the NGINX container registry

Both standard and lightweight deployments use a private image hosted at `private-registry.nginx.com`. You need to log in before running Docker Compose.

To set up Docker to communicate with the NGINX container registry:

{{< include "/nim/docker/docker-registry-login.md" >}}

### Deploy NGINX Instance Manager

If you're using a forward proxy, update the Compose file **before** deploying. Follow the steps in the [Forward Proxy Configuration Guide]({{< ref "nim/system-configuration/configure-forward-proxy.md" >}}).

Go to the directory where you downloaded your `docker-compose.yaml` file, and run the following commands:

```shell
docker login private-registry.nginx.com --username=<JWT_CONTENTS> --password=none
echo "admin" > admin_password.txt
docker compose up -d
```

The deployment output will vary depending on the mode:

#### Standard mode (with metrics)

```text
[+] Running 6/6
 ✔ Network nim_clickhouse        Created
 ✔ Network nim_external_network  Created
 ✔ Network nim_default           Created
 ✔ Container nim-precheck-1      Started
 ✔ Container nim-clickhouse-1    Healthy
 ✔ Container nim-nim-1           Started
 ```

#### Lightweight mode (no ClickHouse)

```text
[+] Running 3/3
 ✔ Network nim_default           Created
 ✔ Network nim_external_network  Created
 ✔ Container nim-nim-1           Started
```

In lightweight mode, only the NGINX Instance Manager service runs. ClickHouse and related containers are removed by design.

### Supported environment variables

You can control Instance Manager behavior by setting environment variables in the `docker-compose.yaml` file. Here’s a summary of commonly used variables:

{{< include "nim/docker/docker-compose-env-vars.md" >}}

### Stop or remove services

To stop NGINX Instance Manager, go to the directory where you downloaded your `docker-compose.yaml` file.

If you used `docker compose up -d` to start services:

- Run `docker compose stop` to pause the containers
- Run `docker compose down` to remove them completely

```shell
docker compose down
```

The shutdown output will vary depending on the mode:

#### Standard mode (with metrics)

```text
[+] Running 6/6
 ✔ Container nim-nim-1           Removed
 ✔ Container nim-clickhouse-1    Removed
 ✔ Container nim-precheck-1      Removed
 ✔ Network nim_default           Removed
 ✔ Network nim_external_network  Removed
 ✔ Network nim_clickhouse        Removed
```

#### Lightweight mode (no ClickHouse)

```text
[+] Running 3/3
 ✔ Container nim-nim-1           Removed
 ✔ Network nim_default           Removed
 ✔ Network nim_external_network  Removed
```

In lightweight mode, only the core service and networks are removed. ClickHouse and precheck containers aren’t present.

---

## Secrets

You can define secrets in the `docker-compose.yaml` file to set the admin password, optional access credentials, and TLS certificates.

### Required

Set the admin password:

```yaml
secrets:
  nim_admin_password:
    file: admin_password.txt
```

### Optional

Use a custom `.htpasswd` file to control access to the user interface:

```yaml
secrets:
  nim_credential_file:
    file: nim_creds.txt
```

Use your own TLS certificate, key, and CA file for the ingress proxy:

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

## Backup

You can create a backup of NGINX Instance Manager at any time using the built-in `nim-backup` command. This works for both standard and lightweight deployments.

Run the following command from your Docker host:

```shell
docker exec nim-nim-1 nim-backup
```

If successful, you’ll see a message like:

```text
Backup has been successfully created: /data/backup/nim-backup-<date>.tgz
```

To locate the backup file:

- **If using named volumes**

  Inspect the volume to find its mount point:

  ```shell
  docker inspect volume nim_nim-data | jq '.[0].Mountpoint'
  ```

  Then list the backup directory:

  ```shell
  sudo ls -l /var/lib/docker/volumes/nim_nim-data/_data/backup
  ```

  Example output:

  ```text
  -rw-r--r-- 1 root root 5786953 Sep 27 02:03 nim-backup-2024-06-11.tgz
  ```

- **If using NFS**

  Check the mount path directly, such as:

  ```shell
  ls -l /mnt/nfs_share/data/backup
  ```


---

## Restore

To restore a backup, follow these steps:

1. Enable maintenance mode:

    In your `docker-compose.yaml` file, set the following:

    ```yaml
    environment:
      NIM_MAINTENANCE: "true"
    ```

2. Run the restore command:

    ```shell
    docker exec nim-nim-1 nim-restore /data/backup/nim-backup-<date>.tgz
    ```

3. After the restore process finishes, disable maintenance mode.

    In `docker-compose.yaml`, change the value back:

    ```yaml
    environment:
      NIM_MAINTENANCE: "false"
    ```

4. Restart the container:

    ```shell
    docker compose up -d
    ```

---

## Storage

NGINX Instance Manager uses named Docker volumes by default to persist data. You can also configure NFS or other storage backends using `driver_opts`.

### Default volumes

The standard `docker-compose.yaml` file defines these named volumes:

- `nim-data`: stores configuration and state for Instance Manager
- `clickhouse-data`: used only in standard mode to persist metrics

In lightweight mode, `clickhouse-data` is not needed and should be removed from the Compose file.

### Example: use NFS for storage

Before you run `docker compose up -d`, make sure your NFS volumes are mounted:

```shell
sudo mount -t nfs <<nfs-ip>>:/mnt/nfs_share/data /mnt/nfs_share/data
sudo mount -t nfs <<nfs-ip>>:/mnt/nfs_share/clickhouse /mnt/nfs_share/clickhouse
```

Update the volumes section in your Compose file:

```yaml
volumes:
  nim-data:
    driver: local
    driver_opts:
      type: "nfs"
      o: "addr=<<nfs-ip>>,rw"
      device: ":/mnt/nfs_share/data"

  clickhouse-data:
    driver: local
    driver_opts:
      type: "nfs"
      o: "addr=<<nfs-ip>>,rw"
      device: ":/mnt/nfs_share/clickhouse"
```

If you’re using lightweight mode, omit the `clickhouse-data` section entirely.

---

## Gather support data

If you [contact support]({{< ref "nim/support/contact-support.md" >}}), it's helpful to include logs and a current backup. These commands capture useful diagnostic data.

### Get recent logs

Save logs from the past 24 hours:

```shell
docker compose logs --since 24h > my-logs-$(date +%Y-%m-%d).txt
```

### Create a fresh backup

Run the backup command to capture the current state:

```shell
docker exec nim-nim-1 nim-backup
```

This creates a `.tgz` file inside the container under `/data/backup/`, which you can extract as described in the [Backup](#backup) section.
