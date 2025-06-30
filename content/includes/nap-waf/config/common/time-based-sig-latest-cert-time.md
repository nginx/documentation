---
nd-docs: DOCS-1490
---

The latest signatures certification time is the timestamp (in date-time ISO format) as the time the signatures in the policy are considered as “trusted” by the user and separates enforced signatures from signatures in staging.

When this value is not defined and the staging flag is enabled, it means that all the signatures in the policy are in staging. If the signature was added to the policy but was created and last modified before the certification date-time then it will not be in staging.

A signature is considered new if it was introduced by a recent signature update that was applied to the respective policy. Note that signatures that were added later to the policy (by adding a new signature set) are not considered new unless they were added in the recent signature update. These signatures will not be in staging.