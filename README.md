[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/nginxinc/template-repository/badge)](https://securityscorecards.dev/viewer/?uri=github.com/nginxinc/template-repository)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Community Support](https://badgen.net/badge/support/community/cyan?icon=awesome)](https://github.com/nginxinc/template-repository/blob/main/SUPPORT.md)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](https://github.com/nginxinc/template-repository/main/CODE_OF_CONDUCT.md)

<!-- These are the "repo [status badge](https://www.repostatus.org/)s" and the community support badges-->

# NGINX documentation

If you want to contribute to F5 NGINX documentation, you've come to the right place. We've organized a series of README-type files to help you get started:

- [Get started](/GET_STARTED.md) to help you get started with NGINX and our documentation.
- [Contributing](/CONTRIBUTING.md) describes how you can contribute to our documentation.
  - [Contributing with Git](/CONTRIBUTING_GIT.md) describes how you can contribute (and check your work) with Git and command line tools.
- [Code of Conduct](/CODE_OF_CONDUCT.md) describes expectations in the NGINX open source community.
- [Creative Commons License](/LICENSE) shows the Creative Commons license associated with work on this repository.
- [Prerequisties](/PREREQUISITES.md) lists the hardware and software that you need to get started with NGINX.
- [Security](/SECURITY.md) describes the procedures we would like you to follow if you find a security issue.
- [Support](/SUPPORT.md) lists how you can get support as a customer or a community member.

## Explanation

This repository contains user documentation for NGINX's products, as well as the requirements for linting, building, and publishing the documentation.

Our documentation is written in Markdown, specifically the [Goldmark](https://github.com/yuin/goldmark) Markdown parser.
We build our docs using [Hugo](https://gohugo.io) and host them in custom URLs on Azure.

## Publishing environments

When you submit a Pull Request (PR), our setup automatically builds the documentation with your proposed changes. You'll see the URL
once you've submitted the PR.

## License

[Creative Commons License](/LICENSE)

&copy; [F5, Inc.](https://www.f5.com/) 2024


## Credits

- [The Good Docs Project](https://www.thegooddocsproject.dev/), whose templates we've adapted for our use.
