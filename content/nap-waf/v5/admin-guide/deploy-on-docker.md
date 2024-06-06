---
description: This guide explains how to deploy NGINX App Protect WAF v5 release using
  Docker Compose.
docs: DOCS-1365
doctypes:
- task
title: Deploying NGINX App Protect WAF on Docker
toc: true
weight: 300
---

## Prerequisites

- Active NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/) (purchased or trial).
- Docker (with Docker Compose) is [installed and running](https://docs.docker.com/engine/install/).

## Build the NGINX Image

Follow the instructions below to build a Docker image containing the NGINX and the NGINX App Protect module.

### Download Certificates

{{< include "nap-waf/download-certificates.md" >}}

Proceed, by creating a `Dockerfile` using one of the examples provided below.

### Dockerfile Based on the Official NGINX Image

{{< include "nap-waf/build-from-official-nginx-image.md" >}}

### NGINX Open Source Dockerfile

{{< include "nap-waf/build-nginx-image-oss.md" >}}

You are ready to [Build the image](#build-image)

### NGINX Plus Dockerfile

{{< include "nap-waf/build-nginx-image-plus.md" >}}

### Build image

{{< include "nap-waf/build-nginx-image-cmd.md" >}}

## NGINX Configuration

In your nginx configuration:

1. Load the NGINX App Protect WAF v5 module at the main context:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

2. Configure the Enforcer address at the `http` context:

    ```nginx
    app_protect_enforcer_address waf-enforcer:50000;
    ```

3. Enable NGINX App Protect WAF on an `http/server/location` context (make sure you only enable NGINX App Protect WAF with `proxy_pass`/`grpc_pass` locations):

    ```nginx
    app_protect_enable on;
    ```

In this guide, we've created the following files under `/conf/` directory:

{{<tabs name="nap5_install_conf_files_hostname">}}
{{%tab name="nginx.conf"%}}

`/conf/nginx.conf`

{{< include "nap-waf/nginx-conf-hostname.md" >}}

{{%/tab%}}
{{%tab name="default.conf"%}}

`/conf/default.conf`

{{< include "nap-waf/default-conf-hostname.md" >}}

{{%/tab%}}
{{</tabs>}}

## WAF Services Configuration

### Set up Docker for F5 Container Registry

{{< include "nap-waf/setup-docker-registry.md" >}}

### Docker Compose File

Create a `docker-compose.yml` with the following configuration:

```yaml
version: "3.9"

services:
  nginx:
    container_name: nginx
    image: nginx-app-protect-5
    volumes:
      - app_protect_bd_config:/opt/app_protect/bd_config
      - app_protect_config:/opt/app_protect/config
      - app_protect_etc_config:/etc/app_protect/conf
      - /conf/nginx.conf:/etc/nginx/nginx.conf # based on the provided example
      - /conf/default.conf:/etc/nginx/conf.d/default.conf # based on the provided example
    networks:
      - waf_network
    ports:
      - "80:80"

  waf-enforcer:
    container_name: waf-enforcer
    image: "private-registry.nginx.com/nap/waf-enforcer:<version-tag>"
    environment:
      - ENFORCER_PORT=50000
    volumes:
      - app_protect_bd_config:/opt/app_protect/bd_config
    networks:
      - waf_network
    restart: always

  waf-config-mgr:
    container_name: waf-config-mgr
    image: "private-registry.nginx.com/nap/waf-config-mgr:<version-tag>"
    volumes:
      - app_protect_bd_config:/opt/app_protect/bd_config
      - app_protect_config:/opt/app_protect/config
      - app_protect_etc_config:/etc/app_protect/conf
    restart: always
    network_mode: none
    depends_on:
      waf-enforcer:
        condition: service_started

networks:
  waf_network:
    driver: bridge

volumes:
  app_protect_bd_config:
  app_protect_config:
  app_protect_etc_config:
```

## Start Deployment

1. To start the NGINX and WAF services, navigate to the directory that contains the `docker-compose.yml` file and run:

    ```shell
    sudo docker compose up -d
    ```

2. To verify the enforcement functionality, ensure the following request is rejected:

    ```shell
    curl "localhost/<script>"
    ```

3. (Optionally) To reload the NGINX, run:

    ```shell
    sudo docker exec nginx  nginx -s reload
    ```

## Using Policy and Logging Profile Bundles

{{< include "nap-waf/bundles-volume-mount.md" >}}

## Troubleshooting

- **Container Failures**: If a container fails, restarts, or stops running, examine its logs for any error messages by executing `sudo docker logs [container_name]` for error messages. The default names for the containers are:
  - `nginx`.
  - `waf-enforcer`
  - `waf-config-mgr`
- **Permissions Issues**: By default, the containers `waf-config-mgr` and `waf-enforcer` operate with the user and group IDs set to 101:101. Ensure that the bundle files are accessible to these IDs.

Sometimes, simply restarting the services can resolve transient issues. Use `sudo docker compose down -v` followed by `sudo docker compose up -d` to restart all services.

If you encounter any other issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v5/troubleshooting-guide/troubleshooting#nginx-app-protect-5" >}}).

## Conclusion

This guide provides the foundational steps for deploying NGINX App Protect WAF v5 using Docker Compose. You may need to adjust the deployment to fit your specific requirements.

For more detailed configuration options and advanced deployment strategies, refer to the [NGINX App Protect WAF v5 configuration guide]({{< relref "/nap-waf/v5/configuration-guide/configuration.md" >}}).
