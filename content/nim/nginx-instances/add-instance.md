---
title: "Add an NGINX instance"
weight: 100
toc: false
nd-content-type: how-to
nd-product: NIM
---

This guide shows you how to add NGINX Open Source and NGINX Plus instances to F5 NGINX Instance Manager.

## Before you begin

Make sure you have:

- One or more instances running NGINX Open Source or NGINX Plus.
- Admin access to NGINX Instance Manager.

## Add instances

1. Open the NGINX Instance Manager web interface and log in.
2. In the **Manage** section on the left, select **Instances**.
3. Select **Add**.
4. Copy the `curl` command.
5. On the host where your NGINX instance is running, run the `curl` command to install NGINX Agent:

   ```shell
   curl https://<NIM-FQDN>/install/nginx-agent | sudo sh
   ```

6. On the same host, run the following command to start NGINX Agent:

   ```shell
   sudo systemctl start nginx-agent
   ```

## Next steps

- [Add instances to instance groups]({{< ref "nim/nginx-instances/manage-instance-groups.md" >}})
- [Add managed certificates]({{< ref "nim/nginx-instances/manage-certificates.md" >}})