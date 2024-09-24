# Release Notes Template Guide

 Before using the template, read this template guide for information about how to complete each section.

## Introduction

Release notes communicate new features, improvements, bug fixes, and known issues to stakeholders such as customers, Technical Support, Sales, Marketing, and users.
This template guide and template are intended for customer-facing release notes, however, you can adapt it for internal release notes as needed.

Stakeholders with both technical and non-technical backgrounds must understand what’s changed, and why those changes are important to the user.

Release notes are usually published at the same time as a product or feature release.

## Why do I need release notes?

Release notes are important for the following reasons:
- They indicate transparency. Frequent release note updates show that you actively maintain the product and care about your stakeholders.
- They reduce support tickets. They keep your stakeholders informed about current releases, especially new features and known issues.
- They help your stakeholders assess impacts that might occur during upgrades.
- They provide a plain-language record of your software’s evolution. Stakeholders don’t have to read development-heavy changelogs to find out what’s changed and why it matters to them.

The following table describes the differences between changelogs and release notes:

| Release Notes                                                                                                                                                                              | Changelogs                                                                                                                                                                                                                 |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Customer focused                                                                                                                                                                           | Developer focused                                                                                                                                                                                                          |
| Use plain language.                                                                                                                                                                        | Use technical language.                                                                                                                                                                                                    |
| Typically requires research to understand the features, functionality, and user experience.                                                                                                | Typically a light effort as it is closely related to developers’ current work.                                                                                                                                             |
| Describes the changes to features and functionality. <ul><li>Can include media to enhance descriptions.</li><li> Often includes links to the user documentation for more information.</li> | A reverse chronological list that describes code changes and their impact on the features. <ul><li>Can include links to merge requests, issue numbers, or commits.</li><li>Can list contributors to the release.</li></ul> |
| Includes what changed and why.                                                                                                                                                             | Links to the developer who made the change and specific issues.                                                                                                                                                            |
| Typically written by a Technical Writer or Product Manager.                                                                                                                                | Typically written by a Software Developer derived from commit messages to a version control system.                                                                                                                        |

## About this template

The template includes the following sections common to release notes:

- [Release Notes version](#release-notes-version): Include a document version number and a release date.
- [High-level summary](#high-level-summary-optional) (optional): One to two sentences that highlight the most important items in the release notes.
- [What's new](#about-the-new-features-section-optional) (optional): Describes new features and functionality.
- [Changes to default behavior](#about-the-changes-to-default-behavior-section-optional) (optional): Describes changes to default behavior.
- [Resolved issues](#about-the-resolved-issues-section-optional) (oprional): Lists the issues resolved in this release, if applicable.
- [Known issues](#about-the-known-issues-section-optional): Provides a link to a list of known issues.
- [Security updates](#about-the-security-updates-section-optional) (optional): Describes security updates in the release, if applicable.

## Release notes best practices
- Write the release notes in a positive and friendly tone.
- Write in the second person. For example “Use your menu to access the window.”
- Be clear, concise, and consistent.
- Use plain language.
- Write in the present tense, except when you describe bug fixes; use the past tense for bug fixes.

## Release Notes version
Each main section of your release notes should correspond to a product release number.
This helps stakeholders identify which release the notes are describing.
We use [semantic versioning](https://semver.org/) to number our releases.
This is usually shown as three numbers, separated by periods.
For example, 1.3.2.

If the product publishes release notes off a release cycle, include the date in the subtitle, in `Month Day, Year` format.


## High-level summary (optional)

A high-level summary can help stakeholders quickly understand the most important items in your release notes, especially if your notes are long.
Keep the summary short.

## About the "New features" section (optional)

List the most important features first.
What is important depends on your organization and stakeholder priorities.
Consider the features from the stakeholder’s point of view, and list new features that have the most impact on their experience first.

When you write about new product features:

1. Use an engaging, concise title to summarize the feature.
1. Describe how the feature benefits the stakeholder. You might ask yourself, “Why is this valuable? How does it benefit the business?”
1. Link to the feature’s full documentation in the description. The description in this section  includes only a brief description. Link to the full documentation to provide a complete description, which becomes the source of truth.

The following is an example of a new feature:

- **Find Your Recent Transactions with Personal Log**

    Use Personal Log to quickly access your most recent transactions.
   When speaking with a customer, you can select the last five transactions that you accessed from a menu.
   You can also perform a more extensive search to find specific transactions you accessed in your queues.
   See [Personal Log](http://example.com) for more information.

The following formulas might be helpful when writing new features:

**Formula 1:**

- [ ] You can now {describe what you can do with the feature}.
- [ ] This means you can {benefit}.
- [ ] See {link to topic name} for more details.

    **If we were to apply this formula, using the previous example, it reads as follows:**

    You can now quickly access your most recent transactions.
    This means you can select the last five transactions that you accessed from a menu when speaking with a customer. You can also perform a more extensive search to find specific transactions you accessed in your queues.
    See [Personal Log](http://example.com)  for more details.

**Formula 2:**

- [ ] {The application} now provides {feature}...
- [ ] …{benefit}.
- [ ] See {link} for more details.

    **If we were to apply this formula, using the previous example, it reads as follows:**

    Software X now provides a Personal Log, so you can quickly access your most recent transactions.
    See [Personal Log](http://example.com) for more details.


## About the "Changes to default behavior" section (optional)

Changes to default behavior are changes that affect the way the software behaves, but are not new features or bug fixes.
For example, if a default setting changes, you must communicate this to stakeholders.

When you write about changes to default behavior:

1. Use an engaging, concise title to summarize the change.
1. Describe how the change benefits the stakeholder. You might ask yourself, “Why is this valuable? How does it benefit the business?”
1. Link to the feature’s full documentation in the description. The description in this section includes only a brief description. Link to the full documentation to provide a complete description, which becomes the source of truth.

The following is an example of a change to default behavior:

- **New Default Setting for Notifications**

    Notifications are now enabled by default.
    See [Notifications](http://example.com) for more information.

The following formulas might be helpful when writing about changes to default behavior:

**Formula 1:**

- [ ] The {application or feature} now…
- [ ] …{describe the change}.
- [ ] See {link} for more information.

    **If we were to apply this formula, using the previous example, it reads as follows:**

    The Notifications feature now enables notifications by default. This means you will receive notifications for all new transactions.
    See [Notifications](http://example.com) for more information.

## About the "Resolved issues" section (optional)

Resolved issues describe what was fixed and why it was useful to the stakeholder.
For example, if new fields are added to a database, you must find out how this helps stakeholders and communicate that information to them.

When you write about resolved issues:

1. Add the issue name (from the Known issues page).
1. Do not describe the issue or the fix.
1. Include the issue number and link to it in the Known issues list.

The following is an example of a resolved issues:

- Broken links in the user interface ([12345](http://example.com/known-issues/#12345))

## About the "Known issues" section (optional)

The Known issues section provides a link to a list of known issues. We usually don't list known issues in the release notes because they are already documented in the Known issues list.

## About the "Security updates" section (optional)

The Security updates section lists resolved security updates in the release, if applicable.

When you write about security updates:

1. Add the security issue name.
1. Add the CVE number.
1. Describe the security issue and how it was resolved.
1. Link to the CVE number.

The following is an example of a security update:

- **Secure bag vulnerability CVE-2024-9999**

    A vulnerability in the coffee bag ([CVE-2024-9999](https://coffee-sec.org/CVE-2024-9999)) could allow an attacker to steal the coffee beans. This issue has been resolved in this release.


## Additional Resources

See “[How to write meaningful release notes](https://drive.google.com/file/d/1q5GVhFEcUFzYxSkeOvzAyN9Gh0xPbAI-/view)” for additional ideas.