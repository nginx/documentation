# Contributing Guidelines

The following is a set of guidelines for contributing to this project. We really appreciate that you are considering contributing!

## ✨ Getting Started

You will need to install Hugo to build and preview docs in your local development environment. 
Refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

**NOTE**: We are currently running [Hugo v0.134.2](https://github.com/gohugoio/hugo/releases/tag/v0.134.2) in production.

## Local Docs Development

To build the docs locally, run the desired `make` command from the docs directory:

```text
make docs           -   runs a local hugo server so you can view docs in your browser while you work
make hugo-mod       -   cleans the Hugo module cache and fetches the latest version of the theme module
make docs-drafts    -   runs the local hugo server and includes all docs marked with `draft: true`
make clean          -   removes the local `public` directory, which is the default output path used by Hugo
```

## Add new docs

### Generate a new doc file using Hugo

To create a new doc file that contains all of the pre-configured Hugo front-matter and the docs task template, run the following command:

`hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>`

e.g.,

`hugo new getting-started/install.md`

The default template -- task -- should be used for most docs. To create docs using the other content templates, you can use the `--kind` flag:

`hugo new tutorials/deploy.md --kind tutorial`

The available content types (`kind`) are:

- concept: Helps a customer learn about a specific feature or feature set.
- tutorial: Walks a customer through an example use case scenario; results in a functional PoC environment.
- reference: Describes an API, command line tool, config options, etc.; should be generated automatically from source code. 
- troubleshooting: Helps a customer solve a specific problem.
- openapi: Contains front-matter and shortcode for rendering an openapi.yaml spec.

## How to format docs

### How to format internal links

Format links as [Hugo refs](https://gohugo.io/content-management/cross-references/). 

- File extensions are optional.
- You can use relative paths or just the filename. (**Paths without a leading / are first resolved relative to the current page, then to the remainder of the site.**)
- Anchors are supported.

For example:

```md
To install <product>, refer to the [installation instructions]({{< ref "install" >}}).
```

### How to use Hugo shortcodes

You can use [Hugo shortcodes](/docs/themes/f5-hugo/layouts/shortcodes/) to do things like format callouts, add images, and reuse content across different docs. 

For example, to use the note callout:

```md
{{< note >}}Provide the text of the note here. {{< /note >}}
```

The callout shortcodes also support multi-line blocks:

```md
{{< caution >}}
You should probably never do this specific thing in a production environment. 

If you do, and things break, don't say we didn't warn you.
{{< /caution >}}
```

Supported callouts:

- `caution`
- `important`
- `note`
- `see-also`
- `tip`
- `warning`

A few more fun shortcodes:

- `fa`: inserts a Font Awesome icon
- `img`: include an image and define things like alt text and dimensions
- `include`: include the content of a file in another file (requires the included file to be in the content/includes directory; will be deprecated in favor of readfile)
- `link`: makes it possible to link to a file and prepend the path with the Hugo baseUrl
- `openapi`: loads an OpenAPI spec and renders as HTML using ReDoc
- `raw-html`: makes it possible to include a block of raw HTML
- `readfile`: includes the content of another file in the current file (intended to replace `include`)
- `bootstrap-table`: formats a table using Bootstrap classes; accepts any bootstrap table classes as additional arguments, e.g. `{{< bootstrap-table "table-bordered table-hover" }}`

## Linting

To run the markdownlint check, run the following command from the docs directory:

  ```bash
  markdownlint -c docs/mdlint_conf.json content
  ```

> Note: You can run this tool on an entire directory or on an individual file.
