# Preparing a good issue

When [creating a new issue](https://github.com/nginx/documentation/issues/new/choose), following the templates will help you provide important details.

We strive to make each issue a single source of truth: as a result, each ticket should contain all of the context required for someone to understand a problem and subsequently be empowered to begin working on it.

This document exists to explain concepts you may be unfamiliar with, and provide examples of the types and amount of detail preferred.

## Use active voice

Much like writing user-facing documentation, we prefer [active voice](https://developers.google.com/tech-writing/one/active-voice) when describing an issue.

Unless an issue is exploratory in nature, it's best to directly state the impact caused by missing correct information.

Otherwise, the issue may give the wrong impression when undergoing triage, which will affect how it's prioritized.

## Design and time constraints

As part of identifying the scope of changes involved in a particular issue, the maintainer reviewing an issue will need to identify any important constraints.

Constraints tend to be precise and sensitive in nature, and are used to figure out how a ticket should be prioritized.

- If an issue involves changing a common noun, it may affect other work priorities
- If an issue is related to an upcoming release, it might need attention soon
- If an issue leaves users in an inoperable state, it requires intervention immediately

Clear constraints reduce or remove time that might otherwise be spent clarifying details around an issue.

## User stories and acceptance criteria

User stories are written in the following format:

**As a** \<user\>,  
**I want** \<thing\>,  
**So I** can \<action\>.

Write user stories from the user's perspective. Their goals may not match yours.

For each user story, think about which user persona it maps to. A persona represents a type of person with shared traits such as experience level, domain knowledge, or goals. 

A user story written for a DevOps persona will look different from one written for SecOps.

Use acceptance criteria to define what needs to be true for the story to be complete and the user’s need to be met.

Just like user stories, write acceptance criteria from the user's point of view. Focus on what they expect, not what you want to build.

Here is a good and bad example of acceptance criteria:

1. The user can find the information about configuring \<feature\>
2. Information about \<feature\> has been updated

The first example focuses on ensuring the work has meaningful impact to help a user.

The second example is simply a checklist item for managing work, without considering its effectiveness.