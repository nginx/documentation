---
docs: DOCS-647
---

gRPC is a remote API standard and is an alternative to OpenAPI. If your applications expose gRPC APIs, NGINX App Protect WAF can protect them by parsing the messages; making sure they comply with the API definition; and enforcing security restrictions - such as size limits, detecting attack signatures, threat campaigns, and suspicious metacharacters in message string field values.
In the following sections, you will learn how to configure gRPC protection in the policy using gRPC Content Profiles.