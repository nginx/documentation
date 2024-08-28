If you want to contribute, know Git, and can work from the command line, this page can help you. As noted in the [README](./README.md), we create source content for our documentation in Markdown.

Once you add and/or edit our Markdown source files, you can build the content locally as described on this page.

## Static Site Generator (Hugo)

We build our documentation with the [Hugo](https://gohugo.io/) static site generator. 

## Images

When you set up an image, this is the standard format:

{{< img src="path/to/images/file-name.png" alt="descriptive text for screenreaders" >}}

## Build documentation locally

To build and preview docs in your local development environment, you need to install Hugo.
Refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

**NOTE**: We are currently running [Hugo v0.115.3](https://github.com/gohugoio/hugo/releases/tag/v0.115.3) in production. If you run a different version of Hugo (older or newer), you might see unexpected errors.

### Local docs development

To build the docs locally, run the desired `make` command from the docs directory:

```text
make docs           -   runs a local Hugo server so you can view docs in your browser while you work
make hugo-mod       -   cleans the Hugo module cache and fetches the latest version of the theme module
make docs-drafts    -   runs the local Hugo server and includes all docs marked with `draft: true`
make clean          -   removes the local `public` directory, which is the default output path used by Hugo
```

### Add new docs
<!--
#### Generate a new doc file using Hugo

To create a new doc file that contains all of the pre-configured Hugo front-matter and the docs task template, run the following command:

`hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>`

For example:

`hugo new getting-started/install.md`

The default template -- task -- should be used for most docs. To create docs using the other content templates, you can use the `--kind` flag:

`hugo new tutorials/deploy.md --kind tutorial` -->

Consistent with the [Diataxis](https://diataxis.fr) framework, our documentation includes the following content types:

- concept: Helps a customer learn about a specific feature or feature set.
- tutorial: Walks a customer through an example use case scenario; results in a functional PoC environment.
- reference: Describes an API, command line tool, config options, etc.; should be generated automatically from source code. 
- openapi: Contains front-matter and shortcode for rendering an openapi.yaml spec.

### How to format docs

#### How to format internal links

Format links as [Hugo `refs`](https://gohugo.io/content-management/cross-references/). 

- File extensions are optional.
