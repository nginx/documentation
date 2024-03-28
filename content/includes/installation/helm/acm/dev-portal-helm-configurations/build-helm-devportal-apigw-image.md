---
docs: DOCS-1310
---

The Developer Portal Helm chart requires a container image that includes the NGINX Plus service and NGINX Agent in order to deploy the chart and have the API Gateway register with the API Connectivity Manager control plane.

In this example, we use Ubuntu (focal), but other supported distributions can be used.

<details closed>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "tech-specs/acm-dev-portal-supported-distros.md" >}}

</details>

Create a Dockerfile similar to the following example:

1. Create a Dockerfile similar to the following example:

    <details closed>
    <summary><i class="fa-solid fa-circle-info"></i> Example Dockerfile</summary>

    {{< fa "download" >}} {{< link "/acm/containers/devportal/Dockerfile" "Download example Dockerfile" >}}

    ```Dockerfile
    FROM ubuntu:focal

    # NGINX Plus release e.g 27
    ARG NGINX_PLUS_VERSION

    # DEVPORTAL release e.g 1.3.0
    ARG DEVPORTAL_UI_VERSION

    ARG CONTROL_PLANE_IP

    # Install NGINX Plus
    RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
        --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    set -ex \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        curl \
        gnupg \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        procps \
    && \
    NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
    for server in \
        hkp://keyserver.ubuntu.com:80 \
        pgp.mit.edu; do \
        echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
        gpg --keyserver "$server" \
            --recv-keys "$NGINX_GPGKEY" \
            && break; \
    done \
    # Configure APT repos
    && gpg --export "$NGINX_GPGKEY" > /etc/apt/trusted.gpg.d/nginx.gpg \
    && printf "Acquire::https::pkgs.nginx.com::SslCert \"/etc/ssl/nginx/nginx-repo.crt\";\n" >> /etc/apt/apt.conf.d/90pkgs-nginx \
    && printf "Acquire::https::pkgs.nginx.com::SslKey  \"/etc/ssl/nginx/nginx-repo.key\";\n" >> /etc/apt/apt.conf.d/90pkgs-nginx \
    && printf "deb https://pkgs.nginx.com/plus/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-plus.list \
    && printf "deb https://pkgs.nginx.com/nms/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nms.list \
    && apt-get update \
    # Install NGINX Plus & agent\
    && apt-get install -y \
            nginx-plus=${NGINX_PLUS_VERSION}* \
            nginx-plus-module-njs=${NGINX_PLUS_VERSION}* \
            nginx-devportal-ui=${DEVPORTAL_UI_VERSION}* \
    && curl --insecure https://$CONTROL_PLANE_IP/install/nginx-agent | PACKAGE_HOST=${CONTROL_PLANE_IP} sh \
    # Forward request and error logs to docker log collector \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Cleanup \
    && apt-get autoremove --purge -y \
        curl \
        gnupg \
        apt-transport-https \
        lsb-release \
    && rm -rf /root/.gnupg \
    && rm -rf /etc/apt/sources.list.d/nginx-plus.list /etc/apt/sources.list.d/nms.list /etc/apt/apt.conf.d/90pkgs-nginx \
    && rm -rf /var/lib/apt/lists/*

    COPY /entrypoint.sh /

    STOPSIGNAL SIGTERM

    CMD bash /entrypoint.sh
    ```

    <br>

    </details>

2. Add an `entrypoint.sh` file similar to the following example to the same directory where you added the Dockerfile:

    <details closed>
      <summary><i class="fa-solid fa-circle-info"></i> Example entrypoint.sh</summary>

    {{< fa "download" >}} {{< link "/acm/containers/devportal/entrypoint.sh" "Download example entrypoint.sh file" >}}

    ```bash
    #!/bin/bash

    set -euxo pipefail

    handle_term()
    {
        echo "received TERM signal"
        echo "stopping nginx-agent ..."
        kill -TERM "${agent_pid}" 2>/dev/null
        echo "stopping nginx ..."
        kill -TERM "${nginx_pid}" 2>/dev/null
    }

    trap 'handle_term' TERM

    if [ -z "${CONTROL_PLANE_IP}" ]; then
        echo "ERROR CONTROL_PLANE_IP environment variable needs to be set."
        exit 1
    fi

    if [ -z "${INSTANCE_GROUP}" ]; then
        echo "ERROR INSTANCE_GROUP environment variable needs to be set."
        exit 1
    fi

    # Launch nginx
    echo "starting nginx ..."
    nginx -g "daemon off;" &

    nginx_pid=$!

    # start nginx-agent, pass args
    echo "starting nginx-agent ..."
    nginx-agent --instance-group "${INSTANCE_GROUP}" --server-host "${CONTROL_PLANE_IP}" &

    agent_pid=$!

    wait_term()
    {
        wait ${agent_pid}
        trap - TERM
        kill -QUIT "${nginx_pid}" 2>/dev/null
        echo "waiting for nginx to stop..."
        wait ${nginx_pid}
    }

    wait_term

    echo "nginx-agent process has stopped, exiting."
    ```

    <br>

    </details>

3. Add your NGINX Plus certificate and key files to the same directory as the Dockerfile. You can download these files from the [MyF5](https://my.f5.com/manage/s/) site.

4. Build the Dockerfile and specify the following settings:

   - `CONTROL_PLANE_IP`: The IP address or hostname of your API Connectivity Manager control plane host
   - `NGINX_PLUS_VERSION`: The version of NGINX Plus that you want to use; for example, `28`
   - `DEVPORTAL_UI_VERSION`: The version of the Developer Portal UI that you want to use; for example, `1.5.0`

    ```bash
    export CONTROL_PLANE_IP=<NGINX-INSTANCE-MANAGER-FQDN>
    export NGINX_PLUS_VERSION=<NGINX-PLUS-VERSION>
    export DEVPORTAL_UI_VERSION=<ACM-VERSION>
    export DEVPORTAL_UI_TAG=${DEVPORTAL_UI_VERSION}-r${NGINX_PLUS_VERSION}
    export DOCKER_BUILDKIT=1
    docker build \
      -t nginx-devportal-apigw:$DEVPORTAL_UI_TAG \
      --build-arg CONTROL_PLANE_IP \
      --build-arg NGINX_PLUS_VERSION \
      --build-arg DEVPORTAL_UI_VERSION \
      --secret id=nginx-crt,src=nginx-repo.crt \
      --secret id=nginx-key,src=nginx-repo.key \
      .
    ```
