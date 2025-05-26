---
# We use sentence case and present imperative tone
title: Add a Staged Configuration
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NGINX One
---

## Overview

This guide explains how to add a Staged Configuration to your NGINX One Console. 

{{< include "nginx-one/staged-config-overview.md" >}}

## Before you start

Before you add a Staged Configuration to NGINX One Console, ensure:

- You have an NGINX One Console account with staged configuration permissions.

## Add a Staged Configuration

You can add a Staged Configuration from:

- Empty files
- An existing Instance
- An existing Config Sync Group
- An existing Staged Configuration

To start the process from NGINX One Console, select **Manage > Staged Configurations**. Select **Add Staged Configuration**.

The following sections start from the **Add Staged Configuration** window that appears.

### Start from an empty file

To start a new Staged Configuration:

1. Select **New Configuration**.
1. Enter a name.
1. Select **Next**.

   You will see a new Staged Configuration with the default NGINX configuration file, `/etc/nginx/nginx.conf`, in edit mode.
1. Type or paste content for `/etc/nginx/nginx.conf`.
1. Select **Add File** to add the configuration, certificate, or other file(s) of your choice. 
1. When you're done, select **Save**.

### Start from an existing Instance

To start from an existing Instance:

1. Select **Existing Source**.
1. Enter a name for your new Staged Configuration.
1. Select **Instance**.
1. In the Choose Instance menu that appears, select an existing Instance.
1. Select **Next**. 

NGINX One Console imports the configuration from the existing Instance. You can now edit the configuration. When you're ready to stop and save your work, select Save.

### Start from an existing Config Sync Group

To start from an existing Config Sync Group:

1. Select **Existing Source**.
1. Select **Config Sync Group**.
1. In the Choose Config Sync Group menu that appears, select an existing Config Sync Group.
1. Enter a name for your new Staged Configuration.
1. Select **Next**. 

NGINX One Console imports the configuration from the existing Config Sync Group. You can now edit the configuration. When you're ready to stop and save your work, select Save.

### Start from an existing Staged Config

To start from an existing Staged Config:

1. Select **Existing Source**.
1. Select **Staged Configuration**.
1. In the Choose Staged Configuration menu that appears, select an existing Staged Configuration.
1. Enter a name for your new Staged Configuration.
1. Select **Next**. 

NGINX One Console imports the configuration from the existing Staged Configuration. You can now edit the configuration. When you're ready to stop and save your work, select Save.

