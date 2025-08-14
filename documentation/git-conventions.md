# Git conventions

For consistency, we have a handful of git conventions:

- We follow a [GitHub flow model](https://githubflow.github.io/) for branch management
- We follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) formatting
- We write [good commit messages](https://cbea.ms/git-commit/), treating them as a source of truth

Many of these conventions are suggested or enforced in tooling: for local development, [set up pre-commit](/documentation/pre-commit.md).

We encourage small, tightly-scoped pull requests: this makes managing reviews simpler, allowing us to iterate on documentation quickly.

## Branch management

We continuously deploy from the [`main`](https://github.com/nginx/documentation/tree/main) branch.

To make changes, [fork the repository](https://github.com/nginx/documentation/fork) then branch from `main`, giving your branch a prefix and descriptive name.

Prefixes are typically a three letter acronym for the product it affects:
- `nic/`, `ngf/`, `nim`/, `waf/`, and so forth
-  Use `docs/` if the change is related to the repository or not product-specific

A descriptive name usually concerns what the branch actually updates:
- `nic/update-helm-links` Tells someone at a glance that the branch relates to NGINX Ingress Controller and links related to Helm
- `patch-27` Tells someone almost nothing at a glance: it does not include a prefix or any details about a possible topic

The exception to this branch naming convention is release branches for products. These are named `<product>-<release>-<version>`:
- `agent-release-2.2`
- `n1c-release-1.5`
- `dos-release-5.1`

Typically, the technical writer for a given product will ensure that branches are kept in sync with `main`, to minimize the risk of merge conflicts.

If you need to rename a branch, here's the syntax:

```shell
git branch -m <current-branch-name> <new-branch-name>
```

## Commit messages

When opening a pull request on GitHub, the very first commit from a branch is automatically pulled to populate the description.

This provides an opportunity to re-use a good commit message to provide context to reviewers for the changes in a branch.

The first line of a git commit message becomes the subject line, with the contents after a line break becoming the body.

A subject line begins with a [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) prefix, and should be written in present imperative.
- _feat: Update ConfigMap reference page_
- _fix: Remove links to missing website_

Keep the subject line around 50 characters or less: imagine the reader is using `git reflog` or `git log --oneline` to review changes.

The body of the git message should have its lines kept around 72 characters or less, and can be structured as follows:

- What was changed and why
- How the changes were implemented
- What else the changes might affect, and what may change in the future

This provides enough context for a reader to get a strong impression of what the commit accomplishes, which in turn makes reviewing pull requests easier

An example of a full commit message following the above conventions is as follows:

```
feat: Move and update process documentation

This commit moves and updates some of the process documentation for the
repository. This is an iterative process, which will continue to improve
as time goes on. Some of the changes include:

- Moving the closed contributions document into the documentation folder
- Moving and reframing the F5/NGINX document as "Maintainers etiquette"
- Moving and renaming the "Managing content with Hugo" document
- Moving the style guide from the templates folder

These files will likely be updated in a subsequent PR as we clarify the
contribution process and user flow of other process artefacts, such as
the pull request and issue templates.

Although we do not draw attention to it, the templates folder is being
retained for reference until the style guide and Hugo archetypes contain
the relevant, useful information.
```
