---
title: Deploy NGINX App Protect WAF with Docker
weight: 500
toc: true
type: how-to
product: NAP-WAF
docs: DOCS-1365
---

## Prerequisites

- Active F5 NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/) (purchased or trial).
- Docker (with Docker Compose) is [installed and running](https://docs.docker.com/engine/install/).

## Build the NGINX Image

Follow the instructions below to build a Docker image containing the NGINX and the NGINX App Protect module.

### Download Certificates

{{< include "nap-waf/download-certificates.md" >}}

Proceed, by creating a `Dockerfile` using one of the examples provided below.

### Dockerfile Based on the Official NGINX Image

{{< include "nap-waf/build-from-official-nginx-image.md" >}}

### NGINX Open Source Dockerfile

Choose the appropriate `Dockerfile` example based on your Operating System (OS).

{{<tabs name="nap5_nginx_OSS_dockerfiles">}}
{{%tab name="Alpine Linux"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-alpine.md" >}}

{{%/tab%}}
{{%tab name="Amazon Linux 2"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-amazon.md" >}}

{{%/tab%}}
{{%tab name="Amazon Linux 2023"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM amazonlinux:2023

# Install NGINX OSS and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install wget ca-certificates shadow-utils yum-utils \
    && echo "[nginx-mainline]" > /etc/yum.repos.d/nginx.repo \
    && echo "name=nginx mainline repo" >> /etc/yum.repos.d/nginx.repo \
    && echo "baseurl=http://nginx.org/packages/mainline/amzn/2023/\$basearch/" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/nginx.repo \
    && echo "gpgkey=https://nginx.org/keys/nginx_signing.key" >> /etc/yum.repos.d/nginx.repo \
    && echo "module_hotfixes=true" >> /etc/yum.repos.d/nginx.repo \
    && echo "priority=9" >> /etc/yum.repos.d/nginx.repo \
    && echo "[app-protect-x-oss]" > /etc/yum.repos.d/app-protect-oss.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-oss/amzn/2023/\$basearch/" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-oss.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-oss.repo \
    && yum -y install app-protect-module-oss \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{%/tab%}}
{{%tab name="CentOS"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-centos.md" >}}

{{%/tab%}}
{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-debian.md" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-oracle.md" >}}

{{%/tab%}}
{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

You are ready to [Build the image](#build-image-main)

### NGINX Plus Dockerfile

{{<tabs name="nap5_nginx_plus_dockerfiles">}}
{{%tab name="Alpine Linux"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-alpine.md" >}}

{{%/tab%}}
{{%tab name="Amazon Linux 2"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-amazon.md" >}}

{{%/tab%}}
{{%tab name="Amazon Linux 2023"%}}

```dockerfile
# syntax=docker/dockerfile:1

# Base image
FROM amazonlinux:2023

# Install NGINX Plus and NGINX App Protect WAF v5 module
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install wget ca-certificates shadow-utils \
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/plus-amazonlinux2023.repo \
    && echo "[app-protect-x-plus]" > /etc/yum.repos.d/app-protect-plus.repo \
    && echo "name=nginx-app-protect repo" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "baseurl=https://pkgs.nginx.com/app-protect-x-plus/amzn/2023/\$basearch/" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "sslclientcert=/etc/ssl/nginx/nginx-repo.crt" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "sslclientkey=/etc/ssl/nginx/nginx-repo.key" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/app-protect-plus.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/app-protect-plus.repo \
    && yum -y install app-protect-module-plus \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port
EXPOSE 80

# Define stop signal
STOPSIGNAL SIGQUIT

# Set default command
CMD ["nginx", "-g", "daemon off;"]
```

{{%/tab%}}
{{%tab name="CentOS"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-centos.md" >}}

{{%/tab%}}
{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-debian.md" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-oracle.md" >}}

{{%/tab%}}
{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

### Build Image {#build-image-main}

{{< include "nap-waf/build-nginx-image-cmd.md" >}}

## NGINX Configuration

In your nginx configuration:

1. Load the NGINX App Protect WAF v5 module at the main context:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

2. Configure the Enforcer address at the `http` context:

    ```nginx
    app_protect_enforcer_address 127.0.0.1:50000;
    ```

3. Enable NGINX App Protect WAF on an `http/server/location` context (make sure you only enable NGINX App Protect WAF with `proxy_pass`/`grpc_pass` locations):

    ```nginx
    app_protect_enable on;
    ```

In this guide, we have created the following files under `/conf/` directory:

{{<tabs name="nap5_install_conf_files_hostname">}}
{{%tab name="nginx.conf"%}}

`/conf/nginx.conf`

```nginx
user  nginx;
worker_processes  auto;

# NGINX App Protect WAF
load_module modules/ngx_http_app_protect_module.so;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    # NGINX App Protect WAF
    app_protect_enforcer_address waf-enforcer:50000;

    include /etc/nginx/conf.d/*.conf;
}

{{%/tab%}}
{{%tab name="default.conf"%}}

`/conf/default.conf`

{{< include "nap-waf/default-conf-hostname.md" >}}

{{%/tab%}}
{{</tabs>}}

## WAF Services Configuration

### Set up Docker for F5 Container Registry

{{< include "nap-waf/setup-docker-registry.md" >}}

### List all tags

For a complete tag list for NGINX App Protect WAF enforcer and NGINX App Protect WAF configuration manager, use the following commands:

```shell
curl https://private-registry.nginx.com/v2/nap/waf-enforcer/tags/list --key <nginx-repo.key> --cert <nginx-repo.crt> | jq
```

```shell
curl https://private-registry.nginx.com/v2/nap/waf-config-mgr/tags/list --key <nginx-repo.key> --cert <nginx-repo.crt> | jq
```


### Docker Compose File

Create a `docker-compose.yml` with the following configuration: Replace `<version-tag>` with the actual release version you are deploying.

```yaml
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


### Docker Compose File with mTLS

To secure traffic between NGINX and App Protect Enforcer using mTLS, create a `docker-compose.yml` with the following configuration:

{{< note >}} Refer to the [Configuration Guide]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#secure-traffic-between-nginx-and-app-protect-enforcer-using-mtls" >}}) to generate certificates and modify the `nginx.conf` for mTLS.
{{< /note >}}

```yaml
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
	      - /path/to/your/certs:/etc/ssl/certs  # mount certificates directory
	    networks:
	      - waf_network
	    ports:
	      - "80:80"

	  waf-enforcer:
	    container_name: waf-enforcer
	    image: "private-registry.nginx.com/nap/waf-enforcer:<version-tag>"
	    environment:
	      - ENFORCER_PORT=4431
	      - ENFORCER_SERVER_CERT=/etc/ssl/certs/app_protect_server.crt
	      - ENFORCER_SERVER_KEY=/etc/ssl/certs/app_protect_server.key
	      - ENFORCER_CA_FILE=/etc/ssl/certs/app_protect_client_ca.crt
	    volumes:
	      - app_protect_bd_config:/opt/app_protect/bd_config
	      - /path/to/your/certs:/etc/ssl/certs  # mount certificates directory
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

If you encounter any other issues, check the [Troubleshooting Guide]({{< ref "/nap-waf/v5/troubleshooting-guide/troubleshooting#nginx-app-protect-5" >}}).

## Air-Gap Install: Secure Offline Deployment

### Prerequisites
- Active NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/) (purchased or trial) on the online machine.
- Docker (with Docker Compose) is [installed and running](https://docs.docker.com/engine/install/) on both the online and offline machine.

### Build the NGINX Image

Follow the instructions below to build a Docker image containing the NGINX and the NGINX App Protect module on the machine connected to the internet.

#### Download Certificates

{{< include "nap-waf/download-certificates.md" >}}

Proceed, by creating a `Dockerfile` using one of the examples provided below.

#### Dockerfile Based on the Official NGINX Image

{{< include "nap-waf/build-from-official-nginx-image.md" >}}

#### NGINX Open Source Dockerfile

{{<tabs name="offline_nap5_nginx_OSS_dockerfiles">}}
{{%tab name="Alpine Linux"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-alpine.md" >}}

{{%/tab%}}
{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-debian.md" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-oracle.md" >}}

{{%/tab%}}
{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

You are ready to [Build the image](#build-image-sub)

#### NGINX Plus Dockerfile

{{<tabs name="offline_nap5_nginx_plus_dockerfiles">}}
{{%tab name="Alpine Linux"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-alpine.md" >}}

{{%/tab%}}
{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-debian.md" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-oracle.md" >}}

{{%/tab%}}
{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

### Build Image {#build-image-sub}

{{< include "nap-waf/build-nginx-image-cmd.md" >}}

#### Set up Docker for F5 Container Registry

{{< include "nap-waf/setup-docker-registry.md" >}}

#### Download Waf-Enforcer and Waf-Config-mgr Images
Pull the `waf-enforcer` and `waf-config-mgr` images. Replace `5.4.0` with the actual release version you are deploying.

```shell
docker pull private-registry.nginx.com/nap/waf-enforcer:5.4.0
docker pull private-registry.nginx.com/nap/waf-config-mgr:5.4.0
```

#### Saving and Transferring Images
1. Save the NGINX Open Source or NGINX Plus image you built earlier.

    ```shell
    docker save -o nginx-app-protect-5.tar nginx-app-protect-5
    ```

2. Save the `waf-enforcer` docker image:

    ```shell
    docker save -o waf-enforcer.tar private-registry.nginx.com/nap/waf-enforcer:5.4.0
    ```

3. Save the `waf-config-mgr` docker image:

    ```shell
    docker save -o waf-config-mgr.tar private-registry.nginx.com/nap/waf-config-mgr:5.4.0
    ```

4. Transfer the tar files from the online machine to the offline/air-gapped machine:

5. On the offline machine load the docker images:

    ```shell
    docker load -i nginx-app-protect-5.tar
    docker load -i waf-enforcer.tar
    docker load -i waf-config-mgr.tar
    ```

### NGINX Configuration

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

In this guide, we have created the following files under `/conf/` directory on the offline machine:

{{<tabs name="offline_nap5_install_conf_files_hostname">}}
{{%tab name="nginx.conf"%}}

`/conf/nginx.conf`

{{< include "nap-waf/nginx-conf-hostname-docker.md" >}}

{{%/tab%}}
{{%tab name="default.conf"%}}

`/conf/default.conf`

{{< include "nap-waf/default-conf-hostname.md" >}}

{{%/tab%}}
{{</tabs>}}

#### Docker Compose File

Create a `docker-compose.yml` with the following configuration on the offline machine: Replace `5.4.0` with the actual release version you are deploying.

```yaml
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
    image: "private-registry.nginx.com/nap/waf-enforcer:5.4.0"
    environment:
      - ENFORCER_PORT=50000
    volumes:
      - app_protect_bd_config:/opt/app_protect/bd_config
    networks:
      - waf_network
    restart: always

  waf-config-mgr:
    container_name: waf-config-mgr
    image: "private-registry.nginx.com/nap/waf-config-mgr:5.4.0"
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
### Start Deployment

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

## Conclusion

This guide provides the foundational steps for deploying NGINX App Protect WAF v5 using Docker Compose. You may need to adjust the deployment to fit your specific requirements.

For more detailed configuration options and advanced deployment strategies, refer to the [NGINX App Protect WAF v5 Configuration Guide]({{< ref "/nap-waf/v5/configuration-guide/configuration.md" >}}).
