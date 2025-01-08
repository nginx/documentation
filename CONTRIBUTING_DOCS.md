# Contributing guidelines for writers

If you want to contribute to our content, know Git, and can work from the command line, this page can help you. As noted in the [README](./README.md), we create source content for our documentation in Markdown.

Once you add and/or edit our Markdown source files, you can build the content locally as described on this page.
Before you [Submit a Pull Request](#submit-a-pull-request), we recommend that you first:

- Set up our [Static site generator](#setup)
  - This will help you [build docs on your local system](#local-docs-development)
- Learn about [Local docs development](#local-docs-development)

If you're an employee of F5/NGINX, also read [For F5/NGINX Employees](./F5-NGINX-team-notes.md).

## Setup

You will need to install Hugo _or_ Docker to build and preview docs in your local development environment.
Refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

**NOTE**: We are currently running [Hugo v0.134.2](https://github.com/gohugoio/hugo/releases/tag/v0.134.2) in production.


Although not a strict requirement, markdown-link-check is also used in documentation development.

If you have [Docker](https://www.docker.com/get-started/) installed, there are fallbacks for all requirements in the [Makefile](Makefile), meaning you don't need to install them.

- [Installing Hugo](https://gohugo.io/getting-started/installing/)
- [Installing markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli?tab=readme-ov-file#installation)
- [Installing markdown-link-check](https://github.com/tcort/markdown-link-check?tab=readme-ov-file#installation).

The configuration files are as follows:

- *Hugo*: `config/default/config.toml`
- *markdownlint-cli*: `.markdownlint.json`
- *markdown-link-check* `md-linkcheck-config.json`

## Local Docs Development

To build the documentation locally, use the `make` command in the documentation folder with these targets:

```text
make watch        - Runs a local Hugo server, allowing for changes to be previewed in a  browser.
make drafts        - Runs a local Hugo server similar to the `watch` target, but displays documents marked with `draft: true` in their metadata.
make docs          - Builds the documentation in the local `public/` directory.
make hugo-get      - Updates the go module file with the latest version of the theme.
make hugo-tidy     - Removes unnecessary dependencies from the go module file.
make hugo-update   - Runs the hugo-get and hugo-tidy targets in sequence.
make lint-markdown - Runs [markdownlint](https://github.com/DavidAnson/markdownlint) on the content folder.
make link-check    - Runs [markdown-link-check](https://github.com/tcort/markdown-link-check) on all Markdown files. Requires a running instance of Docker.
make clean         - Removes the local `public` directory, which is the default output path used by Hugo.
```

## Add new documentation

We provide template files for different types of documentation. The templates, including instructions to use them and examples, are located in the [templates](templates) directory.

We have templates for the following types of documentation:
- Concept
- Getting started
- How-to guide
- Installation guide
- Reference
- Release notes
- Tutorial

## How to format docs

### Basic markdown formatting

There are multiple ways to format text: for consistency and clarity, these are our conventions:

- Bold: Two asterisks on each side - `**Bolded text**`.
- Italic: One underscore on each side - `_Italicized text_`.
- Unordered lists: One dash - `- Unordered list item`.
- Ordered lists: The 1 character followed by a stop - `1. Ordered list item`.

> **Note**: The ordered notation automatically enumerates lists when built by Hugo.
Close every section with a horizontal line by using three dashes: `---`.

### How to format internal links

Internal links should use Hugo [ref and relref shortcodes](https://gohugo.io/content-management/cross-references/).

- Although file extensions are optional for Hugo, we include them as best practice for page anchors.
- Relative paths are preferred, but just the filename is permissible.
- Paths without a leading forward slash (`/`) are first resolved relative to the current page, then the remainder of the website.

Here are two examples:

```md
To install <software>, refer to the [installation instructions]({{< ref "install.md" >}}).
To install <integation>, refer to the [integration instructions]({{< relref "/integration/thing.md#section" >}}).
```

### How to add images

Use the `img` [shortcode](#using-hugo-shortcodes) to add images into your documentation.

1. Add the image to the `/static/img` directory.
1. Add the `img` shortcode:
    `{{< img src="<img-file.png>" alt="<Alternative text>">}}`
   - **Alt text is required, and must describe in detail the content of the image.**
   - **Do not include a forward slash at the beginning of the file path.**
   - This will break the image when it's rendered: read about the  [Hugo relURL Function](https://gohugo.io/functions/relurl/#input-begins-with-a-slash) to learn more.

> **Note**: The `img` shortcode accepts all of the same parameters as the Hugo [figure shortcode](https://gohugo.io/content-management/shortcodes/#figure).

> **Important**: We have strict guidelines regarding the use of images in our documentation. Make sure that you keep the number of images to a minimum and that they are relevant to the content. Review the guidelines in our [style guide](/templates/style-guide.md#guidelines-for-screenshots).

### How to use Hugo shortcodes

[Hugo shortcodes](https://github.com/nginxinc/nginx-hugo-theme/tree/main/layouts/shortcodes) are used to format callouts, add images, and reuse content across different pages.

For example, to use the `note` callout:

```md
{{< note >}}Provide the text of the note here.{{< /note >}}
```

The callout shortcodes support multi-line blocks:

```md
{{< caution >}}
You should probably never do this specific thing in a production environment.

If you do, and things break, don't say we didn't warn you.
{{< /caution >}}
```

Supported callouts:
- `note`
- `tip`
- `important`
- `caution`
- `warning`

You can also create custom callouts using the `call-out` shortcode `{{< call-out "type" "header" "font-awesome icon >}}`. For example:

```md
{{<call-out "important" "JWT file required for upgrade" "fa fa-exclamation-triangle">}}
```

Here are some other shortcodes:

- `fa`: Inserts a Font Awesome icon
- `collapse`: Make a section collapsible
- `tab`: Create mutually exclusive tabbed window panes, useful for parallel instructions
- `table`: Add scrollbars to wide tables for browsers with smaller viewports
- `link`: Link to a file, prepending its path with the Hugo baseUrl
- `openapi`: Loads an OpenAPI specification and render it as HTML using ReDoc
- `include`: Include the content of a file in another file; the included file must be present in the '/content/includes/' directory
- `raw-html`: Include a block of raw HTML
- `readfile`: Include the content of another file in the current file, which can be in an arbitrary location.
- `bootstrap-table`: formats a table using Bootstrap classes; accepts any bootstrap table classes as additional arguments, e.g. `{{< bootstrap-table "table-bordered table-hover" }}`

## Linting

To run the markdownlint check, run the following command, which uses the .markdownlint.yaml file to specify rules. For `<content>`, specify the path to your Markdown files:

```bash
markdownlint -c .markdownlint.yaml <content>
```

> Note: You can run this tool on an entire directory or on an individual file.
