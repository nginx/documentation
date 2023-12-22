---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
# Change draft status to false to publish doc
draft: true
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Add a one-sentence description of the doc that'll show up in search results."
# Assign weights in increments of 100
weight: 
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "security", "analytics"]
doctypes: ["reference"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{<custom-styles>}}

## Overview

<!-- 
If your topic is for a global policy, add the following include: 

{{< include "acm/how-to/policies-intro" >}}

- OR -

If your topic is for an API GW policy, add this include:

{{< include "acm/how-to/policies-proxy-intro.md" >}}

-->

---

## About XYZ Policy

<!--
Explain what the policy does and what it can be used for.
-->

#### Intended Audience

<!--
Specify the intended audience for this guide, that is, who is responsible for applying and/or configuring the policy? For example, and Infrastructure Administrator.
-->

---

## Workflow for Applying Policy

<!--
Add the high-level steps the user must take to apply the policy. For example:

- Create an environment or edit an existing one.
- Check the advanced settings for the environment to see if the policy has been applied.
- Edit the policy to make changes for each environment. Save and publish the changes.

-->

---

## Policy Settings

<!-- Update the following table with the policy's params -->

The following table lists the configurable settings and their default values for the policy.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{< bootstrap-table "table table-striped table-bordered" >}}
| Field        | Datatype | Possible Values     | Description                                        | Required | Default               |
|--------------|----------|---------------------|----------------------------------------------------|----------|-----------------------|
| `users.id`   | integer  | A unique int >= 1   | Description for value.                             | Yes      | System assigned       |
| `users.name` | string   | Example: `Jane Doe` | A short description of what the field is used for. | Yes      | Add the default value |
| `user.age`   | integer  | 1–110               | Description for the value                          | Yes      |                       |

{{< /bootstrap-table >}}
{{< raw-html>}}</div>{{</raw-html>}}

---

## Adding XYZ Policy

{{<tabs name="policy-implementation">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To create an XYZ policy using the REST API, send an HTTP `POST` request to the Add-Endpoint-Name-Here endpoint.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{< bootstrap-table "table table-striped table-bordered" >}}
| Method | Endpoint            |
|--------|---------------------|
| `POST` | `/path/to/endpoint` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

<details open>
<summary>JSON request</summary>

``` json
{
  "users": [
    {
      "id": 1,
      "name": "John Doe",
      "age": 24
    },
    {
      "id": 2,
      "name": "Jane Doe",
      "age": 28
    }
  ]
}
```

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To create an XYZ policy using the web interface:

1. Go to the FQDN for your NGINX Management Suite host in a web browser and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. Add other steps here
3. As a numbered list.

{{%/tab%}}

{{</tabs>}}

---

## Verify the Policy

<!--
Add verification instructions to confirm that the policy has been correctly implemented and is being enforced.
-->

Confirm that the policy has been set up and configured correctly by taking these steps:

- Add steps to verify policy was applied successfully to the the management plane.

Confirm the policy is being enforced:

- Add steps to verify policy is being enforced on the data plane. What can users expect to see?

---

## Troubleshooting

<!-- Add troubleshooting steps for issues users might encounter and can self-solve. The purpose of this section is to deflect customer calls to Support. -->

For help resolving common issues when setting up and configuring the policy, follow the steps in this section. If you cannot find a solution to your specific issue, reach out to [NGINX Customer Support]({{< relref "support/contact-support.md" >}}) for assistance.

### Issue 1

Add a description for the issue. Include any error messages users might see.

Resolution/Workaround:

1. Add steps here
2. As a
3. numbered list.

### Issue 2

Add a description for the issue. Include any error messages users might see.

Resolution/Workaround:

1. Add steps here
2. As a
3. numbered list.
