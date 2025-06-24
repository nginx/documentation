# Managing content with Hugo

This page describes our guidelines on using [Hugo](https://gohugo.io/) to write documentation.

You will need [git](https://git-scm.com/) to interact with the repository and files: the content itself is written in Markdown.

Our workflow is to develop content locally, then submit a pull request once we've done our initial draft and editing passes.

For guidance around how to write content, please check [the style guide](/documentation/style-guide.md).

## Setup

You will need to install Hugo _or_ Docker to build and preview docs in your local development environment.

Read the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

If you have [Docker](https://www.docker.com/get-started/) installed, there are fallbacks for all requirements in the [Makefile](Makefile), meaning you don't need to install them.

- [Installing Hugo](https://gohugo.io/getting-started/installing/)
  - **NOTE**: We are currently running [Hugo v0.147.8](https://github.com/gohugoio/hugo/releases/tag/v0.147.8) in production.
- [Installing markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli?tab=readme-ov-file#installation)
- [Installing markdown-link-check](https://github.com/tcort/markdown-link-check?tab=readme-ov-file#installation)

The configuration files are as follows:

- *Hugo*: `config/default/config.toml`
- *markdownlint-cli*: `.markdownlint.json`
- *markdown-link-check* `md-linkcheck-config.json`

## Develop documentation locally

To build the documentation website locally, use the `make` command in the documentation folder. 

First ensure you have the latest version of the Hugo theme with:

`make hugo-update`

Once you've updated the theme, you can use these targets:

| Target              | Description                                                                 |
| ------------------- | --------------------------------------------------------------------------- |
| _make watch_        | Runs a local Hugo server, allowing for changes to be previewed in a browser. |
| _make drafts_       | Runs a local Hugo server, rendering documents marked with `draft: true` in their metadata.|
| _make docs_          | Builds the documentation in the local `public/` directory. |
| _make clean_         | Removes the local `public` directory |
| _make hugo-get_      | Updates the go module file with the latest version of the theme. |
| _make hugo-tidy_     | Removes unnecessary dependencies from the go module file. |
| _make hugo-update_   | Runs the hugo-get and hugo-tidy targets in sequence. |
| _make lint-markdown_ | Runs [markdownlint](https://github.com/DavidAnson/markdownlint) on the content folder. |
| _make link-check_    | Runs [markdown-link-check](https://github.com/tcort/markdown-link-check) on all Markdown files. |

## Add new documentation

We use [Hugo archetypes](https://gohugo.io/content-management/archetypes/) to provide structure for new documentation pages.

Archetypes are how Hugo represents templates for content.

These archetypes include inline advice on Markdown formatting and our most common style guide conventions.

To create a new page, run the following command:

`hugo new content <product/folder/filename.md>`

This new page will be created with the default how-to archetype. To use a specific archetype, add the `-k` parameter and its name, such as:

`hugo new content <product/folder/filename.md> -k <archetype>`

Our archetypes [currently include](/archetypes/) the following:

- `default` (How-to instructions, general use)
- `concept`(An explanation of one implementation detail and some use cases)
- `tutorial` (An in-depth set of how-to instructions, referencing concepts)

These archetypes are adapted from some existing [templates](/templates/): please [file an issue](https://github.com/nginx/documentation/issues/new?template=1-feature_request.md) if you would like a new archetype.

## How to format documentation

### Basic Markdown formatting

There are multiple ways to format text: for consistency and clarity, these are our conventions:

- Bold: Two asterisks on each side - `**Bolded text**`.
- Italic: One underscore on each side - `_Italicized text_`.
- Unordered lists: One dash - `- Unordered list item`.
- Ordered lists: The 1 character followed by a stop - `1. Ordered list item`.

> **Note**: The ordered notation automatically enumerates lists when built by Hugo.

### How to format internal links

Internal links should use the [ref](https://gohugo.io/methods/shortcode/ref/#article) shortcode with absolute paths that start with a forward slash (for clarity).

Although file extensions (such as `.md`) are optional for Hugo, we include them for clarity and ease when targeting page anchors.

Here are two examples:

```md
To install <software>, refer to the [installation instructions]({{< ref "/product/deploy/install.md" >}}).
To install <integation>, refer to the [integration instructions]({{< ref "/integration/thing.md#section" >}}).
```

### How to use Hugo shortcodes

[Hugo shortcodes](https://github.com/nginxinc/nginx-hugo-theme/tree/main/layouts/shortcodes) are used to format callouts, add images, and reuse content across different pages.

For example, to use the `note` callout:

```md
{{< note >}} Provide the text of the note here .{{< /note >}}
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

You can also create custom callouts using the `call-out` shortcode `{{< call-out "type position" "header" "font-awesome icon >}}`. For example:

```md
{{<call-out "important side-callout" "JWT file required for upgrade" "fa fa-exclamation-triangle">}}
```

By default, all custom callouts are displayed inline, unless you add `side-callout` which places the callout to the right of the content.

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

### Add code to documentation pages

For command, binary, and process names, we sparingly use pairs of backticks (\`\<some-name\>\`): `<some-name>`.

Larger blocks of multi-line code text such as configuration files can be wrapped in triple backticks, with a language as a parameter for highlighted formatting.

You can also use the `ghcode` shortcode to embed a single file directly from GitHub:

`{{< ghcode "<https://raw.githubusercontent.com/some-repository-file-link>" >}}`

An example of this can be seen in [/content/ngf/get-started.md](https://github.com/nginx/documentation/blob/af8a62b15f86a7b7be7944b7a79f44fd5e526c15/content/ngf/get-started.md?plain=1#L233C1-L233C128), which embeds a YAML file.


### Add images to documentation pages

Use the `img` shortcode to add images to documentation pages. It has the same parameters as the Hugo [figure shortcode](https://gohugo.io/content-management/shortcodes/#figure).

1. Add the image to the `/static/img` directory.
1. Add the `img` shortcode:
  - `{{< img src="<img-file.png>" alt="<Alternative text>">}}`
  - Do not include a forward slash at the beginning of the file path or it will [break the image](https://gohugo.io/functions/relurl/#input-begins-with-a-slash).

> **Important**: We have strict guidelines for using images. Review them in our [style guide](/templates/style-guide.md#guidelines-for-screenshots).


### How to use Hugo includes

Hugo includes are a custom shortcode that allows you to embed content stored in the [`/content/includes` directory](https://github.com/nginx/documentation/tree/main/content/includes).

It allows for content to be defined once and display in multiple places without duplication, creating consistency and simplifying the maintenance of items such as reference tables.

For example, the [`licensing-and-reporting/apply-jwt.md`](https://github.com/nginx/documentation/blob/main/content/includes/licensing-and-reporting/apply-jwt.md) file contains instructions for where to add a JWT license file to an NGINX instance.

To add it to a documentation page, use the path as a parameter for the `include` shortcode:

```md
{{< include "licensing-and-reporting/apply-jwt.md" >}}
```

This particular include file is used in the following pages:

- [About subscription licenses](https://github.com/nginx/documentation/blob/77939c1f9f41ae1984ddfc43c65c3b743836057a/content/solutions/about-subscription-licenses.md?plain=1#L54)
- [R33 pre-release guidance for automatic upgrades](https://github.com/nginx/documentation/blob/77939c1f9f41ae1984ddfc43c65c3b743836057a/content/solutions/r33-pre-release-guidance-for-automatic-upgrades.md?plain=1#L62)
- [Installing NGINX App Protect WAF](https://github.com/nginx/documentation/blob/77939c1f9f41ae1984ddfc43c65c3b743836057a/content/nap-waf/v5/admin-guide/install.md?plain=1#L132)

View the [Guidelines for includes](/templates/style-guide.md#guidelines-for-includes) for instructions on how to write effective include files.

## Linting

To use markdownlint to check content, run the following command:

```shell
markdownlint -c .markdownlint.yaml </content/path>
```

The content path can be an individual file or a folder.
