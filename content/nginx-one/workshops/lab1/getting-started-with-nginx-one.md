---
title: "Lab 1: Get started with NGINX One Console"
weight: 100
toc: true
nd-content-type: tutorial
nd-product: NGINX-ONE
---

## Introduction

In this lab, you’ll log in to NGINX One Console, explore its main features, and create a data plane key to register NGINX instances.

NGINX One Console is a cloud service in the F5 Distributed Cloud platform. It lets you:

- Manage all NGINX instances in one place
- Monitor performance and health metrics
- Detect security risks like expired SSL certificates or known vulnerabilities
- Track software versions
- Get performance tips

Instead of switching between tools, you get one dashboard with real-time data and alerts.

---

## What you’ll learn

By the end of this tutorial, you can:

- Open and use NGINX One Console
- Understand how NGINX One Console works
- Create, copy, and store a data plane key
- Revoke or delete a data plane key

---

## Before you begin

You need:

- An F5 Distributed Cloud (XC) account
- NGINX One service enabled
- Basic Linux and NGINX knowledge

{{< include "/nginx-one/cloud-access.md" >}}

---

## How NGINX One Console works

NGINX One Console connects to each NGINX instance through **NGINX Agent**, a lightweight process that enables secure communication between the instance and NGINX One Console.  
NGINX Agent applies configuration updates from NGINX One Console, collects performance and operating system metrics, and sends event notifications from the instance.

You can install NGINX Agent in several ways:

- Use public Docker images of NGINX Open Source with NGINX Agent preinstalled
- Use public Docker images of NGINX Plus with NGINX Agent preinstalled
- Install manually with `apt` or `yum`
- Use the one-line `curl` command provided during registration

When you register a new instance, NGINX One Console gives you a `curl` command that downloads and installs NGINX Agent on your target system.

A data plane key is required to connect an instance to NGINX One Console. Once connected, you can monitor and manage the instance from the NGINX One Console dashboard.

For more about NGINX Agent, see the [NGINX Agent overview]({{< ref "/nginx-one/agent/overview/about.md" >}}).

---

## Open NGINX One Console

{{< include "/nginx-one/cloud-access-nginx.md" >}}


Until you add NGINX instances are connected, the NGINX One Console dashboard remains empty. After you add instances, the dashboard shows metrics like availability, version, and usage trends.

---

## Create a data plane key

1. In NGINX One Console, go to **Manage > Data Plane Keys**.
2. Select **Add Data Plane Key**.
3. Enter a name for the data plane key.
4. Set an expiration date, or use the one-year default.
5. Select **Generate**.
6. Copy the data plane key — **you can’t view it again**.
7. Store the data plane key in a safe place.

You can use the same data plane key to register multiple instances. If you lose the data plane key, create a new one.

---

## Revoke a data plane key

1. In NGINX One Console, go to **Manage > Data Plane Keys**.
2. Find the data plane key you want to revoke.
3. Select the data plane key.
4. Choose **Revoke**, and confirm.

---

## Delete a revoked data plane key

You can only delete a data plane key after you revoke it.

1. In NGINX One Console, go to the **Revoked Keys** tab.
2. Find the data plane key you want to delete.
3. Select the data plane key.
4. Choose **Delete Selected**, and confirm.

---

## Next steps

You’re ready to connect your first NGINX instance to NGINX One Console.  
Go to [Lab 2: Run workshop components with Docker]({{< ref "nginx-one/workshops/lab2/run-workshop-components-with-docker.md" >}})

---

## References

- [Create and manage data plane keys]({{< ref "nginx-one/connect-instances/create-manage-data-plane-keys.md" >}})
- [NGINX Agent overview]({{< ref "/nginx-one/agent/overview/about.md" >}})