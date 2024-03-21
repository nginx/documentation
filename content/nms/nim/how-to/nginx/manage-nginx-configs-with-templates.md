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

After creating a template, you'll need to add various resource files to define its structure and behavior:

- **Config File (.tmpl)**: This is the core template file that defines the structure and parameters of your NGINX configuration. If you're creating a base template, you'll add a **base.tmpl** file. For augment templates, select the appropriate augment file that corresponds to the functionality you wish to include.
- **JSON Schema File (.json)**: JSON schema files are necessary for creating the dynamic web forms in the UI that users will interact with. These schemas define the valid format and type of user inputs for the template.
- **Aux File**: Aux files are additional resources necessary for the NGINX configuration to function properly. They may include JavaScript files, SSL certificates, MIME type definitions, and any other required configuration assets.
- **Docs (README.md)**: Documentation files like **README.md** provide essential information, usage instructions, and a high-level description of what the template does and how to use it.

To add resource files to a template:

1. On the **Templates > Overview** page, locate the newly created template. In the **Actions** column, select the ellipsis (three dots), then choose **Edit Template Files**.
2. In the config editor, select **Add file**.
3. Choose the type of file you want to add to the template. Depending on the file type, you'll be presented with a list of file options to choose from.
4. Select the file names you want to add to your template.
5. After selecting all the necessary files, click **Add** to include them in the template.
6. The selected files will now appear in the template's directory structure on the left side of the editor. Select a file to edit its contents in the editing pane.
8. Make your changes and select **Save** to update the template with your configurations.

{{<call-out "tip" "See Also" >}}<i class="fa-regular fa-lightbulb" aria-hidden="true" aria-label="Tip"></i>
You can find more information about template types, template resource files, and JSON schema features in the [Additional Resources](#additional-resources) section.{{</call-out>}}

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

--- 

## Preview and Generate a Config from a Template

Previewing a config from a template allows you to see how your NGINX configurations will look before they go live. This step helps ensure that your configurations are correctly set up and include all necessary inputs and augmentations. By previewing, you can avoid errors that might disrupt your service when the configurations are published.

To preview and generate a config from a template:

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. In the left navigation pane, select **Templates > Overview**.
4. On the Config Templates "Overview" page, find the template you want to use and select the ellipsis (three dots) in the **Actions** column. Then choose **Preview and Generate**.
5. In the **Preview and Generate Config** dialog, proceed through the forms in sequence, selecting **Next** to move forward:
    - **Choose Publish Options**: Decide where to publish the template by selecting one of the following targets:
      - **Publish to an Instance**: If you want the configuration to apply to a single NGINX instance.
      - **Publish to an Instance Group**: To apply the configuration to multiple instances managed as an instance group.
      - **Save to a Staged Config**: If you prefer to stage the configuration for future deployment.
      - **Save as a New Staged Config**: To create a brand new staged configuration for later use.
    - **Augments** (Optional): If you are working with a base configuration, you can include additional augment templates for enhanced functionality.
    - **Base and Augment Inputs**: Enter the required configuration inputs for the chosen templates.
    - **Preview Config**: Use the dropdown to select and review how each configuration file will appear after generation.
6. After reviewing and confirming that the configurations are correct, select **Publish**. If you've published to an instance or instance group, the submission will be listed on the **Templates > Template Submissions** page for tracking and management.

---

## Additional Resources

- **[Understanding Configuration Templates]({{< relref "nms/nim/about/templates/config-templates.md" >}})**: Learn about the different types of templates, the available targets for publishing, and the template submission process.
  
- **[Template Resource Files]({{< relref "nms/nim/about/templates/template-artifacts.md" >}})**: Learn about the template resource files, including config template files, JSON schemas, and auxiliary files.
  
- **[JSON Schemas for Dynamic Web Forms]({{< relref "nms/nim/about/templates/json-schema-reference.md" >}})**: A reference for the supported JSON schema features used to create dynamic web forms for user input and validation.
