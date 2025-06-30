---
description: Learn about the policies available for use in F5 NGINX Management Suite
  API Connectivity Manager.
nd-docs: DOCS-932
title: Available Policies
toc: true
weight: 500
type:
- reference
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

This page gives an overview of the available policies in API Connectivity Manager. Policies allow you to protect and secure your services and their data.

---

## Policy Types

There are two types of policies for API Connectivity Manager:

{{<bootstrap-table "table table-striped table-bordered">}}

| Policy Type                                    | Description                                                                                                                                             |
|------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Global&nbsp;policies](#global-policies)       | Global policies, typically managed by an Enterprise Security or Support team, are onboarded as a one-time task when onboarding an API. Global policies are enforced for all of the APIs in an environment.                 |
| [API&nbsp;proxy&nbsp;policies](#api-proxy-policies) | When onboarding APIs to API Connectivity Manager, API owners define API-level policies to enforce security and behavior characteristics for their APIs. |

{{</bootstrap-table>}}

### Global Policies {#global-policies}

Global policies are enforced for all of the APIs in an environment. Global policies are commonly prescribed by an Enterprise Security or Support team; the Security or Support team decides if API owners can edit the global policies.

{{< include "acm/about/global-policies.md" >}}

### API Proxy Policies {#api-proxy-policies}

Apply API gateway proxy policies to enhance the experience of your APIs.

{{< include "acm/about/api-proxy-policies.md" >}}

