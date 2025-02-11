---
# We use sentence case and present imperative tone
title: "{{ replace .Name "-" " " | title }}"
# Weights are assigned in increments of 100: determines sorting order
weight: i00
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: concept
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

This guide provides an overview of <concept>, which is used <for/in> <action 1>, <action 2> and <action 3>.

It is an example of a <other concept>, and is closely related to <third concept>.

---

## Background

[//]: # "Explain what the concept is. If possible, relate it to another commonly known concept or software."
[//]: # "This relates the new idea to the reader using their existing knowledge, helping their understanding of it and thus what its purpose is in context."

---

## Use cases

[//]: # "Name the individual use case sections after the actual use case itself, e.g "Route traffic between applications"

### Use case 1

[//]: # "A description for a use case should be a high level outline of a particular problem, then explain how the subject concept is the solution for the issue."

[//]: # "If it helps, include a diagram of some kind. Ensure your description provides all the context required, however: a diagram is an aid to explain things, not a replacement."

```mermaid
# You can use Mermaid to draw diagrams in a codeblock with mermaid as the language.
# Read their documentation for usage: https://mermaid.js.org/intro/
```

Starting from the <top/left> of the diagram, you can see that <thing> is connected to <other thing>: this relationship is established when configuring <parameter> as part of <file name>.

[//]: # "End a particular use case section with links to other pages, such as instructional documentation, other concepts, or reference information (Such as API specifications)."

- [Additional reading 1](some-external-link)
- [Additional reading 2]({{< ref "/some/internal/link.md" >}})
- Additional reading 3

### Use case 2

---

## Conclusion

[//]: # "Summarize everything that the reader will have learned by reading this entire concept document."
[//]: # "It should fulfill the promise made by the introductory paragraph at the top of the document."
[//]: # "Since each use case provides links to additional documents, you may not need to link to more,"
[//]: # "or even include the final 'See also' section."

---

## See also

[//]: # "Link to related documents, such as concepts, reference material or similar use cases."