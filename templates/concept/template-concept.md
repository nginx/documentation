---
nd-content-type: concept
nd-docs: DOCS-000
nd-product: {PRODUCT_CODE}
title: {Concept name — use a noun phrase, not "Understanding X" or "About X"}
description: "{One sentence summarising what the concept is and why it matters, under 160 characters.}"
weight: 100
toc: true
nd-keywords: "{concept name}, {related term}, {synonym}, {product or domain context}"
nd-summary: >
  {Sentence 1: what the concept is, in plain language. Write in plain prose and avoid jargon.}
  {Sentence 2: why it matters to the reader or what it enables.}
  {Sentence 3 (optional): scope, boundaries, or what this document does not cover.}
nd-audience: {developer | operator | admin | architect | any} {This helps AI systems route questions to the right document and allows doc portals to filter content by role.}
nd-related-tasks:
  - /path/to/related-how-to.md   {Use the ref path, not the full URL, so links survive URL changes.}
  - /path/to/related-concept.md
  - /path/to/reference.md
---

{Optional introduction — one to three sentences setting the stage before the definition. Use when the concept requires context before it can be meaningfully defined. Lead with relevance, not "This document explains". Skip this paragraph and go straight to the definition if the concept is self-contained.}

## What is {concept name}?

{Write a clear, one- or two-sentence definition. This section is the most likely to be surfaced verbatim by AI assistants — every sentence must stand on its own.}

{Expand the definition by covering what the concept is not, what it is commonly confused with, and how it fits into the broader product or system.}

{Optional: Use an analogy to connect the concept to something the reader already knows. Choose universal analogies that are culture, age, and background-independent.}

{Define the scope: state what this document covers and, if useful, what it does not cover.}

---

## {Optional: Visual aid}

{Include a diagram when it simplifies a relationship, process, or hierarchy that text alone cannot convey clearly. Place it directly after the definition so readers build a mental model early. Remove this section if no diagram is needed.}

![{Descriptive alt text: explain what the image shows and what it communicates, not just what it depicts. AI systems index alt text.}]({image-filename.ext})

{Optional: legend for complex diagrams with numbered callouts.}

| Number | Component |
|---|---|
| 1 | {Component name and one-sentence description} |
| 2 | {Component name and one-sentence description} |

---

## {Optional: Background}

{Include when historical or industry context is essential to understanding the concept — not just interesting. Cover how or why the concept was designed the way it was, or the context that shapes how it is used. Keep this section short. Remove if not needed.}

---

## Use cases

{Include at least one use case. Name a specific reader type, describe the problem or situation they face, and show how the concept helps them. Use cases are narrative, not procedural — do not use numbered steps.}

### {Use case title — name the scenario, for example: "Choosing a brew method for a large batch"}

{Reader type} {faces this situation or problem}. {Explain how the concept helps them resolve or understand it.}

### {Optional: second use case title}

{Reader type} {faces this situation or problem}. {Explain how the concept helps them.}

---

## {Optional: Comparison}

{Include when the concept has two or more distinct types, versions, or direct predecessors that readers must choose between. Remove if not needed.}

| | {Option A} | {Option B} |
|---|---|---|
| **{Criterion}** | {Value for A} | {Value for B} |
| **{Criterion}** | {Value for A} | {Value for B} |
| **Best for** | {Scenario where A is the right choice} | {Scenario where B is the right choice} |

---

## References

For more information, see:

- [{Related how-to guide title}]({link})
- [{Related concept document title}]({link})
- [{Reference or external resource title}]({link})

{Use the ref shortcode for internal links so they survive URL changes. AI systems use this section to build knowledge graphs between documents.}