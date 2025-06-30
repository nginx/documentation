---
nd-docs: "DOCS-1606"
---

#### Client Request Flow

Bidirectional Enforcement is per message; each message is buffered and processed (doing all the inspection actions according to the policy: signatures, metacharacters, and other violations) on its own. The following section provides more details on receiving a client event:

- The request header and each of the messages in the client stream is enforced **separately**.
- The Enforcer issues a separate security log message per each message containing the violations found on it (if any). Refer to the [gRPC Violations](#grpc-violations) section for more details on gRPC violations. There is also a separate log message per request headers opening the stream.
- Then the Enforcer decides on the action that results from the violations just as it does for a regular HTTP request, but in gRPC it is done **per message** rather than the per whole stream. So if a message needs to be blocked, a blocking response is sent to the client and the stream is closed, but all the messages that preceded the blocked message have already been sent to the server.
- A special case is when the request headers message had blocking violations. In that case, the blocking response is sent right away, ignoring any messages the client may have sent afterward. The security log will just reflect the headers in this case. See more details in the [Sending Blocking Response in Bidirectional Streaming](#sending-blocking-response-in-bidirectional-streaming) section below.

#### Server Response Flow

gRPC server messages are not processed. All gRPC messages (unary or streaming) including the headers and trailer messages, are sent directly to the client (without sending them to the Enforcer).

#### Sending Blocking Response in Bidirectional Streaming

The blocking response comes as the **trailers** message is sent to the client on behalf of the server. At the same time, the server gets the `END_STREAM` frame to ensure streams on both sides are closed.