---
description: ''
docs:
doctypes:
- task
tags:
- docs
title: Connect NGINX Plus container images to NGINX One
toc: true
weight: 400
---

## Introduction

By following this guide, you will be able to set up a Docker container with F5 NGINX Plus and the NGINX Agent, and then connect to the NGINX One Console.

---

## Before you start

Before you start, make sure you have the following:

- A valid JSON Web Token (JWT) from your NGINX subscription. You can download the JWT from [MyF5](https://my.f5.com/manage/s/).
- [A data plane key from NGINX One]({{< relref "/nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys.md" >}}).
- Docker installed and running on your system.

---

## Process for private registry

### Log in to NGINX private registry

First, log in to the NGINX private registry. Replace `YOUR_JWT_HERE` with your actual JWT.

```sh
sudo docker login private-registry.nginx.com --username=YOUR_JWT_HERE --password=none
```

{{< include "security/jwt-password-note.md" >}}

### Pull the image

Next, pull the NGINX Plus image from the private registry. Replace `VERSION_TAG` with the specific version tag you need (for example, `alpine`, `debian`, or `ubi`).

```sh
sudo docker pull private-registry.nginx.com/nginx-plus/agent:VERSION_TAG
```

{{<note>}}A version tag is required. Leaving out the version tag is not supported because `latest` is not a valid option. For more details about version tags, refer to [Deploying NGINX and NGINX Plus on Docker]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md#pulling-the-image" >}}).{{</note>}}

<br>

{{<call-out "tip" "Example:" "fas fa-terminal" >}}
To pull the `debian` image, use the following command:

```sh
sudo docker pull private-registry.nginx.com/nginx-plus/agent:debian
```
{{</call-out>}}

### Start the container

Finally, start the Docker container. Replace `YOUR_DATA_PLANE_KEY` with your actual NGINX One data plane key and `VERSION_TAG` with the specific version tag you pulled.

```sh
sudo docker run \
--env=NGINX_AGENT_SERVER_GRPCPORT=443 \
--env=NGINX_AGENT_SERVER_HOST=agent.connect.nginx.com \
--env=NGINX_AGENT_SERVER_TOKEN=YOUR_DATA_PLANE_KEY \
--env=NGINX_AGENT_TLS_ENABLE=true \
--env=NGINX_AGENT_TLS_SKIP_VERIFY=false \
--restart=always \
--runtime=runc \
-d private-registry.nginx.com/nginx-plus/agent:VERSION_TAG
```

<br>

{{<call-out "tip" "Example:" "fas fa-terminal" >}}
To start the container with the `debian` image, use the following command:

```sh
sudo docker run \
--env=NGINX_AGENT_SERVER_GRPCPORT=443 \
--env=NGINX_AGENT_SERVER_HOST=agent.connect.nginx.com \
--env=NGINX_AGENT_SERVER_TOKEN=YOUR_DATA_PLANE_KEY \
--env=NGINX_AGENT_TLS_ENABLE=true \
--env=NGINX_AGENT_TLS_SKIP_VERIFY=false \
--restart=always \
--runtime=runc \
-d private-registry.nginx.com/nginx-plus/agent:debian
```

{{</call-out>}}

---

## References

For more detailed information, refer to the following resources:

- [Deploying NGINX and NGINX Plus on Docker](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/)
- [Full List of Agent Environment Variables](https://docs.nginx.com/nginx-agent/configuration/configuration-overview/#nginx-agent-environment-variables)
- [NGINX One Data Plane Keys](https://docs.nginx.com/nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys/)
- [My F5 Knowledge Article](https://my.f5.com/manage/s/article/K000090257)
