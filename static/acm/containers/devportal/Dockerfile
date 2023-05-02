FROM ubuntu:focal

# NGINX Plus release e.g 25
ARG NGINX_PLUS_VERSION

# DEVPORTAL release e.g 1.1.0
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