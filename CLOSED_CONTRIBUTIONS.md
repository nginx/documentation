# Contributing guidelines for closed content

This document describes the process for authoring "closed content", which is content of a sensitive nature that cannot be publicised before release.

Sensitive content might include:

- Security content, including personally identifying information (PII).
- Content / features that are not yet ready to be announced.

We work in public by default, so this process should only be used on a case by case basis by F5 employees. For standard content releases, review the [Contributing guidelines](/CONTRIBUTING.md)

## Overview

This repository (https://github.com/nginx/documentation) is where we work by default. It has a one-way sync to an internal repository, used for closed content.

The process is as follows:

- Create a branch with the prefix `internal/` in the closed repository
- Open a pull request in the closed repository to get previews and request feedback
- Once all stakeholders are happy with changes, close the pull request in the closed repository
- Push the changes to the open (public) repository by adding the closed repository as a remote
- Open a new pull request in the open repository, where it can be merged

You can get the URL through our internal communication channels: it will be represented in the following steps as `<closed-URL>`.

To create closed content, first clone the internal repository:

`git clone git@github.com:<closed-url>.git`

Change into this new directory:

`cd <closed-url>`

Check out the `documentation` branch:

`git checkout documentation`

Create a feature branch, **ensuring that you prefix all branch names with `internal/`**:

`git checkout -b internal/feature`

You can then continue on as normal:

```bash
# Make documentation changes
git add .
git commit
git push
```

Open a pull request when you are ready to receive feedback from stakeholders.

After any iterative work, close the pull request. Since the closed repository is a mirror of the open one, we do not merge changes to it.

You should instead open a pull request in the main repository by adding the closed repository as a remote.

```bash
git clone git@github.com:nginx/documentation.git
cd documentation
git add remote internal git@github.com:<closed-url>.git
git fetch internal internal/feature
git checkout -b feature
git merge internal/internal/feature
git push origin feature
```

After the content changes have been merged in the open repository, they will synchronize back to the closed repository.