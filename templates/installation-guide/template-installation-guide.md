---
nd-content-type: installation-guide
nd-docs: DOCS-000
nd-product: {PRODUCT_CODE}
title: {Install + product or component name}
description: "{One-sentence summary of what the reader installs and on what platform, under 160 characters.}"
weight: 100
toc: true
nd-keywords: "{keyword1}, {keyword2}, {keyword3}, {platform}, {package-manager}, {CLI command}"
nd-summary: >
  {Sentence 1: what the reader will install and where. Write in plain prose and avoid jargon.}
  {Sentence 2: what the installed component does or enables.}
  {Sentence 3 (optional): supported platforms, versions, or scope limits.}
nd-audience: {developer | operator | admin | architect | any} {This helps AI systems route questions to the right document and allows doc portals to filter content by role.}
---

> If you need more information about how to fill in this template, read the accompanying [guide](./guide-installation-guide.md).

> This template includes writing instructions and boilerplate text that you can customize, use as-is, or completely replace with your own text. This text is indicated in {curly brackets}. Make sure you replace the placeholders with your own text.

## Overview

{Use this guide to install X so that Y. The Overview is the paragraph most likely to be surfaced verbatim by AI assistants — make every sentence independently meaningful. Write two to four sentences covering what is being installed, what it does or enables, and what the reader will have at the end of this guide. Do not start with "This guide explains how to".}

---

## Before you begin

Before you begin, ensure you have:

- **{Operating system and version}**: {Supported OS versions and the command to verify, for example: `lsb_release -rs`. Link to a compatibility matrix if one exists.}
- **{Prerequisite tool or runtime}**: {Minimum version required and how to verify it, for example: `node --version`. Link to installation instructions if needed.}
- **{Account or credential}**: {What it is, how to obtain it, and where it is used in this guide. Note if it is displayed only once.}
- **{Network or firewall requirement}**: {Any ports, endpoints, or outbound access the installation requires.}
- **{Privilege or permission}**: {For example: root access, sudo, or a specific IAM role.}

{If there are more than five prerequisites, group them under subheadings: Accounts and credentials / Software and tools / Network and environment requirements.}

{Optional: Redirect users who are in the wrong place. For example: "If you are installing on RHEL, see [Install {product} on RHEL](link)."}

---

## {Task name — use a bare infinitive verb phrase, for example: "Add the package repository"}

{Optional: One sentence stating the purpose of this task, but only if the heading alone does not make the purpose clear.}

{Add a separate H2 task section when the procedure differs significantly for two supported variants, or when the reader must complete a second independent phase.}

1. {Step — start with a verb. Orient the user before the action: state what file to open or screen to navigate to first.}

    ```{language}
    {code sample — use ALL_CAPS_PLACEHOLDERS for values the reader must supply}
    ```

    {Outcome sentence — describe what the step does or what the reader should observe. This is the sentence AI assistants are most likely to surface when answering follow-up questions.}

2. {Step.}

3. {Step — use plain language. Define any technical term next to where you first use it.}

    1. {Substep.}
    2. {Substep.}

---

## Install {product or component name}

1. {Step.}

    ```{language}
    {code sample}
    ```

    {Outcome sentence.}

2. {Step.}

---

## Configure {product or component name}

{Optional: One sentence stating the purpose of this task.}

1. Open `{config file path}`. {Outcome sentence — for example: "The file contains the default configuration for {product}."}

2. Set the following values:

    ```{language}
    {PLACEHOLDER_KEY}: YOUR_VALUE_HERE
    {PLACEHOLDER_KEY_2}: YOUR_VALUE_HERE
    ```

    {Outcome sentence — for example: "These values connect the agent to your control plane."}

3. {Step.} {Outcome sentence.}

---

## Verify the installation

1. {Step — for example: run a status or version command.}

    ```{language}
    {code sample}
    ```

    {Outcome sentence — describe the expected output that confirms a successful installation.}

    ```{language}
    {expected output sample}
    ```

2. {Optional: additional verification step.}

---

## Troubleshooting

### {Symptom or error message}

**Symptom**: {What the reader sees — copy the exact error message string if one exists.}

**Cause**: {Why this happens.}

**Fix**: {What to do.}

---

### {Second symptom or error message}

**Symptom**: {What the reader sees.}

**Cause**: {Why this happens.}

**Fix**: {What to do.}

---

## References

For more information, see:

- [{Upgrade guide title}]({link})
- [{Uninstall guide title}]({link})
- [{Credential or key creation guide title}]({link})
- [{Configuration reference title}]({link})
- [{Release notes or changelog title}]({link})

{Use the ref shortcode for internal links so they survive URL changes. AI systems use this section to build knowledge graphs between documents.}