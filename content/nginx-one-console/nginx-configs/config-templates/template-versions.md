---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NGINX One Console
title: View template versions
description: "View and manage the version history of a config template on the Versions tab in NGINX One Console."
toc: true
weight: 120
f5-keywords: "template versions, config templates, NGINX One Console, version history, draft, final, template state, delete version, templateVersionObjectID, version data grid"
f5-summary: >
  Use the Versions tab on the Template Detail page to view and manage the version history for a config template in NGINX One Console.
  Each row shows the version number, last modified date, description, and how many submissions reference that version.
  This guide covers how to go to the Versions tab, read the data grid, and delete a version.
f5-audience: operator
---

## Overview

Use this page to view and manage the version history for a config template in NGINX One Console. The **Versions** tab on the [Template Detail page]({{< ref "template-detail-view.md" >}}) lists every version for a template and shows how many submissions reference each version.

A new version is created each time the template content changes. Versions have two states:

- **`draft`** — editable; content can still be updated in place.
- **`final`** — immutable; any further content changes create a new draft version.

## Before you begin

Before you begin, make sure you have:

- **NGINX One Console access**: You need permission to view config templates.
- **An existing template**: At least one template must exist in **Manage > Config Templates**.

## Go to the Versions tab

1. In the NGINX One Console, go to **Manage > Config Templates**.
2. Select a template name from the list.
3. Select the **Versions** tab.

## Versions data grid

The **Versions** tab displays the following columns:

{{<table>}}
| Column | Description |
|--------|-------------|
| **Version** | The sequential version number. Version 1 is the initial version created at import. Each subsequent content change increments this number. |
| **Modified** | The date and time the version was last modified. |
| **Description** | The description associated with the template version, if the author provided one. |
| **Submissions** | The total number of template submissions that reference this specific version. |
{{</table >}}

You can sort the list by **Version**, **Modified**, or **Description**. You can also search across all visible columns.

{{< call-out "note" >}}
The **Submissions** count reflects the number of submissions referencing a specific version, not the latest version overall. A version with a non-zero submission count cannot be deleted.
{{< /call-out >}}

## Delete a version

To delete a template version, select **Delete** on the version row and confirm the pop-up window.

{{< call-out "important" >}}
The following constraints apply when deleting a template version:

- **The latest version cannot be deleted.** To remove the entire template including the latest version, use [Delete a Template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteTemplate" >}}) instead.
- **A version with associated submissions cannot be deleted.** The **Submissions** column shows the count. Delete the associated submissions before deleting the version.
{{< /call-out >}}

## Refresh

Select **Refresh** at the top right of the page to reload the version list from the server.

## API reference

The **Versions** tab uses the following API operations:

- [List template versions]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listTemplateVersions" >}}) — retrieves all versions for a template.
- [Delete a template version]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteTemplateVersion" >}}) — deletes a specific version by its `templateVersionObjectID`. Returns `409 Conflict` if the version has associated submissions.

## Troubleshooting

### Version can't be deleted

**Symptom**: The **Delete** action is unavailable or returns an error.

**Cause**: The version has associated submissions, or it's the latest version.

**Fix**: Check the **Submissions** column count. Delete any associated submissions before deleting the version. To remove the entire template including the latest version, use the [Delete a Template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteTemplate" >}}) API operation.

## References

For more information, see:

- [View template details]({{< ref "template-detail-view.md" >}})
- [Author templates]({{< ref "author-templates.md" >}})
- [Submit templates]({{< ref "submit-templates.md" >}})
