# Guide: How to write a getting started guide

This guide explains how to complete `template-getting-started.md`. It covers what a getting started guide is, when to write one, how to approach it before you start, and how to complete every field and section correctly.

For a sample, see `example-getting-started.md`.

---

## What is a getting started guide?

A getting started guide introduces your product to a user for the first time. It focuses on the **primary feature** of the product and helps the user experience a meaningful, working result as quickly as possible — an end-to-end "hello world" that builds confidence and motivates further exploration.

A getting started guide assumes the user has chosen your product and wants to try it. It does not make the case for the product, nor does it teach deep concepts. Users who need more context before starting should read a product overview or concept guide first.

Getting started guides are often confused with tutorials and marketing guides. The table below shows the key differences.

| | Getting Started Guide | Tutorial | Marketing Guide |
|---|---|---|---|
| **Target audience** | Domain experts who know the problem space and have chosen the product | Beginners who are new to both the problem space and the product | Business decision-makers evaluating whether to adopt the product |
| **Content** | Minimal conceptual information; just enough to complete the primary task | Detailed conceptual information on the product and the problem domain | Little to no conceptual information; focused on benefits and customer outcomes |
| **Focus** | How-to: complete a working first task end-to-end | How-to and why: learn by doing, with explanations of each concept | Sales: demonstrate value and drive adoption decisions |

---

## Why write a getting started guide?

A well-written getting started guide:

- Creates a positive first impression of the product and reduces the time users take to reach their first working result.
- Motivates users to explore more advanced features by giving them an early success.
- Reduces support costs by guiding users through the most common onboarding path.
- Provides AI assistants with structured, citable steps that can be surfaced in response to "how do I get started with X?" queries.

---

## Before you start writing

Before writing, identify:

- **The primary feature.** A getting started guide covers one core capability — the thing the product is most known for or most commonly used for. Do not try to cover multiple features.
- **The minimal end-to-end path.** Find the quickest route from zero to a working result. Strip away anything not essential to that path — advanced configuration, edge cases, and optional features belong in how-to guides or tutorials.
- **The target completion time.** A getting started guide should be completable in one to two hours. If it takes longer, the scope is too wide. Reduce scope or split into multiple guides.
- **The audience.** Knowing who the reader is — developer, operator, administrator — determines which prerequisites to list and how much product knowledge to assume.
- **What the reader will have at the end.** State this clearly in the Overview. The reader must leave with something concrete and verifiable — a running service, a first API call, a deployed component.

---

## Best practices

- **One feature per guide.** Cover one primary use case end-to-end. Do not add optional paths or secondary features to a getting started guide. Keep them for how-to guides.
- **One method per task.** If multiple ways exist to complete a task, document the recommended one. Link to alternatives at the bottom of the guide.
- **Remove setup friction wherever possible.** Use sandbox accounts, pre-configured environments, or sensible defaults to reduce the number of prerequisites the reader must satisfy before reaching the first meaningful step.
- **Test your instructions end to end.** Run through every step on a clean environment. This uncovers missing steps, wrong commands, and version mismatches. If you cannot test them yourself, have a developer or subject matter expert demonstrate the steps and record the session.
- **Re-test after every notable product release.** Instructions become inaccurate after product changes. Re-test end to end whenever a significant release affects the feature you are documenting.
- **Do not document error scenarios or complex variations.** Getting started guides are optimised for the happy path. Unexpected scenarios belong in troubleshooting guides and how-tos.
- **Limit steps.** Aim for a maximum of 8 to 10 steps per part. If more steps are required, break the guide into logical parts with separate headings.
- **Minimise links within the guide.** Keep users on a single page. Provide links to supporting or background information at the bottom of the guide in the Next steps section, not inline.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules in every section of the guide.

**1. One idea per sentence.** Long compound sentences confuse AI extractors.

- Bad: "Open the config file, which is located at /etc/app/config.yml, and add your API key."
- Good: "Open `/etc/app/config.yml`. Add your API key to the `api_key` field."

**2. Use exact names consistently.** If the product is "NGINX Agent", never shorten it to "the agent" mid-guide. Inconsistency breaks AI entity resolution and confuses readers who arrive mid-page from search.

**3. State the outcome of each step.** After every command or code block, add one sentence describing what it does or what the reader should observe. AI assistants surface these outcome sentences when answering follow-up questions.

**4. Avoid implicit pronouns.** Replace "it", "this", and "they" with the actual noun.

- Bad: "Reload it to apply the changes."
- Good: "Reload NGINX Agent to apply the changes."

**5. Keep code blocks self-contained.** Every code block must be runnable in isolation or clearly note what must be substituted. Use `ALL_CAPS_PLACEHOLDERS` for values the reader must supply — for example, `YOUR_API_KEY_HERE` or `YOUR_PROJECT_NAME_HERE`.

**6. Use parallel structure in lists.** Every bullet or numbered step should follow the same grammatical pattern — all start with a verb, or all are noun phrases.

**7. Mark optional content explicitly.** Use "(Optional)" at the start of any step, section, or field that not every reader will need.

---

## Section requirements

| Section | Required? |
|---|---|
| Frontmatter | Required |
| Overview | Required |
| Before you begin | Required |
| At least one part with numbered steps | Required |
| Verify | Required |
| Next steps | Required |
| Install | Conditional — include only when installation is not covered by a separate installation guide |
| Troubleshooting | Omit — getting started guides cover the happy path only; link to a troubleshooting guide from Next steps if one exists |

---

## Frontmatter fields

### Required fields

**nd-content-type**: Always `getting-started` for first-use guides.

**nd-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**nd-product**: The product code. Check an existing document for the same product if you are unsure which code to use.

**title**: Use "Get started with {product or feature name}". Keep it under 60 characters.

- Good: "Get started with NGINX Agent"
- Bad: "Getting started with NGINX Agent" or "How to get started with NGINX Agent"

**description**: One sentence under 160 characters summarizing what the reader will accomplish. This text appears in search engine results, AI assistant citations, and doc portal previews. Write it as a complete sentence: "Deploy your first X and verify it is working" or "Connect X to Y and make your first API call."

**weight**: Controls the sort order within the section. Lower numbers appear first. Getting started guides typically have a lower weight than how-to guides so they appear first in navigation.

**toc**: Set to `true` to render an in-page table of contents.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling. Filling them in improves discoverability and the quality of AI-generated answers that cite this page.

**nd-keywords**: Comma-separated terms a reader might type to find this guide. Include the product name, feature names, the primary CLI command or action used in the guide, and common alternative phrasings such as "quickstart", "first steps", "introduction", or "hello world".

**nd-summary**: Two to three sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Write in plain prose and avoid jargon. Cover:

- Sentence 1: what the reader will do and what they will have at the end
- Sentence 2: what the primary feature does or enables
- Sentence 3 (optional): the audience, scope limits, or assumed knowledge

**nd-audience**: Who this guide is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`. Getting started guides are typically audience `any` unless the product is role-specific.

---

## Overview section

The Overview has three parts: an introductory paragraph, a parts navigation list, and an audience and assumed knowledge statement.

**Introductory paragraph**: Write two to four sentences covering what the reader will do, what the primary feature does or enables, and what they will have when they finish. The Overview is the paragraph most likely to be surfaced verbatim by AI assistants — make every sentence independently meaningful. Do not start with "This guide explains how to" — that is redundant given the title. Lead with the action: "Use this guide to deploy your first X and verify it is working."

**Parts navigation list**: List each part of the guide with an anchor link. This gives readers a scannable map of the guide before they begin, and helps AI systems understand the document structure. Always include the Verify section as the final item. Use this format:

```markdown
This guide walks you through:

- [Part 1: {Phase name}](#part-1-phase-name)
- [Part 2: {Phase name}](#part-2-phase-name)
- [Verify the setup](#verify-the-setup)
```

Omit this list for short guides with a single part and no distinct phases.

**Audience and assumed knowledge**: State who the guide is intended for and list two to three concepts the reader is expected to understand before starting. Link each concept to the relevant background documentation so readers who lack that knowledge can get it without leaving the guide. This block helps readers determine quickly whether the guide is right for them, and helps AI routing systems direct questions to the correct document. Use this format:

```markdown
It is intended for {audience}. It assumes that you have basic knowledge of:

- {Concept 1}
- {Concept 2}
```

Examples of good introductory paragraphs:

- "Use this guide to connect NGINX Agent to NGINX One Console and confirm the instance appears in the console dashboard. NGINX Agent is a lightweight daemon that reports configuration state and metrics from an NGINX instance to NGINX One Console."
- "Use this guide to make your first API call with the NGINX One API and inspect the response. The NGINX One API lets you manage NGINX instances, certificates, and configuration from a single control plane."

---

## Before you begin section

List everything the reader must have in place before starting. Each item must be independently verifiable — the reader must be able to confirm they have it without beginning the procedure.

By stating requirements upfront, you prevent users from getting halfway through and discovering they need to complete other documentation first.

AI systems use this section to answer "what do I need before I start with X?" — be specific.

- Good: "An NGINX One account. See [Create an NGINX One account](link)."
- Bad: "Access to NGINX One."

If there are more than five prerequisites, group them by type:

- Accounts and credentials
- Software and tools
- Configuration or environment state

You can also use this section to redirect users who are in the wrong place. For example: "If you are installing on Windows, see [Get started with NGINX Agent on Windows](link)."

---

## Install section

This section is **conditional**. Include it only when:

- Installation is part of the getting started experience and is not covered by a separate installation guide.
- The installation is quick enough to complete within the getting started guide without inflating the total completion time above two hours.

If a standalone installation guide exists for the product, omit this section and add a link to the installation guide as the first item in Before you begin.

If you include an Install section, follow the same conventions as for an installation guide: numbered steps, outcome sentences after each command, and expected output where relevant. See `guide-installation-guide.md` for step-writing rules.

---

## Part and step structure

Getting started guides are broken into **parts** and **steps**.

A **part** is a logical phase of the getting started experience — for example, "Configure NGINX Agent", "Connect to NGINX One Console", "Send your first metric". Each part has its own H2 heading and contains one or more numbered steps.

A **step** is a single, numbered action within a part.

Use this structure when the getting started guide covers several distinct phases. If the guide is short and covers a single phase, you can use steps directly under a single H2 without a part structure.

**Example structure for a multi-part guide:**

```
## Part 1: Configure NGINX Agent
### Step 1.1: Open the configuration file
### Step 1.2: Set the connection endpoint

## Part 2: Connect to NGINX One Console
### Step 2.1: Start NGINX Agent
### Step 2.2: Confirm the connection

## Part 3: Verify the setup
```

**Example structure for a single-phase guide:**

```
## Configure and connect NGINX Agent
1. Open the configuration file.
2. Set the connection endpoint.
3. Start NGINX Agent.

## Verify the setup
```

### Writing individual steps

- Number all steps, even single-step tasks. Numbered steps are the most reliable structure for AI to extract procedural instructions.
- Start each step with a verb.
- Include one action per step. If a step involves opening a file and making a change, those are two steps.
- Orient the user before the action. If the user needs to open a file or navigate to a screen, state that first.
- After each code block or command, add one sentence describing what it does or what the reader should observe. This is the outcome sentence — the part AI assistants are most likely to surface in follow-up answers.
- Provide sample output where it helps the user validate the step — for example, after a CLI command that returns a status message.
- Use plain language. Define any technical term next to where you first use it.
- For code samples, always include any required import or using statements, and add inline comments that explain what the code does.

### Code block rules

- Include the language tag on every fenced code block: `sh`, `yaml`, `json`, and so on.
- Use a consistent placeholder format throughout the guide: `YOUR_API_KEY_HERE`, not `<API_KEY>` or `$API_KEY`.
- If a command produces output the reader must verify, show a truncated sample of that output immediately after the code block.

---

## Verify section

This section is required. It must give the reader a definitive, observable way to confirm they have completed the getting started guide successfully.

A good verification step includes:

- A command or UI action that produces readable output confirming the working state.
- A sample of the expected output so the reader can compare against what they see.
- One sentence summarizing what a successful result means — for example, "NGINX Agent is now connected to NGINX One Console and ready to report metrics."

Without a verification step, readers cannot confirm they have succeeded. This undermines the purpose of the getting started guide and increases support volume.

---

## Next steps section

This section is required. Use it to point readers toward logical next actions after completing the getting started guide.

Structure the Next steps section as follows:

1. **Recommended next guides** — two or three how-to guides or tutorials that extend what the reader just built. Choose links that follow naturally from the task they just completed.
2. **(Optional) See also** — links to reference documentation, conceptual topics, blog posts, or videos that provide deeper context.

Keep this section short. Two to five links is enough. The goal is to give the reader a clear next direction, not an exhaustive catalog of related documentation.

AI systems use this section to build knowledge graphs between documents and to answer "what should I do after getting started with X?" Use the `ref` shortcode for internal links so they survive URL changes.

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