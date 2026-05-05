# Guide: How to write release notes

This guide explains how to complete `template-release-notes.md`. It covers what release notes are, when to write them, how to approach them before you start, and how to complete every section correctly.

For a sample, see `example-release-notes.md`.

---

## What are release notes?

Release notes communicate new features, changes to existing behavior, resolved issues, and known issues to the people who use your product. They are published at the same time as each product release.

Release notes are written for a mixed audience of technical and non-technical stakeholders — including customers, support teams, sales, and marketing. Every entry must be understandable to someone who is not a developer and who was not involved in building the change.

Release notes are often confused with changelogs. The table below shows the key differences.

| | Release notes | Changelog |
|---|---|---|
| **Audience** | Customers and non-technical stakeholders | Developers and engineering teams |
| **Language** | Plain language; explains what changed and why it matters | Technical language; describes code changes and their scope |
| **Content** | New features, behavior changes, resolved issues, security updates — with links to full documentation | Commit messages, merge request references, issue numbers, contributor names |
| **Effort** | Requires research to understand user impact and benefit | Light effort; derived from commit messages and version control |
| **Written by** | Technical writer or product manager | Software developer |

---

## Why write release notes?

Well-written release notes:

- Demonstrate that the product is actively maintained and that its builders care about the user experience.
- Reduce support tickets by informing stakeholders about new features, behavior changes, and known issues before they encounter them.
- Help stakeholders assess the impact of upgrading to a new version.
- Provide a plain-language record of the product's evolution that does not require reading developer-facing changelogs.
- Give AI assistants structured, citable entries that can be surfaced in response to queries such as "what changed in version X?" or "was issue Y fixed?"

---

## Before you start writing

Before writing, identify:

- **The release version and date.** Use semantic versioning (MAJOR.MINOR.PATCH, for example `2.16.0`). The date should be the public release date in `Month Day, Year` format.
- **What changed.** Work with the engineering and product teams to get a complete list of features, behavior changes, resolved issues, and security updates in the release. Do not rely on commit messages alone — they are written for developers, not customers.
- **What matters to the user.** For each change, ask: "Why does this matter to a customer? What can they now do that they could not do before, or what problem does this fix for them?" If a change has no user-facing impact, it does not belong in release notes.
- **Whether an upgrade guide is needed.** If the release requires users to take action before or during upgrading — such as backing up data, running a migration script, or changing configuration — include an upgrade guide section. A missing upgrade notice is one of the most damaging omissions in release notes.
- **Which sections apply to this release.** Not every release has new features, behavior changes, and security updates. Include only the sections that apply. Omit empty sections entirely.

---

## Best practices

- **Write for the customer, not the engineer.** Every entry must answer "what does this mean for me?" from the customer's point of view. Translate technical changes into user impact.
- **Write in the present tense for new features and changes.** Use the past tense only for resolved issues.
  - New feature: "You can now filter instances by region."
  - Resolved issue: "Fixed an issue where the dashboard failed to load when more than 50 instances were connected."
- **Write in the second person.** Address the reader as "you". For example: "You can now export reports as CSV."
- **Be concise.** Each entry needs a bold title and two to four sentences of description. Link to the full documentation for details. The release notes entry is a summary, not a tutorial.
- **Link to full documentation.** Every new feature and behavior change entry must link to the documentation that covers it in full. The release notes entry is not the source of truth — the documentation is.
- **List the most impactful items first.** Within each section, list items in order of impact to the user, not in order of development completion.
- **Use consistent formatting.** Every entry in a section must follow the same structure: bold title, then description. Do not mix formats within a section.
- **Do not disclose security issues prematurely.** Security updates must not be published until an investigation is complete and a fix is available. Include the standard security disclosure callout in every release that contains security updates.

---

## AI-ready writing principles

AI assistants and human readers parse documentation differently from search engines. Apply these rules in every section of the release notes.

**1. Use exact product and feature names consistently.** If the feature is called "Instance Manager", never shorten it to "the manager" or "IM" in the same document. Inconsistency breaks AI entity resolution.

**2. One idea per sentence.** Long compound sentences confuse AI extractors.

- Bad: "We have added a new feature that allows you to filter instances by region and also export the filtered results as a CSV file."
- Good: "You can now filter instances by region. You can also export filtered results as a CSV file."

**3. Include the CVE identifier in the entry text for security updates, not only in a link.** AI assistants extract CVE numbers most reliably when they appear as plain text in the entry, not only as link text.

**4. State issue identifiers in plain text as well as in links.** Write the issue number in the entry text so it is findable by search and AI systems even when the link cannot be followed.

- Good: "Fixed an issue where the dashboard failed to load (issue 1234)."
- Bad: "Fixed an issue where the dashboard failed to load ([details](https://example.com/issues/1234))."

**5. Avoid implicit pronouns.** Replace "it", "this", and "they" with the actual feature or product name.

- Bad: "It now supports multi-region deployments."
- Good: "NGINX Agent now supports multi-region deployments."

---

## Section requirements

| Section | Required? |
|---|---|
| Version number and date | Required |
| What's new | Conditional — include when the release contains new features |
| Changes to default behavior | Conditional — include when the release changes existing behavior |
| Resolved issues | Conditional — include when the release fixes reported issues |
| Known issues | Required — always link to the known issues page |
| Upgrade guide | Conditional — include when users must take action before or during upgrading |
| Security updates | Conditional — include when the release contains security fixes |
| High-level summary | Optional — include for large releases with many changes |

---

## Frontmatter fields

### Required fields

**f5-content-type**: Always `release-notes` for release note pages.

**f5-docs**: The tracking ID for this document. Use `DOCS-000` until a real ID is assigned.

**f5-product**: The product code. Check an existing document for the same product if you are unsure which code to use.

**title**: Use `"{Product Name} release notes"`. Keep it under 60 characters. This page covers all versions of the product, so do not include a version number in the title.

- Good: "Nbeamex Coffee release notes"
- Bad: "Nbeamex Coffee 2.16.0 release notes" or "Release notes for Nbeamex Coffee"

**description**: One sentence under 160 characters summarizing what this page covers. Include the product name and the types of changes documented. This text appears in search engine results, AI assistant citations, and doc portal previews.

- Good: "New features, behavior changes, and resolved issues for Nbeamex Coffee 2.16.0."
- Bad: "Release notes."

**weight**: Controls the sort order within the section. Lower numbers appear first.

**toc**: Set to `true` to render an in-page table of contents. Release notes pages almost always benefit from a table of contents because they accumulate multiple version sections over time.

### AI enrichment fields (recommended)

These fields are not rendered in the product UI, but they are consumed by AI systems, search indexes, and docs-as-code tooling. Filling them in improves discoverability and the quality of AI-generated answers that cite this page.

**f5-keywords**: Comma-separated terms a reader might type to find this page. Include the product name, version numbers covered, and the types of changes in the most recent release — for example, feature names, resolved issue identifiers, and CVE numbers.

**f5-summary**: Two to three sentences expanding on `description`. AI assistants use this field when generating answers that cite this page. Write in plain prose and avoid jargon. Cover:

- Sentence 1: what product and version range these release notes cover
- Sentence 2: the most significant change or theme of the release
- Sentence 3 (optional): any scope limits, such as platform or edition

**f5-audience**: Who this page is for. Accepted values: `developer`, `operator`, `admin`, `architect`, `any`. Release notes are typically `any` because they are read by a mixed technical and non-technical audience.

---

## Version number and date

Each release gets its own H2 heading with the version number, followed by the release date on its own line.

Use semantic versioning: three numbers separated by periods (MAJOR.MINOR.PATCH). For example: `2.16.0`.

Use the `Month Day, Year` date format. For example: `April 18, 2024`.

---

## High-level summary

This section is optional. Include it for large releases where a short orientation helps readers decide which sections to read.

Write one to three sentences summarizing the most important changes in the release. Do not repeat information that is fully described in the sections below — the summary should orient the reader, not replace the entries.

---

## Upgrade guide section

Include this section when the release requires users to take action before, during, or after upgrading. Examples include: running a migration script, changing a configuration file format, removing a deprecated setting, or installing a new dependency.

State the required action clearly as a numbered step or a direct instruction. Link to the full upgrade documentation if a standalone upgrade guide exists.

If no user action is required to upgrade, omit this section entirely.

---

## What's new section

List new features and enhancements introduced in this release. List the most impactful items first.

For each entry:

1. Write a bold title that summarizes the feature in one concise phrase.
2. Write two to four sentences describing what the feature does and how it benefits the user. Answer: "What can I now do that I could not do before?"
3. Link to the full documentation for the feature.

**Writing formulas**

Use one of these formulas as a starting point:

- "You can now {describe the new capability}. {Describe the benefit}. See [{doc title}]({link}) for more information."
- "{Product} now {provides / supports / includes} {feature}. {Describe the benefit}. See [{doc title}]({link}) for more information."

---

## Changes to default behavior section

List changes that affect how the product behaves for existing users — without being new features or bug fixes. Examples include: a default setting changing its value, a deprecated option being removed, or a built-in timeout being adjusted.

These entries are important because they can cause unexpected behavior for users who upgrade without reading the release notes. Write them clearly and always link to the documentation that describes the new behavior.

For each entry:

1. Write a bold title that summarizes the change.
2. Write one to three sentences describing what changed, what the previous behavior was, and what the new behavior is.
3. Link to the documentation that covers the new behavior.

---

## Resolved issues section

List the issues fixed in this release. Each entry must include the issue identifier, linked to the issue in the issue tracker.

For each entry, write one sentence in the past tense describing what was broken and what was fixed. Do not describe the technical cause or the fix implementation — focus on the user-facing symptom that is now resolved.

Format: "Fixed an issue where {symptom} ({issue ID with link})."

---

## Known issues section

This section is always required. Do not list individual known issues inline — link to the standalone known issues page instead. Maintaining a separate known issues page keeps the release notes from becoming out of date as issues are resolved.

Use this standard text, updated with the correct link: "You can find the list of known issues in the [Known issues]({link}) topic."

---

## Security updates section

List security fixes included in this release. Always include the standard security disclosure callout before the list of updates.

For each entry:

1. Write a bold title that includes the vulnerability name and CVE identifier.
2. Write two to three sentences describing the vulnerability, its potential impact, and that it has been resolved in this release.
3. Link the CVE identifier to the official CVE record.

Do not publish security updates until an investigation is complete and a fix is available and released.

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
