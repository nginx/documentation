---
title: "Understanding Config Templates"
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

## Config templates

NGINX Instance Manager uses [Go templating](https://pkg.go.dev/text/template) to simplify creating and standardizing NGINX configurations. These config templates create an abstraction layer for NGINX configuration files, enabling users to provide parameters to generate a working configuration without needing a deep knowledge of NGINX syntax. These templates simplify configuring NGINX, enforce best practices for configurations, and enable self-service permissions for app development.

### Types of templates {#template-types}

Configuration templates come in two types:

- **Base templates**: A base template is a comprehensive set of instructions used to generate a complete NGINX configuration. It includes all the necessary directives and parameters to create a functional NGINX configuration from scratch. Essentially, it’s the foundational configuration on which your NGINX instance operates.

- **Augment templates**: An augment template modifies or adds to an existing NGINX configuration. It's used to introduce specific functionality, features, or settings without altering the underlying base template. Augment templates allow for customization and enhancement of NGINX configurations by overlaying additional directives onto the base setup.

### Template resource files {#template-resources}

Configuration templates include the following components:

- **Template files (.tmpl)**: Written in Go's templating language, these files define the NGINX configuration's structure and parameters.
  
- **JSON schema files (.json)**: These files create the rules for validating user inputs and generate dynamic web forms for data entry.

- **Auxiliary files**: Additional files required for configuration, such as JavaScript for added functionality, security certificates, or documentation (README.md). These files support the main configuration and provide necessary context or capabilities.

To learn more about the resources mentioned, refer to the [Template Resource Files]({{< relref "nms/nim/about/templates/template-artifacts.md" >}}) topic.

## Target

A target refers to the specific NGINX server instance, instance group, or staged config where a template (base or augment) is intended to be applied. It's the designated location or context within which the generated configuration will be active and operational.

There are three types of targets:

1. **Individual NGINX instance**: Targets a single server, allowing for precise configuration updates or replacements.

2. **Instance group**: A collection of NGINX instances managed as a single group. Applying a template to an instance group ensures uniform configuration across all its servers.

3. **Staged config**: A staging area for configurations before deployment, allowing for testing and validation to minimize potential disruptions upon live deployment.

## Template submission

Template submission involves applying a set of configurations (derived from base and/or augment templates) to a target. This action takes the parameters defined in the templates, generates the final NGINX configuration, and deploys it to the specified target. Template submission effectively bridges the gap between configuration design and operational use.

Key aspects of template submission include:

- **Snapshots**: Snapshots are created when templates are submitted. Snapshots capture the state of the template and its inputs at the time of submission. This includes all the settings, parameters, and the structure defined in both base and augment templates. By creating a snapshot, NGINX Instance Manager preserves a record of the exact configuration applied to a target at a specific point in time. This is crucial for auditing purposes, rollback scenarios, and understanding the evolution of a server's configuration.

- **Target application**: When submitting a template, it's important to specify the target accurately. The target is the NGINX instance, instance group, or staged config where the generated configuration will be applied. Misidentifying the target can lead to configurations being deployed to unintended environments, potentially causing disruptions.

---

## Additional Resources

- **[Template Resource Files]({{< relref "nms/nim/about/templates/template-artifacts.md" >}})**: Learn about template resource files, including config template files, JSON schemas, and auxiliary files.
  
- **[JSON Schemas for Template Inputs]({{< relref "nms/nim/about/templates/json-schema-reference.md" >}})**: JSON schemas for the dynamic web form builder, used for template input and validation.

- **[Manage NGINX Configs with Config Templates]({{< relref "nms/nim/how-to/nginx/manage-nginx-configs-with-templates.md" >}})**: Learn how to create and import config templates, as well as generate and deploy NGINX configurations.