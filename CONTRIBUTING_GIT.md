If you want to contribute, know Git, and can work from the command line, this page can help you. As noted in the [README](./README.md), we create source content for our documentation in Markdown.

Once you add and/or edit our Markdown source files, you can build the content locally as described on this page.
Before you [Submit a Pull Request](#submit-a-pull-request), we recommend that you first:

- Set up our [Static site generator](#static-site-generator)
- Review how to [Include images](#include-images)
- Review our [Git style guide](#git-style-guide)
- Learn how to [Build documentation locally](#build-documentation-locally)

## Static Site Generator

You will need to install Hugo to build and preview docs in your local development environment.
Refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

**NOTE**: We are currently running [Hugo v0.134.2](https://github.com/gohugoio/hugo/releases/tag/v0.134.2) in production.

## Include images

When you set up an image, this is the standard format:

{{< img src="path/to/images/file-name.png" alt="descriptive text for screenreaders" >}}

## Build documentation locally

To build and preview docs in your local development environment, you need to install Hugo.
Refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

**NOTE**: We are currently running [Hugo v0.115.3](https://github.com/gohugoio/hugo/releases/tag/v0.115.3) in production. If you run a different version of Hugo (older or newer), you might see unexpected errors.

## Submit a Pull Request

Follow this plan to contribute a change to NGINX source code:

- Fork the NGINX repository
- Create a branch
- Implement your changes in this branch
- Submit a pull request (PR) when your changes are tested and ready for review

### Git Style Guide

- Keep a clean, concise and meaningful git commit history on your branch, rebasing locally and squashing before
  submitting a PR
- Follow the guidelines of writing a good commit message as described here <https://chris.beams.io/posts/git-commit/>
  and summarized in the next few points:

  - In the subject line, use the present tense ("Add feature" not "Added feature")
  - In the subject line, use the imperative mood ("Move cursor to..." not "Moves cursor to...")
  - Limit the subject line to 72 characters or less
  - Reference issues and pull requests liberally after the subject line
  - Add more detailed description in the body of the git message (`git commit -a` to give you more space and time in
    your text editor to write a good message instead of `git commit -am`)

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
