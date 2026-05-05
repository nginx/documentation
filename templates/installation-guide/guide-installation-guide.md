# Guide: How to write an installation guide

This guide explains how to complete `template-installation-guide.md`. It covers what an installation guide is, when to write one, how to approach it before you start, and how to complete every field and section correctly.

For a sample, see `example-installation-guide.md`.

---

## What is an installation guide

An installation guide takes your users through the steps required to install, configure, and verify a piece of software on a specific platform. It covers everything from prerequisites and package acquisition through to a running, verified instance.

An installation guide assumes the user has decided what to install and knows why they want it. It does not explain concepts or make the case for the product. Users who need that context should read a quickstart or overview first.

Installation guides are often confused with quickstarts. The table below shows the key differences.

| | Quickstart | Installation guide |
|---|---|---|
| **Orientation** | Learning-oriented: gets a new user to a working demo as fast as possible, often with simplified or pre-configured settings. | Task-oriented: installs the product correctly for real use, including all configuration and verification steps. |
| **Scope** | May skip optional steps or use defaults without explanation. | Covers every step the reader must take, including configuration decisions that affect production use. |
| **Assumed knowledge** | Assumes little to no product knowledge. | Assumes the reader has chosen the product and understands its purpose. |
| **Output** | A working demo or sandbox environment. | A correctly installed and verified instance ready for real use. |

---

## Why write an installation guide

A well-written installation guide:

- Reduces support costs by giving users a single, authoritative path through installation.
- Prevents misconfiguration by making every required setting explicit.
- Serves as a reference users return to when reinstalling or setting up additional instances.
- Provides AI assistants with structured, citable steps that can be surfaced in response to "how do I install X" queries.

---

## Before you start writing

Before writing, identify:

- The target platform. Write one installation guide per platform. Do not combine Linux and Windows steps in a single guide — the conditional branching makes the guide harder to follow and harder for AI to extract.
- The exact install path. There is often more than one way to install software (package manager, binary download, container, source). Choose the recommended method and document only that one. Link to alternatives at the bottom.
- Every prerequisite the user must satisfy before running the first command. Missing prerequisites are the most common cause of installation failures and support requests.
- The verification steps that confirm a successful installation. A guide that ends at "install complete" without verification leaves the user uncertain.
- The two or three most common failure modes and their fixes. These become your Troubleshooting section.

---

## Best practices

- **One platform per guide.** Write one guide per operating system or distribution. If steps differ between Ubuntu and RHEL, write two guides. Combining them forces users to read steps that do not apply to them.
- **One install method per guide.** If multiple install methods exist, document the recommended one. Mention alternatives only by linking to a separate document.
- **Number every step.** Numbered steps are the most reliable structure for AI to extract procedural instructions. Do not use unnumbered prose for steps, even if a task has only one step.
- **Add an outcome sentence after every command.** State what the command does or what the reader should observe. This is the part AI assistants are most likely to surface when answering follow-up questions.
- **Show expected output.** After commands that produce output the reader must verify — such as a version check or a status command — show a truncated example of the expected output. This lets readers confirm they are on the right path without guessing.
- **Test your instructions end to end.** Run through every step on a clean machine or VM that matches the target platform. This uncovers omitted steps, version mismatches, and permissions gaps. If you cannot test them yourself, have a developer or subject matter expert demonstrate the steps.
- **Re-test after every notable product release.** Package names, configuration keys, and service names can change between releases. Re-test end to end whenever a significant release affects the product you are documenting.
- **Minimise links within the guide.** Keep users on a single page. Provide links to supporting or background information in the References section, not inline.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules in every section of the guide.

**1. One idea per sentence.** Long compound sentences confuse AI extractors.

- Bad: "Open the config file, which is located at /etc/nginx-agent/nginx-agent.conf, and replace the token value with the key you copied from the console."
- Good: "Open `/etc/nginx-agent/nginx-agent.conf`. Replace `YOUR_DATA_PLANE_KEY_HERE` with the data plane key you copied from NGINX One Console."

**2. Use exact names consistently.** If the product is "NGINX Agent", never shorten it to "the agent" mid-guide. Inconsistency breaks AI entity resolution and confuses readers who arrive mid-page from search.

**3. State the outcome of each step.** After every command or code block, add one sentence describing what it does or what the reader should observe. AI assistants surface these outcome sentences when answering questions like "what does this command do?"

**4. Avoid implicit pronouns.** Replace "it", "this", and "they" with the actual noun.

- Bad: "Reload it to apply the changes."
- Good: "Reload NGINX Agent to apply the changes."

**5. Keep code blocks self-contained.** Every code block must be runnable in isolation or clearly note what must be substituted. Use `ALL_CAPS_PLACEHOLDERS` for values the reader must supply — for example, `YOUR_DATA_PLANE_KEY_HERE` or `YOUR_INSTANCE_IP_HERE`.

**6. Use parallel structure in lists.** Every bullet or numbered step should follow the same grammatical pattern — all start with a verb, or all are noun phrases.

**7. Mark optional content explicitly.** Use "(Optional)" at the start of any step, section, or field that not every reader will need.

**8. Copy error strings verbatim into Troubleshooting.** AI assistants frequently surface troubleshooting content in response to error messages. Copying the exact error string into the Symptom field is the single most effective thing you can do to make troubleshooting content discoverable.

---

## Section requirements

| Section | Required? |
|---|---|
| Overview | Required |
| Before you begin | Required |
| At least one task section | Required |
| Verify the installation | Required |
| References | Required |
| Troubleshooting | Conditional — include when two or more common failure modes exist |
| Additional task sections | Optional — add for distinct installation phases such as download, install, and configure |

---

## Frontmatter fields

### Required fields

**f5-content-type**: Always `installation-guide` for installation content.

**f5-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**f5-product**: The product code. Check an existing document for the same product if you are unsure which code to use.

**title**: Use an imperative verb phrase beginning with "Install". Keep it under 60 characters. Include the platform when the guide is platform-specific.

- Good: "Install NGINX Agent on Ubuntu"
- Bad: "How to install NGINX Agent on Ubuntu" or "Installing NGINX Agent"

**description**: One sentence under 160 characters summarizing what the reader installs and on what platform. Include the platform version if the guide is version-specific. This text appears in search engine results, AI assistant citations, and doc portal previews.

**weight**: Controls the sort order within the section. Lower numbers appear first.

**toc**: Set to `true` to render an in-page table of contents. Use `false` only for very short single-task guides.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling. Filling them in improves discoverability and the quality of AI-generated answers that cite this page.

**f5-keywords**: Comma-separated terms a reader might type to find this guide. Include the product name, package name, CLI commands used in the guide, the platform and version, and common alternative phrasings such as "setup", "deploy", or "get started".

**f5-summary**: Two to three sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Write in plain prose and avoid jargon. Cover:

- Sentence 1: what the reader will install and where
- Sentence 2: what the installed component does or enables
- Sentence 3 (optional): supported platforms, versions, or scope limits

**f5-audience**: Who this guide is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`. This helps AI systems route questions to the right document and allows doc portals to filter content by role.

---

## Overview section

Write two to four sentences. Cover what is being installed, what it does or enables, and what the reader will have at the end of this guide.

The Overview is the paragraph most likely to be surfaced verbatim by AI assistants — make every sentence count. Do not start with "This guide explains how to" — that is redundant given the title. Lead with the value: "Use this guide to install X so that Y."

Examples of good overview sentences:

- "Use this guide to install NGINX Agent on Ubuntu 22.04. NGINX Agent is a lightweight daemon that reports configuration state and metrics to NGINX One Console."
- "Use this guide to install the NGINX Plus package on RHEL 9. After completing this guide, NGINX Plus will be running and ready to configure as a load balancer or API gateway."

---

## Before you begin section

List everything the reader must have in place before starting. Each item must be independently verifiable — the reader must be able to confirm they have it without starting the procedure.

For installation guides, always include:

- Operating system and version — include the command the reader runs to verify it.
- Any software that must be installed first — with a link to its installation instructions.
- Any credentials or keys — with a link to where to obtain them. Note if the credential is displayed only once.
- Privilege requirements — for example, `sudo` access or root.
- Network requirements — any ports, endpoints, or outbound access the installation requires.

AI systems use this section to answer "what do I need before I install X?" — be specific.

- Good: "A data plane key from NGINX One Console. See [Create a data plane key](link). Store the key securely — it is displayed only once."
- Bad: "Access to NGINX One."

If there are more than five prerequisites, group them by type:

- Accounts and credentials
- Software and tools
- Network and environment requirements

You can also use this section to redirect users who are in the wrong place. For example: "If you are installing on RHEL, see [Install NGINX Agent on RHEL](link)."

---

## Task sections

Name each task section after what the reader does, using a bare infinitive verb phrase: "Install NGINX Agent", not "Installing NGINX Agent" or "How to install NGINX Agent". The bare infinitive is easier to translate and clearer to scan.

Add a separate H2 task section when:

- The procedure differs significantly for two supported variants (for example, package manager vs binary install)
- The reader must complete a second independent phase (for example, install, then configure)

For installation guides, a standard set of task sections is:

1. **Add the repository** (if the software is installed from a package manager)
2. **Install {product name}**
3. **Configure {product name}**
4. **Start {product name}** (if the software runs as a service)
5. **Verify the installation** (always required)

Not every guide will need all five. Add or remove sections to match the actual installation procedure. The Verify section is always required.

### Writing individual steps

- Start each step with a verb.
- Include one action per step.
- Orient the user before the action: state what file to open or what screen to navigate to before giving the command.
- After each command or code block, add one sentence describing what it does or what the reader should observe. This outcome sentence is the part AI assistants are most likely to surface when answering follow-up questions.
- Show a sample of expected output after commands that return output the reader must verify.
- Use plain language. Define any technical term next to where you first use it.

Optionally, open a task section with one sentence stating the purpose of the task, but only if the heading alone does not make the purpose clear.

### Code block rules

- Include the language tag on every fenced code block: `sh`, `yaml`, `json`, and so on.
- Use a consistent placeholder format: `YOUR_DATA_PLANE_KEY_HERE`, not `<KEY>` or `$KEY`.
- If a command produces output the reader must verify, show a truncated sample of that output immediately after the code block.

---

## Verify the installation section

This section is required. It must give the reader a definitive way to confirm the installation succeeded.

A good verification section includes:

- A command that produces readable output confirming the installed version or running state.
- A sample of the expected output so the reader can compare.
- (Optional) A secondary check — for example, confirming the instance appears in a management console.

Without a verification section, readers must guess whether the installation succeeded. This increases support volume and reduces trust in the documentation.

---

## Troubleshooting section

Include this section when two or more common failure modes exist.

Use a consistent format for each issue:

- **Symptom**: What the reader observes. Copy the exact error message string if one exists — this makes the entry discoverable by search engines and AI assistants when users paste the error message into a query.
- **Cause**: Why it happens, in one sentence.
- **Fix**: What to do, written as imperative steps or a command.

AI assistants frequently surface troubleshooting content in response to error messages. Copying the exact error string into the Symptom field is the single most effective thing you can do to make troubleshooting content discoverable.

For installation guides, the most common failure modes are:

- Service fails to start due to a configuration error.
- The installed component cannot reach its upstream endpoint due to a firewall rule.
- Authentication fails due to an incorrect or expired credential.

---

## References section

Link to related docs that provide deeper context or logical next steps. For installation guides, standard references include:

- The upgrade guide
- The uninstall guide
- Any credential or key creation guides referenced in Before you begin
- The configuration reference for the installed component
- Release notes or changelog

Use this section to link to anything you deliberately kept out of the main guide body to avoid interrupting the flow of steps. Always use the `ref` shortcode for internal links so they survive URL changes. AI systems use this section to build knowledge graphs between documents.

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
