# Contributing guidelines for closed content

This document describes the process for authoring "closed content", which is content of a sensitive nature that cannot be publicised before release.

Sensitive content might include:

- Security content, including personally identifying information (PII).
- Content / features that are not yet ready to be announced.

We work in public by default, so this process should only be used on a case by case basis by F5 employees. 

For standard content releases, review the [Contributing guidelines](/CONTRIBUTING.md).

## Overview

This repository (https://github.com/nginx/documentation) is where we work by default. It has a one-way sync to an internal repository, used for closed content.

The process is as follows:

- Add the closed repository as a remote
- Create a remote branch with the prefix `internal/` in the closed repository
- Open a pull request in the closed repository to get previews and request feedback
- Once all stakeholders are happy with changes, close the pull request in the closed repository
- Merge the changes from the remote (Closed) repository branch with a new branch in the open repository
- Open a new pull request in the open repository, where it can be merged

You can get the URL through our internal communication channels: it will be represented in the following steps as `<closed-URL>`.

## Steps

To create closed content, add the closed repository as a remote to the main repository, then fetch.

```shell
cd documentation
git remote add internal git@github.com:<closed-url>.git
git fetch --all
```

Check out the remote `main` branch, and use it to create a feature branch. **Ensure that you prefix all branch names with `internal/`**

```shell
git checkout internal/main
git checkout -b internal/feature
```

Once you've finished with your work, commit it and push it to the internal repository:

```shell
git add .
git commit
git push internal
```

Open a pull request when you are ready to receive feedback from stakeholders.

After any iterative work, close the pull request. Since the closed repository is a mirror of the open one, we do not merge changes to it.

Change back to the origin `main` branch, create a new branch, merge your internal branch and push to origin.

```shell
git checkout main
git checkout -b feature
git merge internal/internal/feature
git push origin
```

Once the content changes have been merged in the open repository, they will synchronize back to the closed repository.
