### Proposed changes

Describe the use case and detail of the change. If this PR addresses an [issue](https://github.com/nginxinc/docs/issues) on GitHub, make sure to include a link to that issue.

**JIRA ID**:

**GitHub Issue**:
Closes #<Issue>

### Checklist

Before creating a PR, run through this checklist and mark each step as complete.

- [ ] I have read the [`CONTRIBUTING`](https://github.com/nginxinc/docs/blob/main/CONTRIBUTING.md) document
- [ ] I have viewed my changes in the Netlify deploy-preview
- [ ] My PR is targeting the correct branch:
  
  - main: content that can be released immediately
  - product release branch: content that should be held for a future release
    
- [ ] I have updated any relevant supporting documentation ([`README.md`](https://github.com/nginxinc/docs/blob/main/README.md) and the [`CHANGELOG.md`](https://github.com/nginxinc/docs/blob/main/CHANGELOG.md))
- [ ] I have followed the [conventional commits guidelines](https://www.conventionalcommits.org/en/v1.0.0/#summary) for all commits on my branch
- [ ] I have updated the [_redirects](https://github.com/nginxinc/docs/blob/main/_redirects), [_redirect_dev](https://github.com/nginxinc/docs/blob/main/_redirects_dev), and [_redirects_staging](https://github.com/nginxinc/docs/blob/main/_redirects_staging) files to reflect changes to any public-facing doc files that I moved or renamed.

When you're ready to merge a PR, run through this checklist and mark each step as complete.

- [ ] Review the doc for spelling errors.
- [ ] Verify that all links in the doc work.
- [ ] Verify that the doc follows the appropriate content template.
- [ ] Add technical and docs reviewers.
  - @nginxinc/docs: any PR (if you're not sure, choose this team)
  - @nginxinc/nap-docs-approvers: add for NGINX App Protect docs.
  - @nginxinc/plus-docs-approvers: add for NGINX OSS and NGINX Plus docs.

- [ ] Share the PR for review in the [`#nginx-doc-reviews`](https://f5.enterprise.slack.com/archives/C04PYFULN91) channel in Slack.
