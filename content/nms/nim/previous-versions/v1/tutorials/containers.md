---
description: Steps on using Instance Manager with Containers
docs: DOCS-642
doctypes:
- tutorial
tags:
- docs
title: Using Containers
toc: true
weight: 400
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document is intended to help use NGINX and Instance Manager with containers.

Instance Manager utilizes the nginx-agent that runs as a process or binary. There are at least three methods to use for containers.

1. Use systemd in a container
2. Layer nginx-agent on top of nginx
3. Run multiple binaries on CMD

## Prerequisites {#prerequisites}

1. NGINX Instance Manager server already configured and running.
2. nginx-agent binaries and/or packages in the Dockerfile directory.
3. Knowledge of building containers and extending them.
4. You know how to use docker and build docker containers

Create an `nginx-agent.conf` and place this in the directory of your Dockerfile (you can also map this as a volume map)

```yaml
server: nginx-manager.example.com:10000
tls:
  # disable tls for testing
  # enable: true
  # cert: /etc/ssl/nginx-manager/agent.crt
  # key: /etc/ssl/nginx-manager/agent.key
  # ca: /etc/ssl/nginx-manager/ca.pem
log:
  level: info
  path: /var/log/nginx-agent/
# (optional) tags for this specific instance / machine for inventory purposes
metadata:
  location: unspecified
# instance tags
tags:
- web
- staging
- etc
# list of allowed config directories (comma-separated)
config_dirs: /etc/nginx,/usr/local/etc/nginx
nginx:
  bin_path: /usr/sbin/nginx
  stub_status: "http://localhost:80/nginx_status"
  # plus_api: "http://localhost:8080/api"
```

## Systemd {#systemd}

Having systemd in the container allows you to use the same packages for VMs or bare metal. Opinions may vary on using systemd, but this method allows a stable and responsive container for running both the nginx and nginx-agent components. As a bonus, you can restart the services and also call reload via systemctl for nginx. If your organization has stringent security requirements, you can easily extend these containers to leverage SELinux and other technologies.

We will use centos7 as an example, but Ubuntu and other distributions that support systemd can be used. Alpine would not be a good choice for this option, though (using systemd).

1. Put your `nginx.conf` and `conf.d` files in the same directory with your Dockerfile. (assuming we are using open source, add a `stub_status` conf to `127.0.0.1` at a minimum)

2. Place the `nginx-agent*.rpm` package in a directory with your Dockerfile to build this image and call the rpm `nginx-agent.rpm`.

3. Create an [nginx.repo](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-a-prebuilt-centos-rhel-package-from-the-official-nginx-repository) in the same directory.

```bash
sudo vim nginx.repo
```

Add the following lines and save the file:

```text
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

4. Create a dockerfile similar to the one {{<fa "here">}} {{<link "/nim/previous-versions/static/previous-versions/v1/examples/docker/Dockerfile.systemd" "Dockerfile.systemd">}}

```Dockerfile
# systemd image  ###############################################################
# From https://github.com/CentOS/CentOS-Dockerfiles/blob/master/systemd/centos7/Dockerfile
FROM centos:centos7 as builder

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]

# NGINX image  ###############################################################
FROM builder as nginx

# Install NGINX Repo - you could use EPEL or write your own repo also
COPY nginx.repo /etc/yum.repos.d/nginx.repo

RUN set -eux \
    # Create nginx user/group first, to be consistent throughout Docker variants
    && groupadd --system --gid 101 nginx \
    && adduser -g nginx --system --no-create-home --home /nonexistent --shell /bin/false --uid 101 nginx \
    && usermod -s /sbin/nologin nginx \
    && usermod -L nginx \
    # Install prerequisite packages (ca-certificates epel-release) and tools for editing/troubleshooting:
    && yum install -y wget ca-certificates bind-utils vim-minimal yum-utils which \
    ## Install the latest release of NGINX
    && yum --showduplicates list nginx \
    && yum install -y nginx \
    # Set permissions
    && chown -R nginx:nginx /etc/nginx \
    # Forward request and error logs to docker log collector
    # Use actual logs for nginx-agent for now
    # && ln -sf /dev/stdout /var/log/nginx/access.log \
    # && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Raise the limits to successfully run benchmarks
    && ulimit -c -m -s -t unlimited \
    # Cleanup
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /etc/yum.repos.d/* \
    && systemctl enable nginx

# Agent image  ###############################################################
FROM nginx

# Set Instance Manager Server and Port and timeout for wait-for-it script
ARG COMPASS_PROTOCOL
ENV COMPASS_PROTOCOL=${COMPASS_PROTOCOL:-http}
ARG COMPASS_SYSTEMD
# Change to /lib/systemd/systemd for ubuntu
ENV COMPASS_SYSTEMD=${COMPASS_SYSTEMD:-/usr/sbin/init}
ARG COMPASS_SERVER
ENV COMPASS_SERVER=${COMPASS_SERVER:-nginx-manager.example.com}
ARG COMPASS_PORT
ENV COMPASS_PORT=${COMPASS_PORT:-11000}
ARG COMPASS_TIMEOUT
ENV COMPASS_TIMEOUT=${COMPASS_TIMEOUT:-15}

# For client certs if used
RUN mkdir -p /etc/ssl/nginx-manager
# COPY ssl/ca.pem /etc/ssl/nginx-manager/ca.pem
# COPY ssl/agent-centos7.crt /etc/ssl/nginx-manager/agent.crt
# COPY ssl/agent-centos7.key /etc/ssl/nginx-manager/agent.key
# RUN set -eux \
#     && chmod 644 /etc/ssl/nginx-manager/* \
#     # Add nginx-manager certificate to CA store for trust
#     && cp /etc/ssl/nginx-manager/ca.pem /etc/pki/ca-trust/source/anchors \
#     && update-ca-trust

RUN mkdir -p /pkg_rpm_build
COPY nginx-agent*.rpm /
# Install nginx-agent package
RUN set -eux \
    && yum install -y ./nginx-agent*.rpm \
    && systemctl enable nginx-agent
# COPY nginx-agent configuration
COPY nginx-agent.conf /etc/nginx-agent/nginx-agent.conf
COPY stub-status.conf /etc/nginx/conf.d/stub-status.conf

# Add command script for wait-for-it and /sbin/init
COPY systemd.sh /usr/local/bin/cmd.sh
# Set executable bit on script
RUN chmod +x /usr/local/bin/cmd.sh

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80
STOPSIGNAL SIGRTMIN+3
CMD ["/usr/local/bin/cmd.sh"]
```

5. Add the `systemd.sh` file in the same directory:

<details>
    <summary>systemd.sh</summary>

{{<fa "download">}} {{<link "/tutorials/containers/systemd.sh" "systemd.sh">}}

```bash
#!/bin/bash
set -eux

if [ -f /etc/ssl/nginx-manager/ca.pem ] ; then
    if [ -d /etc/pki/ca-trust/source/anchors ]; then
        cp /etc/ssl/nginx-manager/ca.pem /etc/pki/ca-trust/source/anchors
        update-ca-trust
    elif [ -d /usr/local/share/ca-certificates ]; then
        cp /etc/ssl/nginx-manager/ca.pem /usr/local/share/ca-certificates
        update-ca-certificates
    fi
fi

if ! [ -d /sys/fs/cgroup/systemd ] ; then
    mkdir /sys/fs/cgroup/systemd
    mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
fi

if [ -f /etc/systemd/system/multi-user.target.wants/nginx-debug.service ]; then
    rm /etc/systemd/system/multi-user.target.wants/nginx-debug.service
fi

echo "$HOSTNAME"

# Nothing below the exec line
exec "${COMPASS_SYSTEMD}"
```

</details><br/>

6. Build the Dockerfile:

```bash
docker build \
  -t nginx-agent:systemd .
```

7. Run the container. In this example, we specify the nginx-manager, ports, and protocol (use HTTP or HTTPS) -- which is used to wait until the nginx-manager is found before starting -- and also export port 1080 to the container's port 80.  We also make the container a daemon and name it `nginx-agent-1`.  Finally, we specify we want to restart the container on failure.

```bash
docker run \
  --name nginx-agent-1 \
  --hostname nginx-agent-1 \
  -d \
  --restart=unless-stopped \
  -e COMPASS_PROTOCOL=http \
  -e COMPASS_SERVER=nginx-manager.example.com \
  -e COMPASS_PORT=11000 \
  -v $PWD/nginx-agent.conf:/etc/nginx-agent/nginx-agent.conf \
  -p 1080:80 \
  nginx-agent:systemd
```

## Layers {#layers}

Using layers is a great way to break apart the systems. We use an NGINX instance and then call it by the section using the nginx-agent.

We will use centos7 as an example, but Ubuntu and other distributions that support systemd can be used. Alpine would not be a good choice for this option, though (using systemd).

1. Put your `nginx.conf` and `conf.d files` in the same directory with your Dockerfile (assuming you're using open-source, add a `stub_status` conf to `127.0.0.1` at a minimum)

2. Place the `nginx-agent*.rpm` package in a directory with your Dockerfile to build this image. Name this file `nginx-agent.rpm`.

3. Create an [nginx.repo](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-a-prebuilt-centos-rhel-package-from-the-official-nginx-repository) in the same directory.

```bash
sudo vim nginx.repo
```

Add the following lines and save the file:

```text
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

4. Create a dockerfile similar to the one {{<fa "here">}} {{<link "/nim/previous-versions/static/previous-versions/v1/examples/docker/Dockerfile.systemd" "Dockerfile.systemd">}}

```Dockerfile
# systemd image  ###############################################################
# From https://github.com/CentOS/CentOS-Dockerfiles/blob/master/systemd/centos7/Dockerfile
FROM centos:centos7 as builder

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install NGINX Repo - you could use EPEL or write your own repo also
COPY nginx.repo /etc/yum.repos.d/nginx.repo

RUN set -eux \
    # Create nginx user/group first, to be consistent throughout Docker variants
    && groupadd --system --gid 101 nginx \
    && adduser -g nginx --system --no-create-home --home /nonexistent --shell /bin/false --uid 101 nginx \
    && usermod -s /sbin/nologin nginx \
    && usermod -L nginx \
    # Install prerequisite packages (ca-certificates epel-release) and tools for editing/troubleshooting:
    && yum install -y wget ca-certificates bind-utils vim-minimal yum-utils which \
    ## Install the latest release of NGINX
    && yum --showduplicates list nginx \
    && yum install -y nginx \
    # Set permissions
    && chown -R nginx:nginx /etc/nginx \
    # Forward request and error logs to docker log collector
    # Use actual logs for nginx-agent for now
    # && ln -sf /dev/stdout /var/log/nginx/access.log \
    # && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Raise the limits to successfully run benchmarks
    && ulimit -c -m -s -t unlimited \
    # Cleanup
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /etc/yum.repos.d/* \
    && systemctl enable nginx

# Set Instance Manager Server and Port and timeout for wait-for-it script
ARG COMPASS_PROTOCOL
ENV COMPASS_PROTOCOL=${COMPASS_PROTOCOL:-http}
ARG COMPASS_SYSTEMD
# Change to /lib/systemd/systemd for ubuntu
ENV COMPASS_SYSTEMD=${COMPASS_SYSTEMD:-/usr/sbin/init}
ARG COMPASS_SERVER
ENV COMPASS_SERVER=${COMPASS_SERVER:-nginx-manager.example.com}
ARG COMPASS_PORT
ENV COMPASS_PORT=${COMPASS_PORT:-11000}
ARG COMPASS_TIMEOUT
ENV COMPASS_TIMEOUT=${COMPASS_TIMEOUT:-15}

# For client certs if used
RUN mkdir -p /etc/ssl/nginx-manager
# COPY ssl/ca.pem /etc/ssl/nginx-manager/ca.pem
# COPY ssl/agent-centos7.crt /etc/ssl/nginx-manager/agent.crt
# COPY ssl/agent-centos7.key /etc/ssl/nginx-manager/agent.key
# RUN set -eux \
#     && chmod 644 /etc/ssl/nginx-manager/* \
#     # Add nginx-manager certificate to CA store for trust
#     && cp /etc/ssl/nginx-manager/ca.pem /etc/pki/ca-trust/source/anchors \
#     && update-ca-trust

RUN mkdir -p /pkg_rpm_build
COPY nginx-agent*.rpm /
# Install nginx-agent package
RUN set -eux \
    && yum install -y ./nginx-agent*.rpm \
    && systemctl enable nginx-agent
# COPY nginx-agent configuration
COPY nginx-agent.conf /etc/nginx-agent/nginx-agent.conf
COPY stub-status.conf /etc/nginx/conf.d/stub-status.conf

# Add command script for wait-for-it and /sbin/init
COPY systemd.sh /usr/local/bin/cmd.sh
# Set executable bit on script
RUN chmod +x /usr/local/bin/cmd.sh

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80
STOPSIGNAL SIGRTMIN+3
CMD ["/usr/local/bin/cmd.sh"]
```

5. Build the Dockerfile

```bash
docker build \
  -t nginx-agent:layers .
```

6. Run the container. In this example, we map the nginx-agent.conf locally and also export port 1080 to the container's port 80. We also make the container a daemon and name it nginx-agent-2. Finally, we specify we want to restart the container on failure.

```bash
docker run \
  --name nginx-agent-1 \
  --hostname nginx-agent-1 \
  -d \
  --restart=unless-stopped \
  -e COMPASS_PROTOCOL=http \
  -e COMPASS_SERVER=nginx-manager.example.com \
  -e COMPASS_PORT=11000 \
  -v $PWD/nginx-agent.conf:/etc/nginx-agent/nginx-agent.conf \
  -p 1080:80 \
  nginx-agent:layers
```

## Single container, multiple binaries {#single}

Running one container with multiple binaries is another way to create your containers. This method just uses a CMD option to run both the nginx binary and nginx-agent binary together. When one or both fail, the container exits, and you restart.

We will use Alpine as an example. We need to add dbus for the machine-id generation.

1. Put your `nginx.conf` and `conf.d` files in the same directory with your Dockerfile. (Assuming you're using open source, add a `stub-status.conf` to `127.0.0.1` at a minimum)

```nginx
# stub-status.conf
server {
    listen 127.0.0.1:80;
    server_name 127.0.0.1;
    access_log off; # Don't log access here (test env)
    location /nginx_status {
        stub_status;
    }
}
```

2. Create bash script to run the two processes. Call it {{<fa "single.sh">}} {{<link "/nim/previous-versions/static/previous-versions/v1/examples/docker/single.sh" "single.sh">}} and put it in the Dockerfile directory.

```bash
#!/bin/bash

# turn on bash's job control
set -m

# Start the primary process and put it in the background
/nginx -g 'daemon off;' &

# Start the helper process
./nginx-agent

# Now, we bring the primary process back into the foreground
# and leave it there
fg %1
```

3. Create a dockerfile similar to the one {{<fa "here">}} {{<link "/nim/previous-versions/static/previous-versions/v1/examples/docker/Dockerfile.single" "Dockerfile.single">}}

```Dockerfile
# NGINX image  ###############################################################
FROM nginx:alpine

COPY nginx-agent /usr/sbin/nginx-agent
COPY stub-status.conf /etc/nginx/conf.d/stub-status.conf
RUN mkdir -p /etc/ssl/nginx-manager
COPY ca.pem client.crt client.key /etc/ssl/nginx-manager/
RUN apk add dbus \
    && dbus-uuidgen > /var/lib/dbus/machine-id \
    && ln -sf /etc/machine-id /var/lib/dbus/machine-id
COPY single.sh .
RUN chmod +x ./single.sh
CMD ["/bin/sh","./single.sh"]
EXPOSE 80
```

4. Place the nginx-agent binary in a directory with your Dockerfile to build this image. (it is called ./nginx-agent)

5. Build the Dockerfile.

```bash
docker build \
  -t nginx-agent:single .
```

6. Run the container. This example specifies the nginx-manager in the `nginx-agent.conf` and exports port `1080` to the container's port `80`. We also make the container a daemon and name it `nginx-agent-3`. Finally, we specify we want to restart the container on failure.

```bash
docker run \
  --name nginx-agent-3 \
  --hostname nginx-agent-3 \
  -d \
  --restart=unless-stopped \
  -v $PWD/nginx-agent.conf:/etc/nginx-agent/nginx-agent.conf \
  -p 1080:80 \
  nginx-agent:single
```

7. Verify docker container is running

```bash
```

## Next Steps {#next}

You can combine these examples with certificates and advanced configurations.
