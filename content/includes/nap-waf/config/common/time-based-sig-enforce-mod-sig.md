---
nd-docs: DOCS-1495
---

All signatures are considered to be in staging if their creation or modification time is later than the `stagingCertificationDatetime`.

A signature in staging will be reported in the security log but will not cause the request to be blocked and will not raise the Violation Rating (threat score). The potential Violation Rating in case all the detected signatures were not in staging will also be reported.

After you review the logs and can be assured that the new and modified signatures that were in staging are behaving correctly and do not cause false positives, you should enforce them. To do so, change the `stagingCertificationDatetime` to the time stamp of the latest signature update. This moves all the signatures out of staging. When installing a new signature update in the future, all the new and modified signatures in that update will be automatically placed in staging.

Note that we do not recommend setting the `stagingCertificationDatetime` to the current time, the time you finished reviewing the signatures. That's because the future signature update might have been created before that time, and when you install that update, modified signatures in it will not be in staging because they will be older than the `stagingCertificationDatetime`.