---
title: "Template Concepts"
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

## Glossary

- **Template**: A set of files for defining NGINX instance configurations. It consists of:
   - **Go template file(s)** (`.tmpl`): Define NGINX configurations and parameters.
   - **JSON schema file(s)** (`.json`): Create a dynamic user interface (UI) and validation rules for input parameters.
   - **Auxiliary files**: Support files like MIME types and certificates.

- **Base template**: The primary template for your NGINX configuration. You'll use one and only one base template as the foundation for your configuration.

- **Augment template**: Additional templates that customize your NGINX configuration with specific features or settings like security enhancements or traffic management strategies. For example, adding OIDC authentication.

- **Target**: The NGINX instance, group of instances, or staged configuration where the template configurations are applied.

- **Template submission**: In the UI, a "Template Submission" is a summary of your most recent base and auxiliary templates, the parameters you entered, and the target(s) where they were applied.
