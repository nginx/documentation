---
title: "Types of Templates"
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

## Configuration Templates
Instance Manager configuration templates simplify the creation and standardization of NGINX configurations using Go templating. Configuration templates allow administrators to quickly and easily generate customized NGINX configurations for different environments without requiring an in-depth knowledge of NGINX syntax.

Templates accelerate setup, ensure NGINX configurations are consistent and compliant with best practices, and enable teams to manage segments independently, fostering self-service within organizations.

You can customize configuration templates through both the web interface or REST API. Teams can adapt existing templates or create new ones based on their needs.

### Components

Configuration templates include these components:

- **Template files (.tmpl)**: Written in Go templating language, these define the configuration structure with placeholders for user inputs, shaping the final NGINX directives.
  
- **JSON schema files (.json)**: These outline the parameters' validation, guiding user input to ensure correct data types and formats, enhancing the interface experience.

- **Auxiliary files**: Additional necessary files, like JavaScript for functionality or certificates, supplement the templates for a complete NGINX configuration.

### Types of Templates

There are two types of configuration templates:

- **Base templates**: Standalone templates that produce a full NGINX configuration, serving as the deployment foundation.

- **Augment templates**: Extensions to base templates, they add functionalities or segments to the configuration, such as caching or OIDC authentication.


## Target

The "target" in templating specifies where the template-generated configuration will be applied. This concept is essential for using templates effectively, as it determines the deployment and management locations for generated configurations.

There are three types of targets:

1. **Individual NGINX instance**: Targets a single server, allowing for precise configuration updates or replacements on that server.

2. **Instance Group**: A collective of NGINX instances treated as a single unit. Applying a template to an instance group ensures uniform configuration across all its servers.

3. **Staged config**: Acts as a preliminary holding area for configurations before they're deployed. This step enables thorough testing and validation, minimizing potential disruptions upon live deployment.

## Template Submission

Template Submission in Instance Manager is the process of deploying an NGINX configuration generated from a template to a specified target. It's a crucial step that actualizes the theoretical design of a template into a active, functioning NGINX configuration. This process involves taking the parameters filled out by the user, combining them with the chosen template (either a Base Template or one or more Augment Templates), and applying the resulting configuration to the intended NGINX environment.

Key aspects of Template Submission include:

- **Snapshot Creation**: Upon submission, a snapshot of the template along with the provided parameters is created. This ensures that each submission is preserved for future reference, enabling easy tracking and modifications if necessary.

- **Target Application**: The user specifies the target (an individual NGINX instance, an instance group, or a staged config) where the generated configuration will be applied. This step determines where the configuration will take effect, directly impacting the operation of the specified NGINX environment.

- **Flexibility and Control**: Users have the flexibility to create new configurations, modify existing ones, or apply additional functionalities through augment templates. This provides granular control over how NGINX instances are configured and managed.

- **Validation and Testing**: For submissions aimed at a staged config, there's an opportunity to validate and test the configuration before live deployment. This minimizes risks and ensures stability in the production environment.

Template Submission is fundamental for operationalizing templates within the Instance Manager, bridging the gap between configuration design and implementation.