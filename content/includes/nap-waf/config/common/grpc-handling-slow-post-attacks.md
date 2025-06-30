---
nd-docs: "DOCS-1599"
---

Slow POST attack mitigation - A client sending messages very slowly for a long time may be cut off by resetting the connection.

In gRPC, a connection is considered "slow" if a message takes more than 10 seconds to process. In other words, the slow connection timer will be reset when a message ends and not when the whole request ends. This way, a limit is applied on the number of concurrent messages rather than the number of concurrent gRPC connections (streams), as many of them may be idle.

The number of slow connections is limited to 25. Once another connection becomes slow it is reset.