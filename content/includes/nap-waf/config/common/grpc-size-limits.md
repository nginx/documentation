---
nd-docs: "DOCS-1619"
---

The maximum total request size is applied to each message on its own, rather than to the total stream messages. By default, the maximum gRPC message size is 4MB.
You can configure different sizes in the declarative policy, like the 100K in the [Policy Example File](#policy-with-the-profile-example). If a message is sent with a size larger than that value, a `GRPC_FORMAT` violation is raised. If a message is sent with a size larger than 10MB, a `GRPC_MALFORMED` and `REQUEST_MAX_LENGTH` violation is raised.

There is no limit to the number of messages in a stream.