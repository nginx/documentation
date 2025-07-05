---
description: ''
nd-docs: null
title: Connect NGINX Plus container images
toc: true
weight: 400
type:
- how-to
---

## Overview

This guide explains how to set up an F5 NGINX Plus Docker container with NGINX Agent and connect it to the NGINX One Console.

---

## Before you start

Before you start, make sure you have:

- A valid JSON Web Token (JWT) for your NGINX subscription.
- [A data plane key from NGINX One]({{< ref "/nginx-one/connect-instances/create-manage-data-plane-keys.md" >}}).
- Docker installed and running on your system.

#### Download your JWT license from MyF5

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

---

## Process for private registry

### Log in to the NGINX private registry

Use your JWT to log in to the NGINX private registry. Replace `YOUR_JWT_HERE` with your JWT.

```sh
sudo docker login private-registry.nginx.com --username=YOUR_JWT_HERE --password=none
```

{{< include "security/jwt-password-note.md" >}}

### Pull the NGINX Plus image

Pull the NGINX Plus image from the private registry. Replace `<version-tag>` with the desired version, such as `alpine`, `debian`, or `ubi`.

```sh
docker pull private-registry.nginx.com/nginx-plus/agentv3:<version-tag>
```

You must specify a version tag that matches your distribution. The `latest` tag is not supported. Learn more in the [Deploying NGINX and NGINX Plus on Docker]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md#pull-the-image" >}}) guide.

<br>

{{<call-out "" "Example:" "" >}}
To pull the `debian` image:

```sh
sudo docker pull private-registry.nginx.com/nginx-plus/agent:debian
```
{{</call-out>}}

### Start the NGINX Plus container

Start the Docker container to connect it to NGINX One. Replace `YOUR_NGINX_ONE_DATA_PLANE_KEY_HERE` with your data plane key and `version-tag` with the version tag you pulled.

**For NGINX Plus R33 or later**:

- Use the `NGINX_LICENSE_JWT` variable to pass your JWT license. Replace `YOUR_JWT_HERE` with your JWT.

For more details, see [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}}).

```sh
sudo docker run \
--env=NGINX_LICENSE_JWT="YOUR_JWT_HERE" \
--env=NGINX_AGENT_SERVER_GRPCPORT=443 \
--env=NGINX_AGENT_SERVER_HOST=agent.connect.nginx.com \
--env=NGINX_AGENT_SERVER_TOKEN="YOUR_NGINX_ONE_DATA_PLANE_KEY_HERE" \
--env=NGINX_AGENT_TLS_ENABLE=true \
--restart=always \
--runtime=runc \
-d private-registry.nginx.com/nginx-plus/agent:<version-tag>
```

<br>

{{<call-out "" "Example:" "" >}}
To start the container with the `debian` image:

```sh
sudo docker run \
--env=NGINX_LICENSE_JWT="YOUR_JWT_HERE" \
--env=NGINX_AGENT_SERVER_GRPCPORT=443 \
--env=NGINX_AGENT_SERVER_HOST=agent.connect.nginx.com \
--env=NGINX_AGENT_SERVER_TOKEN="YOUR_NGINX_ONE_DATA_PLANE_KEY_HERE" \
--env=NGINX_AGENT_TLS_ENABLE=true \
--restart=always \
--runtime=runc \
-d private-registry.nginx.com/nginx-plus/agent:debian
```

{{</call-out>}}

---

## References

For more details, see:

- [Deploying NGINX and NGINX Plus on Docker]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md" >}})
- [Full List of Agent Environment Variables]({{< ref "/agent/configuration/configuration-overview.md#cli-flags-and-environment-variables" >}})
- [NGINX One Data Plane Keys]({{< ref "/nginx-one/connect-instances/create-manage-data-plane-keys.md" >}})
- [My F5 Knowledge Article](https://my.f5.com/manage/s/article/K000090257)
