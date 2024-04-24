
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
case insensitive | Use "not case-sensitive" instead of "case insensitive". | |
caution/warning	| Caution is less severe than Warning. Use Caution when alerting that damage may occur, such as down time or service interruption. Use Warning as the severest form of advisory, such as the risk of data loss or sustained outage.| |
certificate authority (CA) | | |
certificate request | | |
certificate signing request (CSR) | |
certificate/key pair | | 
check (verb) | Do not use when referring to a check box action. Use select. Options for check as a verb: verify, confirm, test, ensure, and so on.| |
check box (noun, GUI) | Use "select" when referring to a check box action.<br>In this example, you could document as either: "For the Protocol Security (DNS) setting, select the Enabled check box." – OR – "For the Application Security setting, select Enabled." | |
checksum | |
click vs select	| Use "select". | Refer to the [Microsoft Style Guide instructions for Describing Interactions with UI](https://learn.microsoft.com/en-us/style-guide/procedures-instructions/describing-interactions-with-ui) for more information. |
client certificate authentication | |
Client SSL | |
client-side or client side | Hyphenate when used as adjective. | |
colloquial language	| Try to avoid using colloquial language, which does not translate well. For example, use "press Esc", not "hit Esc"; "Go to the next section", not "jump to the next section". | |
colon | Never use a colon to introduce a graphic, a figure, or a table. | |
comma (serial or Oxford) | **Always use the serial (Oxford) comma.**<br><br>Example: "apples, oranges, and bananas"; not "apples, oranges and bananas".| |
comma-separated | Always hyphenate. For example: a comma-separated values (CSV) file | |
command line and command prompt (usage)	| Use "command line".<br><br>NOUN: …at the command line.<br>ADJ: …using command-line tools.<br>At the command prompt, type...<br>Do not use command-line prompt.| |
configure | Do not use except when describing the configuration of an NGINX product, such as when installing NGINX or NGINX Agent.<br>In most cases, use "set up" instead.| |
contractions | Contractions are okay to use as long as they're not ambiguous. | |
Cookie persistence (option type) | |
cookie/cookies (noun) | |
covers | As in, "this section/topic/chapter covers the following...". Instead, use a phrase such as, "This topic deals with..." or "This topic provides the following information...". More options: communicates, presents, offers, introduces, explains, describes. | |
curly brackets `{}` | The name for the curved `{}` parenthetical markings is "braces". They are not called curly brackets. | |
CVSS v3.0 | Do not spell out. (Articles with CVSS metrics should include the CVSS link.) | |
daemon | Avoid using this term in generic documentation because it is UNIX-oriented. Instead, we use "agent", "utility", or "application". However, we do refer to specific UNIX daemons, like `named` and `sod`, when daemon is part of the name. | |
data center | Write this as two words. | |
em dash | Allowed in the proper context. May be written using two dashes to ensure it converts correctly when displayed in the web version. | |
data source | |
database | Do not abbreviate as "db". Always a single word. | |
DoS/DDoS/3DoS | Spell out on first reference:<br>- denial-of-service (DoS)<br>- distributed denial-of-service (DDoS)<br>- diverse distributed denial-of-service (3DoS) <insert nick-shadrin-facepalm emoji here> | |
e.g., i.e., etc.| Avoid using Latin abbreviations.<br>- e.g. = for example<br>- i.e. = in other words<br>- etc. = and so on | |
earlier and later | Use to describe versioning. For example, "This applies to versions earlier than NGINX Plus R31".<br>Do not use before, after, greater, lower, higher, below, above, and so on. | | 
either/or | Not recommended.<br>Usually, we mean either, or we mean or. Try to be specific in your writing; people are counting on you for specific instructions. It's okay to use these terms when separated by text, as in, "You can use either the semi-colon or the comma here".| |
ellipses […] | Don’t use ellipses (dots) in your tech writing.<br>When referring to a menu command that has an ellipse, DO NOT include the ellipse.<br>It’s okay to use the word "ellipses" in text. | |
enable | Always use direct, active verbs.<br>It’s okay to instruct the user to enable a setting. Do not use in the context of a system or product enabling the user to do something.| |



the disabled<br> disabled people<br> people with handicaps<br> the handicapped | people with disabilities  |  Use inclusive and bias-free language. See [Accessible Writing](#accessible-writing)
that is         |  i.e.              |  Avoid non-English words
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
