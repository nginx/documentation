---
nd-docs: DOCS-1498
---

When new attack signatures are introduced in an App Protect policy, the policy is tested in a staging environment first before being promoted to production. However, in some instances where it is challenging to replicate real traffic accurately in the staging environment, the detection of genuine attacks becomes difficult. There can be false positives and expose the application to attacks. For such cases, we need to deploy the new signatures in staging environment in “staging” mode.

The **Certification Time** policy property determines the point in time for which signatures have been tested, approved and certified.

The purpose of this feature is to put signatures in staging by their age (modification time).

There are two types of signatures:
1. **Staging Signatures** - All the signatures in the policy that were created or modified **after** the certification time are in staging.
2. **Enforced Signatures** – All the signatures in the policy that were created or modified **prior** to the certification date time or exactly at that time.