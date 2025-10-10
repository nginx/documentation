# Using Include files

_Include files_, often referred to as _includes_, are Markdown files with self-contained text fragments used by Hugo for content re-use.

They enable contributors to maintain a single source of truth for information that is often repeated, such as how to download credential files.

We use them to [avoid repeating ourselves](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), and create consistency in similar instructional steps.

Include files are designed to be context-agnostic and should not rely on or assume any prior content.

The files are located in the [content/includes](https://github.com/nginxinc/docs/tree/main/content/includes) folder, and are implemented using the Hugo `include` shortcode:

```text
{{< include "use-cases/docker-registry-instructions.md" >}}
```

Putting the previous example in any Markdown file would embed the contents of `content/includes/use-cases/docker-registry-instructions.md` wherever the shortcode was used.

For guidance on other Hugo shortcodes, read the [Managing content with Hugo](/documentation/hugo-content.md) document.

## Guidelines for include files

To make sure includes are effective and easy to maintain, follow these guidelines:

- **Only use includes for repeated content**: Create an include only if the content appears in at least **two locations**. Using an include for single-use content adds unnecessary complexity and makes maintenance harder.
- **Keep includes small and modular**: Write narrowly scoped snippets to maximize flexibility and reuse.
- **Avoid nesting includes**: If there’s another way to achieve the same outcome, avoid nesting includes. While possible, it complicates reviews and maintenance. A flat structure is simple.
- **Don't include headings**: Do not include headings in include files. These headings won't appear in a document's table of contents and may break the linear flow of the surrounding content. Add headings directly to the document instead.
- **Don't start documents with includes**: The opening of most documents is the introduction which explains its purpose. Includes are reused text, so starting multiple documents with identical content could look odd, especially in search results.
- **Do not add the F5 prefix to product names in includes**: The brand name is required only on [the first mention in a document](/documentation/style-guide.md#f5-brand-trademarks-and-product-names).

## Include file index

To aid in discoverability of include files, this index is maintained to offer contributors a reference for existing entries.

When viewing an include file, you may also see the `files`: parameter in the frontmatter, which shows where the file is currently in use.

| **_File name_** | **_Description_** |
| ----------------| ------------------ |
| [_licensing-and-reporting/download-jwt-from-myf5.md_](/content/includes/licensing-and-reporting/download-jwt-from-myf5.md) | Instructions for downloading a JSON Web Token from MyF5 |
| [_licensing-and-reporting/download-certificates-from-myf5.md_](/content/includes/licensing-and-reporting/download-certificates-from-myf5.md) | Instructions for downloading certificate files from MyF5 |
| [_use-cases/credential-download-instructions.md_](/content/includes/use-cases/credential-download-instructions.md) | Parallel tabbed instructions for downloading credential files from MyF5 |
| [_use-cases/docker-registry-instructions.md_](/content/includes/use-cases/docker-registry-instructions.md) | Parallel tabbed instructions for listing Docker images from the F5 Registry |