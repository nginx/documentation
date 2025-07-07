# Contributing guidelines

The following are a set of guidelines for contributing to this project. We appreciate your desire to get involved!

If you are an F5 employee, see the following additional guidance on [Maintainers etiquette](/documentation/maintainers-etiquette.md).

## Table of contents

- [Create an issue](#create-an-issue)
- [Start a discussion](#start-a-discussion)
- [Submit a pull request](#submit-a-pull-request)
- [Issue lifecycle](#issue-lifecycle)
- [Additional NGINX documentation](#additional-nginx-documentation)
- [F5 Contributor License Agreement (CLA)](#f5-contributor-license-agreement)

## Create an issue

One way to contribute to the project is by [creating an issue](https://github.com/nginx/documentation/issues/new/choose).

The two most common are enhancements and bug reports. When using the issue templates, they will be automatically labelled.

- An enhancement is an improvement of some kind, such as a new document or additional detail for a product feature
- A bug report draws attention to an issue in documentation, such as an incorrect command or outdated information

Before creating an issue, please check there is [no existing issue](https://github.com/nginx/documentation/issues?q=is%3Aissue) for the topic.

We encourage discussions within issues, since they act as a source of contextual truth and are linked to pull requests.

## Start a discussion

We encourage you to use [GitHub Discussions](https://github.com/nginx/documentation/discussions) for conversations with the community and maintainers.

If you'd like to discuss something NGINX-related that doesn't involve documentation, you should go to the [NGINX Community Forum](https://community.nginx.org/). 

## Submit a pull request

Before making documentation changes, you should view the [documentation style guide](/documentation/style-guide.md) and [Managing content with Hugo](/documentation/writing-hugo.md).

To understand how we use Git in this repository, read our [Git conventions](/documentation/git-conventions.md) documentation.

The broad workflow is as follows:

- Fork the NGINX repository
- Create a branch
- Implement your changes in your branch
- Submit a pull request (PR) when your changes are ready for review

Alternatively, you're welcome to suggest improvements to highlight problems with our documentation as described in our [support](./SUPPORT.md) page.

## Issue lifecycle

To ensure a balance between work carried out by the NGINX team while encouraging community involvement on this project, we use the following
issue lifecycle:

- A new issue is created by a community member
- An owner on the NGINX team is assigned to the issue; this owner shepherds the issue through the subsequent stages in the issue lifecycle
- The owner assigns one or more [labels](https://github.com/nginxinc/oss-docs/issues/labels) to the issue
- The owner, in collaboration with the community member, determines what milestone to attach to an issue. They may be milestones correspond to product releases

## Additional NGINX documentation

This repository does not include all of the source content for the NGINX documentation. Other relevant repositories include:

- [NGINX Open Source](https://github.com/nginx/nginx) - source for [NGINX changelog](https://nginx.org/en/CHANGES)
- [nginx.org](https://github.com/nginx/nginx.org) - source for https://nginx.org
- [NGINX Unit](https://github.com/nginx/unit) - source for https://unit.nginx.org

In those repositories, you can find documentation source code in the `docs` or `site` subdirectories.

## F5 Contributor License Agreement

F5 requires all external contributors to agree to the terms of the F5 CLA (available [here](https://github.com/f5/.github/blob/main/CLA/cla-markdown.md)) before any of their changes can be incorporated into an F5 Open Source repository.

If you have not yet agreed to the F5 CLA terms and submit a PR to this repository, a bot will prompt you to view and agree to the F5 CLA. You will have to agree to the F5 CLA terms through a comment in the PR before any of your changes can be merged. Your agreement signature will be safely stored by F5 and no longer be required in future PRs.
