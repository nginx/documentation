---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NGINX One Console
title: View template submissions
description: "View and manage template submissions for a config template in NGINX One Console."
toc: true
weight: 130
f5-keywords: "template submissions, config templates, NGINX One Console, submission management, template detail, delete submission, Submit Templates API, submissionObjectID, staged config"
f5-summary: >
  Use the Submissions section on the Template Detail page to view and manage all submissions created for a config template in NGINX One Console.
  Each submission row shows which templates and targets were involved, when the submission was created, and when it was last updated.
  This guide covers how to go to the Submissions section, read the data grid, delete a submission, and use the related API operations.
f5-audience: operator
---

## Overview

Use this page to view and manage template submissions in NGINX One Console. The **Submissions** section on the [Template Detail page]({{< ref "template-detail-view.md" >}}) lists every submission for that template.

Each row is a submission the [Submit Templates]({{< ref "submit-templates.md" >}}) API created. You can inspect which templates and targets are in each submission and delete submissions you no longer need.

## Before you begin

Before you begin, make sure you have:

- **NGINX One Console access**: You need permission to view and manage config templates.
- **An existing template**: At least one template must exist in **Manage > Config Templates**.

## Go to the Submissions section

1. In the NGINX One Console, go to **Manage > Config Templates**.
2. Select a template name from the list.
3. On the **Details** tab, scroll down to the **Submissions** section below the metadata card.

## Submissions data grid

The **Submissions** section displays the following columns:

{{<table>}}
| Column | Description |
|--------|-------------|
| **Created On** | The date and time the submission was created. |
| **Description** | The description provided when the submission was created, if one was set. |
| **Templates** | Tag list of all templates included in the submission (base and augments). Hover over a tag to see the template name, type, version used, and latest available version. |
| **Targets** | A count badge showing the number of staged config targets the submission published to. Hover over the badge to see each target's object ID. |
| **Last Modified** | The date and time the submission was last updated. |
{{</table >}}

You can sort the list by **Created On**, **Description**, and **Last Modified**. You can also search across all visible columns.

{{< call-out "tip" >}}
The **Templates** column tooltip shows the version used at submission time alongside the latest available version. If these differ, a newer version of the template is available. You can update the submission using [Update a submission]({{< ref "submit-templates.md#update-a-submission" >}}).
{{< /call-out >}}

## Delete a submission

To delete a submission, select **Delete** on the submission row and confirm the pop-up window.

{{< call-out "caution" >}}
Deleting a submission is **irreversible** and permanently removes all stored input values and payloads for that submission. Deleting the submission record doesn't affect the target staged config.
{{< /call-out >}}

## Refresh

Select **Refresh** at the top right of the **Details** tab to reload both the template metadata card and the submissions list from the server.

## API reference

The **Submissions** section uses the following API operations:

- [List Template Submissions for Template]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listTemplateSubmissionsForTemplate" >}}) — retrieves all submissions scoped to a specific template.
- [Delete a Template Submission]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteTemplateSubmission" >}}) — permanently removes a submission by its `submissionObjectID`.

For full submission management including retrieving, updating, and deleting submissions through the API, see [Manage template submissions]({{< ref "submit-templates.md#manage-template-submissions" >}}).

## Troubleshooting

### Submissions list is empty

**Symptom**: The **Submissions** section shows no rows.

**Cause**: No submissions have been created for this template yet.

**Fix**: Use the [Submit Templates]({{< ref "submit-templates.md" >}}) API to create a submission.

## References

For more information, see:

- [View template details]({{< ref "template-detail-view.md" >}})
- [Submit templates]({{< ref "submit-templates.md" >}})
- [View template versions]({{< ref "template-versions.md" >}})
