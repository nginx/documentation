---
description: Deploy NGINX and NGINX Plus as the Docker container.
docs: DOCS-409
doctypes:
- task
title: Deploying NGINX and NGINX Plus on Docker
toc: true
weight: 600
---

[NGINX Plus](https://www.nginx.com/products/nginx/), the high‑performance application delivery platform, load balancer, and web server, is available as the Docker container.

<span id="prereq"></span>
## Prerequisites

- Docker installation
- for NGINX Plus: *nginx-repo.crt* and *nginx-repo.key* files or JSON Web Token file
- for NGINX Open Source: [Docker Hub](https://hub.docker.com/) account


<span id="nginx_plus_official_images"></span>
## Building NGINX Plus image for specific OS and architecture

Since NGINX Plus <a href="../../../releases/#r31">Release 31</a> you can pull an NIGNX Plus image from the official NGINX Plus Docker registry and upload it to your private registry.

The image may contain a particular version of NGINX Plus or contain a bundle of NGINX Plus and NGINX Agent, and can be targeted for a specific architecture.

### Supported NGINX Plus Versions

- NGINX Plus Release 31
- NGINX Plus Release 31 with [NGINX Agent](https://docs.nginx.com/nginx-agent/)
- NGINX Plus Release 30
- NGINX Plus Release 30 with [NGINX Agent](https://docs.nginx.com/nginx-agent/)

### Supported Distributions

- Alpine (x86_64, aarch64)
- Debian (x86_64, aarch64)
- Red Hat Enterprise Linux (x86_64, aarch64)

### Supported Image Types

- base — NGINX Plus only
- agent — NGINX Plus along with NGINX Agent in a single image
- rootless-base — NGINX Plus run from `nginx` user
- rootless-agent — NGINX Plus with NGINX Agent both run from `nginx` user


### Downloading the NGINX Plus certificate and key or JSON Web Token{#myf5-download}

Before you get a container image, you should provide the SSL certificate and private key files or JSON Web Token file provided with your NGINX Plus license. These files grant access to the package repository from which the script will download the NGINX Plus package:

{{<tabs name="product_keys">}}

{{%tab name="JSON Web Token"%}}
1. Log in to the [MyF5](https://my.f5.com) customer portal.
2. Go to **My Products and Plans** > **Subscriptions**.
3. Select the product subscription.
4. Download the **JSON Web Token** file.
{{% /tab %}}

{{%tab name="SSL"%}}
1. Log in to the [MyF5](https://my.f5.com) customer portal.
2. Go to **My Products and Plans** > **Subscriptions**.
3. Select the product subscription.
4. Download the **SSL Certificate** and **Private Key** files.
{{% /tab %}}

{{% /tabs %}}

### Set up Docker for NGINX Plus Container Registry

Set up Docker to communicate with the NGINX Container Registry located at `private-registry.nginx.com`. 

{{<tabs name="docker_login">}}

{{%tab name="JSON Web Token"%}}
Open the JSON Web Token file previously downloaded from [MyF5](https://my.f5.com) customer portal (for example, `nginx-repo-12345abc.jwt`) and copy its contents.

Log in to the docker registry using the contents of the JSON Web Token file:

```shell
docker login private-registry.nginx.com --username=<output_of_jwt_token> --password=none
```
{{% /tab %}}

{{%tab name="SSL"%}}
Create a directory and copy your certificate and key to this directory:

```shell
mkdir -p /etc/docker/certs.d/private-registry.nginx.com
cp <path-to-your-nginx-repo.crt> /etc/docker/certs.d/private-registry.nginx.com/client.cert
cp <path-to-your-nginx-repo.key> /etc/docker/certs.d/private-registry.nginx.com/client.key
```
The steps provided are for Linux. For Mac or Windows, see the [Docker for Mac](https://docs.docker.com/docker-for-mac/#add-client-certificates) or [Docker for Windows](https://docs.docker.com/docker-for-windows/#how-do-i-add-client-certificates) documentation. For more details on Docker Engine security, you can refer to the [Docker Engine Security documentation](https://docs.docker.com/engine/security/).

Log in to the docker registry:

```shell
docker login private-registry.nginx.com
```
{{% /tab %}}

{{% /tabs %}}

### Pulling the image

Next, pull the image you need from `private-registry.nginx.com`.

To pull an image, replace `<version-tag>` with the specific NGINX Plus version and/or OS version you need, for example, `r31-ubi-9`.

For NGINX Plus, run:

```shell
docker pull private-registry.nginx.com/nginx-plus/base:<version-tag>
```

For NGINX Plus with NGINX Agent, run:

```shell
docker pull private-registry.nginx.com/nginx-plus/agent:<version-tag>
```

For NGINX Plus installed from `nginx` user (rootless installation), run:

```shell
docker pull private-registry.nginx.com/nginx-plus/rootless-base:<version-tag>
```

For NGINX Plus with NGINX Agent installed from `nginx` user (rootless installation), run:

```shell
docker pull private-registry.nginx.com/nginx-plus/rootless-agent:<version-tag>
```

Tagging examples:

- `nginx_release`—`OS_type`: `r31-ubi`, `r31-alpine`, `r31-debian`
- `nginx_release`—`OS_type`—`OS_version`: `r31-ubi-9`, `r31-alpine-9.99`, `r31-debian-sid`
- latest release image gets the `OS_type` tag: `alpine`, `debian` or `ubi`
- latest debian-based images also get the short release tag (e.g. `R31`) and the `nginx-plus` tag


You can use the Docker registry API to list the available image tags.
Replace `<path-to-client.key>` with the location of your client key and `<path-to-client.cert>` with the location of your client certificate. The optional `jq` command is used to format the JSON output for easier reading and requires [jq](https://jqlang.github.io/jq/) JSON processor to be installed.

```shell
curl https://private-registry.nginx.com/v2/nginx-plus/base/tags/list --key <path-to-your-nginx-repo.key> --cert <path-to-your-nginx-repo.crt> | jq
```
```json
{
  "name": "nginx-plus/base",
  "tags": [
    "alpine",
    "debian",
    "nginx-plus-20240313",
    "nginx-plus-20240326",
    "nginx-plus-r30-20240313",
    "nginx-plus-r30-20240326",
    "nginx-plus-r30-alpine-3.18-20240313",
    "nginx-plus-r30-alpine-3.18-20240326",
    "nginx-plus-r30-alpine-3.18",
    "nginx-plus-r30-debian-bookworm-20240313",
    "nginx-plus-r30-debian-bookworm-20240326",
    "nginx-plus-r30-debian-bookworm",
    "nginx-plus-r30-ubi-9-20240313",
    "nginx-plus-r30-ubi-9-20240326",
    "nginx-plus-r30-ubi-9",
    "nginx-plus-r30",
    "nginx-plus-r31-20240313",
    "nginx-plus-r31-20240326",
    "nginx-plus-r31-alpine-3.19-20240313",
    "nginx-plus-r31-alpine-3.19-20240326",
    "nginx-plus-r31-alpine-3.19",
    "nginx-plus-r31-debian-bookworm-20240313",
    "nginx-plus-r31-debian-bookworm-20240326",
    "nginx-plus-r31-debian-bookworm",
    "nginx-plus-r31-ubi-9-20240313",
    "nginx-plus-r31-ubi-9-20240326",
    "nginx-plus-r31-ubi-9",
    "nginx-plus-r31",
    "nginx-plus",
    "r30-alpine-3.18-20240313",
    "r30-alpine-3.18-20240326",
    "r30-alpine-3.18",
    "r30-debian-bookworm-20240313",
    "r30-debian-bookworm-20240326",
    "r30-debian-bookworm",
    "r30-ubi-9-20240313",
    "r30-ubi-9-20240326",
    "r30-ubi-9",
    "r30",
    "r31-alpine-3.19-20240313",
    "r31-alpine-3.19-20240326",
    "r31-alpine-3.19",
    "r31-alpine",
    "r31-debian-bookworm-20240313",
    "r31-debian-bookworm-20240326",
    "r31-debian-bookworm",
    "r31-debian",
    "r31-ubi-9-20240313",
    "r31-ubi-9-20240326",
    "r31-ubi-9",
    "r31-ubi",
    "r31",
    "ubi"
  ]
}
```

### Pushing the image to your private registry

After pulling the image, tag it and upload it to your private registry.

Log in to your private registry:

```shell
docker login <my-docker-registry>
```

Tag and push the image. Replace `<my-docker-registry>` with your registry’s path and `<version-tag>` with the your NGINX Plus version and/or OS version:

```shell
docker tag private-registry.nginx.com/nginx-plus/base:<version-tag> <my-docker-registry>/nginx-plus/base:<version-tag>
docker push <my-docker-registry>/nginx-plus/base:<version-tag>
```

<span id="docker_oss"></span>
## Running NGINX Open Source in a Docker Container

You can create an NGINX instance in a Docker container using the NGINX Open Source image from the Docker Hub.

1. Launch an instance of NGINX running in a container and using the default NGINX configuration with the following command:

    ```shell
    docker run --name mynginx1 -p 80:80 -d nginx
    ```

    where:

    - `mynginx1` is the name of the created container based on the NGINX image

    - the `-d` option specifies that the container runs in detached mode: the container continues to run until stopped but does not respond to commands run on the command line.

    - the `-p` option tells Docker to map the ports exposed in the container by the NGINX image (port `80`) to the specified port on the Docker host. The first parameter specifies the port in the Docker host, the second parameter is mapped to the port exposed in the container

    The command returns the long form of the container ID: `fcd1fb01b14557c7c9d991238f2558ae2704d129cf9fb97bb4fadf673a58580d`. This form of ID is used in the name of log files.

2. Verify that the container was created and is running with the `docker ps` command:

    ```shell
    $ docker ps
    CONTAINER ID  IMAGE         COMMAND               CREATED         STATUS        ...
    fcd1fb01b145  nginx:latest  "nginx -g 'daemon of  16 seconds ago  Up 15 seconds ...

        ... PORTS              NAMES
        ... 0.0.0.0:80->80/tcp mynginx1
    ```

This command also allows viewing the port mappings set in the previous step: the `PORTS` field in the output reports that port `80` on the Docker host is mapped to port `80` in the container.


<span id="docker_plus_image"></span>
## Creating custom NGINX Plus Docker Image

As NGINX Plus is a commercial offering, NGINX Plus Docker images are not available at Docker Hub, so first you will need to create an NGINX Plus Docker image.

> **Note:** Never upload your NGINX Plus images to a public repository such as Docker Hub. Doing so violates your license agreement.

To generate a custom NGINX Plus image:

1. Create the Docker build context, or a Dockerfile, for example:

   <script src="https://gist.github.com/nginx-gists/36e97fc87efb5cf0039978c8e41a34b5.js"></script>

2. As with NGINX Open Source, default NGINX Plus image has the same default settings:

    - access and error logs are linked to the Docker log collector
    - no volumes are specified: a Dockerfile can be used to create base images from which you can create new images with volumes specified, or volumes can be specified manually:

    ```dockerfile
    VOLUME /usr/share/nginx/html
    VOLUME /etc/nginx
    ```

    - no files are copied from the Docker host as a container is created: you can add `COPY` definitions to each Dockerfile, or the image you create can be used as the basis for another image

3. Log in to [MyF5 Customer Portal](https://account.f5.com/myf5) and download your *nginx-repo.crt* and *nginx-repo.key* files. For a trial of NGINX Plus, the files are provided with your trial package.

4. Copy the files to the directory where the Dockerfile is located.

5. Create a Docker image, for example, `nginxplus` (note the final period in the command).

    ```shell
    docker build  --no-cache --secret id=nginx-key,src=nginx-repo.key --secret id=nginx-crt,src=nginx-repo.crt -t nginxplus .
    ```

    The `--no-cache` option tells Docker to build the image from scratch and ensures the installation of the latest version of NGINX Plus. If the Dockerfile was previously used to build an image without the `--no-cache` option, the new image uses the version of NGINX Plus from the previously built image from the Docker cache.

6. Verify that the `nginxplus` image was created successfully with the `docker images` command:

    ```shell
    $ docker images nginxplus
    REPOSITORY  TAG     IMAGE ID      CREATED        SIZE
    nginxplus   latest  ef2bf65931cf  6 seconds ago  91.2 MB
    ```

7. Create a container based on this image, for example, `mynginxplus` container:

    ```shell
    docker run --name mynginxplus -p 80:80 -d nginxplus
    ```

8. Verify that the `mynginxplus` container is up and running with the `docker ps` command:

    ```shell
    $ docker ps
    CONTAINER ID  IMAGE             COMMAND               CREATED         STATUS        ...
    eb7be9f439db  nginxplus:latest  "nginx -g 'daemon of  1 minute ago    Up 15 seconds ...

        ... PORTS              NAMES
        ... 0.0.0.0:80->80/tcp mynginxplus
    ```

NGINX Plus containers are controlled and managed in the same way as NGINX Open Source containers.


<span id="manage"></span>
## Managing Content and Configuration Files

Content served by NGINX and NGINX configuration files can be managed in several ways:

- files are maintained on the Docker host
- files are copied from the Docker host to a container
- files are maintained in the container


<span id="manage_host"></span>
### Maintaining Content and Configuration Files on the Docker Host

When the container is created, you can mount a local directory on the Docker host to a directory in the container. The NGINX image uses the default NGINX configuration, which uses `/usr/share/nginx/html` as the container’s root directory and puts configuration files in `/etc/nginx`. For a Docker host with content in the local directory `/var/www` and configuration files in `/var/nginx/conf`, run the command:

```shell
$ docker run --name mynginx2 \
   --mount type=bind,source=/var/www,target=/usr/share/nginx/html,readonly \
   --mount type=bind,source=/var/nginx/conf,target=/etc/nginx/conf,readonly \
   -p 80:80 \
   -d nginxplus
```

Any change made to the files in the local directories `/var/www and /var/nginx/conf` on the Docker host are reflected in the directories `/usr/share/nginx/html` and `/etc/nginx` in the container. The `readonly` option means these directories can be changed only on the Docker host, not from within the container.


<span id="manage_copy"></span>
### Copying Content and Configuration Files from the Docker Host

Docker can copy the content and configuration files from a local directory on the Docker host during container creation. Once a container is created, the files are maintained by creating a new container when files change or by modifying the files in the container.

A simple way to copy the files is to create a Dockerfile with commands that are run during generation of a new Docker image based on the NGINX image. For the file‑copy (COPY) commands in the Dockerfile, the local directory path is relative to the build context where the Dockerfile is located.

Let's assume that the content directory is `content`  and the directory for configuration files is `conf`, both subdirectories of the directory where the Dockerfile is located. The NGINX image has the default NGINX configuration files, including `default.conf`, in the `/etc/nginx/conf.d` directory. To use the configuration files from the Docker host only, delete the default files with the `RUN` command:

```dockerfile
FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY content /usr/share/nginx/html
COPY conf /etc/nginx
```

Create NGINX image by running the command from the directory where the Dockerfile is located. The period (“.”) at the end of the command defines the current directory as the build context, which contains the Dockerfile and the directories to be copied:

```shell
docker build -t mynginx_image1 .
```

Create a container `mynginx3` based on the `mynginx_image1` image:

```shell
docker run --name mynginx3 -p 80:80 -d mynginx_image1
```

To make changes to the files in the container, use a helper container as described in the next section.


<span id="manage_container"></span>
### Maintaining Content and Configuration Files in the Container

As SSH cannot be used to access the NGINX container, to edit the content or configuration files directly you need to create a helper container that has shell access. For the helper container to have access to the files, create a new image that has the proper Docker data volumes defined for the image:

1. Copy nginx content and configuration files and define the volume for the image with the Dockerfile:

    ```dockerfile
    FROM nginx
    COPY content /usr/share/nginx/html
    COPY conf /etc/nginx
    VOLUME /usr/share/nginx/html
    VOLUME /etc/nginx
    ```

2. Create the new NGINX image by running the following command:

    ```shell
    docker build -t mynginx_image2 .
    ```

3. Create an NGINX container `mynginx4` based on the `mynginx_image2` image:

    ```shell
    docker run --name mynginx4 -p 80:80 -d mynginx_image2
    ```

4. Start a helper container `mynginx4_files` that has a shell, providing access the content and configuration directories of the `mynginx4` container we just created:

    ```shell
    $ docker run -i -t --volumes-from mynginx4 --name mynginx4_files debian /bin/bash
    root@b1cbbad63dd1:/#
    ```

    where:
    - the new `mynginx4_files` helper container runs in the foreground with a persistent standard input (the `-i` option) and a tty (the `-t` option). All volumes defined in `mynginx4` are mounted as local directories in the helper container.
    - the `debian` argument means that the helper container uses the Debian image from Docker Hub. Because the NGINX image also uses Debian, it is most efficient to use Debian for the helper container, rather than having Docker load another operating system
    - the `/bin/bash` argument means that the bash shell runs in the helper container, presenting a shell prompt that you can use to modify files as needed

To start and stop the container, run the commands:

```shell
docker start mynginx4_files
docker stop mynginx4_files
```

To exit the shell but leave the container running, press `Ctrl+p` followed by `Ctrl+q`. To regain shell access to a running container, run this command:

```shell
docker attach mynginx4_files
```

To exit the shell and terminate the container, run the `exit` command.


<span id="log"></span>
## Managing Logging

You can use default logging or customize logging.

<span id="log_default"></span>
### Using Default Logging

By default, the NGINX image is configured to send NGINX [access log](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log) and [error log](https://nginx.org/en/docs/ngx_core_module.html#error_log) to the Docker log collector. This is done by linking them to `stdout` and `stderr`: all messages from both logs are then written to the file `/var/lib/docker/containers/container-ID/container-ID-json.log` on the Docker host. The container‑ID is the long‑form ID returned when you [create a container](#docker_oss_image). To display the long form ID, run the command:

```shell
docker inspect --format '{{ .Id }}' container-name
```

You can use both the Docker command line and the Docker Engine API to extract the log messages.

To extract log messages from the command line, run the command:

```shell
docker logs container-name
```

To extract log messages using the Docker Remote API, send a `GET` request using the Docker Unix sock:

```shell
curl --unix-sock /var/run/docker-sock http://localhost/containers/container-name/logs?stdout=1&stderr=1
```

To include only access log messages in the output, include only `stdout=1`. To limit the output to error log messages, include only `stderr=1`. For other available options, see [Get container logs](https://docs.docker.com/engine/api/v1.39/#operation/ContainerLogs) section of the [Docker Engine API](https://docs.docker.com/engine/api/v1.39/) documentation.


<span id="log_custom"></span>
### Using Customized Logging

If you want to configure logging differently for certain configuration blocks (such as `server {}` and `location {}`), define a Docker volume for the directory in which to store the log files in the container, create a helper container to access the log files, and use any logging tools. To implement this, create a new image that contains the volume or volumes for the logging files.

For example, to configure NGINX to store log files in `/var/log/nginx/log`, add a `VOLUME` definition for this directory to the Dockerfile (provided that content and configuration Files are [managed in the container](#manage_container)):

```dockerfile
FROM nginx
COPY content /usr/share/nginx/html
COPY conf /etc/nginx
VOLUME /var/log/nginx/log
```

Then you can [create an image](#docker_plus_image) and use it to create an NGINX container and a helper container that have access to the logging directory. The helper container can have any desired logging tools installed.


<span id="control"></span>
## Controlling NGINX

Since there is no direct access to the command line of the NGINX container, NGINX commands cannot be sent to a container directly. Instead, [signals](https://nginx.org/en/docs/control.html) can be sent to a container via Docker `kill` command.

To reload the NGINX configuration, send the `HUP` signal to Docker:

```shell
docker kill -s HUP container-name
```

To restart NGINX, run this command to restart the container:

```shell
docker restart container-name
```
