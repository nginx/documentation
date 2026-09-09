---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NGINX One Console
title: Submit and copy templates from the Templates list
description: "Use the Submit and Make a Copy row actions on the Templates list to submit or copy config templates without API calls."
toc: true
weight: 150
f5-keywords: "templates list, config templates, NGINX One Console, submit template, Submit Template panel, make a copy, copy a template, template submission, base template, augment template"
f5-summary: >
  Use the Submit and Make a Copy row actions on the Templates list to work with config templates.
  These actions offer a guided UI, instead of the Templates API.
  Select Submit to open the Submit Template panel. Select a base template, enter parameter values, add optional augment templates, select a target, and preview the configuration.
  Select Make a Copy to create a new draft template from the latest version of an existing template.
f5-audience: operator
---

## Overview

The Templates list in NGINX One Console has two row actions: **Submit** and **Make a Copy**. Use these actions to work with config templates instead of building Templates API requests by hand.

Select **Submit** on a finalized base template to open the **Submit Template** panel. The panel guides you through filling in parameter values. You can preview the rendered NGINX configuration before you save.

Select **Make a Copy** on any template to create a new draft template from its latest version.

## Before you begin

Before you begin, make sure you have:

- NGINX One Console access: You need template write permission to use the **Submit** and **Make a Copy** row actions.
- An imported template: At least one template must exist in **Manage** > **Config Templates**. If you don't have any templates yet, import one first. See [Import templates]({{< ref "import-templates.md" >}}) for instructions.
- A finalized base template: To use **Submit**, you need at least one base template in the `final` state.

## Submit a template

The **Submit** option is available for templates of type `base` that are in the `final` state.

1. Go to **Manage** > **Config Templates**. The **Templates** list opens and shows every imported template with its available row actions.
1. Select **Submit** on a base template that's in the `final` state to create a template submission from the Templates list.
1. Fill in the parameter values for the base template. NGINX One Console generates the form from the template's schema.
1. (Optional) Add one or more augment templates.

   - Fill in the parameter values for each augment template.

1. Select one or more staged configs as the target. You can't target Config Sync Groups or instances directly yet.
1. Preview the rendered NGINX configuration.
1. Select **Save** to create the submission and publish it to your chosen targets.

## Edit an existing submission

You can also use the **Submit Template** panel to edit an existing submission. Open the submission from the **Submissions** section on the Template Detail page.

## Copy a template

The **Make a Copy** option is available for any template, regardless of its type or state. It creates a new draft template from the latest version of the selected template.

1. Go to **Manage** > **Config Templates**. The **Templates** list opens and shows every imported template with its available row actions.
1. Select **Make a Copy** on the template you want to copy.

NGINX One Console creates a new draft template at version 1. It copies the files, template type, and context configuration from the source template. The new template uses the same name and description. You can update them afterward.

This matches the behavior of [Copy a template]({{< ref "author-templates.md#copy-a-template" >}}), the API operation behind this action.

## What happens next

After you submit or copy a template, view the result on the [Template Detail page]({{< ref "template-detail-view.md" >}}). Submissions appear in the Submissions section for the submitted template.

## API reference

The Templates list row actions use the following API operations:

- **Submit**: Uses the [Submit Templates]({{< ref "submit-templates.md" >}}) API to create or update a template submission.
- **Make a Copy**: Uses the [Copy a template]({{< ref "author-templates.md#copy-a-template" >}}) API operation.

## See also

- [Submit templates]({{< ref "submit-templates.md" >}})
- [Author templates]({{< ref "author-templates.md" >}})
- [View template details]({{< ref "template-detail-view.md" >}})
- [View template submissions]({{< ref "template-submissions-view.md" >}})
- [Import templates]({{< ref "import-templates.md" >}})
