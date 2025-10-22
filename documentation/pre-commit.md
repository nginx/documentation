# Set up pre-commit

[pre-commit](https://pre-commit.com/) is a command-line tool used for automatic linting.

It is currently *optional*, and used for consistent [Git conventions](/documentation/git-conventions.md), and [linting tools](/documentation/linting-tools.md).

To use pre-commit, you *must* have all of the linting tool requirements, as every integration will be executed by pre-commit. 

Otherwise, you will need to manually edit the configuration file to disable integrations whose requirements you do not have installed.

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

Periodically, you should update the pre-commit libraries using `autoupdate`:

```shell
pre-commit autoupdate
```

## Use pre-commit

pre-commit will automatically trigger when using git based on the specific integration and how it has been configured.

You can trigger all of the integrations on modified files by running pre-commit without any arguments:

```shell
pre-commit
```

You can trigger an individual integration using its id (Found in the configuration file):

```shell
pre-commit run markdownlint-cli2
```

You can trigger an integration on specific files by passing them as parameters to the `--files` argument:

```shell
pre-commit run markdownlint-cli2 --files README.md
```