# Preparing a good issue

When [creating a new issue](https://github.com/nginx/documentation/issues/new/choose), many of the templates will guide you to providing important detail.

We strive to make each issue a single source of truth: as a result, each ticket should contain all of the context required for someone to understand a problem and subsequently be empowered to begin working on it.

This document exists to explain concepts you may be unfamiliar with, and provide examples of the types and amount of detail preferred.

## User stories and acceptance criteria

User stories are written in the following format:

**As a** \<user\>,  
**I want** \<thing\>,  
**So I** can \<action\>.

It's written from the perspective of a user, whose priorities are often different from your own.

The users for each story may map to specific user personas dependent on the required content design complexity.

A user persona reflects a broad set of demographic criteria, representing a type of person who may have different levels of experience, domain knowledge or priorities.

Acceptance criteria are used to determine whether or not the need identified as part of a user story is fulfilled.

Much like the user story, it is the user perspective that defines how acceptance criteria are written.

Here is a good and bad example of acceptance criteria:

1. The user can find the information about configuring \<feature\>
2. Information about \<feature\> has been updated

The first example focuses on ensuring the work has meaningful impact to help a user.

The second example is simply a checklist item for managing work, without considering its effectiveness.

## Design and time constraints

As part of identifying the scope of changes involved with a particular issue, the maintainer reviewing an issue will need to identify any important constraints.

Constraints tend to be precise and sensitive in nature, and are used to figure out how a ticket should be prioritized.

- If an issue involves changing a common noun, it may affect other work priorities
- If an issue is related to an upcoming release, it might need attention soon
- If an issue leaves users in an operable state, it requires intervention immediately

Clear constraints reduces or removes time that might otherwise be spent clarifying detail around an issue.