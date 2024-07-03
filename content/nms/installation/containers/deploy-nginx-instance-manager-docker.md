---
categories:
- examples
date: "2024-06-06T12:00:00-07:00"
description: 
doctypes:
- tutorial
tags:
- docs
title: Deploy NGINX Instance Manager on Docker
toc: true
versions: []
weight: 100

---

## Overview

This guide explains how to deploy and use F5 NGINX Instance Manager with containers. The NGINX Instance Manager container is built as a single Docker image with all dependencies, allowing for quick setup with open-source NGINX.

This tutorial is designed for:

- Product demos
- Instance counting
- Small-scale environments (≤ 20 instances)

By the end of this guide, you'll be able to:

- Perform a quick test without persistence
- Persist data to a volume
- Set the admin password with an environmental variable
- Override self-signed API gateway certificates
- Configure user access to the container using an `.htpasswd` file.

---

## What You Need

- A working version of [Docker](https://docs.docker.com/get-docker/)
- Your NGINX Instance Manager subscription's JSON Web Token, available from [MyF5](https://my.f5.com/manage/s/subscriptions)

---

## Before You Start

### Set up Docker for NGINX Container Registry

To set up Docker to communicate with the NGINX container registry at `private-registry-test.nginx.com`, follow these steps:

1. Download your NGINX Instance Manager subscription's JSON Web Token and license from [MyF5](https://my.f5.com/manage/s/subscriptions).

   - Log in to the [MyF5](https://my.f5.com/manage/s/subscriptions) customer portal.
   - Go to **My Products and Plans > Subscriptions**.
   - Select the product subscription.
   - Download the JSON Web Token and license files.

2. Open the JSON Web Token file you downloaded from [MyF5](https://my.f5.com/manage/s/subscriptions) and copy its contents.

3. Log in to the Docker registry using the contents of the JSON Web Token file:

   ```bash
   docker login private-registry-test.nginx.com --username=<JWT_CONTENTS> --password=none
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

### Quick Test Without Persistence

1. Run the following Docker command, replacing the placeholders with the appropriate values:
   - `<HOSTNAME>`: desired hostname
   - `<ADMIN_PASSWORD>`: password for the admin account
   - `<VERSION_TAG>`: specific release version you want to use (**note:** `latest` is not supported)

   ```bash
   docker run -it --rm \
     --hostname=<HOSTNAME> \
     -e NMS_PERSIST_DISABLE \
     -e NMS_ADMIN_PASSWORD="<ADMIN_PASSWORD>" \
     -p 8443:443 \
     private-registry-test.nginx.com/nms/nim-bundle:<VERSION_TAG>
   ```

   <br>

   {{< call-out "tip" "Example:" "fas fa-terminal" >}}
   To pull the NGINX Instance Manager 2.17.0 image, set the hostname to "mynim," and set the admin password to "abc123\!@", run:
   ```bash
   docker run -it --rm \
     --hostname=mynim \
     -e NMS_PERSIST_DISABLE \
     -e NMS_ADMIN_PASSWORD="abc123\!@" \
     -p 8443:443 \
     private-registry-test.nginx.com/nms/nim-bundle:2.17.0
   ```
   {{< /call-out >}}

2. Upload the license:
   - In a web browser, go to `https://<YOUR_HOST_IP>:8443` and log in. Replace `<YOUR_HOST_IP>` with the actual IP address or hostname of the machine running the Docker container. If you are accessing it locally, use `https://localhost:8443`.
   - Select the **Settings** gear icon.
   - On the **Settings** menu, select **Licenses**.
   - Select **Get Started**.
   - Select **Browse** to upload the license, or simply drag and drop the license onto the form.
   - Select **Add**.
3. Close the browser to completely log off.
4. Stop and restart the container.
5. Log back in and verify that the license isn't applied.

### Persist to Volume

1. Create or mount a data directory, `<DATA_VOLUME>`, to preserve data if the container restarts.
2. Run the following Docker command, replacing the placeholders with the appropriate values:
   - `<HOSTNAME>`: desired hostname
   - `<ADMIN_PASSWORD>`: password for the admin account
   - `<DATA_VOLUME>`: path to the persistent data directory on the host machine
   - `<VERSION_TAG>`: specific release version you want to use (**note:** `latest` is not supported)

   ```bash
   docker run -it --rm \
     --hostname=<HOSTNAME> \
     --volume=<DATA_VOLUME>:/data \
     -e NMS_ADMIN_PASSWORD="<ADMIN_PASSWORD>" \
     -p 8443:443 \
     private-registry-test.nginx.com/nms/nim-bundle:<VERSION_TAG>
   ```

   <br>

   {{< call-out "tip" "Example:" "fas fa-terminal" >}}
   To pull the NGINX Instance Manager 2.17.0 image, set the hostname to "mynim," set the admin password to "abc123\!@", and write data to `~/nms_storage`, run:

   ```bash
   docker run -it --rm \
     --hostname=mynim \
     --volume=~/nms_storage:/data \
     -e NMS_ADMIN_PASSWORD="abc123\!@" \
     -p 8443:443 \
     private-registry-test.nginx.com/nms/nim-bundle:2.17.0
   ```
   {{< /call-out >}}
3. Upload the license:
   - In a web browser, go to `https://<YOUR_HOST_IP>:8443` and log in. Replace `<YOUR_HOST_IP>` with the actual IP address or hostname of the machine running the Docker container. If you are accessing it locally, use `https://localhost:8443`.
   - Select the **Settings** gear icon.
   - On the Settings menu, select **Licenses**.
   - Select **Get Started**.
   - Select **Browse** to upload the license, or simply drag and drop the license onto the form.
   - Select **Add**.
   - Select **Done**.
4. Close the browser to completely log off.
5. Stop and restart the container.
6. Log back in and verify that the license is still applied.

### Override Self-Signed API Gateway Certificates

1. Ensure you have access to the required certificates:
   - `mycert.pem`
   - `mykey.pem`
   - `myca.pem`
2. Run the following Docker command:
   ```bash
   docker run -it --rm \
     --hostname=mynim \
     -e NMS_ADMIN_PASSWORD="abc123\!@" \
     -e NMS_APIGW_CERT="$(cat mycert.pem)" \
     -e NMS_APIGW_KEY="$(cat mykey.pem)" \
     -e NMS_APIGW_CA="$(cat myca.pem)" \
     --volume=/myvolume/nms:/data \
     -p 8443:443 private-registry-test.nginx.com/nms/nim-bundle:2.17.0
   ```
3. Log in and verify that the certificates are applied correctly.

---

### Create and Use an `.htpasswd` File

In previous examples, the admin password was set using the `NMS_ADMIN_PASSWORD` environment variable. You can also set passwords for the admin and other users using an `.htpasswd` file.

1. Create an `.htpasswd` file on the host machine with an admin user. You will be prompted to enter a password:
   ```bash
   htpasswd -c .htpasswd admin
   ```

2. To add more user passwords, use one of the following commands depending on the desired hashing method:

   {{< call-out "important" "Required: Create new users in the web interface" "fa-solid fa-circle-exclamation" >}}
   Additional users must be created using the web interface first. If users are added only to the `.htpasswd` file and not in the web interface, they will not be able to log in. The web interface creates the users but doesn't support adding passwords, while the `.htpasswd` file adds the passwords but doesn't create the users. For instructions on adding users using the web interface, see [Creating Users]({{< relref "nms/admin-guides/authentication/basic-authentication.md#create-users" >}}).
   {{</call-out>}}

   - For MD5 hash:
     ```bash
     htpasswd -m .htpasswd user1
     ```
   - For SHA hash:
     ```bash
     htpasswd -s .htpasswd user2
     ```

   {{<note>}}NGINX does not support bcrypt password hashing.{{</note>}}

3. To pass the `.htpasswd` file at runtime, run the following command, replacing the placeholders with the appropriate values:
   - `<HOSTNAME>`: desired hostname
   - `<HTPASSWD_VOLUME>`: path to the directory containing the `.htpasswd` file on the host machine
   - `<DATA_VOLUME>`: path to the persistent data directory on the host machine
   - `<VERSION_TAG>`: specific release version you want to use (**Note:** `latest` is not supported)

   ```bash
   docker run -it --rm \
     --hostname=<HOSTNAME> \
     --volume=<HTPASSWD_VOLUME>/.htpasswd:/.htpasswd \
     --volume=<DATA_VOLUME>:/data \
     -p 8443:443 private-registry-test.nginx.com/nms/nim-bundle:<VERSION_TAG>
   ```

   {{<important>}}The admin user must be included in the `.htpasswd` file, or the container will not start.{{</important>}}

   <br>

   {{< call-out "tip" "Example:" "far fa-terminal" >}}
   To pull the NGINX Instance Manager 2.17.0 image, set the hostname to "mynim," pass in the `/home/ubuntu/nim-auth/.htpasswd` file, and write data to `/home/ubuntu/nim_storage`, run:

   ```bash
   docker run -it --rm \
     --hostname=mynim \
     --volume=/home/ubuntu/nim-auth/.htpasswd:/.htpasswd \
     --volume=/home/ubuntu/nim-storage:/data \
     -p 8443:443 private-registry-test.nginx.com/nms/nim-bundle:2.17.0
   ```

   {{</call-out>}}

4. To copy an updated `.htpasswd` file to a running container, use the following command, replacing the placeholders with the appropriate values:
   - `<HTPASSWD_VOLUME>`: path to the directory containing the `.htpasswd` file on the host machine
   - `<CONTAINER_NAME>`: name of the running container

   ```bash
   docker cp <HTPASSWD_VOLUME>/.htpasswd <CONTAINER_NAME>:/data/local-auth/.htpasswd
   ```

   <br>

   {{< call-out "tip" "Example:" "far fa-terminal" >}}
   ```bash
   docker cp /home/ubuntu/nim-auth/.htpasswd nginx-instance:/data/local-auth/.htpasswd
   ```
   {{</call-out>}}

   <br>
   
   {{<call-out "tip" "Tip: How to find a container's name" "far fa-lightbulb" >}}
   To find a container's name, use the `docker ps` command, which lists all running containers along with their names.
   {{</call-out>}}

5. Verify you can log in with the provided usernames and passwords.
  
   In a web browser, go to `https://<YOUR_HOST_IP>:8443` and log in. Replace `<YOUR_HOST_IP>` with the actual IP address or hostname of the machine running the Docker container. If you are accessing it locally, use `https://localhost:8443`.
