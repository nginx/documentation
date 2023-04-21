---
title: "Visual Studio Code plug-in for NGINX Instance Manager"
draft: false
description: "How to use Visual Studio Code with the NGINX Instance Manager extension"
# Assign weights in increments of 100
weight: 500
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["examples"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
versions: []
docs: "DOCS-644"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document is intended to help utilize Visual Studio Code ("vscode") and NGINX Instance Manager.

**TECH PREVIEW**: This extension is in Tech Preview and is community-supported currently.

Currently, we are using basic authentication, which is not a very secure way to protect your Instance Manager environment. It is highly recommended you block external access and only use this internally (your connection from visual studio code to nginx-manager should be internal).

The plug-in for NGINX Instance Manager can be found in the [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=F5DevCentral.vscode-nim).

## Description {#description}

The VS Code plug-in is based on the F5 VS Code plug-in that enables AS3 language and pushes changes to F5 BIG-IP appliances through Visual Studio Code. This extension is based on that work but targets NGINX Instance Manager. The purpose of the extension is to enable a native experience with existing tools. The extension only communicates with nginx-manager and leverages the APIs from NGINX Instance Manager.

## Prerequisites {#prerequisites}

1. NGINX Instance Manager server already configured and running.
2. NGINX Agent installed on any NGINX Instances you want to manage.
3. Basic Authentication to connect to Instance Manager.

## Install the vscode plug-in {#install-plugin}

Assuming you already have Visual Studio Code installed and running. Simply navigate to the [marketplace](https://marketplace.visualstudio.com/items?itemName=F5DevCentral.vscode-nim) and install or search for F5 NIM in the extensions search panel.

## Configure vscode plug {#configure-plugin}

Select the gear icon, and you will see a configuration file that may have existing entries, or you may need to add these. You will need to use Basic auth for this current version and know the username and password.

## What's Next

You can leverage VS Code to explore NGINX Instance Manager and push configurations with lightning speed.

## Known Issues

There are some limitations with the initial version of the extension:

- Analyzer best practice rulesets are not yet integrated.
- Visual Studio Code will not check for conflicts.
