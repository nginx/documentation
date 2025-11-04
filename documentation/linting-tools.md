# Linting tools

This document describes the linting tools used for NGINX documentation and how to use them.

They can be executed automatically with [pre-commit](/documentation/pre-commit.md).

## Git

Git commit messages are linted with pre-commit using [gitlint](https://github.com/jorisroovers/gitlint).

The configuration file, `.gitlint`, is located at the root of the repository.

It checks the length of your message lines, that the body is not empty, and that the title adheres to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary).

For guidance on preferred detail, read the [Commit messages](/documentation/git-conventions.md#commit-messages) information.

## Markdown

Markdown files are linted using [markdownlint](https://github.com/DavidAnson/markdownlint).

The configuration file, `.markdownlint.yml`, is located at the root of the repository.

We use comments in the configuration file so maintainers can understand the rules at a glance.

To interact with the markdownlint library, we use the command line interface (CLI) tool `markdownlint-cli2`.

It is installed using `npm`:

```shell
npm install markdownlint-cli2 --global
```

To install npm (With node.js), you can use a tool such as [fnm](https://github.com/Schniz/fnm) or [nvm](https://github.com/nvm-sh/nvm).

Once `markdownlint-cli2` has been installed, you can use it by passing Markdown files to the command as arguments.

```text
➜ markdownlint-cli2 README.md
markdownlint-cli2 v0.18.1 (markdownlint v0.38.0)
Finding: README.md
Linting: 1 file(s)
Summary: 0 error(s)
```