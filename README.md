# NGINX Docs

[![Check for Broken Links](https://github.com/nginxinc/docs/actions/workflows/check-broken-links.yml/badge.svg)](https://github.com/nginxinc/docs/actions/workflows/check-broken-links.yml)


This repo contains all of the user documentation for NGINX's enterprise products, as well as the requirements for linting, building, and publishing the documentation.

Docs are written in Markdown. We build the docs using [Hugo](https://gohugo.io) and host them on [Netlify](https://www.netlify.com/).

## ✨ Getting Started

You will need to install Hugo to build and preview docs in your local development environment. 
Refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/) for more information.

**NOTE**: We are currently running [Hugo v0.115.3](https://github.com/gohugoio/hugo/releases/tag/v0.115.3) in production.

> Refer to the [CONTRIBUTING](./CONTRIBUTING.md) guide to learn how to develop content in this repo.

---

## Publishing Environments

| Development | Staging | Production |
|--------|--------|--------|
| https://docs-dev.nginx.com | https://docs-staging.nginx.com | https://docs.nginx.com |
| All commits to the `dev` branch, feature branches, pull request deploy previews publish to the docs-dev site.<br><br>This site is primarily used for review of content under development. | All commits to `main` publish to the docs-staging environment automatically.<br><br>This is helpful for sharing staged content with stakeholders for signoff immediately prior to a release. | Members of the @nginxinc/nginx-docs team can manually publish deploys via the Netlify Admin console.<br><br>*Automatic publishing is not currently implemented for this repo.* Work to add a GitHub Action that publishes to the production site once a day is in progress. |

**NOTE**: The dev and staging sites are password-protected; contact a member of the @nginxinc/nginx-docs team if you need access.  

---

## Git Guidelines

- Keep a clean, concise and meaningful git commit history on your branch (within reason), rebasing locally and squashing before submitting a PR.
- Use the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format when writing a commit message, so that changelogs can be automatically generated
- Follow the guidelines of writing a good commit message as described here <https://chris.beams.io/posts/git-commit/> and summarised in the next few points:
  - In the subject line, use the present tense ("Add feature" not "Added feature").
  - In the subject line, use the imperative mood ("Move cursor to..." not "Moves cursor to...").
  - Limit the subject line to 72 characters or less.
  - Reference issues and pull requests liberally after the subject line.
  - Add more detailed description in the body of the git message (`git commit -a` to give you more space and time in your text editor to write a good message instead of `git commit -am`).

### Forking and Pull Requests

This repo uses a [forking workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow). Take the steps below to fork the repo, check out a feature branch, and open a pull request with your changes.

1. In the GitHub UI, select the **Fork** button.
   
    - On the **Create a new fork** page, select the **Owner** (the account where the fork of the repo will be placed).
    - Select the **Create fork** button.

2. If you plan to work on docs in your local development environment, clone your fork. 
   For example, to clone the repo using SSH, you would run the following command:
    
    ```shell
    git clone git@github.com:<your-account>/docs.git
    ```

3. Check out a new feature branch in your fork. This is where you will work on your docs. 

   To do this via the command line, you would run the following command:

    ```shell
    git checkout -b <branch-name>
    ```

    **CAUTION**: Do not work on the main branch in your fork. This can cause issues when the NGINX Docs team needs to check out your feature branch for editing work.

4. Make atomic, [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) on your feature branch. 

5. When ready, open a pull request into the **main** branch or a release branch in the **nginxinc/docs** repo.
    
    - Fill in [our pull request template](https://github.com/nginxinc/docs/blob/main/.github/pull_request_template.md) when opening your PR.
    - Tag the appropriate reviewers for your subject area.  
      Technical reviewers should be able to verify that the information provided is accurate.  
      Documentation reviewers ensure that the content conforms to the NGINX Style Guide, is grammatically correct, and adheres to the NGINX content templates. 

## Release Management and Publishing

**`Main`** is the default branch in this repo. Main should always be releaseable. 
**Do not merge any content into main that is not approved for release.**

If you are working on content that isn't for a specific release (i.e., it can be published upon completion), open your pull request into the `main` branch.

### Prepare Content for Future Releases

If you are working on content for a future release, create a release branch from `main` that uses the naming format *acronym-release-x.y.x* (for example, `adm-release-4.0.0`). Work on your docs in feature branches off of the release branch. Open pull requests into the release branch when you are ready to merge your work.

## 📨 Feature Requests, Support, and Issue Reporting

### Report a Bug

To report a bug, open an issue on GitHub with the label `bug` using the available bug report issue template. Please ensure the bug has not already been reported. **If the bug is a potential security vulnerability, please report it using our [security policy](https://github.com/nginxinc/docs/blob/main/SECURITY.md).**

### Suggest a Feature or Enhancement

To suggest a feature or enhancement, please create an issue on GitHub with the label `enhancement` using the available [feature request template](https://github.com/nginxinc/docs/blob/main/.github/feature_request_template.md). Please ensure the feature or enhancement has not already been suggested.

