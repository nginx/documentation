---
categories:
- examples
date: "2024-06-06T12:00:00-07:00"
description: 
doctypes:
- tutorial
tags:
- docs
title: Deploy NGINX Instance Manager with Containers
toc: true
versions: []
weight: 

---

## Overview

This guide explains how to deploy and use F5 NGINX Instance Manager with containers. The NGINX Instance Manager container is built as a single Docker image with all dependencies, allowing for quick setup with open-source NGINX.

This tutorial is designed for:

- Product demos
- Instance counting
- Small-scale environments (≤ 20 instances)

By the end of this guide, you'll be able to:

- Run the Docker container in various configuration modes:
  - No persistence
  - Persistence to volume mount
  - Set the admin password
  - Override self-signed API gateway certificates
- Configure user access to the container

---

## What You Need

- A working version of [Docker](https://docs.docker.com/get-docker/)
- Your NGINX Instance Manager subscription's JSON Web Token

---

## Before You Start

### Set up Docker for NGINX Container Registry

To set up Docker to communicate with the NGINX container registry at `private-registry.nginx.com`, follow these steps:

1. Download your NGINX Instance Manager subscription's JSON Web Token and license from [MyF5](https://my.f5.com/manage/s/subscriptions).

   - Log in to the [MyF5](https://my.f5.com/manage/s/subscriptions) customer portal.
   - Go to **My Products and Plans > Subscriptions**.
   - Select the product subscription.
   - Download the JSON Web Token and license files.

2. Open the JSON Web Token file you downloaded from [MyF5](https://my.f5.com/manage/s/subscriptions) (for example, `nginx-manager-subscription-A-12345abc.jwt`) and copy its contents.

3. Log in to the Docker registry using the contents of the JSON Web Token file:

   ```bash
   docker login private-registry.nginx.com --username=<output_of_jwt_token> --password=none
   ```

### Data Persistence

- A single volume mount is required to persist the NGINX Instance Manager databases. For example: `--volume=/myvolume/nms:/data`
- An optional volume can be used to add a custom `.htpasswd` file for admin and user authentication. For example: `--volume=/myvolume/pass/.htpasswd:/.htpasswd`

### Supported Environment Variables

- `NMS_PERSIST_DISABLE`: Do not persist data to a volume. All data will be lost after the container stops or restarts.
- `NMS_ADMIN_PASSWORD`: Set an admin password.
- `NMS_APIGW_CERT`: Override the API gateway self-signed certificate.
- `NMS_APIGW_KEY`: Override the API gateway self-signed key.
- `NMS_APIGW_CA`: Override the API gateway self-signed CA.
- `LOG_LEVEL`: Set the logging level for NGINX Instance Manager.

---

## Build Examples

Ensure you have access to the NGINX private repository at `private-registry.nginx.com/` or `myF5.com` to pull pull the container: `nim-bundle:latest`.

### Quick Test Without Persistence

1. Run the following Docker command:
   ```bash
   docker run -it --rm \
     --hostname=mynim \
     -e NMS_PERSIST_DISABLE \
     -p 8443:443 \
     private-registry.nginx.com/nim-bundle:latest
   ```
2. Upload the license:
   - In a web browser, go to the NGINX Instance Manager host and log in.
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
5. Log back in and verify that the license isn't applied.

### Persist To Volume

1. Create or mount your directory `$YOUR_DIRECTORY` on the host machine.
2. Run the following Docker command:
   ```bash
   docker run -it --rm \
     --hostname=mynim \
     --volume=$YOUR_DIRECTORY:/data \
     -p 8443:443 \
     private-registry.nginx.com/nim-bundle:latest
   ```
3. Upload the license:
   - In a web browser, go to the NGINX Instance Manager host and log in.
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
6. Log back in and verify that the license is still applied.

### Set Admin Password with an Environment Variable

1. Run the following Docker command:
   ```bash
   docker run -it --rm \
     --hostname=mynim \
     -e NMS_ADMIN_PASSWORD="admin" \
     --volume=/myvolume/nms:/data \
     -p 8443:443 \
     private-registry.nginx.com/nim-bundle:latest
   ```
2. Upload the license:
   - In a web browser, go to the NGINX Instance Manager host and log in.
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
5. Log in with the admin password set with the environment variable.

### Override Self-Signed API Gateway Certificates

1. Ensure you have access to the required certificates:
   - `mycert.pem`
   - `mykey.pem`
   - `myca.pem`
2. Run the following Docker command:
   ```bash
   docker run -it --rm --hostname=mynim -e NMS_ADMIN_PASSWORD="abc123\!@" -e NMS_APIGW_CERT="$(cat mycert.pem)" -e NMS_APIGW_KEY="$(cat mykey.pem)" -e NMS_APIGW_CA="$(cat myca.pem)" --volume=/myvolume/nms:/data -p 8443:443 private-registry.nginx.com/nim-bundle:latest
   ```
3. Log in and verify that the certificates are applied correctly.

### Create And Pass In .htpasswd File

1. To create an `.htpasswd` file with an admin user on the host machine, run the following command:
   ```bash
   htpasswd -c .htpasswd admin
   ```
2. To add more users, run one of the following commands depending on whether you need MD5 or SHA:
   ```bash
   htpasswd -m .htpasswd user1   # MD5 hash
   htpasswd -s .htpasswd user2   # SHA hash
   ```
   {{<note>}}bcrypt is not supported by NGINX.{{</note>}}
3. To pass the `.htpasswd` file at runtime, run the following command:
   ```bash
   docker run -it --rm --hostname=mynim --volume=/myvolume/pass/.htpasswd:/.htpasswd --volume=/myvolume/nms:/data -p 8443:443 nim-bundle:latest
   ```
   {{<note>}}The admin user must be included in the file or the container will not start.{{</note>}}
4. Verify you can log in with the provided usernames and passwords.
5. To pass in an `.htpasswd` file for a running container, use the following command:
   ```bash
   docker cp .htpasswd <container_name>:/data/local-auth/.htpasswd
   ```
