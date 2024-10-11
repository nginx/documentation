# Contributing guidelines for experts

If you want to contribute, know Git, and can work from the command line, this page can help you. As noted in the [README](./README.md), we create source content for our documentation in Markdown.

Once you add and/or edit our Markdown source files, you can build the content locally as described on this page.
Before you [Submit a Pull Request](#submit-a-pull-request), we recommend that you first:

- Set up our [Static site generator](#static-site-generator)
- If you want to add images, review how to [Include images](#include-images)
- Learn how to [Build documentation locally](#build-documentation-locally)

## Static site generator

You will need to install Hugo to build and preview docs in your local development environment.
Refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

**NOTE**: We are currently running [Hugo v0.134.2](https://github.com/gohugoio/hugo/releases/tag/v0.134.2) in production.

## Include images

When you set up an image, this is the standard format:

{{< img src="path/to/images/file-name.png" alt="descriptive text for screenreaders" >}}

You'll find images in the [static](../static) subdirectory, in a directory associated with the documentation. For example, if you've set up the `file-name.png`
image, you should copy that file to the `static/path/to/images` directory.

## Build documentation locally

To build and preview docs in your local development environment, you need to install Hugo.
Refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

## Submit a Pull Request

Follow this plan to contribute a change to NGINX source code:

- Fork the NGINX repository
- Create a branch
- Implement your changes in this branch
- Submit a pull request (PR) when your changes are tested and ready for review

### Add new docs

Consistent with the [Diataxis](https://diataxis.fr) framework, our documentation includes the following content types:

- concept: Helps a customer learn about a specific feature or feature set.
- tutorial: Walks a customer through an example use case scenario; results in a functional PoC environment.
- reference: Describes an API, command line tool, config options, etc.; should be generated automatically from source code. 
- openapi: Contains front-matter and shortcode for rendering an openapi.yaml spec.
