# Using GitHub Copilot for NGINX documentation

This guide explains how to use GitHub Copilot to draft and review documentation for NGINX products. Copilot automatically reads [.github/copilot-instructions.md](/.github/copilot-instructions.md) and applies the project's style guidelines, brand standards, and Hugo conventions.

## Prerequisites

- [GitHub Copilot subscription](https://github.com/features/copilot) (individual or organization)
- VS Code with the GitHub Copilot extension installed
- Familiarity with the [style guide](/documentation/style-guide.md) and [Hugo content guidelines](/documentation/hugo-content.md)

## How Copilot uses copilot-instructions.md

The `.github/copilot-instructions.md` file is automatically loaded as context for all Copilot interactions in this workspace. This means Copilot "knows" about:

- F5 NGINX product naming conventions
- Markdown formatting standards
- Hugo shortcode syntax
- Git commit message format
- Voice and tone guidelines
- Forbidden terms and preferred replacements

You don't need to paste these guidelines into every chat prompt—Copilot already has them.

## Drafting new content

### Create new documentation pages

Use Copilot Chat to generate new pages following project conventions:

```
@workspace Create a new concept document for NGINX Gateway Fabric about rate limiting
```

Copilot will:
- Use the correct archetype structure
- Include proper front matter (title, weight, nd-content-type, nd-product)
- Follow brand naming guidelines
- Use Hugo shortcodes correctly

### Generate content sections

Select a heading in your document, open Inline Chat (`Cmd+I` / `Ctrl+I`), and ask:

```
Write a background section explaining how this feature works
```

```
Add a use case section for API rate limiting
```

Copilot generates content following the style guide automatically.

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
allows users to configure multiple backends
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

- Reading level (8th-9th grade)
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

Copilot considers:
- Whether content appears 2+ times
- If it's context-agnostic
- Proper include path structure

## Using Copilot with Hugo

### Shortcodes

Ask Copilot to insert Hugo shortcodes:

```
Add a call-out note about this configuration requirement

Insert a version shortcode for NGINX Ingress Controller

Add an include for the Kubernetes terminology
```

Copilot knows the correct syntax:

```markdown
{{< call-out "note" >}} Important information {{< /call-out >}}
{{< nic-version >}}
{{< include "nic/kubernetes-terminology.md" >}}
```

### Front matter

Ask Copilot to add or fix front matter:

```
Add proper front matter for a concept document about TLS termination in NGF
```

Result:

```yaml
---
title: "TLS termination"
weight: 400
toc: false
nd-content-type: concept
nd-product: FABRIC
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

Copilot has access to the entire repository:

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
5. Commit with [Conventional Commits format](/documentation/git-conventions.md)

### Pull request workflow

1. Create feature branch with [proper naming](/documentation/git-conventions.md#branch-management)
2. Draft content using Copilot
3. Review with Copilot: `@workspace Check against copilot-instructions.md`
4. Run local linting: `make lint-markdown`
5. Preview locally: `make watch`
6. Submit PR with [proper commit message](/documentation/git-conventions.md#commit-messages)
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
- [Style guide](/documentation/style-guide.md)
- [Hugo content management](/documentation/hugo-content.md)
- [Git conventions](/documentation/git-conventions.md)
- [copilot-instructions.md](/.github/copilot-instructions.md)

## Getting help

If Copilot isn't following guidelines correctly:

1. Reference the instructions file explicitly: `@workspace Follow .github/copilot-instructions.md`
2. Be more specific in your prompt
3. Show examples of what you want
4. Break complex tasks into smaller steps
5. Ask in [GitHub Discussions](https://github.com/nginx/documentation/discussions) if you need help with prompts
