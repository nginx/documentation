# Managing content with Hugo

This page describes our guidelines on using [Hugo](https://gohugo.io/) to write documentation.

You will need [git](https://git-scm.com/) to interact with the repository and files: the content itself is written in Markdown.

Our workflow is to develop content locally, then [submit a pull request](/documentation/git-conventions.md) once we've done our initial draft and editing passes.

For guidance around how to write content, please check [the style guide](/documentation/style-guide.md).

## Setup

You will need to install Hugo _or_ Docker to build or preview documentation in your local development environment.

Read the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information: we are currently running [Hugo v0.147.8](https://github.com/gohugoio/hugo/releases/tag/v0.147.8) in production.

If you have [Docker](https://www.docker.com/get-started/) installed, there are fallbacks for all requirements in the [Makefile](Makefile), meaning you don't need to install them.

## Build the documentation locally

To build the website locally, first ensure you have the latest version of the Hugo theme with:

`make hugo-update`

You can then use the other `make` commands: *watch* is most commmon when working on documentation.

| Target              | Description                                                                 |
| ------------------- | --------------------------------------------------------------------------- |
| _make watch_        | Runs a local Hugo server, allowing for changes to be previewed in a browser. |
| _make drafts_       | Runs a local Hugo server, rendering documents marked with `draft: true` in their metadata.|
| _make docs_         | Builds the documentation in the local `public/` directory. |
| _make clean_        | Removes the local `public` directory |
| _make hugo-get_     | Updates the go module file with the latest version of the theme. |
| _make hugo-tidy_    | Removes unnecessary dependencies from the go module file. |
| _make hugo-update_  | Runs the hugo-get and hugo-tidy targets in sequence. |

## Add new documentation

We use [Hugo archetypes](https://gohugo.io/content-management/archetypes/) to provide structure for new documentation pages.

Archetypes are how Hugo represents templates for content.

These archetypes include inline advice on Markdown formatting and our most common style guide conventions.

To create a new page, run the following command:

`hugo new content <product/folder/filename.md>`

This new page will be created with the default how-to archetype. To use a specific archetype, add the `-k` parameter and its name, such as:

`hugo new content <product/folder/filename.md> -k <archetype>`

Our archetypes [currently include](/archetypes/) the following:

- `default` - How-to instructions, general use
- `concept` - An explanation of one implementation detail and some use cases
- `tutorial` - An in-depth set of how-to instructions, referencing concepts
- `landing-page` - A special archetype for the landing page of a documentation set, with a unique layout

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

[Hugo shortcodes](https://github.com/nginxinc/nginx-hugo-theme/tree/main/layouts/shortcodes) are used to provide extra functionality and special formatting to Markdown content.

This is an example of a call-out shortcode:

```md
{{< call-out "note" >}} Provide the text of the note here .{{< /call-out >}}
```

Here are some other shortcodes:

- `include`: Include the content of a file in another file: read the [Using include files](/documentation/include-files.md) topic
- `tabs`: Create mutually exclusive tabbed window panes, useful for parallel instructions
- `table`: Add scrollbars to wide tables for browsers with smaller viewports
- `icon`: Add a [Lucide icon](https://lucide.dev/icons/) by using its name as a parameter
- `link`: Link to a file, prepending its path with the Hugo baseUrl
- `ghcode`: Embeds the contents of a code file: read the [Add code to documentation pages](#add-code-to-documentation-pages) instructions
- `openapi`: Loads an OpenAPI specification and render it as HTML using ReDoc

#### Add call-outs to documentation pages

The call out shortcode support multi-line blocks:

```md
{{< call-out "caution" >}}
You should probably never do this specific thing in a production environment.

If you do, and things break, don't say we didn't warn you.
{{< /call-out >}}
```

The first parameter determines the type of call-out, which defines the colour given to it.

Supported types:

- `note`
- `tip`
- `important`
- `caution`
- `warning`

An optional second parameter will add a title to the call-out: without it, it will fall back to the type.

```md
{{< call-out "important" "This instruction only applies to v#.#.#" >}}
These instructions are only intended for versions #.#.# onwards.

Follow <these-instructions> if you're using an older version.
{{< /call-out >}}
```

Finally, you can use an optional third parameter to add a [Lucide icon](https://lucide.dev/icons/) using its name.

#### Add code to documentation pages

For command, binary, and process names, we sparingly use pairs of backticks (\`\<some-name\>\`): `<some-name>`.

Larger blocks of multi-line code text such as configuration files can be wrapped in triple backticks, with a language as a parameter for highlighted formatting.

You can also use the `ghcode` shortcode to embed a single file directly from GitHub:

`{{< ghcode "<https://raw.githubusercontent.com/some-repository-file-link>" >}}`

An example of this can be seen in [/content/ngf/get-started.md](https://github.com/nginx/documentation/blob/af8a62b15f86a7b7be7944b7a79f44fd5e526c15/content/ngf/get-started.md?plain=1#L233C1-L233C128), which embeds a YAML file.

#### Add images to documentation pages

> [!IMPORTANT]
> We have strict guidelines for using images. Review them in our [style guide](/documentation/style-guide.md#guidelines-for-screenshots).

Use the `img` shortcode to add images to documentation pages. It has the same parameters as the Hugo [figure shortcode](https://gohugo.io/content-management/shortcodes/#figure).

1. Add the image to the `/static/img` directory.
2. Add the `img` shortcode: `{{< img src="<img-file.png>" alt="<Alternative text>">}}`

Do not include a forward slash at the beginning of the file path or it will [break the image](https://gohugo.io/functions/relurl/#input-begins-with-a-slash).
