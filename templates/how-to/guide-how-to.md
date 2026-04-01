# Guide: How to write a how-to guide

This guide explains how to complete `template-how-to.md`. It covers what a how-to is, when to write one, how to approach it before you start, and how to complete every field and section correctly.

For a sample, see `example-how-to.md`.

---

## What is a how-to guide?

A how-to guide takes your users through a series of steps required to solve a specific problem or complete a task in your product, for example, how to create an issue in GitHub or how to connect an NGINX instance to NGINX One.

A how-to assumes the user has basic knowledge of the product. It does not teach concepts. Users who need foundational knowledge should read a quickstart or tutorial first.

How-tos are often confused with tutorials. The table below shows the key differences.

| | Tutorial | How-to |
|---|---|---|
| **Orientation** | Learning-oriented: helps users learn a new feature in a hands-on way. | Task-oriented: helps an experienced user accomplish a task or troubleshoot an issue. |
| **Structure** | Follows a carefully managed path from start to finish. | Guides the user along the safest, surest way to a successful result. |
| **Unexpected scenarios** | Eliminates unexpected scenarios and guarantees a successful finish. | Alerts the user to the possibility of unexpected scenarios and explains how to handle them. |
| **Assumed knowledge** | Assumes no practical knowledge; states all tools, configuration, and concepts explicitly. | Assumes practical knowledge of tools, file configurations, and the application. |

---

## Why write a how-to guide?

A well-written how-to guide:

- Demonstrates the capabilities of your product to users who already know what they want to achieve.
- Guides users through a real-world task in a reliable, ordered way.
- Answers specific questions that users encounter while working.
- Reduces support costs by helping users help themselves.

New users can also benefit from a how-to, provided it clearly states any prerequisite knowledge required to complete the task.

---

## Before you start writing

Before writing, identify:

- The main use case this guide addresses.
- The different real-world scenarios a user might encounter while completing the task. Map out the "if this, then that" branches.
- The surest and safest way to complete the task. Do not document multiple ways to achieve the same goal — choose the most common or recommended method and document only that one. Presenting options forces users to think through trade-offs. Save them that effort.
- The error scenarios a user might encounter and their solutions.

---

## Best practices

- **One task per guide.** Address one logical goal per how-to page. Avoid guides where only a subsection is relevant to any given user.
- **One method per task.** If more than one way exists to complete a task, document the recommended method. Mention alternatives only by linking to a separate document.
- **Prepare users for the unexpected.** Alert the user to the possibility of unexpected scenarios and provide guidance. Use callouts (warning, caution, note) to communicate important information without interrupting the flow of steps.
- **Use conditional imperatives.** Frame conditional steps as "If you want X, do Y" or "To achieve W, do Z."
- **Limit steps per task.** Lengthy how-tos overwhelm users. Aim for a maximum of 8 to 10 steps per task. If the task is too large, break it into multiple logical sub-tasks, each with its own heading and steps.
- **Test your instructions end to end.** Always verify that the steps are technically accurate by running through them yourself. This uncovers omitted steps, incorrect details, steps out of order, and gaps that block users. If you cannot test them yourself, have a developer or subject matter expert demonstrate the steps and record the session.
- **Re-test after every notable product release.** Instructions can become inaccurate after product changes. Re-test end to end whenever a significant release affects the feature you are documenting.
- **Minimise links within the guide.** Keep users on a single page as much as possible. Provide links to supporting or background information at the bottom of the page in the References section, not inline.
- **Do not document edge cases.** Avoid writing about scenarios at the boundaries of your product's capability.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules in every section of the guide.

**1. One idea per sentence.** Long compound sentences confuse AI extractors.

- Bad: "Open the config file, which is located at /etc/nginx/nginx.conf, and add the stream block."
- Good: "Open /etc/nginx/nginx.conf. Add the stream block shown below."

**2. Use exact names consistently.** If the product is "NGINX Agent", never shorten it to "the agent" mid-guide. Inconsistency breaks AI entity resolution.

**3. State the outcome of each step.** After a command or code block, add one sentence describing what it does or what the reader should observe.

**4. Avoid implicit pronouns.** Replace "it", "this", and "they" with the actual noun.

- Bad: "Reload it to apply the changes."
- Good: "Reload NGINX to apply the changes."

**5. Keep code blocks self-contained.** Every code block must be runnable in isolation or clearly note what must be substituted. Use ALL_CAPS_PLACEHOLDERS for values the reader must supply (for example, YOUR_JWT_HERE or YOUR_DATA_PLANE_KEY_HERE).

**6. Use parallel structure in lists.** Every bullet or numbered step should follow the same grammatical pattern — all start with a verb, or all are noun phrases.

**7. Mark optional content explicitly.** Use "(Optional)" at the start of any step, section, or field that not every reader will need.

---

## Section requirements

| Section | Required? |
|---|---|
| Frontmatter | Required |
| Overview | Required |
| Before you begin | Required |
| At least one task section | Required |
| References | Required |
| Troubleshooting | Conditional — include when two or more common failure modes exist |
| Additional task sections | Optional — add when the guide covers distinct phases or variants |

---

## Frontmatter fields

### Required fields

**nd-content-type**: Always `how-to` for task-based guides.

**nd-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**nd-product**: The product code. Ask your team lead or the technical writers if you are unsure which code to use. You can also check the code of an existing document for the same product.

**title**: Use an imperative verb phrase — the same verb form you would use to tell someone what to do. Keep it under 60 characters so it fits cleanly in navigation menus and search results.

- Good: "Connect NGINX Plus container images"
- Bad: "How to connect NGINX Plus container images" or "Connecting NGINX Plus container images"

**description**: One sentence under 160 characters summarizing what the reader will achieve. This text appears in search engine results, AI assistant citations, and doc portal previews. Write it as a complete sentence: "Configure X to do Y" or "Learn how to connect X to Y."

**weight**: Controls the sort order within the section. Lower numbers appear first. Ask your documentation team for the correct value if you are unsure.

**toc**: Set to `true` to render an in-page table of contents. Use `false` only for very short guides with a single task section.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling. Filling them in improves discoverability and the quality of AI-generated answers that cite this page.

**nd-keywords**: Comma-separated terms a reader might type to find this guide. Include product names, feature names, CLI commands, file paths, and common misspellings or alternative phrasings.

**nd-summary**: Two to three sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Write in plain prose and avoid jargon. Cover:

- Sentence 1: what the reader will configure or achieve
- Sentence 2: why they would need to do this, or the problem it solves
- Sentence 3 (optional): any important constraints or scope boundaries

**nd-audience**: Who this guide is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`. This helps AI systems route questions to the right document and allows doc portals to filter content by role.

---

## Overview section

Write two to four sentences. Cover what this guide does, why the reader would do it, and any important scope or constraint.

The Overview is the paragraph most likely to be surfaced verbatim by AI assistants — make every sentence count. Do not start with "This guide explains how to" because that is redundant given the title. Lead with the value instead: "Use this guide to configure X so that Y."

Examples of good overview sentences:

- "Use this guide to create an issue on GitHub. Issues let you track ideas, feedback, tasks, or bugs for work on a repository."
- "Use this guide to resolve a merge conflict using the command line. Merge conflicts occur when competing changes are made to the same line of a file."

---

## Before you begin section

List everything the reader must have in place before starting. Each item must be independently verifiable — the reader must be able to confirm they have it without starting the procedure.

By stating requirements upfront, you prevent users from getting halfway through and discovering they need to read other documentation before continuing.

AI systems use this section to answer the question "what do I need before I do X?" — be specific.

- Good: "A data plane key from NGINX One. See [Create a data plane key](link)."
- Bad: "Access to NGINX One."

If there are more than five prerequisites, group them by type:

- Accounts and credentials
- Software and tools
- Configuration or environment state

You can also use this section to redirect users who are in the wrong place. For example: "If you are using Linux, see [the Linux version of this guide](link)."

---

## Task sections

Name each task section after what the reader does, not what the system does. Use a bare infinitive verb phrase — "Connect to the instance", not "Connecting to the instance" or "How to connect to the instance". The bare infinitive is easier to translate and clearer to scan.

Add a separate H2 task section when:

- The procedure differs significantly for two supported variants (for example, Agent 2.x or 3.x)
- The reader must complete a second independent phase (for example, configure, then verify)

Number all steps, even single-step tasks. Numbered steps are the most reliable structure for AI to extract procedural instructions.

Optionally, open a task section with one sentence stating the purpose of the task, but only if the heading alone does not make the purpose clear.

### Writing individual steps

- Start each step with a verb.
- Include one action per step.
- Orient the user before the action. If the user needs to open a file or navigate to a screen to complete the step, state that first.
- After each code block or command, add one sentence describing what it does or what the reader should observe. This outcome sentence is the part AI assistants are most likely to surface when answering follow-up questions.
- Provide sample output where it helps the user validate they completed the step correctly — for example, after a CLI command that returns a status message.
- Use plain language. Define any technical term next to where you first use it.

### Code block rules

- Include the language tag on every fenced code block (sh, yaml, nginx, json, and so on).
- Use a consistent placeholder format throughout the guide: `YOUR_JWT_HERE`, not `<JWT>` or `$JWT`.
- If a command produces output the reader must verify, show a truncated sample of that output immediately after the code block.

---

## Troubleshooting section

Include this section when two or more common failure modes exist for the tasks in this guide.

Use a consistent format for each issue:

- **Symptom**: What the reader observes — copy the exact error message string if one exists, so it is indexable by AI and search.
- **Cause**: Why it happens, in one sentence.
- **Fix**: What to do, written as imperative steps or a command.

AI assistants frequently surface troubleshooting content in response to error messages. Copying the exact error string into the Symptom field is the single most effective thing you can do to make troubleshooting content discoverable.

---

## References section

Link to related docs that provide deeper context or logical next steps. Group links by type:

- How-to guides the reader is likely to need next
- Conceptual or background topics
- API or configuration references
- External resources

Use this section to link to anything you deliberately kept out of the main guide body to avoid interrupting the flow of steps. Always use the `ref` shortcode for internal links so they survive URL changes. AI systems use this section to build knowledge graphs between documents.

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