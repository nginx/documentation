ARG HUGO_VERSION=0.152.2
FROM ghcr.io/gohugoio/hugo:v${HUGO_VERSION}

# Docker build containers do not inherit the host's trusted CA certificates.
# Install F5's Netskope TLS-inspection CA before downloading Hugo modules.
ARG NETSKOPE_CA_URL=https://cdn.f5.com/apps/netskope/f5-netskope-bundle.pem
ARG NETSKOPE_CA_SHA256=ae8a2b0668e3b508fa2f1b4d8c98d5bd367fef58c9fd7357aaa47e6312ad6a22

USER root
RUN set -eu; \
    wget -qO /tmp/netskope-ca.pem "${NETSKOPE_CA_URL}"; \
    echo "${NETSKOPE_CA_SHA256}  /tmp/netskope-ca.pem" | sha256sum -c -; \
    awk '/-----BEGIN CERTIFICATE-----/{n++} n { print > ("/usr/local/share/ca-certificates/f5-netskope-" n ".crt") }' \
        /tmp/netskope-ca.pem; \
    rm /tmp/netskope-ca.pem; \
    update-ca-certificates

USER hugo

EXPOSE 1313
CMD ["server", "--bind", "0.0.0.0", "--port", "1313", "--disableFastRender"]
