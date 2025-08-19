---
title: "Lab 1: Get started with NGINX One Console"
weight: 100
toc: true
nd-content-type: tutorial
nd-product: NGINX-ONE
---

## Introduction

In this lab, you’ll log in to NGINX One Console, explore its features, and create a data plane key to register NGINX instances.

NGINX One Console is a cloud service in the F5 Distributed Cloud platform. You can use it to:

- Manage all NGINX instances in one place
- Monitor performance and health metrics
- Detect security risks, such as expired SSL certificates or known vulnerabilities
- Track software versions
- Get performance tips

Instead of switching between tools, you get one dashboard with real-time data and alerts.

---

## What you’ll learn

By the end of this tutorial, you can:

- Open and use NGINX One Console
- Describe how NGINX One Console works
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

NGINX One Console connects to each NGINX instance through **NGINX Agent**, a lightweight process that runs alongside NGINX.  

NGINX Agent enables secure communication with NGINX One Console. It lets you manage configurations remotely, collect and report real-time performance and system metrics, and receive event notifications from your NGINX instance.

You can install NGINX Agent in several ways:

- Use public Docker images of NGINX Open Source with NGINX Agent preinstalled
- Use public Docker images of NGINX Plus with NGINX Agent preinstalled
- Install manually with `apt` or `yum`
- Run the one-line `curl` command provided during registration

When you register a new instance, NGINX One Console gives you a `curl` command to download and install NGINX Agent on your system.

A data plane key is required to connect an instance to NGINX One Console. Once connected, you can monitor and manage the instance from the dashboard.

For more about NGINX Agent, see the [NGINX Agent overview]({{< ref "/nginx-one/agent/overview/about.md" >}}).

---

## Open NGINX One Console

{{< include "/nginx-one/cloud-access-nginx.md" >}}

Until you connect NGINX instances, the NGINX One Console dashboard is empty. After you add instances, the dashboard shows metrics such as availability, version, and usage trends.

---

## Create a data plane key

1. In NGINX One Console, go to **Manage > Data Plane Keys**.
2. Select **Add Data Plane Key**.
3. Enter a name for the key.
4. Set an expiration date, or keep the one-year default.
5. Select **Generate**.
6. Copy the key — **you can’t view it again**.
7. Store the key in a safe place.

You can use the same key to register multiple instances. If you lose it, create a new one.

---

## Revoke a data plane key

1. In NGINX One Console, go to **Manage > Data Plane Keys**.
2. Find the key you want to revoke.
3. Select the key.
4. Choose **Revoke**, and confirm.

---

## Delete a revoked data plane key

You can delete a data plane key only after you revoke it.

1. In NGINX One Console, go to the **Revoked Keys** tab.
2. Find the key you want to delete.
3. Select the key.
4. Choose **Delete Selected**, and confirm.

---

## Next steps

You’re ready to connect your first NGINX instance to NGINX One Console.

Go to [Lab 2: Run workshop components with Docker]({{< ref "nginx-one/workshops/lab2/run-workshop-components-with-docker.md" >}}).

---

## References

- [Create and manage data plane keys]({{< ref "nginx-one/connect-instances/create-manage-data-plane-keys.md" >}})
- [NGINX Agent overview]({{< ref "/nginx-one/agent/overview/about.md" >}})