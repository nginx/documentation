---
title: F5 Global Default base template
draft: false
description: ''
weight: 110
toc: true
nd-docs: DOCS-1503
personas:
- devops
- netops
- secops
- support
type:
- reference
---

## Overview

The F5 Global Default Base template includes all the essential elements needed to build NGINX configurations using templates. It simplifies complex directives into user-friendly parameters, helping those new to NGINX generate configurations quickly. While **this default template alone will not create a deployable NGINX configuration**, it offers a clear example of how to use modular components and injectable templates for augmenting functionality and the simplified user interface that comes along with that. Using these patterns, you can copy and modify the base template to create custom templates tailored to your specific needs.

## Key components

The default base template comprises several core components, each serving a specific role in the configuration process:

1. **Base template (`base.tmpl`)**: Establishes fundamental settings like user context, worker processes, and logging. It includes blocks for **main**, **HTTP**, and **stream** configurations and conditionally loads additional modules based on provided inputs.

2. **HTTP server inputs (`http-server.json`)**: Defines parameters for HTTP server block configurations, including server names, facilitating the creation of customized server blocks within the HTTP context.

3. **Location inputs (`location.json`)**: Outlines parameters for configuring location blocks, allowing detailed customization of routing and request handling within server blocks.

4. **Stream upstream inputs (`stream-upstream.json`)** and **HTTP upstream inputs (`http-upstream.json`)**: Provide schemas for upstream configurations in both HTTP and stream contexts, specifying upstream names and enabling dynamic generation of upstream blocks.

5. **Module options (`main.json`)**: Offers options for module loading, including conditions to exclude specific modules, ensuring flexibility in module management and error prevention during configuration testing.

6. **Stream server inputs (`stream-server.json`)**: Describes parameters for stream server configurations, including UDP settings, ports, and proxy pass details, supporting the generation of stream server blocks tailored to specific requirements.

## Template customization and usage

The template uses JSON schema files to validate the input and provide a user-friendly interface for customizing NGINX configurations. Each schema corresponds to a different configuration aspect, allowing users to define server, location, and upstream settings without editing NGINX config files directly.

### Conditional module loading

The template conditionally loads modules based on user inputs, optimizing the configuration by including only necessary modules. This makes the configuration process more efficient and enhances the performance and security of NGINX instances.

### Dynamic configuration generation

The template dynamically generates configuration blocks for HTTP and stream contexts, incorporating server blocks, location directives, upstream configurations, and proxy pass settings based on the provided inputs. This modular and dynamic approach facilitates the rapid deployment of customized NGINX configurations, catering to a wide range of deployment scenarios.

---

## Additional Templating Resources

{{< include "nim/templates/additional-templating-resources.md" >}}
