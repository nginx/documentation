# Guide: How to write a reference article

This guide explains how to complete `template-reference.md`. It covers what a reference article is, when to write one, how to approach it before you start, and how to complete every field and section correctly.

For a sample, see `example-reference.md`.

---

## What is a reference article?

A reference article provides a structured, information-oriented description of a specific component, interface, or set of values in your product — for example, a list of configuration parameters, a table of CLI flags, or an API response schema.

The purpose of a reference article is to present facts concisely and consistently. It does not instruct the reader how to accomplish a task. Users who need procedural guidance should read a how-to guide or installation guide instead.

Reference articles are often confused with how-to guides and conceptual topics. The table below shows the key differences.

| | Reference article | How-to guide | Conceptual topic |
|---|---|---|---|
| **Orientation** | Information-oriented: describes what something is, what values it accepts, and what it does. | Task-oriented: guides the user through a series of steps to achieve a result. | Understanding-oriented: explains why something works the way it does. |
| **Structure** | Consistent, scannable entries — typically tables or structured lists. | Numbered steps with outcome sentences. | Prose with diagrams or examples. |
| **Assumed knowledge** | Assumes the reader knows what they are looking for and needs the exact details. | Assumes basic product knowledge; explains what to do and in what order. | Assumes the reader wants to build mental models, not complete a task. |
| **Content** | Facts only: names, types, defaults, constraints, allowed values. | Actions and their expected outcomes. | Concepts, relationships, and background context. |

---

## Why write a reference article?

A well-written reference article:

- Gives users a single, authoritative source of truth for parameter names, types, defaults, and constraints.
- Reduces support costs by answering "what does this field accept?" questions without requiring a support ticket.
- Provides AI assistants with structured, citable facts that can be surfaced in response to specific lookup queries such as "what is the default value of X?" or "what type does the Y parameter accept?"
- Serves as a stable anchor for how-to guides and tutorials that reference the same parameters without repeating their definitions.

---

## Before you start writing

Before writing, identify:

- **The subject.** A reference article covers one well-defined component — a configuration file, a set of API parameters, a CLI command, or a set of environment variables. Do not mix multiple unrelated components in a single article.
- **The entry format.** Decide whether the entries are best presented as a table, a definition list, or structured subsections. Tables work well for parameters with consistent attributes (name, type, required, default, description). Definition lists work well for a smaller set of entries with longer descriptions.
- **The attributes each entry needs.** For parameters, this is typically: name, type, whether it is required, the default value, and a description. Identify all attributes before writing so every entry is consistent.
- **The source of truth.** Reference documentation is most reliable when generated from or validated against source code. If auto-generation tooling exists for the component you are documenting, use it. If not, have a developer or subject matter expert review every entry before publication.
- **What is out of scope.** A reference article does not explain when or why to use a parameter — it describes what the parameter is. Keep conceptual explanations in a linked concept topic and task-based instructions in a linked how-to guide.

---

## Best practices

- **One component per article.** Cover one configuration file, one API endpoint, one CLI command, or one logical group of related parameters per page. If an article grows too large to scan easily, split it by logical subset.
- **Be consistent across every entry.** Every entry in a table or list must use the same attributes in the same order. Inconsistency forces readers to re-orient on every row and breaks AI extraction.
- **Use exact names.** Parameter names, type names, and default values must match the product exactly, including capitalization and punctuation. A mismatch between the reference article and the product is the most damaging error a reference article can contain.
- **State defaults explicitly.** If a parameter has a default value, always state it. If a parameter has no default and is required, state that it is required. Never leave the default or required status implied.
- **Keep descriptions factual and brief.** Each description should answer "what does this entry do or accept?" in one to two sentences. Do not include usage instructions or examples unless they are essential to understanding the entry.
- **Auto-generate where possible.** Reference documentation that is generated from source code or API schemas is easier to keep accurate. If auto-generation tooling exists, use it and treat the template as the structure within which generated content lives.
- **Review with a subject matter expert.** Reference articles are high-stakes: an incorrect type, default, or constraint can cause misconfiguration. Always have a developer or SME review every entry before publication.
- **Re-validate after every release.** Parameter names, types, defaults, and constraints change between product versions. Re-validate the entire article whenever a release affects the component you are documenting.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules in every section of the article.

**1. Use exact names consistently.** Parameter names, field names, and type names must match the product exactly and be used identically throughout the article. Inconsistency breaks AI entity resolution and causes lookup failures.

**2. One idea per sentence.** Long compound descriptions confuse AI extractors.

- Bad: "Sets the timeout value in seconds, which applies to both read and write operations and defaults to 30 if not specified."
- Good: "Sets the timeout in seconds for read and write operations. Default: `30`."

**3. State defaults and constraints as their own sentence or field.** Do not bury defaults or constraints inside a longer description sentence. AI systems extract these values most reliably when they are stated explicitly.

- Bad: "The log level, which can be debug, info, warn, or error, and defaults to info."
- Good: "The log verbosity level. Accepted values: `debug`, `info`, `warn`, `error`. Default: `info`."

**4. Avoid implicit pronouns.** Replace "it", "this", and "they" with the actual parameter or component name.

- Bad: "It must be set before the agent starts."
- Good: "The `api_key` parameter must be set before NGINX Agent starts."

**5. Mark optional and required entries explicitly.** Do not rely on the absence of a "Required" label to imply optional. State required or optional for every entry.

**6. Use parallel structure in every table and list.** Every description in a table column should follow the same grammatical pattern. All descriptions start with a verb phrase, or all are noun phrases. Mixing patterns forces AI and human readers to re-parse each entry individually.

**7. Use ALL_CAPS_PLACEHOLDERS for values the reader must supply.** In example values and code samples, use `YOUR_VALUE_HERE` rather than `<value>` or `$VALUE`. This is consistent with how-to guides and installation guides in this documentation set.

---

## Section requirements

| Section | Required? |
|---|---|
| Frontmatter | Required |
| Overview | Required |
| At least one entry section | Required |
| References | Required |
| Additional entry sections | Optional — add when entries fall into clearly distinct subsets |

---

## Frontmatter fields

### Required fields

**nd-content-type**: Always `reference` for reference articles.

**nd-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**nd-product**: The product code. Check an existing document for the same product if you are unsure which code to use.

**title**: Use a noun phrase identifying the component or set of entries. Do not use a verb phrase or start with "How to". Keep it under 60 characters.

- Good: "NGINX Agent configuration parameters"
- Good: "Instance Manager API — list instances"
- Bad: "How to configure NGINX Agent" or "Configuring NGINX Agent"

**description**: One sentence under 160 characters summarizing what this article covers. This text appears in search engine results, AI assistant citations, and doc portal previews.

**weight**: Controls the sort order within the section. Lower numbers appear first.

**toc**: Set to `true` to render an in-page table of contents. Reference articles with multiple entry sections almost always benefit from a table of contents.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling. Filling them in improves discoverability and the quality of AI-generated answers that cite this page.

**nd-keywords**: Comma-separated terms a reader might type to find this article. Include the component name, all parameter names covered in the article, and common alternative phrasings such as "config", "settings", "options", or "parameters".

**nd-summary**: Two to three sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Write in plain prose and avoid jargon. Cover:

- Sentence 1: what component or set of entries this article covers
- Sentence 2: what the reader can use this article to look up
- Sentence 3 (optional): scope limits, such as the product version this applies to

**nd-audience**: Who this article is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`. Reference articles are typically `developer` or `operator` depending on who configures or calls the component.

---

## Overview section

Write two to four sentences. Cover what component or set of entries this article describes, what the reader can use this article to look up, and any important scope or version constraints.

The Overview is the paragraph most likely to be surfaced verbatim by AI assistants — make every sentence independently meaningful. Do not start with "This article describes" — lead with the subject: "Use this reference to look up X" or "This page lists all Y parameters for Z."

Examples of good overview sentences:

- "Use this reference to look up all configuration parameters for NGINX Agent. Each parameter entry includes the parameter name, type, default value, and a description of its effect."
- "This page lists the request parameters and response fields for the NGINX One API list-instances endpoint. Use it when constructing API requests or parsing API responses."

---

## Entry sections

Name each entry section after the subset of entries it contains. Use a noun phrase — "Request parameters", "Response fields", "Environment variables" — not a verb phrase.

Add a separate H2 entry section when entries fall into clearly distinct subsets with different attributes. For example, an API endpoint reference might have separate sections for General requirements, Request parameters, and Response fields, because each subset has different column structures.

Within a section, choose the format that best fits the entries:

**Table**: Use for parameters with four or more consistent attributes (name, type, required, default, description). Tables are the most scannable format and the most reliably extracted by AI systems. See the template for a starter table structure.

**Definition list**: Use for a small number of entries (fewer than six) where the description is long enough that a table cell would be difficult to read.

**Structured subsections**: Use when each entry is complex enough to need its own H3, with multiple attributes described in prose or nested lists beneath it. This format is common for webhook event types or complex API response objects.

### Table column guidance

For parameter tables, use these columns in this order:

| Column | Required? | Notes |
|---|---|---|
| Name | Required | Use the exact parameter name as it appears in the product. Format as inline code. |
| Type | Required | Use consistent type names throughout: `string`, `integer`, `boolean`, `array`, `object`. |
| Required | Required | Always state `Yes` or `No`. Never leave this implied. |
| Default | Recommended | State the default value, or `None` if there is no default. Do not omit this column. |
| Description | Required | One to two sentences. State what the parameter does and what values it accepts. List constraints as a separate sentence. |

Additional columns such as Example or Deprecated are optional. If you add them, add them consistently to every row.

---

## References section

Link to related docs that provide deeper context or logical next steps. For reference articles, standard references include:

- The how-to guide that shows how to configure the component this article describes
- The installation guide for the component
- The conceptual topic that explains the component's purpose and architecture
- Release notes or changelog entries that affect the parameters in this article

Use the `ref` shortcode for internal links so they survive URL changes. AI systems use this section to build knowledge graphs between documents.

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