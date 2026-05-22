---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NONECO
title: View template submissions
toc: true
weight: 130
---

# Overview

This guide explains how to view and manage submissions associated with a template using the NGINX One Console. The **Submissions** section on the [Template Detail page]({{< ref "template-detail-view.md" >}}) lists every submission made using that template.

Each row represents a persisted submission that was created by the [Submit Templates]({{< ref "submit-templates.md" >}}) API. From this view you can inspect which templates and targets are involved in each submission and delete submissions that are no longer needed.

## Navigate to the Submissions section

1. In the NGINX One Console, go to **Manage > Config Templates**.
2. Select a template name from the list.
3. On the **Details** tab, scroll down to the **Submissions** section below the metadata card.

## Submissions data grid

The **Submissions** section displays the following columns:

{{<bootstrap-table "table table-striped table-bordered">}}
| Column | Description |
|--------|-------------|
| **Created On** | The date and time the submission was originally created. |
| **Description** | The description provided when the submission was created, if one was set. |
| **Templates** | Tag list of all templates included in the submission (base and augments). Hover over a tag to see the template name, type, version used, and latest available version. |
| **Targets** | A count badge showing the number of staged config targets the submission published to. Hover over the badge to see each target's object ID. |
| **Last Modified** | The date and time the submission was last updated. |
{{</bootstrap-table>}}

The list supports sorting by **Created On**, **Description**, and **Last Modified**, and text search across all visible columns.

{{< call-out "tip" >}}
The **Templates** column tooltip surfaces the version used at submission time alongside the latest available version. If these differ, a newer version of the template is available and the submission can be updated using [Update a submission]({{< ref "submit-templates.md#update-a-submission" >}}).
{{< /call-out >}}

## Delete a submission

To delete a submission, select the **Delete** action on the submission row and confirm the dialog.

{{< call-out "caution" >}}
Deleting a submission is **irreversible** and permanently removes all stored input values and payloads for that submission. The target staged config is not affected — only the submission record is deleted.
{{< /call-out >}}

## Refresh

Select **Refresh** at the top right of the **Details** tab to reload both the template metadata card and the submissions list from the server.

## API reference

The **Submissions** section uses the following API operations:

- [List Template Submissions for Template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listTemplateSubmissionsForTemplate" >}}) — retrieves all submissions scoped to a specific template.
- [Delete a Template Submission]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteTemplateSubmission" >}}) — permanently removes a submission by its `submissionObjectID`.

For full submission management operations including retrieving, updating, and deleting submissions via the API, see [Manage template submissions]({{< ref "submit-templates.md#manage-template-submissions" >}}).

## See also

- [View template details]({{< ref "template-detail-view.md" >}})
- [Submit templates]({{< ref "submit-templates.md" >}})
- [View template versions]({{< ref "template-versions.md" >}})
