---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NGINX One Console
title: View template details
description: "View metadata, submissions and version history for a config template on the Template Detail page in NGINX One Console."
toc: true
weight: 110
f5-keywords: "template details, config templates, NGINX One Console, template metadata, template submissions, template versions, Object ID, template state, F5 default template, tmpl, tmplv"
f5-summary: >
  Use the Template Detail page in NGINX One Console to view metadata, submissions and version history for a config template.
  The Details tab shows the template's type, state, object IDs, and all submissions created with it. The Versions tab lists every version with submission counts and timestamps.
  This guide covers how to go to the Template Detail page, read each tab, and use the related API operation.
f5-audience: operator
---

## Overview

Use this page to view metadata, submissions and version history for a config template in NGINX One Console. The Template Detail page has two tabs: **Details** and **Versions**.

## Before you begin

Before you begin, make sure you have:

- **NGINX One Console access**: You need permission to view config templates.
- **An existing template**: At least one template must exist in **Manage > Config Templates**.

## Go to the Template Detail page

1. In the NGINX One Console, go to **Manage > Config Templates**.
2. Select a template name from the list. F5 templates show the F5 logo icon in the list.

The **Details** tab opens by default. Select the **Versions** tab to view the full version history.

## Details tab

The **Details** tab contains a metadata summary card for the template and a [Submissions section]({{< ref "template-submissions-view.md" >}}) below it listing all submissions created with this template.

The metadata summary card displays the following fields:

{{<table>}}
| Field | Description |
|-------|-------------|
| **Created** | The date and time the template was created. |
| **Type** | The template type: `base` or `augment`. See [Template types]({{< ref "author-templates.md#template-types" >}}) for details. |
| **Is F5 Default** | Displayed for templates provided by F5. F5 default templates are immutable and cannot be modified or deleted. |
| **Object ID** | The unique identifier for the template (`tmpl_...`). Use this value in API operations for the template, such as [updating metadata]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/updateTemplateMetadata" >}}) or [copying a template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/copyTemplate" >}}). Select the copy button to copy it. |
| **State** | The state of the latest template version: `draft` (editable) or `final` (immutable, shown with a lock icon). |
| **Latest Version** | The version number of the most recent template version. |
| **Description** | The human-readable description of the template, if the author provided one. |
| **Latest Object ID** | The unique identifier for the latest template version (`tmplv_...`). Use the copy button to copy this value for version-level API operations, such as providing the `object_id` when [submitting templates]({{< ref "submit-templates.md" >}}). |
{{</table >}}

{{< call-out "tip" >}}
Both **Object ID** and **Latest Object ID** are copyable directly from the UI.

- **Object ID** (`tmpl_...`) identifies the template itself and is used for template-level operations (metadata updates, copy, delete, listing versions).
- **Latest Object ID** (`tmplv_...`) identifies the current version and is used as the `object_id` in submission requests.
{{< /call-out >}}

## Versions tab

The **Versions** tab lists every version created for the template, along with submission counts and modification timestamps. See [View template versions]({{< ref "template-versions.md" >}}) for full details.

## Refresh

Select **Refresh** at the top right of the page to reload the template details from the server.

## API reference

The Template Detail page uses the [Retrieve a Template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/getTemplate" >}}) API operation, which returns the latest version details including metadata, file contents, and submission count.

## Troubleshooting

### Template details don't load

**Symptom**: The Template Detail page shows no data or an error.

**Cause**: The template may have been deleted, or you may not have permission to view it.

**Fix**: Go to **Manage > Config Templates** and confirm the template exists. If it does, ask your administrator to check your access permissions.

## References

For more information, see:

- [View template versions]({{< ref "template-versions.md" >}})
- [View template submissions]({{< ref "template-submissions-view.md" >}})
- [Author templates]({{< ref "author-templates.md" >}})
- [Import templates]({{< ref "import-templates.md" >}})
- [Submit templates]({{< ref "submit-templates.md" >}})
