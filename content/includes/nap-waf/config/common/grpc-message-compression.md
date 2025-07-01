---
nd-docs: "DOCS-1574"
---

Currently, Message Compression is not supported. Therefore, a violation `VIOL_GRPC_MALFORMED` will be raised and the connection will be blocked if a compressed message is sent.