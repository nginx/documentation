# NGINX Documentation

[![Check for Broken Links](https://github.com/nginxinc/docs/actions/workflows/check-broken-links.yml/badge.svg)](https://github.com/nginxinc/docs/actions/workflows/check-broken-links.yml)

This repository contains all of the user documentation for NGINX's enterprise products, as well as the requirements for linting, building, and publishing the documentation.

We write our documentation in Markdown. We build it with [Hugo](https://gohugo.io) and our custom [NGINX Hugo theme](https://github.com/nginxinc/nginx-hugo-theme). We set up previews and deployments using our [docs-actions](https://github.com/nginxinc/docs-actions?tab=readme-ov-file#docs-actions) workflow.

## ✨ Contributing

We are beta-testing contribution using [CloudCannon](https://app.cloudcannon.com). If you would like to participate, send an email to [nginx-doc-ops@f5.com](mailto:nginx-doc-ops@f5.com).

> Refer to the [CONTRIBUTING](./CONTRIBUTING.md) guide to learn how to develop content using the developer workflow in this repo.

---

## Publishing environments

| Development | Staging | Production |
|--------|--------|--------|
| https://docs-dev.nginx.com | https://docs-staging.nginx.com | https://docs.nginx.com |
| All commits to the `dev` branch, feature branches, pull request deploy previews publish to the docs-dev site.<br><br>This site is primarily used for review of content under development. | All commits to `main` publish to the docs-staging environment automatically.<br><br>This is helpful for sharing staged content with stakeholders for signoff immediately prior to a release. | Members of the DocOps team can manually publish deploys with a GitHub action.<br><br>*Automatic publishing is not currently implemented for this repo.* Work to add a GitHub Action that publishes to the production site once a day is in progress. |

**NOTE**: Pull request previews and the development and staging sites are all password-protected. You can find the latest login details on Slack or Confluence.

---

## Git guidelines

- Keep a clean, concise and meaningful git commit history on your branch (within reason), rebasing locally and squashing before submitting a PR.
- Use the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format when writing a commit message, so that changelogs can be automatically generated
- Follow the guidelines of writing a good commit message as described here <https://chris.beams.io/posts/git-commit/> and summarised in the next few points:
  - In the subject line, use the present tense ("Add feature" not "Added feature").
  - In the subject line, use the imperative mood ("Move cursor to..." not "Moves cursor to...").
  - Limit the subject line to 72 characters or less.
  - Reference issues and pull requests liberally after the subject line.
  - Add more detailed description in the body of the git message (`git commit -a` to give you more space and time in your text editor to write a good message instead of `git commit -am`).

### Pull requests and forks

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

## Release management and publishing

**`Main`** is the default branch in this repo. Main should always be releaseable. 
**Do not merge any content into main that is not approved for release.**

If you are working on content that isn't for a specific release (i.e., it can be published upon completion), open your pull request into the `main` branch.

### Preparing content for future releases

If you are working on content for a future release, create a release branch from `main` that uses the naming format *acronym-release-x.y.x* (for example, `adm-release-4.0.0`). Work on your docs in feature branches off of the release branch. Open pull requests into the release branch when you are ready to merge your work.

## Feature requests, support, and issue reporting

### Report a Bbg

To report a bug, open an issue on GitHub with the label `bug` using the available bug report issue template. Please ensure the bug has not already been reported. **If the bug is a potential security vulnerability, please report it using our [security policy](https://github.com/nginxinc/docs/blob/main/SECURITY.md).**

### Suggest a feature or enhancement

To suggest a feature or enhancement, please create an issue on GitHub with the label `enhancement` using the available [feature request template](https://github.com/nginxinc/docs/blob/main/.github/feature_request_template.md). Please ensure the feature or enhancement has not already been suggested.

## Credits

- [The Good Docs Project](https://www.thegooddocsproject.dev/), whose templates we've adapted for our use.