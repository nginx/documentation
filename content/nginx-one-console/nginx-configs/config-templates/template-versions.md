---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NONECO
title: View template versions
toc: true
weight: 120
---

# Overview

This guide explains how to view and manage the version history of a template using the NGINX One Console. The **Versions** tab on the [Template Detail page]({{< ref "template-detail-view.md" >}}) lists every version created for a template and shows how many active submissions reference each version.

A new version is created each time the template content changes. Versions progress through two states:

- **`draft`** — editable; content can still be updated in place.
- **`final`** — immutable; any further content changes create a new draft version.

## Navigate to the Versions tab

1. In the NGINX One Console, go to **Manage > Config Templates**.
2. Select a template name from the list.
3. Select the **Versions** tab.

## Versions data grid

The **Versions** tab displays the following columns:

{{<bootstrap-table "table table-striped table-bordered">}}
| Column | Description |
|--------|-------------|
| **Version** | The sequential version number. Version 1 is the initial version created at import. Each subsequent content change increments this number. |
| **Modified** | The date and time the version was last modified. |
| **Description** | The description associated with the template version, if one was provided. |
| **Submissions** | The total number of template submissions that reference this specific version. |
{{</bootstrap-table>}}

The list can be sorted by **Version**, **Modified**, or **Description**, and supports text search across all visible columns.

{{< call-out "note" >}}
The **Submissions** count reflects the number of submissions referencing a specific version, not the latest version overall. A version with a non-zero submission count cannot be deleted.
{{< /call-out >}}

## Delete a version

To delete a template version, select the delete action on the version row and confirm the dialog.

{{< call-out "important" >}}
The following constraints apply when deleting a template version:

- **The latest version cannot be deleted.** To remove the entire template including the latest version, use [Delete a Template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteTemplate" >}}) instead.
- **A version with associated submissions cannot be deleted.** The **Submissions** column shows the count. Resolve or delete the associated submissions before attempting to remove the version.
{{< /call-out >}}

## Refresh

Select **Refresh** at the top right of the page to reload the version list from the server.

## API reference

The **Versions** tab uses the following API operations:

- [List template versions]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listTemplateVersions" >}}) — retrieves all versions for a template.
- [Delete a template version]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteTemplateVersion" >}}) — deletes a specific version by its `templateVersionObjectID`. Returns `409 Conflict` if the version has associated submissions.

## See also

- [View template details]({{< ref "template-detail-view.md" >}})
- [Author templates]({{< ref "author-templates.md" >}})
- [Submit templates]({{< ref "submit-templates.md" >}})
