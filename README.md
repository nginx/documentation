# NGINX Docs

This repo contains all of the user documentation for NGINX's enterprise products, as well as the requirements for linting, building, and publishing the documentation.

Docs are written in Markdown. We build the docs using [Hugo](https://gohugo.io) and host them on [Netlify](https://www.netlify.com/).

## ✨ Getting Started

1. To install Hugo locally, refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/).

    > **NOTE**: We don't support Hugo versions newer than `v0.91`. 
    > This means you'll need to install Hugo by following the "Prebuilt binaries" instructions for your operating system.

2. We use `markdownlint` to check that Markdown files are correct. Use `npm` to install `markdownlint-cli`:

    ```bash
    npm install -g markdownlint-cli   
    ```

Refer to the [CONTRIBUTING](./CONTRIBUTING.md) doc to learn how to develop content in this repo.

---

## Publishing Environments

| Development | Staging | Production |
|--------|--------|--------|
| https://docs-dev.nginx.com | https://docs-staging.nginx.com | https://docs.nginx.com |
| All commits to the `dev` branch, feature branches, pull request deploy previews publish to the docs-dev site. <br>This site is primarily used for review of content under development. | All commits to `main` publish to the docs-staging environment automatically.<br>This is helpful for sharing staged content with stakeholders for signoff immediately prior to a release. | Content publishes to the production site once a day, via a GitHub Action. Members of the @nginxinc/nginx-docs team can manually trigger production deploys by running the GitHub Action or via Netlify Admin console. |

> NOTE: The dev and staging sites are password-protected; contact a member of the @nginxinc/nginx-docs team if you need access.

---

## Git Guidelines

- Keep a clean, concise and meaningful git commit history on your branch (within reason), rebasing locally and squashing before submitting a PR.
- If possible and/or relevant, use the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format when writing a commit message, so that changelogs can be automatically generated
- Follow the guidelines of writing a good commit message as described here <https://chris.beams.io/posts/git-commit/> and summarised in the next few points:
  - In the subject line, use the present tense ("Add feature" not "Added feature").
  - In the subject line, use the imperative mood ("Move cursor to..." not "Moves cursor to...").
  - Limit the subject line to 72 characters or less.
  - Reference issues and pull requests liberally after the subject line.
  - Add more detailed description in the body of the git message (`git commit -a` to give you more space and time in your text editor to write a good message instead of `git commit -am`).

### Pull Requests

- Fork the repo, create a branch, implement your changes, add any relevant tests, and submit a PR when your changes are **tested** and ready for review.
- Fill in [our pull request template](https://github.com/nginxinc/docs/blob/main/.github/pull_request_template.md).

> Note: if you'd like to request or contribute new content, please consider creating a [feature request issue](https://github.com/nginxinc/docs/blob/main/.github/feature_request_template.md) first to start a discussion about the proposed content.

## Release Management and Publishing

**`Main`** is the default branch in this repo. Main should always be releaseable. 
**Do not merge any content into main that is not approved for release.**

If you are working on content that isn't for a specific release (i.e., it can be published upon completion), open your pull request into the `main` branch. 

### Prepare Content for Future Releases

If you are working on content for a future release, create a release branch from `main` that uses the naming format *acronym-release-x.y.x* (for example, `adm-release-4.0.0`). Work on your docs in feature branches off of the release branch. Open pull requests into the release branch when you are ready to merge your work.

## 📨 Feature Requests, Support and Issue Reporting

### Report a Bug

To report a bug, open an issue on GitHub with the label `bug` using the available bug report issue template. Please ensure the bug has not already been reported. **If the bug is a potential security vulnerability, please report it using our [security policy](https://github.com/nginxinc/docs/blob/main/SECURITY.md).**

### Suggest a Feature or Enhancement

To suggest a feature or enhancement, please create an issue on GitHub with the label `enhancement` using the available [feature request template](https://github.com/nginxinc/docs/blob/main/.github/feature_request_template.md). Please ensure the feature or enhancement has not already been suggested.

