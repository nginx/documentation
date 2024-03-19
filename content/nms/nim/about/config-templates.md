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
weight: 
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

NGINX Instance Manager configuration templates use [Go templating <i class="fas fa-external-link-alt"></i>](https://pkg.go.dev/text/template) to simplify the creation and standardization of NGINX configurations. Configuration templates allow administrators to quickly and easily generate customized NGINX configurations for different environments without requiring an in-depth knowledge of NGINX syntax.

Templates accelerate setup, ensure NGINX configurations are consistent and compliant with best practices, and enable teams to manage segments independently, fostering self-service within organizations.

You can customize configuration templates through both the Instance Manager web interface or REST API. Teams can adapt existing templates or create new ones based on their needs.

### Template components

Configuration templates include these components:

- **Template files (.tmpl)**: Go templating language files that define the structure and parameters of the NGINX configuration.
  
- **JSON schema files (.json)**: Files that specify the validation rules for the parameters, guiding user input and ensuring correct data types and formats.

- **Auxiliary files**: Additional support files required for the configuration, such as JavaScript files for functionality, certificates for security, README.md files that provide an overview and usage instructions for the templates, and any other necessary resources.

### Types of templates

There are two types of configuration templates:

- **Base templates**: A base template can generate a complete NGINX configuration on its own. It provides the foundational structure and settings necessary for an NGINX instance to function. Base templates define the core aspects of the configuration, such as server directives, locations, and other fundamental settings that are essential for the NGINX server's operation. These templates serve as the starting point for creating a fully operational NGINX configuration, to which additional functionalities or customizations can be added, often through augment templates.

- **Augment templates**: An augment template adds specific functionalities or configuration segments to an existing NGINX configuration, enhancing or modifying it without replacing the entire setup. These templates can introduce new features like caching mechanisms, OIDC authentication, or detailed configuration for specific location or server blocks. Augment templates are used in conjunction with a base template or applied to an already existing NGINX configuration to extend its capabilities or adjust its behavior according to specific requirements.

## Target

A target in the context of NGINX configuration templates refers to the specific NGINX environment or server where the generated configuration from a template—whether a base template, an augment template, or a combination of both—is applied. Targets can be individual NGINX instances, groups of instances managed together as an instance group, or a staged configuration area where configurations are tested and validated before being deployed to production environments. Understanding and specifying the correct target is essential for ensuring that the configuration is applied to the intended NGINX server(s) or environment, resulting in the desired changes or enhancements in functionality.

There are three types of targets:

1. **Individual NGINX instance**: Targets a single server, allowing for precise configuration updates or replacements on that server.

2. **Instance Group**: A collective of NGINX instances treated as a single unit. Applying a template to an instance group ensures uniform configuration across all its servers.

3. **Staged config**: Acts as a preliminary holding area for configurations before they're deployed. This step enables thorough testing and validation, minimizing potential disruptions upon live deployment.

## Template submission

A template submission is the process of applying a configuration generated from a template to a specified target within the NGINX environment. It involves selecting a template—either a base template for creating a new configuration or an augment template for adding to or modifying an existing configuration—filling out the required parameters based on the template's structure, and then deploying this configuration to the chosen target. This target could be an individual NGINX instance, a group of instances, or a staged configuration setting for testing purposes. 

Template submission effectively bridges the gap between configuration design and implementation, turning theoretical designs into operational reality within the NGINX infrastructure.

Key aspects of template submission include:

- **Snapshot creation**: Upon submission, a snapshot of the template along with the provided parameters is created. This ensures that each submission is preserved for future reference, enabling easy tracking and modifications if necessary.

- **Target application**: The user specifies the target (an individual NGINX instance, an instance group, or a staged config) where the generated configuration will be applied. This step determines where the configuration will take effect, directly impacting the operation of the specified NGINX environment.

- **Flexibility and control**: Users have the flexibility to create new configurations, modify existing ones, or apply additional functionalities through augment templates. This provides granular control over how NGINX instances are configured and managed.

- **Validation and testing**: For submissions aimed at a staged config, there's an opportunity to validate and test the configuration before live deployment. This minimizes risks and ensures stability in the production environment.

