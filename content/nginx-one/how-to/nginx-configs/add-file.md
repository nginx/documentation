---
docs: null
title: Add a file to an instance
toc: true
weight: 400
type:
- how-to
---

## Overview

{{< include "nginx-one/add-file/overview.md" >}}

## Before you start

Before you add files in your configuration, ensure:

- You have access to the NGINX One Console.
- NGINX instances are properly registered with NGINX One Console

## Important considerations

If your instance is a member of a Config Sync Group, changes that you make may be synchronized to other instances in that group.
For more information, see how you can [Manage Config Sync Groups]({{< ref "/nginx-one/how-to/config-sync-groups/manage-config-sync-groups.md" >}}).

## Add a file

You can use the NGINX One Console to add a file to a specific instance. To do so:

1. Select the instance to manage.
1. Select the **Configuration** tab.

   {{< tip >}}

   {{< include "nginx-one/add-file/edit-config-tip.md" >}}

   {{< /tip >}}

1. Select **Edit Configuration**.
1. In the **Edit Configuration** window that appears, select **Add File**.

You now have multiple options, described in the sections which follow.

{{< img src="nginx-one/images/add-file-to-config.png" alt="A modal window to edit configuration, with a 'New Configuration File' option selected." >}}

### New Configuration File

Enter the name of the desired configuration file, such as `abc.conf` and select **Add**. The configuration file appears in the **Edit Configuration** window.

### New SSL Certificate or CA Bundle

{{< include "nginx-one/add-file/new-ssl-bundle.md" >}}

  {{< tip >}}

  Make sure to specify the path to your certificate in your NGINX configuration,
  with the `ssl_certificate` and `ssl_certificate_key` directives.

  {{< /tip >}}

### Existing SSL Certificate or CA Bundle

{{< include "nginx-one/add-file/existing-ssl-bundle.md" >}}

## See also

- [Create and manage data plane keys]({{< ref "/nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys.md" >}})
- [View and edit NGINX configurations]({{< ref "/nginx-one/how-to/nginx-configs/view-edit-nginx-configurations.md" >}})
- [Manage certificates]({{< ref "/nginx-one/how-to/certificates/manage-certificates.md" >}})
