---
nd-docs: "DOCS-1637"
---

A Slow POST attack or Slow HTTP POST attack is a type of denial of service attack. The attacker sends a legitimate HTTP POST request with the header Content-Length specified. The attacker then proceeds to send this content slowly. The server establishes a connection to the client and keeps it open to receive the request that it thinks is legitimate.

The attacker sends several such requests and effectively occupies the server’s entire connection pool. As a result, it blocks the service for other legitimate users and results in a denial of service.