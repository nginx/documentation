---
# We use sentence case and present imperative tone
title: View and edit a Staged Configuration
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: tutorial
aliases: /nginx-one/how-to/staged-configs/edit-staged-config/
# Intended for internal catalogue and search, case sensitive:
product: NGINX One
---

## Overview

This guide explains how to edit an existing Staged Configuration in your NGINX One Console. 

{{< include "nginx-one/staged-config-overview.md" >}}

## Before you start

Before you edit a Staged Configuration, ensure:

- You have an NGINX One Console account with staged configuration permissions.```

## View and edit a Staged Configuration
<!-- Possible future include, with similar files in config-sync-groups/, nginx-configs/, and staged-configs/ subdirectories -->

Once you've registered your NGINX Staged Configs with the F5 NGINX One Console, you can view and edit their NGINX configurations on the **Staged Configurations** details page.

To view and edit an NGINX configuration, follow these steps:

1. On the left menu, select **Staged Configurations**.
1. Select the staged configuration you want to view or modify.
1. Select **Edit** to make changes to the current configuration.
1. Make your changes to the configuration files. The configuration analyzer will let you know if there are any errors.
1. When you are satisfied with the changes, select **Next**.
1. Compare and verify your changes before selecting **Save** to publish the edited Staged configuration.
