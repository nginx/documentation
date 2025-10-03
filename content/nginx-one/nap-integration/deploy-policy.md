---
# We use sentence case and present imperative tone
title: "Deploy policy"
# Weights are assigned in increments of 100: determines sorting order
weight: 600
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NGINX One
---

After you've set up a policy, it won't do anything, until you deploy it to one or more instances and Config Sync Groups.

This page assumes you've created a policy in NGINX One Console that you're ready to deploy.

## Deploy a policy

To deploy a policy from NGINX One Console, take the following steps:

1. Select **App Protect** > **Policies**.
1. Select the policy that you're ready to deploy.
1. Select the **Details** tab.
1. In the **Deploy Policy** window that appears, you can confirm the name of the current policy and the version to deploy. NGINX One Console defaults to the selected policy and latest version.
1. In the **Target** section, select Instance or Config Sync Group.
1. In the drop-down menu that appears, select the instance or Config Sync Group available in the current NGINX One Console.
