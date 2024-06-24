---
categories:
- examples
date: "2024-06-06T12:00:00-07:00"
description: 
doctypes:
- tutorial
tags:
- docs
title: Deploy NGINX Instance Manager with containers
toc: true
versions: []
weight: 

---

## Overview

This guide explains how to deploy and use F5 NGINX Instance Manager with containers. Built as a single Docker image with all dependencies, this container allows you to quickly set up NGINX Instance Manager with open-source NGINX.

This tutorial is designed for:

- Product demos
- Instance counting
- Small-scale environments (≤ 20 instances)

By the end of this guide, you will be able to:

- Run the Docker container in various configuration modes:
  - No persistence
  - Persistence to volume mount
  - Set the admin password
  - Override self-signed API gateway certificates
- Configure user access to the container

---

## What You Need

- A working version of Docker
- Access to the NGINX private registry at `http://private-registry.nginx.com/` or from `myF5.com` to pull the container: `nim-bundle:latest`

To set up Docker to communicate with the NGINX private registry, follow these steps:

1. Create a directory for the Docker certificates:
   ```bash
   mkdir -p /etc/docker/certs.d/private-registry.nginx.com
   ```

2. Copy your certificate and key to the directory:
   ```bash
   cp <path-to-your-nginx-repo.crt> /etc/docker/certs.d/private-registry.nginx.com/client.cert
   cp <path-to-your-nginx-repo.key> /etc/docker/certs.d/private-registry.nginx.com/client.key
   ```

   **Note:** Replace `<path-to-your-nginx-repo.crt>` and `<path-to-your-nginx-repo.key>` with the actual paths to your certificate and key files.

The steps provided are for Linux. For Mac or Windows, consult the [Docker for Mac](https://docs.docker.com/docker-for-mac/#add-client-certificates) or [Docker for Windows](https://docs.docker.com/docker-for-windows/#how-do-i-add-client-certificates) documentation. For more details on Docker Engine security, you can refer to the [Docker Engine Security documentation](https://docs.docker.com/engine/security/).

---

## Data Persistence

- A single volume mount is required to persist the NGINX Instance Manager databases. For example: `--volume=/myvolume/nms:/data`
- An optional volume can be used to add a custom `.htpasswd` file for admin and user authentication. For example: `--volume=/myvolume/pass/.htpasswd:/.htpasswd`

---

## Supported Environment Variables

- `NMS_PERSIST_DISABLE`: Do not persist data to a volume. All data will be lost after the container stops or restarts.
- `NMS_ADMIN_PASSWORD`: Set an admin password.
- `NMS_APIGW_CERT`: Override the API gateway self-signed certificate.
- `NMS_APIGW_KEY`: Override the API gateway self-signed key.
- `NMS_APIGW_CA`: Override the API gateway self-signed CA.
- `LOG_LEVEL`: Set the logging level for NGINX Instance Manager.

---

## Preparation Steps

Ensure you have access to the NGINX private repository at `http://private-registry.nginx.com/` or `myF5.com` to pull pull the container: `nim-bundle:latest`.

### Quick Test Without Persistence

1. Run the following Docker command:
   ```bash
   docker run -it --rm \
     --hostname=mynim \
     -e NMS_PERSIST_DISABLE \
     -p 8443:443 \
     nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/nim-bundled-poc/nim-bundle:latest
   ```
2. Upload the license:
   - In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
   - Select the Settings gear icon.
   - On the Settings menu, select **Licenses**.
   - Select **Get Started**.
   - Select **Browse** to upload the license, or simply drag and drop the license onto the form.
   - Select **Add**.
   - Select **Done**.
3. Close the browser to completely log off.
4. Restart the service:
   ```bash
   sudo systemctl restart nms
   ```
5. Log on and verify that the license isn't applied.

### Persist To Volume

1. Create or mount your directory `$YOUR_DIRECTORY` on the host machine.
2. Run the following Docker command:
   ```bash
   docker run -it --rm \
     --hostname=mynim \
     --volume=$YOUR_DIRECTORY:/data \
     -p 8443:443 \
     nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/nim-bundled-poc/nim-bundle:latest
   ```
3. Upload the license:
   - In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
   - Select the Settings gear icon.
   - On the Settings menu, select **Licenses**.
   - Select **Get Started**.
   - Select **Browse** to upload the license, or simply drag and drop the license onto the form.
   - Select **Add**.
   - Select **Done**.
4. Close the browser to completely log off.
5. Restart the service:
   ```bash
   sudo systemctl restart nms
   ```
6. Log on and verify that the license is still applied.

### Set Admin Password with an Environment Variable

1. Run the following Docker command:
   ```bash
   docker run -it --rm \
     --hostname=mynim \
     -e NMS_ADMIN_PASSWORD="admin" \
     --volume=/myvolume/nms:/data \
     -p 8443:443 \
     nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/nim-bundled-poc/nim-bundle:latest
   ```
2. Upload the license:
   - In a web browser, go to the FQDN for your NGINX Management Suite host and log in.
   - Select the Settings gear icon.
   - On the Settings menu, select **Licenses**.
   - Select **Get Started**.
   - Select **Browse** to upload the license, or simply drag and drop the license onto the form.
   - Select **Add**.
   - Select **Done**.
3. Close the browser to completely log off.
4. Restart the service:
   ```bash
   sudo systemctl restart nms
   ```
5. Log on with the admin password set with the environment variable.

### Override Self-Signed API Gateway Certificates

1. Ensure you have access to the required certificates:
   - `mycert.pem`
   - `mykey.pem`
   - `myca.pem`
2. Run the following Docker command:
   ```bash
   docker run -it --rm --hostname=mynim -e NMS_ADMIN_PASSWORD="abc123\!@" -e NMS_APIGW_CERT="$(cat mycert.pem)" -e NMS_APIGW_KEY="$(cat mykey.pem)" -e NMS_APIGW_CA="$(cat myca.pem)" --volume=/myvolume/nms:/data -p 8443:443 nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/nim-bundled-poc/nim-bundle:latest
   ```
3. Log in and verify that the certificates are applied correctly.

### Create And Pass In .htpasswd File

1. To create a `.htpasswd` file with an admin user on the host machine, run the following command:
   ```bash
   htpasswd -c .htpasswd admin
   ```
2. To add more users, run one of the following commands depending on whether you need MD5 or SHA:
   ```bash
   htpasswd -m .htpasswd user1   # MD5 hash
   htpasswd -s .htpasswd user2   # SHA hash
   ```
   **Note:** bcrypt is not supported by NGINX.
3. To pass the `.htpasswd` file at runtime, run the following command:
   ```bash
   docker run -it --rm --hostname=mynim --volume=/myvolume/pass/.htpasswd:/.htpasswd --volume=/myvolume/nms:/data -p 8443:443 nim-bundle:latest
   ```
   **Note:** The admin user must be included in the file or the container will not start.
4. Verify you can log in with the provided usernames and passwords.
5. To pass in a `.htpasswd` file for a running container, use the following command:
   ```bash
   docker cp .htpasswd <container_name>:/data/local-auth/.htpasswd
   ```

---

## Summary

In this tutorial, you learned how to:

- Run the Docker container in various configuration modes:
  - No persistence
  - Persistence to volume mount
  - Set the admin password
  - Override self-signed API gateway certificates
- Configure user access to NGINX Management Suite running in the container

---

## Next Steps

Explore further deployment options or additional tutorials to enhance your NGINX Management Suite setup.