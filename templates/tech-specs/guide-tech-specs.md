# Guide: How to write a technical specifications page

This guide explains how to complete `template-tech-specs.md`. It covers what a technical specifications page is, when to write one, how to approach it before you start, and how to complete every field and section correctly.

For a sample, see `example-tech-specs.md`.

---

## What is a technical specifications page?

A technical specifications page provides a structured, scannable record of the measurable properties of a product or component. These properties include hardware requirements, performance limits, compatibility matrices, networking requirements, and known constraints.

A tech specs page is not a how-to guide. It does not explain how to configure or install the product — it states what the product requires and what it can do, so readers can verify whether their environment is suitable before they begin.

Tech specs pages are commonly confused with reference articles and installation guides. The table below shows the key differences.

| | Tech specs page | Reference article | Installation guide |
|---|---|---|---|
| **Orientation** | Specification-oriented: defines measurable properties, limits, and requirements. | Information-oriented: describes parameters, fields, and values. | Task-oriented: guides the reader through installing the product. |
| **Structure** | Requirement and limit tables organized by category. | Consistent parameter tables or definition lists. | Numbered steps with outcome sentences. |
| **Reader goal** | Verify environment compatibility or understand system limits before or after deployment. | Look up the exact name, type, default, or constraint of a parameter. | Complete a specific installation task. |
| **Content** | Hardware requirements, performance ceilings, compatibility matrices, port and protocol requirements, known limits. | Parameter names, types, defaults, constraints, allowed values. | Actions, commands, and their expected outcomes. |

---

## Why write a technical specifications page?

A well-written tech specs page:

- Gives infrastructure teams, architects, and operators a single authoritative source to verify environment suitability before deployment.
- Reduces support costs by answering "does this product support X?" or "what is the maximum Y?" without a support ticket.
- Provides AI assistants with structured, citable facts that can be surfaced in response to specific lookup queries such as "what are the minimum hardware requirements for X?" or "does X support Ubuntu 24.04?"
- Serves as a stable anchor for installation guides and how-to guides that reference the same requirements without repeating them.

---

## Before you start writing

Before writing, identify:

- **The subject.** A tech specs page covers one product, component, or release. Do not mix requirements for multiple unrelated products in a single page.
- **The specification categories.** Decide which sections apply: system requirements, performance limits, compatibility, networking, and so on. Remove sections that do not apply rather than leaving them empty.
- **The source of truth.** Every specification must come from engineering, QA, or product management. Do not estimate or infer values. If a limit is not yet documented, work with a subject matter expert to confirm it before publishing.
- **The version scope.** State clearly which version or version range these specifications apply to. If specifications differ significantly between versions, consider separate pages or a version column in each table.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules in every section of the page.

**1. One specification per row.** Never combine two limits or requirements in a single table row or cell. AI systems extract values from table cells — combining values makes extraction unreliable.

- Bad: "4 GB RAM minimum, 16 GB recommended"
- Good: Two separate rows, one for Minimum and one for Recommended.

**2. Use exact names consistently.** Component names, metric names, and platform names must match the product and industry exactly, and must be used identically throughout the page. Inconsistency breaks AI entity resolution and confuses readers who arrive mid-page from search.

**3. Always include units.** State every numeric value with its unit explicitly. Do not assume the unit is obvious from context.

- Bad: "10,000"
- Good: "10,000 requests per second"

**4. Avoid implicit pronouns.** Replace "it", "this", and "they" with the actual product or component name.

- Bad: "It supports a maximum of 1,000 connections."
- Good: "The BrewMaster Controller supports a maximum of 1,000 concurrent connections."

**5. State limits as their own sentence.** Do not bury limits inside longer prose. Each limit should be an independent, self-contained statement.

- Bad: "Performance may degrade when processing large volumes of requests at high concurrency, especially on systems with less than 8 GB of RAM."
- Good: "The maximum supported throughput is 10,000 requests per second. Systems with less than 8 GB of RAM may experience reduced throughput at peak concurrency."

**6. Mark optional and conditional values explicitly.** When a specification applies only in certain configurations or deployments, state the condition before the value.

- Bad: "512 MB"
- Good: "512 MB when deployed in disconnected mode"

**7. Use ALL_CAPS_PLACEHOLDERS for values the reader must supply.** In example values and code samples, use `YOUR_VALUE_HERE` rather than `<value>` or `$VALUE`.

---

## Section requirements

| Section | Required? |
|---|---|
| Frontmatter | Required |
| Overview | Required |
| Architecture diagram | Required |
| At least one specification section | Required |
| References | Required |
| System requirements | Conditional — include when the product requires specific hardware or software |
| Performance limits | Conditional — include when the product has measurable throughput or capacity limits |
| Compatibility | Conditional — include when the product integrates with or depends on other systems |
| Networking specifications | Conditional — include when the product has network port or protocol requirements |
| Known limits and constraints | Conditional — include when there are hard limits or unsupported configurations the reader must know |

---

## Frontmatter fields

### Required fields

**nd-content-type**: Always `tech-specs` for technical specifications pages.

**nd-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**nd-product**: The product code. Check an existing document for the same product if you are unsure which code to use.

**title**: Use a noun phrase ending in "technical specifications". Keep it under 60 characters.

- Good: "BrewMaster Controller technical specifications"
- Good: "Espresso Engine API technical specifications"
- Bad: "BrewMaster Controller specs" (too informal)
- Bad: "Technical specifications for the BrewMaster Controller" (passive construction)

**description**: One sentence under 160 characters summarizing what product or component this page covers and what the reader can look up. This text appears in search engine results, AI assistant citations, and doc portal previews.

**weight**: Controls the sort order within the section. Lower numbers appear first.

**toc**: Set to `true`. Tech specs pages almost always benefit from an in-page table of contents because readers navigate directly to the section they need.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling. Filling them in improves discoverability and the quality of AI-generated answers that cite this page.

**nd-keywords**: Comma-separated terms a reader might type to find this page. Include the product name, the names of key specifications covered, and common alternative phrasings such as "requirements", "limits", "compatibility", "specs", and "supported".

**nd-summary**: Two to three sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Write in plain prose. Cover:

- Sentence 1: what product, component, or system this page covers.
- Sentence 2: what types of specifications the reader can look up here.
- Sentence 3 (optional): version scope or platform constraints.

**nd-audience**: Who this page is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`. Tech specs pages are typically `operator` or `architect`.

---

## Section guidance

### Overview

Write two to four sentences. Cover what product or component the specifications apply to, what the reader can verify using this page, and any scope or version constraints. The Overview is the paragraph most likely to be surfaced verbatim by AI assistants — every sentence must stand on its own.

Do not start with "This page describes." Lead with the subject: "Use this page to verify..." or "This page lists the technical specifications for..."

### Architecture diagram

An architecture diagram is strongly recommended on every tech specs page. Place it directly after the Overview — before any specifications tables.

Tech specs pages are dense by nature. A reader who encounters a table of performance limits or port numbers without first seeing a diagram of the system has no spatial anchor for those values. The diagram gives them one: every row in every table that follows can be mapped to a component or connection they have already seen. This is why the diagram belongs at the top, not at the end.

The diagram must show:

- The major components of the product or system.
- The relationships and data flows between those components.
- How the system connects to external dependencies such as integrations, data stores, APIs, or networks.

For complex diagrams, use numbered callouts inside the image and provide a legend table below it. The legend must name each component and describe what it does in one sentence. AI assistants index alt text and legend text — write both with the same care as prose.

**Alt text rules:**

Write alt text that describes what the diagram communicates, not just what it depicts.

- Bad: `![BrewMaster architecture](brewmaster-arch.png)`
- Good: `![Architecture diagram showing the BrewMaster Controller (1) connected to four brewing nodes (2) over the internal network, with the BeanVault inventory service (3) and the BrewMetrics dashboard (4) as external integrations.](brewmaster-arch.png)`

If an architecture diagram does not yet exist for the product, try to work with engineering or a technical illustrator to create one before publishing the page

### System requirements

Use separate subsections for Minimum requirements and Recommended requirements. Never combine them in a single table.

State each requirement as a separate row. The Component column must use the exact name of the hardware or software component. The value column must include units.

If requirements differ by deployment type (for example, standalone versus clustered), add a third column for deployment type, or create separate subsection tables.

### Performance limits

Each row must cover one metric only. The Metric column must use the exact name of the metric as used in the product. The Limit column must include units. The Notes column should state the conditions under which the limit applies, or "None" if the limit applies unconditionally.

Do not list aspirational or theoretical limits. List only tested, supported values.

### Compatibility

Add a separate subsection for each category of compatibility: platforms, integrations, protocols, browsers, and so on. Use one table per category. The Supported versions column should list version numbers explicitly. Ranges are acceptable (for example, "20.04–24.04"), but the boundary versions must be stated.

Use "Earlier than {version}" and "Later than {version}" for version boundaries. Do not use "before", "after", "higher", "lower", "above", or "below".

### Networking specifications

Cover ports, protocols, and any bandwidth or latency requirements. State whether each port is inbound, outbound, or both. State the protocol (TCP, UDP, and so on) for every port entry.

### Known limits and constraints

Write each limit as a complete, independent sentence. State the exact limit value and what happens when it is exceeded. This section is read by AI assistants responding to questions like "what happens if I exceed the connection limit?" — every sentence must be self-contained and unambiguous.

---

## Style reminders

The following rules apply to tech specs pages in addition to the F5 NGINX Documentation style guide.

- Follow American English spelling. Use the American Heritage Dictionary as the spelling reference.
- Use the active voice. Write "The controller supports a maximum of..." not "A maximum of ... is supported by the controller."
- Use the simple present tense. Write "The product requires 4 GB of RAM" not "The product will require 4 GB of RAM."
- Use sentence case for all headings. Capitalize only the first word and proper nouns.
- Always use the Oxford (serial) comma in lists.
- Do not use Latin abbreviations. Write "for example" not "e.g.", "in other words" not "i.e.", and "and so on" not "etc."
- Do not use "please", "simply", or other politeness phrases.
- Use "select" not "click". Use "earlier than" and "later than" not "before" or "after" when describing version ranges.
- Spell out product names in full on first mention in the document. For enterprise F5 NGINX products, include "F5" on first mention only.