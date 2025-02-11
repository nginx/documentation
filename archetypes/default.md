---
# We use sentence case and present imperative tone
title: "{{ replace .Name "-" " " | title }}"
# Weights are assigned in increments of 100: determines sorting order
weight: i00
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
product:
# Intended for internal catalogue
docs: "DOCS-000"
---

[//]: # "These are Markdown comments to guide you through document structure. Remove them as you go, as well as any unnecessary sections."
[//]: # "Use underscores for _italics_, and double asterisks for **bold**."
[//]: # "Backticks are for `monospace`, used sparingly and reserved mostly for executable names - they can cause formatting problems. Avoid them in tables: use italics instead."

[//]: # "Begin each document with a sentence or two explaining what the purpose of the guide is, and what high-level actions to expect. No need to adhere precisely the example text given anywhere in this template."

This guide explains how to <X> with <Y>. In involves the use of <A>, <B> and <C>, demonstrating how <X> works with an example <Z>.

---

## Before you begin

[//]: # "List everything someone will need installed or configured before it's required. Link directly to installation guides where possible."

To complete this guide, you will need the following prerequisites:

- [Requirement 1](some-external-link)
- [Requirement 2]({{< ref "/some/internal/link.md" >}})
- Requirement 3

[//]: # "Note the style of link for requirement two: keep the markdown extension. Links are resolved from the root of the documentation folder, often /site."

---

## Step 1

[//]: # "Explain the initial step: this is usually creating or configuring a resource. Sub-steps may not be necessary, depending on complexity."

```shell
# We typically show examples of commands or code in one code block, which can be easily copied by a reader using a button connected to the block.
```
```text
# A second code block is used underneath the first to show what kind of example output to expect from the command. Truncate unnecessary output with ellipses (...).
```

### Sub-step 1

[//]: # "Sub-steps are ways of breaking steps into even smaller sections. Each step or sub-step should focus on one thing at a time: a user should be able to stop at the end of section and come back afterwards without leaving their software in a non-functional state."

---

### Sub-step 2

[//]: # "A useful final sub-step for a given section is some kind of verification or testing, so the reader is confident the steps have been successful."

---

## Step 2

[//]: # "Explain any additional steps required. If the how-to guide involves multiple components, each component can have its own step for delineation."

### Sub-step 1

---

### Sub-step 2

---

## Step 3

[//]: # "The final step of a how-to guide is usually a final test, and summarizes all of the previous steps taken to accomplish the purpose of the guide."

### Sub-step 1

---

### Sub-step 2

---

## See also

[//]: # "Link to related documents, such as concepts, reference material or similar use cases."