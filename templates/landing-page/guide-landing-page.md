# Guide: How to write a landing page

This guide explains how to complete `template-landing-page.md`. It covers what a landing page is, when to write one, how to approach it before you start, and how to complete every field and section correctly.

For a sample, see `example-landing-page.md`.

---

## What is a landing page

A landing page sits at the root of a product's documentation. It introduces the product in a few sentences and then routes the reader to the most important content using cards, organized into one or more sections.

A landing page does not teach or instruct. It contains little to no procedural content of its own — it is a hub, not a destination. Readers who need to learn a concept or complete a task should be routed, via a card, to a concept document or how-to guide.

Landing pages are often confused with concept documents or overview pages. The table below shows the key differences.

| | Landing page | Concept | How-to |
|---|---|---|---|
| **Orientation** | Navigation-oriented: helps readers find the right content fast. | Understanding-oriented: explains what something is and why it matters. | Task-oriented: guides a reader through completing a specific goal. |
| **Content** | A short product introduction plus card sections that link elsewhere. | Definitions, explanations, analogies, diagrams, use cases. | Numbered steps, prerequisites, and expected outcomes. |
| **Reader need** | "I'm new here — where do I go?" | "I don't understand what this is." | "I know what I want to do — show me how." |
| **Length** | Short. A few sentences plus links. | Medium to long. | As long as the task requires. |

---

## Why write a landing page

A well-written landing page:

- Gives a new reader a fast, accurate first impression of what the product does.
- Routes readers to the handful of pages that matter most, instead of a full table of contents.
- Surfaces the current highest-priority content — a new feature, the most common install path, or the latest release — above older, less relevant material.
- Gives AI assistants and search engines a single, authoritative summary of the product to cite when answering "what is X" queries.

---

## Before you start writing

Before writing, identify:

- The one or two sentences that best describe the product's value. This becomes both the `f5-subtitle` and the opening of the About section.
- The single most important next step for a brand-new reader. This becomes the one card in Featured content, and is almost always a "get started" or install page.
- The three or four tasks or topics a typical reader looks for next. These become the cards in the section below Featured content.
- Whether this product is part of a larger family or bundle (for example, a platform console that manages several related products). If so, plan a components section at the bottom of the page.
- Whether the product has secondary content worth surfacing on its own — workshops, an API, RBAC, a glossary, or release notes. These become a "More information" section.

---

## Best practices

- **Keep prose minimal.** The About section should take a reader seconds to read. If you find yourself writing more than one short paragraph, move the extra detail to a concept document and link to it from a card.
- **One card, one destination.** Never point two cards at the same URL. If you are tempted to, merge them into one card.
- **Limit Featured content to three cards.** Any card past the third will not render. One card renders full width; two render at half width each; three stack in an inverse pyramid. Use one full-width card for the single most important action.
- **Write card descriptions like teasers, not summaries.** Aim for 10 words or fewer per card. The title carries the "what"; the description carries the "why click this."
- **Order sections by reader priority, not internal structure.** Put the content most readers need first — typically "get started" — and push reference-style content (API, glossary, changelog) into "More information" at the bottom.
- **Do not duplicate navigation.** A landing page is not a sitemap. Only include cards for the pages that matter most; do not attempt to list every page in the section.
- **Use `brandIcon`, not `icon`, for related products.** In a components section, use each product's real logo (`brandIcon`) so readers can visually recognize sibling products. Reserve the generic `icon` parameter (Lucide icons) for task-oriented cards within this product.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules to every section of the landing page.

**1. Lead with what the product does, not what it is called.** The title already states the name. The first sentence of About should state the value.

- Bad: "F5 Kitchen Brew Console is a console for brewers."
- Good: "F5 Kitchen Brew Console makes it easy to manage connected brewers across locations and environments."

**2. Name specific capabilities.** Avoid vague value statements that could describe any product.

- Bad: "Brew Console helps you work more efficiently."
- Good: "Brew Console lets you track extraction targets, manage maintenance schedules, and monitor firmware versions."

**3. Use exact product names consistently.** Never shorten a product name inconsistently across cards — pick one short form (if any) and use it everywhere on the page.

**4. Make every card description self-contained.** A card description is often surfaced on its own in search results or AI answers, separate from its title. Write it so it makes sense without the card title next to it.

**5. Write descriptive link text inside card titles.** Card titles are used as the link text. "Connect more brewers" tells the reader and AI systems what the destination page covers; "Learn more" does not.

---

## Section requirements

| Section | Required? |
|---|---|
| About | Required |
| Featured content | Required — at least one card |
| Named topic sections (for example, "Workshops") | Optional — add when a distinct content group deserves its own callout |
| More information | Recommended — group secondary and reference-style links here |
| {Product family} components | Conditional — include only when the product is part of a bundle or family |

---

## Frontmatter fields

### Required fields

**f5-content-type**: Always `landing-page`.

**f5-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**f5-product**: The product name, used for internal catalogue and search. Case-sensitive.

**title**: The product name as it should appear as the page heading. Do not add "Documentation" or "Overview" — the page itself makes that clear.

**url**: The base of the deployed path. This becomes `docs.nginx.com/<url>/<other-pages>`. Always start and end with a slash.

**f5-landing-page**: Always `true`. This tells the theme to render this page using the landing page layout instead of a standard content page.

**cascade.logo**: The filename of the product's logo icon, resolved from the theme's `/static/images/icons/` folder. This cascades down to every child page in the section, so set it once here.

### Recommended fields

**description**: One sentence under 160 characters summarizing what the product does. Appears in search engine results, AI assistant citations, and doc portal previews.

**f5-subtitle**: A short phrase displayed directly beneath the page title on the rendered page. This is the first thing a reader sees — make it a value statement, not a tagline.

**weight**: Controls sort order relative to sibling sections. Lower numbers appear first. Omit if the product does not need to be pinned to a specific position.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling.

**f5-keywords**: Comma-separated terms a reader might type to find this product. Include the product name, its main features, and common alternative phrasings.

**f5-summary**: One to two sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Cover:

- Sentence 1: what the product is and the core value it provides
- Sentence 2: what it's part of, or the problem it solves — mention the parent product family if applicable

**f5-audience**: Who this product is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`.

---

## Card and card-section shortcodes

Landing pages are built from two shortcodes: `card-section`, which groups cards into a row, and `card`, which renders an individual link. Every `card` must be nested directly inside a `card-section`.

### card-section parameters

| Parameter | Values | Purpose |
|---|---|---|
| `showAsCards` | `"true"` | Include on every card-section for consistency with existing landing pages. |
| `isFeaturedSection` | `"true"` / `"false"` | Set `"true"` only on the Featured content section. Applies distinct styling to call out the section as the primary entry point. |
| `title` | free text | Use only on a components section, to label a category (for example, `"Kubernetes solutions"`). Omit on regular card sections — use a Markdown heading above the shortcode instead. |

### card parameters

| Parameter | Values | Purpose |
|---|---|---|
| `title` | free text, required | The card's heading and link text. |
| `titleUrl` | relative or absolute path | Where the card links. Use a path relative to the current section for pages within this product, or a leading-slash absolute path for pages in another section. |
| `icon` | a [Lucide icon name](https://lucide.dev/icons/) | A generic icon for a task-oriented card. Default is `book-open`. Omit for a plain text-only card. |
| `brandIcon` | a logo filename from `/static/images/icons/` | A product logo, used instead of `icon`. Reserve for components sections that link to sibling products. |
| `isFullSize` | `"true"` / `"false"` | Set `"true"` to make a card span the full section width. Use for a single card in the Featured content section. |

### Sizing rules

A card-section arranges its cards based on how many it contains:

- **One card**: renders full width.
- **Two cards**: render at half width each, side by side.
- **Three cards**: stack in an inverse pyramid (one wide, two narrower below, or similar responsive layout).
- **More than three cards**: only the first three render. Split extra cards into a second card-section under its own heading.

---

## About section

Write two to four sentences. Cover:

- What the product does, in plain language
- The specific capabilities that make it useful — avoid vague claims like "enables efficiency"
- If the product is part of a family, one sentence naming that family and linking to the components section (`#{product-family-slug}-components`)

This section is the one most likely to be quoted verbatim by an AI assistant answering "what is {product}" — make every sentence stand on its own.

---

## Featured content section

Include one to three cards that represent the single most important next step for a reader who just landed on this page. This is almost always a "get started" or installation card.

- If you have exactly one card, set `isFullSize="true"` so it spans the page.
- If you have two or three cards, omit `isFullSize` and let them share the row.
- Always set `isFeaturedSection="true"` on this card-section.

Good candidates for this section: the primary get-started or install guide, the most-read task, or a significant new feature.

---

## Additional card sections

Add further card-sections, each under its own heading, for the remaining tasks and topics a reader commonly looks for. Group cards that share a theme under the same heading (for example, "Set up and configure," "Monitor and secure").

Use "More information" as the final card-section on the page for secondary or reference-style links: RBAC, API docs, glossary, changelog, and release notes. Readers who need these know to look for them, so they do not need top billing.

Name each heading after the reader's goal, not the internal feature name — "Secure your fleet," not "Security module."

---

## Components section (conditional)

Include this section only if the product is one part of a larger family — for example, a platform console that manages several related products, or a product with multiple deployment options documented separately.

Group related products under one or more `card-section` blocks that use the `title` parameter instead of a Markdown heading, and use `brandIcon` on every card so readers recognize each product by its logo. Do not set `showAsCards` or `isFeaturedSection` on these sections — they use a different, logo-forward layout.

If the product stands alone, remove this section entirely.

---

## Style reminders

Please follow these guidelines when writing and formatting landing page content. They are designed to improve readability for human readers and discoverability by AI assistants and search engines. Check the documentation for your specific product repository to see if there are any additional style rules or templates you should follow.

### Language and grammar

- Follow American English spelling. Use the American Heritage Dictionary as the spelling reference.
- Use the active voice. Write "The console lets you monitor..." not "Monitoring is enabled by the console."
- Use the simple present tense. Write "The product requires..." not "The product will require..."
- Always use the Oxford (serial) comma in lists of three or more items.
- Do not use Latin abbreviations. Write "for example" not "e.g.", "in other words" not "i.e.", and "and so on" not "etc."
- Do not use "please", "simply", or other politeness phrases that add no information.

### Terminology and naming

- Spell out product names in full on first mention.
- Use exact names consistently throughout the page. Never shorten a product name inconsistently between cards.
- Use "select" not "click".

### Headings and structure

- Use sentence case for all headings. Capitalize only the first word and proper nouns.
- Name card-section headings after the reader's goal, not the internal feature or module name.

### AI-ready writing

- One idea per sentence. Long compound sentences confuse AI extractors.
- Avoid implicit pronouns. Replace "it", "this", and "they" with the actual noun.
- Write every card description so it makes sense on its own, without its card title alongside it.
- Keep card descriptions to roughly 10 words or fewer — write a teaser, not a summary.
