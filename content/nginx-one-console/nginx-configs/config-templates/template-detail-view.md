---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NONECO
title: View template details
toc: true
weight: 110
---

# Overview

This guide explains how to view detailed information about a template using the NGINX One Console. The Template Detail page provides key metadata about a template and its version history through two tabs: **Details** and **Versions**.

## Navigate to the Template Detail page

1. In the NGINX One Console, go to **Manage > Config Templates**.
2. Select a template name from the list.

The Template Detail page opens showing the **Details** tab by default. Select the **Versions** tab to view the full version history.

## Details tab

The **Details** tab displays a summary card with the following fields:

{{<bootstrap-table "table table-striped table-bordered">}}
| Field | Description |
|-------|-------------|
| **Created** | The date and time the template was originally created. |
| **Type** | The template type: `base` or `augment`. See [Template types]({{< ref "author-templates.md#template-types" >}}) for details. |
| **Object ID** | The unique identifier for the template (`tmpl_...`). Use the copy button to copy this value for template-level API operations such as [updating metadata]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/updateTemplateMetadata" >}}) or [copying a template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/copyTemplate" >}}). |
| **State** | The state of the latest template version: `draft` (editable) or `final` (immutable, shown with a lock icon). |
| **Latest Version** | The version number of the most recent template version. |
| **Description** | The human-readable description of the template, if one was provided. |
| **Latest Object ID** | The unique identifier for the latest template version (`tmplv_...`). Use the copy button to copy this value for version-level API operations, such as providing the `object_id` when [submitting templates]({{< ref "submit-templates.md" >}}). |
{{</bootstrap-table>}}

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

## See also

- [View template versions]({{< ref "template-versions.md" >}})
- [Author templates]({{< ref "author-templates.md" >}})
- [Import templates]({{< ref "import-templates.md" >}})
- [Submit templates]({{< ref "submit-templates.md" >}})
