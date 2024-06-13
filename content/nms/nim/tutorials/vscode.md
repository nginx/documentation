---
description: How to use Visual Studio Code with the Instance Manager extension
docs: DOCS-830
doctypes:
- tutorial
draft: true
tags:
- docs
title: Visual Studio Code plugin for Instance Manager
toc: true
weight: 800
---

<!-- vale off -->
<!-- remove the vale comment and this one before flipping draft status -->

{{< shortversions "2.0.0" "latest" "nimvers" >}}

{{%heading "overview"%}}

This document is intended to help utilize Visual Studio Code ("VS Code") and Instance Manager.

**TECH PREVIEW**: This extension is in Tech Preview and is community supported currently.

Currently we are using basic authentication which is not a very secure way to protect your Instance Manager environment.  It is highly recommended you block external access and only use this internally (your connection from Visual Studio Code to nginx-manager should be internal).

The plugin for Instance Manager can be found in the [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=F5DevCentral.vscode-nim).

## Description {#description}

The VS Code plugin is based off the F5 VS Code plugin that enables AS3 language and pushing changes to F5 BIG-IP appliances through Visual Studio Code.  This extension is based off that work but targets Instance Manager.  The purpose of the extension is to enable a native experience with existing tools.  The extension only communicates with nginx-manager and leverages the APIs from Instance Manager.

## Prerequisites {#prerequisites}

1. NGINX Management Suite already configured and running.
2. NGINX Agent installed on any NGINX Instances you want to manage.
3. Basic Authentication to connect to Instance Manager.

## Install the VS Code Plugin {#install-plugin}

Assuming you already have Visual Studio Code installed and running.  Simply navigate to the [marketplace](https://marketplace.visualstudio.com/items?itemName=F5DevCentral.vscode-nim) and install or search for F5 Instance Manager in the extensions search panel.

![Visual Studio Code Marketplace](marketplace.png)

## Configure the VS Code Plugin {#configure-plugin}

Click on the gear icon and you will see a configuration file which may have existing entries or you may need to add these.  You will need to use Basic auth for this current version and will need to know the username and password.

## What's Next

You can leverage VS Code to explore Instance Manager and push configurations with lightning speed.  Go explore.

## Known Issues

There are some limitations with the initial version of the extension:

- Analyzer best practice rulesets are not yet integrated.
- Visual Studio Code will not check for conflicts.
