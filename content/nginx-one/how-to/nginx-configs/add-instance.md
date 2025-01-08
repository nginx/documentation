---
description: ''
doctypes:
- task
tags:
- docs
title: Add an NGINX instance
toc: true
weight: 100
---

## Overview

This guide explains how to add an F5 NGINX instance in F5 NGINX One Console. You can add an instance from the NGINX One Console individually, or as part of a [Config Sync Group]({{< relref "/nginx-one/glossary.md" >}}). In either case, you need
to set up a data plane key to connect your instances to NGINX One.

## Before you start

Before you add an instance to NGINX One Console, ensure:

- You have administrator access to NGINX One Console.
- You have configured instances of NGINX that you want to manage through NGINX One Console.
- You have or are ready to configure a data plane key.
- You have or are ready to set up managed certificates.

{{< note >}}If this is the first time an instance is being added to a Config Sync Group, and you have not yet defined the configuration for that Config Sync Group, that instance provides the template for that group. For more information, see [Configuration management]({{< relref "nginx-one/how-to/config-sync-groups/manage-config-sync-groups#configuration-management" >}}).{{< /note >}}

## Add an instance

You can add an instance to NGINX One Console in the following ways:

- Directly, under **Instances**
- Indirectly, by selecting a Config Sync Group, and selecting **Add Instance to Config Sync Group**

In either case, NGINX One Console gives you a choice for data plane keys:

- Create a new key
- Use an existing key

NGINX One Console takes the option you use, and adds the data plane key to a command that you'd use to register your target instance. You should see the command in the **Add Instance** screen in the console.

Connect to the host where your NGINX instance is running. Run the provided command to [install NGINX Agent]({{< relref "/nginx-one/getting-started#install-nginx-agent" >}}) dependencies and packages on that host.

```bash
curl https://agent.connect.nginx.com/nginx-agent/install | DATA_PLANE_KEY="<data_plane_key>" sh -s -- -y
```

Once the process is complete, you can configure that instance in your NGINX One Console.

## Managed and Unmanaged Certificates

If you add an instance with SSL/TLS certificates, those certificates can match an existing managed SSL certificate/CA bundle.

### If the certificate is already managed

If you add an instance with a managed certificate, as described in [Add your NGINX instances to NGINX One], these certificates are added to your list of **Managed Certificates**. 

NGINX One Console can manage your instances along with those certificates.

### If the certificate is not managed

These certificates appear in the list of **Unmanaged Certificates**.

To take full advantage of NGINX One, you can convert these to **Managed Certificates**. You can then manage, update, and deploy a certificate to all of your NGINX instances in a Config Sync Group.

To convert these cerificates, start with the Certificates menu, and select **Unmanaged**. You should see a list of **Unmanaged Certificates or CA Bundles**. Then:

- Select a certificate
- Select **Convert to Managed**
- In the window that appears, you can now include the same information as shown in the [Add a new certificate](#add-a-new-certificate) section

Once you've completed the process, NGINX One reassigns this as a managed certificate, and assigns it to the associated instance or Config Sync Group.

## Add an instance to a Config Sync Group

When you [Manage Config Sync Group membership]({{< relref "nginx-one/how-to/config-sync-groups/manage-config-sync-groups#manage-config-sync-group-membership" >}}), you can add an existing or new instance to the group of your choice.
That instance inherits the setup of that Config Sync Group.
