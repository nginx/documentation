---
categories:
- examples
date: "2024-06-06T12:00:00-07:00"
description: This topic explains how to deploy and use Instance Manager with containers.
doctypes:
- tutorial
tags:
- docs
title: Running NMS as a single docker container
toc: true
versions: []
weight: 700

---

## Overview
NIM Bundled (Nimble) builds the product as a single Docker image with all dependencies.

The supported use cases are:
* Product demos
* Instance counting
* Small scale environments (<= 20 instances)

By the end of this tutorial, you'll be able to:
* Run the Docker container in the various configuration modes
    * No persistence
    * Persistence to volume mount
    * Set the admin password
    * Override self signed APIGW certs
* Configure user access to the container

## Background

The purpose of this docker container is to allow users to quickly set up NMS with OSS nginx, via a docker container. 
Its main use cases are for Instance counting of NGINX instances, product demos and small scale environment

## Before you start

- A working version of docker
- Access to the nginx private registry `http://private-registry.nginx.com/` or from  `myF5.com`  and ability to pull the container: `nim-bundle:latest`

## Data Persistence

- A single volume mount is required to persist the NIM databases, for example: `--volume=/myvolume/nms:/data`
- An optional volume can be used to add a custom `.htpasswd` file for admin and user authentication, for example: `--volume=/myvolume/pass/.htpasswd:/.htpasswd`

## Supported Environment Variables

- `NMS_PERSIST_DISABLE`: Do not persist data to a volume. All data will be lost after the container stops or restarts.
- `NMS_ADMIN_PASSWORD`: Set an admin password.
- `NMS_APIGW_CERT`: Override the APIGW self-signed certificate.
- `NMS_APIGW_KEY`: Override the APIGW self-signed key.
- `NMS_APIGW_CA`: Override the APIGW self-signed CA.
- `LOG_LEVEL`: Set the NIM logging level.

## NMS Build Examples

To get started, you should ensue have access to the repo `http://private-registry.nginx.com/` or from  `myF5.com` and ability to pull the container: `nim-bundle:latest`
you have pulled the NIM docker container

### Quick Test without Persistence

1. Run the following docker command:
  ```bash 
     docker run -it --rm --hostname=mynim -e NMS_PERSIST_DISABLE -p 8443:443 nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/nim-bundled-poc/nim-bundle:latest
   ```
2. Upload license and restart service
3. Log on and see that license is not applied

### Persist to Volume

1. Create/Mount your directory `$YOUR_DIRECTORY` on host machine
2. Run the following docker command: 
```bash 
   docker run -it --rm --hostname=mynim --volume=$YOUR_DIRECTORY:/data -p 8443:443 nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/nim-bundled-poc/nim-bundle:latest
   ```
3. Upload license and restart service
4. Log on and see that license is still applied

### Set Admin Password via Environment Variable

2. Run the following docker command: 
```bash 
docker run -it --rm --hostname=mynim -e NMS_ADMIN_PASSWORD="admin" --volume=/myvolume/nms:/data -p 8443:443 nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/nim-bundled-poc/nim-bundle:latest
```
2. Upload license and restart service
4. Log on with the admin password passed set via the environment variable

### Override Self-Signed APIGW Certificates

1. Ensure you have access to the required certificates e.g.:
    1. mycert.pem
    2. mykey.pem
    3. myca.pem
2. Run the following docker command:
```bash 
docker run -it --rm --hostname=mynim -e NMS_ADMIN_PASSWORD="abc123\!@" -e NMS_APIGW_CERT="$(cat mycert.pem)" -e NMS_APIGW_KEY="$(cat mykey.pem)" -e NMS_APIGW_CA="$(cat myca.pem)" --volume=/myvolume/nms:/data -p 8443:443 nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/nim-bundled-poc/nim-bundle:latest
```
3. Login and verify that the certs are applied correctly


### Create and Pass in .htpasswd file

1. To create a .htpasswd file with an admin user on the host machine run the following: 
  ```bash 
  htpasswd -c .htpasswd admin
  ```
2. To add more users you can run either of the below commands depending on if you need `MD5` or `SHA`
 ```bash
 htpasswd -m .htpasswd rufus1   # Add a user called rufus1 to an existing .htpasswd file - this will hash in MD5 with -m
 htpasswd -s .htpasswd rufus2   # Add a user called rufus2 to an existing .htpasswd file - this will hash in SHA with -s
 ```
   _Note: bcrypt is not supported by NGINX; thus will not work.
3. To pass the .htpasswd file at runtime run the following command: 
```bash
   docker run -it --rm --hostname=mynim --volume=/myvolume/pass/.htpasswd:/.htpasswd --volume=/myvolume/nms:/data -p 8443:443 nim-bundle:latest
```
_Note: the admin user will have to be contained in the file or the container will not start._

4. Verify you can log on with the provided usernames and passwords.
5. To pass in a .htpasswd file for a running container use the following command: 
```bash 
docker cp .htpasswd <container_name>:/data/local-auth/.htpasswd
   ```


## Summary

In this tutorial, you learned how to:

* Run the Docker container in the various configuration modes:
  * No persistence
  * Persistence
  * Set the admin password
  * Override self signed APIGW certs
* Configure user access to NMS running in the container

