---
title: "Lab 2: Run workshop components with Docker"
weight: 200
toc: true
nd-content-type: tutorial
nd-product: nginx-one
---

## Introduction

This guide shows you how to run a demo backend application and multiple NGINX OSS and Plus containers with Docker. The backend application runs in three `nginxinc/ingress-demo` containers, each serving a simple web page. You’ll also link each NGINX container to NGINX One Console for management and monitoring.

## What you’ll learn

By the end of this tutorial, you’ll know how to:

- Set up environment variables for your data plane key and license
- Log in to the NGINX private registry
- Generate self-signed certificates
- Run Docker Compose to start 9 containers
- Verify your containers in Docker and in NGINX One Console

## Before you begin

Make sure you have:

- An F5 Distributed Cloud (XC) account
- NGINX One service enabled in your XC account
- Docker and Docker Compose installed and running
- An active data plane key from [Lab 1: Get started with NGINX One Console]({{< ref "nginx-one/workshops/lab1/getting-started-with-nginx-one.md" >}})
- A trial or paid NGINX Plus JWT license (saved as `nginx-repo.jwt`) from [MyF5](https://my.f5.com/manage/s/).
- Basic Linux and NGINX know-how
- Git installed and SSH key set up for GitHub access

---

## Clone the NGINX documentation repo

1. **Clone the repo via SSH**

   ```shell
   git clone git@github.com:nginx/documentation.git
   ```

2. **Change to the Lab 2 directory**

   ```shell
   cd workshops/nginx-one/lab2
   ```

This folder contains `docker-compose.yml` and `generate_certs.sh`.

---

## Set environment variables

1. **Set your data plane key**

   ```shell
   export TOKEN="paste-your-data-plane-key-here"
   echo "$TOKEN"
   ```

2. **Set your NGINX Plus JWT**

   ```shell
   export JWT=$(cat path/to/nginx-repo.jwt)
   echo "$JWT"
   ```

3. **Give your setup a unique name**

   Replace `your.initials` with something that identifies you or your setup (for example, `s.jobs`)

   ```shell
   export NAME="your.initials"
   echo "$NAME"
   ```

---

## Log in to the private registry

Pipe your JWT into Docker login:

```shell
echo "$JWT" | docker login private-registry.nginx.com \
  --username "$JWT" --password-stdin
```

You should see **Login Succeeded**.

---

## Generate certificates

Run the script to create self-signed certs:

```shell
chmod +x generate_certs.sh
./generate_certs.sh
```

This creates `1-day.key`, `1-day.crt`, `30-day.key`, and `30-day.crt` in the `nginx-oss/etc/ssl/nginx` subfolder.

---

## Run Docker Compose

Start all nine containers in detached mode:

```shell
docker compose up --force-recreate -d
```

Wait until you see "Started" for each container.

---

## Verify containers

1. **Check Docker**

   ```shell
   docker ps | grep "$NAME"
   ```

   You should see 9 containers listed.

2. **Check NGINX One Console**

   - Go to the **Instances** page in the NGINX One Console
   - Refresh and search by your `$NAME` (for example, `s.jobs`)
   - Confirm each instance shows a green **Online* icon.

If you don’t see them, double-check your `$TOKEN` or generate a new data plane key.

---

## Next steps

Now that your containers are up and registered, go on to explore NGINX One Console features in Lab 3.

[Go to Lab 3 →](../lab3/readme.md)

---

## References

- [NGINX One Console docs](https://docs.nginx.com/nginx-one/)
- [NGINX Agent overview](https://docs.nginx.com/nginx-agent/overview/)
