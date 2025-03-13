---
description: null
title: Deploy using Docker Compose
toc: true
weight: 100
docs: DOCS-1653
type: []
---

## Overview

This guide will show you how to deploy and use F5 NGINX Instance Manager in Docker using [Docker Compose](https://docs.docker.com/compose/). 

This NGINX Instance Manager docker compose deployment is a single Docker image containing NGINX Instance Manager, Security Monitoring, and the latest App Protect compilers, which is orchestrated using a Docker Compose docker-compose.yaml definition. 

The ClickHouse database is deployed in a separate container to improve resilience and make this a fault tolerant solution. You can also configure persistent storage

---

## What you need

- A working version of [Docker](https://docs.docker.com/get-docker/)
- Your NGINX Instance Manager subscription's JSON Web Token from [MyF5](https://my.f5.com/manage/s/subscriptions) You can use the same JSON Web Token as NGINX Plus in your MyF5 portal.
- This pre-configured `docker-compose.yaml` file:
  - {{<fa "download">}} {{<link "/scripts/docker-compose/docker-compose.yaml" "Download docker-compose.yaml file">}}.
  
---

## Minimum requirements

Deploying NGINX Instance Manager with docker requires a minimum of 4 CPU cores and 4 GB of memory for basic use cases. However, every environment is unique, primarily due to variations in the NGINX configurations being managed. For instance, managing NGINX instances with hundreds of configuration files or those with WAF (NGINX App Protect) enabled can significantly increase resource demands.

If your use case is limited to usage tracking without active management or agent communication, the minimum requirements should suffice. For more complex deployments, we recommend reviewing the technical specifications guide to ensure the resources allocated are sufficient to handle an increased workload, particularly for the ClickHouse database, which may need to manage a higher volume of reads and writes.

## Before you start

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

### Set up Docker for NGINX container registry

To set up Docker to communicate with the NGINX container registry located at `private-registry.nginx.com`, follow these steps:

{{< include "/nim/docker/docker-registry-login.md" >}}

### Compose deployment

{{<call-out "note" "Configuring a forward proxy:" "" >}}

If you are configuring a **forward proxy**, follow the steps in the [Forward Proxy Configuration Guide]({{< relref "nim/system-configuration/configure-forward-proxy.md" >}}) to modify `docker-compose.yaml` with the correct proxy settings **before** deploying NGINX Instance Manager.

{{</call-out>}}

Go to the directory where you downloaded `docker-compose.yaml`. Use the following commands to log in to `private-registry.nginx.com` and deploy NGINX Instance Manager.

```shell
docker login private-registry.nginx.com --username=<JWT_CONTENTS> --password=none
echo "admin" > admin_password.txt
docker compose up -d
```

If the deployment succeeds, you’ll see output similar to this:

```text
[+] Running 6/6
 ✔ Network nim_clickhouse        Created   0.1s
 ✔ Network nim_external_network  Created   0.2s
 ✔ Network nim_default           Created   0.2s
 ✔ Container nim-precheck-1      Started   0.8s
 ✔ Container nim-clickhouse-1    Healthy   6.7s
 ✔ Container nim-nim-1           Started   7.4s
 ```

### Supported environment variables

{{< include "nim/docker/docker-compose-env-vars.md" >}}

<br>

{{<call-out "tip" "See also:" "" >}} 
For details on configuring a forward proxy, see the [Forward Proxy Configuration Guide]({{< relref "nim/system-configuration/configure-forward-proxy.md" >}}).
{{</call-out>}}

### Compose stop or tear down

Navigate to the directory where you downloaded `docker-compose.yaml`. If you started NIM with `docker compose up -d`, stop NIM services once you've finished with them by running `docker compose stop`. You can bring everything down, removing the containers entirely, with the `docker compose down` command.

```shell
docker compose down
```
```
[+] Running 6/6
 ✔ Container nim-nim-1           Removed   30.6s
 ✔ Container nim-clickhouse-1    Removed    1.4s
 ✔ Container nim-precheck-1      Removed    0.0s
 ✔ Network nim_default           Removed    0.9s
 ✔ Network nim_external_network  Removed    0.4s
 ✔ Network nim_clickhouse        Removed    0.6s
```

---

## Secrets

In the same `docker-compose.yaml` file, you can modify the following credentials:

Set the admin password (required)

```yaml
secrets:
  nim_admin_password:
    file: admin_password.txt
```

Pass a custom `.htpasswd` file (Optional)

```yaml
  nim_credential_file:
    file: nim_creds.txt
```

Optionally, you can also set the external SSL certificate, key, and CA files, in PEM format for the NGINX Instance Manager Ingress proxy.

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

Once you've set up your Docker containers, use the following command to back them up:

```shell
~$ docker exec nim-nim-1 nim-backup
...
Backup has been successfully created: /data/backup/nim-backup-<date>.tgz
```

If your system uses named volumes, inspect the `Mountpoint`. Alternatively, if you're using a shared NFS volume, then collect the data directly from the mount point.

```shell
~/compose$ docker inspect volume nim_nim-data | jq '.[0].Mountpoint'
"/var/lib/docker/volumes/nim_nim-data/_data"
ubuntu@ip-<address>:~/compose$ sudo ls -l /var/lib/docker/volumes/nim_nim-data/_data/backup
-rw-r--r-- 1 root root 5786953 Sep 27 02:03 nim-backup-<date>.tgz
```

---

## Restore 

Before you can restore a backup, set your containers to maintenance mode in the same `docker-compose.yaml` file:

```yaml
    environment:
      NIM_MAINTENANCE: "true"
```

```shell
~$ docker exec nim-nim-1 nim-restore /data/backup/nim-backup-<date>.tgz
...
NGINX Instance Manager has been restored.
```

Once the process is complete set `NIM_MAINTENANCE` to `false` and then run `docker-compose up -d`.

---

## Storage

By default, the storage uses named volumes. Alternatively, you can use optional `driver_opts` settings to support other storage formats such as NFS.
For all storage volumes, make sure to mount them, before running `docker compose up -d`. For a mounted NFS volume, you might use the following commands:

```shell
~$ sudo mount -t nfs <<nfs-ip>>:/mnt/nfs_share/clickhouse /mnt/nfs_share/clickhouse
~$ sudo mount -t nfs <<nfs-ip>>:/mnt/nfs_share/data /mnt/nfs_share/data
```

```yaml
volumes:
  # By default docker compose will create a named volume 
  # Refer to https://docs.docker.com/reference/compose-file/volumes/ for additional storage options such as NFS 
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

---

## Support Data 

In case of problems, it's a good practice to:

- Collect logs `docker-compose logs --since 24h > my-logs-$(date +%Y-%m-%d).txt`
- Collect backup information `docker exec nim-nim-1 nim-backup`
