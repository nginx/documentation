# Contributing guidelines

The following is a set of guidelines for community contributions to this
project. We really appreciate your desire to contribute!

If you are an F5 employee, see the following additional guidance [For F5 Employees](./F5-NGINX-team-notes.md).

## Table of contents

- [Report a Bug](#report-a-bug)
- [Suggest a Feature or Enhancement](#suggest-a-feature-or-enhancement)
- [Open a Discussion](#open-a-discussion)
- [Submit a Pull Request](#submit-a-pull-request)
  - Review our [Git style guide](#git-style-guide)
  - Review our Documentation [style guide](./templates/style-guide.md)
  - Review our [Contributing guidelines for writers](./CONTRIBUTING_DOCS.md)
- [Issue Lifecycle](#issue-lifecycle)
- [Content edited elsewhere](#content-edited-elsewhere)
- [F5 Contributor License Agreement (CLA)](#f5-contributor-license-agreement)

## Report a bug

To report a bug, open an issue on GitHub with the label `bug` using the
available bug report issue template. Before reporting a bug, make sure the
issue has not already been reported.

## Suggest a feature or enhancement

To suggest a feature or enhancement, open an issue on GitHub with the label
`feature` or `enhancement` using the available feature request issue template.
Please ensure the feature or enhancement has not already been suggested.

## Open a Discussion

If you want to start a conversation with the community and maintainers,
we encourage you to use
[GitHub Discussions](https://github.com/nginx/documentation/discussions).

## Submit a Pull Request

To contribute to F5 NGINX documentation, follow these steps:

- Fork the NGINX repository
- Create a branch
- Implement your changes in your branch
- Submit a pull request (PR) when your changes are ready for review

Alternatively, you're welcome to suggest improvements to highlight problems with
our documentation as described in our [support](./SUPPORT.md) page.

### Git style guide

- Keep a clean, concise and meaningful Git commit history on your branch, rebasing locally and squashing before you submit a PR
- Follow the guidelines of writing a good commit message as described here <https://chris.beams.io/posts/git-commit/>
  and summarized in the next few points:

  - In the subject line, use the present tense ("Add feature" not "Added feature")
  - In the subject line, use the imperative mood ("Move cursor to..." not "Moves cursor to...")
  - Limit the subject line to 72 characters or less
  - Reference issues and pull requests liberally after the subject line
  - Add more detailed description in the body of the git message (`git commit -a` to give you more space and time in
    your text editor to write a good message instead of `git commit -am`)

#### Branch protection rules

This repository has the following branch protection rules in place:

- **Pushing branches that contain the "internal/" prefix is not allowed.** This ensures internal development branches are not accidentally or purposefully pushed to this repo.
- **Two approvers are required for all merges to main and release branches.** This ensures all code that is approved for release to production is appropriately reviewed. This rule applies to all branches with `*release*` in the branch name.
- **Only NGINX DocOps Team members can create release branches.** This ensures the docs team is aware of all branches supporting specific product releases. This rule applies to all branches with `*release*` in the branch name.
- **Pushes (force or otherwise) directly to main or release branches is not allowed.** Release branches serve as "main" for the release they are associated with. Restricting pushes directly to main and release branches ensures all content changes are reviewed and approved. This rule applies to all branches with `*release*` in the branch name and to "main".

### Documentation style guide

For detailed guidance, see our documentation [style guide](./templates/style-guide.md).

## Issue lifecycle

To ensure a balance between work carried out by the NGINX team while encouraging community involvement on this project, we use the following
issue lifecycle:

- A new issue is created by a community member
- An owner on the NGINX team is assigned to the issue; this owner shepherds the issue through the subsequent stages in the issue lifecycle
- The owner assigns one or more [labels](https://github.com/nginxinc/oss-docs/issues/labels) to the issue
- The owner, in collaboration with the community member, determines what milestone to attach to an issue. They may be milestones correspond to product releases

## Content edited elsewhere

This repository does not include all documentation available at https://docs.nginx.com. Other relevant repositories include:

- [NGINX Open Source](https://github.com/nginx/nginx)
- [NGINX Unit](https://github.com/nginx/unit)
- [NGINX Ingress Controller](https://github.com/nginxinc/kubernetes-ingress/)
- [NGINX Gateway Fabric](https://github.com/nginxinc/nginx-gateway-fabric)

In those repositories, you can find documentation source code in the `docs` or `site` subdirectories.

## F5 Contributor License Agreement

F5 requires all external contributors to agree to the terms of the F5 CLA (available [here](https://github.com/f5/.github/blob/main/CLA/cla-markdown.md)) before any of their changes can be incorporated into an F5 Open Source repository.

If you have not yet agreed to the F5 CLA terms and submit a PR to this repository, a bot will prompt you to view and agree to the F5 CLA. You will have to agree to the F5 CLA terms through a comment in the PR before any of your changes can be merged. Your agreement signature will be safely stored by F5 and no longer be required in future PRs.
