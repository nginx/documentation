---
title: Manage NGINX configs with templates
draft: false
description: ''
weight: 200
toc: true
nd-docs: DOCS-1506
personas:
- devops
- netops
- secops
- support
type:
- how-to
---

## Create a Config Template

Config templates in F5 NGINX Instance Manager allow you to predefine and standardize configurations for your NGINX instances. By creating a template, you can streamline the deployment process and ensure consistency across your environments. This guide walks you through creating a new template from scratch or importing an existing template from an archive, generating and deploying a configuration to a designated target, and modifying an existing template submission.

### Import Config Templates from an Archive

When importing a config template from an archive, ensure your `.tar.gz` file matches to the following structure:

- Each template must be in its own directory within the archive.
- Directories should contain all related template files (.tmpl for templates, .json for JSON schemas).
- Directories should have a `meta.json` file that includes metadata such as the template's name, description, author, type, and unique identifier (UID).

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

### Create a Config Template from Scratch

To create a new config template:

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. From the Launchpad menu, choose **Instance Manager**.
3. In the left navigation pane, select **Templates**.
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

After creating a template, you'll need to add [resource files]({{< ref "/nim/nginx-configs/config-templates/concepts/template-resources.md" >}}) to define its structure and behavior:

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

---

## Preview, Generate, and Submit a Config from a Template {#preview-generate-config}

Previewing a config from a template lets you see how your NGINX configurations will look before publishing them. During this step, you'll make sure all the inputs and augmentations are correct. Once you're satisfied with the preview, you can generate the config and submit it.

To preview, generate, and submit a config from a template:

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. Select **Instance Manager** from the LaunchPad.
3. On the left sidebar, select **Templates**.
4. Locate the desired template on the "Overview" page and select the ellipsis (three dots) in the **Actions** column, then select **Preview and Generate**.
5. Complete the forms on the **Preview and Generate Config** dialog in sequence, selecting **Next** to move forward:
    - **Choose Publish Options**: Specify where to publish the template by selecting either:
      - **Publish to an Instance**: To apply the configuration to a single NGINX instance.
      - **Publish to an Instance Group**: To apply the configuration to multiple instances managed as an instance group.
      - **Save to a Staged Config**: To stage the configuration for future deployment.
      - **Save as a New Staged Config**: To create a brand new staged configuration for later use.
    - **Augments** (Optional): Include any augment templates needed to enhance a base configuration with additional features.
    - **Base and Augment Inputs**: Enter the required configuration inputs for the chosen templates.
    - **Preview Config**: Use the filename dropdown to review the output for each configuration.
6. After verifying the configurations, select **Publish**. If you've published to an instance or instance group, the template submission will tracked on the **Template Submissions** page.
7. Once the submission is accepted and confirmed, select **Close and Exit**.

---

## Editing a Template Submission

{{<call-out "important" "Existing configs will be overwritten" >}}
When you edit a template submission, it is important to note that the current NGINX configuration, alongside all previous submissions and inputs for your target, will be replaced. This ensures that your NGINX instances always run the most up-to-date configurations derived from the latest inputs.
{{</call-out>}}

When managing your NGINX configurations, you might find that certain parameters need updating to keep up with changing requirements. Rather than creating a new template submission for every minor adjustment, you have the flexibility to edit the latest template submission. This process allows you to modify the existing inputs to the preferred settings, providing a streamlined approach to configuration management.

To edit a template submission:

1. Open your web browser, go to the Fully Qualified Domain Name (FQDN) of your NGINX Management Suite host, and log in.
2. Select **Instance Manager** from the LaunchPad.
3. On the left sidebar, select **Template Submissions** to view a list of all template submissions.
4. Locate and select the template submission you want to edit.
5. Select the tab that corresponds to the type of target for your template submission: **Instances**, **Instance Groups**, or **Staged Configs**.
6. Find the template target you intend to edit. Select the ellipsis (three dots) in the **Actions** column next to the target, then select **Edit Submission**.
7. Complete the forms on the **Preview and Generate Config** dialog in sequence, selecting **Next** to move forward. As you proceed, update any existing inputs to the new settings you wish to apply.
8. When you reach the **View Changes** section, you have the opportunity to compare the previous submission against the new one. Use the **Diff Mode** option to view differences either side-by-side or inline.
9. After you verify the configurations are correct, select **Publish** to update the template submission with your changes and publish the config.
10. Once the updated submission is successfully accepted and confirmed, select **Close and Exit** to complete the editing process.

---

## Additional Templating Resources

{{< include "nim/templates/additional-templating-resources.md" >}}

