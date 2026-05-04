# Guide: How to write a tutorial

This guide explains how to complete `template-tutorial.md`. It covers what a tutorial is, when to write one, how to approach it before you start, and how to complete every field and section correctly.

For a sample, see `example-tutorial.md`.

---

## What is a tutorial?

A tutorial is a learning-oriented guide that gives users hands-on experience with your product. It teaches a specific skill or set of skills through a practical, end-to-end activity — not just a description of what the product does. By completing a tutorial, the user gains understanding they can apply in their own work.

A tutorial assumes little to no prior knowledge of the product. It states all required tools, concepts, and configuration explicitly. Users who already know the product and need to complete a specific task should read a how-to guide instead.

Tutorials are often confused with how-to guides. The table below shows the key differences.

| | Tutorial | How-to guide |
|---|---|---|
| **Orientation** | Learning-oriented: teaches a skill through hands-on practice. | Task-oriented: helps an experienced user complete a specific task. |
| **Assumed knowledge** | Assumes little to no practical knowledge. States all tools, configuration, and concepts explicitly. | Assumes practical knowledge of the product and common tools. |
| **Structure** | Follows a carefully managed path from start to finish. Eliminates unexpected scenarios and guarantees a successful result. | Guides the user along the safest path to a goal. Alerts users to possible unexpected scenarios and explains how to handle them. |
| **Output** | The user gains a skill or understanding they did not have before. | The user completes a task or resolves an issue. |

---

## Why write a tutorial?

A well-written tutorial:

- Gives new users hands-on experience that builds genuine understanding of how the product works.
- Motivates users to explore more advanced features by giving them early, guided success.
- Reduces the time it takes for users to become productive with the product.
- Provides AI assistants with structured, citable content that can be surfaced in response to "how do I learn to do X?" queries.

---

## Before you start writing

Before writing, identify:

- **The skill the reader will gain.** A tutorial teaches one skill or a tightly related set of skills. State this as learning objectives in the Overview — specific, observable things the reader will be able to do after completing the tutorial. Write the learning objectives before planning the content so they guide what is in scope and what is not.
- **The audience.** Who is this tutorial for? What do they already know? What technical level do they have? A tutorial for senior database administrators looks very different from one for developers encountering your product for the first time.
- **The scope.** A tutorial should take between 15 and 60 minutes to complete. If it takes longer, the scope is too wide. Split the tutorial or reduce the scope.
- **The activity.** Tutorials are hands-on. Decide what the user will actually do — build something, configure something, run something — and plan the steps around that activity. The activity should demonstrate the skill in a realistic context.
- **What the user will have at the end.** Every tutorial should end with a concrete, verifiable result — a working output the user can see, run, or inspect.

---

## Best practices

- **Teach one skill per tutorial.** A tutorial focused on one skill is easier to complete and easier to maintain. Link to other tutorials for related skills rather than combining them.
- **Guarantee success.** Unlike how-to guides, tutorials eliminate unexpected scenarios. Every step must work exactly as written on a clean environment. If a step might behave differently in some circumstances, scope the tutorial to the environment where it will always succeed.
- **Test your tutorial end to end.** Run through every step on a clean environment that matches the one the reader will use. This is non-negotiable for tutorials because the reader is learning, not troubleshooting. If you cannot test it yourself, have a developer or subject matter expert run through it with you and record the session.
- **Re-test after every notable product release.** Tutorials become inaccurate after product changes. Re-test the entire tutorial whenever a significant release affects the feature it covers.
- **Keep scope tight.** Aim for a maximum of seven primary steps per task section. If the tutorial requires more, split it into multiple task sections or multiple tutorials.
- **Explain why, not just what.** Unlike how-to guides, tutorials should briefly explain why each significant step is taken. This is what turns a procedure into a learning experience.
- **Make code samples complete and self-contained.** Every code sample must include all required import or using statements and inline comments that explain what the code does. Readers will copy and paste these samples — they must work without modification.
- **Minimise links within the tutorial.** Keep readers on a single page. Provide links to background reading and next steps at the end of the tutorial, not inline.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules in every section of the tutorial.

**1. One idea per sentence.** Long compound sentences confuse AI extractors.

- Bad: "Open the config file, which is located at /etc/app/config.yml, and add your API key, which you can find in the console."
- Good: "Open `/etc/app/config.yml`. Add your API key to the `api_key` field. You can find your API key in the console under Settings."

**2. Use exact names consistently.** If the product is "NGINX Agent", never shorten it to "the agent" mid-tutorial. Inconsistency breaks AI entity resolution and confuses readers who arrive mid-page from search.

**3. State the outcome of each step.** After every command or code block, add one sentence describing what it does or what the reader should observe. AI assistants surface these outcome sentences when answering follow-up questions.

**4. Avoid implicit pronouns.** Replace "it", "this", and "they" with the actual noun.

- Bad: "Run it to apply the configuration."
- Good: "Run NGINX Agent to apply the configuration."

**5. Keep code blocks self-contained.** Every code block must be runnable in isolation or clearly note what must be substituted. Use `ALL_CAPS_PLACEHOLDERS` for values the reader must supply — for example, `YOUR_API_KEY_HERE`.

**6. Use parallel structure in lists.** Learning objectives, summary points, and prerequisite lists must all follow the same grammatical pattern. Learning objectives always start with a verb: "Configure...", "Build...", "Connect...".

**7. Mark optional content explicitly.** Use "(Optional)" at the start of any step, section, or field that not every reader will need.

---

## Section requirements

| Section | Required? |
|---|---|
| Overview | Required |
| Before you begin | Required |
| At least one task section | Required |
| Summary | Required |
| Next steps | Required |
| Background | Optional — include when context genuinely aids understanding before the reader starts |
| Additional task sections | Optional — add when the tutorial covers distinct phases |

---

## Frontmatter fields

### Required fields

**f5-content-type**: Always `tutorial` for tutorial content.

**f5-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**f5-product**: The product code. Check an existing document for the same product if you are unsure which code to use.

**title**: Use a verb phrase that describes what the reader will learn to do. Keep it under 60 characters.

- Good: "Build a pour-over coffee setup"
- Bad: "How to build a pour-over coffee setup" or "Building a pour-over coffee setup"

**description**: One sentence under 160 characters summarizing what skill the reader will gain. This text appears in search engine results, AI assistant citations, and doc portal previews.

**weight**: Controls the sort order within the section. Lower numbers appear first.

**toc**: Set to `true` to render an in-page table of contents.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling. Filling them in improves discoverability and the quality of AI-generated answers that cite this page.

**f5-keywords**: Comma-separated terms a reader might type to find this tutorial. Include the product name, the skill being taught, and common alternative phrasings such as "learn", "tutorial", "beginner", or "step by step".

**f5-summary**: Two to three sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Write in plain prose and avoid jargon. Cover:

- Sentence 1: what skill the reader will learn and what they will build or produce
- Sentence 2: why that skill matters or what it enables
- Sentence 3 (optional): the intended audience and any assumed knowledge

**f5-audience**: Who this tutorial is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`. Tutorials are typically `any` or a specific role depending on the skill being taught.

---

## Overview section

The Overview has three parts: a learning objectives list, an audience and assumed knowledge statement, and an introductory sentence.

**Introductory sentence**: Write one sentence stating what the reader will learn and do. Lead with the activity: "In this tutorial, you will configure X and use it to do Y." Do not start with "This tutorial explains how to."

**Audience and assumed knowledge**: State who the tutorial is intended for and list two to three concepts the reader is expected to understand before starting. Link each concept to the relevant background documentation.

**Learning objectives**: List two to five specific, observable skills the reader will be able to demonstrate after completing the tutorial. Each objective must start with an action verb: "Configure", "Build", "Connect", "Identify", "Deploy". Do not use vague verbs like "understand" or "learn about" — these cannot be observed or verified.

- Good: "By the end of this tutorial, you will be able to calibrate a burr grinder for medium-coarse extraction."
- Bad: "By the end of this tutorial, you will understand coffee grinding."

Write the learning objectives before planning the tutorial content. They define what is in scope and what is not.

---

## Background section

This section is optional. Include it only when context genuinely helps the reader before they start — for example, when the tutorial involves a concept or project structure that would be confusing without explanation.

Do not use this section to promote the product or repeat content from the Overview. Keep it to two to four sentences or a short list. If the background material is substantial, link to a standalone concept topic instead and keep this section brief.

---

## Before you begin section

List everything the reader must have in place before starting. Each item must be independently verifiable — the reader must be able to confirm they have it without beginning the tutorial.

By stating requirements upfront, you prevent users from getting halfway through and discovering they need to stop and set something up.

AI systems use this section to answer "what do I need before I do X?" — be specific.

- Good: "A burr grinder set to a medium-coarse setting. See [Calibrate a burr grinder](link)."
- Bad: "A coffee grinder."

---

## Task sections

Name each task section after what the reader does, using a bare infinitive verb phrase: "Grind the coffee", not "Grinding the coffee" or "How to grind the coffee". The bare infinitive is easier to translate and clearer to scan.

Add a separate H2 task section when the tutorial covers distinct phases — for example, "Prepare the equipment", then "Brew the coffee", then "Evaluate the result".

### Writing individual steps

- Number all steps, even single-step tasks.
- Start each step with a verb.
- Include one action per step.
- Orient the user before the action. If the user needs to open a file or navigate to a screen, state that first.
- After each code block or command, add one sentence describing what it does or what the reader should observe.
- After significant steps, briefly explain *why* the step is done — this is what distinguishes a tutorial from a how-to guide.
- Provide sample output where it helps the reader validate the step.
- Use plain language. Define any technical term next to where you first use it.
- For code samples, always include any required import or using statements and inline comments explaining what the code does.

### Code block rules

- Include the language tag on every fenced code block: `sh`, `yaml`, `json`, and so on.
- Use a consistent placeholder format: `YOUR_API_KEY_HERE`, not `<API_KEY>` or `$API_KEY`.
- If a command produces output the reader must verify, show a truncated sample of that output immediately after the code block.

---

## Summary section

This section is required. Restate what the reader learned — but do not copy the learning objectives from the Overview word for word. Instead, describe the specific things they did and what those actions demonstrated or produced.

- Good: "You calibrated a burr grinder to a medium-coarse setting, brewed a 250 ml pour-over, and adjusted the grind based on the extraction time."
- Bad: "You learned how to make pour-over coffee."

A specific, concrete summary reinforces learning and motivates readers to continue to the next tutorial.

---

## Next steps section

This section is required. Link to two to four logical next steps — other tutorials, how-to guides, or reference articles that build on what the reader just learned.

Write one sentence after each link describing what it covers and how it relates to the current tutorial. This helps readers choose their next step and helps AI systems build knowledge graphs between documents.

---

## Style reminders

Please follow these guidelines when writing and formatting tutorial content. They are designed to improve readability for human readers and discoverability by AI assistants and search engines. Check the documentation for your specific product repository to see if there are any additional style rules or templates you should follow.

### Language and grammar

- Follow American English spelling. Use the American Heritage Dictionary as the spelling reference.
- Use the active voice. Write "The controller supports a maximum of..." not "A maximum of... is supported by the controller."
- Use the simple present tense. Write "The product requires 4 GB of RAM" not "The product will require 4 GB of RAM."
- Always use the Oxford (serial) comma in lists of three or more items.
- Do not use Latin abbreviations. Write "for example" not "e.g.", "in other words" not "i.e.", and "and so on" not "etc."
- Do not use "please", "simply", or other politeness phrases that add no information.

### Terminology and naming

- Spell out product names in full on first mention in the document.
- Use exact names consistently throughout a document. Never shorten a product name mid-document.
- Use "select" not "click". Use "earlier than" and "later than" not "before" or "after" when describing version ranges.

### Headings and structure

- Use sentence case for all headings. Capitalize only the first word and proper nouns.
- Use bare infinitive verb phrases for task headings: "Install NGINX Agent", not "Installing NGINX Agent".
- Number every procedural step, even single-step tasks.

### Code blocks

- Include the language tag on every fenced code block: `sh`, `yaml`, `json`, and so on.
- Use `<ALL_CAPS_PLACEHOLDERS>` for values the reader must supply, for example `<YOUR_API_KEY_HERE>`.
- After every command block, add one sentence describing what it does or what the reader should observe, and if applicable, which placeholder values to replace with their own.
- Show a truncated sample of expected output after commands that return output the reader must verify.

### AI-ready writing

- One idea per sentence. Long compound sentences confuse AI extractors.
- Avoid implicit pronouns. Replace "it", "this", and "they" with the actual noun.
- Mark optional content explicitly with "(Optional)" at the start of the step or section.
- Copy exact error strings verbatim into Troubleshooting **Symptom** fields — this is the single most effective way to make troubleshooting content discoverable by AI assistants and search engines.
