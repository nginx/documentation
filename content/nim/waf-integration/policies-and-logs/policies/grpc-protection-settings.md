---
title: gRPC Protection settings
description: >
  Look up the settings available for gRPC Protection and gRPC Error Response in an
  F5 WAF for NGINX security policy. Use this reference when you configure a gRPC
  profile, upload IDL files, or set the response for blocked gRPC requests.
canonical: /nginx-instance-manager/waf-integration/policies-and-logs/policies/grpc-protection-settings/
toc: true
weight: 450
f5-content-type: reference
f5-product: F5 NGINX Instance Manager
f5-keywords: "gRPC, gRPC Protection, gRPC profile, IDL file, proto file, attack signature overrides, gRPC violations, gRPC error response, API Protection, WAF policy"
f5-summary: >
  Look up the gRPC Protection and gRPC Error Response settings in an F5 WAF for
  NGINX security policy. Configure these settings in the F5 NGINX Instance Manager
  security policy wizard.
f5-audience: admin
---

## Overview

Use this reference to look up the settings available for **gRPC Protection** and **gRPC Error Response** in an F5 WAF for NGINX security policy. Both sections are available under **API Protection** in the security policy wizard. To open the wizard, create a new policy or edit an existing one. See [Create a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/create-policy.md" >}}) or [Update a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/update-policy.md" >}}).

The **gRPC Protection** section contains **gRPC Profiles** and **gRPC Violations**. A gRPC profile controls how the policy inspects traffic for one gRPC service. gRPC violation actions apply to the whole policy, not to an individual profile. Select **Reset All Fields** in the gRPC Protection section to reset every profile and violation action to its default state.

**gRPC Error Response** is a separate, policy-wide section. It controls the response that F5 NGINX Instance Manager sends to a client when it blocks a gRPC request.

---

## gRPC Profiles

A gRPC profile describes how the policy inspects traffic for one gRPC service. A policy can have more than one gRPC profile. The **gRPC Profiles** table lists each profile's name, description, and status for Interface Definition Language (IDL) files and attack signatures. It also includes **Edit** and **Remove** actions for each profile.

To add a profile, select **Add Item**. To change an existing profile, select its name, or select **Edit** from the **Actions** menu. The default values in the following tables apply to a new profile. When you edit an existing profile, its displayed values can differ from these defaults.

| Name | Required | Default | Description |
|:--- |:--- |:--- |:--- |
| **Profile Name** | Yes | None | A name for the profile. It must be unique among the policy's gRPC profiles. |
| **Description** | No | None | A description of the profile's purpose. |

### gRPC Protections

| Name | Required | Default | Description |
|:--- |:--- |:--- |:--- |
| **Enable attack signatures** | No | On | Detects attack signatures and threat campaigns in gRPC traffic for this profile. When you turn on this setting, you can configure [attack signature overrides](#attack-signature-overrides). |
| **Associate URLs** | No | On | Associates URLs derived from the `.proto` package and service names. |
| **Check for illegal meta characters** | No | On | Detects disallowed metacharacters in gRPC string fields. |
| **Decode String Values as Base64** | No | Enabled | Decodes string values as Base64 before inspection. Select **Disabled** or **Enabled** based on your service's traffic. |

### Defense Attributes

| Name | Required | Default | Description |
|:--- |:--- |:--- |:--- |
| **Allow unknown fields** | No | Off | Allows request fields that aren't defined in the IDL. Leave this setting off when requests must follow the IDL strictly. |
| **Maximum Data Length** | No | `4194304` bytes (4 MiB) | Sets the maximum size, in bytes, of a gRPC message the profile accepts. Enter a positive byte value, or `any` for no limit. |

### IDL Files

Upload the IDL definitions that describe your gRPC service and its imports. You can drag and drop files, or select to browse for them. The wizard accepts `.proto`, `.tar`, `.tgz`, and `.tar.gz` files.

| Name | Required | Default | Description |
|:--- |:--- |:--- |:--- |
| **Primary** / **Set as Primary** | Yes, for one file in the profile | The first accepted file | Identifies the main IDL file or archive for the profile. Exactly one file must be primary. If you remove the primary file, the first remaining file becomes primary. |
| **Import Path** | No | None | Sets the import location for a non-primary file. |
| **Primary entry file name** | Yes, for an archive | None | Names the primary `.proto` file inside an uploaded archive, not the name of the archive itself. |
| **Remove** | n/a | n/a | Removes a file from the profile. |

Keep the following in mind:

- Each uploaded `.proto` file must declare `syntax = "proto3";`.
- You can save a profile without any IDL files, but supply the definitions and imports your service needs before you compile the policy.
- The wizard doesn't inspect the contents of an archive. Make sure the archive includes the primary file and its dependencies, then check the policy compilation results.
- If an uploaded file has the same name as a file already used elsewhere in the policy, rename it and upload it again. The wizard also rejects duplicate names within a single profile or upload batch.
- Some existing file references display as read-only. You can remove a read-only entry, but you can't edit it in the file list.

### Attack Signature Overrides

Use Attack Signature Overrides to change detection settings for individual attack signatures in this profile. This section is available when you turn on **Enable attack signatures**.

| Name | Required | Default | Description |
|:--- |:--- |:--- |:--- |
| **Add Item** | n/a | n/a | Opens the **Add Attack Signature Overrides** dialog, where you select individual signatures to override for this profile. The dialog lists each signature's name, ID, attack type, accuracy, and risk. |
| **Enabled control** | No | Off | Turns an existing override on or off for this profile. |
| **Remove** | n/a | n/a | Removes an override from the list when you no longer need it. |

A new override is off by default. If you turn off a signature for this profile, you reduce detection. Review overrides carefully before you turn one off.

### Save or discard profile changes

After you add or edit a profile, select **Save Changes** (or **Add Profile** for a new profile) to apply your changes. Select **Cancel** to discard unsaved changes. Select **Remove** from the **Actions** menu to remove a profile entirely.

---

## gRPC Violations

Select **Edit Configuration** in the **gRPC Violations** section to choose an enforcement action for each violation type. This setting applies to the whole policy, not to an individual profile.

| Violation type | Default | Description |
|:--- |:--- |:--- |
| **gRPC data does not comply with format settings** | Alarm | Detects content that doesn't comply with profile restrictions, such as message length or unknown fields. |
| **Malformed gRPC data** | Alarm and Block | Detects malformed or unparsable gRPC content. |
| **Illegal gRPC method** | Alarm | Detects a request for a gRPC service method that isn't defined in the IDL. |

Set each violation type's enforcement action to one of the following:

| Action | Description |
|:--- |:--- |
| **Alarm** | Reports the violation. Doesn't block the request. |
| **Alarm and Block** | Reports the violation and blocks the request. |
| **Disabled** | Doesn't enforce the violation. |

Whether NGINX Instance Manager blocks a request also depends on the policy's enforcement mode and deployment configuration. For example, a policy in transparent mode doesn't block a request, even if you set its violation action to **Alarm and Block**.

See [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

---

## gRPC Error Response

Under **API Protection** > **gRPC Error Response**, configure the single, policy-wide response NGINX Instance Manager returns for a blocked gRPC request. All three fields are optional. If you clear all three, NGINX Instance Manager removes the configured gRPC error response.

| Name | Required | Default | Description |
|:--- |:--- |:--- |:--- |
| **gRPC Status Code** | No | None | A named status code to return to the client. Search the list, or select **Clear Selection** to remove a chosen code. Accepted values: `ABORTED`, `ALREADY_EXISTS`, `CANCELLED`, `DATA_LOSS`, `DEADLINE_EXCEEDED`, `FAILED_PRECONDITION`, `INTERNAL`, `INVALID_ARGUMENT`, `NOT_FOUND`, `OK`, `OUT_OF_RANGE`, `PERMISSION_DENIED`, `RESOURCE_EXHAUSTED`, `UNAUTHENTICATED`, `UNAVAILABLE`, `UNIMPLEMENTED`, and `UNKNOWN`. |
| **gRPC Status Message** | No | None | A message to accompany the status. Avoid exposing internal security or service details in this message. |
| **Response Content** | No | None | Content to return in the response body for the blocked request. |

---

## See also

- [Protect gRPC services using external .proto files]({{< ref "/nim/waf-integration/policies-and-logs/policies/grpc-protection-external-files.md" >}})
- [Create a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/create-policy.md" >}})
- [Update a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/update-policy.md" >}})
- [Add signature sets and exceptions]({{< ref "/nim/waf-integration/policies-and-logs/policies/add-signature-sets.md" >}})
- [Add cookies, parameters, and URLs]({{< ref "/nim/waf-integration/policies-and-logs/policies/cookies-parameters-urls.md" >}})
- [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}})
