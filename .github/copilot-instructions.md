# NGINX Documentation Copilot Instructions

## Project Overview

This is a Hugo-based documentation site for F5 NGINX products (NGINX Plus, NGINX Ingress Controller, NGINX Gateway Fabric, WAF, Instance Manager, etc.). Content is written in Markdown with Hugo shortcodes, transformed to HTML via Hugo v0.152.2, and uses the custom theme `github.com/nginxinc/nginx-hugo-theme/v2`.

## Essential Build & Dev Commands

```bash
# Update Hugo theme before starting work
make hugo-update

# Local development server (most common)
make watch  # http://localhost:1313

# Include draft content
make drafts

# Build for production
make docs  # outputs to public/

# Linting
make lint-markdown       # markdownlint-cli2
make link-check          # markdown-link-check
```

## Content Structure

- **`content/`**: Product documentation organized by product code (`nic/`, `ngf/`, `waf/`, `nim/`, `agent/`, etc.)
- **`content/includes/`**: Reusable content fragments for DRY principle (e.g., `content/includes/waf/terminology.md`)
- **`archetypes/`**: Hugo templates for new pages (`default.md`, `concept.md`, `tutorial.md`, `landing-page.md`)
- **`layouts/shortcodes/`**: Custom Hugo shortcodes for product versions and special formatting
- **`static/`**: Static assets (images, scripts) organized by product
- **`documentation/`**: Internal process docs and style guides

## Creating New Content

Use Hugo archetypes to scaffold new documentation:

```bash
# Default how-to guide
hugo new content nic/how-to/configure-ssl.md

# Specific archetype
hugo new content ngf/concepts/routing.md -k concept
```

Front matter structure (from archetypes):
```yaml
title: "Page Title"           # Sentence case, present imperative
weight: 100                    # Controls sort order, increments of 100
toc: false                     # Enable for large documents
nd-content-type: how-to        # how-to | concept | tutorial | reference
nd-product: INGRESS           # INGRESS, FABRIC, NIMNGR, F5WAFN, etc.
```

## Quality Checklist
Before delivering rewritten content, verify:
- [ ] Reading level is 8th-9th grade (use simple words, short sentences)
- [ ] All F5 product names follow brand guidelines
- [ ] Procedures use imperative verbs and numbered steps
- [ ] No forbidden terms (abort, execute, kill, etc.)
- [ ] Active voice throughout
- [ ] Cultural neutrality maintained
- [ ] Technical accuracy preserved
- [ ] User-focused perspective maintained
- [ ] All links use `{{< ref >}}` shortcode with absolute paths
- [ ] All images have alt text and follow formatting standards
- [ ] No nested includes and all includes are context-agnostic
- [ ] Front matter is complete and follows archetype structure

## Hugo Shortcodes & Includes

### Include Files (DRY Content)
```markdown
{{< include "nic/kubernetes-terminology.md" >}}
{{< include "waf/install-selinux-warning.md" >}}
```

- **Only** use includes for content appearing in **2+ locations**
- Do **not** include headings (they won't appear in TOC)
- Do **not** nest includes unless unavoidable
- Keep include files context-agnostic and modular

### Call-outs
```markdown
{{< call-out "note" >}} Important information here. {{< /call-out >}}
{{< call-out "warning" >}} Critical warning here. {{< /call-out >}}
{{< call-out "caution" >}} Potential damage/downtime. {{< /call-out >}}
```

### Internal Links
Always use `ref` shortcode with **absolute paths** and **file extensions**:
```markdown
[installation instructions]({{< ref "/nic/deploy/install.md" >}})
[section anchor]({{< ref "/integration/thing.md#section" >}})
```

### Version Shortcodes
Product version shortcodes are in `layouts/shortcodes/`:
```markdown
{{< nic-version >}}               # NGINX Ingress Controller version
{{< version-ngf >}}               # NGINX Gateway Fabric version
{{< version-waf >}}               # WAF version
```

## Writing Style & Conventions

### Content Structure Requirements
1. **Lead with the answer** - Put essential information first
2. **Use clear headings** - Help users scan quickly
3. **Provide context** - Explain why they're doing something
4. **Be specific** - Include exact UI labels, commands, file paths
5. **Test your instructions** - Ensure they're followable

### Target Audience
- **Global audience** - Many users may not speak English as their first language
- **Technical professionals** - Developers, system administrators, product managers, customer success managers
- **Reading level** - Write for 8th-9th grade comprehension
- **Context** - Users need actionable information to complete technical tasks

### Core Writing Principles (from F5 Modern Voice)
1. **Focus on the customer question** - Understand what they're trying to accomplish
2. **Give concise answers** - Provide the 80% case first, essential information only
3. **Make it scannable** - Use lists, headers, and clear structure
4. **Use normal, relaxed words** - Professional but conversational tone
5. **Empathize** - Acknowledge complexity, never imply user error

## Key Rewriting Standards

### Voice and Tone
- Use active voice over passive voice
- Write in second person (you, your) from user's perspective  
- Use present tense: "The system receives" not "The system will receive"
- Be conversational but professional
- Use contractions when they improve readability

### Sentence Structure
- Maximum 20 words for task-oriented sentences
- Maximum 25 words for conceptual sentences
- Maximum 6 sentences per paragraph
- Start with action words for procedures
- Use imperative mood: "Select the option" not "You should select"

### Word Choice - Always Use These Replacements
| Use | Instead of |
|-----|-----------|
| allow list, denylist | whitelist, blacklist |
| primary, secondary | master, slave |
| start, restart | boot, reboot |
| select | click |
| go to | navigate to |
| because | as (for cause-and-effect) |
| set up | configure (except for F5 product configuration) |

### Brand & Product Names
- **First mention** in document: Full name with F5 (e.g., "F5 NGINX Plus", "F5 NGINX Instance Manager")
- **Subsequent mentions**: Drop F5, keep NGINX (e.g., "NGINX Plus", "NGINX Instance Manager")
- **Never** use acronyms for product names (no "NIC", "NGF", etc.)
- **Open source products**: No F5 prefix (e.g., "NGINX Agent", "NGINX Unit")
- **No articles** before product names: "NGINX Agent" not "the NGINX Agent"
- **Titles/headings**: Omit F5 prefix

### Markdown Formatting
- **Bold**: `**Bolded text**` (two asterisks)
- **Italic**: `_Italicized text_` (one underscore)
- **Monospace**: `` `code` `` (use sparingly, avoid in tables)
- **Unordered lists**: `- List item` (one dash)
- **Ordered lists**: `1. Item` (auto-enumerates)
- **Always use Oxford comma**: "apples, oranges, and bananas"

### Tone & Language
- Present imperative for headings/titles
- Active voice from user perspective (avoid "allows you to")
- No anthropomorphism (avoid "decides", "knows", "sees")
- Use "select" for checkboxes/options, not "check"
- Use "because" not "as" for cause-effect
- Avoid colloquialisms ("press Esc" not "hit Esc")

### Global Audience Requirements
- Avoid idioms, cultural references, slang
- Use simple, common words over complex alternatives
- Be explicit rather than implicit
- Spell out acronyms on first use
- Use metric measurements with US equivalents when needed
- Avoid violent or militaristic language

### Formatting Standards
- Use sentence case for headings
- Bold UI elements exactly as they appear
- Use numbered lists for sequential steps
- Use bullet points for non-sequential items
- Use ">" for navigation paths: "Go to System > Configuration"


## Git Workflow

### Branch Naming
```
<product-code>/<descriptive-name>
docs/<descriptive-name>          # for repo/non-product changes

Examples:
  nic/update-helm-links
  ngf/add-tcp-routing-guide
  docs/improve-contributing-guide
```

Release branches: `<product>-release-<version>` (e.g., `agent-release-2.2`)

### Commit Messages (Conventional Commits)
```
<type>: <subject line ~50 chars>

<body wrapped at 72 chars explaining what, why, how>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat: Add TLS passthrough guide for NGF

This commit adds a new how-to guide for configuring TLS passthrough
in NGINX Gateway Fabric. The guide covers:

- Prerequisites and Gateway API requirements
- Step-by-step configuration with examples
- Common troubleshooting scenarios

Relates to issue #1234
```

### Pre-commit Hooks (Optional)
```bash
pip install pre-commit
pre-commit install  # enables gitlint & markdownlint-cli2
```

## Linting & Quality

Linting config:
- **`.markdownlint.yaml`**: Markdown rules (headings, spacing, alt text)
- **`.pre-commit-config.yaml`**: Git hooks (gitlint, markdownlint-cli2)

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

Tests verify UI components (e.g., N4A calculator) and page rendering.

## Hugo Module System

Hugo theme is managed as a Go module:
```bash
hugo mod get -u github.com/nginxinc/nginx-hugo-theme/v2  # Update theme
hugo mod tidy                                             # Clean dependencies
```

Permalinks for products defined in `config/_default/config.toml` (e.g., `/nginx-ingress-controller/`, `/nginx-gateway-fabric/`).

## Directory Organization Patterns

- Product content follows pattern: `content/<product>/<section>/<topic>.md`
- Sections use `_index.md` with `weight:` to control nav ordering (increments of 100)
- Landing pages use `landing-page` archetype with unique layout
- Static assets mirror content structure: `static/<product>/images/`

## Common Pitfalls

1. **Don't** use relative links; always use `{{< ref "absolute/path.md" >}}`
2. **Don't** forget to run `make hugo-update` before major work
3. **Don't** create includes for single-use content
4. **Don't** use product acronyms in user-facing text
5. **Don't** commit directly to `main`; always use feature branches
6. **Don't** forget weight values in front matter (causes unpredictable sorting)

## Key Reference Files

- Style guide: [documentation/style-guide.md](documentation/style-guide.md) (543 lines, comprehensive)
- Hugo content: [documentation/hugo-content.md](documentation/hugo-content.md)
- Git conventions: [documentation/git-conventions.md](documentation/git-conventions.md)
- Include files: [documentation/include-files.md](documentation/include-files.md)
- Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)

## Product Codes (for branches & metadata)

- NAGENT: NGINX Agent
- FABRIC: NGINX Gateway Fabric
- INGRESS: NGINX Ingress Controller
- NIMNGR: NGINX Instance Manager
- F5WAFN: F5 WAF for NGINX
- F5DOSN: F5 DoS Protection for NGINX
- NAZURE: NGINXaaS for Azure
- NGOOGL: NGINXaaS for Google Cloud
- NONECO: NGINX One Console
- NGPLUS: NGINX Plus
