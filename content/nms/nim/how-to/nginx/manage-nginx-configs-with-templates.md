---
title: "Manage NGINX Configs with Templates"
date: 2024-03-12T15:51:04-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 300
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
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

## Create a Config Template

Config templates in NGINX Instance Manager allow you to predefine and standardize configurations for your NGINX instances. By creating a template, you can streamline the deployment process and ensure consistency across your environments. This guide walks you through creating a new template from scratch or importing an exiting template from an archive.

### Create a Config Template from Scratch

To create a new config template:

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. In the left navigation pane, select **Templates > Overview**.
4. On the Config Templates "Overview" page, select **Create**.
5. In the **Create Template** dialog:
    - Select **New** to start a fresh template.
    - Enter a unique and descriptive name for your template in the **Name** field.
    - (Optional) Provide a description in the **Description** field to give more context about the template's purpose or usage.
    - Choose the template's **State** to indicate its readiness:
        - **Draft**: Indicates that the template is still under development, editable, and not finalized for use.
        - **Ready for Use**: Means the template is finalized, locked from further editing, and ready to be applied or submitted.
    - Specify the **Type** of template you are creating:
        - **Base**: Select this option if the template will serve as a comprehensive starting point, containing all the directives needed for a standalone NGINX configuration.
        - **Augment**: Choose this if the template will add to or enhance an existing configuration by introducing additional directives or settings.
6. Click **Submit** to create the template.

Remember that a base template is required to build a full configuration, whereas augment templates are used to extend or modify this base configuration as needed. You can find more about these template types in the topic [Understanding Configuration Templates]({{< relref "nms/nim/about/templates/config-templates.md" >}}).

### Import a Config Template from an Archive

When importing a config template from an archive, ensure your `.tar.gz` file adheres to the following structure:

- Each template must be in its own directory within the archive.
- Directories should contain all related template files (.tmpl for templates, .json for JSON schemas) and a `meta.json` file that includes metadata such as the template's name, description, author, type, and unique identifier (UID).

Optionally, you can sign your archive with a digital signature for verification upon import. This process involves creating a cryptographic hash of the archive file and signing it with a private key.

#### Required archive structure

``` text
<archive-name>.tar.gz
│
├── <template-name>/
│   ├── <template-files>.tmpl
│   ├── <validation-files>.json
│   └── meta.json
│
├── <another-template-name>/
│   ├── <template-files>.tmpl
│   ├── <validation-files>.json
│   └── meta.json
│
└── ...
```

#### Example meta.json file

``` json
{
  "meta_version_num": 1,
  "name": "example_template",
  "description": "This is an example NGINX template.",
  "author": "Your Name",
  "type": "base",  // Could be "base" or "augment"
  "uid": "unique-identifier-uuid-goes-here"
}
```

_Replace the placeholder values with the actual details of your template._

<br>

To import an existing template from a `.tar.gz` archive file:

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. In the left navigation pane, select **Templates > Overview**.
4. On the Config Templates "Overview" page, select **Create**.
5. In the **Create Template** dialog, select **Import**.
6. Drag and drop your `.tar.gz` archive file onto the web form or select **Browse** to find and select your file.
7. Once the file is uploaded, select **Parse** to inspect the archive.
8. If an error message appears indicating the archive is unsigned, and you recognize and trust the source of the file, select the checkbox **Allow Signature Bypass**.
9. Select **Import** to finish importing the templates.

{{<warning>}}<i class="fa fa-exclamation-triangle" aria-hidden="true" aria-label="Warning"></i> Make sure you validate the source of the archive before bypassing the signature requirement to maintain the security of your system.{{</warning>}}


