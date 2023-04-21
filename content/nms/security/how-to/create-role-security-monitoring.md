---
title: "Give Users Access to Security Monitoring Dashboards"
date: 2022-11-16T13:34:27-08:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to grant users access to the NGINX Management Suite Security Monitoring dashboards."
# Assign weights in increments of 100
weight: 200
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1026"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{< shortversions "1.0.0" "latest" "secvers" >}}

{{<custom-styles>}}

## Overview

You can use NGINX Management Suite Security Monitoring to monitor NGINX App Protect WAF instances. The Security Monitoring analytics dashboards and security logs provide protection insights and help you analyze possible threats or identify opportunities to tune your security policies.

By completing the steps in this topic, you will create a role that gives users access to the Security Monitoring module and logs, and assign it to user accounts or groups. 

{{<note>}}The recommendations in this guide follow the principle of least privilege and do not grant users access to the Instance Manager module. You can create additional roles with custom modules, features, and permissions to suit your use case.{{</note>}}

## Before You Begin

Complete the following prerequisites before proceeding with this guide: 

- NGINX Management Suite Security Monitoring is [installed]({{< relref "/admin-guides/installation/on-prem/install-guide#install-nms-modules" >}}) and running. 
- Your user account needs to be able to access the User Management settings in NGINX Management Suite. 
  The minimum required role permissions are:

    - **Module**: Settings 
    - **Feature**: User Management
    - **Access**: `READ`, `CREATE`, `UPDATE`

- Review the table below to determine the minimum permissions needed for your use case.

  {{<bootstrap-table "table table-bordered table-hover">}}
  | Module(s) | Feature(s) | Access | Description |
  |-------|--------|----|--------|
  | Instance&nbsp;Manager <hr> Security&nbsp;Monitoring | Analytics <hr> Security&nbsp;Monitoring | READ <hr> READ  | Read-only access that allows users to view the Security Monitoring dashboards. Users cannot access Instance Manager or Settings.
  | Instance&nbsp;Manager <hr> Security&nbsp;Monitoring <hr> Settings | Analytics <hr> Security&nbsp;Monitoring <hr>User Management | READ <hr> READ <hr> CREATE,&nbsp;READ,&nbsp;UPDATE| Allows users to view the Security Monitoring dashboards and manage user accounts and roles.<br><br>{{< fa "lightbulb" >}} Recommended for a "super-user" who is responsible for managing other users' access to the security dashboards. This permission set does not allow the user to delete user accounts.
  {{</bootstrap-table>}}


## Create a Role

{{< include "admin-guides/access-control/nms-sm-rbac.md" >}}

## Assign the Role to Users

After you've created a role for Security Monitoring, assign the role to one or more users or to a user group.

{{< include "admin-guides/access-control/assign-roles.md" >}}

To assign the role to a user group, take the following steps:

1. Open the NGINX Management Suite web interface and log in.
2. Select the **Settings** (gear) icon in the upper-right corner.
3. Select **User Groups**.
4. Select the user group from the list, or select **Create** to [add a new user group]({{< relref "/admin-guides/access-control/set-up-rbac.md#create-group" >}}).
5. Select the **Edit** icon.
6. In the **Roles** list, select the role(s) that you want to assign to the group.
7. Select **Save** to update the user group.
