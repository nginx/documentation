################################################################
FROM debian:buster-slim

LABEL maintainer="NGINX Agent Engineering"

# APT non-interactive during build
ARG DEBIAN_FRONTEND=noninteractive

ARG CONTROL_PLANE_IP
ENV CONTROL_PLANE_IP=$CONTROL_PLANE_IP

# Install NGINX Agent
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    curl \
    gnupg \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    procps \
# NGINX is included in the dockerfile here, can be modified as needed, this adds the OSS image by default.
    nginx \
  && curl -k https://$CONTROL_PLANE_IP/install/nginx-agent | sh \
# Forward request and error logs to docker log collector \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log 

# Cleanup \
RUN apt-get autoremove --purge -y \
       curl \
       gnupg \
       apt-transport-https \
       lsb-release \
  && rm -rf /root/.gnupg \
  && rm -rf /var/lib/apt/lists/* 

COPY entrypoint.sh /

STOPSIGNAL SIGTERM

CMD bash /entrypoint.sh
