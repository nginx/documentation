# Using GitHub Copilot for NGINX documentation

This guide explains how to use GitHub Copilot to draft and review documentation for NGINX products. Copilot automatically reads [.github/copilot-instructions.md](/.github/copilot-instructions.md), which in turn directs it to the F5 Technical Writing Style Guide for style guidelines, brand standards, and Hugo conventions.

## Prerequisites

- [GitHub Copilot subscription](https://github.com/features/copilot) (individual or organization)
- VS Code with the GitHub Copilot extension installed
- Familiarity with the [style guide](https://github.com/F5Docs/style-guide) and [Hugo content guidelines](/documentation/hugo-content.md)

## How Copilot uses copilot-instructions.md

GitHub automatically loads `.github/copilot-instructions.md` as context for every Copilot interaction in this workspace. That file directs Copilot to `.style-guide/agent-instructions/f5-tech-writer-agent.md`, a file in the `.style-guide` git submodule, and tells it to treat that file as primary guidance for the repo.

`copilot-instructions.md` itself covers NGINX-specific context directly:

- F5 NGINX product naming conventions
- Hugo shortcode syntax and include rules
- Git commit message format
- Front matter structure and product names

Voice and tone guidelines, forbidden terms, and other core style rules live in the linked style guide file.

### Confirm the style guide loaded

At the start of a session, confirm Copilot has read the style guide file:

```
@workspace Summarize the instructions in .style-guide/agent-instructions/f5-tech-writer-agent.md
```

If needed, point Copilot there explicitly:

```
@workspace Read .style-guide/agent-instructions/f5-tech-writer-agent.md in full, then continue
```

## Using the F5 Tech Writer Agent workflows

The agent instructions define three response modes. Ask for one by name, or describe what you want in plain language — Copilot maps your request to the matching mode.

### Review

Ask Copilot to review a file. It reads the file, identifies style issues, and cites the specific style guide topic slug each issue violates (for example, `active-voice` or `sentence-length`) alongside a suggested fix. It closes with a reading level assessment: the main factors driving complexity, and specific ways to simplify.

```
@workspace Review content/ngf/overview/gateway-architecture.md
```

### Copy edit

Ask Copilot to copy edit a file, and it edits the file in place. Afterward, it lists every change it made, citing the topic slug for each, and adds a short note on how the changes affect reading level and what could still be simplified.

```
@workspace Copy edit content/ngf/overview/gateway-architecture.md
```

### Draft from notes

Give Copilot raw notes and ask it to draft a document. It identifies the closest content type — concept, getting-started, how-to, installation-guide, reference, release-notes, tech-specs, or tutorial — pulls the matching template, and follows that template's section structure in order. Every section from the template appears as its own H2 heading in the output. If something needed to fill the template is missing, Copilot asks before drafting.

```
@workspace Draft a how-to guide from these notes: [paste notes]
```

### Reading agent citations

When the agent cites a style rule, it uses the topic slug — the filename without `.md`, for example `active-voice`, not "Active voice." If a citation doesn't correspond to a real file in `.style-guide/`, flag it. The agent's instructions require it to say "No matching topic" rather than invent one.

### What the agent always checks

Regardless of which mode you use, the agent prioritizes sentence length, active voice, reading level, and global audience above other style rules, and always checks `word-list.md`, `ui-terms.md`, and `click-vs-select.md` for required term replacements. It flags technical accuracy issues separately and asks you to verify them with a subject matter expert rather than correcting them itself.

## Drafting new content

### Create new documentation pages

Use Copilot Chat to generate new pages following project conventions:

```
@workspace Create a new concept document for NGINX Gateway Fabric about rate limiting
```

The output includes:

- The correct archetype structure
- Proper front matter (title, weight, f5-content-type, f5-product)
- Brand naming guidelines applied
- Hugo shortcodes used correctly

### Generate content sections

Select a heading in your document, open Inline Chat (`Cmd+I` / `Ctrl+I`), and ask:

```
Write a background section explaining how this feature works
```

```
Add a use case section for API rate limiting
```

The generated content follows the style guide.

### Expand on existing content

Select a paragraph and ask:

```
Expand this with more technical details

Add an example configuration

Explain this for a beginner audience
```

## Reviewing and fixing content

### Run comprehensive reviews

In Copilot Chat, review entire files:

```
@workspace Review this file against copilot-instructions.md and list all issues
```

```
@workspace Check this document for:
- Product naming violations
- Passive voice
- Missing alt text
- Incorrect link format
```

### Fix specific issues

#### Active voice

Select passive voice text:

```
You can configure multiple backends
```

Open Inline Chat (`Cmd+I`):

```
Convert to active voice
```

Result:

```
You can configure multiple backends
```

#### Product naming

Select text with acronyms:

```
NIC supports custom policies for NGF resources
```

Inline Chat:

```
Fix product naming per copilot-instructions
```

Result:

```
NGINX Ingress Controller supports custom policies for NGINX Gateway Fabric resources
```

#### Image alt text

Select an image with empty alt text:

```
{{< img src="/ngf/diagram.png" alt="" >}}
```

Inline Chat:

```
Add descriptive alt text
```

#### Link format

Select a relative markdown link:

```
[installation guide](../install/readme.md)
```

Inline Chat:

```
Convert to Hugo ref shortcode with absolute path
```

Result:

```
[installation guide]({{< ref "/ngf/install/readme.md" >}})
```

### Batch fixes across files

Find and fix patterns across multiple files:

```
@workspace Find all files with "allows you to" and suggest active voice alternatives

@workspace Search for product acronyms (NIC, NGF) in content/ and list the files

@workspace Check all images in content/ngf/ for missing alt text
```

## Common workflows

### Rewriting existing content

To rewrite a document following all standards:

```
@workspace Rewrite this document following all guidelines in copilot-instructions.md. Focus on:
1. Active voice
2. F5 product naming on first mention
3. Oxford commas
4. Sentence length limits
5. Present tense
```

### Checking quality before PR

Before submitting a pull request:

```
@workspace Review my changes against the Quality Checklist in copilot-instructions.md
```

Copilot checks:

- Reading level (8th–9th grade)
- Product naming compliance
- Active voice usage
- Forbidden terms
- Link format
- Alt text presence
- Front matter completeness

### Creating includes

When content appears in multiple places:

```
@workspace Should this content be an include file? If yes, suggest the path and show me how to use it
```

Copilot checks:

- Whether content appears in two or more places
- Whether it's context-agnostic
- Proper include path structure

## Using Copilot with Hugo

### Shortcodes

Ask Copilot to insert Hugo shortcodes:

```
Add a call-out note about this configuration requirement

Insert a version shortcode for NGINX Ingress Controller

Add an include for the Kubernetes terminology
```

The correct syntax is:

```
{{< call-out class="note" >}} Important information {{< /call-out >}}
{{< nic-version >}}
{{< include "nic/kubernetes-terminology.md" >}}
```

### Front matter

Ask Copilot to add or fix front matter:

```
Add proper front matter for a concept document about TLS termination in NGF
```

Result:

```
---
title: "TLS termination"
weight: 400
toc: false
f5-content-type: concept
f5-product: F5 NGINX Gateway Fabric
---
```

### Archetypes

Generate content following specific archetypes:

```
Create a tutorial document structure for installing NGINX Plus

Generate a how-to guide for configuring JWT authentication
```

## Prompt best practices

### Be specific

❌ Poor:

```
Improve this writing
```

✅ Good:

```
Rewrite this in active voice following F5 style guidelines
```

### Reference context

```
@workspace Make this section match the tone and style of content/ngf/overview/gateway-architecture.md

Rewrite following the example in custom-policies.md
```

### Iterative refinement

Fix one category at a time:

1. `Fix product naming`
2. `Convert to active voice`
3. `Fix link formatting`
4. `Add alt text to images`

### Use workspace context

Copilot can search the entire repository:

```
@workspace What other documents explain rate limiting? Use those as style examples

@workspace Find similar configuration examples in the codebase
```

## Limitations and cautions

### Always review Copilot output

- **Technical accuracy**: Verify all technical details, commands, and configurations
- **Links**: Check that referenced files actually exist
- **Version info**: Confirm version numbers and compatibility information
- **Product specifics**: Validate product-specific features and behaviors

### Copilot cannot

- Run Hugo commands (`make watch`, `make docs`)
- Execute linters (`make lint-markdown`)
- Commit or push changes to git
- Access external documentation or APIs
- Know about unreleased features or upcoming changes

### When to use Copilot vs manual editing

**Use Copilot for:**

- Style and formatting fixes
- Rewriting for consistency
- Generating boilerplate content
- Finding pattern violations

**Manual editing for:**

- Technical accuracy verification
- Complex conceptual explanations
- Product strategy decisions
- Breaking changes and deprecations

## Integration with existing workflows

### Pre-commit checks

1. Write content with Copilot assistance
2. Ask Copilot to review against standards
3. Run `make lint-markdown` locally
4. Fix any remaining issues
5. Commit with [Conventional Commits format](git-conventions.md)

### Pull request workflow

1. Create feature branch with [proper naming](git-conventions.md#branch-management)
2. Draft content using Copilot
3. Review with Copilot: `@workspace Check against copilot-instructions.md`
4. Run local linting: `make lint-markdown`
5. Preview locally: `make watch`
6. Submit PR with [proper commit message](git-conventions.md#commit-messages)
7. CI checks run automatically (see `.github/workflows/docs-lint.yml`)

### Working with reviewers

Use Copilot to address review feedback:

```
@workspace The reviewer says this is too technical. Simplify for 8th grade reading level

@workspace Apply these review comments to the document: [paste comments]
```

## Tips and tricks

### Learn from existing content

```
@workspace Analyze the writing style in content/ngf/overview/gateway-architecture.md and apply it here
```

### Quick fixes

Select problematic text and use quick prompts:

- `/fix` - General improvements
- `active voice` - Convert from passive
- `simplify` - Reduce complexity
- `expand` - Add more detail

### Save common prompts

Create a personal list of frequent prompts:

- "Review against Quality Checklist"
- "Fix all style violations"
- "Add front matter for concept doc"
- "Convert links to Hugo ref shortcodes"

### Use Copilot Edits mode

For larger rewrites, use Copilot Edits:

1. Open Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`)
2. Select "Copilot: Open Copilot Edits"
3. Add files to edit
4. Provide comprehensive instructions
5. Review all changes together

## Additional resources

- [GitHub Copilot documentation](https://docs.github.com/en/copilot)
- [Style guide](https://github.com/F5Docs/style-guide)
- [Hugo content management](hugo-content.md)
- [Git conventions](git-conventions.md)
- [copilot-instructions.md](../.github/copilot-instructions.md)

## Getting help

If Copilot isn't following guidelines correctly:

1. Reference the instructions file explicitly: `@workspace Follow .github/copilot-instructions.md`
2. Be more specific in your prompt
3. Show examples of what you want
4. Break complex tasks into smaller steps
5. Ask in [GitHub Discussions](https://github.com/nginx/documentation/discussions) if you need help with prompts