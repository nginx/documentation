---
title: "Get started with NGINX One Console"
weight: 100
toc: true
nd-content-type: tutorial
nd-product: NGINX-ONE
---

## Introduction

This guide helps you log in to NGINX One Console and understand the basics of how it works. You’ll learn how to get started, find your way around the console, and manage your NGINX instances using data plane keys.

## What you’ll learn

By the end of this tutorial, you’ll know how to:

- Open and use NGINX One Console
- Understand what NGINX One Console does and how it works
- Create, copy, and save a data plane key
- Revoke or delete a data plane key (optional)

## Before you begin

Make sure you have:

- An F5 Distributed Cloud (XC) account
- NGINX One service enabled in your account
- Basic knowledge of Linux and NGINX

---

## Learn what NGINX One Console does

NGINX One Console is a cloud-based service in the F5 Distributed Cloud platform. It helps you:

- Manage all your NGINX instances from one place
- Monitor performance and health metrics
- Catch security risks like expired SSL certificates and known vulnerabilities
- Keep track of software versions and get performance tips

With NGINX One Console, you don’t need to switch between tools. You get a single dashboard with real-time data and alerts.

---

## How NGINX One Console works

NGINX One Console connects to each NGINX instance using a small agent called **NGINX Agent**.

You can install NGINX Agent by:

- Using public NGINX OSS Docker images with the agent already included
- Using NGINX Plus containers (these already include the agent)
- Installing from Linux package managers like `apt` or `yum`

See the [NGINX Agent docs](https://docs.nginx.com/nginx-agent/overview/) for more details.

---

## Open and use NGINX One Console

1. Go to [https://console.ves.volterra.io/login/start](https://console.ves.volterra.io/login/start).
2. Sign in using your Distributed Cloud account.
3. On the home page, find the **NGINX One** tile.
4. Select the tile to open the console.
5. Make sure the service status shows **Enabled**.
6. Select **Visit Service** to go to the **Overview** dashboard.

If NGINX Console isn’t enabled, contact your XC administrator to request access.

When no NGINX instances are connected, the dashboard will be empty. Once you add instances, it will show metrics like availability, version, and usage trends.

---

## Create and save a data plane key

To register NGINX instances, you need a data plane key.

1. In the console, go to **Manage > Data Plane Keys**
2. Select **Add Data Plane Key**
3. Enter a name for the key
4. Set an expiration date (or keep the default of one year)
5. Select **Generate**
6. Copy the key when it appears—**you won’t be able to see it again**
7. Save it somewhere safe

You can use the same key to register many instances. If you lose the key, you’ll need to create a new one.

---

## (Optional) Revoke a data plane key

To disable a key:

1. In the **Data Plane Keys** page, find the key you want to revoke
2. Select the key
3. Choose **Revoke**, then confirm

---

## (Optional) Delete a revoked key

You can only delete a key after you revoke it.

1. In the **Revoked Keys** tab, find the key you want to delete
2. Select the key
3. Choose **Delete Selected**, then confirm

---

## Next steps

Now that you’ve explored NGINX One Console and created a key, you’re ready to connect your first NGINX instance.

[Go to Lab 2 →](../lab2/readme.md)

---

## References

- [NGINX One Console documentation](https://docs.nginx.com/nginx-one/)
- [NGINX Agent overview](https://docs.nginx.com/nginx-agent/overview/)