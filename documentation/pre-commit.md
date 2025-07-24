# Set up pre-commit

[pre-commit](https://pre-commit.com/) is a command-line tool used for automatic linting.

It is currently *optional*, and used for consistent [Git conventions](/documentation/git-conventions.md), but will be used for more in the future.

The configuration file is located at the root of the repository, [pre-commit-config.yaml](/.pre-commit-config.yaml).

## Install pre-commit

To install pre-commit, you need [pip](https://pypi.org/project/pip/), which is bundled with most contemporary Python installations.

After ensuring you have pip installed, follow the [Installation steps](https://pre-commit.com/#install):

```shell
pip install pre-commit
```

Then install the git hook scripts with the following command:

```shell
pre-commit install
```

It will then run every time you use `git commit`.

If you encounter an error about a missing configuration file, you are likely working in a branch that has not synced changes from `main`.

You will need to sync changes from `main` or temporarily uninstall pre-commit to address the error.

```shell
pre-commit uninstall
```
