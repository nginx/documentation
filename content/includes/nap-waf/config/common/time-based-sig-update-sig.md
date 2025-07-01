---
nd-docs: DOCS-1492
---

After applying a signature update (F5 or user-defined), and assuming the update creation time is later than the previous signature update applied to the policy (in other words, the signatures are upgraded, not downgraded), then all the signatures that were affected by the update (created or modified) are automatically put in staging. That's because their modification time is newer than the current `stagingCertificationDatetime`. Signatures that were not affected by the update will **not** be in staging.