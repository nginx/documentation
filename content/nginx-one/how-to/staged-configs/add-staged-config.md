---
# We use sentence case and present imperative tone
title: Add a Staged Configuration
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: tutorial
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
product:
# Intended for internal catalogue
docs: "DOCS-000"
---

## Overview

This guide explains how to add a Staged Configuration to your NGINX One Console. 

{{< include "nginx-one/staged-config-overview.md" >}}

## Before you start

Before you add a Staged Configuration to NGINX One Console, ensure:

- You have administrator access to NGINX One Console.

## Add a Staged Configuration

You can add a Staged Configuration from:

- Empty files
- An existing Instance
- An existing Config Sync Group
- An existing Staged Configuration

To start the process from NGINX One Console, select **Manage > Staged Configruations**. Select **Add Staged Configuration**.

The following sections start from the **Add Staged Configuration** window that appears.

### Start from an empty file

To start a new Staged Configuration:

1. Select New.
1. Enter a name.
1. Select Next.

   You will see a new Staged Configuration with the default NGINX configuration file, `/etc/nginx/nginx.conf`, in edit mode.
1. Type or paste content for `/etc/nginx/nginx.conf`.
1. Select Add File to add the configuration, certificate, or other file(s) of your choice. 

### Start from an existing Instance

To start from an existing Instance:

1. Select From.
1. Enter a name for your new Staged Configuration.
1. Select Instance.
1. In the Choose Instance menu that appears, select an existing Instance.
1. Select Next. 

NGINX One Console imports the configuration from the existing Instance. You can now edit the configuration. When you're ready to stop, select Save.

### Start from an existing Config Sync Group

To start from an existing Config Sync Group:

1. Select From.
1. Select Config Sync Group.
1. In the Choose Config Sync Group menu that appears, select an existing Config Sync Group.
1. Enter a name for your new Staged Configuration.
1. Select Next. 

NGINX One Console imports the configuration from the existing Config Sync Group. You can now edit the configuration. When you're ready to stop, select Save.

### Start from an existing Staged Config

To start from an existing Staged Config:

1. Select From.
1. Select Staged Config.
1. In the Choose Staged Config menu that appears, select an existing Staged Config.
1. Enter a name for your new Staged Configuration.
1. Select Next. 

NGINX One Console imports the configuration from the existing Staged Config. You can now edit the configuration. When you're ready to stop, select Save.

