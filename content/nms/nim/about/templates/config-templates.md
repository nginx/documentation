---
title: "Understanding Configuration Templates"
date: 2024-03-11T14:03:20-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["concept"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

## Config Templates

NGINX Instance Manager uses [Go templating](https://pkg.go.dev/text/template) to simplify creating and standardizing NGINX configurations. These config templates create an abstraction layer for NGINX configuration files, enabling users to provide parameters to generate a working configuration without needing a deep knowledge of NGINX syntax. These templates simplify configuring NGINX, enforce best practices for configurations, and enable self-service permissions for app development.

### Types of Templates {#template-types}

Configuration templates come in two types:

- **Base Templates**: These are standalone templates that provide all the necessary settings for an NGINX instance to run. They formulate the fundamental structure of the NGINX configuration, including server directives, locations, and other key settings.

- **Augment Templates**: These templates add functionality or segments to an NGINX configuration. They can introduce new capabilities like caching, OIDC authentication, or segment or break out specific configuration content like location blocks or server blocks.

### Template Resource Files {#template-resources}

Configuration templates include the following components:

- **Template Files (.tmpl)**: Written in Go's templating language, these files define the NGINX configuration's structure and parameters.
  
- **JSON Schema Files (.json)**: These files create the rules for validating user inputs and generate dynamic web forms for data entry.

- **Auxiliary Files**: Additional files required for configuration, such as JavaScript for added functionality, security certificates, or documentation (README.md). These files support the main configuration and provide necessary context or capabilities.

To learn more about the resources mentioned, refer to the [Template Resource Files]({{< relref "nms/nim/about/templates/template-artifacts.md" >}}) topic.

## Target

A target in the context of NGINX configuration templates refers to the location where the generated configuration is applied. Targets can be individual NGINX instances, groups of instances managed as an instance group, or a staged configuration that can be tested and validated before being deployed to production environments.

There are three types of targets:

1. **Individual NGINX instance**: Targets a single server, allowing for precise configuration updates or replacements.

2. **Instance Group**: A collection of NGINX instances managed as a single group. Applying a template to an instance group ensures uniform configuration across all its servers.

3. **Staged config**: A staging area for configurations before deployment, allowing for testing and validation to minimize potential disruptions upon live deployment.

## Template submission

Template submission involves applying a template-generated configuration to a chosen target in the NGINX environment. This process starts with selecting a template, either a base template for a new setup and/or an augment template for updates. Augment templates can be used in combination with the base template to add new features or segments when generating configurations, or to update an existing configuration. Then, you fill in the needed parameters and deploy the configuration to your target.

Template submission effectively bridges the gap between configuration design and operational use.

Key aspects of template submission include:

- **Snapshot creation**: When a template is submitted, a snapshot of the template and the provided parameters is saved. This helps keep a record of what was submitted and makes it easy to review and make changes in the future if needed.

- **Target application**: Users can choose where the generated configuration will take effect--on an individual NGINX instance, an instance group, or a staged config.

- **Flexibility and control**: Users can create new configurations with base templates or they can add additional functionalities or segments with augment templates.
