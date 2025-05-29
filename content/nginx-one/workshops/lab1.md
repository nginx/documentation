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

NGINX One Console connects to each NGINX instance using a lightweight agent called **NGINX Agent**.

The agent is responsible for securely registering and managing each instance through the console.

There are a few ways to install NGINX Agent:

- Use public Docker images of NGINX OSS that already include the agent
- Use NGINX Plus containers with the agent preinstalled
- Install manually using package managers like `apt` or `yum`
- Use the one-line curl command that NGINX One provides during registration

When you register a new instance in the console, you'll get a ready-to-use `curl` command that downloads and installs the NGINX Agent on your target system.

For more information about NGINX Agent, see the [NGINX Agent documentation](https://docs.nginx.com/nginx-agent/overview/).

---

## Open and use NGINX One Console

1. Go to [https://console.ves.volterra.io/login/start](https://console.ves.volterra.io/login/start).
2. Sign in using your Distributed Cloud account.
3. On the home page, find the **NGINX One** tile.
4. Select the tile to open the console.
5. Make sure the service status shows **Enabled**.
6. Select **Visit Service** to go to the **Overview** dashboard.

If NGINX One Console isn’t enabled, contact your XC administrator to request access.

When no NGINX instances are connected, the dashboard will be empty. Once you add instances, it will show metrics like availability, version, and usage trends.

---

## Create and save a data plane key

To register NGINX instances, you need a data plane key.

1. In the console, go to **Manage > Data Plane Keys**.
2. Select **Add Data Plane Key**.
3. Enter a name for the key.
4. Set an expiration date (or keep the default of one year).
5. Select **Generate**.
6. Copy the key when it appears—**you won’t be able to see it again**.
7. Save it somewhere safe.

You can use the same key to register many instances. If you lose the key, you’ll need to create a new one.

---

## (Optional) Revoke a data plane key

To disable a key:

1. On the **Data Plane Keys** page, find the key you want to revoke.
2. Select the key.
3. Choose **Revoke**, then confirm.

---

## (Optional) Delete a revoked key

You can only delete a key after you revoke it.

1. On the **Revoked Keys** tab, find the key you want to delete.
2. Select the key.
3. Choose **Delete Selected**, then confirm.

---

## Next steps

Now that you’ve explored NGINX One Console and created a key, you’re ready to connect your first NGINX instance.

[Go to Lab 2 →](../lab2/readme.md)

---

## References

- [Create and manage data plane keys]({{< ref "nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys.md" >}})
- [NGINX Agent overview]({{< ref "agent/overview.md" >}})