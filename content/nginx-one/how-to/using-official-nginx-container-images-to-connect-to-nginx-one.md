---
description: ''
docs: 
doctypes:
- task
tags:
- docs
title: Using NGINX Plus container images to connect to NGINX One
toc: true
weight: 300
---

## Introduction

By following this guide, you will be able to set up a Docker container with NGINX Plus and the NGINX Agent, and then connect to NGINX One SaaS.

## Before you start

Before you start, make sure you have the following:

- A valid JWT (JSON Web Token) from your NGINX subscription.
- [A data plane key from NGINX One]({{< relref "/nginx-one/how-to/data-plane-keys.md" >}}).
- Docker installed and running on your system.

## Process for private registry

### Log in to NGINX private registry

First, log in to the NGINX private registry. Replace `YOUR_JWT_HERE` with your actual JWT.

```sh
sudo docker login private-registry.nginx.com --username=YOUR_JWT_HERE --password=none
```

### Pull the image

Next, pull the NGINX Plus image from the private registry. If you want to select a specific image, follow the instructions in [Deploying NGINX and NGINX Plus on Docker]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md#pulling-the-image" >}}).

```sh
sudo docker pull private-registry.nginx.com/nginx-plus/agent
```

### Start the container

Finally, start the Docker container. Replace `YOUR_DATA_PLANE_KEY` with your actual NGINX One data plane key.

```sh
sudo docker run \
--env=NMS_SERVER_GRPCPORT=443 \
--env=NMS_SERVER_HOST=agent.connect.nginx.com \
--env=NMS_SERVER_TOKEN=YOUR_DATA_PLANE_KEY \
--env=NMS_TLS_ENABLE=true \
--restart=always \
--runtime=runc \
-d private-registry.nginx.com/nginx-plus/agent
```

{{<note>}}If you used an image other than the default one, make sure you change the image name in the command.{{</note>}}


## References

For more detailed information, refer to the following resources:

- [Deploying NGINX and NGINX Plus on Docker](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/)
- [Full List of Agent Environment Variables](https://docs.nginx.com/nginx-agent/configuration/configuration-overview/#nginx-agent-environment-variables)
- [NGINX One Data Plane Keys](https://docs.nginx.com/nginx-one/how-to/data-plane-keys/)
- [My F5 Knowledge Article](https://my.f5.com/manage/s/article/K000090257)
