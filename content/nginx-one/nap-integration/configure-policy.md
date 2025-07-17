---
# We use sentence case and present imperative tone
title: "Add and configure a policy"
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NGINX One
---

This document describes how you can configure a security policy in the F5 NGINX One Console. When you add a policy, NGINX One Console includes several UI-based options and presets, based on NGINX App Protect WAF.


If you already know NGINX App Protect WAF, you can go beyond the options available in the UI. 

## Add a policy

From NGINX One Console, select App Protect > Policies. In the screen that appears, select **Add Policy**. That action opens a screen where you can:

- In General Settings, name and describe the policy.
  - You can also set one of the following enforcement modes:
    - Transparent
    - Blocking

For details, see the [Glossary]({{< ref "/nginx-one/glossary.md#nginx-app-protect-waf-terminology" >}}), specifically the entry: **Enforcement mode**. You'll see this in the associated configuration file,
with the `enforcementMode` property.

You can also set a character encoding. The default encoding is `Unicode (utf-8)`. To set a different character encoding, select **Show Advanced Fields** and select the **Application Language** of your choice.

## Configure a policy

With NGINX One Console User Interface, you get a default policy. You can also select **NGINX Strict** for a more rigorous policy:

### Basic Configuration and the Default Policy

{{< include "/nap-waf/concept/basic-config-default-policy.md" >}}

## Save your policy

NGINX One Console includes a Policy JSON section which displays your policy in JSON format. What you configure here is written to your instance of NGINX App Protect WAF. 

With the **Edit** option, you can customize this policy. It opens the JSON file in a local editor. When you select **Save Policy**, it saves the latest version of what you've configured. You'll see your new policy under the name you used.

From NGINX One Console, you can review the policies that you've saved, along with their versions. Select **App Protect** > **Policies**. Select the policy that you want to review or modify.
