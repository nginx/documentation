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

# Concepts

This section introduces fundamental concepts related to configuration templating within NGINX Instance Manager. 

## Config Template

Config Templates are central to the dynamic generation of NGINX configurations in Instance Manager. They consist of a set of files designed to produce NGINX configurations that meet specific user requirements through provided inputs. The components of a Config Template include:

- **Gotemplates**: Files that use Go's templating language to integrate user inputs into NGINX configuration directives. They enable the customization of various configuration aspects, including server and location directives.
- **JSON Schema Files**: Specifications that detail the expected structure and types of user inputs. They play a crucial role in validating user inputs and guiding the user interface in presenting data input fields.
- **README.md**: A document offering detailed information about the template's purpose, how to use it, and instructions for effective application.
- **Auxiliary Files**: Important files such as MIME types configurations, SSL/TLS certificates for secure connections, and static content (e.g., JavaScript, CSS, HTML files) that support the NGINX server’s functionality.

## Base Template

a base template is a type of configuration template within NGINX Instance Manager that can independently generate a complete and functional NGINX configuration. It contains all the necessary directives and parameters essential for the operational integrity of an NGINX instance. The key characteristics include:

- The ability to produce a comprehensive NGINX configuration autonomously, without the need for integrating additional templates or augmentations.
- Inclusion of a `base.tmpl` gotemplate, potentially alongside JSON schema files for validating input, as well as essential auxiliary files. This ensures that the NGINX server is provisioned with the foundational settings required for basic operations.

## Augment Template

Augment templates are defined as a type of configuration template within NGINX Instance Manager specifically designed to modify, enhance, or add to the functionalities provided by a base template or an existing NGINX configuration. Unlike base templates, augment templates cannot generate a standalone NGINX configuration by themselves. Their key characteristics include:

- The capacity to introduce specific features, adjustments, or optimizations to an existing NGINX configuration, thereby extending or enhancing its capabilities beyond the foundational setup provided by a base template.
- A composition that includes gotemplate files targeted at specific NGINX contexts (for example, `http.tmpl`, `location.tmpl`) and their corresponding JSON schema files for accurate input validation. This is complemented by any necessary auxiliary files relevant to the augmentations being introduced.


## Target

A Target is the specific deployment destination or context for the NGINX configurations that are generated using Config Templates within NGINX Instance Manager. It essentially specifies where the resulting configuration will be applied, ensuring that configurations are directed to the appropriate operational environment. Key aspects of a Target include:

- Serving as the intended destination for deploying generated NGINX configurations, which can be either a singular NGINX instance, a collective group of instances known as an Instance Group, or a Staged Configuration environment intended for pre-deployment testing or verification.
- Enabling precise and efficient application of configurations to ensure they meet the operational requirements of the specified environment or setup.

Understanding Targets is crucial for accurate and efficient application of configurations to the intended operational environments.

## Template Submission

A template submission is the process of deploying a config template—whether it is a base template alone or in combination with one or more augment templates—to a target destination. This process involves several key steps:

- Choosing the appropriate Config Template(s) and completing the required inputs based on the template's JSON schema. This step ensures that all necessary data for generating the NGINX configuration is accurately provided.
- Utilizing the selected templates and the provided inputs to generate the NGINX configuration. This involves merging the templates and inputs to create a configuration that meets the specified requirements.
- Documenting the combination of templates and inputs as a deployable snapshot. This snapshot can be deployed to the specified Target and is subject to future adjustments or updates as needed.

Template Submission is a crucial step in the NIM templating process as it actualizes the configurations designed within the templates, making them ready for deployment to the designated operational environment. This process not only streamlines the management of NGINX configurations but also ensures that configurations can be efficiently updated and deployed across various environments, maintaining optimal server performance and functionality.