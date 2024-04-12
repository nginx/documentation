---
title: "Use a location augment template with RBAC"
date: 2024-03-12T16:01:58-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---


## Overview

The F5 Global Default base template makes all of the NGINX directive blocks accessible. This might be okay if you want people to make changes without being restricted. However, if you want only designated individuals or teams to edit specific HTTP servers or locations, perhaps as part of a self-service workflow, you can use augment templates to portion out (segment) parts of the NGINX config and role-based access control (RBAC) to assign permissions.

An administrator has defined the upstream location in the base template. However, now we want to break the upstream location out of the base template so a specific team, like SRI, can edit these settings themselves. By breaking the location out of the base template, we're able add additional control over how can access it. In short, a base template makes all of the NGINX directive blocks accessible if there's no need for access control. However, if you want to restrict certain server or location blocs, you can create augments for those blocks and limit access with RBAC.

Limitation: can't augment an augment. If you have an augment and want to update it, you have to update the augment directly. You can't create an augment to update an augment.




## Import template

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. In the left navigation pane, select **Templates > Overview**.