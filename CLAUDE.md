# NGINX Documentation

@.style-guide/agent-instructions/f5-tech-writer-agent.md

## Hugo includes

Some docs use Hugo shortcodes to include content from other files, for example:

    {{< include file="path/to/file.md" >}}

When you encounter an include shortcode in a file you are editing, read the
included file and review it for style issues as part of the same task. Apply
the same style rules to included files. List changes to included files
separately in your output, citing the filename.

---

## Repo overview

This is a Hugo-based documentation site for F5 NGINX products (NGINX Plus,
NGINX Ingress Controller, NGINX Gateway Fabric, WAF, Instance Manager, etc.).
Content is written in Markdown with Hugo shortcodes, transformed to HTML via
Hugo v0.152.2, using the custom theme `github.com/nginxinc/nginx-hugo-theme/v2`.

## Build and dev commands

```bash
# Update Hugo theme before starting work
make hugo-update

# Local development server
make watch  # http://localhost:1313

# Include draft content
make drafts

# Build for production
make docs  # outputs to public/

# Linting
make lint-markdown       # markdownlint-cli2
make link-check          # markdown-link-check
```

## Content structure

- `content/` -- Product documentation organized by product code (`nic/`, `ngf/`, `waf/`, `nim/`, `agent/`, etc.)
- `content/includes/` -- Reusable content fragments (for example, `content/includes/waf/terminology.md`)
- `archetypes/` -- Hugo templates for new pages (`default.md`, `concept.md`, `tutorial.md`, `landing-page.md`)
- `layouts/shortcodes/` -- Custom Hugo shortcodes for product versions and special formatting
- `static/` -- Static assets (images, scripts) organized by product
- `documentation/` -- Internal process docs

## Creating new content

Use Hugo archetypes to scaffold new documentation:

```bash
# Default how-to guide
hugo new content nic/how-to/configure-ssl.md

# Specific archetype
hugo new content ngf/concepts/routing.md -k concept
```

Front matter structure:

```yaml
title: "Page title"           # Sentence case; how-to/tutorial: verb phrase; concept: noun phrase
description: "One sentence summarizing the page, under 160 characters."
weight: 100                   # Controls sort order, increments of 100
toc: false                    # Enable for large documents (tech-specs, tutorial)
f5-product: F5 NGINX Ingress Controller           # Use a name from the Product Names list below
f5-content-type: how-to       # how-to | concept | reference | tech-specs | tutorial | getting-started | installation-guide | release-notes
f5-docs: DOCS-000             # Jira ticket ID for the doc request
f5-keywords: "keyword1, keyword2, keyword3"
f5-summary: >
  Sentence 1: what the page covers.
  Sentence 2: why it matters to the reader.
  Sentence 3 (optional): scope or constraints.
f5-audience: any              # developer | operator | admin | architect | any
```

When adding or updating `f5-product` in front matter, always use a name from
the **Product names** list at the end of this file. Do not invent codes or other names.

## Hugo shortcodes and includes

### Include files
```markdown
{{< include "nic/kubernetes-terminology.md" >}}
{{< include "waf/install-selinux-warning.md" >}}
```

- Only use includes for content appearing in 2 or more locations
- Do not include headings -- they won't appear in the TOC
- Do not nest includes unless unavoidable
- Keep include files context-agnostic and modular

### Call-outs
```markdown
{{< call-out class="note" title="Note" >}} Text here. {{< /call-out >}}
{{< call-out class="warning" title="Warning" >}} Text here. {{< /call-out >}}
{{< call-out class="caution" >}} Text here. {{< /call-out >}}
```

Refer to the admonitions topic in the style guide for when to use each type.

### Internal links
Always use the ref shortcode with absolute paths and file extensions:

```markdown
[link text]({{< ref "/nic/deploy/install.md" >}})
[section anchor]({{< ref "/integration/thing.md#section" >}})
```

Never use relative links or bare markdown links for internal content.

### Version shortcodes
```markdown
{{< nic-version >}}     # NGINX Ingress Controller version
{{< version-ngf >}}     # NGINX Gateway Fabric version
{{< version-waf >}}     # WAF version
```

## Git workflow

### Branch naming

```text
<product-code>/<descriptive-name>
docs/<descriptive-name>          # for repo or non-product changes

Examples:
  nic/update-helm-links
  ngf/add-tcp-routing-guide
  docs/improve-contributing-guide
```

Release branches: `<product>-release-<version>` (for example, `agent-release-2.2`)

### Commit messages (Conventional Commits)

```text
<type>: <subject line ~50 chars>

<body wrapped at 72 chars explaining what, why, how>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:

```text
feat: Add TLS passthrough guide for NGF

This commit adds a new how-to guide for configuring TLS passthrough
in NGINX Gateway Fabric. The guide covers:

- Prerequisites and Gateway API requirements
- Step-by-step configuration with examples
- Common troubleshooting scenarios

Relates to issue #1234
```

### Pre-commit hooks (optional)
```bash
pip install pre-commit
pre-commit install  # enables gitlint and markdownlint-cli2
```

## Linting

- `.markdownlint.yaml` -- Markdown rules (headings, spacing, alt text)
- `.pre-commit-config.yaml` -- Git hooks (gitlint, markdownlint-cli2)

Key markdownlint rules enforced:
- MD022/MD031/MD032: Blank lines around headings, code blocks, lists
- MD026: No trailing punctuation in headings
- MD045: All images must have alt text

## Testing

Playwright tests in `tests/`:

```bash
cd tests
npm install
npx playwright test
```

## Hugo module system

```bash
hugo mod get -u github.com/nginxinc/nginx-hugo-theme/v2  # Update theme
hugo mod tidy                                             # Clean dependencies
```

Permalinks for products are defined in `config/_default/config.toml`.

## Directory organization

- Product content: `content/<product>/<section>/<topic>.md`
- Sections use `_index.md` with `weight:` to control nav ordering (increments of 100)
- Landing pages use the `landing-page` archetype
- Static assets mirror content structure: `static/<product>/images/`

## Product names

- F5 NGINX Agent
- F5 NGINX Gateway Fabric
- F5 NGINX Ingress Controller
- F5 NGINX Instance Manager
- F5 WAF for NGINX
- F5 DoS for NGINX
- F5 NGINXaaS
- F5 NGINXaaS for Azure
- F5 NGINXaaS for Google Cloud
- F5 NGINX One Console
- F5 NGINX Plus

## Common pitfalls

- Never use relative links -- always use `{{< ref "absolute/path.md" >}}`
- Run `make hugo-update` before major work
- Don't create includes for single-use content
- Don't use product acronyms in user-facing text
- Don't commit directly to `main` -- always use feature branches
- Don't forget `weight:` values in front matter (causes unpredictable sorting)

## Key reference files

- `.style-guide/` -- F5 Technical Writing Style Guide (Git submodule)
- `documentation/hugo-content.md` -- Hugo content guidance
- `documentation/git-conventions.md` -- Git conventions
- `documentation/include-files.md` -- Include file guidance
- `CONTRIBUTING.md` -- Contributor guide