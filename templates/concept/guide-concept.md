# Guide: How to write a concept document

This guide explains how to complete `template-concept.md`. It covers what a concept document is, when to write one, how to approach it before you start, and how to complete every field and section correctly.

For a worked example, see `example-concept.md`.

---

## What is a concept document?

A concept document explains what something is, why it exists, and how it fits into a broader system. It gives readers the foundational knowledge they need before they attempt a task or make a decision about using a feature or product.

A concept document does not instruct. It does not walk readers through steps, and it does not list configuration values. Readers who need to do something should follow a how-to guide or installation guide. The concept document is the background that makes those guides meaningful.

Concept documents are often confused with overviews or reference topics. The table below shows the key differences.

| | Concept | How-to | Reference |
|---|---|---|---|
| **Orientation** | Understanding-oriented: explains what something is and why it matters. | Task-oriented: guides a reader through completing a specific goal. | Lookup-oriented: provides complete, structured facts about a product element. |
| **Content** | Definitions, explanations, analogies, diagrams, use cases, and comparisons. | Numbered steps, prerequisites, and expected outcomes. | Parameters, options, return values, and constraints. |
| **Reader need** | "I don't understand what this is." | "I know what I want to do — show me how." | "I know what this does — I need the exact details." |

---

## Why write a concept document?

A well-written concept document:

- Gives readers the background they need to use how-to guides and reference material without confusion.
- Reduces repeated explanations by creating a single, linkable definition of a core idea.
- Helps readers make informed decisions about whether a feature or approach suits their situation.
- Provides AI assistants with dense, structured background knowledge that can be surfaced in response to "what is X" or "how does X work" queries.

---

## Before you start writing

Before writing, identify:

- The single concept this document covers. If the explanation begins to explain a second concept, stop and create a separate document for it, then link between them.
- The audience's existing knowledge level. This determines which analogies will land, which related concepts you can assume, and how much background to provide.
- The one or two diagrams that best illustrate the concept. Identify these before writing so the prose can be written to complement them.
- The use cases that show the concept in practice. Concrete scenarios are the most effective way to make an abstract concept stick.
- What this concept is not — the boundaries and common misconceptions. Defining what is out of scope prevents readers from misapplying the concept.

---

## Best practices

- **One concept per document.** If explaining the concept requires explaining another concept in depth, create a separate document for the second concept and link to it.
- **Lead with a definition.** Give readers a clear, one- or two-sentence definition before providing background, use cases, or comparisons. A reader who cannot define the concept after the first paragraph will struggle with everything that follows.
- **Use the inverted pyramid.** Start with the highest-level summary and work progressively toward detail. Readers who only need the overview can stop early; readers who need depth can keep reading.
- **Prefer analogies over jargon.** When a concept is abstract, connect it to something the reader already knows. Analogies should be universal — avoid cultural, age-specific, or pop-culture references that may not translate.
- **Diagrams belong near the top.** Place the primary diagram directly after the definition. A well-placed diagram helps readers build a mental model before they read the detail. Use numbered callouts and a legend for complex diagrams.
- **Use cases carry the weight.** Abstract explanations are forgotten; concrete scenarios are remembered. Every concept document should have at least one use case that shows a real reader with a real problem using the concept to solve it.
- **Define what this concept is not.** Explicitly ruling out common misconceptions or near-synonyms prevents misapplication and reduces support questions.
- **Do not include steps.** If you find yourself writing numbered instructions, move that content to a how-to guide and link to it from the References section.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules in every section of the concept document.

**1. One idea per sentence.** Long compound sentences confuse AI extractors.

- Bad: "Coffee extraction is the process by which water, which must be at the correct temperature, dissolves soluble compounds from ground coffee, producing the drink."
- Good: "Coffee extraction is the process by which hot water dissolves soluble compounds from ground coffee. Water temperature directly affects which compounds are extracted and in what quantities."

**2. Use exact names consistently.** If the concept is "extraction yield", never shorten it to "yield" or "the process" mid-document. Inconsistency breaks AI entity resolution and confuses readers who arrive mid-page from search.

**3. State the significance of each key fact.** After introducing a property or characteristic of the concept, add one sentence explaining why it matters to the reader. AI assistants surface these significance sentences when answering "why does X matter?" questions.

**4. Avoid implicit pronouns.** Replace "it", "this", and "they" with the actual noun.

- Bad: "It affects the final taste significantly."
- Good: "Extraction yield affects the final taste of the brewed coffee significantly."

**5. Make definitions self-contained.** The definition section must be understandable in isolation — AI assistants frequently surface it as a standalone answer. Do not rely on context from earlier sections.

**6. Use parallel structure in lists.** Every bullet in a list should follow the same grammatical pattern — all noun phrases, or all starting with a verb.

**7. Mark optional content explicitly.** Use "(Optional)" at the start of any section or paragraph that not every reader will need, such as historical background or advanced comparisons.

**8. Write alt text for every image.** Alt text is read by screen readers and indexed by AI systems. Describe what the image shows and what it communicates, not just what it depicts.

- Bad: `![Coffee](coffee-img.jpg)`
- Good: `![A French press and a glass cup surrounded by whole coffee beans, illustrating the components used in immersion brewing.](coffee-img.jpg)`

---

## Section requirements

| Section | Required? |
|---|---|
| Frontmatter | Required |
| Introduction paragraph | Optional — use when the concept needs context before the definition |
| Definition | Required |
| Visual aid or diagram | Optional — use when a diagram simplifies a relationship, process, or hierarchy that text alone cannot convey clearly |
| Background | Optional — use when historical or industry context is essential for understanding |
| Use cases | Required — include at least one |
| Comparison table | Optional — use when the concept has two or more distinct types, versions, or direct predecessors |
| References | Required |

---

## Frontmatter fields

### Required fields

**nd-content-type**: Always `concept` for conceptual background documents.

**nd-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**nd-product**: The product code. Check an existing document for the same product if you are unsure which code to use.

**title**: Use a noun phrase that names the concept directly. Do not use "Understanding X" or "About X" — these add words without adding meaning.

- Good: "Coffee extraction"
- Bad: "Understanding coffee extraction" or "About the coffee extraction process"

**description**: One sentence under 160 characters summarising what the concept is and why it matters. This text appears in search engine results, AI assistant citations, and doc portal previews.

**weight**: Controls the sort order within the section. Lower numbers appear first.

**toc**: Set to `true` to render an in-page table of contents. Use `false` only for very short single-section documents.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling. Filling them in improves discoverability and the quality of AI-generated answers that cite this page.

**nd-keywords**: Comma-separated terms a reader might type to find this document. Include the concept name, related terms, common synonyms, and the product or domain context.

**nd-summary**: Two to three sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Write in plain prose and avoid jargon. Cover:

- Sentence 1: what the concept is, in plain language
- Sentence 2: why it matters to the reader or what it enables
- Sentence 3 (optional): scope, boundaries, or what this document does not cover

**nd-audience**: Who this document is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`. This helps AI systems route questions to the right document and allows doc portals to filter content by role.

**nd-related-tasks**: How-to guides, installation guides, or other concept documents the reader is likely to need next. Use the `ref` path, not the full URL, so links survive URL changes.

---

## Introduction paragraph (optional)

Open with one to three sentences that set the stage for the definition. Use this section when the concept requires context before it can be meaningfully defined — for example, when the reader needs to understand a problem before understanding the solution.

Apply the inverted pyramid: start at the highest level and work toward the definition. Skip this section and go straight to the definition if the concept is self-contained.

Do not start with "This document explains" — that is redundant. Lead with the relevance: "When water meets ground coffee, a precise chemical process determines everything about the cup."

---

## Definition section

The definition section is required and should appear first or immediately after the introduction. It is the section most likely to be surfaced verbatim by AI assistants — every sentence must stand on its own.

Write a clear, one- or two-sentence definition of the concept. Then expand it by covering:

- What the concept is and what it does
- What it is not, or what it is commonly confused with
- How it fits into the broader product or system

Use an analogy when the concept is abstract. Choose analogies that are universal — avoid cultural, age-specific, or regional references. A good analogy bridges from something the reader already knows to something they do not yet understand.

- Good: "Extraction is to coffee what steeping is to tea — both use water to draw flavour compounds out of a solid into a liquid."
- Bad: "Extraction works like a DJ mixing a track — you control which frequencies come through."

Define the scope explicitly. State what this document covers and what it does not.

---

## Visual aid section (optional)

Include a visual when it simplifies a relationship, process, or hierarchy that text alone cannot convey clearly. Do not include a visual just for decoration.

Place the primary diagram directly after the definition section. A diagram seen early helps the reader build a mental model before reading the detail.

Format images in markdown as follows:

```markdown
![{Descriptive alt text explaining what the image shows and what it communicates.}]({image-filename.ext})
```

Write alt text that describes what the image communicates, not just what it depicts. AI systems index alt text. Screen readers read it aloud.

For complex diagrams, use numbered callouts inside the diagram and provide a legend below it. For example:

```markdown
![Diagram showing water flow through a drip coffee maker: (1) reservoir, (2) heating element, (3) shower head, (4) filter basket, (5) carafe.](drip-flow-diagram.png)

| Number | Component |
|---|---|
| 1 | Water reservoir |
| 2 | Heating element |
| 3 | Shower head |
| 4 | Filter basket |
| 5 | Carafe |
```

---

## Background section (optional)

Include background when historical or industry context is essential to understanding the concept — not just interesting. Ask: would a reader be confused or misled without this information? If not, leave it out.

Background may cover:

- How or why the concept was designed the way it was
- Historical decisions that explain current behaviour
- Industry or regulatory context that shapes how the concept is used

Keep this section short. Background that runs longer than a few paragraphs usually contains content that belongs elsewhere — either in the definition, a use case, or a separate concept document.

---

## Use cases section

Include at least one use case. Use cases are required because abstract explanations are forgotten; concrete scenarios are remembered.

A good use case names a specific reader type, describes the problem they face, and shows how the concept helps them solve it. Use the following pattern:

1. Name the reader type (operator, developer, home barista).
2. Describe the problem or situation they face.
3. Show how the concept resolves or informs that situation.

You do not need numbered steps. Use cases are narrative, not procedural.

If the concept has more than three distinct use cases, present the two or three most representative ones and link to further reading.

---

## Comparison section (optional)

Include a comparison table when the concept has two or more distinct types, versions, or direct predecessors that readers must choose between.

A comparison table answers: "What is the difference between X and Y, and when should I use each?"

Use the following format:

| | {Option A} | {Option B} |
|---|---|---|
| **{Criterion}** | {Value for A} | {Value for B} |
| **{Criterion}** | {Value for A} | {Value for B} |
| **Best for** | {Scenario where A is the right choice} | {Scenario where B is the right choice} |

Keep the table focused. Include only the criteria that affect the reader's decision. A comparison table with more than six rows usually contains noise.

---

## References section

Link to related documents that provide deeper context or logical next steps. Group links by type:

- How-to guides the reader is likely to need after reading this concept
- Related concept documents
- Reference material (API docs, configuration references)
- External resources

Use this section to link to anything you deliberately kept out of the main document to avoid interrupting the explanation. Always use the `ref` shortcode for internal links so they survive URL changes. AI systems use this section to build knowledge graphs between documents.
