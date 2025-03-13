---
docs: DOCS-1654
title: Deploy NGINX Plus in a container (data plane)
toc: true
weight: 200
type:
- how-to
---

## Overview

This guide explains how to:

- get official NGINX Plus Docker container images and add them to your private registry
- start the container using NGINX Agent-specific parameters
- add container instances to F5 NGINX Instance Manager

---

## Before you begin

Before you start, make sure that:

- NGINX Instance Manager is [installed]({{< ref "/nim/deploy/vm-bare-metal/install.md" >}}).

  {{<note>}} When installing and configuring NGINX Instance Manager, remember the domain name/IP address and the gRPC port number. You will need them to configure the NGINX Agent to communicate with NGINX Instance Manager.
  {{</note>}}
- You have the JSON Web Token (JWT) from MyF5 Customer Portal. The [download instructions](#download-jwt) are below.
- The [Docker Engine](https://docs.docker.com/engine/install/) command-line tool is installed.
- Your private Docker registry is configured and running.

#### Download the JWT from MyF5 {#download-jwt}

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

---

## About NGINX Plus Docker registry

The NGINX Plus Docker registry is available at `https://private-registry.nginx.com/v2/`. It contains the following Docker container images:

- [NGINX Plus]({{< ref "/nginx/releases.md" >}}):
  `https://private-registry.nginx.com/v2/nginx-plus/base`

- [Unprivileged]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#nginx-plus-unprivileged-installation" >}}) installation of NGINX Plus:
  `https://private-registry.nginx.com/v2/nginx-plus/rootless-base`

- NGINX Plus bundled with [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/):
  `https://private-registry.nginx.com/v2/nginx-plus/agent`

- Unprivileged installation of NGINX Plus and NGINX Agent:
  `https://private-registry.nginx.com/v2/nginx-plus/rootless-agent`

The images can be targeted for a particular operating system and NGINX Plus release using tags.

### Tags for operating systems

{{<bootstrap-table "table table-bordered">}}
| Operating system                           | Basic OS tag | Tag examples                                  |
|--------------------------------------------|--------------|-----------------------------------------------|
| Alpine (x86_64, aarch64)                   | `alpine`     | `r32-alpine`, `r32-alpine-3.20`               |
| Debian (x86_64, aarch64)                   | `debian`     | `r32-debian`, `r32-debian-bookworm`           |
| Red Hat Enterprise Linux (x86_64, aarch64) | `ubi`        | `r32-ubi`, `r32-ubi-9`,  `r32-ubi-9-20240624` |
{{</bootstrap-table>}}

### Tags for NGINX Plus versions

The NGINX Plus registry contains images for the two most recent versions of NGINX Plus. The basic operating system tag returns the latest version of NGINX Plus built for the latest version of this operating system.

{{<call-out "tip" "Example:" "fas fa-terminal" >}}
`nginx-plus-r32-ubi-9`, `nginx-plus-r31-alpine-3.19`.
{{</call-out>}}

### Listing all tags

For a complete tag list for NGINX Plus bundled with NGINX Agent images, use the command:

```shell
curl https://private-registry.nginx.com/v2/nginx-plus/<nginxplus-image-type>/tags/list --key <nginx-repo.key> --cert <nginx-repo.crt> | jq
```

where:
- the `<nginxplus-image-type>` is the location of images in NGINX Plus private registry: `base`, `rootless-base`, `agent`, `rootless-agent`
- the `<nginx-repo.key>` is a local path to your client key from MyF5, for example, `/etc/ssl/nginx/nginx-repo-x12345.key`
- the `<nginx-repo.crt>` is a local path to your client certificate from MyF5, for example,`/etc/ssl/nginx/nginx-repo-x12345.crt`
- the `jq` command is used to format the JSON output for easier reading and requires the [jq](https://jqlang.github.io/jq/) JSON processor to be installed.

---

## Getting an image from the registry

1. Log in to the NGINX Plus registry. Replace `YOUR_JWT_HERE` with your actual JWT obtained from MyF5:

   ```shell
   sudo docker login private-registry.nginx.com --username=YOUR_JWT_HERE --password=none
   ```

2. Pull the NGINX Plus image from the private registry. Use the NGINX Plus bundled with NGINX Agent image (the `agent` subdirectory) to enable connectivity with NGINX Instance Manager. Replace `VERSION_TAG` with the specific version tag you need.

   ```shell
   sudo docker pull private-registry.nginx.com/nginx-plus/agent:VERSION_TAG
   ```
   <br>

   {{<call-out "tip" "Example:" "fas fa-terminal" >}}
   To pull the latest version of NGINX Plus with NGINX Agent image for Debian or Ubuntu, use the command:

   ```shell
   sudo docker pull private-registry.nginx.com/nginx-plus/agent:debian
   ```
   {{</call-out>}}

---

## Adding image to private Docker registry

After pulling the image, tag it and upload it to your private registry.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry>
   ```

2. Tag the image. Replace `<my-docker-registry>` with your registry’s path and `<my-version-tag>` with the your NGINX Plus version, OS version, or both:

   ```shell
   docker tag private-registry.nginx.com/nginx-plus/agent:<version-tag> <my-docker-registry>/nginx-plus/agent:<my-version-tag>
   ```

3. Push the image to the private registry and tag it:

   ```shell
   docker push <my-docker-registry>/nginx-plus/agent:<my-version-tag>
   ```

---

## Launching Docker container

Start the Docker container from your private registry. You will also need to pass NGINX Agent connection settings as environment variables (`--env=$variable`) to enable connectivity with NGINX Instance Manager:

```shell
sudo docker run \
--env=NGINX_AGENT_SERVER_GRPCPORT=443 \
--env=NGINX_AGENT_SERVER_HOST=127.0.0.1 \
--env=NGINX_AGENT_TLS_ENABLE=true \
--env=NGINX_AGENT_TLS_SKIP_VERIFY=false \
--restart=always \
--runtime=runc \
-d <my-docker-registry>/nginx-plus/agent:<my-version-tag>
```

where:

 - `NGINX_AGENT_SERVER_GRPCPORT` sets a GRPC port used by NGINX Agent to communicate with NGINX Instance Manager.
 - `NGINX_AGENT_SERVER_HOST` sets the domain name or IP address of NGINX Instance Manager. Note that for production environments it is not recommended to expose NGINX Instance Manager to public networks.
 - `NGINX_AGENT_TLS_ENABLE` and `NGINX_AGENT_TLS_SKIP_VERIFY` enable mutual TLS, server-side TLS, or insecure mode (not recommended for production environments). See [Encrypt communication](https://docs.nginx.com/nginx-agent/configuration/encrypt-communication/) for details.
 - `<my-docker-registry>` is the path to your private registry.
 - `<my-version-tag>` is the tag assigned when pushing to your registry.

Full list of CLI flags with their default values can be found in [CLI flags and environment variables]({{< ref "/nms/nginx-agent/install-nginx-agent.md#cli-flags-and-environment-variables" >}}).
<br>

## Connecting NGINX Plus from container to NGINX Instance Manager

1. In a web browser, enter the address for your NGINX Instance Manager, for example, `https://127.0.0.1/ui/`, and log in.

2. In the **Modules** section, select **Instance Manager**:

3. Search for live hosts with NGINX Open Source or NGINX Plus.

   - In the left menu, Select **Scan**.
   - In the **CIDR** field, specify the mask of the target network, for example, `172.17.0.1/27`.
   - In the **Port Ranges** field, specify one or more ports or port ranges separated by a comma, for example, `80,443,8000-8090`.
   - Deselect the **ICMP** checkbox if Internet Control Message Protocol (ICMP) echo requests are disabled in your network.
   - Select **Scan**.

4. When the scanning is finished, you will get the list of your NGINX Plus managed and unmanaged instances, including instances running in containers:

NGINX Plus instances that can be managed by NGINX Instance Manager can be accessed from the **NGINX Plus** tab.

You can also scan for NGINX instances using the NGINX Instance Manager API; for more information, refer to [Scan NGINX Instances]({{< ref "/nim/nginx-instances/scan-instances.md" >}}).

### Troubleshooting unmanaged instances

If the instance appears as "unmanaged", check if:

- the NGINX Plus Docker image includes NGINX Agent
- the container was started with correct `--env=` parameters of NGINX Agent, for example, `--env=NGINX_AGENT_SERVER_GRPCPORT=443`
- there are connectivity issues between NGINX Instance Manager and the network running NGINX Plus instances (for example, ports `80` and `443` are open in the firewall)




---

## See also

- [Deploying NGINX and NGINX Plus with Docker]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md" >}})
- [Full list of agent environment variables]({{< ref "/nms/nginx-agent/install-nginx-agent.md#cli-flags-and-environment-variables" >}})
