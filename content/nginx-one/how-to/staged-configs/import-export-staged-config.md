---
# We use sentence case and present imperative tone
title: Import and export a Staged Configuration
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
product: NGINX One
---

## Overview

Many administrators do their work on local systems, virtual machines, Docker containers, and more. F5 NGINX One Console
supports import and export of such configurations.
This guide explains how to import or export a Staged Configuration to your NGINX One Console. 

{{< include "nginx-one/staged-config-overview.md" >}}

## Before you start

Before you import or export a Staged Configuration to NGINX One Console, ensure:

- You have an NGINX One Console account with staged configuration permissions.

You can also import, export, and manage multiple Staged Configurations through [the API]({{< ref "/nginx-one/how-to/staged-configs/api-staged-config.md" >}}).

## Considerations

NGINX One Console supports imports and exports as a compressed archive known as a [tarball](https://en.wikipedia.org/wiki/Tar_(computing)), in `tar.gz` format. 
When you work with such archives, consider the following:

- Do _not_ unpack archives directly to your NGINX configuration directories. You do not want to accidentally overwrite existing configuration files.
- The files are set to a default file permission mode of 0644.
- Do not include files with secrets or personally identifying information.
- We ignore hidden files.
  - If you import or export such files in archives, NGINX One Console does not include those files.
- The size of the archive is limited to 5 MB.  The size of all uncompressed files in the archive is limited to 10 MB.

{{< tip >}}

Before you unpack an archive, run the `tar -tvzf <archive-name>.tar.gz` command. It displays the files and directories in that archive, without overwriting anything.
You'll then know where files are written when you extract an archive with a command like `tar -xvzf <archive-name>.tar.gz`.

{{< /tip >}}

## Import a Staged Configuration

To import a Staged Configuration from your system to the NGINX One Console, you need to:

- Package your configuration in `tar.gz` format. For example, the following command creates an archive file named for-import.tar.gz` from files in the `/etc/nginx` directory:
  ```bash
  tar czvf /etc/nginx for-import.tar.gz
  ```

You would then import that file to the NGINX One Console. To do so, follow these steps:

1. On the left menu, select **Staged Configurations**.
1. Select **Add Staged Configuration**.
1. Select **Import Configuration**.
1. Add a name for the Staged Configuration to be imported.
1. Select **Import from File**.
1. Choose the file. The process depends on your operating system.
1. If successful, you'll see a success message.
   - A typical error suggests that the file is too large.

## Export a Staged Configuration

You can export a Staged Configuration from the NGINX One Console, as a download, to your system. To do so, follow these steps:

1. On the left menu, select **Staged Configurations**.
1. Select the Staged Configuration you want to export. 
1. Select the ellipsis (...) on the right side of the row with the Staged Configuration.
1. Select **Export**
1. In the file menu that appears, choose a filename for your archive and save the result
1. Be careful. Do not unpack the archive in a way that overwrites your current NGINX configuration.

## Manage multiple Staged Configurations

You can also delete multiple Staged Configurations through the UI:

1. On the left menu, select **Staged Configurations**.
1. Select the Staged Configuration you want to delete.
1. You can then select the **Delete selected** button.

You can do more from the API. Specifically, with the `object_id` of each configuration, you can create, modify, or delete multiple staged configurations with the [Bulk Staged Configurations endpoint]({{< ref "/nginx-one/api/api-reference-guide/#operation/bulkStagedConfigs" >}}).
