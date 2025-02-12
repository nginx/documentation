---
# We use sentence case and present imperative tone
title: "{{ replace .Name "-" " " | title }}"
# Weights are assigned in increments of 100: determines sorting order
weight: i00
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: tutorial
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

This guide is a tutorial on how to set up <thing>. While going through the steps of this tutorial, <concept 1>, <concept 2> and <concept 3> will be introduced and explained to understand how <thing> works.

By the end of the tutorial, you should have enough working knowledge of <thing> to develop your own <configuration/application/etc>.

## Background

[//]: # "The largest difference between a tutorial and a how-to document is the scope of detail included. While working on the tutorial, consider what overlap might exist with a concept document."
[//]: # "We want to reduce the amount of context switching a reader has to go through, so it might be beneficial to convert some text content into an include for re-use between a tutorial and a concept document."

<thing> is a common use for <product>: it enables the ability to use <feature 1>, <feature 2> and <feature 3>, which are important when configuring <product> for <use case>.

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

[//]: # "The text immediately following a heading in a tutorial should likely explain a concept to build a mental model of what the reader is about to do."
[//]: # "If it's a successive step (One after the first), you might refer to work already done to follow the sequence of operations."

The first thing required for setting up <thing> is <step name>. This is the <service/host/etcetera> that the <thing> will run on. The <component> that is set-up from this step is necessary for <requirement>, and will be connected to <other component> and <third component> in a later step. The <thing> we are configuring will look something along the lines of this by the end:

[//]: # "If it helps, include a diagram of some kind. Ensure your description provides all the context required, however: a diagram is an aid to explain things, not a replacement."

```mermaid
# You can use Mermaid to draw diagrams in a codeblock with mermaid as the language.
# Read their documentation for usage: https://mermaid.js.org/intro/
```

Starting from the <top/left> of the diagram, you can see that <thing> is connected to <other thing>: this relationship is established when configuring <parameter> as part of <file name>.

---

### Sub-step 1

[//]: # "The sub-steps of a tutorial should show the exact steps a reader should take to accomplish an action, and what to expect when doing so."
[//]: # "Though there may be multiple ways to accomplish a task, focus on showing the reader the exact way to do one."
[//]: # "You can mention alternative paths, but do not give unnecessary detail: it detracts from the task at hand."

To set up <component>, start by running the following command. It will create <dependency 1>: take note of the <unique identifier> value, as it will be used for connecting <other component> in later steps.

```shell
# We typically show examples of commands or code in one code block, which can be easily copied by a reader using a button connected to the block.
```
```text
# A second code block is used underneath the first to show what kind of example output to expect from the command. Truncate unnecessary output with ellipses (...).
```

To verify the creation of <component>, you can also inspect information about it using <command>. The output should look something like this:

```shell
<a copyable, single line command>
```
```
<the output of that command, possibly truncated and with changed IPs or domains>
```

---

### Sub-step 2

---

## Step 2

[//]: # "Explain any additional steps required. If the tutorial involves multiple components, each component can have its own step for delineation."

---

### Sub-step 1

---

### Sub-step 2

---

## Conclusion

[//]: # "Summarize everything that the reader will have learned and accomplished by the end of this tutorial."
[//]: # "It should fulfill the promise made by the introductory paragraph at the top of the document."
[//]: # "You may wish to link to another tutorial as the next logical step, but that could also be part of the 'See also' section."

---

## See also

[//]: # "Link to related documents, such as concepts, reference material or similar use cases."