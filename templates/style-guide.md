
# F5 NGINX Documentation style guide

{Version number and last updated date}

## Introduction

Welcome to our project! This style guide is intended for use by project
contributors, not necessarily end-users. It provides general guidance to anyone
who contributes to the project's documentation.

## Intended audience and scope

This style guide is intended for use by any contributors that are writing
documentation for F5 NGINX products, including software engineers. This guide
can help project contributors to communicate clearly and consistently in the project's end-user documentation, API documentation, configuration files, and in-product user messages.

## Our preferred style guide

This document contains guidelines specific to the the documentation of F5 NGINX products and open source projects. 

F5 NGINX follows the [Microsoft style guide](https://learn.microsoft.com/en-us/style-guide/welcome/)
for user-facing content and the Chicago Manual of Style](https://www.chicagomanualofstyle.org/home.html).


Our project uses standard American spelling and our preferred dictionary is the
[American Heritage Dictionary](https://ahdictionary.com/) or your preferred
dictionary.

When writing documentation for our project, align with the default guide's
voice and tone.

## F5 brand trademarks and product names

- Always use the full brand name the first time it occurs in written copy. For example:
    
  - F5 NGINX Plus 
  - F5 NGINX App Protect WAF
  - F5 NGINX Management Suite

- After the first use, you can drop the "F5". All subsequent uses must include the "NGINX" brand name. For example:

  - NGINX Plus
  - NGINX App Protect WAF
  - NGINX Management Suite
    
- Always use the full brand name in the meta description.
- Never use acronyms instead of the full product names.     
- We don’t need to use trademarks in product documentation.

## Glossary of preferred terms

The table provides guidelines about the terms you should and should not use for
consistency, listed in alphabetical order:

Term  | Recommendations  |  Explanation
--------------- | -----------------  |  -----------
e.g.            | for example        |  Avoid non-English words
the disabled<br> disabled people<br> people with handicaps<br> the handicapped | people with disabilities  |  Use inclusive and bias-free language. See [Accessible Writing](#accessible-writing)
that is         |  i.e.              |  Avoid non-English words
abort | Never use this term in your docs. Use the preferred terms when writing about a process:<br>stop<br>interrupt<br>shut down| Abort is acceptable to use in programmer or similar technical documentation only if it is a function name, parameter name, or otherwise part of a name in the API. 
above and below	| Avoid. Refer to the specific section, table, figure, an so on, as opposed to indicating its relative position in the document.
access	| Used as a verb, it’s jargon, so don’t use it.|
allows	| Not recommended. <br>Avoid phrases such as "NGINX Plus allows you to…". <br><br>Use direct, active verbs from the perspective of the user instead. |
and/or	| Not recommended. Usually, this means either "and" or "or". Try to be specific in your writing; people are counting on you for clear instructions. |  |
anthropomorphism | Avoid referring to the product or feature as though it were alive. <br>When referring to products, stay away from words like: decides, knows, sees, listens, and hears.<br>A wizard guides you, it doesn’t walk you through the steps.
application	| When referring to applications in general, write out the entire word. For clarity, avoid abbreviating to "app" unless specifically referencing the user interface or product.
as/because | Use "because" instead of "as" when showing a cause and effect relationship. | |
attack signature, attack signature set | Refers to elements of the NGINX App Protect WAF package. Do not abbreviate or otherwise shorten. | |
backwards | Use backward and forward, not backwards and forwards | |
black list<br> blacklist<br> blacklisted | Do not use these terms.<br>Use these terms instead:<br>-black list (noun) = deny list (noun)<br>-blacklist (verb) = denylist (verb)<br>-blacklisted (adjective) = denylisted (adjective)
boot, boot up, reboot | Use "start" and "restart" if possible.<br>For "boot", use in the context of "boot to a new volume". If the meaning is actually "start", then use "start". Do not use "boot up".<br>Instead of "reboot", use "restart". <br>When referring to applying configuration changes, use "reload".
white list<br>whitelist<br>whitelisted | Do not use. Use these terms instead:<br>- white list (noun) = allow list (noun)<br>- whitelist (verb) = allowlist (verb)<br>- whitelisted (adjective) = allowlisted (adjective) |


## Topic types and templates

This project recommends using the following templates from the
[Good Docs project](https://github.com/thegooddocsproject/templates):

- API Overview
- API Quickstart
- API Reference
- Discussion Article
- How To Guide
- Logging Article
- Reference Article
- Tutorial

## General writing tips

{This section is optional.}

For some general tips about improving writing see:

- [Write the Docs - Style Guides](https://www.writethedocs.org/guide/writing/style-guides/#writing-style)
- [18F Content Guide](https://content-guide.18f.gov/)

## Accessible writing

Documentation should be written in a way that supports people with disabilities
and users with various input methods and devices. Improving accessibility also
helps make documentation clearer and more useful for everyone.

For resources on making your writing more accessible, see:

- [Writing accessible documentation - Google developer documentation style guide](https://developers.google.com/style/accessibility)
- [Accessibility guidelines and requirements - Microsoft Writing Style Guide](https://docs.microsoft.com/en-us/style-guide/accessibility/accessibility-guidelines-requirements)
- [Writing for Accessibility - Mailchimp Content Style Guide](https://styleguide.mailchimp.com/writing-for-accessibility/)

## Inclusive and bias-free writing

When contributing to this project, you should strive to write documentation with
inclusivity and diversity in mind. Inclusive language recognizes diversity and
strives to communicate respectfully to all people. This kind of language is
sensitive to differences and seeks to promote equal opportunities.

For resources on making your writing more inclusive, see:

- [Inclusive documentation - Google developer documentation style guide](https://developers.google.com/style/inclusive-documentation)
- [The Conscious Style Guide - a collection of resources](https://consciousstyleguide.com/)
- [Bias-free communication - Microsoft Writing Style Guide](https://docs.microsoft.com/en-us/style-guide/bias-free-communication)
- [Guidelines for Inclusive Language - Linguistic Society of America](https://www.linguisticsociety.org/resource/guidelines-inclusive-language)

## Using linters

{This section is optional.}

This project uses the {your preferred linter.}

{Provide instructions or policies related to the linter here.}

## How the style guide is updated

{Indicate here how frequently your style guide is reviewed, who owns the style
guide, and how contributors can provide feedback on your style guide.}

## Revision history

{This section is optional or can be combined with the next section if needed.}

The following table describes the history of all decisions and revisions made to
this style guide over time. This guide uses the Major.Minor.Patch
[semantic versioning](https://semver.org/) convention.

Edition  |  Date          |  Lead Author(s)    |  Link to Repository Commit/Tag
-------  |  ----          |  --------------    |  -----------------------------
{0.1}    |  {YYYY-MM-DD}  |  {Your name here}  |  First draft of Style Guide


## Decision log

{This section is optional or can be combined with the previous section if
needed.}

The following table describes the history of all decisions made to this style
guide over time:

Ref  |  Date         |  Description                               |  Agreed to by
---  |  ----         |  -----------                               |  ------------
1    | {YYYY-MM-DD}  |  {Explain the decision that was made here} |  {Name or role}


---

> Explore other templates from [The Good Docs Project](https://thegooddocsproject.dev/). Use our [feedback form](https://thegooddocsproject.dev/feedback/?template=Style%20guide) to give feedback on this template.
