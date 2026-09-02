---
description: Deploy F5 NGINX Instance Manager in a rootless Docker environment using Docker Compose, with runtime configuration injection using environment variables.
title: Deploy rootless using Docker Compose
toc: true
weight: 150
f5-docs: DOCS-NIM-ROOTLESS
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-summary: >
  Deploy F5 NGINX Instance Manager in a secure, rootless Docker Compose environment where all
  processes run as a non-root user. Change NGINX Instance Manager configuration at runtime using environment
  variables—no image rebuild required.
---

## Overview

This guide shows you how to deploy F5 NGINX Instance Manager using Docker Compose in a **rootless** configuration. In this setup, all container processes run as a non-root user (`nms`), following the principle of least privilege for production environments.

A key capability of this deployment is **runtime configuration injection**: you can change NGINX Instance Manager settings by editing environment variable files and restarting the stack. You don't need to rebuild the Docker image.

Key characteristics of this deployment:

- **Rootless by design** — All processes run as `nms` (non-root), reducing the attack surface and satisfying security hardening requirements.
- **Runtime configuration** — Change NGINX Instance Manager settings by updating `.env` and `docker-compose.yaml`. You don't need to rebuild the image.
- **Production-hardened** — Startup scripts are idempotent and avoid fragile patterns such as recursive permission changes.
- **Flexible licensing** — Supports both connected and disconnected license modes, switchable at runtime.

---

## What you need

Before you begin, make sure you have the following:

- [Docker Engine](https://docs.docker.com/get-docker/) 20.10 or later installed on a Linux host (amd64 or arm64).
- Docker Compose plugin v2 or later.
- A valid NGINX Instance Manager license file, base64-encoded.
- An NGINX certificate and private key, required to download NGINX Instance Manager packages during image build.
- Basic familiarity with Docker Compose and YAML syntax.

---

## Before you start

Clone the deployment repository to your host machine:

```shell
git clone https://github.com/nginx/nginx-demos.git
cd nginx-demos/nginx-instance-manager/docker-deployment
```

---

## Build the NGINX Instance Manager image

Run the build script, supplying your NGINX certificate, key, and a name for the resulting image:

```shell
./build.sh -C <NGINX_CERTIFICATE> -K <NGINX_CERTIFICATE_KEY> -t <IMAGE_NAME>
```

Replace the placeholders:

- `<NGINX_CERTIFICATE>` — Path to your NGINX TLS certificate file.
- `<NGINX_CERTIFICATE_KEY>` — Path to your NGINX TLS private key file.
- `<IMAGE_NAME>` — Your preferred Docker image tag (for example, `nim:latest`).

The build script downloads NGINX Instance Manager packages from the NGINX repository using your certificate and key, and produces a self-contained rootless image.

---

## Configure environment variables

Edit `docker-compose/.env` and set the following values:

```shell
NIM_IMAGE=<IMAGE_NAME>
NIM_LICENSE=<BASE64_ENCODED_LICENSE_FILE>
NIM_USERNAME=<NIM_ADMIN_USER>
NIM_PASSWORD=<NIM_ADMIN_PASSWORD>
NIM_CLICKHOUSE_ADDRESSPORT=docker-compose-clickhouse-1:9000
NIM_CLICKHOUSE_USERNAME=<USERNAME>
NIM_CLICKHOUSE_PASSWORD=<PASSWORD>
NIM_LICENSE_MODE_OF_OPERATION=connected
```

Replace `<IMAGE_NAME>` with the tag used in the build step, and `<BASE64_ENCODED_LICENSE_FILE>` with your base64-encoded NGINX Instance Manager license. Set `NIM_LICENSE_MODE_OF_OPERATION` to `connected` or `disconnected` depending on your environment (see [License modes](#license-modes) below).

{{< call-out class="note" >}} Change `NIM_USERNAME` and `NIM_PASSWORD` to values appropriate for your environment before deploying to production. {{< /call-out >}}

---

## Verify docker-compose.yaml environment mappings

Open `docker-compose.yaml` and confirm that the `nim` service passes all required variables into the container:

```yaml
environment:
  - NIM_LICENSE=${NIM_LICENSE}
  - NIM_USERNAME=${NIM_USERNAME}
  - NIM_PASSWORD=${NIM_PASSWORD}
  - NIM_CLICKHOUSE_ADDRESSPORT=${NIM_CLICKHOUSE_ADDRESSPORT}
  - NIM_CLICKHOUSE_USERNAME=${NIM_CLICKHOUSE_USERNAME}
  - NIM_CLICKHOUSE_PASSWORD=${NIM_CLICKHOUSE_PASSWORD}
  - NIM_LICENSE_MODE_OF_OPERATION=${NIM_LICENSE_MODE_OF_OPERATION}
```

If you add new configuration variables later, add a corresponding line here to make the value available inside the container.

---

## Start the stack

Start NGINX Instance Manager and its dependencies (including ClickHouse) with:

```shell
docker compose -f docker-compose.yaml up -d
```

---

## Access the NGINX Instance Manager web interface

When the containers are running, open a browser and go to:

```text
https://localhost/
```

Accept the self-signed TLS certificate warning if prompted. Log in using the `NIM_USERNAME` and `NIM_PASSWORD` values you set in `.env`.

---

## How runtime configuration injection works

When the NGINX Instance Manager container starts, `startNIM.sh` reads the environment variables that Docker Compose passes in. It writes their values into the NGINX Instance Manager configuration files using `yq`, a YAML processor. The two configuration files are:

- `/etc/nms/nms.conf`
- `/etc/nms/nms-sm-conf.yaml`

This means NGINX Instance Manager applies fresh configuration on every container start. You change a setting by updating the variable in `.env` and restarting the stack. You don't need to rebuild the image.

The script exposes two helper functions:

- `set_nms_conf` — writes a value to a key path in `nms.conf`.
- `set_nms_sm` — writes a value to a key path in `nms-sm-conf.yaml`.

---

## Add or change NGINX Instance Manager configuration

To inject a new or changed configuration value, complete these steps:

1. **Add the variable to `.env`**

   ```shell
   MY_NEW_SETTING=myvalue
   ```

2. **Pass the variable into the container in `docker-compose.yaml`**

   ```yaml
   environment:
     - MY_NEW_SETTING=${MY_NEW_SETTING}
   ```

3. **Map the variable to a config key in `startNIM.sh`**

   ```shell
   # For nms.conf:
   set_nms_conf '.path.to.config.key'  MY_NEW_SETTING

   # For nms-sm-conf.yaml:
   set_nms_sm '.path.to.config.key'  MY_NEW_SETTING
   ```

Then restart the stack to apply the change:

```shell
docker compose -f docker-compose.yaml up -d
```

You don't need to rebuild the image.

---

## License modes {#license-modes}

NGINX Instance Manager supports two license operating modes. The correct choice depends on whether your host has outbound internet access to the NGINX licensing service.

### Connected mode

NGINX Instance Manager contacts the NGINX licensing service directly over the internet. Use this mode when the host has reliable outbound HTTPS access.

Set in `.env`:

```shell
NIM_LICENSE_MODE_OF_OPERATION=connected
```

### Disconnected mode

NGINX Instance Manager operates without outbound internet access and validates the license locally. Use this mode for air-gapped or restricted environments.

Set in `.env`:

```shell
NIM_LICENSE_MODE_OF_OPERATION=disconnected
```

### Switch modes at runtime

To change the license mode without rebuilding the image:

1. Update `NIM_LICENSE_MODE_OF_OPERATION` in `docker-compose/.env`.
2. Confirm the variable is listed under `environment:` in the `nim` service in `docker-compose.yaml`.
3. Confirm the mapping exists in `startNIM.sh`:

   ```shell
   set_nms_conf '.integrations.license.mode_of_operation'  NIM_LICENSE_MODE_OF_OPERATION
   ```

4. Restart the stack:

   ```shell
   docker compose -f docker-compose.yaml up -d
   ```

---

## Stop or remove services

To stop the running stack:

```shell
docker compose -f docker-compose.yaml stop
```

To stop and remove containers and networks:

```shell
docker compose -f docker-compose.yaml down
```

---

## Troubleshooting

### Permission errors on startup

All processes run as the `nms` non-root user. If you see permission errors, check that any host-mounted volumes are readable and writable by the `nms` user. Avoid using recursive `chown` or `chmod` commands, because these can interfere with rootless operation.

### Configuration changes not taking effect

If an updated variable has no effect after a restart, verify all three steps were completed:

- The variable is defined in `.env` with the correct value.
- The variable is listed under `environment:` in the `nim` service in `docker-compose.yaml`.
- A `set_nms_conf` or `set_nms_sm` call for that variable exists in `startNIM.sh`.
- The stack was fully restarted (`docker compose up -d` re-creates containers on config change).

### View container logs

To inspect startup output and verify configuration injection ran successfully:

```shell
docker compose -f docker-compose.yaml logs nim
docker compose -f docker-compose.yaml logs clickhouse
```

### Check running container state

```shell
docker compose -f docker-compose.yaml ps
```

---

## See also

- [Deploy using Docker Compose]({{< ref "nim/deploy/docker/deploy-nginx-instance-manager-docker-compose.md" >}}) — Standard (non-rootless) Docker Compose deployment.
- [NGINX Instance Manager Documentation](https://docs.nginx.com/nginx-instance-manager/)
- [yq YAML Processor](https://mikefarah.gitbook.io/yq/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
