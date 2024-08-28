[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/nginxinc/template-repository/badge)](https://securityscorecards.dev/viewer/?uri=github.com/nginxinc/template-repository)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Community Support](https://badgen.net/badge/support/community/cyan?icon=awesome)](https://github.com/nginxinc/template-repository/blob/main/SUPPORT.md)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](https://github.com/nginxinc/template-repository/main/CODE_OF_CONDUCT.md)

# NGINX Template Repository

## What is included on this template?

This template includes all the scaffolding you need to get started on an OSS repository that meets the required NGINX criteria:

- [Apache License 2.0](/LICENSE) (required for all NGINX OSS projects).
- [`.gitignore`](/.gitignore) with some minimal sensible defaults.
- [Issue](/.github/ISSUE_TEMPLATE) and [PR](/.github//pull_request_template.md) templates.
- [Contributing](/CONTRIBUTING.md) guidelines.
- [Support](/SUPPORT.md) guidelines for either community and/or commercial support (uncomment the commercial block if necessary).
- [Security](/SECURITY.md) guidelines for reporting major vulnerabilities.
- [Code of Conduct](/CODE_OF_CONDUCT.md).
- [F5 CLA workflow](/.github/workflows/f5-cla.yml). For more details on the action please check the [F5 CLA signature datastore repository](https://github.com/f5/f5-cla-data).
- Open Source Security Foundation (OSSF) Scorecard [(implemented via a GitHub Action)](/.github/workflows/ossf_scorecard.yml)
- [README](/README.md) placeholder. How you structure the README is up to you (although the template provides placeholder sections), but you will need to include:
  - A [repostatus](https://www.repostatus.org/) badge.
  - An OSSF Scorecard badge. (Optional -- Some projects will by their nature have low scores. In such a case you might want to remove this badge!).
  - A community and/or commercial support badge. Include the latter -- and replace the commented out badge/URL placeholder with the relevant support URL -- if this repository contains a commercially supported project. You can find a commented out example below the community badge in this README.
  - A contributor covenant/code of conduct badge. (Optional -- If you already have multiple badges and want to reduce clutter, simply including the actual code of conduct is enough!)
  - An explicit link back to the [Apache License 2.0](/LICENSE).
  - An up to date copyright notice.
- [Changelog](/CHANGELOG.md) placeholder. (Optional -- A changelog is recommended, but it is not required and can diverge in format from the placeholder here included.)
- [Codeowners](/.github/CODEOWNERS) placeholder. (Optional -- Codeowners is a useful feature, but not all repositories require them.)

**Note:** If you created a public repository before this template became available (or you didn't know about it's existence), please include any missing files found here in your repository. There is no need if you have a private repository, but we still recommend you include all of the above scaffolding should the repository ever become public.

## How do I use this template?

**DO NOT FORK** -- this template is meant to be used from the **[`Use this template`](https://github.com/nginxinc/template-repository/generate)** feature.

1. Click on **[`Use this template`](https://github.com/nginxinc/template-repository/generate)**.
2. Give a name to your project.
3. Wait until the first run of CI finishes (GitHub Actions will process the template and commit to your new repo).
4. Clone your new project and tweak any of the placeholders if necessary. Pay special attention to the README!
5. Happy coding!

**NOTE**: **WAIT** until the first CI run on GitHub Actions finishes before cloning your new project.

---

<!--  DELETE THE LINES ABOVE THIS AND WRITE YOUR PROJECT README BELOW -- PLACEHOLDER SECTIONS HAVE BEEN INCLUDED FOR YOUR CONVENIENCE -->

[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/{{REPOSITORY_OWNER}}/{{REPOSITORY_URL}}/badge)](https://securityscorecards.dev/viewer/?uri=github.com/{{REPOSITORY_OWNER}}/{{REPOSITORY_URL}})
[![Community Support](https://badgen.net/badge/support/community/cyan?icon=awesome)](/SUPPORT.md) <!-- [![Commercial Support](https://badgen.net/badge/support/commercial/cyan?icon=awesome)](<Insert URL>) -->
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](/CODE_OF_CONDUCT.md)

# {{REPOSITORY_NAME}}

## Requirements

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam elit turpis, varius et arcu elementum, viverra rhoncus sem. Aliquam nec sodales magna, et egestas enim. Mauris lobortis ultrices euismod. Pellentesque in arcu lacus. Mauris cursus laoreet nulla, ac vehicula est. Vestibulum eu mauris quis lorem consectetur aliquam ac nec quam. Vestibulum commodo pharetra mi, at bibendum neque faucibus ut. Mauris et tortor sed sem consectetur eleifend ut non magna. Praesent feugiat placerat nibh, varius viverra orci bibendum sed. Vestibulum dapibus ex ut pulvinar facilisis. Quisque sodales enim et augue tempor mattis. Suspendisse finibus congue felis, ac blandit ligula. Praesent condimentum ultrices odio quis semper. Nunc ultrices, nibh quis mattis pellentesque, elit nulla bibendum felis, quis dapibus erat turpis ac urna.

## Getting Started

Duis sit amet sapien vel velit ornare vulputate. Nulla rutrum euismod risus ac efficitur. Curabitur in sagittis elit, a semper leo. Suspendisse malesuada aliquam velit, eu suscipit lorem vehicula at. Proin turpis lacus, semper in placerat in, accumsan non ipsum. Cras euismod, elit eget pretium laoreet, tortor nulla finibus tortor, nec hendrerit elit turpis ut eros. Quisque congue nisi id mauris molestie, eu condimentum dolor rutrum. Nullam eleifend elit ac lobortis tristique. Pellentesque nec tellus non mauris aliquet commodo a eu elit. Ut at feugiat metus, at tristique mauris. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;

## How to Use

Maecenas at vehicula justo. Suspendisse posuere elementum elit vel posuere. Etiam quis pulvinar massa. Integer tempor semper risus, vitae maximus eros ullamcorper vitae. In egestas, ex vitae gravida sodales, ipsum dolor varius est, et cursus lorem dui a mi. Morbi faucibus ut nisi id faucibus. Sed quis ullamcorper ex. In et dolor id nunc interdum suscipit.

## Contributing

Please see the [contributing guide](/CONTRIBUTING.md) for guidelines on how to best contribute to this project.

## License

[Apache License, Version 2.0](/LICENSE)

&copy; [F5, Inc.](https://www.f5.com/) 2024
