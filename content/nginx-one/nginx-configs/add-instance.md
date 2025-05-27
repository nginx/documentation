---
description: ''
title: Add an NGINX instance
toc: true
weight: 100
aliases: /nginx-one/how-to/nginx-configs/add-instance/
type:
- how-to
---

## Overview

This guide explains how to add an F5 NGINX instance in F5 NGINX One Console. You can add an instance from the NGINX One Console individually, or as part of a [Config Sync Group]({{< ref "/nginx-one/glossary.md" >}}). In either case, you need
to set up a data plane key to connect your instances to NGINX One.

## Before you start

Before you add an instance to NGINX One Console, ensure:

- You have [administrator access]({{< ref "/nginx-one/rbac/roles.md" >}}) to NGINX One Console.
- You have [configured instances of NGINX]({{< ref "/nginx-one/getting-started.md#add-your-nginx-instances-to-nginx-one" >}}) that you want to manage through NGINX One Console.
- You have or are ready to configure a [data plane key]({{< ref "/nginx-one/getting-started.md#generate-data-plane-key" >}}).
- You have or are ready to set up [managed certificates]({{< ref "/nginx-one/certificates/manage-certificates.md" >}}).

{{< note >}}If this is the first time an instance is being added to a Config Sync Group, and you have not yet defined the configuration for that Config Sync Group, that instance provides the template for that group. For more information, see [Configuration management]({{< ref "nginx-one/config-sync-groups/manage-config-sync-groups#configuration-management" >}}).{{< /note >}}

## Add an instance

{{< include "/nginx-one/how-to/add-instance.md" >}}

## Managed and Unmanaged Certificates

If you add an instance with SSL/TLS certificates, those certificates can match an existing managed SSL certificate/CA bundle.

### If the certificate is already managed

If you add an instance with a managed certificate, as described in [Add your NGINX instances to NGINX One]({{< ref "/nginx-one/getting-started.md#add-your-nginx-instances-to-nginx-one" >}}), these certificates are added to your list of **Managed Certificates**.

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

When you [Manage Config Sync Group membership]({{< ref "nginx-one/config-sync-groups/manage-config-sync-groups#manage-config-sync-group-membership" >}}), you can add an existing or new instance to the group of your choice.
That instance inherits the setup of that Config Sync Group.
