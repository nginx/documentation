---
# We use sentence case and present imperative tone
title: View and edit a Staged Configuration
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: tutorial
# Intended for internal catalogue and search, case sensitive:
product: NGINX One
# Intended for internal catalogue
docs: "DOCS-000"
---

## Overview

This guide explains how to edit an existing Staged Configuration in your NGINX One Console. 

{{< include "nginx-one/staged-config-overview.md" >}}

## Before you start

Before you edit a Staged Configuration, ensure:

- You have administrator access to NGINX One Console.

## View and edit a Staged Configuration
<!-- Possible future include, with similar files in config-sync-groups/, nginx-configs/, and staged-configs/ subdirectories -->

Once you've registered your NGINX Staged Configs with the F5 NGINX One Console, you can view and edit their NGINX configurations on the **Staged Configurations** details page.

To view and edit an NGINX configuration, follow these steps:

1. On the left menu, select **Staged Configurations**.
2. Select the staged configuration you want to view or modify.
3. Select the **Configuration** tab to see the current configuration for the NGINX instance.
4. Select **Edit Configuration** to make changes to the current configuration.
5. Make your changes to the configuration files. The configuration analyzer will let you know if there are any errors.
6. When you are satisfied with the changes, select **Next**.
7. Compare and verify your changes before selecting **Save and Publish** to publish the edited configuration.

## See also

- [Manage Config Sync Groups]({{< relref "/nginx-one/how-to/config-sync-groups/manage-config-sync-groups.md" >}})
