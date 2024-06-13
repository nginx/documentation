# GitHub Configurations

This directory contains settings used by GitHub for Actions, identifying code reviewers, issue and pull request templates, and more.

## Workflows

### check-broken-links

The check-broken-links workflow relies on the following projects:

- https://github.com/BoundfoxStudios/action-hugo-link-check
- https://github.com/fenneclab/hugo-bin/releases

The hugo-bin project lets you add Hugo as a dependency in your npm package.json file. The action-hugo-link-check Action requires this, as that is how it identifies which version of Hugo to run to build your docs. 

> Note: The release version numbers in the hugo-bin project do not align with the actual Hugo releases. Check the README and versions in the hugo-bin repo to find out which releases correspond to Hugo releases.
